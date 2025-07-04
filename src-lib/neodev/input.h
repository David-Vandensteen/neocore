#ifndef __INPUT_H__
#define __INPUT_H__

#ifdef __cplusplus
	extern "C" {
#endif

//controller types (status byte)
#define CTRL_NOCONNECT	0x00
#define CTRL_STANDARD	0x01
#define CTRL_EXPANDED	0x02	//4P mode
#define CTRL_MAHJONG	0x03
#define CTRL_KEYBOARD	0x04

//hardware registers
#define P1_HW		0x300000
#define P2_HW		0x340000

//bios values
#define P1_STATUS	0x10fd94
#define P1_PAST		0x10fd95
#define P1_CURRENT	0x10fd96
#define P1_EDGE		0x10fd97
#define P1_REPEAT	0x10fd98
#define P1_TIMER	0x10fd99

#define P2_STATUS	0x10fd9a
#define P2_PAST		0x10fd9b
#define P2_CURRENT	0x10fd9c
#define P2_EDGE		0x10fd9d
#define P2_REPEAT	0x10fd9e
#define P2_TIMER	0x10fd9f

//P1B is P3
#define P1B_STATUS	0x10fda0
#define P1B_PAST	0x10fda1
#define P1B_CURRENT	0x10fda2
#define P1B_EDGE	0x10fda3
#define P1B_REPEAT	0x10fda4
#define P1B_TIMER	0x10fda5

//P2B is P4
#define P2B_STATUS	0x10fda6
#define P2B_PAST	0x10fda7
#define P2B_CURRENT	0x10fda8
#define P2B_EDGE	0x10fda9
#define P2B_REPEAT	0x10fdaa
#define P2B_TIMER	0x10fdab

//select/start buttons
#define PS_CURRENT	0x10fdac
#define PS_EDGE		0x10fdad

// Positions : sSDCBARLDU
#define JOY_UP		0x01
#define JOY_DOWN	0x02
#define JOY_LEFT	0x04
#define JOY_RIGHT	0x08
#define JOY_A		0x10
#define JOY_B		0x20
#define JOY_C		0x40
#define JOY_D		0x80

#define P1_START	0x01
#define P1_SELECT	0x02
#define P2_START	0x04
#define P2_SELECT	0x08
#define P1B_START	0x10
#define P1B_SELECT	0x20
#define P2B_START	0x40
#define P2B_SELECT	0x80

//Mahjong defines
#define P1_JONG_A_G	0x10fd95
#define P1_JONG_H_N	0x10fd96
#define P1_JONG_BTN	0x10fd97

#define P2_JONG_A_G	0x10fd9b
#define P2_JONG_H_N	0x10fd9c
#define P2_JONG_BTN	0x10fd9d

#define JONG_A		0x01
#define JONG_B		0x02
#define JONG_C		0x04
#define JONG_D		0x08
#define JONG_E		0x10
#define JONG_F		0x20
#define JONG_G		0x40
#define JONG_H		0x01
#define JONG_I		0x02
#define JONG_J		0x04
#define JONG_K		0x08
#define JONG_L		0x10
#define JONG_M		0x20
#define JONG_N		0x40
#define JONG_PON	0x01
#define JONG_CHI	0x02
#define JONG_KAN	0x04
#define JONG_RON	0x08
#define JONG_REACH	0x10


#ifdef __cplusplus
	}
#endif

#endif // __INPUT_H__
