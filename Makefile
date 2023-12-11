CC ?= gcc
LINKER ?= ld

PREP_DIR= ./preprocess
OBJ_DIR= ./object
ASM_DIR= ./assembly
BIN_DIR := ./binary

TARGET := final.out

help:
	@echo "Print help:"
	@echo "make clean > delete artifacts"
	@echo "make all > do all at once"
	@echo "make preprocess > Run preprocessor step on source files"
	@echo "make compile > Compiles .i to assembly files"
	@echo "make assemble > Assembles .s files to object files"
	@echo "make link > Links object files to binary for execution"

all: preprocess compile assemble link

preprocess: main.c add.c
	@echo preprocess step
	@mkdir $(PREP_DIR)
	$(CC) -E main.c > $(PREP_DIR)/main.i
	$(CC) -E add.c > $(PREP_DIR)/add.i

compile: $(wildcard *.i)
	@echo compile step
	@mkdir $(ASM_DIR)
	$(CC) -S $(PREP_DIR)/main.i -o $(ASM_DIR)/main.s
	$(CC) -S $(PREP_DIR)/add.i -o $(ASM_DIR)/add.s

assemble:
	@echo assembly step
	@mkdir $(OBJ_DIR)
	$(CC) -c $(ASM_DIR)/main.s -o $(OBJ_DIR)/main.o
	$(CC) -c $(ASM_DIR)/add.s -o $(OBJ_DIR)/add.o

link:
	@echo link step
	@mkdir $(BIN_DIR)
	$(LINKER) -o $(BIN_DIR)/$(TARGET) \
		/usr/lib/x86_64-linux-gnu/crti.o \
		/usr/lib/x86_64-linux-gnu/crtn.o \
		/usr/lib/x86_64-linux-gnu/crt1.o \
		-lc $(OBJ_DIR)/main.o $(OBJ_DIR)/add.o \
		-dynamic-linker /lib64/ld-linux-x86-64.so.2

.PHONY: clean
clean:
	rm -r $(PREP_DIR)
	rm -r $(OBJ_DIR)
	rm -r $(ASM_DIR)
	rm -r $(BIN_DIR)
