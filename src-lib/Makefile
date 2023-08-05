INC = $(NEODEV)\include
LIB = $(NEODEV)\lib

# TODO : parametric NEOBUILDATA
NEOBUILDDATA = ..\build

RM = $(NEOBUILDDATA)\bin\rm.exe
MKDIR = $(NEOBUILDDATA)\bin\mkdir.exe

ASFLAGS = -m68000 --register-prefix-optional

install: neocore

neocore:
	copy /Y neocore.h $(INC)
#	cp neocore.h $(INC)
	gcc -I$(INC) -m68000 -O3 -Wall -fno-lto -fno-use-linker-plugin -fomit-frame-pointer -ffast-math -fno-builtin -nostartfiles -nodefaultlibs -D__cd__ -c neocore.c -o $(LIB)\libneocore.a
# TODO : fix clean & uninstall

clean:
	$(RM) -f $(LIB)\libneocore.a
	$(RM) -f $(INC)\neocore.h

uninstall:
	$(RM) -rf --no-preserve-root $(NEOBUILDDATA)
