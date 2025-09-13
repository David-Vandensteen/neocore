```
Confidential
```
future is
0

Neo-Geo Hardware Specification

SNK


## Neo-Geo Hardware Specification

   - Neo-Geo Specification Hardware Table of Contents
- Special Features of the "3D-LINE SPRITE" Hardware
- Specification of Each Function Hardware
         - FIX Hardware
         - Background Hardware
         - 3D-Line Sprite Hardware
   - Interrupts Hardware
      - Interrupt-1 Hardware
         - Interrupt-2 Hardware
   - Access to Line Sprite Controller (LSPC) Hardware
   - Address Map of the 68000 Hardware
   - Address Map of the 280 Hardware
- I/O Map of the 280 Hardware
   - Sound Function Hardware #
   - Notes Hardware
- 3D Line Sprite Hardware
         - Vertical and Horizontal Positions Hardware
         - Vertical Reduction (BIGV). and Horizontal Reduction (BIGH) Hardware Example of the Number of Active Characters (ACT).
         - Address Mapping of the FIX Area (VRAM) (In the NTSC Mode)Hardware
         - Address Mapping of the FIX Area (VRAM) (In the PAL Mode) Hardware
         - Address Example of the 3D-Line Sprite Hardware
         - Address Mapping of the 3D-Line Sprite Hardware
         - Color Palettes Hardware
         - Data Format of the 3D-Line Sprite Character ROM Hardware
         - Data Format of the FIX Area Character ROM Hardware


```
Neo-Geo Specification
```
### CPU

### HD68HCOOOPS 12

```
Program ROM
2M ~~tes'(~aximum)
```
Work RAM
64K Bytes

```
Fix character
128K Bytes
```
```
3D-line sprite character
128M Bits (Maximum)
```
```
VRAM
64K Bytes + 4K Bytes
```
```
Background
1 Color
```
```
Dec. 1, 1989
Aug. 22, 1990
Jun. 18, 1991
```
```
Clock: 12 MHz
```
```
Color
4096 colors out of 65536 colors si~nultaneous color displ'ay
(1 5 colors x 256 palettes)
16k bytes
```
```
RGB output, video output, and headphone output (stereo)
```
```
Can use ~nelnory card
```
```
Interrupts
Vertical blanking interrupt and timer interrupt
```
```
Hardware - 1
```

[12] Sound

```
1) 1 YM-
2) 62K Bytes Program
3) 2K Bytes Working RAM
4) 16M Bytes (max.) ADPCM-A
5) 16M Bytes (max.) ADPCM-B
6) Z8OA (clock 4 MHz) CPU
```
[13] The screen is displayed using LSPC or LSPC2.
When using LSPC2, switching between NTSC and PAL becomes possible through
hardware (with software they can only be read).

```
In the PAL mode, the display area becomes 16 lines larger on the top and bottom; the
vertical blanking lengthens only by 16 lines.
```
```
Hardware - 2
```

```
Special features of the "3D-LINE SPRITE"
```
```
One 3D-LINE SPRITE consists of 32 characters arranged vertically. Each character is
a 16 by 16 dot array.
```
```
With 380 3D-LINE SPRITEs, many enemies and ammunition can appear on the screen.
Large characters can be easily displayed, and parts may be overwritten.
```
```
Characters are more freely distributed than are those produced using boards which have
separate scroll and sprite patterns.
```
```
The image can be reduced in 256 levels vertically, and 16 levels horizontally.
```
```
The display range may be changed in steps (0, 1, 2, 3,... 16, 32, 33) by specifying the
number of active characters.
```
```
A 3D scrolling display is formed by forty-one 3D-LINE SPRITEs.
In this configuration, set the number of active characters to 33. The picture size can be
reduced up to half both vertically and horizontally.
```
```
Note: When the number of active characters is set to 33, the picturecan be reduced
by up to half vertically, and both ends of the picture will be connected together
as a loop.
```
```
A maxiinu~n of 96 3D-LINE SPRITEs can be placed horizontally.
(The arrangement is determined only by the vertical position and number of active
characters .) I
```
Various scenes such as rivers, are easily displayed by the automatic character switching
display function.
(Switching character number bits 0-2)

Multiple 3D-LINE SPRITEs can be moved si~nultaneously using the chain function.

Interrupts can be issued at specified intervals using timer interrupt, or when the scanning
reaches an arbitrary point on the screen.

The display can be diinlned by using the shadow bit output.

```
Hardware - 3
```

```
Specification of Each Function
```
```
1) FIX ;Priority 1
```
1. 40 by 28 characters are displayed at a fixed location.
2. The size of each character is 8 by 8 pixels.
3. Up to^15 colors. can be used per character.
4. There are 16 color pallettes. (4 bits)
5. The number of characters is 4096. (12 bits)

2) Background ;Priority 3

```
One color is specified from 65,536 colors.
```
3) 3D-LINE SPRITE ;Priority 2

1. Up to 380 3D-LINE SPRITES can be displayed simultaneously, but only 96 can
    be placed horizon tally.
2. One 3D-LINE SPRITE consists of 32 vertical characters; each character being a
16 by 16 dot array.
3. The following parameters are specified for each 3D-LINE SPRITE
11 Vertical position (9 bits)
21 Horizontal position (9 bits)
31 Vertical reduction (8 bits) ;OFFH for maximum
41 Horizontal reduction (4 bits): ;OFH for maximum
51 Number of active characters (6 bits): ;No characteis are displayed
;when this is set to 0.
;The product of 16 times this
;number will be the total
;number of dots that are
;displayed, except when "33"
;is selected.
61 Chain bit (1 bit): ;When this bit is set to " 1 ,"
;this 3D-LINE SPRITE is
;connected to the right side of
;the previous 3D-LINE
;SPRITE, and vertical
;position, horizontal position,
;vertical reduction, and
; number of active characters
;settings are ignored.

```
Hardware - 4
```

4. The following parameters are set for each character.
    I] Character number (16 bits)
21 CoIor pallette number (8 bits)
31 Vertical flip (1 bit) ; " I " flips image vertically.
41 Horizontal flip (1 bit) ; "^1 " flips image horizontally.
51 Automatic character switching display of 4-sequence characters. (1 bit)
;" 1" for active.
61 Automatic character switching display of 8-sequence characters. (1 bit)
;" 1 " for active.
5. Specify the speed of the automatic character switching display. (8 bits)
;This value controls the speed
;for both 4-sequence and
; 8-sequence characters.
6. Total number of characters. (65,536 is the maximum.)
7. Fifteen colors can be used per character.
8. There are^239 color palettes.

4) Interrupts

1. Interrupt- 1
    11 Interrupt-vector address is 64H.
21 Interrupt is triggered at the beginning of vertical blanking.
31 Execute the following instructions when the interrupt occurs:
M0V.W #4, 3COOOCH ;For the next interrubt
MOV. B DO, 30000 1 H ;For the watchdog
2. Interrupt-
11 Interrupt vector address is 68H.
21 Interrupt is triggered when the timer counter reaches 0.
31 The folIowing instruction is executed when the interrupt occurs:
M0VE.W #2,3COOOCH

```
41 After the CPU sets the Tiiner High register and Tiiner Low register, that
data is set to the timer counter (32 bits) at the moment that the following
events listed below occur. (The value of the timer counter is decremented
by one every 167nS which is the time it takes to scan one pixel, and an
interrupt is triggered when it reaches 0.)
```
```
Hardware - 5
```

```
(1) When the Timer Low register is set.
(2) At the beginning of the horizontal blanking in the first line of
vertical blanking.
(3) When the timer counter reaches 0.
```
```
51 User can set bits^4 to 7 of the Mode register to disable interrupts, or to
change the initialization timing for the timer counter.
61 Timer High and Tiiner Low registers should never be set to 0.
71 To trigger: interrupts for every N pixels, set the Timer register to N-1, and
set bits 4 to 7 of the Mode register to 1001B4 (9 x H).
81 To trigger interrupts when the scanning reaches multiple arbitrary display
locations, set bits 4 to 7 of the Mode register to 1 1 OlB (d x H). Then,
in the interrupt handler routine, set the interval between the next interrupt
and the following to the Timer register.
```
5) Access to Line Sprite Controller (LSPC)

1. Read and write operations to VRAM should be done via the LSPC register.
2. VRAM has one address for each word (16 bits), and all readlwrite operations are
done in words. (Long words, and bytes are not allowed.)
3. LSPC has the following registers:

```
.I ] Address register (wri te-only)
contains the VRAM address (0 - OFFFFH) of the next readlwrite
operation.
21 Write Data register (wri te-on1 y)
Contains data to be transferred to VRAM.
When the CPU writes data to this register, it is passed to VRAM.
31 Automatic Increment register (readlwrite)
```
```
I
```
```
Values range between 0 and OFFFFH.
This value is added to the Address register immediately after the data is
written to the Write Data register.
41 Mode Register
Bits 8- 15: Speed for automatic character switching display. Multiply
value ti~iles 16mS for the actual timing interval.
Bit 3 = 1: Stop automatic character switching display.
Bit 4 = 1: Issues an interrupt when the timer counter reaches 0.
Bit 5 = 1: When Timer Low register is set, Timer counter is
siinultaneously set.
Bit 6 = 1: Tiiner counter is set at the beginning of the horizontal
blanking of the first vertical blanking line.
Bit 7 = 1: Timer counter is set to initial value when Timer counter
becomes 0.
```
```
Hardware - 6
```

```
51 Read Register (read-only)
VRAM data is read from this register. (The value of the Address register
doesn't change.)
61 Raster Vertical Position register (read only)
Bits 0-2: When the automatic character feature is active, the
character number of the character displayed can be read
from here.
Bit 3: NTSC/PAL mode select *** =PC2 only ***
= 0 : PAL
= 1 : NTSC
Bit 7 : Read lV
Bit 8 : Read 2V
Bit 9 : Read 4V
Bit 10 : Read 8V
Bit 11 : Read 16V
Bit 12 : Read 32V
Bit 13 : Read 64V
Bit 1'4 : Read 128V
Bit 15 : Read 256V (Set. to " 1 " during display.)
71 Timer High register (write-only)
Upper 16 bits of data to be set to Timer counter.
81 Timer Low register (wri te-on1 y)
Lower 16 bits of data to be set to Timer counter.
91 Interrupt Clear register (write-only)
Interrupt flags are cleared when bit is set to " 1 ".
Bit 1 = 1 : Clears tlie timkr interrupt flag.
Bit 2 = 1: Clears the vertical blanking interrupt flag.
101 Timer Stop Switch (write-only) *** LSPC2 only ***
(Initial Value : Bit 0 = I)
Bit 0 = 0: Timer counter is not stopped even when the PAL mode is
selected.
Bit 0 = 1 : Only when PAL mode is selected, timer counter is stopped
for 32 horizontal lines (18,432 pixels).
```
4. Read and write operations to LSPC registers are executed with no wait cycle.
5. Read operation from VRAM should be done at least 1.4pS (16 CPU clock cycles)
    after the address register is changed.
6. When the value in the Address register is changed from the 0 - 7FFFH range to
    the 8000H - OFFFFH range, or from the 8000H - OFFFFH range to the 0 -
    7FFFH range, this value must be written directly into tlie register, rather than
       using tlie automatic increment operation. At least 1.4pS (16 CPU clock cycles)
    is required before writing to the Address register after the Data register is


```
changed.
```
7. Write operation to Data or Address register should be done 1pS (12 CPU clock
    cycles) after the write operation is executed to a Data register.

```
Example :
MOVE DO, [AQ] ;A0 = 3COOOOH
MOVE Dl, [A l] ;A1 =3C0002H
ADDQ #8., Dl ;instruction for^4 or more clock cycles
MOVE Dl, [All
MOVE #1234H, [A 1] ;instruction for 12 or more clock cycles
MOVE #5678H, [All ;instruction for 12 or more clock cycles
MOVE #9ABCH, [All ;instruction for 12 or more clock cycles
```
6) Address map of the 68000

1. Program ROM 0-OFFFFFH
2. System ROM OCOOOOOH-OC 1 FFFFH
3. Work RAM 100000H-^1 OFFFFH
4. LSPC
11 Address register 3COOOOH (write, word)
21 Write Data register 3C0002H (write, word)
31 Auto Increment register 3C0004H (readlwrite, word)
41 Mode register 3C0006H (write, word)
51 Read Data register 3COOOOH (read, word)
or 3C0002H
61 Raster Vertical Position register.
3C0006H (read, word)
71 Timer High register 3C0008H (write, word)
,
81 Timer Low register 3COOOAH (write, word)
91 Intern~pt Clear register 3COOOCH (write, word)
101 Timer Stop Switch 3COOOEH (write, word)
**** LSPC2 only ****
5. Color Palette (2 banks) 400000H-40 1 FFFH (word-long)
6. Watchdog Tiiner 300001H (write, BYTE)
7. Output Port (write, byte)
11 Set shadow bit to 0 for normal display 3A0001H
21 Set shadow bit to 1 for di~nined display 3A0011H
31 Vector switch (0-7FH) ON 3A0003H
(Switch between 0-7FH and OCOOOOOH-OC0007FH)
41 Vector switch (0-7FH) OFF 3A00 13H
51 Memory card llwrite enable 3A0005H


```
61 Memory card 2lwrite enable 3A0017H
71 Me~nory card 1 /write disable 3A0015H
81 Memory card 2lwrite disable 3A0007H
91 Memory cardlregister select enable 3A0009H
101 Memory cardlset to normal 3A00 19H
1 1] Memory cardlbank output (bit 2-0) 3800 1 1H
121 Select palette bank 0 3AOOOFH
131 Select palette bank 1 3A001 FH
141 Controller Output^38000 1 H
(negative logic, open-collector)
Bit 0 : Bit 1 output from controller 1
Bit1 : Bit 2 output from controller 1
Bit 2 : Bit 3 output from controller 1
Bit3 : Bit 1 output from controller 2
Bit 4 : Bit 2 output fro111 controller 2
Bit5 : Bit 3 output from controller 2
```
8. Sound code output 320000H (write, byte)
9. Sound code input 320000H (read, byte)
10. Input Port
11 Player lltop (0 = ON)
21 Player llbottom (0 = ON)
31 Player 1 /left (0 = ON)
41 Player 1 /right (0 = ON).

51 Player lltrigger (^1) (0 = ON)
61 Player lltrigger (^2) (0 = ON)
71 Player lltrigger (^3) (0 = ON)
81 Player lltrigger 4 (0 = ON)
101 Player 1 /start (0 = ON)
1 I] Player 1 /select (0 = ON)
121 Player 21top (0 = ON)
131 Player 21bottom (0 = ON)
141 Player 2lleft (0 = ON)
151 Player 2lright (0 = ON)
161 Player 2ltrigger 1 (0 = ON)
171 Player 2ltrigger (^2) (0 = ON)
181 Player 2ltrigger 3 (0 = ON)
191 Player 2ltrigger (^4) (0 = ON)
201 Player 2lstart (0 = ON)
211 Player 2lselect (0 = ON)
221 Meinory card 1 insertion status
(0 = inserted)
(read, BYTE)
300000H, bit 0
300000H, bit 1
300000H, bit 2
300000H, bit 3
300000H, bit 4
300000H, bit 5
300000H, bit 6
300000H, bit 7
380000H, bit 0
380000H, bit 1
340000H, bit 0
340000H, bit 1
340000H, bit 2
340000H, bit 3
340000H, bit 4
340000H, bit 5
340000H, bit 6
340000H, bit 7
380000H, bit 2
380000H, bit 3
380000H, bit 4
Hardware - 9


```
231 Memory card 2 insertion status
(0 = inserted) 380000H, bit^5
241 Write protect status detection 380000H, bit 6
(0 = write enable)
251 NEO-GEO mode 380000H, bit^7
0 : NEO-GEO
1 : MULTI-VIDEO SYSTEM
```
11. Memory card. 800000H-OBFFFFFH (word, long word)
    (8 banks)
When 2K-byte RAM card is used, it is allocated to address
800000H - 800FFFH, and bits 8 to 15 are ignored.

```
7) Address map of the 280
```
1. Program ROM
2. Work RAM

```
8) I10 map of the 280
```
1. Sound code input OOOOH (read)
2. Clear sound code input OOOOH (write)
3. NMI enable 0008H (write)
4. NMI disable 0018H (write)
5. Sound code outpilt OOOCH (write)
6. YM2610 0004H-0007H (readlwrite)

9) Sound function

1. The NMI can be activated and deactivated by writing sound code from the 68000,
    The NMI is disabled immediately after the system is reset.

```
,
```
2. The NMI flag is cleared when the sound code is read.
    3. The sound co~n~nand is read from OOOOH but a sound acknowledge (or return
       data) is written to 000CH. On the 68000 side, the single location 320000H is
       written or read.
4. An interrupt can be triggered by the YM2610 timer.

```
10) Notes
```
1. After the CPU is reset and before the interrupt is enabled, the following
    instruction needs to be executed at least once every 100mS.
       MOVE, B DO, 300001H
2. You must access the palette by word or long word. Access should be attempted
only during the vertical blanking period. (Noise may appear on the screen if the
access is attempted during the visible scanning period.)
3. Set the number of active characters to "0" to erase a 3D-LINE SPRITE.

```
Hardware. - 10
```

4. After the CPU is reset, the following instruction needs to be executed
    im~nediately before the interrupt is issued.
       MOVE, W #7, 3COOOCH
          This will clear the interrupt resister.
5. The following initialization is also necessary after the CPU is reset.
    [I] Write the transparency character (e.g. 0020H) into the VRAM
       address 0 to 3FH.
    [2] Write OOOOH into VRAM address 8200H.
6. When designing for NEO-GEO, important characters should not be placed within
    the left most and right most 16-dot areas, nor' in the top and bottom 8-dot areas.
    These areas may not be visible on some television monitors.
7. For Multi-Video Systems, 8 dots on both the left and right sides should be
inasked by black characters, using the FIX display mode.
8. When the vertical reduction ratio of a 3D-LINE SPRITE is set to a value other
    than OFFH, the characters which are addressed by 1EH and 20H of that 3D-LINE
    SPRITE need to be transparent characters. Or, put a transparent dot in the
    locations one dot below IEH and one dot above 20H.

```
Hardwart: - 1 I
```

rndot
-wm,

```
%&lot
(PAL)
```
```
\
```
```
Hardware - 12
```

```
Display area
Vertical and Horizontal Positions
```
0: Character

```
1: Color
```
```
Hardware - 13
```
```
'-g
02
```
-
    04

```
06
```
### P

```
.-~~~~~-~~,~,~,C~~,~,~,~,~,~,~,~,~,~,C,~,~,~,c,~Cc,C,~,CCCC~CCCCCCCCC~~ 7 PAL
```
```
.~~~~~-4-,C#~,~~-,C,~,~,a,C,a,~,C,~,C,~,I,C,~,C,CI,CCCC~CC.C.CC~CC~-,"~
```
-- ~~ri~ontal Position- Large

1'

```
Vertical Position- Large
```
```
i
1
```
```
la
```
```
1C
```
```
1E
-I#-,
20
```
```
Display Position When Vertical Position=O and Horizontal position=
'. I
```
I

--u~~H~~~~~8CI~LI0@t~~m~~~~~a8.c#~#-#~~~#~~~~~~~8~~~~~~~~a~~~~~~~~,-,~,~,C,CT i 1 NTSC

T~~N#~CII# a,8,,,,,,,, ,,- -1 PAL

```
3C
```
```
3E
```
```
-3P-L I NE SPR 1 TE
```

Example of the Number of Active Characters
Horizontal Reduction (BIGH)

```
Hardware - 14
```
```
(ACT), Vertical Reduction (BIGV),
```
```
rl are display
k"! L I
```
```
and
```
```
area
```

```
Address Mapping of the FIX Area (VRAM) (In the NTSC Mode)
```
k v A Y I

```
Color Palette Number Character Number
```
```
Hardware - 15
```
BT15 87'14 BT13 0T12 BTII BT!O BIT9 BIT8 BIT7 BITG BIT5 BIT4 BIT3 BIT2 BIT1 81~


```
Address Mapping of the FIX Area (VRAM) (In the PAL Mode)
```
\ 1 A Y J

```
Color Palette Number Character Number
```
```
Hardware - 16
```

3D-LINE SPRITE

VRAM Address (Example)

```
BT~S I BT14 (BTl3 1 a12 1 mli 1 BTlO I BIT9 I BIT8 I BIT7 I Blm I BIT5 ( BlT4 I BIT3 I B~TZ I BIT1 1 BIT
\ - Y Presently, only bit 4 is used.
Character Number Other bits are for future expansions,
Extended Character Code and. .- are left at 0s. ,
```
```
\ " A Y J
Color Palette Number Unused
8-Level Automatic Character Switching 4-Level Automatic Character Switching
```
```
Unused. Horizontal Reduction Vertical Reduction
```
BTIS ( BTl4 1 8713 1 BT12 I Lkll I BTJO I BITS I BIT8 ( BIT7 I BITG'I BIT5 ( BIT

```
Vertical Position
```
BIT3 I BI'E 1 Bl~l 1 BIT

```
I
Chain Bit
```
```
Number of Active Characte~
```
```
\ Y A Y 1
```
```
Horizontal Position Unused
```
```
Hardware - 17
```
BT15 BT14 BT13 Bl'12 BTll BTlO BIT9 BIT8 BIT? BlTG BIT5 BIT4 BIT3 BIT2 BIT1 BITO


```
Address Mapping of the 3D-Line Sprite (VRAM) ;by low priority
```
```
Hardware - 18
```
```
Horizontal
Position
```
```
8401H
```
```
8402H
```
```
8403H
```
### 857BH

### 857CH

### 1

### 2

### 3

### 379

### 380

```
Character and
Color
```
```
40H-7FH
```
```
80H-OBFH
```
```
OCOH-OFFH
```
### 5ECHOH-5EFHH

### 5FOOH-5F3FH

```
Reduction
```
### 800 1 H

### 8002H

### 8003H

### 8 17BH

### 817CH

```
Vertical
Position
```
```
820 1 H
```
```
8202H
```
```
8203H
```
### 837BH

### 837CH


```
Color Palettes
```
1. There are 256 color palettes.
2. Each palette can have 15 color codes selected from 65,537 colors.
3. Use color palette number 255 for the background.
4. Use color palette numbers 0- 15 for the FIX areas.
5. Use color palette numbers 16-254 for the 3D-line sprites.
bit 4 - bit 7 30 line sprite color
bit. 0 - bit 3 fix color

Addresses for the Color Codes

```
1) Color Palette Number 0 400000H-4000 1 FH
However, 400000H is 0 (transparent)
2) Color Palette Number 1 400020H-40003FH
```
3) Color Palette Number (^2) 400040H-40005 FH
255) Color Palette Number 254
256) Background
Color Codes
BL,UE i

..
BLUEZ
BLUE3
BLUE4
GREEN1
GREEN2
GREEN3
GREEN4
..
RED 1
RED2
RED3
RED4
BLUE0
GREEN0
..
REDO
IICD-I

### 40 1 FCOH-40 1 FDFH

### 40 1 FFEH-40 1 FFFH

```
(Will become a bit darker with 1)
```
```
Hardware - 19
```

```
Data Format of the 3D-Line Sprite Character ROM
```
```
One character is 16 x 16 dot matrix and is composed of addresses 0-1FH (bits 7-0, bits
15-8, bits 23-16, and bits 31-24) of each 4 ROMs.
```
I I 8 I I I I
MRSlOlI 'i ADRSlOIl i ADRSlOll MRSlOll i ADRSIOII ADRSlOll i ADRSlOll i hDRSlOll
BIT0 : BIT1 : BIT2 .: BIT3 : BIT4. : BIT5 : DlTG : BIT7
BIT8 i BIT9 i .BIT10 i BIT11 I BIT12 i BIT13 i BlT14 I BIT15
BIT16 : BIT17 : BIT18 : BIT19 : BIT20 : BIT21 : BIT22 BIT23
BIT24 i BIT25 i BITZ i 4. BIT27 i BIT20 ' i BIT29 i BIT30 : BIT31

```
ADRS I111
```
```
ADRS 1211
h
ADRS 1311
```
```
.pl
```
```
ADRS 1411 e
```
.. ADRs 1Mf
    ADD l~il

```
ADRS 111
```
```
However, when using a 16-bit data ROM, it is composed of addresses 0-1FH (bits 15-0
and bits 31-16) for both ROMs.
```
```
~DK 0
```
kom 1

```
EON 2
ADRS 3
```
```
AORS 4
```
```
htk 6
```
```
ADKG.
```
b~s 7

```
Hardware - 20
```
```
ADRS 'l~l
```
```
ADRS 1MI
```
ADRS la1

ADRS lDll

AD@ ]Ell

```
AORS IF11
```
```
4DRS OAH
```
```
ADRS OBI1
```
```
ADRS 0~11
```
```
ADRS 0011
```
```
ADK OD1
```
```
ADRS Off l
```

Data Format of the FIX Area Character ROM

```
One character is an 8x8 dot matrix and is composed of addresses 0-1FH for one ROM.
```
```
Hardware - 21
```
```
AURS 8 i AURS 8
DIM4 .iBlT/*4
```
```
AORS 9 i ADRS 9
DIM4 j BIT/-4
I
ADRSOhIl i ADnrcMII
BIT34 : BIT/-4
```
```
ADRSCOII i ADRS~II
am4 i o~n-4
I
ADRWUl i ADRSO;II
BIT34 3 0117-4
```
```
ADRSOIII~ i ADlsanl
01~34 i 8117-4
g
ADIlSOB l AORSUUI
BIT34 : BIT/--4
```
```
AUNOAI i ADMAI
BIT34 i 8117-4
```
```
AURSlOll i ADRSlOll
BIT34 iBIT/--4
9
MIRSI Ill i ADEl Ill
BIT34 .j BlT7-4
```
```
AUislzll i ADi6lzll
BIT34 : BlT7-4
```
```
AURS~OII i ~RSI~II
6m-o i BIU-4
1
AORSl411 i MRSIIII
BIT34 : 01T7-4
```
```
MRS1611 i'~ORS1511
BIT34 i BIT74
8
ADRS1611 i M61611.
BIT34 : BIT7-I
```
```
~~k317ll i ADREl7ll
BIT34! 8157-4
```
```
AORTlDII i hDRSl8ll
BI'134 !BIT/-4
8
AOE19H i ADRSlSII
BIT34 i BlT7-4
8
AURSlhll i AD,Nlhll
BIT34 : BlW
```
```
MRS IBII ; ME~BI~
sin4 : BIW
I
ADRS.lCll i ADRSlClI
```
(^01134) -8 : BIl7-4
ADElDll i MRSlUl
BIT34 BIT74
9
AORSIUI i ADRSl~l
.01T34 : 61TI-4
hPSlFIl i hUIkl~1
BIT34 i BIT/--4
AORS 0 i hUl6 0
BIT34 ~01T1--4

. 4
ADRS 1 i ADRS 1
BIT3--0 i BIT/--4

```
AMIS 2 i ADRS 2
FIT34 i BIT/--4
```
```
AORS 3 i ADRS 3
o1~3-a i BIW-4
I
AtJE 4' i ADRS 4
BIT34 : BITI-4
```
```
AD6 5 i A06 5
BI 4 i 01~7-4
8
ADRS 0 AORS 6
BIT34 : B117-4
```
```
ADRS 7! AURS 7
BIT34 BIT/--4
```

```
Confidential
```
NEO-GEO SYSTEM PROGRAM

R&D Section, Technical Development Division
SNK Co., Ltd.


-- 1 -- OUTLINE OF SYSTEM PROGRAM

```
Two types of program ROMs exist for Neo-Geo. One is provided in the game cartridge
(hereafter called the game program, or the game for short).
The other is built into the NEeGEO unit (hereafter called the system program, or the system
for short). The mapping for these is as follows:
```
```
Game Rom System Rom
```
000000H C00000H

```
S witchable
C -4
```
```
Figure 1-1
```
```
In this mapping, the areas between address 0 to 7FH can be switched using the software.
The system side is selected when the system is reset.
```
System Program - 1


```
The system program is generally composed of the following five parts:
```
```
(1) Control over the entire game
(2) Standard UO
(3) Memory-card interface
(4) Simple monitoring program (for development)
(5) Utility program
```
Furthermore, the NEO-GEO provides addresses 100000H-10FFFFH as a work area, out
of which the addresses 10F300H-10FFm;H are reserved exclusively for use by the
system program. Therefore, every game is to use addresses 100000H-10F2Fl;H.

For the multi-video system (hereafter called the MVS), DOOOOOH-DO- is used as
the backup RAM am. This is used exclusively by the system, and cannot be used for
the game.

```
Work Area
```
```
For Game
```
```
t
Stack Area
```
```
For System
```
```
Backup RAh
```
```
For System
```
System Program - 2


The complete program flow of Neo-Geo is basically as follows:

I system Initialization I

```
Game Initialization
```
1 Eye-Catcher 1

```
Demo Game or At this stage, the system
```
## Game 1 Game , 1 subroutine is requested every

```
1/60 of a second.
```
# -

```
Fig. 1-3
```
System Program - 3


```
[I] System Initialization
```
```
As shown in Fig. 1-1, reset processing is done by the system, since the system side is
selected for the exception-handling vector (address 0-7FH) when resetting.
```
```
At this point, the system work and different types of 110 are initkkd, and it is
determined whether or not the game cartridge has been loaded.
```
```
121 Game Initialization
```
```
Out of the work area, only the backup area (described later) for each game is initializd.
This is due to commercial-system (MVS) and home-unit compatibility. For the
commercial machine, the hardware is shared among various games, and the status of
work and V-RAM vary from game to game. Therefore, initialization is required every
time a game is started.
```
```
131 Eye-Catcher
```
```
A company logo or the NEO-GEO logo is displayed as an .eye-catcher. If sprites for
common Fix or the NEO-GEO logo are available, the eyecatcher procedure can be done
through the system program.
```
141 Game and Demo Game

```
Normally, a game demo or title display is shown (the system specifies which to show)
for approximately 30 seconds. At this stage, if there is a specification or permission
from the system to start the game, the game statts. A request is to be made every 1/60
second for the system subroutine [SYSTEM-101. It should return to the system program
after the demo or end of the game.
```
System Program - 4


- 2 --- INTERFACE BETWEEN SYSTEM AND GAME

[I] Entries into the System Program from the Game

```
All entries into the system program from the game are made through the jump table
(address C00402H). Because the system uses privileged instructions, be sure to put the
system in the supervisor mode when entering the system program.
For the system subroutine, be careful, since the registers are not saved.
```
[2] Exception-Handling Vector

```
When the game program is being executed, the game side is selected for the exception-
handling vector of address 0-7FH. At this point, handling some exceptions starts the
system's simplified monitor. Therefore, define the addresses as follows:
```
System Program - 5

```
No
00
01
02
03
04
05
06
07
08
09
OA
OB
```
OC-OE

OF

```
10-17
18
19
1A
1B
1C
1D
1E
1F
```
```
Address
00
04
08
OC
10
14
18
1C
20
24
28
2C
30-38
3C
4e5C
60
64
68
6C
70
74
78
7C
```
```
Name
Reset SSP default values
Reset PC default values
Bus error (monitor start-up)
Address error
Incorrect command
Division by 0
CHK command
TRAPV command
Illegal privilege
Trace exception handling
No package command (1010)
No package command (1 11 1)
Unused
Uninitialized interrupt
Unused
Virtual interrupt
Interrupt 1
Interrupt 2
Interrupt 3 (unused)
Interrupt 4 (unused)
Interrupt 5 (unused)
Interrupt 6 (unused)
Interrupt 7 (unused)
```
```
Address
1OF300H
C00402H
C00408H
C004OEH
C00414H
Defined by game
Defined by game
Defined by game
C0041AH
C00420H
Defined by game
Defined by game
C00426H
C0042CH
C00426H
C00432H
Defined by game
Defined by game
Defined by game
Defined by game
Defined by game
Defined by game
Defined by game
```

```
When the foreground monitor ICE (In-Circuit Emulator) is used, define the vectors
according to the ICE monitor. (Otherwise, such problems as not being able to execute
step by step may occur, causing difficulties in debugging.) But even in this case, define
the addresses when placing the program in ROM.
```
```
Furthermore, vectors not used in the actual game are to be at No. 6 as unused, even if
it is defined in the game.
```
[3] Game ID

```
In each game, the address 1OOH-18H is the ID region that the system refers to. Define
the parameters, addresses, etc., according to the following:
```
System Program - 6

### ADDRESS

```
lOOH
```
### 107H

```
lO8H
```
```
lOAH
```
### 1 OEH

### 112H

### SIZE

```
(byte)
7 1 2 4 4 2
```
### DESCRIPTION

### ASC

### HEX

