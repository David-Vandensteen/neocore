// FILE created by NGFX SoundBuilder v0.210501 [SoundBank Release]

static inline void send_sound_command(BYTE CommandNo)
{
    (*((PBYTE)0x320000)) = CommandNo;
}

// Z80 System commands
#define SOUNDBANK_00 (0x08)
#define SOUNDBANK_01 (0x09)
#define SOUNDBANK_02 (0x0a)
#define SOUNDBANK_03 (0x0b)
#define SOUNDBANK_04 (0x0c)
#define SOUNDBANK_05 (0x0d)
#define SOUNDBANK_06 (0x0e)
#define SOUNDBANK_07 (0x0f)
#define ADPCM_STOP (0x18)
#define ADPCMA_LOOP_STOP (0x19)
#define ADPCMB_LOOP_STOP (0x1a)
#define ADPCM_FADE_OUT (0x1b)
#define ADPCM_FADE_IN (0x1c)
#define CDDA_STOP (0x1d)
#define CDDA_PAUSE (0x1e)
#define CDDA_RESUME (0x1f)

// Z80 Sound commands

// SoundBank 00
#define ADPCM_MIXKIT_GAME_CLICK_1114 (0x20)
