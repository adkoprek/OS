## Define the compiler and linker
CC=x86_64-elf-gcc
OBJCP=x86_64-elf-objcopy
LD=x86_64-elf-ld
FLAGS=-ffreestanding -m64 -g

SRC=$(shell pwd)
BIN=./bins

CSRC := $(shell find ./ -name "*.c")
CTAR := $(patsubst %.c,%.o,$(CSRC))

all: prebuild boot

prebuild:
	rm -rf $(BIN)
	mkdir $(BIN)

boot: $(ASMTAR) $(CTAR)
	echo $(CTAR)

%.o: %.c
	mkdir -p $(BIN)/$(shell dirname $<)
	$(CC) $(FLAGS) -c $< -o $(BIN)/$(subst .c,.o,$<) $(addprefix -I ,$(shell dirname $(shell echo $(CSRC) | tr ' ' '\n' | sort -u | xargs)))

%.o : %.asm
	mkdir -p $(BIN)/$(shell dirname $<)
	nasm $< -f elf64 -o $(BIN)/$(subst .asm,.o,$<) $(addprefix -i ,$(shell dirname $(shell echo $(CSRC) | tr ' ' '\n' | sort -u | xargs)))
