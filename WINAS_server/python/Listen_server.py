#!/usr/bin/env python3
# server
import socket
import matlab.engine
import time
import numpy as np
import re
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

 
HOST = ''    # Symbolic name meaning all available interfaces
PORT = 8877 # Arbitrary non-privileged port
 
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
print('Listening for connections at port:', PORT)
 
cnt = 0
while(1):
    eng = matlab.engine.start_matlab()
    s.listen(1)
    #print(s.accept())
    conn, addr = s.accept()
    print('Connected by', addr)
    start = time.time()
    
 
    tst = open('text','wb')
    print('Receiving file opened')
    cnt = cnt + 1
    while 1:
        data = conn.recv(4096)
        if data:
            raw_data = repr(data)[2:-1]
            
            tst.write(data)
            print('Receiving data')
            
        else:
            tst.close()
            break

    print('Analysing file, please wait....')
    ret= eng.read_log_file('text')
    
    with open('results.txt','w') as filehandle:
        print('File analysed')
        for listitem in ret:
                filehandle.write("%s\n" % listitem)
                filehandle.write('%s\n')
                
                np_x = np.array(listitem).reshape(listitem.size, order='F')
                print (type(listitem))
                #print (np_x)
                phase = np.angle(np_x)
                amp = np.absolute(np_x)
                #print ('Phase:' ,phase)

                for i in range(len(phase)):
                    print ('Phase:' ,phase[i])
                    fig = plt.figure()
                    plt.plot(phase[i].transpose())
                    plt.title('Phase')
                    plt.ylabel('Phase')
                    plt.xlabel('Subcarriers')
                    #plt.show()
                    fig.savefig("/Users/vick/Desktop/FYP/Code_Working/Phase"+str(i)+".png", format="png")

                for i in range(len(amp)):
                    print('Amplitude:' ,amp[i])
                    fig = plt.figure()
                    plt.plot(amp[i].transpose())
                    plt.title('Amplitude')
                    plt.ylabel('Amplitude')
                    plt.xlabel('Subcarriers')
                    fig.savefig("/Users/vick/Desktop/FYP/Code_Working/Amplitude"+str(i)+".png", format="png")
                
                
                print('Writing analysed data to results file')
                end = time.time()
                print("Time elapsed", end-start, 's')

    print(ret)
    #print(ret)
    eng.quit()
    conn.close()
