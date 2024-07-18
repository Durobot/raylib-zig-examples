// Since raygui is a single-header C library,
// we've got to have this "implementation" file,
// which is just an adapter used to facilitate C-to-Zig
// translation
#define RAYGUI_IMPLEMENTATION

// UGLY WORKAROUND:
// Declaration and implementation of `TextToFloat` were copied from raygui.h due to reasons below.
// I'm not sure why `raygui.h` does this now, but `TextToFloat` is defined ONLY if
// `RAYGUI_STANDALONE` constant is defined.
// At the same time, `TextToFloat` is called from `GuiValueBoxFloat`, which means it can't be compiled.
// So, in order to build our project, we must provide a copy of `TextToFloat`, since we do not
// want to define `RAYGUI_STANDALONE` (it breaks things for us).
static float TextToFloat(const char *text);         // Get float value from text

#include "raygui.h"

// Get float value from text
// NOTE: This function replaces atof() [stdlib.h]
// WARNING: Only '.' character is understood as decimal point
static float TextToFloat(const char *text)
{
    float value = 0.0f;
    float sign = 1.0f;

    if ((text[0] == '+') || (text[0] == '-'))
    {
        if (text[0] == '-') sign = -1.0f;
        text++;
    }

    int i = 0;
    for (; ((text[i] >= '0') && (text[i] <= '9')); i++) value = value*10.0f + (float)(text[i] - '0');

    if (text[i++] != '.') value *= sign;
    else
    {
        float divisor = 10.0f;
        for (; ((text[i] >= '0') && (text[i] <= '9')); i++)
        {
            value += ((float)(text[i] - '0'))/divisor;
            divisor = divisor*10.0f;
        }
    }

    return value;
}
