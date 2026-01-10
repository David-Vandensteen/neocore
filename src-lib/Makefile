install: neocore

AR = ar

neocore: neocore.o cdda.o
	$(AR) cr $(LIBRARY_PATH)/libneocore.a $(LIBRARY_PATH)/neocore.o $(LIBRARY_PATH)/cdda.o

neocore.o: neocore.c
	gcc -I$(INCLUDE_PATH) -m68000 -O3 -Wall -fomit-frame-pointer -ffast-math -fno-builtin -nostartfiles -nodefaultlibs -D__cd__ -c neocore.c -o $(LIBRARY_PATH)/neocore.o

cdda.o: cdda.c
	gcc -I$(INCLUDE_PATH) -m68000 -O3 -Wall -fomit-frame-pointer -ffast-math -fno-builtin -nostartfiles -nodefaultlibs -D__cd__ -c cdda.c -o $(LIBRARY_PATH)/cdda.o

debug:
	@echo DEBUG
	@echo INCLUDE_PATH : $(INCLUDE_PATH)
	@echo LIBRARY_PATH : $(LIBRARY_PATH)
