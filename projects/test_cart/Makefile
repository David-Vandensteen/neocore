#les premiers chiffres correspondent au numéro du jeu (Le "NGH Number"), la lettre indique le type de données:

#Les P contiennent le programme pour le 68K (souvent qu'un seul).
#Les C contiennent les données graphiques pour les sprites.
#Le S1 contient les données graphiques pour le fix (qu'un seul de 128ko).
#Les V contiennent les samples et les tables pour les musiques.
#Le M1 contient le programme pour le Z80 (qu'un seul de 128ko).



#049-c1.bin
#049-c2.bin

####################
#	Project settings #
####################

PROJECTNAME = $(PROJECT)

NEOBUILDTEMP = $(shell cygpath -u $(TEMP))/neocore/$(PROJECTNAME)

FILECUE = $(PROJECTNAME).cue
FILEISO = $(shell cygpath -u $(NEOBUILDTEMP)\$(PROJECTNAME).iso)
FILEZIP = $(shell cygpath -u $(NEOBUILDTEMP)\$(PROJECTNAME).zip)
ISONAME = $(PROJECTNAME).iso

###################
#	Global settings #
###################Ò

FILEPRG = $(NEOBUILDTEMP)/$(PROJECTNAME).prg
FILESPRITE = $(NEOBUILDTEMP)/SPR
NEOBUILDDATA = $(shell cygpath -u $(APPDATA))/neocore
RAINE = $(NEOBUILDDATA)/raine/raine32.exe
CDTEMPLATE = $(NEOBUILDDATA)/cd_template

#######
#	CMD #
#######
MKDIR = $(shell cygpath -w $(NEOBUILDDATA))\bin\mkdir.exe
CP = $(shell cygpath -w $(NEOBUILDDATA))\bin\cp.exe
RM = $(shell cygpath -w $(NEOBUILDDATA))\bin\rm.exe
ZIP = $(shell cygpath -w $(NEOBUILDDATA))\bin\zip.exe
MKISOFS = $(shell cygpath -w $(NEOBUILDDATA))\bin\mkisofs.exe

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
#OUTPUT = cd
OUTPUT = cart

############################
# Settings for cart output #
############################
ROMSIZE = 0x20000
PADBYTE = 0xFF

##############################
# Object Files and Libraries #
##############################
SRC_C= $(wildcard *.c)

OBJS = $(NEOBUILDTEMP)/crt0_$(OUTPUT).o

ifneq ("$(wildcard chardata.xml)","")
	OBJS := $(OBJS) $(NEOBUILDTEMP)/palettes.o
	OBJS := $(OBJS) $(NEOBUILDTEMP)/maps.o
endif

OBJS += $(patsubst %.c,$(NEOBUILDTEMP)/%.o,$(wildcard *.c))

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
all: init $(FILESPRITE).cd $(FILEPRG)
$(FILEPRG) : $(NEOBUILDTEMP)/$(PROJECTNAME).o
	$(OBJC) -O binary $< $@

$(NEOBUILDTEMP)/$(PROJECTNAME).o : $(OBJS)

	$(LD) -L$(LIBDIR) $(CCFLAGS) $(LDFLAGS) $(OBJS) $(LIBS) -o $@

$(NEOBUILDTEMP)/%.o: %.c
	$(CC) -I$(INCDIR) $(CCFLAGS) -c $< -o $@

$(NEOBUILDTEMP)/%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

init:
	$(MKDIR) -p $(NEOBUILDTEMP)

sprite: $(FILESPRITE).cd

dbg:
	echo $(OBJC)
	echo $(OBJS)

$(FILESPRITE).cd:
	if exist chardata.xml BuildChar.exe "chardata.xml"
	if exist char.bin CharSplit.exe char.bin -cd $(shell cygpath -w $(FILESPRITE))
	$(RM) -f char.bin

run: zip
# todo (minor) - raine parametric position
	powershell -ExecutionPolicy Bypass -File ..\..\scripts\raine-start.ps1 $(shell cygpath -w $(RAINE)) $(shell cygpath -w $(FILEZIP))

zip: $(FILEPRG) iso
	$(ZIP) -j $(shell cygpath -u $(FILEZIP)) $(NEOBUILDTEMP)/iso/*

iso: $(FILEPRG)
	echo Try to kill raine32.exe process...
	powershell "try { taskkill /IM raine32.exe /f } catch { }; exit 0"

	$(RM) -rf $(NEOBUILDTEMP)/iso
	$(MKDIR) -p $(NEOBUILDTEMP)/iso
	$(CP) -f $(CDTEMPLATE)/* $(NEOBUILDTEMP)/iso
	$(CP) -f $(FILEPRG) $(NEOBUILDTEMP)/iso/DEMO.PRG
ifneq ("$(wildcard $(FILESPRITE).cd)","")
	$(CP) -f $(FILESPRITE).cd $(NEOBUILDTEMP)/iso/DEMO.SPR
endif
	$(MKISOFS) -o $(FILEISO) -pad $(NEOBUILDTEMP)/iso

add-cue:
	echo CATALOG 0000000000000 > $(FILECUE)
	echo FILE "$(ISONAME)" BINARY >> $(FILECUE)
	echo TRACK 01 MODE1/2048 >> $(FILECUE)
	echo INDEX 01 00:00:00 >> $(FILECUE)
	echo FILE "$(ISONAME)" WAVE >> $(FILECUE)
	echo TRACK 02 AUDIO >> $(FILECUE)
	echo PREGAP 00:00:59 >> $(FILECUE)
	echo INDEX 01 00:00:00 >> $(FILECUE)

clean:
	echo Try to kill raine32.exe process...
	powershell "try { taskkill /IM raine32.exe /f } catch { }; exit 0"

	$(RM) -rf $(NEOBUILDTEMP)/*
	$(RM) -rf $(NEOBUILDTEMP)
	$(RM) -f palettes.s
	$(RM) -f maps.s
	$(RM) -f externs.h

serve:
	powershell -ExecutionPolicy Bypass -File ..\..\scripts\neocore-hot-reload.ps1 .

dist:
