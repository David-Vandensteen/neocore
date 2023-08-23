install: neocore

neocore:
#	copy /Y neocore.h $(INCLUDE_PATH)
#	cp neocore.h $(INCLUDE_PATH)
#	gcc -I$(INC) -m68000 -O3 -Wall -fno-lto -fno-use-linker-plugin -fomit-frame-pointer -ffast-math -fno-builtin -nostartfiles -nodefaultlibs -D__cd__ -c neocore.c -o $(LIB)\libneocore.a
	gcc -I$(INCLUDE_PATH) -m68000 -O3 -Wall -fomit-frame-pointer -ffast-math -fno-builtin -nostartfiles -nodefaultlibs -D__cd__ -c neocore.c -o $(LIBRARY_PATH)\libneocore.a


debug:
	@echo DEBUG
	@echo INCLUDE_PATH : $(INCLUDE_PATH)
	@echo LIBRARY_PATH : $(LIBRARY_PATH)
