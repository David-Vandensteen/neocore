
INC = $(NEODEV)/m68k/include
LIB = $(NEODEV)/m68k/lib

NEOBUILDDATA = $(shell cygpath -u $(APPDATA))/neocore
RM = $(shell cygpath -w $(NEOBUILDDATA))\bin\rm.exe
CP = $(shell cygpath -w $(NEOBUILDDATA))\bin\cp.exe
MKDIR = $(shell cygpath -w $(NEOBUILDDATA))\bin\mkdir.exe

ASFLAGS = -m68000 --register-prefix-optional

install: neocore

neocore:
	$(CP) -f src-lib\neocore.h $(INC)
	gcc -I$(INC) -m68000 -O3 -Wall -fomit-frame-pointer -ffast-math -fno-builtin -nostartfiles -nodefaultlibs -D__cd__ -c src-lib\neocore.c -o $(LIB)\libneocore.a


clean:
	$(RM) -f $(LIB)\libneocore.a
	$(RM) -f $(INC)\neocore.h

uninstall:
	$(RM) -rf --no-preserve-root $(NEOBUILDDATA)

init-project:
	powershell -ExecutionPolicy Bypass -File scripts\neocore-init-project.ps1
