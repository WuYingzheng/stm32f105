OPENOCD_PIDFILE = /tmp/openocd_opensky.pid


# put your *.o targets here, make should handle the rest!
SRCS = main.c system_stm32f10x.c

# all the files will be generated with this name (main.elf, main.bin, main.hex, etc)
PROJ_NAME=main

# Location of the Libraries folder from the STM32F0xx Standard Peripheral Library
STD_PERIPH_LIB=stm32_lib

# Location of the linker scripts
LDSCRIPT_INC=ldconfig

# location of OpenOCD Board .cfg files (only used with 'make program')
OPENOCD_BOARD_DIR=/usr/share/openocd/scripts/board

# Configuration (cfg) file containing programming directives for OpenOCD
OPENOCD_PROC_FILE=extra/stm32f0-openocd.cfg

# that's it, no need to change anything below this line!

###################################################

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
OBJDUMP=arm-none-eabi-objdump
SIZE=arm-none-eabi-size

CFLAGS  = -Wall -g -std=c99   
#CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m3 -march=armv6s-m
CFLAGS += -mlittle-endian -mcpu=cortex-m3 -mthumb
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -Wl,--gc-sections -Wl,-Map=$(PROJ_NAME).map

###################################################

vpath %.c user
vpath %.a $(STD_PERIPH_LIB)

ROOT=$(shell pwd)

CFLAGS += -I inc -I $(STD_PERIPH_LIB) -I $(STD_PERIPH_LIB)/CMSIS/device/STM32F10x/Include
CFLAGS += -I $(STD_PERIPH_LIB)/CMSIS/Include -I $(STD_PERIPH_LIB)/STM32F10x_StdPeriph_Driver/inc
CFLAGS += -include $(STD_PERIPH_LIB)/stm32f10x_conf.h

SRCS += /home/wyz/stm-32/project/hello/stm32_lib/CMSIS/device/STM32F10x/Source/Templates/gcc_ride7/startup_stm32f10x_cl.s
# add startup file to build

# need if you want to build with -DUSE_CMSIS 
#SRCS += stm32f0_discovery.c
#SRCS += stm32f0_discovery.c stm32f0xx_it.c

OBJS = $(SRCS:.c=.o)

###################################################

.PHONY: lib proj

all: lib proj

lib:
	$(MAKE) -C $(STD_PERIPH_LIB)

proj: 	$(PROJ_NAME).elf

$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@ -L$(STD_PERIPH_LIB) -lstm32f1 -L$(LDSCRIPT_INC) -Tlinker.ld
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin
	$(OBJDUMP) -St $(PROJ_NAME).elf >$(PROJ_NAME).lst
	$(SIZE) $(PROJ_NAME).elf
	
program: $(PROJ_NAME).bin
	openocd -f $(OPENOCD_BOARD_DIR)/stm32f0discovery.cfg -f $(OPENOCD_PROC_FILE) -c "stm_flash `pwd`/$(PROJ_NAME).bin" -c shutdown


debug: $(PROJ_NAME).elf
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2.cfg -f /usr/share/openocd/scripts/target/stm32f1x.cfg & echo $$! > $(OPENOCD_PIDFILE)
	sleep 1
	arm-none-eabi-gdb --eval-command="target remote localhost:3333" $(RESULT).elf
	if [ -a $(OPENOCD_PIDFILE) ]; then kill `cat $(OPENOCD_PIDFILE)`; fi;

flash : $(PROJ_NAME).bin
	#if [ -a $(OPENOCD_PIDFILE) ]; then kill `cat $(OPENOCD_PIDFILE)`; fi;
	#st-flash write $(RESULT).bin 0x8000000
	st-flash write $(PROJ_NAME).bin 0x8000000

clean:
	find ./ -name '*~' | xargs rm -f	
	rm -f *.o
	rm -f $(PROJ_NAME).elf
	rm -f $(PROJ_NAME).hex
	rm -f $(PROJ_NAME).bin
	rm -f $(PROJ_NAME).map
	rm -f $(PROJ_NAME).lst

reallyclean: clean
	$(MAKE) -C $(STD_PERIPH_LIB) clean
