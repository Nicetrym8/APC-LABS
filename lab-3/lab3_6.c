/*
Ports 40h-43h, 43h - conrol port for timer

43h:
bits 7 – 6: if not 11 — channel number
00,01,10 = channel 0,1,2
bits 5 – 4:
00 — capture counter value
01 — r/w lsb
10 — r/w msb
11 — r/w lsb then msb
bits 3 – 1: mode
000: IRQ0 if zero
001: 1 pulse fixed time
010: periodic pulse generation
011: square wave 50%(main mode)
100: software 1 pulse
101: hardware 1 pulse
bit 0: counter format:
0 — Binary 16bit
1 - BCD

bits 7 – 6: if 11 - read timer status
bits 5 – 4: read mode
00: RS/(OL <- CE)
01: (OL <- CE)
10: RS
bits 3 – 1: channels 3 – 1

RS:
bit 7: OUT state
bit 6: 1/0 counter state
bits 5 – 0: undefined(from prev command)

Channel registers:
    RS (8); status
    RSW (8); conrol word
    OL (16); buffer (for reading)
    CE (16); counter
    CR (16); for some modes
Lines:
    GATE - control input;
    CLOCK - clock freq;
    OUT - timer output


*/


#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <dos.h>

#define ARRAY_SIZE(n) sizeof(n)/sizeof(n[0])
#define BASE_MAX_FREQ 1193180L
typedef struct note {
    int freq;
    int delay;
} note;
typedef void (*menu_function)();
typedef struct menu_struct {
    menu_function fun;
    const char* name;
}menu_struct;
void play_melody();
void exit_program();
void get_state_of_timer();
void char_to_binary(unsigned char state, char* str);
void toggle_speaker();
void setup_counter_param(int freq);
menu_struct menu[] = {
    {exit_program,"Exit"},
    {play_melody,"Play Melody"},
    {get_state_of_timer, "Get RS/CE"}
};
const note melody[] = {
    {293,140},
    {0,70},
    {293,122},
    {0,61},
    {587,248},
    {0,124},
    {440,368},
    {0,184},
    {415,256},
    {0,128},
    {392,242},
    {0,121},
    {349,251},
    {0,125},
    {293,121},
    {0,60},
    {349,121},
    {0,60},
    {392,128},
    {0,64},
};

void print_menu() {
    char i;
    for (i = 0;i < ARRAY_SIZE(menu);i++)
        printf("%d: %s\n", i, menu[i].name);
}
int main() {
    char c;
    char i;
    system("cls");
    print_menu();
    while (c = getchar()) {
        system("cls");
        print_menu();
        for (i = 0;i < ARRAY_SIZE(menu);i++)
            if (c == (i + '0'))
                menu[i].fun();
    }
    return 0;
}

inline void get_state_of_timer()
{
    char channel;
    int counter_val;
    char bin_state[9];
    system("cls");
    for (channel = 0; channel < 3; channel++)
    {
        outp(0x43, 0xC0 | (1 << (channel + 1))); //command, 
        char_to_binary(inp(0x40 + channel), bin_state);
        counter_val = inp(0x40 + channel);
        counter_val += inp(0x40 + channel) << 8;
        printf("Channel %d: RS: %s CE:0x%X\n", channel, bin_state, counter_val);
    }
    getchar();
}
void exit_program() {
    exit(0);
}
void char_to_binary(char state, char* str)
{
    signed char i;
    for (i = 7; i >= 0; i--)
    {
        str[i] = ((state & 1) + '0');
        state >>= 1;
    }
    str[8] = '\0';
}

void setup_counter_param(int freq) {
    unsigned long prescaler;
    outp(0x43, 182); //10110110 c2; lsb,msb; mode PWM, fmt BIN16
    prescaler = (BASE_MAX_FREQ / freq);
    outp(0x42, (char)prescaler); // lsb
    outp(0x42, (prescaler >> 8)); //msb
    printf("Channel 2 - 0x%X\n", prescaler);
    return;
}

void toggle_speaker() {
    static char active = 0;
    if (!active) {
        outp(0x61, inp(0x61) | 3); //channel and speaker - bit0,1
        active = 1;
        return;
    }
    outp(0x61, inp(0x61) & 0xFC);
    active = 0;
    return;
}

void play_melody() {
    int i;
    system("cls");
    for (i = 0; i < ARRAY_SIZE(melody); i++) {
        if (melody[i].freq) {
            setup_counter_param(melody[i].freq);
            toggle_speaker();
            delay(melody[i].delay);
            toggle_speaker();
        }
        else
            delay(melody[i].delay);
    }
    getchar();
}
