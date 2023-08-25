####################
#	Project settings #
####################
PROJECTNAME = $(PROJECT)
NEOBUILDTEMP = $(PATHBUILD)

#######################################
# Base dir of your m68k gcc toolchain #
#######################################

BASEDIR = $(NEODEV)
AS = $(BASEDIR)/m68k/bin/as
LD = $(BASEDIR)/m68k/bin/gcc
CC = $(BASEDIR)/m68k/bin/gcc
AR = $(BASEDIR)/m68k/bin/ar
OBJC = $(BASEDIR)/m68k/bin/objcopy
BIN2O = $(BASEDIR)/m68k/bin/bin2elf
GFXCC = $(BASEDIR)/m68k/bin/gfxcc
FIXCNV = $(BASEDIR)/m68k/bin/fixcnv

#######################################
# Path to libraries and include files #
#######################################

INCDIR = $(BASEDIR)/m68k/include
LIBDIR = $(BASEDIR)/m68k/lib
TMPDIR = $(TEMP)

###################################
# Output: {cart, cd} *lower case* #
###################################
OUTPUT = cd

############################
# Settings for cart output #
############################
ROMSIZE = 0x20000
PADBYTE = 0xFF

##############################
# Object Files and Libraries #
##############################
SRC_C := $(wildcard *.c) $(wildcard */*.c)

OBJS = $(NEOBUILDTEMP)/crt0_$(OUTPUT).o
OBJS := $(OBJS) $(NEOBUILDTEMP)/palettes.o
OBJS := $(OBJS) $(NEOBUILDTEMP)/maps.o
OBJS += $(patsubst %.c,$(NEOBUILDTEMP)/%.o,$(SRC_C))

LIBS = -lneocore -lDATlib -lmath -lprocess -lc -lgcc

#####################
# Compilation Flags #
#####################

ASFLAGS = -m68000 --register-prefix-optional
LDFLAGS = -Wl,-T$(BASEDIR)/src/system/neo$(OUTPUT).x -Xlinker -Map=$(NEOBUILDTEMP)/output.map
CCFLAGS = -m68000 -O3 -Wall -fomit-frame-pointer -ffast-math -fno-builtin -nostartfiles -nodefaultlibs -D__$(OUTPUT)__
ARFLAGS = cr
DEBUG = -g

##################
# FIX Definition #
##################
FIXFILES = $(BASEDIR)/src/shared/fix_font.bmp

##############
# Make rules #
##############
all: $(FILEPRG)

$(FILEPRG): $(NEOBUILDTEMP)/$(PROJECTNAME).o
	$(OBJC) -O binary $< $@

$(NEOBUILDTEMP)/$(PROJECTNAME).o: $(OBJS)
	$(LD) -L$(LIBDIR) $(CCFLAGS) $(LDFLAGS) $(OBJS) $(LIBS) -o $@

$(NEOBUILDTEMP)/%.o: %.c
	$(CC) -I$(INCDIR) $(CCFLAGS) -c $< -o $@

$(NEOBUILDTEMP)/%.o: */%.c
	$(CC) -I$(INCDIR) $(CCFLAGS) -c $< -o $@

$(NEOBUILDTEMP)/%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

debug:
	@echo DEBUG
	@echo PROJECT : $(PROJECTNAME)
	@echo BASEDIR : $(BASEDIR)
	@echo NEOBUILDTEMP : $(NEOBUILDTEMP)
	@echo FILEPRG : $(FILEPRG)
