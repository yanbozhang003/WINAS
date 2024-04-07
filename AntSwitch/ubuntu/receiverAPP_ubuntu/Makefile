#INCLUDE_DIR=$(TOOLCHAIN_DIR)/usr/include

#CC=mips-openwrt-linux-gcc

#CFLAGS= -std=gnu99

OBJS = csi_func.o client_main.o
CC=gcc

receiverAPP: $(OBJS)
	$(CC) $(OBJS) -o receiverAPP

csi_func.o: csi_func.c csi_func.h
	$(CC) -c csi_func.c -o csi_func.o

client_main.o: client_main.c csi_func.h
	$(CC) -c client_main.c -o client_main.o

clean: 
	rm -f *.o client_main
#all: client_main
#client_main: client_main.o
#client_main.o: client_main.c
