#	settings #

PROJECTNAME = $(PROJECT)
NEOBUILDTEMP = $(PATHBUILD)

AS = $(GCC_PATH)/as
LD = $(GCC_PATH)/gcc
CC = $(GCC_PATH)/gcc
AR = $(GCC_PATH)/ar
OBJC = $(GCC_PATH)/objcopy
BIN2O = $(GCC_PATH)/bin2elf
GFXCC = $(GCC_PATH)/gfxcc
FIXCNV = $(GCC_PATH)/m68k/bin/fixcnv

TMPDIR = $(TEMP)

# Output: {cart, cd} *lower case* #

OUTPUT = cd

# Settings for cart output #

ROMSIZE = 0x20000
PADBYTE = 0xFF

# Object Files and Libraries #

SRC_C := $(shell find -name '*.c' | tr "\n" " ")

OBJS = $(NEOBUILDTEMP)/crt0_$(OUTPUT).o
OBJS := $(OBJS) $(NEOBUILDTEMP)/palettes.o
OBJS := $(OBJS) $(NEOBUILDTEMP)/maps.o
OBJS += $(patsubst %.c,$(NEOBUILDTEMP)/%.o,$(SRC_C))

LIBS = -lneocore -lDATlib -lmath -lprocess -lc -lgcc

# Compilation Flags #

ASFLAGS = -m68000 --register-prefix-optional
LDFLAGS = -Wl,-T$(NEO_GEO_SYSTEM) -Xlinker -Map=$(NEOBUILDTEMP)/output.map
CCFLAGS = -m68000 -O3 -Wall -fomit-frame-pointer -ffast-math -fno-builtin -nostartfiles -nodefaultlibs -D__$(OUTPUT)__
ARFLAGS = cr
DEBUG = -g

# FIX Definition #

FIXFILES = $(BASEDIR)/src/shared/fix_font.bmp

# Make rules #

all: $(FILEPRG)

$(FILEPRG): $(NEOBUILDTEMP)/$(PROJECTNAME).o
	$(OBJC) -O binary $< $@

$(NEOBUILDTEMP)/$(PROJECTNAME).o: $(OBJS)
	$(LD) -L$(LIBRARY_PATH) $(CCFLAGS) $(LDFLAGS) $(OBJS) $(LIBS) -o $@

$(NEOBUILDTEMP)/%.o: %.c
	$(CC) -I$(INCLUDE_PATH) -I$(PROJECT_PATH) $(CCFLAGS) -c $< -o $@

$(NEOBUILDTEMP)/%.o: */%.c
	$(CC) -I$(INCLUDE_PATH) -I$(PROJECT_PATH) $(CCFLAGS) -c $< -o $@

$(NEOBUILDTEMP)/%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

debug:
	@echo DEBUG
	@echo PROJECT : $(PROJECTNAME)
	@echo BASEDIR : $(BASEDIR)
	@echo NEOBUILDTEMP : $(NEOBUILDTEMP)
	@echo FILEPRG : $(FILEPRG)