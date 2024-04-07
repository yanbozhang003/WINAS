INCLUDE_DIR=$(TOOLCHAIN_DIR)/usr/include

CC=mips-openwrt-linux-gcc

CFLAGS= -std=gnu99

OBJS = csi_func.o client_main.o

sendINET: $(OBJS)
	$(CC) $(OBJS) -o client_main

csi_func.o: csi_func.c csi_func.h
	$(CC) -c $(CFLAGS) -I $(INCLUDE_DIR) -o $@ $<

client_main.o: client_main.c csi_func.h
	$(CC) -c $(CFLAGS) -I $(INCLUDE_DIR) -o $@ $<

clean: 
	rm -f *.o client_main
#all: client_main
#client_main: client_main.o
#client_main.o: client_main.c
