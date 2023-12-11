CC ?= gcc
LINKER ?= ld

SRC_F = $(shell find -name '*.c')

PREP_DIR= ./preprocess
PREP_F = $(SRC_F:%=$(BUILD_DIR)/%.i)

OBJ_DIR= ./object
OBJ_F = $(PREP_F:%=$(BUILD_DIR)/%.o)

ASM_DIR= ./assembly
ASM_F = $(OBJ_F:%=$(BUILD_DIR)/%.s)

BIN_DIR := ./binary

TARGET := final.out

help:
	@echo Print help:
	@echo make all > Do every step
	@echo make preprocess > Preprocess all .c files
	@echo make compile > Compile preprocessed .i files to object files
	@echo make assemble > Assemble object files
	@echo make link > Link to get binary
	@echo make clean > get rid of artifacts

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