```
Cartridge Recognition Code, 1
The game does not start unless this code has been set
conectly.
0
System Version
Set at 0 for the present.
Game Code ID
Defines the garhe identification code (provided by
sw
(Note: OOOOH is not allowed.)
Program ROM Size
(Example) For^4 M bits, 80000H
for 16 M bits, lOOOOOH
These are defined in long-words.
Starting address of the work-backup area
Size of the work-backup area
```
```
Defined in long-words and words, the starting address
and size of the system-backup area of the work area
used for the game.
```
```
Formula:
lOOOOOH < = [STARTI < [START + SIZE] = lOFCOOH
0 < [SIZE] < = lOOOH
```
```
lOOH
N
4E
```
```
lOlH
E
45
```
### 102H

```
0
4F
```
### 103H

-
2D

### 104H

### G

### 47

### 105H

### E

### 45

### 106H

### 0

### 4F


```
System Program - 7
```
-

### DESCRIPTION

```
0 = the common eye-catcher by the system to be
used.
This requires the common Fix, exclusive sprites and
eye-catcher sounds. Furthermore, define the
exclusive sprite bank number (the upper eight bits of
the character code) in the following byte:
1 = the game's original eye-catcher program
2 = no eye-catcher
When 114H is 0, this defines the sprite bank (the
upper eight bits of the character code) for the
eye-catcher sprites.
For Japan
For U.S.A.
For Europe (regions other than U.S. A.)
```
```
Defines the starting addresses of data for titles,
mode-select menu dips, etc., for each version, in
long words. (Contents of data mentioned
hereinafter.)
USER.
PLAYER-START
DEMO-END
COIN-SOUND'
```
```
Define the JMP commands for each program.
(Contents of the programs described later)
Defines the starting address of the Recognition Code
2 (in long words).
```
### ADDRESS

### 114H

### 115H

### 116H

```
1 lAH
1 lEH
```
### 122H

### 128H

### 12EH

### 134H

### 182H

### SIZE

```
(byte)
```
```
1 1 4 4 4 6 6 6 6 4
```

* Cartridge Recognition Code 2

```
Be sure to start with even addresses.
```
```
System Program - 8
```

- 3 --- GAME PROGRAM SPECIFICATION

The following terms will be used in the programming function descriptions that follow.

System Program - 9

```
Title
Address
Function
Conditions
Input
```
```
Output
Description
```
```
Subroutine name
Entry address
Summary of subroutine contents.
Conditions for entry
Input parameters required at time of entry into the subroutine.
B, W or L, following the address, stands for byte, word or long word,
respectively.
Output parameters returned at the exit of the subroutine.
Extra notes on the functions performed by the subroutine.
```

System Program - 10

```
Title
Address
Function
Input
```
Description

Description by

### USER

### 122H

```
Execution of the game's main program
Command No. (0-3) for the USER-REQUEST (lOFDAEH,B)
Other settings:
* 68000 registers
SR = 2700H
A7 (SSP) = 10F300H
Other registers: Undefined
* Work Area for the Game (10000elOF2FFH)
Only for the backup area of +h game. The values at the end of
the game, etc., are already undefined. Everything is undefined at
the time of command 0 start-up initialization.
* VO
Timer Interrupt: Not allowed.
Automatic Character Switching speed: 64/60 see.
(4OOOH is set to 3C006H.)
Vector: Switch to the game side.
Sound Reset Code (03): Already sent.
Other I/O: Undefined.
* Displays
Color Palette Banks: All 0s for both 0 and 1
Fix: All at 0020H.
Sprite: Vertical. Position (Active Characters)... all at 0 Horizontal
Position... all out of screen
Reduction Parameters... all at. OFFFH
Character Codes & Attributes: A11 undefined.
All game programs start when the system jumps to here (not a subroutine
call). Jump to SYSTEM-RETURN (C00444H) when processing is over
(when the game is complete, etc.). Also, call the SYSTEM-I0
(C0044AH) every 1/60 second.
User-Request Conditions
```
No 0 Start-up initialization
USER REQUEST = 0
Initialize onlfthe part defined (by the address 10EH-113H) as the backup
area of the work area used for the game. Normally, use this area for high
scores, rankings, etc. On the MVS, this command is called only once:
when the cassette is inserted into the main board for the first time.
Initialize the work area, excluding the backup area, screen displays, and
110, etc. every time USER is entered.


System Program - 11

No 1

No 2

No 3

```
Eye-catcher
USER-WQUEST = 1
A request is made only when the address 114H is 1. The call is not made
at any other time, nor with the MVS. Only one request is to be made right
after the home system is turned on.
Demo GamdGame
USER-REQUEST = 2
A demonstration of the title and the game is performed when a request is
made. Jump to SYSTEM-IZETURN when the demonstration is over and
the game has yet not been started. Or, if the game has been started, jump
to SYSTEM-RETURN after the game is over.
Title Display
USER REQUEST = 3
Only the game title is displayed. This command is requested only in the
mode with the MVS-forced start. At this point, the SELECT TIMER
(IOFDDAH, B) gives the remaining time in BCD, so please &lay this on
the screen. When the time runs out, instructions come from the system to
start the game. Therefore, there is no need for the game side to return to
the SYSTEM-RETURN. Everything else is the same as in the Command
2 game demo. (Please note that if the Game Start Compulsion is not set
for compulsion time, then the SELECT-TIMER is not used.)
```

System Program - 12

I
Title

Address

Function

Condition

Input

### PLAYER-START

### 128H

```
Game-Start Processing
A request is made, if the pressing of the start button is detected, with
sufficient credit, in the SYSTEM 10. Or, a call is made when the
MVS-forced start is past the time limit.
Starting Player in the START-FLAG (10FDD2H, B)
START- FLAG
d7 d6 d5 d4 d3 d2 dl dB
I
i -- l --I -- 1 -- i p4l p31 p2i pli
I I I!
```
(^1) I
start at "1"
Output Sets each bit of the STWFLAG to " 1" (as they are) if the game can be
started, or to "0" if not. (It is not allowed to change any bits from 0 to 1.)
When the game has been started, set the applicable byte to " 1" (game
status) where the USER-MODE (lOFDAFH, B) is 2 (normal game status,
PLAYER-MODE (10IDB6H-, 4 bytes)) during the demo.
r 1
I
10FDBGH PI1
10FDB7H P2!
10FDB8H P3i
/ 1IFDBSH I?g
L


System Program - 13

Description A call is made when the system instructs the game to begin. wen
starting the game from its own judgment, use the system subroutines
CREDIT-CHECK and CREDIT DOWN, described later.) With the
START FLAG, basically only t6e bit representing the player whose start
button & been pressed becomes 1. For during the MVS demo (the
USER - MODE at "I"), the following shows how it works:

### COUNTRY-CODE

### (10FD83H,B)

### 0 =JAPAN

### 1 =U.S.A.

### 2 =EUROPE

```
This means: On pressing the P2 START key, Japanese and European
specifications allow the two players to start the game simultaneously, while
the U.S. specifications allow only player 2 to start the game. Therefore,
for such games as sports games, where participation in the middle of a
game is not possible, the U.S. specifications require preselection of the
two-player game (refer to the sample program for these specifications).
When the game is in progress, an extension of play time or the addition of
lives is available at the player's option, and participation from the middle
of play should be available. If these options are not possible, or if it is a
game like Mah-Jong, which allows only one player to play, return after
changing the applicable bit to "0. "
```
```
If any of the START FLAG bits is firned with 1, the system deducts
credit. Therefore, be sure to perform the start processing, etc.
Furthermore, be sure to keep the USER MODE at 2, or the game may be
switched to another game.
```
### START-FLAG LOWER 4 BITS

### P1 START

### OOO1

```
OOO1
OOO1
```
```
P2 START
001 1
0010
001 1
```

```
Title
Address
Function
Condition
```
```
Description
```
[Note] PLAYER - START, DEMO-END and COIN-SOUND are all called from SYSTEM - 10.

### DEMO-END

### 12EH

```
Procedure to allow the demo to end early.
When a switch to another game is detected in the SYSTEM-10 during the
demonstration (only MVS)
In the MVS, switching to another game can be made by pressing the select
button during the demo. This switching interrupts the demo, so if
necessary store the items in the work backup area. The system returns
itself to SYSTEM-RETURN. Therefore, do not directly jump to SYSTEM
RETURN.
```
```
Title
Address
Function
Parameter
```
```
Explanation
```
[2] Data Referred to by the System

### COIN_SOUND

### 134H

```
Request to the Sound CPU(Z80) for the coindeposit sound
When the deposit of a coin or coins is detected in the SYSTEM - I0 (MVS
only)
Make a request to the 280 according to the specifications of the particular
game. Be sure to get a coindeposit sound in any setting or scene.
```
```
In conventional commercial games, the game's difficulty level, etc., was set using the
DIP switch on the board. With the MVS, the setting is performed by the memory switch
.using backup memory --, which is called "mode-select menu." Every game needs to
have data on default values, descriptions of items, and the contents of the modes. The
starting addresses are 116H, 1 1 AH and 1 lEH, which are defined in long words. (Refer
to page 9.)
```
* Data Format

```
System Program - 14
```
### ADDRESS

### (OFFSET)

### +O

```
+ 16
+32
+44
+56
```
### SIZE

### (BYTE)

### 16

### 16

### 12

### 12

### 12

### CONTENT

```
Game title
Mode-select default
Mode-select itemldescription of contents
Mode-select itemldescription of contents
Mode-select itemldescription of contents
```

```
(1) Game Title
```
```
Define the game title (16 bytes) in the common Fix code.
```
```
(2) Mode-Select Default
```
```
The mode-select menu can have up to 14 items. The beginning four items are reserved
for specific purposes, but the remaining 10 items can be used freely for each game.
```
(3) Description on Items and Contents of the Mode-Select Menu

```
This is the description on the items and contents for display when a change(s) in setting
the modes idare made on the screen. Define each in the 12-byte common Fix code.
Define only the names for items 1 through 4, but do not define an item(s) that are not
used. For the item 5 and above, define the item name, and the contents when set at "0,"
set at "1" and so on... up to 15.
```
```
r
Item No.
12
```
```
3
```
### 4

### 5-14

C

System Program - 15

```
Size
WORD
```
### BYTE

```
BYTE
```
### BYTE

```
Offset
+0, +2
```
### +4

```
+5
```
### +5-+ 15

```
Content
Setting of (extended) play time, etc. The
default values are set using BCD, with the
minutes in the upper byte and seconds in the
lower byte. Setting in seconds is possible in
the lower byte up to 29 minutes and 59
seconds. If this is not used, specify OFFFFH.
Set the remaining lives, etc., from 1 - 99
```
```
.
```
```
using binary code. Specify OFFH if unused.
The default value of the extended play is set
between 0 and 100 in binary, with 0 for no
extended play, 1 to 99 for the extended-play
limit, and 100 for unlimited extended plays.
Specify OM if unused.
This can be used freely for each game. The
default value (O-OFH) is set in the upper four
bits, and the content number (1-OFH) is set in
the lower four bits. However, if the lower
four bits are Os, items beyond this point are
not used.
```

```
[Setting Example 11
```
```
For a game based on remaining lives
```
### 1 DC. B

### 2

### 3 DC. W

### 4 DC. W

### 5 DC. B

### 6 DC. B

### 7 DC. B

8 DC. B
9 DC. B
10 DC. B
11 DC. B
12 DC.B
13 DC. B
14 DC.B
: 15 DC. B
16 DC.B
17 DC.B
18 DC. B
19
20 DC.B
21 DC.B
22 DC.B
23 DC. B
24 DC.B
25
26 DC. B
27 DC. B
28 DC. B
29 DC.B
30
31 DC.B
32 DC.B
33 DC.B
34 DC. B
35 DC.B
36
37 DC. B
38 DC. B
39 DC. B

```
' SAMPLE GAME1
```
```
OFFFFH
Ol'iErFFH
3
100
14H
13H
24H
01H
OOH
OOH
OOH
OOH
OOH
OOH
'HERO.
'CONTINUE
```
```
'DDFFICULTY ';ITEM5
'EASY 9. Y
```
. 'NORMAL 9. Y
    'HARD 9. '
    'VERY HARD 9. 9

### 'BONUS ';ITEM6

### 'NO BONUS 9. Y

### 'EVERY BONUS ';

### 'SECOND BONUS ';

### 'BONUS RATE ';ITEM7

### '20000/ 10000 9. 9

### '30000/ 10000 9. 9

### '50000/30000 .9 9.

### ' 1000001500000 9. 9

### 'DEMO SOUND ';JTEM8

```
'WITH '. 9
'WITH OUT %. 9
```
```
V)
(TIME)
(REMAINING Lm)
(EXTENDED PLAY)
```
### ITFM NAME

```
JTEiM NAME
```
```
ITEM NAME
0
1
2
3
```
```
ITEM NAME
0
1
2
```
```
ITEM NAME
0
1
2
3
```
### XTEW NAME

### 0

### 1

System Program - 16


```
On-screen display of initialization status and set values
```
```
Sample Game 1
(Set value)
HERO^3 3
CONTINUE NO LIMlT 100
DIFFICULTY NORMAL 1
BONUS EVERY BONUS 1
BONUS RATE 50000/30000 2
DEMO SOUND WITH 0
```
LINE 1 Specify the game title in 16 bytes.
LINES3&4 Define OFFFFH, since the game is based on remaining lives and time is
not used.
LINE 5 Set three lives.
LINE 6 Unlimited. number of extended plays ,.
LINES 7-10 Default values and numbers of conterits that can be set on items 5 to 8.
For example, for item 5 (DIFFICULTY LEVEL), four types can be set
fiom 0 to 3 (EASY, NORMAL, HARD, VERY HARD) with the default
value as 1 (NORMAL).
LINE 11 Since the lower four bits are at "0," items 9 through 14 are not used.
LTNES 12-16 Although these items are not used, space for data needs to be reserved.

LINES 17-18 Since items.^1 and 2 are not used, definition begins from item 3. But on
items 1 to 4, only item names are to be defined.
LINE 19 The name of item^5
LINES 20-24 Use words to express the contents of the set values from 0 to 3
respectively, for item 5. Four types of settings are possible, so four
descriptions are necessaryi

System Program - 17


```
[Setting Example 21
```
```
Game on a time-unit basis
```
1 DC. B
2
3 DC. W
4 DC. W
5 DC. B
6 DC. B
7 DC. B
8 DC. B
9 DC. B
10 DC. B
11 DC. B
12 DC. B
13 DC. B
14 ' DC. B
15 DC. B
16 DC. B
17
18 DC. B
19 DC. B
20
21 DC.B
22 DC. B
23 DC.B
24 DC.B
25 .DC. B
26
27 DC. B
28 DC. B
29 DC.B
30 DC. B
3 1
32 DC.B
33 DC. B
34 DC. B
35 DC. B
36 DC. B
37
38 DC. B
39 DC.B
40 DC.B

```
' SAMPLE
```
```
OO330H
OO3OOH
om
14H
03~
04H
01H
OOH
OH
OOH
OOH
OOH
OOH
OOH
```
```
'PLAY TIME
'CONT. TIME
```
```
'DIFFICULTY
'EASY
'NORMAL
'HARD
'VERY HARD
```
```
'BONUS
'NO BONUS
'EVERY BONUS
'SECOND BONUS
```
```
'BONUS RATE
'20000/10000
'30000/10000
'50000/30000
' 100000/50000
```
### 'DEMO SOUND

### 'WITH

### 'WITH OUT

```
W)
o=m
-G LIVES)
(EXTENDED PLAY)
```
### ITEM NAME

### ];];EM NAME

### ITEM NAME

### 0

### 1

### 2

```
3
```
```
ITFM NAME
0
1
2
```
### ITEM NAME

### 0

### 1

### 2

### 3

```
l3XM NAME
0
1
```
System Program - 18


```
On-screen display of initialization and set values
```
```
SAMPLE GAME 2
```
PLAY TIME 03 MINUTES 30 SECONDS
CONT. TIME 03 MINUTES 00 SECONDS
CONTINUE NONE
DIFFICULTY NORMAL
BONUS NO BONUS
BONUS RATE 20000/10000
DEMO SOUND WITH

```
(Set Value)
0330H
0300H
0
1
0
0
0
```
```
The set values are transferred to the work GAMRDIP (10FD84H-, 16 bytes) when
entering USER (122H). Therefore, refer to the values and carry out the applicable
process for each game. The system makes a change(s) in the modes or transfers the set
values to the work area, but does not process any of the contents whatsoever. Care must
be taken in this respect. When it comes to the home system, there is no display of the
mode-select menu, etc., so please set these modes freely for each game.
```
System Program - 19


-- 4 -- SYSTEM PROGRAMS SPECIFICATION

[I] System Programs

```
Enter the following by the JMP instruction instead of subroutines. Be sure to always
make the entry in the supervisor mode.
```
System Program - 20

```
Title
Address
Function
Condition
```
```
Description
```
### SYSTEM-INTI

```
C00438H
System Level 1 Interrupt Program
When it is determined that it is in the system mode at the beginning of the
level 1 interrupt. If bit 7 in the SYSTEM-MODE (lOFD80H, B) is at "0,"
it is determined to be in the system mode, and if at " 1" it is in the regular
game mode.
At the time of entering USER (122H), the 0-7FH exception handling vector
from the game is used, and bit 7 in the SYSTEM-MODE is at 1-the game
mode. When the system is in full operation, the vector from the system is
used, and the bit 7 in the SYSTEM-MODE is at &the system mode. If
the vector is mapped onto the emulation memory when switching vectors or
debugging and vector switching is not possible, the vector from the game
may be selected even in the system mode. In this case, jump to the
SYSTEM-INTI at the beginning of interrupt " 1" for the game.
Furthermore, the SYSTEM-INTI is involved only in accessing the
SYSTEM 10, MESS-OUT (described later) and watchdog. Therefore, for
games wig long "no interrupt" times directly after entering USER, the
game itself can allow interrupts by placing a "0" for bit 7 of
SYSTEM - MODE at that time.
```

System Program - 21

Title

Address

Function

Parameter

```
S Y STEM-RETURN
C00444H
Returns from the game program to the system program.
This subroutine should be called when all jobs are Fihed after USER
entry.
```

```
System Subroutines
```
```
There is no guarantee that the contents of the registers are preserved afkr the program
exits a subroutine.
```
System Program - 22

Title

Address

Function

Condition

Description

### SYSTEM-I0

### C0044AH

```
Input and output operations from the system program.
This subroutine should be called every 1/60 of a second during the game
program. When it is called outside of the interrupt-handling routine, and if
the program needs to access the If0 besides the screen using the intermpt-
handling routine, prohibit the interrupt request while SYSm-I0 is
executed, which takes about 300 micro seconds on average.
This subroutine executes the following:
```
```
1 Senses joystick-input status.
2 Detects coins inserted in the slot (MVS only). If required,
COIN_SOUND(134H) is called.
3 Checks the start button. If required, PLAYER - START(128H) is
called.
```
(^4) Checks the game selection (MVS only). If necessary,
DEMO END(l2EH) is called and the game is selected.
5 ~imers;sed by the system are counted up or down.
To detect the coin input precisely, this routine needs to be called every
1/60 of a second. In general, it is recommended that this routine be called
at the end of the interrupt-1 handler routine. However, if this is called
from the main routine and not from the interrupt-1 handler routine due to
the V-RAM output and such, be sure that the processing does not overflow.
Since the coin-input detection routine also controls the credit status, that the
game program does not have to execute any coin-related tasks.
Status of the joystick is stored in the work area, INPUT l(lOFD94H), and
the game routine can read the status from this work ar;rather than
reading it directly from U0.


```
Title
Address
Function
Input
```
```
Output
```
```
Description
```
System Program - 23

### CREDIT-CHECK

### C00450H

```
The system verifies the credit status.
In addresses CREDIT-DEC (IOFDBOH, B) and CREDIT-DEC + 1, put
the number of credits (BCD, 0-99H) needed for player 1 and player 2
respectively.
Unchanged if the content of CREDIT-DEC (IOFDBOH, B) and
CREDIT - DEC + 1 is sufficient to start the game. Otherwise it's set to
"0. "
Before the game program can start the game or add remaining lives without
using PLAYER-START, the credit should be confirmed first using this
subroutine. The game program can use this routine to simply check if the
player can start the game, because it only checks the credits left.
```
Title

Address

Function

Condition

Input

Description

### CREDIT-DOWN

```
C00456H
Credit deduction executed by the system.
After the system checks the credits by calling the CREDIT - CHECK
routine.
Place the exact returned values from CREDIT-CHECK for CREDIT - DEC
and CREDIT-DEC + 1.
Credits are deducted by the value of CREDIT-DEC, and the system
executes the operation in preparation for starting a game. Be sure to
execute the processing to start the ghes in the game program.
```

```
Title
Address
Function
Condition
Output
```
```
Explanation
```
### READ-CALENDAR

### C0045CH

```
Reading from the calendar
MVS only
Current date and time data are stored in seven bytes, starting from the
address label DATE-TIME (10FDD2H, seven bytes).
+O Year Last two digits of the year in BCD
+1 Month Two digits in BCD (1-12)
+2 Day Two digits in BCD (1-3 1)
+3 Week 0 to 6, starting from Sunday, Monday,...
Saturday.
+4 Hours Two digits BCD (0-23)
+5 Minutes Two digits BCD (0-59)
+6 Seconds Two digits BCD (0-59)
This subroutine is only for the MVS. Use this for updating the ranking
and beekeeping at certain intervals.
```
```
Title
Address
Function
Output
```
### FKCLEAR

### C004C2H

```
Clears the fix display.
Put 020H (opaque character) on the entire line at both sides, and puts
OFFH (transparent character) in the rest of the Fix display area. These two
characters are defined as common Fix characters.
```
```
Title
Address
Function
Output
```
System Program - 24

```
LSP-1st
C004C8H
Initializes the line sprite.
Set the following values to line sprites 1 to 380:
V-POSITION : 0
H-POSITION : Off the screen
Reduction Ratio: OFFFH
However, the character codes and attributes are not changed.
```
Title

Address

Function

### MESS-OUT

### C004CEH

```
Generic V-RAM output (explained later)
```

Title

Address

Function

System Program - 25

### CARD

### C00468H

```
Access to the memory card (explained later in more detail)
```
Title

Address

Function

### CARD-ERROR

```
C0046EH
Handles memory card errors. (explained later in more detail)
```

```
131 System Work Area
```
```
An asterisk following the name indicates that the value is written by the game. Do not
write into the others or undefined memory addresses.
```
-
    Title
    Address
    Description

### SYSTEM-MODE

```
10FD80H 1 byte
Current software mode status:
bit 7 = 0 system mode
1 game mode
The system is not triggered by the game-start button and game-selection
button while it is in the system mode. (Therefore, PLAYER-START
would not be called.) During the interrupt-handler routine of the game
program (such as during game initialization), and when PLAYEiR-START
cannot be called, the system m be in the system mode temporarily, but
will return to the game mode as soon as possible.
```
```
Title
Address
Description
```
### MVS-FLAG

```
10FD82H 1 byte
Indicates if this system is for commercial or home use.
0 Home use
other values Commercial use
```
```
Title
Address
Description
```
System Program - 26

### COUNTRY-CODE

```
10FD83H 1 byte
Country specification:
0 Japan
1 USA
```
(^2) Europe (or countries other than Japan and USA)
This information is used to select the language to be used in the game and
the type of coins to accept. (Refer to the PLAYER - START section about
the coin system.)
Title
Address
Description

### GAMRDIP

```
10FD84H - 10FD93H 16 byte
Game parameters of each game.
```

```
System Program - 27
```
```
Title
Address
```
Description

### INPUT-1

```
10FD94H - 10FD99H 6 bytes
Current status of Controller 1.
+O Controller 1 status
0 = No connection
1 = Normal controller
2 = hpanded controller
3 = Mah-jong controller
4 = Keyboard
```
```
This value is set when the program jumps to SYSTEM-RETURN after the
reset.
+ 1 Controller^1 : Status from 1/60 second before
+2 Controller^1 : Current status
+3 Controller^1 : Active-edge flag
+4 Controller^1 : Auto-repeat flag
+5 Controller 1 : Repeat timer
```
```
Values in addresses PUT 1 + 11 to mUT_1 + 41 are expressed in
positive logic, and bit assign;hents are:
```
```
d7 d6 d5 d4 d3 d2 dl do
```
```
D
```
```
Example:
```
```
................ .,'.
----C-J.-A----L-J --.-- LLA--I--LLL--. ---.-.-.---------
<- 16/60sec-> < -8/60sec-> <-8/60sec->
+1 ?0101101--..1.....-1..... 1
+2 01011011..-- 1......1..... 1
+3 01010010 ....0......0.... 0
+4 010106100*-010~-~-01~~~-~~
```
```
The value in address WUT-1 + 31 is set to " 1 " only when the status
changes from OFF to ON. The value in address PUT-1 + 41 is set to
" 1" when the status changes from OFF to ON and at a fixed interval if the
switch is kept ON. (After 16/60 second from the first active edge, and
every 8/60 second thereafter.)
Because the auto-repeat flag monitors all the bits of the byte, if there is a
change on another bit, it will immediately be set to " 1," even before the
time interval mentioned above elapses.
```
### C B A RIGHT LEFT BOTTOM TOP


```
Even if the value of WUT-1 + 0] (status) is "0" (no co~ection), all the
values are set, assuming that a normal controller is connected, but there is
no input if the controller status is 4 (keyboard).
When the controller status is 3 (mah-jong), the switches are set as the
follows:
d7 d6 d5 d4 d3 d.2 dl do
```
```
System Program - 28
```
Title

Address

Description

### INPUT-2, 3, 4

### 10FD9AH, IOFDAOH, 10FDA6H

```
Status of controllers 2, 3, and 4 are set.
The contents are the same as for INPUT-1.
When the controllers are expanded, they are assigned as follows:
INPUT-1 = controller 1A
INPUT-2 = controller 1B
INPUT-3 = controller 2A.
INPUT-4 = controller 2B
When a controller for mah-jong is used, the active-edge flags of controllers
1 and 2 are set in the addresses INPUT-3 and INPUT - 4 respectively.
```
```
These values are the raw data; the active-edge flags are set in the addresses
starting from INPUT-3 with the same address offset (positive logic).
```
```
These controller input values (addresses NUT-1 + 11 to NUT-1 +5])
are set by the SYSTEM-I0 subroutine.
```
### D

### M

```
Ron
```
### +1

### +2

### +3

### F

### M

-

### E

### L

```
Reach
```
### C

### J

```
Kan
```
-
-
-

```
G
N
```
-

### B

### I

```
Chi
```
### A

### H

```
Pong
```

1 Description

~itle

```
Address
When controllers 1 and 2 are normal controllers, INPUT-5 and INPUT-6
will have the same values as those in INPUT-1 and INPUT-2. When the
controller is for mahjong, the values are converted to those of the normal
controller. The following is the table of conversion:
Mah-jong l~ormal
```
### INPUT-5, 6

```
lOFEEBH, lOFEEEH
```
IC button

```
I
[C button (bit 6) 1
```
```
A b&np
B button
```
```
A button (bit 4)
B button (bit 5)
```
```
D button
E button
```
IH button 1 ~oystick right (bit 3) --I

```
D button (bit 7)
Jovstick UD Cbit 0)
F button
G button
```
```
Joystick down (bit 1)
Joystick left (bit 2)
```
```
System Program - 29
```
Title

Address

Function

### INPUT-S

```
10FDACH 2 bytes
Status of the start button and select button
+O Raw data
+ 1 Active-edge flag
Both are in positive logic..
```
```
Bit format is as follows:
d7 d6 d5 d4 d3 d2 dl do
P4
Select
```
```
The select button is not sensed in MVS mode. (It is used to select games.)
```
### P4

```
Start
```
### P3

```
Select
```
### P3

```
Start
```
### P2

```
Select
```
```
P2
Start
```
### P 1

```
Select
```
### P1

```
Start
```

```
Title
Address
Description
```
### USER-=QUEST

### 10FDAEX 1 BYTE

```
A command number is set here when USER (122H) is executed.
0 = Start-up initialization
1 = Eye-catcher
2 = Demonstration game
3 = Title only
```
```
Title
Address
Description
```
```
USERMODE [*I
lOFDAFH 1 byte
Set the current status of the game program with the game software.
0 = Start-up initialization, eye-catcher
1 = Title, game demo
2 = Game in progress
Game selection is enabled only when the mode is " 1" for the MVS. Make
sure to change the mode to "2" when the game starts after the demo.
```
```
Title
Address
Description
```
System Program - 30

```
CREDIT-DEC [q
10FDBOH 4 bytes
Before calling CREDIT-CHECK and CREDIT-DOWN, set the necessary
credits for each player here in one byte of BCD for each player. (Set 0 for
the player who is not playing.) Use the exact returned value from
CREDIT-CHECK when calling CREDIT - DOWN.
```
Title

Address

Function

### START-FLAG

```
10FDB4H 1 byte
Player(s) who is starting the game is indicated when PLAYER - START
(128H) is called. (Refer to PLAYER START for details.)
START-FLAG is valid only when PLAYER START is called; the value is
undefined otherwise. Do not use this value directly in the game program.
```

```
Title
Address
Function
```
```
(Address
```
```
PLAYER - MODE [*I
10FDB6H 4 byte
Set the current status of the players in the order of player 1, 2, 3, and 4.
0 = Never played a game
1 = Currently playing
2 = Continue option being displayed
3 = Game over
```
```
Title
Address
Description
```
```
Address
```
```
Address
```
```
DATE - TIME
10FDD2H 7 byte
The current date and time are set when READ-CALENDAR is called.
(Refer to READ-CALENDAR for the data format.)
```
```
Function
```
L

```
C-COMMAND [*I
1OFDC4H 1 byte
CARD-ANSWER [*I
10FDC6H 1 byte
CARD START r*i
10FDC8H 1 long word
CARDSIZE I*]
lOFDCCH 1 word
CARD_FCB [*I
lOFDCEH 1 word
CARD-SUB [r
lOFDDOH 1 byte or 1 word
Addresses listed above are used when CARD(C00462H) and
CARD - ERROR(C00468H) are called.
The memory card functions are explained in detail in Section 6 "Memory
Card," p.47.
```
```
MESS-BUSY I*]
lOFDC2H 1 byte
If the value is not "0," MESS-OUT (generic V-RAM output routine) is
skipped. Always put "0" before calling CARD-ERROR.
```
System Program - 3 1


```
Title
Address
Function
```
System Program' - 32

```
MESS-POINT [*I
lOFDBEH 1 long word
Set pointer for MESS-OUT. Refer to "Using MESSPUT," p.37
for more details.
```
Title

Address

Function

### SOUND-STOP

```
D00046H 1 byte
If this is set to "0" in the MVS, do not play any demo sound regardless of
the settings in the mode-select menu (except for sound effects for coin
insertion).
This work area is located in the backup memory, and cannot be accessed
by the system for home use.
```

__ 5 --- COMMON FIX CHARACTER CODE AND GENERIC V-RAM OUTPUT

[I] Common Fix character code
The data displayed by the system for mode-select menu and such, should use the
following common Fix character code:

```
TYPE 1
Used for the game title and data title in the ,memory card
i TYPE 2
Used exclusively for explaining the mode select menu
TYPE 3
Used for displaying all information on overseas versions
```
```
In the table, [SP] (20H) denotes the "SPACE" character. All three types have OFFH
assigned for the 'end' code, so Om;H cannot be used in the data.
One Kanji character of TYPE 2 occupies two bytes. (e.g. Kanji character WAN] can
be defined as OOH, 01H.)
```
```
System Program - 33
```

Used Exclusively for Japanese
MESS - OUT Output Command 9

System Program - 34


Used Exclusively for the Mode Select Menu
MESS - OUT Output Command 8

```
System Program - 35
```

```
Used Exclusively for English
MESS - OUT Output Command 8
```
```
: '1'
```
(^601) 1:: iaibicidieif!g: i f hi: jikj i l]mino , I
70 p. 'qj rjs~t:~'v~~ix:y~z: .. i!i : '. i ; ,
! i i! 1
System Program - 36


```
[2] Using MESS-OUT (Generic V-RAM Output)
```
```
All messages displayed on the screen by the system must use MESS-OUT. MESS-OUT
is called during interrupt 1 (SYSTEM-INTI) by the system, and even for the game, if
this is called at an appropriate area, it can be used.
The output method is as follows: the addresses of output data are stored in the
MESS - BUFFER (lOWOOH), and when MESS-OUT is called these are output all at
once.
```
(1) Output Data Format

```
There are two types of data output with MESS-OUT: a series of control commands and
the actual output data accessed by those commands. The control command is made up
of one word, the lower byte is used for the command number, and the upper byte or the
next (long) word is used for the parameters. Since the control commands are made in
word units, the starting address must start from an even address.
```
System Program - 37

