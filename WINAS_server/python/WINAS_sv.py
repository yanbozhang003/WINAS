import socket
import struct
import threading
import bitstruct
import numpy as np
import pprint
import math

# global variables
port = 3333
sock_buffer = []
csi_struct = []

class csi_info(threading.Thread):
    def __init__(self, raw_csi, queue):
        threading.Thread.__init__(self)
        self.raw = raw_csi
        self.queue = queue

    def run(self):
        self.parse_header()
        #print("MAC: ", self.csi['MAC_idx'])
        
    def append_queue(self):
        self.queue.append(self.csi)

    def parse_header(self):
        print("packet len:", len(self.raw))
        val = struct.unpack('!QHHBBBBBBBBBBBH', self.raw[0:25])
        print(val)
        if val[1] == 420:
            self.csi = {'timestamp': val[0],
                        'csi_len': val[1],
                        'channel': val[2],
                        'phyerr': val[3],
                        'noise': val[4],
                        'rate': val[5],
                        'chnBW': val[6],
                        'num_tones': val[7],
                        'nr': val[8],
                        'nc': val[9],
                        'rssi': val[10],
                        'rssi_0': val[11],
                        'rssi_1': val[12],
                        'rssi_2': val[13],
                        'payloadlen': val[14]}
            idx = 23 + val[1]
            #print('idx:', idx, idx+70, idx+72, idx+16, idx+18)
            self.csi['buflen'] = struct.unpack('!H', self.raw[-2:])[0]
            #self.csi['pkt_idx'] = struct.unpack('!H', self.raw[(idx+70):(idx+72)])[0]
            self.csi['MAC_idx'] = struct.unpack('!H', self.raw[(idx+16):(idx+18)])[0]
            self.rssi_vec = [self.csi['rssi_0'], self.csi['rssi_1'], self.csi['rssi_2']]
            self.csi['csi'] = self.extract_csi(self.csi['num_tones'],
                                            self.csi['nc'],
                                            self.csi['nr'],
                                            self.raw[25:25+self.csi['csi_len']])
            self.append_queue()
        
    def signbit_convert(self, val, maxbit=10):
        if (val & (1<<(maxbit-1))) != 0:
            val -= (1<<maxbit)
        return val
    
    def extract_csi(self, num_tones, nc, nr, raw_csi):
        csi = []
        data = bitstruct.unpack('u10'*(num_tones * nc * nr * 2), raw_csi)
        data = [struct.unpack('!h', struct.pack('!H', x<<6))[0]>>6 for x in data]
        dataI = np.array([self.signbit_convert(x) for x in data[::2]])
        dataR = np.array([self.signbit_convert(x) for x in data[1::2]])
        data = dataI + 1j*dataR
        AntEng = [abs(x) for x in data]
        scale_factor = [0.0]*len(AntEng)
        for i in range(0, nr):
            for j in range(0, nc):
                k = ((j * nr) + i)
                AntEng[k] = AntEng[k] / num_tones
                scale_factor[k] = math.pow(10, self.csi['rssi'] / 20) / AntEng[k]
                for l in range(0, num_tones):
                    m = (l * nr * nc) + k
                    data[m] = data[m] * scale_factor[k]
        for i in range(0, nr):
            AntEng[i] = AntEng[i] / (nc * num_tones)
            scale_factor[i] = math.pow(10, self.csi['rssi'] / 20) / AntEng[i]
            for j in range(0, num_tones):
                for k in range(0, nc):
                    l = (j * nr * nc) + (k * nr) + i
                    data[l] = data[l] * scale_factor[i]
##        for i in range(0, nc):
##            temp = []
##            for j in range(0, nr):
##                temp.append(data[num_tones * (j + (i * nr)): num_tones * (j + 1 + (i * nr))])
##                AntEng = sum([abs(x) for x in temp[j]]) / num_tones
##                scale_factor = np.power(10, (self.csi['rssi']/20.0)) / AntEng
##                temp[j] = [x * scale_factor for x in temp[j]]
##            # nr nomalization with respective rssi value
##            #AntEng = (sum([abs(x) for x in csi]) / num_tones) / (nc * num_tones)
##            AntEng[i] = AntEng[i] / (nc * num_tones)
##            scale_factor = np.power(10, (self.rssi_vec[i] / 20.0)) / AntEng
##            for j in range(0, nr):
##                temp[j] = [x * scale_factor for x in temp[j]]
##            ## end
##            csi.append(temp)
        for i in range(0, nc):
            csi.append([])
            for j in range(0, nr):
                csi[i].append([])
                for k in range(0, len(data), num_tones):
                    csi[i][j].append(data[k:k+num_tones])
        csi = np.array(csi)
        return csi

    def __str__(self):
        csi_str  = 'timestamp: ' + str(self.csi['timestamp']) + '\n'
        csi_str += 'csi_len: ' + str(self.csi['csi_len']) + '\n'
        csi_str += 'channel: ' + str(self.csi['channel']) + '\n'
        csi_str += 'phyerr: ' + str(self.csi['phyerr']) + '\n'
        csi_str += 'noise: ' + str(self.csi['noise']) + '\n'
        csi_str += 'rate: ' + str(self.csi['rate']) + '\n'
        csi_str += 'chnBW: ' + str(self.csi['chnBW']) + '\n'
        csi_str += 'num_tones: ' + str(self.csi['num_tones']) + '\n'
        csi_str += 'nr: ' + str(self.csi['nr']) + '\n'
        csi_str += 'nc: ' + str(self.csi['nc']) + '\n'
        csi_str += 'rssi: ' + str(self.csi['rssi']) + '\n'
        csi_str += 'rssi_0: ' + str(self.csi['rssi_0']) + '\n'
        csi_str += 'rssi_1: ' + str(self.csi['rssi_1']) + '\n'
        csi_str += 'rssi_2: ' + str(self.csi['rssi_2']) + '\n'
        csi_str += 'payloadlen: ' + str(self.csi['payloadlen']) + '\n'
        csi_str += 'buflen: ' + str(self.csi['buflen']) + '\n'
        #csi_str += 'pkt_idx: ' + str(self.csi['pkt_idx']) + '\n'
        csi_str += 'MAC_idx: ' + str(self.csi['MAC_idx']) + '\n'
        csi_str += 'csi: ' + str(self.csi['csi']) + '\n'
        return csi_str

    def __repr__(self):
        return self.__str__()

class Thread_A(threading.Thread):
    def __init__(self, name):
        threading.Thread.__init__(self)
        self.name = name

    def run(self):
        global sock_buffer
        global csi_struct
        while True:
            data = conn.recv(4096)
            print(len(data))
            # for b in data:
            #     print(' {:02x}'.format(b), end='')
            # print('\n')
            # t = csi_info(data,csi_struct)
            # t.start()
            # print(csi_struct)
            # t.join()


# main start here
s = socket.socket()
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
print("Socket successfully created")

s.bind(('', port))
print("socket binded to %s" %(port) )

s.listen(5)
print("socket is listening")

conn, addr = s.accept()
print('Got connection from', addr)

# create threads
a = Thread_A("sock_recv")

a.start()

a.join()