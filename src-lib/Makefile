INC = $(NEODEV)\m68k\include
LIB = $(NEODEV)\m68k\lib

# TODO : parametric NEOBUILDATA
#NEOBUILDDATA = $(APPDATA)\neocore
NEOBUILDDATA = ..\build

RM = $(NEOBUILDDATA)\bin\rm.exe
CP = $(NEOBUILDDATA)\bin\cp.exe
MKDIR = $(NEOBUILDDATA)\bin\mkdir.exe

ASFLAGS = -m68000 --register-prefix-optional

install: neocore

neocore:
	$(CP) -f neocore.h $(INC)
	gcc -I$(INC) -m68000 -O3 -Wall -fomit-frame-pointer -ffast-math -fno-builtin -nostartfiles -nodefaultlibs -D__cd__ -c neocore.c -o $(LIB)\libneocore.a

clean:
	$(RM) -f $(LIB)\libneocore.a
	$(RM) -f $(INC)\neocore.h

uninstall:
	$(RM) -rf --no-preserve-root $(NEOBUILDDATA)