```
Command
0
```
```
Command
1
```
```
Command End Code
This means that a series of control commands has ended.
```
```
Example DC. W 0 -- End of Command
```
```
Data Format
This specifies the format of the data to be output.
Command upper byte
do O=End code specification 1 = Data size specification
dl O=Bytedata 1= Word data
Next word
With byte data
Upper byte Upper byte data that is commonly output
Lower byte End code or data size
```
```
With word data
End code or data size
```

..

System Program - 38

Command
1
(Continued)

```
Example 1:
```
```
End code
Output upper byte
```
```
In this case, the output data is made up of only the lower byte, and the
upper byte is 12H as specified. Also, FFH is the data end code.
Therefore, FFH cannot be placed in the lower byte.
```
```
Data size specification
Command 1
```
```
In this case, the output data is made up of only the lower byte, and the
upper byte is 34H as specified. Also, the data size is constant at 16 bytes,
and H through FFH cannot be placed in the lower byte.
```
```
Example 3: DC.W 0201H, OOOOH
```
```
Word data End code
End code specification
Command 1 1
```
```
In this case, the output data is made up in words, so the upper byte can be
changed in word units.
```
```
Data size specification
Command 1
```
```
The data size is constant at 32 bytes.
```
```
The format set here is valid until it is specified again using command 1, so
it is not necessary to specify this for every output if they are in the same
format.
```

System Program - 39

```
Command
2
```
Command
3

```
The setting of the automatic increment amount
Command upper byte: Increment amount
(Character expansion to 16 bits and output to 3C0004H)
```
```
Example: DC-W 2r
```
```
Automatic increment
20H Command 2
```
```
Output V-RAM address
The next word is output directly to 3COOOOH.
```
Example: DC. W 1, "p" "P"

```
Command 3 V-RAM address
```

System Program - 40

Comhand Output data address
The starting address of the output data is specified in the next long word.
(If word data was specified in command 1, please start from an even
address.)
The data is actually output with this command.

```
Example 1: DC.W 1
```
```
c Data format
Byte data
End Code WH
DC.W 4 Command 4
DC.L MESSAGE1 Starting address of data
..................................
MESSAGE1 : Output data
DC.B 'SAMPLE,' m;H
```
Example 2: DC.W 3 1H

```
32- Data format
Word data
Data size 3
DC.W 4 Command 4
DC.L MESSAGE2 Starting address of data
..................................
MESSAGE2: Output data
DC.W 130H, 1131H, 3033H
```

System Program - 41

Command
5

Command
6

```
Address increment amount
Add the amount specified in the next word to the V-RAM address output
previously, and this is used as the output address. (Output to 3COOOOH)
```
```
Example:
DC. W 1, OFFH Data format
Byk data
End code OFFH
DC. W 3, 7202H V-RAM address
(Fix character)
DC. W 102H Automatic increment 1
(Fix character vertical output)
DC. W 4
DC.L DATA1 Data output
DC.W 5, 20H one line to the right
DC.W 4
DC.L DATA2
DC. W 5, 41H two lines to the right and one line down
DC. W 4
DC.L DATA3
DC. W 0 Command end code
```
```
Resume the output of data previously output
```
```
Example:
DC.W 4
DC.L DATA4 Data output (1)
DC.W 5,20H Address change
DC.W 6 Output the rest (2)
...................................
DATA4:
DC.B 0, 1, 2, 3, 4, OFFH (1)
End code
DC.B 5, 6, 7, OFFH (2)
```

```
System Program - 42
```
```
Command
7
```
```
Directly define the output data
```
```
Example:
DC.W 7 Direct data definition
```
```
End code
One-byte dummy so that the next command will be an even address
(This is necessary if the total data size is odd, but not necessary if the size is
even.)
```
Command
8

```
Fix 8x16 dot-matrix character horizontal output
The toplevel output upper-byte data is placed in the upper byte of the
command. The lower-output byte data is placed from the next byte on.
me end code is 0m;H.)
The bottom level will output the data in the first address following the upper
byte*
```
```
Example:
DC.W 3, 7101H Output address
DC.W 108H Command 8
upper byte data
```
```
Output data
```
V-RAM after output

### ADDRESS 70101

### DATA

```
If the output data size is odd, one byte must be placed after the end code as
a dummy.
```

```
System Program - 43
```
```
Command
9
```
```
Command
A and B
```
Command
C

```
Fix 8x16 dot-matrix Japanese character horizontal output
The format is the same as command 8. However, codes 0-1FH are changed
to hiragana with voiced sound symbols, and code 60H-7FH is changed to
katakana with voiced sound symbols. (Exclusive for common Fix TYPE 1)
The automatic incrementing function is set in 20H for commands 8 and 9.
```
```
Subcommand calling (A) and return (B)
The pointer is moved to the address specified by the long word after
command A, and command B returns the pointer to the original location.
Up to four levels of these subcommands can be nested. However, command
0 (end command) cannot be used within the subcommands.
```
```
Example:
DC.W OAH Call
DC.L SUB-COMMAND
DC.W 0
........................................
SUB-COMMAND:
DC.W 7
DC.B ' XYZ', OFFH
DC.WS OBH Return
```
```
Continuous output of the same data
The data specified in the next word is output continuously the number of
times specified by the upper byte of the command.
```
```
Example:
DC.W2 H, 0020H
```
```
Number of times to repeat=32
Command C JL+ Output data
```
```
0020H is output continuously 32 times.
```

```
(2) Output Data Set
```
```
Command
D
```
```
Set the starting address of the output data (control command) in long word from the
```
.. address indicated by MESS POINT (IOFDBEH, L). Then, increment MESS POINT
    by four. If MESS OUT is g%ng to be used for interrupts, set MESS-BUSY (IO~%~C~H,
    B) to a value oth& than 0 so that processing does not coincide. By doing this even if
    MESS-OUT has been called, processing can be skipped. Also, even when simply
    accessing the V-RAM, if MESS - OUT is called, the V-RAM address may change. Be
    sure to use MESSBUSY.
    MESS-POINT points to MESS-BUFFER (10FFOOH) directly after the output for
    MESS OUT has been finished (when no data is set), and since the buffer size is 256
    bytes, ik sure not to exceed this size.
    When 0 is set for the control-command address, a control command can be placed from
    the next address in the MESS-BUFFER.

```
Data increment output
The data specified in the next word is continuously output by being
incremented the number of times specified by the upper byte of the
command. Only the lower byte is incremented for the data, and the upper
byte is not increased.
```
```
Example:
DC. W 200DH, 1 180H
```
```
Number of times o repeat=32 First output
Command D *-
```
The data is output in the sequence 1 180H, 118 lH, 1182H,... , 119FH.

System Program - 44


Sample Program

### ADDQ. B

### HOVE. L

### MOVE. L

```
MOVE. W
MOVE. W
HOVE. Y
MOVE. W
HOVE. W
HOVE. W
HOVE. W
HOVE. L
HOVE. L
SUBQ. B
```
### 81, MESS-BUSY

### HESS-POINT, A0

### #0000H, (A0) +

### #0003H, (LO)+

### #7318H, (A01 +

```
#030lH, (A0) +
#0001H, (A01 +
#0007H, (80) +
100000H, (A01 +
$0, (B0)+
#HESSAGEl,(AB)+
dB, HESS-POINT
$1, WESS-BUSY
```
### DC.W 0003H

### DC.W 7024H

### DC.W 00048

### DC. L MS 1

### DC.W 0005H

### DC.W 0001H

### DC.W 0006H

### DC.W 0005H

### DC.Y 0001H

### DC.Y 0007H

### DC.B 'MESSAGE 3 '

### DC.B 0FFH

```
Dc 8 a
```
```
fbusy flag set
;pointer get
;buffer direct comnand
;COMMAND 3
f output v-ram address
;COMMAND 1
; 1 uord data
;COHMAND 7
; output data
;COMMAND 0 (comnand end)
;next conmand address set
;pointer set
;busy flag clear
```
### ;COHHAND 1

```
; byte datasend code type
; data hi-byte 0,end code 0FFH
;COMMAND 2
; auto increnent 20H
;COMMAND 3
; output v-ran address
;COMMAND 4
; output data address
;COMMAND 5
; 1 line down
;COMMAND 6
; data continue- output :
;COMMAND 5
; 1 line down
;COMMAND 7
; output data (8 byte)
; data e~d code
f dummy for even address
```
```
System Program - 45
```

```
DC.4:
DC.Y
DC. W
```
```
DC.B
DC. U
DC.1
DC.W
```
```
DC. B
DC. !!
DC-L
DC. Y
DC. L
DC. W
DC.L
DC.W
DC.L
DC.Y
```
```
Hsl:
DC. B
DC.8
```
### 0,1,2,3,4,0FFH

### 000AB

### SUB-KESS

### 000A8

### SUB-MESS

### 000BB

### SUB-HESS

### '000AH

```
SUB -fiESS
00001
```
```
'HESSAGE 1 ' , 0FFH
'MESSAGE 2',0FFH
```
```
SUB-XESS:.
DC. W , 280CH
DC. W 00208
DC.W l00DH
DC.W 0500H
DC.JJ 000BH
```
### ;COMIYAMD 5

```
; 1 line dok-n
;COMMAND 8
; data hi-byte 1 & 2
f output data & end code
;COMMAND 5
; 1 line down
;COHMA.ND 9
; data hi-byte 1 & 2
; output data 8 end code
;COMMA!VD X
; sub comnand address
;COMMA~D A
; sub conmand address
;COMMAND A
; sub connand address
;COMMAND A
; sub conmand address
;COMMAND 0
; comiand end code
```
```
;output data
; 1st output data
; 2nd output data
```
```
;sub comnand
;COWWAND C
; B020H 40 times output
;COMMAND D
; output 0500H, QSBlH,... ,050FH
;COMMAND B
; sub connand return
```
If an error is detected during data output for MESS-OUT (such as an overflow of the command
number), then the output is stopped at that point.

System Program - 46


```
--- 6 --- MEMORY CARD
```
```
[I] Game Data Structure on the Card
```
```
The game data on the memory card is composed of the following four items:
Game Number (Game ID placed in 108H)
Sub-Number (16 types (0 through 15) for each game)
Data Title (20 bytes)
Game Data (64 byte units)
```
```
The memory card is divided into directories, FAT and data, as with floppy disks, and
these are controlled by the system.
```
```
The game number and subnumber are placed in the directory. Multiple data can be
placed for one game using subnumbers (for example, data for one-player games and two-
player games).
```
```
The game data is controlled in page units, and one page is 64 bytes. However, the data
title takes up 20 bytes for the fist page, so only 44 bytes can be used for data. (The full
64 bytes can be used from the second page onward.)
```
[2] Memory Card Access

```
Accessing the memory card can be done by setting the parameters in the workspace for
the card from 10m)C4H, and calling CARD (C00468H). Please do not access the card
directly from the game besides special cases. '
The command result is returned in CARD-ANSWER (10FDC6H, B). "0" means that
the command has been successfully executed, and other values signify that some error
has occurred, and the value represents the type of error.
```
System Program - 47


```
Command
```
```
Input
```
```
Command
```
```
Input
```
```
Output
```
System Program - 48

```
Format
```
```
Command
```
Input

```
CARD-COMUAND byte
```
```
Data search
```
```
0
```
```
CARD-COMMAND byte
```
CARD - FCB word

```
CARD-SUB word
```
```
Data Load
```
```
This formats the memory card. All data in the card will be lost.
```
### 1

```
Game number
```
```
If bit n is "0," the data does
not exist for sub-number n of
the game number given by
CARD FCB. " 1 " means the
data eiists.
```
```
CARD-COMMAND byte
```
```
CARD-FCB word
```
```
CARD-SUB byte
```
CARD - START 1 word

```
CARD-SIZE word
```
```
Example: Call CARD-FCB by setting the parameter as 1234H, and if
the result CARD-SUB is 01 10000010000101B, the data in
the subnumbers 0, 2, 7, 13, and 14 exists for game number
1234H.
```
### 2

```
Game number
```
```
Subnumber
```
```
Data-load address
```
Output The smaller size is selected between the data size on the card and the size
specified by CARD-SIZE. The game data is loaded up to the smaller size
selected, from the address indicated by CARD START.
The game title is set in the beginning 20 bytes:


```
System Program - 49
```
Command

Input

```
Data Save
```
```
CARD-COMMAND byte
```
```
CARXFCB word
```
```
CARD-SUB byte
```
```
CARD-START 1 word
```
```
CARDSSIZE word
```
### 3

```
Game number
```
```
Subnumber
```
```
Data-save address
```
```
Save data size
```
```
Set ,the data title in common Fix code (TYPE1 for domestic and TYPE3
for overseas) for the beginning 20 bytes of save data. This is used for
directory displays, etc., so please try to show the game title and the
necessary data.
```
```
(For example,
"Baseball VS. 1P"
"Baseball vs. 2P"
"Baseball Tournament"
```
```
The starting address and data size must be even values for data load and
data save.
```

```
Command
```
Input

System Program - 50

Command

Input

Output

```
Data Delete
```
```
CARD-COMMAND byte
```
CARD - FCB word

```
CARD-SUB byte
```
```
Reading the data title
```
### 4

```
Game number
```
```
Subnumber
```
```
CARD-COMMAND byte
```
CARD - START 1 word

```
CARD-SIZE word
```
```
This deletes the specified data.
```
### 5

```
Data title/set address
```
```
Directory number
```
```
If CARD SIZE is n, the data title in the nth game data in the card
directory% set in the 20 bytes beginning with the address indicated by
CARD - START. Other output is as follows:
```
```
CARD-FCB word
```
```
CARD - SUB byte
CARD-SIZE word
```
```
Game number
```
```
Subnumber
```
```
+1
```
```
All data titles on the card can be observed by first setting "0" to the
CARD SIZE and by calling this routhe until CARD-ANSWER reaches
82H (no data).
```

Note About Data Loading

```
Command
```
```
Input
```
```
Command
```
```
Input
```
```
The system does not check the game data, so please use the data after checking the
contents for each game. Please do not allow for errors to occur from data corruption or
improper changes made by the user. We prohibit running the program directly on the
loaded data and on the memory card.
```
System Program - 51

```
User Name Save
```
```
CARD-COMMAND byte
```
```
CARD-START 1 word
```
### 6

```
User name address
```
```
User Name Load
```
```
CARD-COMMAND byte
```
CARD - START i word

### 7

```
User namejload address
```
```
The user name (16 bytes) can be specified for every memory card. (All are
20H during formatting.) The domestic format is Fix code TYPE1 and the
overseas format is TYPE3. Saving and loading is performed from the
address indicated in CARD-START.
```

```
[3] Error Codes
```
```
The result of the call made to CARD is returned in CARD-ANSWER (10FDC6HY B).
```
[4] Error Processing

### CODE

### OOH

### 80H

### 81H

### 82H

### 83H

### 84H

### 85H

```
Some of the error handling for errors caused by the card may be performed by the
system by calling CARD ERROR (C0046EH). Call CARD-ERROR by sending the
exact parameters (iicludin~ CARD-ANSWER) returned from the card.
The result of error handling is prompted with CARD-ANSWER. If "0" is returned, the
previous command had been successfully executed after error handling, and other values
denotes that the command cannot not be executed.
During error handling the system handles the screen display, so set MESS BUSY
(IOFDCZH, B) to "0." The screen goes back to the previous display after thereturn
from error handling.
```
```
Description
```
```
Normal completion
```
```
The card has not been inserted.
```
```
The card has not been formatted.
```
```
The specified data does not exist.
```
```
FAT irregularity
```
```
Data full (insufficient data area).
When saving data, if the same game number and sub-number already exist,
the old data is deleted after the new data is saved.
```
```
Write disable. Or, a ROM card.
```
System Program - 52


** Details of Error Handling **

j ERROR 1 CARD - COM34AN.D j i

```
A. This displays the error status.
B After verifying that the card can be formatted, the card is formatted and the
command is executed. (However, for commercial-use machines, formatting is
done automatically without confmation.)
C All data titles in the card are displayed, and allowing the user to select the data
for deletion to obtain more memory. Then, the data is saved. (This procedure
can be canceled.)
```
- Nothing is performed.

```
If the same data exists when the card is full and the size of the data to save is the same
as the already existing data, save the new data after deleting the old data. This is to
prevent the players from having to perform extra operations for error handling, as much
as possible.
```
```
System Program - 53
```

--- 7 -- SOUND PROGRAM

```
The program specification for the sound CPU (280) can be done freely, but there are
some sound codes that are standard specifications.
```
```
CODE '1 Slot-Switching
```
```
Cancel all sounds and enter an infinite loop in the work RAM after enabling the NMI.
Retum " 1" to the 68000 right before entering the infinite loop.
The system waits for "1" to be returned from the 280, and slot switching is done.
Returning a " 1" to the 68000 is prohibited if a sound code other than " 1" is received.
(Always return a code other than " 1." If " 1" is left carelessly, slot-switching is done
before the 280 is ready.)
```
Code 3 280 Reset

```
Perform the same process as the hardware reset. Complete the reset process within
lOOm seconds.
```
Code 2 Eye-catcher Sound

```
This is used only when the eye-catcher is done by the system. (When the main CPU's
memory location 114H is "0") Mow this to be executed in any condition once code 3
has been received.
```
```
Allow codes 1 and 3 to be received with NMI as much as possible. In that case, the next
NMI is not executed unless the 280 executes RETN, so be sure to execute RETN. Also,
allows these two codes to be executed in any condition.
```
System Program - 54


___ g --- USING THE MONITOR PROGRAM

```
A simple monitor function is provided in the system ROM for development. The
monitoring is started up from specific-exception handling. (Refer to game ID for
details.) In particular, monitoring starts for the bus error when jumper 11 on the board
is short-circuited.
```
```
Monitor Screen
```
```
Error Name
```
```
Access Information Memory Access Address Operation Word
```
```
Only for bus errors and address errors
```
```
DO Dl D2 D3
D4 D5 D6 D7
A0 A1 A2 A3
A4 A5 A6 A7 (SSP)
USP SR PC
```
```
Monitor Command
```
Monitor Commands

DISPLAY MEMORY Displays the memory contents
DISPLAY V-RAM Displays the V-RAM contents
MODIFY MEMORY Modifies the memory
MODIFY V-RAM Modifies the memory
MODIFY REGISTER Modifies the registers
TRACE Trace mode (step-by-step execution)
RUN Runs the program (exits the monitor mode)

```
The command switches by using button A, and the command is executed with button C.
The horizontal and vertical movements of the joystick change the parameters.
The memory is accessed in words.
```
```
System Program - 55
```

--- 9 --- POINTS TO NOTE WHEN CREATING A GAME

