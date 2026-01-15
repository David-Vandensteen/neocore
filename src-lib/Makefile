install: neocore

AR = ar

CFLAGS = -I$(INCLUDE_PATH) \
				 -m68000 \
				 -O3 \
				 -Wall \
				 -Wextra \
				 -fomit-frame-pointer \
				 -fdata-sections \
				 -ffast-math \
				 -ffunction-sections \
				 -fno-builtin \
				 -nostartfiles \
				 -nodefaultlibs \
				 -Wno-unused-parameter \
				 -D__cd__

neocore: neocore.o cdda.o
	$(AR) cr $(LIBRARY_PATH)/libneocore.a $(LIBRARY_PATH)/neocore.o $(LIBRARY_PATH)/cdda.o

neocore.o: neocore.c
	gcc $(CFLAGS) -c neocore.c -o $(LIBRARY_PATH)/neocore.o

cdda.o: cdda.c
	gcc $(CFLAGS) -c cdda.c -o $(LIBRARY_PATH)/cdda.o

debug:
	@echo DEBUG
	@echo INCLUDE_PATH : $(INCLUDE_PATH)
	@echo LIBRARY_PATH : $(LIBRARY_PATH)