1. Call SYSTEM-I0 every 1/60 of a second.
2. Most VO-related processing are performed by the system, so please do not access
the VO directly with the game software except for special cases. The addresses
that are not defined by hardware may be phantom addresses, so be sure never to
use these addresses.
3. Be sure never to write anything in the system work area (10F300H-10FFFFH)
except for the area to be set by the game software and the backup RAM
(D00000H-DOWFH).
4. Be careful in using flags for the game starting processes, since these processes are
especially known to be problematic.
5. Please do not place any important displays in the 32 dots at both the left and right
sidq and eight dots at both the top and bottom on the screen. (These areas may
not be displayed, depending on the monitor.

System Program - 56


### --- 10 --- SAMPLE PROGRAM

### DC. L

DC.L
DC - L
DC. L
DC. L
DC. L
DC. L
DC-L

DC. L
DC.L
DC. L
DC.L
DC. L
DC.L
DC. L
DC.L

DC.L
DC-L
DC.L
DC. L
DC.L
DC-L
DC.L
DC. L

DC. L
DC.L
DC.L
DC.L
DC.L
DC.L
DC-L
DC.L

```
0
```
```
10F300H
0C00402H
0C00408H
0C0040EH
0C00414H
ZD-ENTRY
CHK-ENTRY
TARPV-ENTRY
```
```
0C0041.AH
0C00420H
L1010-ENTRY
L1111-ENTRY
0C00426H
0C00426H
0C00426H
0C0042CH
```
```
0C00426H
0C00426H
0C00426H
0C00426H
0C00426H
0C00426H
0C00426H
0C00426H
```
```
0C00432H
INTl
INT2
INT3
INT4
INTS
INT6
INT7
```
```
;Reset SSP
;Reset PC
;Bus Error=noni tor entry
;Address Error
;Illegal Instruction
;Zero Divide
'; CHK Instruction
;TRBPV Instruction
```
```
;Privilege Violation
;Trace
;Line 1010 Emulator
;Line 1111 Emulator
;Unassigned
n
```
(^9) n
1
;Eninitialized Interrupt
;Spurious Interrypt
;Interrupt 1
;Interrupt 2
;Interrupt 3
;Interrupt 4
;Interrupt 5
;interrupt 6
;Interrupt 7
System Program - 57


```
ORG
```
```
DC-B
DC.W
DC. L
DC. L
DC. W
DC. B
DC. 0
DC. L
DC.L
DC.L
```
```
JHP
JM P
JMP
JN P
```
```
ORG
```
```
DC. L
```
### DC.W

### DC.W

### DC.W

### DC.W

### DC.W

### DC.W

### DC.W

### DC. W

DC. W
DC.Y .:
DC.W
DC.U
DC.W
DC.W
DC.W
DC.W

### 'NEO-GEO' '0

### 67898

### 800000H

```
l00000H
l000H
0
B
JAPAN-DATA
USA-DATA
EUROPE-DATA
```
```
USER
PLAYER-START
DEMO-END
COIN-SOUSD
```
### ;(100H) ID 1

```
; (108H) Gane Code
; (10AH) Ram Size (4Mbit)
; (10EH) Backup Start
; (112H) Bickup Size
;(114H) Use System .Eye-Catch
; (115H) Eye-Catch ch hi- byte
;(116H) Soft Dip Data
; (11AH)
n:
; (11EH) n
```
System Program - 58


JAPAN-DATA:
DC. B
DC-B
'

```
DC. W
DC.W
DC-B
DC. B
```
```
DC.B
DC. B
DC.B
DC.B
DC. B
DC. B
DC.B
DC.B
DC. B
DC.B
```
```
DC.B
DC. B
```
```
DC-B
DC. B
```
```
DC. B
DC-B
DC. B
DC.B
```
### 0CAH,0EDH,76H,0E8H,20H703H,0F9H,0E0H

```
20H, 20H,20H, 20H, 20H,20H,20H,20H
Sample Game '
```
```
300H ;Play tine 3 nin
300H ; Continue Play 3 min
3 ;Hero 3
100 ;Continue non-linit
```
```
;Bonus Type
;Bonus Rate
;Difficulty
;Demo Sound
;Not used
```
```
OC9H,0EDH,0D2H,BEFH,0DSH,0F4H,0FgH
06H7 07H,088,09H, 20H f Extended Play Time
```
```
OAH,OBH,OCH,ODH,OEHtOFH
20H, 20H, 20H, 20H, 20H, 20H ;:~emaining Lives
```
```
0C9H,0EDH,0D2Ht0EFHt0D5H,0F4H,0F9H
20H, 20H ,20H, 20H, 20H f Continue
```
```
'BONUS TYPE '
'NO BONUS '
'EVERY BONUS '
'SECOND BONUS'
```
```
System Program - 59
```

```
DC.B 'BONUS RATE '
DC-B '20000/10000 '
DC.B '30000/10000 '
DC.B '50000/30000 '
DC. B ' 100000/50000'
```
### DC-B 00H,01H,02H,03H,04H90SH

```
DC. B 20H, 20H , 20H, 20H, 20H, 20H ; ~iffi~~lty Level
DC.B 'LEVEL 1 '
DC.B 'LEVEL2 '
DC.B 'LEVEL3^9
DC.B 'LEVEL4 '
DC-B. 'LEVEL 5 '
DC.B 'LEVEL 6 '
DC.B 'LEVEL 7 9
DG.B 'LEVEL 8 '
```
```
DC.B
DC. B 20H, 20H, 20H, 20H ; Demo Sound
DC. B BEE, OFH, 0A7H, 20H, 20H ,20H
DC. B 20H, 20H, 20H, 20H, 20H, 20H f with
DC.B 14H915H,8BH,20H,20H,20H
DC. B 20H, 20H, 20H, 20H, 20H ,20H ; without
```
USA~DATA:
EUROPE-DATA:
DC.B 'SXXPLE GAME^9

```
DC.W 300H ;Play tine 3 nin
DC.# 200H ; Continue Play 3 min
```
DC.B (^3) ;Hero 3
DC.B 0 ;Continue without
;Bonus Type
;Bonus Rate
;Difficulty
;Demo Sound
f Not used
System Program - 60


### DC.B

### DC.B

### DC. B

### DC. B

### DC-B

### DC.B

### DC .B

### DC.B

### DC.B

### DC. B

### DC-B

### DC.B

### DC.B

### DC.B

### DC.B

### DC. B

### DC.B

### DC.B

### DC.B

### DC. B

### DC.B

### DC.B

### DC. B

### DC.B

### DC.B

### DC. B

### DC.B

### DC. B

### DC.B

```
'PLAY TIHE '
'CONT. TIME '
' HERO '
'CONTINUE '
```
```
'BONUS TYPE '
'NO BONUS '
'EVERY BONUS '
'SECOND BONUS'
```
```
'BONUS RATE '
' 20000/10000 '
'30000/10000 '
' 50000/30000 '
' 100000/50000'
```
```
'DIFFICULTY '
'LEVEL 1 '
'LEVEL 2 $
'LEVEL 3 9
'LEVEL 4 I
'LEVEL 5 I
'LEVEL 6 I
'LEVEL 7 '
'LEVEL 8 1
```
```
'DEXO SOUED '
'MITH?
'WITH OUT '
```
```
System Program - 6 1
```

z7. He' H


```
Confidential
```
Neo-Geo Development Tool Catalogue


```
Neo-Geo Development Tool List
```
* Not available from SNK.

```
Product Name
```
1. Development Software PCB (ROM
    Type)
2. Development Software PCB (IC Card
Type)
3. Sample Cassette Board (for
Commercial-Use)
4. Sample Cassette Board (for Home-
Use)
5. Development Neo-Geo Main Unit
6. Controller
7. RGB 21-Pin Cable
8. Memory Card (for Games)
9. Art Box (Character Development
Unit)
10. SCSI Hard Drive (For Character
Development)
11. Sound Program (for Neo-Gw
Development)

```
Functions
```
```
Reference
For both home and commercial uselcharacter 128 MICan
use 1 M or 4 M EPROM
For both home and commercial uselcharacter 128 M/Uses
4 M or 32 M IC card.
Mass-produced typeICan use 16 M EPROM
* Note: Product availability may be affected by stock on
hand. Contact SNK for availability information.
Mass-produced typelCan use 16 M EPROM * Note:
Product availability may be affected by stock on hand.
Contact SNK for availability information.
Can develop for both home and commercial uselone
controller, AC adapter, and AV cable are accessories.
Controller exclusively for Neo-Geo
RGB output cable exclusively for Neo-Geo main unit
2 K-byte (commercial product JEIDA Version 4.1 SRAM
card can also be used)
Game play data storage card
RGB cable for the monitor as an accessory
* The mouse is not an accessory. (A mouse for PC98 can
he used; DSUB 9-pin.)
SCSI cable for the Art Box is an accessory.
```
```
Software for PC 9800
```
```
Development Software PCB
(ROM Type)
```
```
Development Software PCB
(IC Card Type\)
```
```
Development Nw-Geo Main
Unit
```
```
Art Box
(Character Development
Unit)
```
```
RGB 21-Pin Cable
```
```
This is the development board, which uses the EPROM. It corresponds to
all programs, characters, and sounds. Note: Refer to the "Development
EPROM Example" for the EPROM to be used.
This is the development board, which uses an IC card. It corresponds to
all programs, characters, and sounds. Note: Refer to the "Development
IC card Exan~ple" for the IC card to be used.
This is a product for which the CPU (68,000) of the home-use Neo-Geo
board is used as a pin socket, and for which the ICE can be used.
(ICE: In-Circuit Emulator)
This is a design tool for character development. The hard drive is used as
an external memory device. RS232C7 RGB output, bus mouse,
Centronics connector, and IC card output are the 110s. (JEIDA Version
3, 4 can he used as the IC card output.)
RGB cable exclusively used for the Neo-GH)
```

```
Description of Develop~nent Tools
```
1. Development Software PCB (ROM Type) 2. Development Software PCB (IC-card type)

This is the development board, which uses This is the development board, which uses the IC
EPROMs*. It corresponds to all programs, card*. It corresponds to all programs, characters,
characters, and sounds, and is used for both and sounds, and is used for both home and
home and co~nmercial use. It allows up to business. It allows up to 128 M characters.
128 M characters.

It can use 1 M or 4 M EPROM*. It can use 4 M and 32 M IC card'.
* Not available from SNK. (Can use JEIDA Version 3 or 4)

```
Note: Only the PCM uses the 4M EPROM*.
```
```
*Not available from SNK.
```
3. Sample Cassette Board (Business-use) 4. Sample Cassette Board (Home-Use)

Used for location testing. Mass-produced type. Can use 16 M EPROM*.
Mass-produced type, can use 16 M EPROM*.
*Not available from SNK.
*Not available from SNK.

```
Catalogue - 2
```

5. Development Neo-Geo Main Unit 6. Controller

```
This is a product for which the CPU (280, 68000) of Neo-Geo main-unit controller
the home-use Neo-Geo board is used as a pin socket,
and for which the ICE can be used. * Two controllers are recommended for
develop~nen t of dual player games.
It is equipped with a development system ROM
Possible for different country versions, co~nmercial-
and home-use check.
```
```
Can develop for both home and co~n~nercial use.
One controller, AC adapter, and AV cable are
accessories.
```
* The RGB cable for the monitor is attached.

7. RGB 21-Pin Cable 8. Memory Card (for Games)

RGB Cable exclusively for the Neo-Geo This is an IC card for game play data storage.
2 K bytes (Commercial product JEIDA Ver.
4.1 SRAM krd can also be used.)

```
Catalogue - 3
```

9. Art Box (Character Development Unit) 10. SCSI Hard Drive (for Character
    Development)

This is a design tool for character development. This is used as the external memory device of
RS232C, RGB output, bus mouse, Centronics, the Art Box.
and IC card output (can use JEIDA Version 3 or
4) are used as 110s.

The RGB cable for the monitor is accessorized.

```
Catalogue - 4
```

```
Software Developinent Tool Structural Diagram
```
1. Development software PCB (ROM type)
5. Development Neo Geo
6. Controller 8. Memory card (for Games)

```
Devices Necessary for Developinent
```
```
Catalogue - 5
```
Program Development

Sound Development

```
* 1. Personal computer such as PC 9801, etc.
* 2.^12 MHz^68000 ICE (In-Circuit Emulator)
* 3. RGB 21-pin inonitor
* 4. PAL monitor (for PAL specification checking) < such as the
Toshiba 21 System Core FS >
* 5. EPROM writer (better if it can accept the 16 M EPROM)
< Recomn1ended:AF-9705, by Ando Electronics >
* 1. Personal computers, such as the PC9801, etc.
* 2. 280 ICE (In-Circuit Emulator)
```

```
Structural Diagram of Character Development Tool
*I. RGB 21-pin monitor
```
d

9. Art Box (Character development unit)

,a:. 0 (. 0 - mmqs

S1

f

10. SCSI hard drive

```
* 2. Bus mouse
```
```
I
```
```
* 4. Scanner
```
```
* 3. EP ROM writer
Devices Necessarv for Develop~llent
Character Development * 1. RGB 21-pin monitor
* 2. Bus mouse (400 dpi for the PC-9800)
* 3. - EPROM writer (better if it can accept the 16 M
EPROM) <Recommended: AF-9705, by Ando
Electronics >
* 4. Scanner (Recommended: Epson GT-6000 >
* 5. PAL monitor (for checking PAL specifications)
< Recommended: Toshiba 2 1 System Core FS >
```
```
* We do not market these products.
* We also do not market the IC card used for the PCB develop~nent software (IC card type).
```

Product Development Component Specifications


```
An Example of EPROM for Develop~nent
```
+ Development Software PCB @OM Type) X3002 Series

* Not available from SNK.

```
Note: Differences of " JEDEC" and "N-JEDEC"
```
```
Reference
```
```
Can switch between
JDEC and N-JEDEC
```
```
Can switch between
JDEC and N-JEDEC
```
```
Can switch between
JDEC and N-JEDEC
```
```
Can switch between
JDEC and N-JEDEC
```
### FIX

```
Character
```
```
Program
```
```
Music
```
### PCM

```
OE = Outpiit Enable
```
Refer to the cross reference on a separate sheet for details.

```
Materials - 1
```
```
Model
```
```
TC571001 or TC571000
(N-JEDEC) (JDEC)
TC571001 or TC571000
TC574000
TC57100 1 or TC571000
TC574000
TC571001 or TC571000
.TC574000
TC571001 or TC571000
TC57400
```
```
Number
of Mega
Bytes
1 M
```
### 1 M

### 4 M

### 1 M

### 4 M

### 1 M

### 4 M

### 1 M

### 4 M

```
Manufactu
rer
```
```
Toshiba
```
```
Toshiba
Toshiba
Toshiba
Toshiba
Toshiba
Toshiba
Toshiba
Toshiba
```

+ Sample Cassette Board

* Not available from SNK.

```
Note: Differences of "JEDEC" and "N-JEDEC"
```
```
Reference
```
### N-JEDEC

```
20011s
20011s
20011s
150ns
150ns
150ns
150ns
JEDEC
20011s
20011s
20011s
200ns
```
```
OE = Output Enable
```
Refer to the cross reference on a separate sheet for details.

```
FIX
```
```
Character
```
```
Program
```
```
Music
```
### PCM

```
Materials - 2
```
```
Manufacturer
```
```
Toshiba
```
```
Toshiba
Toshiba
Toshiba
Toshiba
Toshiba
Toshiba
Toshiba
```
```
Toshiba
Toshi ba
Toshiba
```
```
Model
```
### TC57 100 1

### TC578200

### TC57 1 6200

### TC574096

### TC574200

### TC578200

### TC57 16200

### TC571000

### TC574200

### TC578200

### TC57 1 6200

```
Number
of Mega
Bytes
1 M
```
### 8M

### 16 M

### 4M

### 4M

### 8 M

### 16 M

### 1 M

### 1 M

### 8 M

### 16 M

```
Type
```
-
. -
-

```
4096 Type
4096 Type
```
- - - - - -


W 256KJ5 12K bit EPROMfOTPImask ROM

-

```
1M-bit EPROM/OTP/mask ROM
```
```
2M-bit mask ROM
```
```
Materials - 3
```

4M bit EPROM/OTP/mask ROM

```
8Ml16M bit EPROMIMask ROM
```
Materials - 4


```
An Example of the IC Card for Development
```
+ Development Software PCB (IC Card Type) X3002 Series <PI-C2>

```
* The JEIDA Ver. 3 IC cards are not rnarketed to the public.
Versions after JEIDA Ver. 4 IC cards can be used instead of version 4.
```
'
+ The data region for the PCM is exclusive to " M EPROM (JEDEC)."

```
Reference
```
```
Can use both Versions 3 and 4.
*
```
```
Capacity switching is possible via the
slide switch (SWl and SW2).
Cannot use the Version 4 card for the
program. Access time: 150 ns
*
```
```
Can use both Versions 3 and 4.
*
```
### FIX

```
Character
```
```
Program
```
```
Music
```
* We do not market these products.

### PCM

```
Note: Although versions 3 and 4 can be used for "music" and "fix," the following points must be
noted.
```
```
IC Card
Version
JEIDA Ver. 4
JEIDA Ver. 3
JEIDA Ver. 4
```
```
JEIDA Ver. 3
```
```
JEIDA Ver. 4
JEIDA Ver. 3
```
```
Number of
Mega Bits
1 M
4 M
32 M
```
### 4M

### 1 M

### 4 M

```
JEIDA Ver3 i i JEIDA V.e;'r-4
i
```
Data bus Dl5^8 7 0 1 i Data bus Dl5 (^8 7 0)
1
Display on the
Card Surface
128
512
4 M

### 512

### 128

### 5 12

```
Nuinber of Mega Bytes
4 M
```
```
Unused
```
```
F
10
```
```
Materials - 5
```
```
Manufacturer
Toshiba
```
```
Address
43
```
```
Model
TC574000
```
```
Remarks
Less than 20011s
```

+ Regarding the access time of the JEIDA Version 4 IC Card

```
Generally it is "200 nanoseconds."
We recoinmend "200 ns," although there is the "250 ns" type.
```
+ Regarding the IC Card Reader for the JEIDA Version 4 IC Card

```
The other IC cards (not the programs) can only be read with this development board.
```
```
Please purchase the "IC Card Reader for Version 4," which is being marketed.
```
```
Recommended Products
```
```
Manufacturer: Adtech Systems
Product Name: RAM-Zo
Type: AMI-2 -
2 Corresponds to flash memory.
```
+ Regarding the IC Card Capacity Display

```
Generally, the capacity is displayed in bytes.
```
```
Example:
```
```
Mu1 tip1 ies the card display eight times
```
```
Card Display
512 K Bytes
2 M Bytes
4 M Bytes
```
+ When Using as Characters

```
When Converted to Bits
4096 K Bits = > 4M Bits
16 M Bits
32 M Bits
```
* C1 and C2 are pairs Increase by two

```
Example) For 64M-bit characters (Ver. 4)
```
```
Developing using four cards Developing using two cards
64 + 4 = 16 M bits 64 i 2 = 32 M bits
```
Thus, 16 M bits per one card Thus, 32 M bits per one card
4 4
16 + 8 = 2M bytes 32 i 8 = 4 M bytes
4 4

```
Materials - 6
```

Use four "2 M byte" IC cards. Use two "4 M byte" IC cards.

```
Materials - 7
```

```
Examples of Sound Development Utility Devices
```
* Not available from SNK.

```
Mixer
Patch Bay
Synthesizer
Sampler
```
Sound Processor
Sound Effect
Library

```
Audio System
```
```
Materials - 8
```
```
Connects between devices and adjusts the sound quality.
Used along with the mixer, and smoothes out connections between devices.
Used as sound source for instrumental sounds and effects.
Used as sound source for instrumental sounds and effects.
Also, short recording, editing, and processing are performed.
Processes sound, such as echoes, etc.
50-60 set CDs
Various sound effects are recorded (includes the licensing fee).
Power amps, speakers, DAT, microphone, etc.
```

future is

```
~eo-~eo/MVs Software Development Planner's Manual
```

Neo-Geo/MVS Game Development Process

```
The Neo-Geo and MVS game software packages at our company are
developed through the following process, Please read this section
as a reference,
(100 M software was used to determine the production period, and
the following is an average example.)
```
```
Draft an original plan for the project (approximately 30 days to
draft the plan) ,
```
```
Planning meeting: Define the plan's details and determine the
submission deadline for the plan.
```
```
Develop the plan and test characters, then proceed to a design
review (30-60 days for development).
```
```
Planning meeting: Review each step in the program's production
process, including characters and sounds, and submit on the
deadline.
```
```
Start character development (180-240 days after start of the
development).
```
```
Start program development (210-270 days after start of the
development) ,
```
```
Start sound development (60-120 days after start of the
development).
```
```
Character and sound check: Perfopn corrections and changes as
necessary,
```
```
Game-detail check and company location -> Perform corrections and
changes as necessary,
```
```
Start the debugging process (start about 60 days prior to the
final deadline date) ,
```
```
Location testing: Perform corrections and changes as necessary
after the final check of each item,
```
```
Complete the character and sound master ROM: Submit the ROMs to
SNK ,
```
```
Complete the program master ROM, Submit the ROM to SNK.
```
```
Perform the debugging process for approximately a week, even after
submitting the final ROM revision,
```
```
The entire process takes approximately 10-14 months.
```
```
Software Development pol
```

```
Issues to be considered while making the original game plan
```
```
[video arcade]
El
```
Memory Card 1

```
Neo-Geo
[home]
1
What is Neo-Geo?
```
```
The Neo-Geo system allows individuals to play games which are usually
installed in video arcades. Individuals can rent larger capacity
hardware at rental stores, or they can purchase the hardware and
software. A memory card, which is compatible with the MVS, is used to
store the game information, thus the player can continue the game at
home after leaving the video arcade,
```
```
What is MVS (Multi Video System)?
```
MVS is designed for coin operation usage, MVS contains one or more
program cartridges which differ in size from the consumer cartridges,
There are two types of MVS: one has multiple cassettes and the other
.type is equipped with a single cassette, Players using the multiple
slot system can choose which game to play by pushing the Game Select
Button (described later),

```
[Domestic distribution]
* board with 1 slot (capable of connecting to a JAMMA unit)
* board with 2 slots (for the special upright unit)
* board with 4 slots (for the special table or upright unit)
* board with 6 slots (for the special tgble or upright unit)
```
```
[Overseas distribution]
* board with 1 slot
* board with 2 slots (for the special upright unit
for the upright unit exclusively used for MVS)
* board with 4 slots (for the special upright unit)
* board with 6 slots (for the special upright unit)
```
Note: "Slotan means a game cartridge receptacle.
Note : The above configurations were available as of February 1991;
what is currently available may differ,

```
What is a Memory Card? (~etails to be described later)
```
A memory card stores information, such as the player Is status and area,
enabling the player to continue play at home (using Neo-Geo) after
leaving the video arcade (using MVS), Therefore every game should be
compatible with the Memory card, (Although the game should be playable
without a Memory card.)

```
Software Development p.2
```

```
Differentiating the Neo-Geo and MVS games
```
```
When designing a game, consider including some features to distinguish
the Neo-Geo version from .the MVS version (see the examples below). The
purpose is to give some incentive to users to rent Neo-Geo; please
design in such special features in order to raise the entertainment
value of this machine to consumers.
```
```
Examples :
```
```
Make the Neo-Geo's standard difficulty level different from
the MVS version's level. Allowing the Neo-Geo difficulty
level to be fully selectable raises player interest.
Include more varieties and longer demonstration images in
Neo-Geo, since the length of play does not have to be cut
down so much for home. Extra ideas, which can not be
included in the game for MVS because of the limit of play
time, may be incorporated in the game for Neo-Geo.
The number of bonus or continued games should be limited in
Neo-Geo , (In that case, please display the bonus or
continued games left.)
```
```
Game Content, Language, and Symbol Considerations
```
```
The Neo-Geo and MVS units operate in a wide variety of home and arcade
locations, The players have a wide age range, especially for the Neo
Geo home unit, which is used by families, When designing the game
project, the following factors must be considered during the design.
A recent game trend is the introduction of ultra-violent games which
are designed to use shock value to gain audience. This trend has
caused regrettable actions to occur in terms of public acceptance of
games and exposing a younger age range to violence beyond their years.
SNK Corp, requests that the game designers use good judgement in their
game design, Though there is no set guidelines, please refer to the
following below as a gauge in the design stage.
```
```
1, Avoid scenes of spurting blood or ultra violence for the game
actions, even in secret moves,
```
2. Symbols of adult consumption such as liquor bottles and cigarettes
    or large wads of money require special consideration.
3. Avoid religious symbols of any form.
4. Copyrighted symbols and trademarks or brand names are not
    recommended, unless there is a brand tie-in for the game basis.
       Similarly, avoid using famous people's names or likenesses due to
    possible invasion of privacy.
5, Profanity and anti-social language are to be avoided.
6. Avoid using sound effects or music that is borrowed without
    permission of the authors/composers.

As a general rule, the most important thing to remember is to give a
good play value without resorting to shock tactics. Comedy in good
taste is a very good method to add gaming value to any game. If the
whole family can laugh together at a game with a sense of humor, it
provided a more enjoyable experience without being offensive.

```
Software Development p.3
```

```
Brief Game Flow (MVS Only)
```
```
The MVS unit game developed by our company flows as shown below.
The screens marked with a + must be developed, but the ones marked
with a f are optional, depending on each project. (Since the
following is strictly basic, please consult with our company
before development or refer to our games for actual processes.)
```
```
The software dip unit settings are standardized, as are the
hardware dip. (Please refer to the sections on software dip and
hardware dip.)
............
```
. Power ON.

```
the credit is 0, loop here.
................................
I
I Display the FBI mark (U. S. version only)
(displayed by the system) I
```
```
1 Title demo (*) is displayed from slot 1 in order Id
Game demo display (*) 1-
```
*I Insert credit 1

```
Fqrced start countdown display (*)
(if game start compulsion is set)
.............................................................. I^1
```
. Start button ON ,. If there are multiple slots the.
... .. ...................... game to be played can be seiected.
. Forced start countdown.. with the game select button.
. time out .....................................

I How to play display (4) (

```
I Memory card load screen (only when there is a memory card)
............... I I
```
. Start play -4 I

```
Naming (4)
m
...............
```
. To continue.
I

```
J
...............
....................
```
. Not to continue.
....................
    Memory card save screen (*)
       I I
I Game over display (*)
.............................................................
. Don't forget your memory card! (displayed by the system). A

```
Software Development p.4
```

```
Performance of ~eo-Geo/MVS
(Provided herein are specifications needed for software
developers)
```
```
.Display Method
```
```
lSprite One sprite character consists of 16 dots x 16 dots, and
32 sprite characters, vertically arranged, form into one
line sprite, Neo-Geo is made up of 32-character line
sprites (of 16 dots x 512 dots each) with back
characters, such as backgrounds, also comprised entirely
of line sprites.
```
```
380 line sprites are all prioritized. In actual
programming, these line sprites are allotted for such
items as the main characters, enemies, and backgrounds.
```
```
A maximum of 380 line sprites can be displayed; however, should
over 96 line sprites be horizontally displayed at one time, line
sprites from the highest priority will start missing. Every
program, therefore, must be worked out with this in mind. (This
precaution must be taken only when more than 96 lines are
displayed horizontally.)
```
```
I FIX One character consists of 8 x 8 dot matrix, and
scrolling (dot-by-dot movement) is not possible. This
is given a higher priority than the sprite, and this
cannot be changed. In program development, this is used
to display the Neo-Geo system display, scores, etc,
...................................................
Screen Size (Maximum display area on.the monitor)
```
```
The screen size is 320 dots (20 characters) horizontally x
224 dots (14 characters) vertically.
```
-.--.-.-------a.e. (^288) 4- i
I
Full Display Area^208
i
Software Development p.5

. -- ...
    1
    i i
       i

2 2'4
i
i
I

(^1) L-.
(Caution) Some monitors may not provide
the full display of 320 x 224 (partly
not visible); therefore, it is safer to
set such important display items as
the main character's life gauge, etc.
within the 288 x 208 area. (288 x 208 is
what we consider as the safe area, and
it is suggested that you use your own
I 3 20 - ... ...... ....... .-: i judgment for the display positions.)


```
Palettes
```
```
One palette consists of 16 colors with 0 as blank for O-F. There are
up to FF (256 units) palettes, 4,096 out of 65,536 colors can be
displayed at one time,
```
In the O-FF palette number range, it is possible to have O-F for the
FIX and the remaining 10-FF for the sprite, (The O-FF palettes for the
FIX are usable for the sprite as well, butthe palettes for the sprite
are not usable for the FIX,)

In some programs FF may even be insufficient, so the palette number can
be expanded to a certain number of units, (This varies from program to
program, )

```
Functions
```
The MVS and Neo-Geo hardware have functions such as reduction, auto-
action, vertical (V) and horizontal (H) flip in character units, and
lowering of the color tone.

I Reduction The sprite can be reduced from 100% to 0%. The
reductions can be done in 256 levels vertically and 16
levels horizontally, (The reason that there are only 16
levels horizontally is that a one-line sprite consists
of 16 dots horizontally,)

```
(Note) If an item is reduced more than 256 dots (16 characters)
vertically, one dot of the character below will be pulled up
when displayed (refer to the left diagram), When reducing an
item that is more than 256 dots, it is necessary to take
measures such as leaving the lowest dot blank, (Please
perform these measures and ideas during development,)
```
```
Software Development p.6
```

```
I Auto-Action
By using this for items that are displayed as constant action in
loops, such as rivers and spectators, the CPU processing load can
be reduced, This can only be used with sprites, and the number of
actions can be selected from two types four and eight step and
settings from 1/60 to 256/60 seconds can be set as the action
speed,
```
```
(Note) The parsing method of the character for auto-action differs
between the selection of four step actions and eight step
actions. For four actions, the first character of each
action is placed in each character bank where the lower digit
is 0, 4, 8, and F, then the second character, third
character, and so on, are parsed. For eight step actions,
they are placed in each character bank where the lower digit
is a 0 or 8, and are parsed in the order of action. (Even if
the first and third actions are entirely the same, they are
treated as completely different characters for auto-action
characters. )
```
```
I Character Flip Vertical and horizontal flips can be performed in
character units for the sprite,
```
.I Decreasing the Tone of the Screen
The tone of the game screen can be decreased (a
little bit) ,

```
I communication Function
The communication function is not included as the
basic function of the hard drive, but it becomes
possible by adding a communication board to the
cassette side, Please take note when planning,
that there are restrictions in amount of data that
can be sent or received during communication,
Sound Function
```
```
A Yamaha YM2610 is used as the sound-source chip, This chip can
simultaneously produce three sounds: ADPCM (speech synthesis), four
seven-sound FM sound source, and SSG (PSG compatible),
```
```
I ADPCM-A and ADPCM-B
```
```
There are two types of ADPCMs used for speech synthesis, and the number
of sounds, etc,, differs,
```
```
Software Development p.7
```
```
ADPCM A
```
```
ADPCM B
```
```
Data ROM
```
```
4M Mask ROM
```
```
4M Mask ROM
```
```
Number of Seconds
That Fits in 4M ROM
Approximately 1
Minute
Maximum of 2 Minutes
If the Quality is
Decreased.
```
```
Number of
Sounds
6 Sounds
```
```
1 Sound
```
```
sampling
Rate
18.5 KHz
```
```
2.0-55.5 KHz
```

```
The sound quality improves as the value of the sampling rate is
increased for the "ADPCM-Bw shown above, but this would require more
memory, But if the sampling rate is low, it would require less memory,
but the sound quality would decrease, The tuning can be changed by
changing this value during replay, For example, if an instrumental
sound, etc,, is recorded, it can be used as the BGM.
```
The llADPCM-Bw corresponds to both BGM and sound effects. Depending on
the plan, it can be used for sound effects or BGM, especially as B6M
instruments,

```
I FM Sound Source Four sounds can be produced simultaneously by the
FM sound source.
```
```
I SSG Sound Source This sound source is compatible with the PSG, and
three low-frequency sounds can be produced, which
can be mixed with noises.
```
```
I Static Setting for Stereo
This sound-source chip is stereo, but it can only
output to Lch, Rch, or L+Rch, So, when setting
sounds in more detail, two of the same sounds
should be used and adjustments must be made for
each level setting,
```
I Sound Arrangement
The sound arrangement depends on each plan, The
diagram below is an arrangement for when our
program is used:

I Volume In order for it to be compatible with the MVS, please
follow our s~ecifications for volume adjustment.

### BGM

```
Sound Effects
```
```
Software Development p.8
```
```
ADPCM-B 3 sounds, FM 4 sounds.
ADPCM-B 3 sounds, SSG 3 sounds 1 type
```
### ADPCM-B 1

```
sound
```

```
Regarding the System ROM
```
```
A system ROM that controls the game system is built into the Neo-
Geo/MVS. The following detail controls are handled in different
regions by the system ROM.
```
```
Types of System ROM
```
```
MVS Japan/U.S.A./Southeast Asia/Europe
Neo-Geo Japan/U.S.A/Europe/Asia
```
```
MVS Regional Specification (The details of each item are described on
the next page.)
```
```
Software Development p.9
```
```
Specification
```
```
Language
(Display
Method)
Coin 1
```
```
Coin 2
```
```
Coin 3
```
```
Coin 4
```
```
Credit/Coin
Setting
```
```
Credit/ LED
Display
FBI Display
Continue
Service
Start Button
1
Start Button
2
Game Select
```
Cross-Hatch
Color
Forced Start
Current
Version

```
U.S.A.
```
```
English
```
```
P1 only
Coin counter
1
P2 only
Coin counter
2
Unused
```
```
Unused
```
```
Same for
coin slots
and 2
One for P1 &
one for P2
Yes
Yes
```
```
P1 start
(note) 2
P2 start
(note) 2
Before coin
insertion
Sky Blue
```
```
None
Version 5.0
```
```
Japan
```
```
Japanese
```
```
Both P1 & P2
Coin counter
1
Both P1 & P2
```
```
Unused
```
```
Unused
```
```
Separate
coin slots 1
and 2
Same for P1
& P2
None
None
```
```
P1 start
(note) 2
P1 and P2
start
After coin
insertion
Red
```
```
Possible
Version 5.0
```
```
Southeast
Asia (Korea)
English
```
```
Both P1 t P2
Coin counter
1
Both P1 t P2
Coin counter
2
Unused
```
```
Unused
```
```
Separate for
coin slots 1
and 2
Same for P1
& P2
None
None
```
```
P1 start
(note) 2
P1 and P2
start
After coin
insertion
Blue
```
```
Possible
Version 5.0
```
```
Europe
```
```
English
```
```
P1 only
Coin counter 1
```
```
P2 only
Coin counter
I*
P1 only
Coin counter 2
P2 only
Coin counter 2
Separate for
coin slots 1
and 2
One for P1 &
one for P2
None
None
```
```
P1 start
(note) 2
P2 start
(note) 2
After coin
insertion
Yellow
```
```
Possible
Version 5.0
```

*. If DIP No. 2 is off for hard dip in the European version and "Coins 1 and
2 only (Coins 3 and 4 will not be used)" is set, then the box will be
changed as follows
1

I

```
P2 only
coin counter 2 I
```
```
Software Development p.10
```

```
Descriptions of terms from the previous table
```
```
Regarding the "Coin Counter* 1
b There are two types of coin counters, and one counter is
allocated for one type of coin. "Both P1 & P2" means that
coin 1 uses counter 1 and coin 2 uses counter 2. "P1 onlyw
and "P2 onlyw means that coin 1 or coin 2 uses counter 1 and
coin 3 or coin 4 uses counter 2.
```
,

```
Regarding "Credit LED Displayw I
b "Both P1 & P2" means there is only one credit LED display, but
"PI onlyw or "P2 onlytt means that the credit LED displays are
independent for players 1 and 2.
```
```
Regarding 'tcoinst (
b Input of coins 1-4 can be accepted, but "same for P1 & P2"
means they share the same LED credit display.
```
```
Ex.) An insertion of one coin means one credit for coin 1, and
the insertion of two coins means one credit for coin 2.
There is only one LED credit display, and it shows a
value of two when one coin is inserted in coin 1 and two
coins inserted in coin 2.
```
```
A "PI onlyw and "P2 onlyw means they have independent credit LED
displays. The point to note in this specification is that the
credit rate for coin 1 and coin 2 will be the same. So, the
number of coins for each credit will not vary, such as one
coin .insertion for a coin-1 credit and two coin insertions for
a coin-2 credit.
The hardware is equipped to deal with the input of coins of
different values into coin 3 and coin 4. (However, dip switch
2 must be on. )
```
```
Example) Player 1 = Coin 1 (#loo)/ Coin 3 (g50)
Player 2 = Coin 2 (#loo)/ Coin 4 (g50)
```
```
Note) Coin 1 and coin 2 do not have the above meanings for the
U.S. version. Coin 1 indicates "coin to start the gameM
and coin 2 indicates "coin to continue game during the
continued countdown."
(This is described later in the section, 8tContinue
Service. ")
```
```
Regarding the "FBI Displayf I
b As one method to prevent copying, the U.S. version displays
the "Drug Preventiontt announcement and the FBI logo.
```
```
Software Development p.11
```

```
Regarding "Continue servicew I
D A regular number of coins is required when starting a game,
but for the U.S, version, when coin(s) are inserted during the
continue countdown, the game can be continued with fewer coins
than the regular amount,
```
```
Example) Coin 1 = One credit for two coins
Coin 2 = One credit for one coin
```
```
For the above settings:
Coin 2 is the number of coins required for one credit at
the start of a game, and coin 2 is the number of coins
required for one credit during the continued countdown,
```
```
Regarding "Cross-Hatch Colorsw
D The region type of the system ROM can be identified by the color
displayed around the cross-hatch during the test screen,
```
'

```
Regarding the "Forced Start"
I
```
```
Regarding the "Start Buttonw
b With "Both P1 & P2," start button 1 allows only player 1 to start
or continue a game. Start button 2 allows players 1 and 2 to start
at the same time if there are two or more credits, After the game
starts, start button 2 can be used for player 2 to continue a game,
```
```
With "PI onlyw and "P2 only," the start buttons are independent,
while start button 1 relates only to player 1 and start button 2
relates only to player 2,
```
```
D After the coin has been inserted, the game will start
automatically after a fixed duration, without pressing the start
button, This is a standard setting and can be changed with the
mode-select menu (described later).
```
```
Software Development p.12
```

```
Regarding the Hard Dip (MVS Only)
```
```
The unit's condition can be controlled with the hard dip with the MVS
(along with the control using soft dip).
```
```
The hard dip is located on the MVS system PCB, the location varying,
depending on the PCB model.
```
All settings are read and set on power up, except for switches 7 & 8
which affect the game mode immediately.

```
Software Development p.13
```
```
Details
```
```
Turn this on, and when the power is
turned on the soft dip screen is
displayed.
Off = two-coin system status
On = four-coin system status/ When coin
3 and coin 4 are used
Turn this on when connecting the mah-
jong computer panel.
This is used as the unit identification
number during communication.
There are four types: It4-OFF and 5-OFF, It
"4-ON and 5-OFF, " "4-ON and 5-ON, tt and
"4-OFF and 5-ON."
Turn this on to enable the
communications mode.
The game can be played without credit if
this is turned on.
The screen stops when this is turned on.
```
```
Switch
Number
1 2 3 4 5 6 7 8
```
```
Item
```
```
Setting Mode
```
```
Coin System
```
```
Mah-Jong Computer
Panel
.Communication
Control
```
```
Communication
Control
Free Play
```
```
Screen Stop
```

```
About the Mode Select Menu (MVS only)
```
```
With the MVS, each game's parameters are set using the Parameter
Selection menu. This menu also sets some of the parameters used in the
operation of the game machine itself, in conjunction with DIP switches.
```
Mode Select Menu- operation 1

```
I When the test switch located inside the unit is pressed while the
MVS system's power is on, or switch #1 is set in the hard dip, the
following menu will appear on the display.
```
```
I When the menu is displayed, use the 1P joystick to select an item
which needs to be set or verified, then push button A to go to
that item. The display will then show the selected page.
```
```
4 Hardware Test
Hardware (DIP) Switch Set
Parameter Select Software
Income Records
Password
Calendar Set
Exit
```
- dd/mm/Wyy

I * The display screens of domestic and foreign versions differ
slightly.

Mode Select Menu - Hardware Test

```
Items on the Hardware Test change when the player-1 button is
pressed. An item especially useful for development is the "Memory Card
Test or Backup RAM ClearN displays. Power the PCB down to exit from
the Hardware Test page.
```
```
[I] Crosshatch 121 RGB Test
```
```
Software Development p.14
```

```
INSERT MEMORY CARD - - - 1
I 4
i
BACKUP CLEAR t I t
C.
OK = PUSH A, B, C BUTTON
```
DIP .- -- Switch Status Display [4] Sound ._.. Test.

```
j, On this menu, the Memory Card is
tested to ensure that it works
properly; in addition, the contents
of the Backup RAM in the MVS unit can
be cleared.
```
```
l/O <:llK<:K
1.1 1.2 01 I' I Z34ZiG7R
11 1. 0 0 00000000
IlOVP( 0 0
I.l?YT 0 0 TRST 0
H I<:llT 0 0 COIN2 0
I.IJSIIA 0 0 COIN1 0
I.!ISJln 0 0 SCHV I (:KO
1'1ISIJ~:O 0
I'IISIIO 0 0 Kt. t.Klll t.l<llX
START 0 0 5 RR 27.
S)?l.l?CTO 0
```
- - ;- - - When the Memory Card is inserted, the
    screen reads :
I
I "MEMORY CARD TEST OK"
: When no Memory Card is inserted, it
reads :
.. - - - - - - - - "INSERT MEMORY CARD"

```
SO1INO TEST
SO1INI) OYY
K I GIIT
1.R PT
CENTER
```
-. -.. -.

[Memory Card Test]
Proper functioning of the Memory Card is tested. Please be
advised that the data contained in the Memory Card becomes
corrupted during this test if the Memory Card has any data in it.
[Backup RAM Clear]
When buttons A, B, and C are pressed simultaneously, the system
initializes various parameters stored in the backup RAM of the
MVS. Please be careful when performing this operation since all
of the following are cleared by this procedure: unit parameters,
software parameters, the calendar, and the income records.

```
Memory Card Test and Backup RAM Clear
```
[6] Calendar Set

```
Calendar Set
Current date and time
~/~~/YYYY
hh:mm:ss
New date and time
Use button A and
joystick to select.
Use button B to set.
~/~~/YYYY
hh:mm: ss
```
```
Note: The internal calendar may
be altered slightly when
the income statistics,
described later, are
collected. Please keep
this in mind when the
system is used for field
trials.
```
```
Software Development p.15
```

```
,.."..I"...".- .....-.. - ......... - -............ -.....--... ... .--...... --.-..----.""" ...,
j : ..............-.... ode Select .........--,.---..." - 'DIP Switch .-.-. ".-.." -....... Status ...--...--- .... t
```
```
Displays the status of DIP switches on the main board.
```
### 12345678

```
Mode O....... OFF
Controller. -0.. ... Normal
Communication ... 0 0 0 .. OFF
Bonus Play ..... -0. OFF
Stop Mode ...... -0 OFF
0 = OFF, 1 = ON
```
i Software Parameter Set f

```
On this page, the system parameters and software control parameters
(such as the difficulty level and bonus points) are checked and set for
each game. Confirm that these values are correctly set while debugging
the system as described in "Debugf1 section later, since these
parameters directly affect the game.
When nEXITfl is selected, the system is reset and the screen is changed.
```
-+ System Parameters
Slot 1 game title..
Slot 2 game title.
Slot 3 game title.
Slot 4 game title.
Slot 5 game title.
Slot 6 game title..
EXIT

```
* After Ifsoftware Parameter Setff is
selected, the display will show a list
of selections as shown on the left.
Please select either Ifunit Parametersm
or one of the games from the list.
```
```
.... These items may vary depending on the
number of slots and the number of games
in the machine.
```
```
Display the maximum number of letters
possible for the software title.
```
```
Software Development p.16
```

isoftware.. - ...................... Parameters - Unit ............................ Parameters -... .. -......... : /

```
The system8 s software parameters of the unit are set and checked.
```
```
4 COIN-1: 1 COIN = 1 CREDIT
COIN-2: 1 COIN = 2 CREDIT
GAME SELECTION : Only when player has credit
Time before game start : 30 seconds
Demo sound : Set by each game
```
```
* Use the joystick to
select the item to be
changed and press button A
or B to set, Push button
C to return to the
previous page,
```
i L..... Game Parameters -- f

```
Each game installed in the system uses software parameters which are
checked and set on this page, The contents of the parameters differ
from game to game,
```
```
Default
1 credit
```
```
2 credit
```
```
Only when
the player
has credit
```
```
30 seconds
```
```
Set by
each game
```
```
Item
Credits
for coin-1
Credits
for coin-2
Game
Selection
Method
```
~utomatic
start

```
Demo Sound
ON/OFF
```
```
* The maximum of 15 items can be set by each software; each item can
have 15 options, (See the following examples for details,)
```
```
Contents
Number of credits per coin inserted into coin
slot 1
Number of credits per coin inserted into coin
slot 2
Whether the player can select the game when there
is no credit left, or the selection can be made
only when there is some credit left (multiple
slot system),
Select whether to start the game automatically
after the time limit, or to wait until the Start
button is pushed (game start compulsion, from 1-
59 seconds) ,
This sets whether there will be demo sound for
the entire unit. If this parameter is set to
wOFFN, no sound is played even if the game's
sound parameter is turned "ONu,
```
```
* Please note that, of these 15 items, items numbered 1 to 4 can
also be controlled in a more detailed fashion by the system ROM,
```
```
For example, the time can be set to minutes and seconds precision
level, However the items that can be set by the system are
limited depending on the system's configuration,
```
```
Software Development p.17
```

```
Software Development p.18
```
```
Items that can be controlled by the system (The same parameters set in
items
to
1
2
```
```
3
```
### 4

### 5

```
6 ,
```
7

8

### 9

### 10

### 11

### 12

### 13

### 14

### 15

```
1 to 4 may also be set using menu items 5 to 15, however, items 5
15 only have 15 options for each item.)
Play Time
Continue Play Time
Limit
Number of Lives
(e.g. planes)
Number of Continue
Plays
```
```
0 minutes 0 seconds - 59 minutes 59 seconds
0 minutes 0 seconds - 59 minutes 59 seconds
```
1 - 99

None, No Limit, 1 - 99

```
Examples of items which can be set by each software, (Contents of
each item is up to
Difficulty Level
```
```
Bonus Setting
```
```
Bonus Score
Playing
Instructions
Demo Sound
Credit Display
Free
Free
Free
Free
Free
```
```
the developers,)
```
```
" Minimum 4 levels, maximum 15 levels, .....
Sample difficulty levels (for 8 levels):
1 : very easy 2 : easy 3 : a little easy
4 : average 5 : a little difficult 6 :
difficult
7 : very difficult 8 : extremely difficult
No bonus / limit two / no bonus limit
Note: When nlimit twon is set, player gets up to
two bonuses, one bonus each time the score
reaches a bonus score level. "no limitn
increases the player bonuses for unlimited number
of times. -.a--.-.-----.-..---.--..-.- -..........- "US....
Example : When the bonus score setting is at
1000/2000
1st bonus : 1000 '2nd bonus : 1000 + 2000
(System gives no more bonuses if "limit twow is
set, )
3rd bonus : 1000 + (2x2000)
4th bonus : 1000 + (3~2000)~ and so on,
15 levels maximum
yes / no
```
```
yes / no
yes / no
```

```
(Shooting game example)
NAM 2020
4 CONTINUE PLAY NO LIMIT
DEMO SOUND YES
NUMBER OF PLANES 3
DIFFICULTY LEVEL 4
BONUS SETTING LIMIT TWO
BONUS SCORES 1000/2000
```
```
(Sports game example)
HYPER BASEBALL
-, PLAY TIME 03 : 00
CONTINUE PLAY TIME 04: 00
CONTINUE SETTING -YES
DEMO SOUND YES
PLAYING INSTRUCTIONS YES
CALLED GAME YES
```
Note: A maximum of 8 items can be displayed in one screen page in the above
examples. When 9 or more items are used, place "NEXTm in line 8 and design
the second page to be displayed when the player moves the cursor to the
bottom of the page using the joystick. The first page appears again when the
cursor is moved to the top of the second page.

```
(An example using 9 or more items)
First Page Second Page
```
### QUIZ BIG SEARCH

### NUMBER OF LIVES 3

### CONTINUE NO LIMIT

### DEMO SOUND YES

### PLAYING INSTRUCTIONS YES

### DIFFICULTY LEVEL 4

### BONUS SETTING LIMIT TWO

### BONUS SCORES 1000/2000

### NEXT

### DISPLAY CORRECT ANSWER YES

### CREDIT DISPLAY YES

i Income Records ..... i

```
For the MVS, various data such as the unit's total income and the
income and playing time of each of the games are displayed and verified
on this page. Please be careful when you execute the Backup RAM clear,
since these income records are stored in the backup RAM, and they will
be deleted when the RAM is cleared.
This page is mainly used by the operator, and it is also useful for the
income checking during location testing.
```
```
UNIT/COIN ..........
UNIT/PLAY ..........
SLOT-1 game title ..
SLOT-2 game title
SLOT-3 game title
SLOT-4 game title
SLOT-5 game title
SLOT-6 game title ..
```
```
..... Unit's income and play data are
.... : displayed.
.....
```
. Income and play data for each game
. are displayed.
.....

```
Software Development p.19
```

j~ncome ...-.-.--.- ""---..-----"---.-."-"."---.-".- Records - UNIT/COIN , j

```
The unit's income records are displayed in the following order: "Weekly
Datatt, "Monthly data, January through June", "Monthly data, July
through Decembertt, Each category contains the f0110~ing data: "Income
from coin slot l", "Income from coin slot 2", and "number of service
credits, "
```
Income Records - Unit/Play i

```
The unit's game records are displayed in the following order: "Weekly
Datau, "Monthly data, January through Junew, and "Monthly data, July
through Decemberu, Each category has data on "Number of games playedtt,
"continue gamesw, and "Average time."
```
11ncome Records - Income, by game title f

```
Game statistics of each game (such as "number of games playedtt,
"continue gamesw, and "average timew) are displayed,
Note: The income data might be altered when software cartridges are
changed, Please execute the backup RAM clear after the change,
```
-.
    Password Set 1
       * This is not directly related to the software
       development,

```
Push button D to set,
I
When the memory card is used, be
sure to set the password in the
memory card as well,
```
y ....... *-
fMode .................................. Select - Calendar Set j

```
Year, month, day, and time is set in the system,
```
```
Software Development p.20
```

```
About Memory Card
```
```
By having a memory card to store the player's score, area, etc. in a
game, the player can continue, (using the NEOGEO system), the rest of
the game played at the arcade (MVS). The memory card is a selling
strength of the Neo-Geo system; therefore, every game should be
programmed with memory card capability.
```
```
Specifications of Memory Card (Information needed for programs)
```
```
The memory card has "27 pages," and each page consists of 64 bytes.
The data at the head of the page is used for the title display and uses
20 bytes, leaving 44 bytes on each page.
```
```
Although multiple-page use is possible for one game, please try not to
use too many pages (to avoid situations where there is only one title
in a memory card).
```
```
Consulting with a programmer regarding this matter is recommended in
developing a program.
```
```
Card Format
```
A memory card, if not yet formatted, can be formatted when it is saved
or when the memory card utility menu is displayed on the monitor screen
(as explained below).

```
Memory Card Utility Menu (Neo-Geo unit only)
```
When a memory card is set in the Neo-Geo system and then the system is
reset with the buttons A, B, C and D pressed down simultaneously, the
memory card utility menu is displayed. In this mode, the user name can
be registered in the memory card, or data copies can be performed, etc.

The operation here is to be performed according to the instructions
displayed on the screen.

```
Memory Card Utility
```
```
+ 1 Format card ....
2 Display data name
3 Data copy
4 Erase Data
5 Register user's name
6 End ....
```
. Select with the lever and
. choose with the button.

```
Software Development p.21
```

```
~egulations for saving Data
```
The data saving method and points are up to each program developer;
however, the following fundamental display regulations must be strictly
met :

```
Common Regulations
```
```
At the saving point, display IIMEMORY CARD SAVE1' and the option of
I1YESI1 or "NO." If the complete phrase does not fit, it is
acceptable to just display "SAVEw and I1YESW or "NO."
```
```
The basic position of the selection is set at selections can
be made with the lever and the selection can be chosen with
button A.
```
```
If the selection is "YES," "DATA SAVE OKw is displayed to indicate
to the player that it has been completed. If the entire phrase
cannot be displayed within the display frame, the "SAVE OKw
display is acceptable.
```
```
If the selection is llNO,w that is the end of the "MEMORY CARD
SAVEw procedure.
```
```
As a rule only for the MVS, do not show any displays regarding the
memory card unless the card is set in the unit.
```
```
Place a time limit for the foregoing selection of "YESt1 or llNO.al
(Within 10 seconds)
```
```
Software Development p.22
```

```
a Data Loading
```
```
The data loading method and points are up to each program developer.
However, the following fundamental regulations must be strictly
observed :
```
```
Common Regulations
```
```
At the loading point, display ttMEMORY CARD LOADtt and the option of
ttYES" or ltNO.w If the entire phrase cannot be displayed within
the display frame, just display "LOADw and "YESw or "NO."
```
```
The basic position of the' selection is set at t1YES,t8 selection is
to be done using the lever and to be chosen using button A.
```
```
If the selection is ttYES,tt "DATA LOAD OKtt is displayed to indicate
to the player that the procedure is completed. If the entire
phrase cannot be displayed within the display frame, the ttLOAD OKtt
display is acceptable. At this point, make an effort to display
the contents of the data to be loaded.
```
```
(Example) 2nd AREA-START POWER UP LEVEL-4
```
```
If the selection is ttNO,tt that is the end of the IIMEMORY CARD
LOADtt procedure.
```
```
As a regulation for the MVS, make sure not to display any items
regarding the memory card unless the card is set in the unit.
```
```
Put a time limit for the foregoing selection of ItYESW or "NO."
(Within 10 seconds)
```
```
Note
```
j Such words as ItSAVE" and tlLOADtl can be replaced by other words
/within the game context, if the meaning is easily understood,
/such ............................. as "retrieve progress -. --"-__.-------..-...---..._-.." scrollw -for an RPG game, etc.). ....... ... ..-. ....-

```
Software Development p.23
```

```
Regarding Demo Screens
```
```
The demo screen for the MVS (title, game demo, and ranking) should be
approximately 30 seconds.
```
```
Example: King of the Monsters
```
```
(Note) 1 We recommend using fixed characters, since the "operating
instruction^^^ and l1titlef1 displayed during the demo screen
may need excess sprites, depending on the game.
```
```
Time
(Aprox. )
5
```
```
20
```
...

```
5
```
```
software Development p.24
```
```
Details
```
```
As lonq as it is within the
time limits, title presentation
(display) can be developed
freely for each game.
```
```
Display a reduced-size title
on the game demo. (The display
position and title size must be
determined by each developer,)
Try to display the operating
instructions, although it
depends on the game's contents
(not compulsory).
However, when displaying the
operating instructions, be sure
to match the movements on the
screen with the lever and
button' movements,
```
1 T i t 1 e s C r e e n 2

G '
a m e D e m 0 3 R a n k i n 4 S C r e e n

```
Screen
```
```
KING
OF THE
MONSTERS
```
```
Operating instructions Title
mote) 1 (Note) 1
```
```
A button: punch KING OF
B button: kick THE MONSTERS
0
```
```
Demo Play isp play
Area
```
```
RANK I NG
```
```
1
2
3
4
5
```

```
Messages to be included during the demo screen (1 to 3)
```
```
MVS (Commercial-Use)
```
```
<For Ja~an and Southeast ~sia>
```
I 1 I ( PUSH P1 TO START.......
I

```
.... This message should be displayed
as long as no coin is inserted
during game demonstration. (1 to
3
```
```
<For USA and Europe>
```
```
...
.. Display these after returning
```
. the screen to the title display.
. (1)

```
Number of
credits
```
11 INSERT COIN .............

```
Message
```
1-1 10 1 (PUSH PI TO START ........ I

```
.... This message should be
displayed as long as no coin
is inserted during game
demonstration. (1 to 3)
```
```
0
```
```
1'
```
.. Display these after

. returning the screen to the
... title display. (1)

```
"INSERT COINw display
[In Japan and southeast Asia]
While two players are playing simultaneously, and the game ends
for only one player, display llINSERT COIN" for that player at the same
time as the continue countdown display. Display credits remaining to
each player separately during play. Naturally, if the game is over for
both players, display the general "INSERT COINw message along with the
general countdown display of the credits.
```
```
1'
1'
```
```
[USA, Europe]
When two players are playing simultaneously, display "INSERT COINu
and credits remaining to each player separately, whether the game has
ended for only one player or for both players.
```
```
PUSH P2 TO START
```
PUSH P1 OR P2 TO START ..

```
NEO-GEO (Home-Use)
For the home-use system, the sequence of the demonstration
displays (1 to 3 in previous page) do not have to be the same as the
commercial machines, and no credit display is needed. Thus there are
no message display restrictions, other than that minimum messages be
displayed in essential locations such as the title display.
```
```
Software Development p.25
```

Example: "PUSH START1@ is displayed on the title screen, but not during
the story description.

Example : Always display IIPUSH STARTw.

```
Software Development p.26
```

```
Screen Flow for starting of a Game for Home-Use Games
```
```
Screen Flow and ~pplicable Operation at Each Step (buttons to be
pressed)
```
```
screen
```
- (1) Start button ON -

```
-+ (3) A button ON -+
4
...................
```
. If memory card.
. is not inserted.
...................
    4

```
(5) Game start
```
. If memory.
. card is. -+
. inserted.

-(4) A button ON 1

'0 Be sure to observe the operations (procedures) in moving to the next
screen in steps 1 through 4 in the flow diagram above.

```
@&@tsq% => A note about the unification (note) regarding the operation
~hechodrwhen setting items other than difficulty levels are included.
Example: The difficulty level selection screen for "Last Resorttt
```
### MODE SELECT

c

```
PUSH A BUTTON STqT
```
```
I 8
I
1 Flashing
```
```
.The initial setting is always Mnormal.u
The initial setting is always "3."
'The item but g~sm~wW>~w%~:.:. ~&u~&~9~~&@~$~@~~aay~~~~~~I~~&~.t can be cailed t>W//..wX::... ~7.-..v~;kzvv,>~y "sound" w*a?:w~y<,..%:..*f*:.:.:.>3->:k>x or "MusicM
~~~~&x~$~~i~@~~&~~~$*~:~::~::::*~:.:.: ,<* .:<. ,, ........ Al,.g ........ 0.>7rf '.:> .........% **.v .%..
G>&3$@3$m;,. &...y<. ,,,..; $&, .&..a$$$3z :.:.d&g;w:g$gg -
1s not necessary to disp~ay - - the music
title by numbers as shown in the diagram
on the left. (The music titles themselves
can be displayed.)
```
```
<Operating Method>
The initial status of the cursor starts from the first item, as
shown above.
The cursor only moves up or down and is controlled by the up-and-
down movement of the control lever. (This does not have to loop. )
```
```
Each ............................. :.:.:.:.: mode ....................... ............... is set w*.:.:: ..... :.:.:.:.:.:* by ..............,. .................................................................... the left and right movements of the lever.
(;~p:&~~~B@~&w~fax$@@&@~~~@~$&@$&$~$~@~$~~@~~~. )
::W~::~~:::~~:ffi~~~~:*:~::::::~:K:::~.~jI:.>:.~~.I:.:.:.:.:.x.:.:.: ....... :,, ,I:'.. ................................. ...........x .I :.: .>:. :.:.:.:.:.:.:.:.: .-.. ........................................
```
```
Software Development p.27
```

Example) For the "leveltt selection, by pressing the lever to the left
from the initial status (normal), it loops in the order of
"easy," "MVS , "hard," and wnormal.w When the lever is
pressed to the right, it will loop in the opposite order.

```
Software Development p.28
```

```
Game mode and credits: 2-player game running on MvS (commercial-use)
```
```
Please refer to the following example (taken from "SOCCER BRAWL"):
```
[Domestic and southeast Asia version]

```
Software Development p.29
```
```
Credits
```
### 1

### 1

### 2

### 2

```
Machine's response
```
```
Credit decreases by one when player-1 pushes the
start button. The display will show the following
mode choices: IILEAGUE MODE/VS MODEa1. The player
cannot move the cursor off the "LEAGUE MODEaa, and
use techniques such as dimming the "VS MODEa1 line
(by changing the palette) to indicate to the player
that these cannot be selected. If, however, an
additional coin is inserted while this screen is
displayed, the NVS.MODEw will then be displayed in
normal brightness, and the player can use the
cursor to select the "VS MODEw. If the player
selects the "VS MODEaa and pushes button A, the
credit tally will be decremented, and the game will
start in the 2-player "VS MODE." (Note) Refer to
diagram 1.
* Modes can be selected only on the player 1 side.
* When an addition coin is inserted when the mode
selection screen iS displayed, the timer returns to
the initial value.
No response.
If player-1 pushes the start button, the credit
amount will be decreased by one, then the display
prompts the player to choose either "LEAGUE MODEw
or "VS MODEa1. The credit will be decreased by one
more if the "VS MODEw is selected (total of 2
credits are used).
* Only player-1 can select which the mode.
Credits are decreased by two and the game starts in
the "VS MODEm immediately.
* Mode select screen is not displayed.
```
```
Start
P1
PUSH
```
### PUSH

```
button
P2
```
### PUSH

### PUSH


Fig. 1

```
<player-1 pushes the start button <When one more credit (coin) is
when one credit is left-> added. >
I I
GAME MODE SELECT
```
### INSERT COIN

```
9
```
```
Indicate that the player cannot When one more credit (coin) is
select "VS MODEm by locking the added, show the players that the
cursor and differentiating the "VS MODEw is now selectable, by
items visually, such as dimming enabling the cursor to be moved
t and showing visually by
* brightening the line,
aY Remove VNSERT COINw from the
IIINSERT COIN", display,
The timer is reset to the
initial value,
```
```
Software Development p.30
```

[U. S. , European Version]

```
Software Development p.31
```
```
Machine's response
```
```
When player 1 pushes the start button, "LEAGUE MODE/VS MODEt1
selection is displayed but the cursor is fixed at "LEAGUE MODEu
and can not be
moved by the player. At this time, "VS MODE" is dimmed.
```
```
(The display and selection privileges (control priority) when
--------- the coins (credits) are --------_U_--------------------------------. added from the above condition)
When one or more credits are added by player 1, "VS MODE"
display brightens. The player can now select "VS MODE". The
credit total decreases when the button A is pushed while "VS
MODEt1 is selected, and the game starts in the "VS MODE1', * Only
player 1 can select the game mode. UUI---------------------------.
When one or more credits are added by player 2, "VS MODEw
brightens and the player can then move to and select the I1VS
MODEt1. The credit amount decreases when button A is pushed
while "VS MODEw is selected, and the game starts in the "VS
MODEn. * Either player -- 1 or 2 can select --------- the mode, --------.
When one or more credits are added to both players 1 and 2, the
IIVS MODEm display brightens and either player can select the
"VS MODE". is
selected, and the
game start can
select the game mode.
When player 1 presses the start button, one credit is deducted
and the selection screen for the "LEAGUE MODEw or "VS. MODEm is
displayed. But the cursor cannot be moved from the "LEAGUE
MODE." At this time the "VS. MODEw is dimmed.
<The display and selection privileges (control priority) when
the coins (credits) are added from the above condition> =>
Follows the above examples 1-3
When player 1 pushes the start button, the credit amount
decreases by one and "LEAGUE MODE/VS MODE1' is displayed. If
the player selects "VS MODEw, one additional credit is
deducted. (total 2 credits used) * Only player 1 can select
the game mode.
When player 2 pushes the start button, the credits decrease by
one and "LEAGUE MODE/VS MODEw is displayed. If the player
selects "VS MODEN, one more credit is deducted. (total 2
credits used) * Only player 2 can select the game mode.
The credit amount of the player who pushed the start button
first is decreased by one, and "LEAGUE MODE/VS MODEw selection
screen is displayed. If the "VS MODEm is selected, one credit
is decreased from the second player's credits. (total 2 credits
used)
* If player 1 pushes the start button and the "VS MODEw is
selected, one of player 2's credits are automatically deducted.
```
```
* Both players can select the game mode. If "LEAGUE MODEu is
selected, the player who pushed the button (and paid the
credit) plays,
```
```
credit
1P
1
```
-----
EX.~
1-

.---.
Ex.2
0

.--.-
Ex. 3
1-

```
0
```
### 2

```
0
```
```
1
```
### 2P

```
0
```
.--

```
0
```
### 1-

```
1-
```
```
1
```
```
0
```
### 2

(^1) '


```
Note:
When player 1 has two credits left and player 2 has one credit left, if
player 1 pushes the start button (one credit deducted from player 1) and
selects the "VS MODEw, then one credit is taken from player 2. (Player 1
has 1 credit left, and player 2 has none.)
```
[Other games (Soccer Brawl, Football Frenzy)]
I r- - -- -------- ---------------I
I ' Even if player^1 and player^2 both have one credit, if player^1 I I
pushes start button and selects "LEAGUE MODE," player 2 cannot
I I I
I I participate in the game. I I
I I
* In this case, the start button on the player-2 side will not I I I
I
I i respond, and player^2 has to wait until player^1 finishes the game. j I
I I
! I • Player^2 takes the left side of the field and attacks toward the I
I I right side, even when player 2 selects "LEAGUE MODE" to play against i
I t the computer. Only when player^1 plays against player 2, player^2 j
I would have the left field.
I

```
I
!
```
(^1) I. When the game is in the "VS MODEw, the game is over regardless of i I I
I! who wins. Therefore there is no continue play in this mode. I
Note: Certain sports games allow the players to continue the game to the end
(witil the game finishes). These games should treat the (1P and 2P) start
buttons, which are used to continue the game, as follows: the domestic
version (in which the players share credits) should check both players' start
buttons. Game software for use in the USA and Europe (where the players have
separate credit amounts) should check only the start button of the player who
has credits left.
Software Development p.32


```
~egarding Credit Characters
```
```
Please lay out the credit display when using the position indicated
below as a reference.
(Match the display line with the specified position.)
There aren't any restrictions for fonts, color usages, .:.:.:.:.:~:ji~,.:~w.;sp,:s etc., if they $...
```
.:.:.:.: are ........................... not :.:.:.:.: the standard fixed characters.. .............,..... ....................... But be .: ..:.. sure. ., ............. ..................................... to @&gig- ............ .*. :<<A.:.a:.ss::::*:. ..:.:.>.::<::*.:::,*:m:2
a@i&ssj ............................ ............> (especially .....> ........... ............................. :.: ................... ......,......,...: the ........................ credit >. :::: :..:: .......... 2 ................................. :-+.<.:.:.:. display) ;&~~~@~~~g~p~@gg.t;h@ 2::;:;~*:d*~:~~~~~~C:~.:.;.*~<:px.~xxi::::::i:m
"~'~:~~y&@~~g&&~~~O@~&@~@~~@B&~~ P:.:.:.. ...... ::::::::.:.:.. .<;..:.:.:,:.:.: :.:r....:..:.:.:.:::::.:...:.:.>>:.:.:.:.:.:.:.ti....: <....... ~...., ..s*:*>>:.: ( ln the scro 11s dur-ng the game)

```
I Confirmation of the Display Position
```
```
= 8x8 dot (character size is 8x8 dot)
```
```
------------------^320 dots (40 characters)
```
```
I
224 dots
8 characters)
```
```
Software Development p.32
```

```
Regarding the Continue Option
```
```
MVS (Both Domestic and Foreign Countries)
Simply use llContinuew and "Not Continue." his excludes the number-of -
plays display.)
```
```
Home-Use (Domestic and Foreign Countries)
```
1. Definitions and Number of Repetitions for the Continue F'unction

```
The wcontinuew function refers to when the player's remaining life,
etc., becomes 11011 after starting the game, and the player can continue
the game although the game is over, The game can be continued up to
three times.
```
```
Player 1 => Can continue three times
Player 2 => Can continue three times
```
```
* The player can continue only three times even if it is a one-player
game. Even if the game is replayed by using the memory card, the game
can only be continued three times.
```
,(Note) When the player presses the "startg1 button at the beginning of
the game, the player is not continuing a game, so be sure not to count
this as .the player's continuation of a game.

```
When the player does not choose to wcontinuelt a game during the
continue countdown though,the player still can continue the game, the
game will be over with a one-player game, and the display returns to
```
```
countdown. For example, if player one did not choose to continue the
game during the continue countdown although it was possible, but as
```
```
Software Development p.33
```

2. Difficulty Level Setting During the Start of a Game

The difficulty level setting can be changed by the player before
starting a game (after pressing the start button), for home-use games.
(Refer to the games after the home-use "AS0 11.")

```
b'~he Flow of the Screen and Operation Methods at Those Times
```
```
screen
```
rt button ON -

```
1
```
I

```
(2) A button ON 4
```
" load"

.............

. If memory.
4 (3) A button ON. card is.
1. inserted.
................................
. If memory card. 1
. is not inserted.
...................
1
I I
1 (5) Game start I ~(4) A button ON^4

* Be sure to observe the operations (procedures) in moving to the next
screen in steps 1 through 4 in the flow diagram above.

```
(Note) 1 => The "StartN button to enter the difficulty level
selection screen, and the priorities for the control:
```
```
Player 1 start button is turned on => Can change the settings
for player 1. (Player 2 cannot change the settings.)
Player 2 start button is turned on => Can change the settings
for player 2. (Player 1 cannot change the settings.)
Both players 1 and 2 press the start button on => Both players
1 and 2 can chanae the settinss toaether.
```
```
Software Development p.34
```

```
(Note) 2 => Please use the following two examples as reference for the
control method for the difficulty level setting screen.
```
```
Example 1: AS0 I1 (Only the difficultv level settins) I
```
```
level of the
```
```
(Taken from the
the commercial machines)
NORMAL - - - - - - - from the difficulty level of the
```
MVS - - - - - - - - - - - - machines

```
* If there are less than four levels of difficulty for the
commercial machines, overlap the same levels.
(Example) : Have "Normaltt and "MVS" at the same difficulty
level,
```
* If there are more than four levels for the commercial machines,
"Normaltt should be set at a less difficult level than with the
"MVS."

```
he lever moves the arrow vertically, and the A button selects the
level.
Position the arrow at nNormalw as the initial level,
```
Example 2: Last Resort (When other settinas besides the difficultv
level are included)
I I

```
The initial status is always mNormal.w
MODE SELECT The initial status is always "3." (Will not
```
. ao above 31

```
The initial status of the arrow is set at wLevel,m as indicated
above.
The vertical movement of the lever moves the arrow. (Only moves
vertically. The menu should loop between "Levelm and "Sound.")
```
```
PUSH A BUTTON s~AR~--.-titles
```
```
Software Development p.35
```
```
can be displayed as well.
Flashing
```

```
The each item should be selected with the horizontal movement of
the lever, (Do not let the buttons set the selection.) The
selections of each item should loop also,
```
```
Example: Level Selections
...,..a w:<.:.: - && - &$;.:.;
r &. - Normal M~..:.:.: -., Ess%&h ... 43 1
--
The selection loops between "Easyw and :MVSw by the left (+) and
right (4) movements of the lever,
```
```
The characters that are displayed in the game should use each
game's original ASCII (8x8) characters, The words displayed on
the screen should be as shown in the diagrams above, If the arrow
character is not available, replace with another character,
```
```
Please decide on the position arrangement of the characters by
using the above diagrams as reference. Also, please make design
decisions of the menu background for each game, since any type of
backgrounds are acceptable.
```
* Please decide on the items to dis~lav for the "exam~le 2"-twe

```
Software Development p.36
```

```
(3) Display of the Remaining Number of Continuing Plays
```
```
Display the remaining number of continue plays during the continue game
screen in a way that can easily be understood by the player.
```
```
isp play the following during the countdown in the continue game
screen :
```
- Please display these using each game's original ASCII (8x8)
    characters,
- The number is set at "3" initially, and the number decreases every
    time the game is continued.
- For the games where two players can play at the same time, display
    this continue option independently for players 1 and 2. Position
    this display where it is easy to see for the player (such as the
    position where the score or remaining lives is displayed).

```
* However, the continue game display varies depending on the games,
so please make design decisions for every development regardixig
detailed display settings,
```
```
<Example of the Screen is play Layout>
```
```
Example 1:
```
1 CONTINUE 9 CONTINTJE 9 I countdown Display

### P1 00000 P2 00000

```
Example 2:
```
```
Remaining Number of Continue Games
```
```
Countdown isp play
```
```
Remaining Number of Continue Games
```
```
Software Development p.37
```

```
* In example 1, the remaining number of credits and the countdown
are displayed immediately after the player crashes and the screen
switches to the continue screen. Then, the remaining number of
credits and countdown are erased when the continue operation is
exited (the start button is pressed), or the countdown has ended.
```
```
* In example 2, the credit display for the (foreign) commercial
machines is used for this purpose, so there is no need to erase
the credit (remaining number of continue games) display.
Regarding the display timing, display the remainins number of
continue crames after the start button is pressed. If only one
player starts a game where two players can play at the same time,
it is acceptable for the side of the player who is not
participating in the game to display "CREDIT 4" as the remaining
number of continue games. Also, please display "CREDIT Ow instead
of erasing the credit display when the last continue game is
played.
```
```
** Although two examples were shown above, it is recommended to use
example 2 to allow the laver to understand clearlv how many
.continue aames are left, However, as stated before, this is not
enforced and the design decision for this aspect is up to the
developers. The most appropriate method for each development
(game) can be used, but the priority should be placed on the
player being able to understand the display clearly.
```
```
(4) Canceling the Continue Function (Speeding Up the Function)
```
```
By pressing any of the buttons A-D during the continue countdown, the
countdown speed can be increased. (When the button is pressed
continuously faster than the normal countdown speed (one second/count),
the countdown speed in increased to the speed of the press of the
button. )
```
If both players 1 and 2 crashes (ends the game), and the game enters
a "total continue state,I1 only the plaver that has remainins credit
(number of continue sames) can cancel the countdown usins hislher
buttons (A-D).
This is intended to give priority to the player with remaining credit
(number of continue games),
(This is to prevent the player with remaining credit from not being
able to. continue a game because of the player with no remaining credit
(number of continue games=O) pressing the buttons by mistake.)

```
Software Development p.38
```

*** (2) Supplement regarding the difficulty level when starting a game

Having four difficulty levels is a minimum requirement. However,
there are basically no restrictions in including different setting
items (sound mode, number of lives for each game, etc.) seen in general
home-use games.

```
Details (for each button A-D)
```
```
Responds to both players 1 and 2
Only responds to player 1
Only responds to player 2
Not necessary to allow the players to continue
(including any displays). Just a E%$%8%$i%%%@ <...= m:.:d:.,d4 ,-= display is
sufficient.
```
```
Credit
(Number of
Continue
Games )
```
Regarding buttons A-D when canceling the continue countdown for the
commercial machines

### 1P

### 1-

### 1-

```
0
0
```
```
<Domestic and southeast Asia versions>
* When the coin-shooters are the same for 1P and 2P.
```
### 2P

### 1-

```
0
1-
0
```
```
Software Development p.39
```
```
Credit
```
### 1-

```
0
```
```
The responsiveness of buttons A-D when both
players have the continue option
```
```
Responds
Responds
Responds
Responds
```
```
Buttons A-D
1P
Push
```
```
Push
```
### 2P

```
Push
```
```
Push
```

```
<US and European versions>
* When the coin-chutes are independent
Please observe the buttons (A-D) on the player side where the
continue option is being offered, regardless ofthe number of remaining
credits for the US and European versions (the coin-chutes are
independent).
```
```
<An Example of the Continue Display>
* The games "Garo Densetsuw and "Last ResortN are used as reference
examples below:
```
```
Example: ~epending on the game mode selected, the second player cannot
join during the middle of a game, but can continue in the
middle of a game.
```
```
The response of buttons A-D
```
```
When player lls game is over and the credit for player
1 is llO,n the function can only be sped up by the
buttons (A-D) on the player 1 side, even if player 2
has some credit left.
When player 2's game is over and the credit for player
2 is wO,lt the function can only be sped up by the
buttons (A-D) on the player 2 side, even if player 1
has some credit left.
When the game is over for both players 1 and 2,
"individual speedingw can be performed using the
buttons for each player 1 and 2, regardless of whether
there is some credit left for player 1 and 2.
```
```
Continue
```
```
Example: Use I1total continue statet1 when it is a one-player game, and
switch to ttindividual continue statet1 displayed when a second
player participates from the middle of a game. (As a safety
measure, by displaying the "individual continue statet1 on the
screen even when the number is being displayed with "total
continue statet1 display, switching would not be necessary
when required; just the Ittotal continue state1' would be
removed from the screen.)
```
### 1P

```
o
```
```
0
```
(Note) For games that can be continued until the game is over, such as
certain sports games (baseball), observe both 1P and 2P buttons for the
domestic and Southeast Asia versions to continue the game (1P and 2P).
Observe only the side with some credit left for the US and European
versions.

### 2P

```
o
```
```
0
```
```
Software Development p.40
```

```
Regarding Company Logos
```
Company Logos for the MVS (for business-use)
<~omestic>

Company Logos for the Neo-Geo (Home-Use)
<Domestic>
~-----------------------------'--- -I

```
i S N K SNK HOME ENTERTA I NMENT. I NC. 01 99x j
4 : ' - I m -a+
```
<other Foreign Versions>

```
a -------------------------------------------- a
```
```
1, Company Logo (Standard FIX)
```
2. Company Name (Original Characters for Each Game)
3. Copyright and Year

```
Regarding Debug Dips
```
```
If the debug dips used during the debugging of a game are submitted
for "sample location or as Itmaster ROM,,,
ws<s<..%...: ........ :,..><.. ...., ".., *<<.>.>..:,.. ....... .............. .:,. ...... .... ..<,.. >..>~F<:w$.:y.xy.p ........... ..,: .,.:.,.:: 3p.;<,.:.:*F<?-.v* ........ m..
```
. ,..:... ...... ......,.. ..... .. .... .<: .............. %.. ......,.... .............................................................. (If the debug modes
    inserted with other games in the MVS unit, the game may halt after one
round of the demo,)

```
Software Development p -4 1
```

```
Items to be Standardized for Level Displays
```
```
The level (difficulty level) to be displayed on the screen is
standardized as shown below.
```
1. Adapting Range
    The display is limited to the MVS (domestic and foreign are the
       same).
2. Display Position
    The display position should basically be in the bottom center.
However, if this space'is necessary for displaying another item,
please adapt a new setting, using appropriate judgement for each
case.
3. Character Size and the FIX for Display
    The character size should be an 8x8 dot matrix. Use the standard
    FIX, or FIX exclusivel~ used for the same.
       Please take precautions about visibility and character size when
    using the FIX exclusively created for the game.
4. Regarding the Word Usage (Spelling)
It is standardized to "LEVEL-O~~. * will be filled with the
    applicable level.

* Layout Reference Diagram

```
Level Display position
```
```
t-fl > .,. -.A.. ,,-.. .?.>.. 4
L E V Ii: L - 0
```
```
Lower Screen Area
```
```
Software Development p.42
```

```
Regarding Other Regulations
```
```
Regulations for the Forced-Start Countdown (only for MVS)
```
When the MVS unit has "forced start enable," the forced-start countdown
starts when a credit becomes available. When the countdown reaches
zero, the game starts automatically. (When another credit is added,
the countdown is reset, and the countdown starts again.) Please use
the FIX characters specified by our company and follow the standard
position specified by our company for the display position of the
countdown display.

```
Countdown Display Position
```
```
Software Development p.43
```

```
Display for the Playing Instructions
```
```
Mainly for the multiple-slot MVSs, sufficient playing instructions
cannot be described using an instruction card, as usually done for
other commercial machines. Therefore, there is a method to explain the
operations by displaying the playing instructions on the screen during
a game, instead of having an instruction card.
```
```
There are no restrictions on characters, etc. for the screen display
but limit the display time between 4-10 seconds, so that the play time
and demo time will not take too long. Also, have the option available
to be able to interrupt this display using the buttons.
```
```
If the playing operations are simple and the game can be understood
without any instructions, it is not necessary to include the playing
instructions. However, we may request that the playing instructions be
created after our companyvs evaluation of the same project.
```
```
Regarding the starting Method (also refer to vlSystem ROMI1)
```
For the Japanese and Southeast Asian MVS units, the 1P button is used
to start player 1, and the 2P button is used to start both players 1
-and 2. For a 2-player simultaneous play, the game is started using
this method, and during the game the 1P button is used to start player
1 and the 2P button is used to start player 2.

```
For the US and European MVS units, 1P button (left side) is used to
start player 1 (left side) and 2P button (right side) is used to start
player 2 (right side).
```
```
For the Neo-Geo, these design decisions are up to each development.
```
```
Software Development p.44
```

```
Regarding Other Regulations
```
```
Naming Regulations
```
```
Please follow the following regulations when the naming option is
available for high scores and records with the Neo-Geo and MVS games.
However, if the game is completely unique, please make design decisions
for each development.
```
```
I The timing for the naming should be after the game is over (when
the remaining lives reaches 0, when time runs out, etc.), and
before the continue option is displayed.
```
```
I Please allow only three letters for the name entry. This is also
to prevent any profane words or any anti-social words to be
entered for the machines used overseas.
```
```
I The basic operation method when entering the initials is to select
the letters using the vertical movement of the lever (or
horizontal), and choose using the A button (move to the next
letter to be set, or after the third letter, end the naming). In
order to return to the previous letter that had been set, include
such backspace symbols as "+tl in the letter set or have the system
be able to return to the previously set letter using the B button.
Also, include the ending symbol such as I1ENDW in the character set
for the player to be able to exit without having to enter all
three letters.
```
```
4 Characters that must always be included
```
Always include the characters specified by our company in the ROM to
display the characters for the system-related displays in the Neo-Geo
and MVS.

```
I Sprites: Neo-Geo eye-catcher logo (use all 58 characters)
I FIX: Standard characters for system control (can use FIX from
bank 00 to 02)
I FIX: Characters for the number of credit display (can use all
21 characters)
```
```
Note: Regarding the Manufactured Year Display
```
The manufactured year display that must be displayed in the title
screen, etc. should be the year when the product began being marketed.
So please take note for products that were completed over the course of
more than one year.

```
Software Development p.45
```

I ~egarding Other Regulations I

```
Creating the Soft Dip Chart
```
We include the soft dip manual for the product for MVS cassette
marketing. Please create a soft dip manual for each game when the
details of the game soft dip have been determined.

```
(Creation Example-1) "Quiz Big Search" Made by Our Company
(The actual size is A4.)
```
```
Quiz Big Search Soft Dip Details
```
```
Quiz Big Search
```
```
B Hero
Continue
Demo Sound
Playing Instructions
Difficulty Level
Bonus Rate
Bonus
Correct Answer Display
Credit
```
```
11 Hero This sets the number of lives the character will
have.
```
```
21 Continue
```
```
Software Development p.46
```
```
Operating Method Place the arrow to ."Hero1@ using the vertical
motion of the lever., and proceed with the
setting using the "Aq1 button. The @@B1@ button
restores the screen and establishes the
setting.
```
```
This sets the number of times the game can be
continued.
```
```
31 Demo Sound
```
```
Operating Method Place the arrow to llContinuell using the
vertical motion of the lever, and proceed with
the setting using the ggA1l button. The t8Btt
button restores the screen and establishes the
setting.
```
```
This determines whether there will be sound during
the demo game.
Operating Method Place the arrow to "Demo Sound1@ using the
vertical motion of the lever, then proceed with
the setting using the @@A1@ button. The l@Bw
button restores the screen and establishes the
setting.
```

```
4/ Playing
Instructions
```
```
This determines whether there will be an operating-
instruction screen at the beginning of a game.
```
```
5/ Difficulty
Level
```
```
Operating Method Move the arrow to Itplaying ~nstructions~~ using
the vertical motion of the lever, then proceed
with the setting using the "Aw button. The IIB"
button restores the screen and establishes the
setting.
```
```
This sets the difficulty level of the game. (There
are 15 levels from 1-15, and difficulty increases as
the number increases.)
```
'

```
Operating Method Move the arrow to "Difficulty Levelg1 using the
vertical motion of the lever, and proceed with
the setting using the I1AW button. The "BM
button restores the screen and establishes the
setting.
```
```
7/ Bonus
```
```
Software Development p.47
```
6. Bonus Rate

```
This sets the score where the character's life
increases by one.
```
```
8/ Correct
Answer Display
```
```
his sets the system where the remaining lives in the
game will increase according to the players1 scores.
```
```
Operating Method Move the arrow to "Bonusw using the vertical
motion of the lever, then proceed with the
setting using the "Aw button. The "BW button
restores the screen and establishes the
setting.
```
```
This determines whether the correct answer is
displayed when the question is answered incorrectly.
```
```
Second Bonus The number of lives will increase by one, according
to the score, up to two times.
Every Bonus The number of lives will increase by one,
according to the scores for an unlimited number
of times.
NO Bonus No lives will be added.
Operating Method Place the arrow to "Bonus RateM using the
vertical motion of the lever, then proceed with
the setting using the "Am button. The "BW
button restores th.e screen and establishes the
setting.
```
```
Operating Method Move the arrow to Itcorrect Answer Displayt1
using the vertical motion of the lever, then
proceed with the setting using the "Af1 button.
The "Bm button restores the screen and
establishes the setting.
```

```
Software Development p.48
```
9/ Credit This determines whether there will be a credit
display for the MVS.

Operating Method Move the arrow to @ICreditw using the vertical
motion of the lever, then proceed with the
setting using the llA1l button. The llB1l button
restores the screen and establishes the
setting.


```
~egarding PAL (European) Specifications
```
```
The following areas are different for PAL (European version)
CnnPi .a. t i par.. i nn trnm - nr.. nnr vnrc i nnc
```
1. Only 224 dots are displayed vertically on the screen for the
    en TTc A -4 n en kq.4- T..; th the Firrnnn-n xrnre;nn AC DXT
~36 aocs are alsplayea verclcally on me screen. xnererore, slnce cne
areas that are not displayed for the Japanese, US, and Asian versions
are displayed (16 dots each for top and bottom). Items with the
undisplayed regions will now be displayed. This may result in an
unappealing screen, so please strictly follow these regulations:

```
(1) Display the 16 dots at the top and bottom that could not be seen
with other versions accurately (able to see) even when changed to
the European version. (Create the Japanese, U.S., and Asian
versions with awareness of the 256 dot vertical display.)
```
```
(2) In a game with the 256-dot vertical setting, more than 256 dots
will be displayed if the screen is to be swayed vertically to
express a shaking motion, etc., so add FIX characters (black
coloring) to hide the top and bottom of the screen.
However, the size should be just one character (8x8 dot matrix
(Note) refer to the diagram below). (Have the vertical length of
the shaking within 8 dots.)
```
2. Only for the PAL specification (European version), the vertical
synchronizing is done from 1/60 to 1/50 of a second. (The CPU speed of
the program becomes 516. The sound does not change. ) If the sound and
music are supposed to match the screen display (such as the title demo
and ranking) , there may be some lagging between the two, so adjust
these errors with the sound engineers'and programmer. (This is not
applicable during a game.)

```
Software Development p.49
```

. ~;;an.+~~q~:.~-= ..
    Parts to be hidden with FIX characters

* Japan, U.S., and Asian versions -, 224 dots (vertical) x 320 dots
(horizontal)
* PAL version -, 256 dots (vertical) x 320 dots (horizontal)

```
Software Development p.50
```

```
~egarding Debugging
```
```
What is Debugging?
```
```
~ebugging is performed when the game is in the condition where it can
be played, The existence of bugs must be checked for different
conditions including: a bug that appears during game play, bugs that
appear between the system program and game program, and sound-related
bugs,
```
When a fatal bug that seriously affects game progress is discovered
after the mask ROM has been mass produced or the product has already
been placed on the market, the production line may have to be halted or
the product may have to be recalled, either of which can lead to a
massive loss. Therefore, please be very careful and explicit about
debugging,

```
Common Debugging Examples
```
The debugging technique differs depending on the game systems, The
following examples are very general, so be more precise when actually
debugging, in accordance to judgement of every development,

```
MVS: Can the selections be made using the select button, even if
multiple software are set in the slot?
MVS: Has the instruction card corresponding to the game set in the
slot been written up?
MVS: Does the number of credits on the unit display match the
number of credits displayed in the game?
MVS: Does the game reflect every item setting in the Mode
Parameter setting?
MVS: Are the "unit settingsw and "individual software settingsw in
the Mode Parameter Setting being reflected?
MVS: Has the "income record" of the Mode Parameter Setting been
correctly added/calculated?
MVS: Does the machine eat up coins?
```
```
Neo-Geo: Does the game correspond to the number of continue limit
set?
Neo-Geo: Does the game reflect the differentiations made in the
game contents with the MVS game?
```
```
Do display, coin system, and various settings correspond to
various system ROMs?
```
```
Can memory card saving/loading be performed according to the
specifications?
Can the memory card be used between the MVS and Neo-Geo?
Perform irregular operations, such as changing the memory card
with another card after the "Memory Card Save?" prompt is
displayed-
```
```
Software Development p.51
```

Are there any errors in spelling or display settings?
Do the lever and button response reflect the specifications?
Are the 'hits' being correctly registered as they are set for all
types of characters?
Are the shapes and colors of the characters being displayed
correctly?
Does the game "fall" into a stage where the main character can no
longer be controlled, or the enemy can no longer move?
Are the scores being added and calculated correctly?
Are there any infinite loops?
Are the priorities for the sprite being displayed as specified?
When enemies are left on the screen intentionally, are there any
bugs from such factors as slower CPU processing speed?
Similarly, do items disappear that aren't supposed to disappear to
proceed with the game, by 96 sprites lining up on the same
horizontal line?
Can the sound (BGM and sound effects) be heard as they were
specified?
Does the continue system function appropriately?

```
Software Development p.52
```

```
[I] Start-Up Checks
```
.* The checking is done after the backup has been cleared.
* The write-ups with the instruction card are only done with the six-
slot units, old SCB units, and American units.

```
[2] Soft Dip Inspection (Unit Settings)
```
```
Are there any irregularities when inserting a game in
any of the slots?
Does the demo game loop correctly even when multiple
software packages are inserted in the slots?
Can selections be made using the selection buttons with
the same settings as above?
Are instruction cards being written for the slots that
are set?
Are there any irregularities when software from another
company is inserted?
```
```
~nit/Classification by U.S.A. Europe
Country
Six Slots
Four Slots
Two Slots
One Slot
```
```
Software Development p.53
```
```
Southeast
Asia
```
```
~omestic
```
```
Item
Coin 1
```
```
Coin 2
```
```
Game Select
```
```
Forced Start
```
```
Demo Sound
```
```
Contents
1 Coin= Credit
2 Coins= Credit
coins= Credit
Coins= Credit
Coins= Credit
Coins= Credit
Coins= Credit
Coins= Credit
Only when there is credit
Free
1-60 seconds
None
Set by each game
None
```
```
Demo Game Remarks
```

```
Software Development p.54
```
```
Remarks
```
Item

Unit

Software

```
Item Game
Continue
Limit
```
```
Demo Sound
```
```
Playing
Instructions
```
```
Credit
Display
```
```
Difficulty
Level
```
```
Bonus
```
```
Contents
Coin 1
Coin 2
Service
Number of plays
Number of times to continue
Average play time
```
```
Contents
Limit
None
Sound
None
Instructions
None
isp play
None
1 2 3 4 5 6 7 8
```
```
None
Second Bonus
Every Bonus
```
```
Demo
****
****
```
```
****
****
```
```
****
****
****
****
****
****
****
****
****
****
****
```
```
Check Remarks
```

```
[S] Inspection in the coin-Insertion Regions
```
```
Software Development p.55
```
Item
After the power is turned on,
continuously insert coins before the
demo starts and confirm the effects.
Also, confirm the service switches in
the situation above.
Continuously insert coins when the demo
starts.
Continuously insert coins when the demo
screen is changing.
Continuously insert coins when the demo
screen is complete.
Continuously insert coins at the start
of a game.
Continuously insert coins when the game
screen is changing.
Continuously insert coins when one
pattern has been completed.
Continuously insert coins when the game
is over.
continuously insert coins when entering
the name.
Continuously insert coins when the
lever and buttons are pressed.
Insert coins at the same time the start
switch is turned on.
Press the one-player button and two-
player button at the same time when the
credit display shows wl,w and confirm
that the credit display will not show
"99. 88
Start player-one or player-two when the
credit display shows wlO,M and confirm
that the credit display changes to "9."

Confirm that the counter is linked with
the number of coins inserted, and not
the credit.

Confirm that the credit display on the
unit matches the credit display on the
screen.

Insert more than 99 credits.

```
Coin1
```
.

```
Coin2 Counter1 Counter2
```

```
[6] Memory Card Inspection
```
```
[7] Game em on strati on ~nspection
```
```
Item
Can the memory card load and save according to the setting?
Can the memory card be used between the MVS and Neo-Geo?
Insert a memory card that is full.
Insert an unformatted memory card.
Insert a defective memory card.
```
```
Check
```
```
Software Development p.56
```
.

```
Item
Confirm the company logo.
Are there any spelling errors or display errors?
Are there any irregularities in the characters or
background screens?
Are there any irregularities in the shapes or forms of
characters8 items or energy gauges?
Will the credit increase without having any coins inserted?
Are there any irregularities when the start switch, lever,
and buttons are pressed without the coin being inserted?
Are there any irregularities when the start switch is not
pressed after inserting a several coins?
Are there any irregularities when coins are inserted to
start a game during screen changes?
Are there any irregularities when the start button is
pressed during a forced start?
Confirm the demo after the game is over during standard
Play
Confirm the same situation as above during continued play.
Confirm the demo after entering the name for the high-score
record.
Confirm what happens after the game is over if the demo
sound is turned off.
Confirm what happens after the game is over if the demo
sound is on.
```
```
Check
```

[8] Game Operation Inspection (* Perform according to each software
development.)

```
Software Development p.57
```
```
Item
Are there any mistakes in the display settings for any of the
displays?
Are the lever and buttons as specified in the setting method?
Are the colors and shapes of the characters displayed
properly?
Is the score being calculated correctly?
Does the sound (BGM and sound effects) correspond to the
setting?
Is the continue-service function working properly?
Does the random pattern occur?
```
```
Check
```
-


```
Continue pressing the lever and buttons for player 2 when
player 1 is playing.
Keep on pressing the lever and buttons for player 1 when
player 2 is playing.
Let players 1 and 2 start, and do not touch anything.
confirm any malfunctions when different items are used
continuously when player 1 is playing.
Also confirm the same as above item for player 2.
Apply attacks on every enemy character using every item for
player 1 and player 2.
Try entering from different angles in the areas on the screen
where entry is not allowed for players 1 and 2.
Escape as much as possible without regarding the enemies for
players 1 and 2.
Minimize the attacks on the enemies and go forward as fast as
possible for players 1 and 2.
Kill the enemies as fast as possible or in a way that the
most points will be obtained for players 1 and 2.
```
.Alternate players 1 and 2 and proceed during continued play.

```
When player 1 is playing, have player 2 participate from the
middle of the game, matching the timing with when player 1 is
making a move or when the enemy is attacking, etc.
When player 2 is playing, have player 1 join in the same
manner as described above.
With player 1 only, have the player obtain a high score at
the final screen of each area. Then get killed there, and
proceed to the next scene after entering the name for a high
score.
Confirm the same setting as above for player 2.
During a two-player game, keep on pressing the levers and
buttons after completing each area, before the next area
begins.
During a two-player game, proceed by attacking each other or
being intertwined together.
During a two-player game, proceed by making the same motions
simultaneously for both players.
During a two-player game, proceed by making the same motions
as the enemies, simultaneously.
Proceed through the final screen with just player 1.
Clear the final screen with just player 2.
Clear up to the final screen by showing all possible
characters, filling up the screen.
```
```
Software Development p.58
```

.-..I----.......-.-- -.-... ...- -... "-".--"-..-.---.--------.--.----..- .... --I-........-.-.- ...-...... _. ......-.....- " .....-
j Note : Be sure to perform debugging with the MVS with the
software debug dip removed. (When inserted with certain
software, it may be reset during the title loop.)

i~e sure the debugging mode does not start up in any case, for both f
ithe samples and master ROM. :

```
Software Development p.59
```

```
Inspection of System Development Simulation
```
```
* Bug-checking using the simulation of Neo-GeO System Development
ROM (Ver. 6.1).
```
```
(1) The simulation setting screen (1) is called up when the Select +
C button is pressed on the player-2 side.
.(l).
MODE SET
MAIN SOFT DIP
GAME SOFT DIP
RESTART
DEFAULT START
GAME START TEST
CARD FULL
CHECK SUM
BOOKKEEPING (CARD)
GAME DEBUG DIP
```
```
MODE SET Sets the version
setting
MAIN SOFT DIP MVS unit setting
GAME SOFT DIP Soft dip for each game
RESTART Reset
DEFAULT START Clear the backup area
GAME DEBUG DIP Soft dip for the
setting during
debugging of a game
```
```
* The Europe-Asia specification for.the MVS is only for Southeast
Asia (Korea).
If checking the MVS Europe, select USA.
* When checking the Neo-Geo, select Normal Neo-Geo.
```
```
(2) Simulation of each specification is performed according to MODE
SET.
(2
```
+ Start the game by setting the MODE, returning to screen 1, and
pressing DEFAULT START (clear the backup area).

### TYPE NORMAL NEO-GEO

### COUNTRY JAPAN

...........................

...........................

```
Software Development p.60
```
```
TYPE Neo-Geo/MVS
```
```
COUNTRY Japan/USA/Europe-
Asia
```

```
Main Soft Dip (MVS unit setting)
(3)
MAIN SOFT DIP
COIN 1 1 COIN = 1 CREDIT
COIN 2 1 COIN = 2 CREDIT
GAME SELECT ONLY WHEN THERE IS CREDIT
GAME START COMPULSION 30s
DEMO SOUND SET FOR EACH GAME
```
```
Start the game by making the selections with the A button and
returning to screen (1) by the C button.
When inserting coins for the game, press Select -I- A for coin 1 and
Select + B for coin 2.
```
```
Match the setting of the initial specification of the version set
in (2)- (The MVS system matches the setting with the initial
specification automatically,) * Refer to the MVS Regional
Specification.
```
```
confirm that everything is created as specified for every version.
The meanings of coin 1, coin 2, start button, coin counter, and
credit display differ depending on the version.
When a bug is detected during the coin check, check again with the
MVS, and when the bug is not detected with the MVS, it is
considered normal.
The demo sound will be off if it is in the MVS setting.
Change the settings and confirm whether the system will operate
properly,
```
```
Game Soft Dip [Soft dip for each game (4) ]
(4)
I GHOST PILOTS
HERO 3
CONTINUE NO LIMIT
DIFFICULTY^3
BONUS SECOND BONUS
BONUS LATE 10000/30000
HOW TO PLAY WITH
DEMO SOUND WITH
CREDIT DIPS WITH
```
-+ Start the game by making the selections with the A button,
returning to screen 1 using the C button and pressing RESTART.
-+ Confirm that the game operates as specified.
-+ Change the settings and confirm that the game operates properly.
-+ Confirm that it corresponds correctly with the MAIN SOFT DIP.

```
Software Development p.61
```

```
(5) Debug Dip (Soft dips used during debugging by the software
developers, changing the settings as necessary.)
```
### DEBUG DIP

### 12345678

```
00000000
```
I DIP 2 00000000 I

```
-b Start the game by making the selections with the A button,
returning to screen 1 using the C button, and pressing RESTART.
-b In order to correspond with the bugs that appear with certain
conditions, confirmations are made by reproducing the conditions
using the debug dip.
-b Make different settings by hypothesizing different conditions, and
confirm that it operates correctly.
```
```
e For the simulation bug-checking, examine thoroughly such main
areas as whether the game has been created correctly according to
the specification, or whether there are any display errors or
characters errors.
~r Refer to the MVS bug-checking list when checking.
```
```
<Measures to Take When a Bug Has Been Detected>
```
1. Version MVS/Neo-Geo, region, number of players
2. Date/Time Write down the date and time when the program ROM has
been completed and when the bug has been detected.
3. Effects Write clearly the conditions of the bug. If taping the
game on video, be sure to have a counter.
4. Cause Write clearly what scene, what operations were being
done, and what condition the game was in when the bug
occurred.
5. Frequency Reproduce the same conditions several times to confirm
their frequency.
(* A= The bug always shows when the conditions are met.
    B= The bug shows frequently.
       C= The bug sometimes shows.
       D= The bug rarely shows.)

-b Note and comprehend the items 1-5, report to the planner, and
submit this to the programmer.
-b Always confirm the new program ROM when the bug has been
eliminated.
-b Confirm that no other parts of the software was effected by fixing
this bug.
-b Report to the programmer.

```
Software Development p.62
```

```
After the bugs have been removed and the game has been completed,
location testing is done by actually setting up this game at the arcade
to observe the reactions of the general users and income numbers to
make final adjustments.
```
```
The location testing sometimes cannot be continued if a bug has been
detected during location testing, and accurate data may not be
obtained; so please make sure to perform the testing after all the bugs
have been removed. The most problematic types of bugs during debugging
are listed below:
```
```
Bugs that stop the proceeding of a game such as the game being reset
during play, the. screen. .freezing, and the main character or enemies
"f allingw to a stage. where -they cannot move.
```
```
Income record is not accurately factored.
```
Besides the data collection of income numbers, game play time, etc. the
developers must also go to the arcade to check the popularity of the
.game, reactions of the players, difficulty levels, etc.

```
(General Examples)
*' How is the income? The most important factor in location
testing is the income. If the game does
not have a good income during location
testing, adjustments and improvements
must be made to the game. It is also a
problem if the initial income is high,
butthe income drops significantly after
a week, It is best if the game
maintains a stable high income for a
long period of time.
```
```
* What about the play time? If the average play time is 'long, this
may result in decrease of income because
each player is playing for too long.
Adjustments and improvements may also be
necessary if the play time is too long
during location testing. (The ideal
play time that our company determined
for an MVS game is 2 minutes 30 seconds
to 3 minutes 30 seconds)
```
```
* What about the attraction? Check to see if it attracts people's
attention during the location testing.
The attraction will not be good if the
game is not appealing as a new product.
```
```
Software Development p.63
```

```
* Is the game being understood? Check to see that the player
understands the operation methods,
game objectives, and character
intentions. If there are problems
for the players in grasping the
game, make appropriate adjustments,
correct the display method, etc.
```
```
* How are the difficulty levels? The difficulty level cannot be
evaluated by just the average play
time. Developers actually need to
observe the players to evaluate
this. If the game is too difficult
(or easy), adjustments must be
made. (Please be careful to
differentiate between general
players. and expert players, to
avoid making erroneous
assumptions. )
```
```
* What about the number of continue plays?
The number of times the game is
continues increases for more
appealing games. It is best if the
game makes the players want to
continue the game.
```
```
* Are there any bugs? Remove the bug immediately if a bug
is found during the location
testing. (If the bug causes
problems in proceeding with the
location testing, the location
testing obviously cannot be
continued. So please perform the
debugging completely and carefully
before the location testing.)
```
```
If another development company uses our company's location testing
sites, please have an observer (one who observe the location
testing on a regular basis) provided by the development company.
Also, make sure to notify our company of where we can reach the
person in charge at the development company during the location
testing. (Please do so for weekends and holidays also.)
```
```
Reference: ."Regarding Our Company's Location Testingg1 (February
1991 to present)
```
Corrections and improvements (remove the items that are not necessary)
are made after a minimum of one week's worth of location testing data
with our policy. Then, after the completion of appropriate adjustments
the final version goes through another location testing for three days.

```
Software Development p.64
```

NEO-GEO BASE UNIT MANUAL FOR

DEVELOPMENT


```
This NEO-GEO base unit has been modified on the basis that it is to be used for
development. The unit has NEO-MVS SYSTEM ROM which allows game debugging.
Also it simulates arcade software with the home entertainment system.
```
```
USE OF NEO-MVS SYSTEM ROM
```
```
[Function]
```
```
Press 2P-A-BUTTON while pressing 2P-SELECT * enters COIN1
Press 2P-B-BUTTON while pressing 2P-SELECT G- enters COIN2
```
```
(It is only valid in MVS mode. When in USA mode, COIN2 is PLAYER2-COIN)
```
```
2P-C-BUTTON while pressing 2P-SELECT G- system menu
```
```
(When SYSTEM-MODE bit7 is 0 this function is disabled)
```
```
[System Menu]
```
```
MODE SET
MAIN SOFT DIP
GAME SOFT DIP
RESTART
DEFAULT START
GAME START TEST
CAWFULL
CHECK SUM
BOOK KEEPING (CARD)
GAME DEBUG DIP
```
```
(What follows is done through the 2P controller)
```
lever up, down select command (the menu loops)
A button command execute
C button return to game
D button to see game screen. pressing the D button again will return you to
the system menu screen. this can be used as a pause.

* HOW TO USE THE COMMANDS

### [MODE SET]

```
Switching for arcade, home system, Japan, America, Europe (also South East Asia). Also,
it will display part of SYSTEM WORK.
```

### TYPE DEVEL. HOME USE (1)

### COUNTRY JAPAN (2)

```
xx WORK LIST xx
USER REQUEST 00 (3)
USER MODE 00 (3)
PLAYER MODE 00 00 00 00 (3)
CREDIT 00 00 (4)
GAME CODE 0044 (5)
```
```
(1) TYPE
A, B button allows switching to DEV.HOME USE (development for home system),
DEVEL.MVS (development for arcade), and NORMAL HOME USE (home system).
```
* DEVELOPMENT MODE AND NORMAL MODE

### (2) COUNTRY

With the A and B button, change the COUNTRY-CODE to, JAPAN (=O), USA (=I),
EUROPE or EUROPE-ASIA (=2).

### TYPE

```
Home
system
```
```
Arcade
system
```
G- You can change (1) and (2) with the up and down direction of the controller. Also you
can return to System Menu with the C button.

```
(3) USER REQUEST, USER MODE, PLAYER MODE
Each SYSTEM-WORK details are displayed.
```
### MODE

```
Development
```
```
Normal
```
```
Development
```
```
Normal
```
### (4) CREDIT

CREDIT number is displayed. The addresses are lOFEOOH and lOFEOlH (these are
valid only from 2P side or USA).

```
(5) GAME CODE
Displays GAME-CODE located at the address 108H.
```
### SET UP

### DEV.HOME USE

### SYSTEMROM

```
for NORMAL
HOME USE
DEV.MVS
```
```
NormalSYSTEM
ROM
```
### 1 OFE80H(.W)

```
Other than 0
```
### 0

```
Other than 0
```
```
0
```
### DIFFERENCE

```
BACK UP AREA saved
when RESET
Initializes when RESET
```
```
Define CREDIT to
1 OFEOOH
Define CREDIT to
D00034H
```

### [MAIN SOFT DIP] [GAME SOFT DIP]

```
Soft dip, used in the arcade system, allows chaging the display with this selection.
Please be careful when this function is chosen. Some of the ones which use "kanji"
characters might not be properly displayed. For the USA use, COIN2 rate will be same as
the coin rate at the time of continue. Moving the controller up and down will allow for
the menu selection, A and B button to change the content, and C button to return to the
System Menu.
```
```
[RESTART]
This choice will reset (initialize) the software. The parameters chosen at the MODE
SELECTION will remain the same. Even with the hardware reset, MODE and SOFT DIP
values will not be cleared. Power on reset of USER-REQUEST=O will only be entered
once at the time of start up even if the TYPE has been set for the home system. The only
exception of this is when the TYPE has been chosen as the NORMAL HOME USE.
```
### [DEFAULT START]

```
BACK UP AREA and SOFT DIP values are reinitialized after RESET.
```
### [GAME START TEST]

With the MVS forced start MODE, USER-REQUEST=3 and USER is entered, and
after 10 interrupts PLAYER-START is requested. If start is not accepted at this time,
ERROR is displayed.

### [CARD FULL]

Available memory of the MEMORY CARD (used for the games) are filled with
dummy data. Please use this to check the memory card program.

### [CHECK SUM]

The CHECK SUM of the 8 NIbit program area (8 bit, 16 bit) is displayed. You can not
return to the System Menu. If the game ID is not found at the time of reset, the system
will automatically go into this MODE. This will allow you to examine the CHECK SUM
of the character ROM's.

BOOK KEEPING (CARD)]
This displays the net income of the MVS system. (The operation method is the same
as the MVS. You may not return to the System Menu.)

### [GAME DEBUG DIP]

This will change the front 2 byte of the game BACK UP AREA to bit format. Please
use this for development (ex: no death mode). C button will allow you to return to the
System Menu

```
Notes On: NEO-GEO Base Unit for Development
Development using NEO-GEO CB- connect Jumper 2 (J2) with a solder.
Debugging using NEO-GEO CB- disconnect Jumper 2 (J2).
```

DO NOT COPY 1

NEO GEO SOUND PROGRAM

(SOUND2.REL)

USER'S MANUAL

SNK


### YM2610 CHIP OUTLINE

```
MVS, NEO-GEO circuit boards uses the YM2610 chips made by YAMAHA. This chip
has the capacity to output the following at the same time: 7 voices ADPCM (voice
synthesis), FM source 4 voices, and SSG 3 voices (PSG compatible). Explanation of all
three follows.
```
```
ADPCM
This is voice synthesis (PCM). There are two types, ADPCMA and ADPCMB, and the
differences are listed in a table below.
```
The sampling rate listed above maybe analogous to the tape recorder speed. The larger
the value, the faster the rotating speed. The higher the sampling rate, the better the
quality, requiring more memory. In contrast, the lower the value, the lower the quality;
but the memory that is required is less. Also, changing this value at the time of
reproduction will change the interval. Even though ADPCMA is fixed, ADPCMB is not
and recording a musical instrument will allow the use of the sounds as BGM.

```
PCMA
```
FM Source
FM allows 4 voices output at one time. Compared to the previously used FM source of
the YM3812 chip, the output is more realistic.

SSG Source
This is compatible to the PSG, and allows 3 voice output with noise mixing of rectangular
wave form.

```
Output
6 voices
1 volce
```
(1) This source chip is in stereo. There is a choice from Lch (Left channel) output, Rch
(Right channel) output, or L+Rch (both channel) output. If a specific sound is required,
there might be the need to use two voices and manipulation of each level settings.

(2) Dividing the sources: These sound sources are divided into Sound Effect and BGM
and are shown in the table below.

```
Sampling Rate
18.3 kHz fixed
2.0-53.5 kHz
```
ADPCMB is compatible to both BGM and Sound Effect. It is used for one or the other
depending on the game.

```
Data ROM
4M mask ROM
4M mask KOM
```
```
The Seconds on 4M ROM
approximately 1 second
lowering the qual~ty, 2 sec.
```
```
ADPCMB 1 voice
ADPCMB 1 voice
```
```
BGM
Sound Effect
```
```
ADPCMA 3 voices, FM 4 voices
ADPCMA 3 voices, SSG 1 voice
```

```
Files needed for NEO-GEO sound development are included in the NEO-GEO Sound
Program floppy disks.
```
### FILE NAME

SOUND2.REL
B ANK.REL
WINDOW.COM
SDATA5-DAT
SDATA6.DAT
VO-FM.SRC
VO-PCMA.SRC
VOPCMB.SRC
TBL-PCMB.SRC
VO-HOST.SRC
TBL-MU.SRC
0AFO.SRC
0BFO.SRC
CONFIG20.SRC
CONFIG-S.SRC
YM5F.SRC
SM7F.SRC
EQU4.ASM
SD.B AT
SDB .BAT
SB .BAT
INIT.MCR
ANDO.COM

AND0 .Em

```
CONTENTS
```
```
sound driver
copy program
copy program
table including data
table including data
music or sound effect data source file
music or sound effect data source file
music or sound effect data source file
music or sound effect data source file
music or sound effect data source file
music or sound effect data source file
OA??.SRC initial source file
OB??.SRC initial source file
initial music source file
initial SSG source file
eye catch music data file
coin sound data file
file which enters EQU specification
batch file used during assembling and linking
batch file used during assembling and linking
batch file used during assembling and linking
macro file used during PROICE operation
program which transfers data from the host computer to the ROM
writer
program which transfers data from the host computer to the ROM
writer
```

### CREATING NEO-GEO YM2610 PCM

```
Please follow the process listed below if Macintosh is to be used to create the NEO-GEO
PCM.
```
1. Using an AKA1 sampler, sample the needed sound effects and musical instruments.
    Please record the bass drums, bass and other low frequency instruments at 44.1
    kHz; and record high frequency instruments, such as the cymbals, at half the
       sample rate mentioned earlier. (If the instrument does not seem to be in either
    class of frequency, please try with both the sampling rate. Depending on which
    rate chosen will determine the sound value that will be reproduced.)
2. Save as a file in Macintosh using Alchemy.
3. Convert the Macintosh files using a file converter or Ether Net (Tops) into PC98
DOS format.
4. Convert the PC98 DOS format file to YM2610 compatible file using ADPCM
compressor (provided by our company) and bum in the data using the ROM
writer. Please refer to the ADPCM compressor user manual provided separately.

```
* The pitch table specifying ADPCNIB scale is sampled at 12kHz. Please set the
ADPCMB instrument sound at 12 kHz (or 24 m).
```
```
* The address value of ADPCM data created are input in VO-PCMB.SRC and
VO-PCMA.SRC. The method of address value calculation is shown below.
```
```
(1) Find out the ADPCM data file size using the MS-DOS command "DIR."
```
```
(3) Change intoHEX form
```
```
(4) FI + 10H = G- This value is the file size entered into in
VO-PCMB.SRC and VO-PCMA.SRC.
```
```
Please transfer the ADPCM data, grouped in 1 Mbits (or 4 of these grouped in 4
* Mbits), with the use of the MS-DOS command "COPY" and the switch " /B" to
the ROM writer.
```

```
ADPCM Data Entry & Edit
```
```
File Name: VO-PCMA.SRC
Entry & Edit into this file the sound data PCMA created by the YM2610 ACQUISITION
UNIT & OPNB SYNTHESIZE UNIT (abbreviated as PCMA from now on).
```
```
Macro Definition of "TBL-KEY-PCMA," "TBL-KEY-PCMA2," and
"TBL-KEY-PCMA3 ."
```
```
TBL-KEY-PCMA ;MAIN PCMA VOICE TABLE $00-$FF
;(DON'T USE VOICEOOA-1 -VOICEIF-1 FOR 2 BITE CODE)
;El=lg,VO-No
;D1=14,VO_No
................................................................. a@@@@@@@ ...........................
i ;VO1CEOOA
```
............................................................................................................................................. VOICES 01,0000,0001,00,0000,000 1 ,PC, 1F ;(COMMENT) i

```
;VOlCEOlA
VOICES 01,0000,0001,00,0000,000 l,PC, 1F ;(COMMENT)
;VOlCE02A
VOICES 01,0000,0001,00,0000,0001,PC,1F ;(COMMENT)
```
```
Every row has "VOICE??A," "VOICES" and eight number values. These eight values are
the parameters for the "VOICE??A." Each parameter will be explained below.
```
```
1- Will enter the "VOICE??A" (sound from PCMA) in priority order. The value is
from 0 to FF. The lower the numerical value, higher the priority.
```
```
2- Will enter the numerical value of the lower two figures cut off of the start address
entered during PCMA data creation. The maximum numerical value is Fm;F.
```
```
3- Will enter the numerical value of the lower two figures cut off of the end address
entered during PCMA data creation. The maximum numerical value is FFFF.
```
```
4- Number of loops (repeat) of the "VOICE??A" (sound from PCMA) is specified.
The value is from 0 to FF. The value FF corresponds to infinite loop.
```
```
5- Will enter the start address (cutting off the lower two figures) when looping.
```
```
6- Will enter the end address (cutting off the lower two figures) when looping.
```
```
7- Will define the output destination of the "VOICE??A" (sound from PCMA).
R channel output " enter PR
L channel output " enter PL
L and R channel output G- enter PC
```

```
8- Sets the volume level of the "VOICE??A" (sound from PCMA). The value is from
00 to IF. 1F is the maximum.
```
```
* Macro Definitions "TBL-IEY-PCMA," "TBL-KF!Y-PCMA2," and
"TBL-KEY-PCMA3" have "VOICE??A" values of 0 to FE h. With 255 for each, a
maximum of 765 PCMA sound may be entered.
```
```
Macro Definition of "PCMA-EI-TBL," "PCMA-EI-TBL2," and "PCMA-EI-TBL3."
```
```
There are three tables in "VO-PCMA.SRC", similar to the table above. The table
"PCMA-EI-TBL" is the DI, EI table (switch determining output of "VOICE??A," output
or not) corresponding to "TBL-KEY-PCMA;" "PCMA-EI-TBL2" to
"TBL-KEY-PCMA2;" and "PCMA-EI-TBL3" to "TBL-KEY-PCMA3." If PCMA
sound is used as a sound effect, this DI, EI table is used. (If PCMA sounds are used as
instrumental sounds, there is no need for the use of this table.)
```
@ determines the first significant place "?'in "VOICE??A," @ determines the second
significant place. (For example, the table above gives "VOICE32A.") The current table is
"PCMA-EI-TBL," but this look up method is the same for other tables. The value, in the
above case "1," determines if there is an output. When the numerical value "0 signifies
"DI" (no sound output), and value of "1" signifies "EI" (sound output).

```
To output "VOICE??A" sound during a game, "1" must be entered in the corresponding
"??' table cell, and the following codes must be sent from the main program:
If numerical value "1" of "VOICE??A" is entered in "TBL-KEY-PCMA * "18"
If numerical value "1" of "VOICE??A" is entered in "TBL-KEY-PCMA2 w "1A"
If numerical value "1" of "VOICE??A" is entered in "TBL-KEY-PCMA3 * "1C"
To interrupt the sound output of "TBL-KEY-PCMA," please send "14;" and for
"TBL-KEY-PCMA2," please send " 15."
```

```
Ex:
To output sound "VOICE32A" of "TBL-KEY-PCMA2" from the main program, send
"lC, 32."
(Precautions)
1 Please do not enter sound effects in "VOICEOOA" through "VOICElFA" of
"TBL-KEY-PCMA." (This will conflict with the Sound Program System
Codes.) Also, please do not enter "1" in 00 through 1F h of "PCMA-EI-TBL."
(These areas maybe used for instrumental sounds.)
2 Only sound effects are allowed to be entered in "TBL-KEY-PCMA2" and
"TBL-KEY-PCMA3 ."
3 Please do not enter sound effects in "VOICEOOA" through "VOICElFA" of
"TBL-KEY-PCMA2." and "TBL-KEY-PCMA3." (This will conflict with the
Sound Program System Codes.)
```
```
File Name: VO-PCMB .SRC
Entry & Edit into this file the PCMB sound data created by the YM2610 ACQUISITION
UNIT & OPNB SYNTHESIZE UNIT (abbreviated as PCMB from now on).
```
```
Macro Definition of "TBL-KEY-PCMB."
```
TBL-KEY-PCMB ;MAIN PCMB VOICE TABLE $00-$FF
................................................................. @@@@@@@J@ ...........................

j VOlCEOO VOICES 00, 00, 00, 00, 00, 00, 00, FF
VOICESLFO 00, 00, 00, 00, 00, 00, 00, 00, 00, 00
i .......................... .... ............. ............ @..@...@...@..@ .............. ...i

```
VOlCEOl VOICES 00, 00, 00, 00, 00, 00, 00, FF
VOICESLFO 00, 00, 00, 00, 00, 00, 00, 00, 00, 00
```
```
VOICE02 VOICES 00, 00, 00, 00, 00, 00, 00, FF
VOICESLFO 00, 00, 00, 00, 00, 00, 00, 00, 00,^00
```
```
The numerical values listed in the rows "VOICES," 1 through 8, and "VOICESLFO," 9
through 18, define the parameter of "VOICE?." The 16 numerical values will be
explained.
```
```
1- Will enter the "VOICE??B" (sound from PCMB) in priority order. The value is
% from 0 to FF. The lower the numerical value, higher the priority.
```
```
2- Will enter the numerical value of the lower two figures cut off of the start address
entered during PCMB data creation. The maximum numerical value is FFFF.
```
```
3- Will enter the numerical value of the lower two figures cut off of the end address
```

```
entered during PCMB data creation minus " 1 ." The maximum numerical value is
FFFF.
```
```
4- Number of loops (repeat) of the "VOICE??B" (sound from PCMB) .is specified.
The value is from 0 to FF. The value FF corresponds to infinite loop.
```
```
5- Will enter the start address (cutting off the lower two figures) when looping.
I
6- Will enter the end address (cutting off the lower two figures) when looping.
```
```
7- Will enter the frequency of the ADPCM data created during sampling. The
calculated sampling rate must be entered at the top.
(Sampling Rate Calculation Method)
PB =
65536xFB
55.5 PB = pitch FB = frequency
(sampling rate) (kHz)
```
```
Ex: Calculation of sampling rate with sampling frequency of 8 kHz.
PB = 65536x8 55.5 = 9446.630.... ,----.----...
rounding off to the nearest whole number? ---.-----...a 9447 i
Enter this numerical value at the i - - - top. -. of.. -EGu. "VO-PCMB.SRC" -qa7 a as shown below.
```
```
.._......_._...._._---..---.--...---....a SPRCE
If the sound created by YM2610 ACQUISITION UNIT & OPNB SYNTHESIZE
UNIT is divided into 16 kHz, 8 kHz, and 18 kHz sampling frequency; calculate and
enter the sampling rate values for 16 kHz, 8 kHz, and 18 kHz sampling frequency
and enter it as shown above.
The "K8" in front defines the sampling frequency as "8 kHz."
```
8- Defines the volume of "VOICE??' (PCMB sound). The values ranges from 0 to FF.
Larger the value, larger the volume.

9- Using LFO on "VOICE??'(PCMB sound), the value here specifies SYNC DELAY
TIME (time delay before LFO is used). The values ranges from 0 to FF. LFO is
used as the output begins if the value is 0. Larger the value, longer the delay time.

```
10- Defines the LFO envelope type. There are ten envelope types to choose from and
are shown below.
(Shown on next page)
The numerical value listed in the table determines the first significant place value,
while the second significant (tenth) place determines the "VOICE??' (PCMB sound)
output destination.
R channel output * "1"
L channel output * "2"
L and R channel output G- "3"
```

No. I Envelope Shapes I

```
11- Minimum.
```
```
12- Maximum pitch.
LFO depth is defined here. Please see the drawing below for visual aid.
Ex: PCME3 sound with sampling frequency of 12kHz.
```
```
(Maximum pich)
;-19 .-! .-. I ,! *-. I .-! -.!
.-. It I I I I
(1 2 kHz standard pitch) .-. I I I I id i .-! i-'! I 9 i-' i I
&!^8 .-I I i-I-. i-a i !-! .-! !-! I .-.
(Mmimum pitch) Time +
```
Using the calculation used in 7 with 12 kHz, the sampling rate should be 14170.
This value is the 12 kHz standard pitch shown in solid line from in the drawing above.
Addition of a value ?? to 14170 results in the Maximum pitch and negation of the depth
results in the Minimum pitch. The Minimum and Maximum pitch define the depth of the
LFO.
(Input method) .--...----..-
Maximum pitch * 14170 + ; ---- '??.--j = (1)
Minimum pitch * 14170 -! ...-- ??..-i = (2)
,. - - -.. - - -.
i ._.... ?? - - -.. i value is the LFO depth. Change value (1) to base 16 and input into 1 1, (2) to base
16 and input into 12. The numerical value raging from 0 to FFFF.
13- Defines the LFO speed. The value ranging from 0 to FFFF. The larger the value
the faster the speed. When the value is 0, LFO will not be used.

14-1 8 Defines the volume portmanteau (Please think of this as the attack portion of the
volume envelope.) of "VOICE??' ((PCMB sound).

```
14- Defines the type of volume portmanteau.
There is no volume when the first significant number is "0."
```

```
The volume is lowered when the first significant number: is "1."
The volume is raised when the first significant number is "2." (one place)
```
```
15- Defines the time (speed) required from the start volume to the end volume. The
numerical value ranges from 0 to FF. Smaller the value the faster the speed. When
the value is set to 0, as the output of sound begins, the end volume level is reached
with the effect being nullified.
```
```
16- The initial volume level that is to be modified is defined. (This parameter is useless
when the numerical value "1" [where the volume is lowered] is chosen at 14.) The
value ranging from 0 to FF. Larger the value, larger the level.
```
```
17- The final volume level of the sound that is to be modified is defined. The value
ranging from 0 to FF. Larger the value, larger the level.
```
```
18- Defines the speed (chosen in 15) increase. (In other words, to define the speed of
volume portmanteau, both 15 and 18 must be define as positive values.) The value
ranging from 0 to FF. Larger the value, larger the increase of speed. When the
value is 0, there is no modification.
```
```
Macro Definition "PCMB-EI-TBL," and "PCMB-EI-TBL2.':
```
The contents are similar to "PCMA-EI-TBL," "PCMA-EI-TBL2," and
"PCMA-EI-TBL3." Please input accordingly. However, there are few differences which
are listed below.
* The voice EI code entered in "PCMB-EI-TBL" is "19."
* The voice EI code entered in "PCMB-EI-TBL2" is "1B."
(Sending in the following order will result in sound output: EI code, voice number.)

(Sample) ADPCM hardware address, OPNB SmTHESIZE UNIT address, and address
relationship inside the files (such as relationship between "VO-PCMA.SRC" and
"vo~PCMB.SRc).
1- Word count of OPNB SYNTHESIZE UNIT from 0-4000H data is 1 Mbit.

2- 400H of address input area inside of "VO-PCMA.SRC" & "VO_PCMB.SRC" is 1
Mbit.
<Sample> (Start Address) (End Address)
1 M 0 - 400 (H)
2M 400 (H) - 800 (H)
3M 800 (H) - COO (H)
4M (HI - 1000 (H)

```
1000 (H) - 1400 (H)
1400 (H) - 1800 (H)
1800 (H) - lC00 (H)
```

```
lC00 (H) - 2000 (H)
2000 (H) - 2400 (H)
```
```
3- There is no difference on the NEO-GEO system between ADPCMA data ROM and
ADPCMB data ROM. Access point address values of "VO-PCMA.SRC" and
"VO-PCMB.SRC" are the same. Please make sure not to over lap
"VO-PCMA.SRC: and "VO-PCMB .SRC" address values. (Please be aware, that
there is no error message display when there are address value over laps or if the
same values are entered.)
To avoid confusion, please organize ADPCMA data (ROM) and ADPCMB data
(ROM). (Each data and ROM should be placed separately as units consisting of one
data per ROM.)
```
```
4- During development, the ADPCMA and ADPCMB data ROM hardware position
will probably change. At this time the address input value must be changed in
"VO-PCMA.SRC" & "VO-PCMB.SRC" files. The example below illustrate the
method of shifting the address values entered in files "VO-PCMA.SRC" &
"VO-PCMB.SRC" by the same amount.
Ex:
```
```
In this case, there is a need to move every address values by 1 M (i.e. each address value
requires an addition of 400H). If the Macro Definition "VOICER MACRO of
"VO-PCMB.SRC" is rewritten as follows (Figure I), there is no need to rewrite each
address values.
```
```
Figure 1
```
I
I VOICER MACRO &PI,&ST,&EN,&CT,&FD,&ED,&PT,&LV

```
$&PI
$&ST/2+200H
$&EN/2- 1 +200H Add 200H to these areas
(calculate 1 M using 200H)
```
```
$&ED/2- 1 +200H
&PT
$&LV
```
```
Because of Macro Definition purposes, 200H is used to calculate 1 M. For example,
increasing the value 200H to 400H will equal 2 M, and increasing to 600H results in 3 M
of address shift for a file in "TBL-KEY-PCMA?'
* This can be done for either "VO-PCMA.SRC" or "VO-PCMB.SRC."
```

```
* "ADPCMA" ROM should be installed starting from "Vl" (from address OOOOH),
"VO-PCMB.SRC" address input starting from OOOOH as well, and depending on the
number of ADPCMA ROM's, the above operation should be done in "VO-PCMB.SRC."
```
```
File Name: "TBL-PCMB .SRC"
This allows the instrumental sounds entered in "VO-PCMB.SRC" to be used in
MUSIC.SRC.
```
```
Macro Definition "TBL-OKEY-PCMB"
Ex:
```
The VOICE NUMBER (the ?? of "VOICE??') of the PCMB instrumental sounds created
in "VO-PCMB.SRC" should be entered in the dotted line box. The first entry in the
above example is "18." This is the VOICE NUMBER of "VO-PCMB.SRC." And the
VOICE NUMBER that is corresponding to "18" in "TBL-OKEY-PCMB is "40."
(@ determines the first significant value, 4, and @ determines the second significant
value, +40 * 40.) Entering this value into the prescribed position of MUSIC.SRC, and
entering the musical score will produce musical sounds with VOICE NUMBER "18." (It
will be discussed further in "Creating MUSIC.SRC.")

Macro Definition "TBL-OCTAVE-PITCH"

This is a pitch table that adds scale to each sound that was entered into Macro Definition
"TBL-OCTAVE-PITCH." The scale has been adjusted with a sampling rate of 12 kHz.
(Because of this, it is possible to use the instrumental sounds with sampling rate of 24
kHz.) If there is a need to use different sampling rates, this is where the changes should
be entered. But it is our recommendation to use this sampling rate of 12 kHz.

Macro Definition "TBL-MKEY-PCMB"

Normally, sampling one note that the musical instrument produces, and playing it with a
wide range of frequencies, the lowest and highest frequency output would be interpreted
by the human ears as coming from different instruments. Iq order to compensate for this
failure to emulate a real instrument, the following steps should be taken. First, sample the


```
desired instrument sound. Second, sample the sound one octave (two octave in some
cases) at a time two to three times higher and lower than what was sampled in the first
step. (Number of times higher and lower can be changed according to how wide a range
the musical score is.) Finally, the sounds that were sampled should be entered separately
into "VO-PCMB.SRC," and entering also in "TBL-MKEY-PCMB" results in a score
sounding as if it was coming from a real instrument rather than being simulated. (Of
course this will require more memory.)
```
```
Ex:
```
```
TBL-MKEY-PCMB ; MAIN $80-$BF :type multi
, ,.-v-----.--..o------.....--.-.---a-...O.--.~-A-~~-.-----.- octave0 1 2 3 4 5 6 7
```
- i
PCMB-KEY j .----.-a 80 i. i ......................................................................... DB $00,$00,$00,$21,$22,$23,$00,$00 1

```
PCMB-KEY8 1 DB $00,$00,$00,$00,$00,$00,$00,$00
PCMB-KEY82 DB $00,$00,$00,$00,$00,$00,$00,$00
......
```
... .....

```
Each row has "PCMB-KEY??," "DB," and 8 parameters with octave numbers from 0 to
```
7. Each parameter represents an octave. "octave 0" represents the lowest octave and
"octave 7" represents the highest octave. Enter the VOICE NUMBER of PCMB in one
of the octave locations. In the above example, @ "$21," @ "$22," and @ "$23" are the
VOICE NUMBER created in "VO-PCM.SRC." (Assuming each sample range is 1
octave, this example allows instrumental output over three octave range.) "80" represents
these parameters. Entering this numerical value in the prescribed area of MUSIC.SRC,
the creation of the musical score is initiated.
The above description is what "TBL-MKEY.PCMB9' is normally used for, but it also
maybe used as a "split" (i.e.: It can be used to separate a musical interval into high and
low frequencies).

Macro Definition "TBL-MULTI.PITCH

This is a pitch table that adds scale to each sound that was entered into Macro Definition
"TBL-MLTLTLPITCH." The sampling rate of this scale is 12 kHz as well. Please use this
table as is.


```
File Name: "VO-HOST.SRC"
MUSIC, EFFECT that are to be outputted from the game, must receive the code from the
main CPU. The file "VO-HOST.SRC" is a table which stores the code of MUSIC,
EFFECT.
```
Macro Definition "TBL-EFFECT-PCMB"
Enter the VOICE NUMBER of PCMB sounds of EFFECT, entered (or edited) in file
"VO-PCMB.SRC," to correlate with the codes.
Ex:
b

```
TBL-EFFECT-PCMB ;HOST REQUEST $80-$BF ;type HOST request
0
012345678 - F
..................................................................................................
; $0A,$00,$00,$00,$00,$00,$00,$00,$00 -
```
. Q
DB $00 i ;8
DB ; $00,$00,$00,$00,$00,$00,$00,$00,$00 - $00 j ;9
DB $~0,$00,$00,$00,$00,$00,$00,$00,$00 - $00 i ;A
DB i $00,$00,$00,$00,$00,$00,$00,$00,$00 - $00 i ;B
.-....-.--..-.-....-....-.-...--..--...---..--.-.............---..---..-...-....-..---*-.. ...-.--,

```
Enter (inside the dotted line box) the VOICE NUMBER of PCMB sounds of EFFECT
entered and edited in "VO-PCMB.SRC." The only non-zero entry inside the dotted line
box is "$OA;" the corresponding code for this value is "80." (0 determines the first
```
significant value, 0, and @ determines the second significant value, (^8) 80.)
Macro Definition 'bTE3L-EFFECT-PCMA"
It is similar to "TBL-EEFECT-PCMB." Please refer to the section above.
64 sounds with code 80-BF in "TBL-Em;ECT-PCMB" may be entered and 64 sounds
with code CO-FF in "TBL-EFFECT-PCMA." (If there are more 64 sounds, please use
the method discussed earlier in "PCMA-EI-TBL.")
Macro Definition "TBL-MCODE"
This is to open each code of the MUSIC, EFFECT. Please think of this as the switch to
output the sound of MUSIC, EFFECT.
Ex:
0
0123456789ABCDEF
TBL-MCODE EQU $ @
DB ~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~ ; 00
DB ~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~ ; 10
DB @ G- 0,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0 ; 20
DB ~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~ ; 30
DB ~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~ ; 40


### ; NO ENTRY =O

### ; SYSTEM CODE = 1

### ; MUSIC ENTRY = 2

### ; EFFECT PCMA = 3

### ; EFFECT PCMB = 4

### ; EFFECT SSG =5

```
@ determines the first significant value, 0, and @I determines the second significant value,
20 * 20, which is the code corresponding to the flag (switch, "0").
```
```
A code with a value from 00-1F is a SYSTEM CODE (related to sound program) and is
not normally modified here.
```
```
A code with value from 20-5F is a MUSIC.SRC flag and requires a value of "2" in the
flag section to be active. (MUSIC.SRC related codes will be explained later.)
```
A code with value from 60-7F is a S. S. G. SRC flag and requires a value of "5" in the
flag section to be active. (S. S. G. SRC related codes will be explained later.)

```
A code with value from 80-BF is a PCMB EFFECT sound flag and requires a value of
"4" in the flag section to be active.
```
```
A code with value from CO-FF is a PCMA EFFECT sound flag and requires a value of
"3" in the flag section to be active.
```
Please specify all unused codes to be "0" (if it is not set to "0," it will affect the sound
program).


```
+ Steps Taken from YM2610 ACQUISITION UNIT & OPNB SYNTHESIZE
UNIT Instrumental and EFFECT PCMA, B Sound; To Assembling In The Sound
Program: And Finally To Sound Output.
```
(1) / Find the instrumental and or EFFECT sound; sample the sounds using YM2610 i
i ACQUISlTION UNIT & OPNB SYNTHESIZE UNIT and store this data into the i
i ............... ROMs. .................................................... ....................................................................
.... .............................................................................................................................................. P
(2) i Store the address of the sampled sound in "VO-PCMA.SRCW or
............................................................................................................................................. "VO-PCMB.STC."
Q 9'
...................... (EFFECT SOUND) ..................................................... ....................................................................... (INSTRUMENTAL SOUND PCMB)
i Inside "VO-HOST.SRC," specify the code i.. i Enter the VOICE NUMBER for PCMB j
i for PCMA sound Macro Definition "TBL- i. j , instrumental sounds in
EFFECT-PCMA" and for PCMB sound i. j a "TBL-PCMB.SRC" and convert it to j
i Macro Definition "TBL-EFFECT-PCMB" ; ..................................................................... i numerical values for MUSIC.SRC. :
i and open flags for Macro Definition p
i ........................................................................... "TBL-MCODE." + Enter into MUSIC.SRC

```
P
+ Send code for sound output
The method shown above is the basic flow
for PCM data entry.
```
```
(Caution) For EFFECT sound output method discussed in Macro Definition
"PCMA-EI-TBL," "PCMA-EI-TBL2," and "PCMB-EI-TBL3" also exist.
Thus there are two methods including the method shown above. (Both
methods are valid.)
```

+ MUSIC, SRC S. S. G. SRC Entry

```
MUSIC.SRC must be entered before MUSIC DATA, S. S. G. DATA. (Similarly for S. S.
G. SRC) Please follow the steps taken below.
```
```
First, create an initial MUSIC, SRC file. Copy file "CONFIG20.SRC" in MS DOS.
("CONFIG20.SRC is the template for MUSIC, SRC.)
```
```
Ex:
```
```
@ --- Enter the two alphabet character of choice.
```
@ --- Enter a numerical value from 20-5F. (This number will correspond with CODE.)

```
i) Copy "CONFIG-S.SRC" for S. S. G. SRC, and use alphabet characters other than
those used in the MUSIC.SRC. The numerical values should chosen from 60-7F.
```
```
Enter the MUSIC.SRC file HM21.SRC into the following three files:
"TBL-MU.SRC"
"SDATA5.SRC"
"VO-HOST.SRC"
```
```
i) Enter S. S. G. SRC into the three files as well.
```
```
File: "TBL-MU.SRC"
Macro Definition "TBL-MUSIC"
Table which corresponds with MUSIC-SRC.
Ex:
8 0
DEFW 0 : MUSICB
@ 0
DEFW MUSIC2-l
DEFW 0 ; MUSIC22
DEFW 0 ; MUSIC23
```
The value of @ ranges from 20-5F (maximum of 63 songs) and there are "0 ;" (8)
corresponding to this value. For example, entering "HM21.SRC" into this table, enter the
value 21 into 0 and erase the value "0 ;" as in @. (Please enter S. S. G. SRC into Micro
Definition "TBL-SSG-MUSIC" using a similar method as was shown.)


File: "SDATA5.DAT"
i File which collects all files associated with sound. MUSIC. SRC and S. S. G. SRC are

```
files and must be taken account of in "SDATA5.DAT."
Ex:
.................... ....................
Play MML data
.................... ....................
a INCLUDE TBL-MU.SRC
@ INCLUDE HM21.SRC
```
```
Please scroll down to "Play MML data." Please enter after @(INCLUDE
TBL-MU.SRC) as in @. With each increase of MUSIC.SRC, please enter
"INCLUDE-??? in numerical order. Please follow the same steps for S. S. G. SRC.
```
```
File: "VO-HOST.SRC"
The details are as they were discussed earlier. Please enter the CODE number for
MUSIC.SRC, "2," or S. S. G. SRC "5," into Macro Definition "TBL-MCODE." (Ex:
MUSIC.SRC for the above example would have the value "2" at location "21")
```

```
9 Music Score Data (MUSIC.SRC) Creation
```
```
Please follow the steps listed below before entering the music score data.
```
```
"HM2 1 .SRC" will be used as an example. The "HM2 1 .SRC" file will initially be as shown
below, a copy of "CONFIG20.SRC," but the file name and data inside will not be
matching. Please change the values iQ to "21" and @ 0 to "MUSIC." (This
must be done every time a new MUSIC.SRC is created.
```
```
9
***** SOUND CONDUCTER CONFIG.SYS FILE *****
```
& EQU $

```
9
9 ***** PLAYING MODE *****
9
DB $00 ; SELECT CODE
9
9 ***** DATA ENTRY POINT ADDRESS TABLE *****
7
DW SCORI@~~L~ ; PART 1
DW SCO-2 ; PART 2
DW SCO-3 ; PART 3
DW scorn4 ; PART 4
DW sc0RE.5 ; PART 5
DW SCO-6 ; PART 6
DW SCO-7 ; PART 7
DW SCORE@~LS ; PART 8
DW SCOR_F~~~(~ ; PART 9
DW SCORE^^ 0 ; PART 10
DW SCORT~~ 1 ;PART 11
7
9 ** *** TEMPO(MUS1C) OR PRIORITY(EFFECT) PARAMETER *****
```
```
Music score creation will be discussed below. The file shown is the initial state of
MUSIC.SRC.
```
```
9
, ***** SOUND CONDUCTER CONFIG.SYS FILE *****
```
```
9
5 ***** PLAYING MODE *****
```

### DB $00 ; SELECT CODE

***** DATA ENTRY POINT ADDRESS TABLE *****

```
; PART 1
; PART 2
; PART 3
; PART 4
; PART 5
; PART 6
; PART 7
; PART 8
; PART 9
; PART 10
;PART 11
```
* * * * * TEMPO(MUS1C) OR PRIOIUTY(EFFECT) PARAMETER * * * * *

```
9
; initial PCMA total level
9
```
***** OPEN / CLOSE FLAG TABLE **** *

### OPEN (0 1,OO) CLOSE(00,OO)

### ; PART 1

### ; PART 2

### ; PART 3

### ; PART 4

### ; PART 5

```
" 0 ; PART 6
; PART 7
; PART 8
; PART 9
; PART 10
;PART 11
```


```
@ --- Defines tempo, values ranging from 00-FF. The larger the value the faster the
tempo.
```
```
@ --- Defines the total level of volume of FM sound, PCMA sound, and PCMB sound.
Top value ranging from 0-127 and is for the total level of FM sound. Smaller the
value larger the volume.
Second value ranges from 0-3F and is for the total level of PCMA sound.
Because EFFECT sound created in PCMA sound will also be read in, please leave
the level at 3F.
Bottom value ranges from 0-FF and is for the total level of PCMB sound. The
larger the value, larger the volume.
```
@ --- This is the switch to OPEN and CLOSE (to output or not) of each SCORE for @,
8, and @.
"$OO,OO" * OFF "$0 1 ,OW @= ON

@ --- Input method for FM sound notes

```
The area boxed is the score data input area and is for 4 scores. Each score has
capacity to output one sound (at one time).
```
```
(Part 1) Inputting note data
One note data has the following: note length, volume & tie specification, and
octave & key. Each numerical values are hexadecimal.
Ex:
DB $18 $88 $4C
(note length) (volume & tie specification) (octave & key)
```
```
(note length)
The numerical values range from 00-30, and correspond to notes as follow.
```
```
112 note * 30 114 note * 18
118 note * OC 1/16 note * 06
1/32 note G- 03 dotted^114 note @=^24
dotted 118 note * 12 dotted 1/16 note * 09
3 notes per 2 beat * 03 3 notes per beat * 24
(quarter note triplet) (triplet)
six notes per beat * 04
(six group note)
```
```
(volume & tie or a rest)
volume ranges from 80-BF, smaller the value, larger the volume. If the note is a
tie, the range is from 00-3F (negate 80 from volume range). Also, for a rest, use
the value 40.
```

```
Tie example: $18, $9A, $4C
(notes before tie)
```
```
$18, $1A, $4C
(notes after tie)
```
```
Changing the value (octave & key) of the note after the tie note will
make a
(musical) slur.
```
```
(octave & key)
An octave is defined by the top 4 bits (tenth place). The range is 7 octaves, with
numerical value of 0-E (even values).
A key is defined by the bottom 4 bits (one place). The numerical value is chosen
from 0-F with the following relationship.
```
```
(Part 2) Inputting tone, total level of each score, and total octave of each score.
Ex:
DB $8A $84 $84
(tone) (total level) (total octave)
```
```
These three consists a set that should be inputted before note data.
```
```
value
```
```
note
```
```
(tone)
The values here correspond with the Voice Number of the FM tone created in
"VO-FM.SRC."
```
```
C#
```
### 0

### G

```
(total level)
The total level of each score is defined here with range from 80-9F. Smaller the
value, the larger the volume.
```
```
(total'octave)
The total octave of each score is defined here with rages 80-8F. 80 is the base
value with even number values (2,4,6,8, A, C, E) corresponding to a raise of an
octave per interval. To lower an octave, odd values (3,5,7,9, B, D, F) should be
used; each interval corresponds to one octave being lowered.
```
### 12 3 4 5 6 7 8 9AB

### D# AB

```
The three numerical values should be inputted to FM Score in the beginning, but if
there is a need to have a different value, it is possible to change.
```
@ --- Inputting PCMA Scores
The 6 Scores boxed in is the PCMA sound score input section. Normally,
Score??S-Score??7 is used. (PCMA sound may be outputted with 6 sound

```
C
```
```
CD
```
```
DEF
```
```
EF
```

```
simultaneously, but 3 sounds are normally used for EFFECT. If EFFECT is not
being used, Score??5-Score??lO may be used.)
(Part 1) Inputting note data
Ex:
DB $18 $88 $18
(note length) (volume & tie specification) (Voice No. of PCMA)
```
```
The three hexadecimal values is a set.
```
```
Input method for (note length) and (volume & tie specification) are the same for
FM sound note input method. After these two values, please enter the Voice
Number of the instrumental sound that is to be used from "VO-PCMA.SRC."
Also, the range of (volume & tie specification) is $80-$9F with $9F being the
maximum value.
```
```
(Part 2) Inputting total level of each Score (PCMA sound)
Ex:
DB $80 $95
(volume specification code) (PCMA total level of each Score )
The two numerical value makes a set for input.
```
```
(volume specification code) Please enter "$80" in front of (PCMA total level of
each Score).
(PCMA total level of each Score) The range is 80-9F, larger the value larger the
volume.
```
```
These values must be entered, but may be modified as needed.
```
--- Input method for PCMB. sound note
1 Score that is inside the box is the note data for PCMB sound.

```
(Part 1) Inputting PCMB sound note data
The method is the same as the input method for FM sound note data entry.
```
```
(Part 2) Inputting method for Score total level, total octave, and key.
Ex:
080
DB $80, $FF, $80
@ 8
DB $46, $40
```
```
0 --- Volume specification code. Please enter the value before a, because the
set consists of 0 and Q.
```
```
Q --- The total level of PCMB part is specified. The range is $80-$FF, larger
```

```
the value, larger the volume.
```
```
@ --- Total octave is defined with $80 as the base (lowest) value. With the
addition of even values (of $02, $04, $06,$08, $OA, $OC, $OE) the
octaves will go up by one octave at a time. The maximum value is $8F.
```
```
@ --- Code which defines the tone. Please enter the value before @, because
the set consists of @ and @.
```
```
@ --- Please enter "TBL-OKEY-PCMB" of "TBL-PCMB .SRC" or code from
"TBL-MKEY-PCMB."
(For example, looking at the file example "Macro Definition
"TBL-OKEY-PCMB" from section "File Name: "TBL-PCMB .SRC,"
inputting "$40" will designate the instrumental sound "VOICE 18" in file
"VO-PCMB. SRC." Inputting "$80" with "TBL-MKEY-PCMB ," the
series of instrumental sounds in line "PCMB KEY80" will be outputted.)
```
```
Please enter the values listed above as a set before PCMB part notes.
```
```
Other commands that are necessary for creating scores will be discussed below.
```
1. $40 (Music stop code)
    Please enter after each score. (Before entering this code, please put in a rest "$01,
$40, $00.")
2. $42 (Return first part code)
Please enter this code to loop a MUSIC.SRC piece after each score.
3. $44 (LR switch code)
Defines the direction (L channel, R channel, and LR channel) of the output for
each score. Please enter the following codes for each directional choice (These may be
defined anywhere inside the Score.)

```
L channel output
DB $44 $02
R channel output
DB $44 $01
LR channel output
DB $44 $03
```
4. $47 (Next music code)
    Please enter this code to play one MUSIC.SRC after another. (Ex: after the
introduction MUSIC.SRC.)
Ex:
    Playing HM2 1 .SRC and HM22.SRC.


```
After each score of HM21 .SCR please enter the following.
$47, 0. (22 of HM22.SRC)
```
5. $3F (Fade out code)
    Defines fade out. Please enter the following inside 1 Score of choice: $3F, $??
(fade out speed). The range of fade out speed is 0-FF, and larger the value faster it fades
out.
6. $33 (Tempo change code)
Using this code allows change of tempo.
$33 $?? (?? 0. tempo) Range of the value is 0-FF. Larger the value, faster
the tempo.


+ Special Commands for Musical Score Creation

1. "$3 1" or "$32" (repeat code)
    "$34" or "$38" (repeat end code)
Allows repeat of groups of notes in each Score.
Ex:

```
.................................................................. $??, $??, $??, $??, $??, $??, -
note data note data
```
0 --- This is the repeat code. Please input this code before the group of note data you
want repeated.

8 --- This is the repeat end code. Please enter this code after the group of note data

```
you want repeated.
```
0 --- Please enter the number of times you would want this loop to be repeated. The
maximum value is 255 times. Please enter this number in hexadecimal. (i.e.
0-FF).

In the above example, the group of note data are repeated 16 times.

```
.................................................................. $??, $??, $??, $??, $??, $??, -
note data note data
```
```
$31, $10
.................................................................. $??, $??, $??, $??, $??, $??, -
note data note data
$34
;-$3*-;
..........
```
Using $32 (repeat code) and $38 (repeat end code) allows double repeat.

2. Chorus command ($BO-$BF)
Please choose 2 of the 4 Scores of FM sound to be outputted in unison. Entering the
chorus command in the beginning of one of the 2 Scores will create the chorus effect. The
range is BO-BF. "$BO" designates no chorus, and larger the value the larger the effect.
3. BJUMP command


```
If 1 pattern of phrase is to be used in numerous places, B-JUMP command should be
used. This will save input time and storage space.
```
................... Ex:
i .................a B-??-?? ; @
DB .................................................................. $??, $??, $??, $??, $??, $??, -
note data note data

```
Before the phrase desired, please enter @; and 8 after. Please enter the chosen letters
from the alphabet of numerical values in "??" of @.
```
```
Please enter the following command where ever the desired phrase is to be outputted.
```
```
The characters in "??" must correspond with the characters in @. The phrase may be
entered as many times as needed inside MUS1C.SRC. Also, by changing the characters
"??," numerous B-JMP commands may be used.
```

..
FILE: "VO_FM.SRC"

```
FM tones to be used in MUSIC.SRC should be created by entering numerical values in
this file. There are numerous publications dealing with FM sound equations, please refer
to these books.
Ex:
```
```
VOICE-No8A @
DEFB 7 +#
DEFB 5 +@
DEFB 3 -3 -3 3 +@@@a
DEFB o 1 1 1 +ammn
DEFB 27 0 0 0 -H!B@@@
DEFB 3 2 3 3 +@om@
DEFB 16 16 16 16 -@Dm@@
DEFB 3 6 7 7 +@@@a
DEFB 0 0 0 0 +a@@&31)
DEFB 14 15 15 15 +@@m@
DEFB 5 5 7 7 +@@@@
DEFB 0 0 0 0 +@@@I@
DEFB 0 +@
DEFB 0 +@J
DEFB 0 +@
DEFB 00 +a
DEFB 0 +@
DEFB 0 +@
DEFB 0 -6.D
DEFB OOOOOOOQB *fa
DEFB 00OOOOOOB +@
```
@ --- This is the FM Voice Number for the set of numerical values. Please enter this

```
number to call the sound for output in MUSIC.SRC. The values start from 80 and
ends with FF, i.e. 127 tone entry capacity.
```
Q --- Defines Feed back. Value ranges from 0-7, larger the value, stronger the effect.

@ --- Defines the algorithm. Please choose from below; with the numbers shown below.


```
The following 4 values correspond with operators 1,2,3, and 4 respectively.
```
```
-- Defines the de-tune value of each operator. The range is from-4-+3.
```
```
-- Defines the multiple (frequency rate) of each operator. The range is
0-15, larger the value, the stronger the effect.
```
```
-- Defines the output level of each operator. The range is 0-127,O having
the highest amplitude value.
```
```
I- Defines the key scale rate of each operator. The range is 0-3, larger the
value, the larger the correction.
```
-- Defines the attack rate of each operator. The range is 0-3 1, larger the
value, faster the rate.

-- Defines the decay rate of each operator. The range is 0-3 1, larger the
value, faster the rate.

-- Defines the sustain rate of each operator. The range is 0-3 1, larger the
value, faster the rate.

-- Defines the sustain level of each operator. The range is 0-3 1, larger the
value, lower the level.

-- Defines the release rate. The range is 0-15, larger the value shorter the
release time.


```
(Reference Envelope Generator)
```
```
ON OFF
```
```
Decay Sustain Release
Attack Rate Rate Rate
Rate
```
-- Defines S'S'G type Envelop (assigns envelop created in S'S'G sound
source to each operator). The shape and value relationship is as shown
below. (Entering a value 0-7 designates OFF.)

```
SSG Type Envelop
```
```
Defines the wave form of LFO (wave shape of low frequency output
created by LFO). The value and shape relationship are as follows.
```
```
0 : saw tooth wave
```
```
1 : square wave
```
```
2 : triangle wave
```
```
3 : sample & hold (random wave)
```
```
Defines Sync Delay (timing of LFO after key-on). The range is 0-FF,
with 0 designating Sync Delay OFF.
```

```
Defines the LFO Speed. The range is 0-7FFF.
```
```
Defines PMD (Pulse Modulation effect defined). The range is 0-FF,
larger the value, more intense the effect.
```
```
Defines PMS (Pulse Modulation general [over all] effect defined). The
range is 0-FT, larger the value, more intense the effect.
```
```
Defines Int Count (LFO genera] [roughly] timing defined. The range is
0-FF, when LFO is used, please set the value to 1 (normally).
```
```
Is not in use. (Please set to 0.)
```
PMS-AMS 1 G- Parameter which defines AMS.PMS of LFO from the
hardware. (Above LFO is from the software.) Lower 4 bits is the
parameter for AMS with range 0-3. Upper 4 bits is the parameter for
PMS with range 0-7. (* Please change to binary value when inputting.)

H-LFO-Switch F LFO switch from hardware. 0th bit is for AM of
operator 1. 1st bit for AM of operator 2. 2nd bit for AM of operator 3.
3rd bit for AM of operator 4. When each of the bit value 1 equals ON,
and value 0 equals OFF.


8 Creating File "SSG.SRC"

```
Please do the following before entering data into the file "S'S'G.SRC."
```
```
The file "CONFIG-S.SRC" (the initial state of "S'S'G.SRC" file) is shown below. Please
copy file "CONFIG-S.SRC" with another name. For example, if it is copied as
"SM61.SRC," change all the area boxed to value with "61."
--- --- -- -
```
9 * * * ** BEGIN TO FILE HEADER * ** **

$MUSI~ EQU $
9
7 ***** SSG priority *****
9 .............
DB iOl ............. i-0
9
, ***** DATA ENTRY POINT ADDRESS TABLE *****
7
DW SCORI$~S 1 ; PART 1
DW SCOREJ~S 2 ; PART2
DW SCORE@IS~ ; PART 3
DW SCO~S-4 ; PART 4 ; noise channel.
3
, ***** OPEN I CLOSE FLAG TABLE *****
9
9 OPEN (01) CLOSE (00)
9 ...........
DB i $00 i ; Part 1
DB i$00: -8 ; Part 2
DB i$o0 i ; Part 3
DB j $00 : ; Part 4 Noise mixed
...........
9
, ***** Noise mixed sw *****
9 ,..... .................
DB i OOoOOOo0B : - @
.......................
............................................................................
SCORE~S-1
DB $55 j
:scorns 2 i -@
DB $55 i

/ .................................... sco~s-3
.......................-....... i. DB $55 ;
......................................
iscorns - N i-1: .................................

............................................................................ DB $55! G- @


```
@ --- The priority order of that S'S-G.SRC is defined. The range is 0-FF, smaller the
value, higher the priority.
```
```
--- Switch (to output or not) to OPEN or CLOSE each SCORE of @ and @.
```
```
@ --- A switch to define the SCORE of output destination of the NOISE part. Please
enter the data for the NOISE part in SCORE??-N. This SCORE can not be
outputted on its own. This SCORE must be mixed with one of the following
SCORE??S-1 -SCORE??S-3.
Ex: ...................................................
i DB OOOOOOOOB
```
```
If noise to be mixed with SCORE??S-1, change the value of "0" at Q to "1 ."
If noise to be mixed with SCORE??S-2, change the value of "0" at Q to "1 ."
If noise to be mixed with SCORE??S-3, change the value of "0" at @ to "1 ."
```
```
(NOISE part not used)
Please do the following:
(1) Please enter a rest in SCORE??S-N with the score length of one of the
SCORE??S-1 -SCORE??S-3.
```
```
(2) Please turn "ON" ("$01") the appropriate SCORE in area Q.
```
```
(3) Please turn "OFF' ail of the switches which define the SCORE of output
destination of the NOISE part (values of "0").
```
@ --- This is the music data for S'S'G sounds. Input method is the same as mentioned
for FM sound of MUSIC.SRC (please refer to earlier sections). The set is shown
below.
DB $(length of score), $(volume & tie), $(octave & key)

@ --- Please enter the NOISE part into this SCORE. Input method for length of score
and volume & tie are the same as above (please refer to earlier sections). Please
enter the following value for noise frequency, 0-IF. Smaller the value, lower the
frequency and larger the value, higher the frequency. The set is shown below.

```
DB $(length of score), $(volume & tie), $(noise frequency)
```

```
(Other Commands Used For S'S'G.SRC)
```
1. Envelop change
    The use of 10 pre-set envelop may be used on S'S'G sound of SCORE??S-1-3.
Ex:
DW $53, $(Envelop Shape), $(Envelop Speed)
(These three values consist a set, and should be entered in front of the note data of
SCORE??S-1-3.)

```
(Envelop Shapes)
Please entered the value shown in the table below for the corresponding envelop shape.
```
(Envelop Speed)
Defines the envelop speed. The range is from 0-FFFF, smaller the value, the faster the
speed.

2. $55 (SSG Stop Code)
    Please enter at the end of each SCORE.
3. Repeat Command
    The command that was explained in the MUSIC.SRC section may be used as well
in S'S'G.SRC. Please refer to the edrlier sections for instructions.


```
File Name: "OA??.SRC9' and "OB??.SRCfl
```
```
If two or more sound effect is ADPCMA sounds, using OA??.SRC; or if they are
ADPCMB sounds, using OB??.SRC will allow output of one following another with one
code. (Ex: If there are two sound effects entered, such as "click" and "boom," in
"TBL-EiY-PCMA" of "VO_PCMA.SRC;" using "OA??.SRC allows use of one code to
output the sound set of "click boom.")
```
```
File: "0AFO.SRC"
```
***** BEGIN TO FILE HEADER *****

***** DATA ENTRY PRIORITY *****

***** DATA ENTRY POINT ADDRESS TABLE *****

### DW SCOWAA -(A)

***** OPEN 1 CLOSE FLAG TABLE *****

### OPEN (01) CLOSE (00)

DB " 8

***** PART 1 DATA AREA *****

@ --- Defines the priority of the sound effects entered (defined below). Smaller the
value, higher the priority.

Q --- Flag table for sound effects entered. "$01" designates output, and "$00"
designates no output.


@ --- Defines the volume level of the outputted sound effects. "$80" is the volume level
designation, and the raising the value, "9F' above, defines the raise of volume
level. The range is $80-$9F.

@ --- The three bytes defines a set. The first byte defines the length of output. The.
output length is the same as the each note length of tempo "$B8" of
"MUSIC.SRC." (Ex: "$30,$??,$??" with tempo "$B8" is the same as a half
note.) The range is $00-$30. If the need is to have a longer length, please use the
second byte as a tie as it was done in "MUSIC.SRC."

```
The second byte designates the velocity and tie. Definition and inputting method
is the same as PCMA part in "MUSIC.SRC." Please refer to earlier sections.
```
```
The third byte defines the VOICE NUMBER (numerical value entered in
"TBL-KEY-PCM?" of "VOPCMA.SRC") of the sound effect.
```
@ --- This is the STOP CODE for "OA??.SRC." Please enter this code at the end of

```
these files.
```
Input Method for "OA??.SRC"

1. Copy the file and re-input the numerical value in (A), shown in the previous page, to
correspond with the file name. (If the file name is "OAFO.SRC," change the value in (A)
to "FO.")
2. Please remove ";O" in front of "AMUSICFO" of "Tl3L-PCMA-EFFECT2" in
"VO-PCMA.SRC" as is shown below:

TBL-PCMA-EFFECT2 ;OA??.SRC TABLE $FO-FF

### DEFW AMUSICFO

```
DEFW 0; AMUSICFl
DEFW 0; AMUSICF2
DEFW 0; AMUSICF3
```
3. Including "SDATA5.DAT."

._-_--_-_____-_-_-_--------------------------------------- ,---------------------------------------------------------

, Play MML data
._-------___--_------------------------------------------- ,---------------------------------------------------------

INCLUDE TBL-MU.SRC ;MUSIC TBL
.-____-__-__-__-__-_ * < PCMA OA mES >-- - - - - - - - -- - -- _ - - - -- - - -

```
INCLUDE 0AFO.SRC
```

4. Please enter the file name numerical value in a location in "TBL-EFFECT-PCMA" of
"VO-HOST.SRC." The value in the location will be the code. (Ex: If the file is
"OAFO.SRC," input "FO" into the dotted box. Then the code for "0AFO.SRC" would be
"EO.") Also, please enter "3" in the code area for "TBL-MCODE." (Please enter "3" in
the boxed area of TBL-MCODE for "EO.")

.* 9

. 9 *
7 * * * ** REQUEST CODE FLAG TABLE * ** **
.* 9
.* 9
. , * ; 0 : NO ENTRY
.* , ; 1 : ENTRY CODE
.* 7
.* 9 0123456789ABCDEF

TBL-MCODE EQU $
DB O,l,l,l,l,l,l,l,l,l,l,O,O,O,l,l ; 00
DB l,l,O,O,l,l,O,O,l,l,l,l,l,O,O,O ; 10
DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 20
DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 30

### NO ENTRY = 0

### SYSTEM CODE = 1

### MUSIC ENTRY = 2

### EFFECT PCMA ENTRY = 3

### EFFECT PCMB ENTRY = 4

### EFFECT SSG ENTRY = 5

9
TBL-EFFECT-PCMB ;HOST REQUEST $BO-$BF ; type HOST request

```
9 O 12 3 4 5 6 7 89 ABCDEF
DB $00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8
```

```
9
TBL-EFFECT-PCMA ;HOST REQUEST $CO-$FF ; type HOST request
7 0 12 3 4567 ~~ABCDEF
DB $00,$00,$00,$00, $OO,$OO,$OO,$OO,$OO,$OO,$OO,$OO,$OO,$OO,$oo,$oo ; C
DB ~00,$00,$00,$00, $OO,$OO,$OO,$OO,$OO,$OO,$OO,$OO,$OO,$OO,$oo,$ ; D
DB $00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00 9 $00 9 $00,$00
DB $00,$00,$00,$00, $00,$00,$00,$00,$00,$~,$00,$00,$,$00,$00,$00
```
### ; E

### ; F

```
9
COIN-CODE
DB $7F
```
```
After doing the set up shown in 1-4, sending "EO" code will output the sound entered in
"OAFO. SRC ."
```
```
Important Information on "OA??.SRC" and "OB??.SRC"
```
```
* Input into "OB??.SRC" is similar to "OA??.SRC." Please refer to information on
"OA??.SRC." There is however, one difference. In @mentioned in the previous
page, the values are different with "$80,$FF,$80,$46,$00." "$FF" is the volume with
range of $00-$FF. Note that $FF is the maximum volume.
```
* ADPCMA sound and ADPCMB sound may not be combined.

* Maximum of 15, "0AFO.SRC"-"0AFE.SRC" may be created for "OA??.SRC."

```
Maximum of 15, "0BFO.SRC"-"0BFE.SRC" may be created for "OB??.SRC."
```
* Please begin "OA??.SRC" with "0AFO.SRC." Once "OAFO-SRC" has been entered,

```
"VOICEOA-VOICEFA" of "TBL-Kl3Y-PCMA" in "VO-PCMA.SRC" can not be
used.
```

### CREATING M1 ROM

```
(1) Please use the assembler on "SDATA5.DAT" to compile.
```
```
(2) Please link the above output machine language with "SOUND2.COM (this is the
sound driver file). (Data address starts at 2EOOH.)
```
```
(3) The "SOUND2.COM" created by the above operation should be transferred to
address 0 and "WINDOW.COM (to prevent copying) to address 18000H with the
ROM writer. If the "SOUND2.COM exceeds address F7M, please create
"BANK.COM and transfer to address 10000H. (Creating "BANK.COM will be
covered later.)
```
```
(4) After transfer, please input the lower two digits of check sum in address 14; and the
numerical value l00H minus lower two digits of check sum (i.e. lOOH - value in
address 14) in address 15. These value should be inputted to the RAM of ROM
writer. (These values are necessary for start up ROM and RAM check of NEO-
GEO and MVS systems.)
```
```
After the operation in (1)-(4), please write into 1M ROM.
```
```
* If the assembler is from "IWASAIKI," operations (1)-(3) may be performed by the
use of batch file "SB.BAT" to compile and to link. (For "BANK.COM," please use
"SB .BAT.")
```
* If the ROM writer being used is from "ANDO," all transfers of COM file may be

```
done with "ANDO.EXE."
```
```
(Use)
Please type "AND0 (drive name) (file name)." After this input, instructions will
appear on the monitor. Please follow its instructions and set up the ROM writer.
```

### CREATING BANK.COM

```
(Explanation of BANK switch over)
There are "BANKO" and "BANK1" inside M1 ROM. The address of M1 ROM is
"OOOOOH-1FFFFN" with "BANKO" at "000OOH-OFFFFH" and "BANK1" at
" 1OOOOH- 1FFEFH."
```
```
(Area OF8OOH-OFFFFH of "BANKO" is used as a work area)
```
```
Data inputted into "BANK1" are "MUSIC.SRC" related. The switch over from
"BANKO" to "BANKl" is accomplished through the different MUSIC code sent and is
done automatically in the sound program.
```
```
SOUND2.COM (data included in SOUND2.REL+SDATA5.DAT) is inputted from
OOOOOH in "BANKO." If SOUND2.COM exceeds OF7FFH, "BANKl" is used. In this
case, "BANK.COM" (MUSIC data included in SDATA6.DAT) will be inputted from
10000H. Method of creating BANK.COM is shown below.
```
```
(Creating BANK.COM)
```
1. For "TBL-SBANK-No" in "SDATA5.DAT"
    Please enter "0" in the area that corresponds to the MUSIC code for the MUSIC data
    that is to be entered in "BANKO." Please enter "1" in the area that corresponds to
    the MUSIC code for the MUSIC data that is to be entered in "BANKl." If
    "BANKl" is not to be used, please enter "0." Sound program refers to this table to
    switch from one BANK to the other.
Ex:
MUSIC data with MUSIC code "32" is to be outputted from "BANK1"

```
.-----_--------------------------------------------------- ,------------------------------------------------------_--
9 BANK TABLE
.--__-_--------------------------------------------------- ,---------------------------------------------------------
```
. 9,9.. 0. .BANK0 l..BANKl

TBL-SBANK-No ;;; 0123456789ABCDEF
DEFB ~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~ ;20
DEFB 0,0~0,0,0,0,0,0,0,0,0,0,0,0,0 ;30
DEFB ~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~ ;40
DEFB ~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~ ;50

._-_---_------__-_---------------------------------------- ,---------------------------------------------------------


2. Please include the MUSIC data file name, that is to be entered in "BANK1," in
    "SDATA6.DAT." Next, define ORG to be at 8000H and please assemble (using IS)
the segment using ASEG (absolute). (ORG and ASEG have been defined in
"SDATA6.DAT." Also if the assembler is made by "IWASAKI" corporation,
"SDB.BAT" will assemble the segment.)
Ex:
In the example below, MUSIC data "HM21.SRC" and "HM25.SRC" are included.

```
.__----_-----_----------------------_-------------------_- 9
;(DO NOT TOUCH HERE)
ASEG
ORG 8000H
INCLUDE EQU4.ASM
.-______---_---_------------------------------------------ 9
```
```
INCLUDE HM21 .SRC
INCLUDE HM25.SRC
```
3. After assembling "SDATAG.DAT," please check the top address of MUSIC data (to
    be inputted in BANK1) included in "SDATA6.DAT." Please input these addresses in
    "TBL-MU.SRC" directly. (If the assembler is made by "IWASAKI" corporation,
    checking "SDATA6.$SY" after assembling will be sufficient. For example, if the
    MUSIC file is HM21 .SRC, look for the letters "HM21.SRC" in "SDATA6.$SY," the
    head address is the 4 digit numerical value left of "SDATA6.$SY.")
Ex:
The top address of MUSIC data "HM21.SRC" and "HM25.SRC" included in
"SDATA6.DAT" is directly inputted into "TBL-MU.SRC"
. 9 *
- 7 *
9 * **** MUSIC SCORE DATA TOP ADDRESS *****
. , *
.* 9
TBL-MUSIC EQU $
DEFW O;MUSIC20
DEFW 08000H ~9
DEFW O;MUSIC22
DEFW O;MUSIC23
DEFW O;MUSIC24
DEFW 08 15FH -m
DEFW O;MUSIC26


4. Please enter the value "2" in the code area in "TBL-MCODE" of "VO-HOST.SRC"
    which corresponds to the music number of the music source included in
    "SDATA6.SRC."
5. Please link the following files, "BANK.REL" (to prevent copying) and
    "SDATA6.REL" created so far with the procedures mentioned earlier.
       "BANK.COM should be created by this procedure. When linking, please define the
    data area starting from 8000h. (If the assembler is made by "IWASAKI"
    corporation, "SB.BAT" will do the linking operation.)
    Also, create "SOUND2.COM (Follciwing procedures 1 and 3, assemble, and link the
    files) and transfer "SOUND2.COM starting from OOOOH, "BANK.COM starting
    from 10000H, and "WINDOW.COM starting from 18000H to the 1M ROM.


```
Explanation of System Codes
System codes are codes necessary from the main CPU (68000) to control the sound
program. For example, to stop all request of BGM and effect noise, or to fade the music
out; the main CPU sends these codes. The code values range from 00 - IF, and each of
their functions are listed below.
```
```
SOUND PROGRAM SYSTEM CODE TABLE
```
```
Explanation of Codes
```
```
code
01
02
03
04
```
00
0 1
02
03
04
05
06
07
08
09
OA
OB
oc
OD
OE
OF

```
Code for the MVS. Please do not send this code.
This code will play the "eye-catch" BGM (5F).
Sound program reset. Please send this code in the beginning.
Will not accept any sound code (even if reset code is sent, this status will remain).
The coin sound (7F) is the only exception.
Will not accept any MUSIC codes (20 - 5F).
Will not accept any EFFECT codes (60 - FF).
Will accept all sound codes. This code must be sent after reset or k,~ DI for any
sound to be outputted.
Will accept all MUSIC codes (20 - 5F).
```
```
rnde
10
1 1
12
13
14
15
16
17
18
19
1A
1B
1C
ID
1E
1F
```
```
bank change
request of "eye-catch" BGM
reset of sound program
ALLDI
MUSIC DI
EFFECT DI
ALLEI
MUSICEI
EFFECTEI
fadeout
```
```
tempo change
SSGSTOP
```
```
FTTNrTTnN
ROM & RAM check
fade out stop
```
```
ADPCMA(TBL-KEY-PCMA) sound effect stop
ADPCMAWL-KEY-PCMA2) sound effect stop
```
```
ADPCMA(TBL-KEY-PCMA) sound effect stop
ADPCMAWL-KEY-PCMB) sound effect stop
ADPcMAWL-KE~Y-PCMA~) sound effect stop
ADPCMA(TI3L-KEY-PCMB2) sound effect stop
ADPcMA(TBL-KEY-PCMA~) sound effect stop
```

### DEVELOPMENT BOARD DIP SWITCH QUICK REFERENCE TABLE

```
X0007-EPIC0 (Prog-Side) Dip-SW Quick Reference Table
```
I I1,I.I.

```
Define PCM-ROM Type
```
1 1 1

```
007-EPIC (Prog-Side) Dip-SW Quick Reference Table
```
```
For Expansion (Do Not Touch)
Define Program ROM Type
```
### 12345678

### DSW2

### (NOTE)

1. A blank space inside the small boxes designate Dip-SW OFF.
2. Please do not touch the areas which are marked as "For Expansion." There is no

### ON

### ON

### ONON

```
A
guarantee that the system will run properly when they are turned ON.
```
### IM-ROM WON-JEDEC)

### IM-ROM IJEDEC)

### ON

### IM-ROM (NON-JEDEC)

### IM-ROM (JEDEC)

### 4M-ROM

### IM-ROM


```
Will accept all EFFECT codes (60 - IT).
Will fade out the BGM currently being played. Send the speed value, 00 - FF,
after this code. Larger the value the faster the fade out speed.
Will change the tempo of the BGM currently being played. Please send the tempo
data after this code (Tempo data is the same as the MUSIC file data).
Will stop the SSG sound effect (It will only stop the output).
Please do not send this code.
Sending this code during fade out will stop the fade out.
Sending voice number entered in "TBL-KEY-PCMA" after this code will stop
that sound effect.
Sending voice number entered in "TBL-KEY-PCMA2" after this code will stop
that sound effect.
Sending voice number entered in "TBL-KEY-PCMA after this code will start
output of that sound effect.
Sending voice number entered in "TBL-KEY-PCMB" after this code will start
output of that sound effect.
Sending voice number entered in 'LTBL-KEY-PCMA2" after this code will start
output of that sound effect.
Sending voice number entered in "TBL-KEY-PCMB2" after this code will start
output of that sound effect.
Sending voice number entered in "TBL-KEY-PCMA3" after this code will start
output of that sound effect.
```
### NOTE:

OOH - 1FH table of "TBL-MCODE in "VO-HOST.SRC" are part of the sound
program system code entry. Please enter the value "1" inside the corresponding area of
"TBL-MCODE with respect with the sound program system code entry.
If sending two or more codes consecutively, please wait 64 ms or more for reset
code, or 32 ms or more for other codes (including codes other than system codes).


```
About the PCM-ROM
```
```
For the PCM-ROM, you may use three types of ROM with different capacity and pin
configuration. The ROMs that can be used in this board is: 1M JEDEC type ROM, 1M
NON-JEDEC type ROM, 4M-ROM. There are three choices, but using a different type
ROM among the JEDEC types result in the program not working properly and may result
in loss of the very expensive ROMs.
```
```
About the Program ROM
```
1. Just like the PCM-ROM, three ROM types mentioned above may be used. In addition
1M-RAM is also available. When the program area is used as a RAM, you can not write
directly into this area. When loading the program into RAM, please start from address
200000H. RAM address OH has a correspondence with address 200000H, except you can
not write into this area.
2. After changing the program area to RAM, there is a danger of running the program
and destroying the area. To prevent this kind of accident, there is a memory write protect
SW on the board. There should be a switch with the marking "SW3." Pushing the switch
toward the right side will stop any writing requests from the main board. (This switch is
valid for memory cards as well.)

```
Writing Allowed
SW3
```
### WE ENABULE

```
Writing Not Allowed
SW3
```
```
WE ENABULE
```
3. When using a 4M-ROM for the program ROM, please insert ROM into socket P1 and
P2. Inserting into other sockets will not work.

About the Memory Card

1. On this board, the memory card may be used as a program RAM. The memory card
that may be used are JEIDA format. Also you may insert two 4Mbit memory card.
2. This board does not support back up, but by using the memory card, it offers the same
function. When using the memory card, please do not insert anything into program
sockets (PI - P8).
3. Inserting the memory card will light the CDlEN or CD2EN LED. If the LED is not
lit, please make sure the memory card has been inserted correctly. Also, if the write
protect SW of the memory card is ON, CDlWP or CD2WP LED will go off.


```
NOTE:
```
1. Although in RAM mode, addresses 20000H and later addresses are used for program
load, please do not used addresses 2FFFFOH - 2IiliFFFH since they are reserved for
expansion.
2. Leaving the memory card inserted after the power has been turned off results in faster
consumption of the back up battery of the memory card. And for protection of the
memory card, please take the card out and into a protective casing when turning the
power off.

```
~0007-EPICO Memory Map
```
1. When Using Memory Cards
    - 200000H-
    I I

1 Memory Card 1 I

t--p.E~j-+ Memory Card 2

```
9 The above memory map corresponds to when memory is being written in.
During read, start address may be set at OH.
```
2. When Using RAM

```
EVEN ODD
9 The above memory map corresponds to when memory is being written in.
During read, start address may be set at OH.
```
