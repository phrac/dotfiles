/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>
/* appearance */

static const char *fonts[] = {"Hack Nerd Font:size=9"};
static const char dmenufont[] = "Hack Nerd Font:size=9";

/* useless gaps patch */
static const unsigned int gappx = 0;
static const unsigned int borderpx = 2;       /* border pixel of windows */
static const unsigned int snap = 12;          /* snap pixel */
static const Bool showbar = True;             /* False means no bar */
static const Bool topbar = True;              /* False means bottom bar */
static const unsigned int systrayspacing = 2; /* systray spacing */
static const int defaultpriority = 50;
static const Bool showsystray = 0; /* False means no systray */
static const char col_gray1[] = "#2e3440";
static const char col_gray2[] = "#3b4252";
static const char col_gray3[] = "#d8dee9";
static const char col_gray4[] = "#81a1c1";
static const char col_cyan[] = "#81a1c1";
static const char *colors[][3] = {
    /*               fg         bg         border   */
    [SchemeNorm] = {col_gray3, col_gray1, col_gray2},
    [SchemeSel] = {col_gray4, col_gray1, col_cyan},
};

/* statusbar colors */
#define NUMCOLORS 2
/*static const char colors[NUMCOLORS][MAXCOLORS][8] = {
        // border   foreground background
        { "#2e3440", "#81a1c1", "#2e3440" },  // normal
        { "#81a1c1", "#81a1c1", "#2e3440" },  // selected
        // add more here
};*/
// static const char colors[NUMCOLORS][MAXCOLORS][17] = {
/* border    fg         bg */
//    { "#3b4252", "#d8dee9", "#2e3440" },        /* [0]  01 - Client normal */
//    { "#81a1c1", "#81a1c1", "#2e3440" },        /* [1]  02 - Client selected
//    */ { "#83a598", "#81a1c1", "#2e3440" },        /* [2]  03 - Client urgent
//    */ { "#83a598", "#81a1c1", "#2e3440" },        /* [3]  04 - Client
//    occupied */ { "#2e3440", "#fb4934", "#2e3440" },        /* [4]  05 - Red
//    */ { "#2e3440", "#fabd2f", "#2e3440" },        /* [5]  06 - Yellow */ {
//    "#2e3440", "#81a1c1", "#2e3440" },        /* [6]  07 - Green */ {
//    "#2e3440", "#81a1c1", "#2e3440" },        /* [7]  08 - Dark grey */ {
//    "#2e3440", "#d5c4a1", "#2e3440" },        /* [8]  09 - Light grey */ {
//    "#2e3440", "#81a1c1", "#2e3440" },        /* [9]  0A - Bar normal*/ {
//    "#3c3836", "#81a1c1", "#2e3440" },        /* [10] 0B - Bar selected*/
//   { "#fb4934", "#fb4934", "#2e3440" },        /* [11] 0C - Bar urgent*/
//    { "#928374", "#458588", "#2e3440" },        /* [12] 0D - Bar occupied*/
//    { "#3b4252", "#d8dee9", "#2e3440" },        /* [13] 0E - Tag normal*/
//    { "#81a1c1", "#81a1c1", "#81a1c1" },        /* [14] 0F - Tag selected*/
//    { "#fb4934", "#fb4934", "#2e3440" },        /* [15] 10 - Tag urgent*/
//    { "#3c3836", "#928374", "#2e3440" },        /* [16] 11 - Tag occupied*/
//};

/* tagging */
static const char *tags[] = {"", "", "", "", "ﴬ", "", "", ""};

static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class                instance    title       tags mask   iscentered
       isfloating   monitor */
    {"Gimp", NULL, NULL, 1 << 7, True, 0},
    {"Firefox", NULL, NULL, 2, False, 0},
    {"feh", NULL, NULL, 0, True, 0},
    {"Chromium-browser", NULL, NULL, 2, False, 0},
    {"Pcmanfm", NULL, NULL, 1 << 3, True, 0},
    {"Thunar", NULL, NULL, 1 << 3, True, 0},
    {"Geeqie", NULL, NULL, 0, True, -1},
    {"Viewnior", NULL, NULL, 0, True, -1},
    {"mpv", NULL, NULL, 0, True, -1},
    {"Sxiv", NULL, NULL, 0, True, -1},
    {"keepassx", NULL, NULL, 0, True, -1},
    {"MuPDF", NULL, NULL, 0, True, -1},
};

/* layout(s) */
static const float mfact = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;    /* number of clients in master area */
static const Bool resizehints =
    False; /* True means respect size hints in tiled resizals */

#include "layouts.c"
#include "tcl.c"
static const Layout layouts[] = {
    /* symbol     arrange function */
    {"侀", tile}, /* first entry is default */
    {"ﱖ", grid},
    {"𧻓", NULL}, /* no layout function means floating behavior */
    {"履", monocle},
    {"恵", tcl},
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
      {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
      {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},                        \
      {MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                       \
  }

/* commands */
#include "commands.c"

static Key keys[] = {
    /* modifier                     key        function        argument */
    {MODKEY, XK_r, spawn, {.v = dmenucmd}},
    {MODKEY, XK_Return, spawn, {.v = termcmd}},
    {MODKEY, XK_b, togglebar, {0}},
    {MODKEY, XK_j, focusstack, {.i = +1}},
    {MODKEY | ShiftMask, XK_j, zoom, {0}},
    {MODKEY, XK_k, focusstack, {.i = -1}},
    {MODKEY, XK_i, incnmaster, {.i = +1}},
    {MODKEY, XK_d, incnmaster, {.i = -1}},
    {MODKEY, XK_h, setmfact, {.f = -0.05}},
    {MODKEY, XK_l, setmfact, {.f = +0.05}},
    {MODKEY, XK_Tab, view, {0}},
    {MODKEY, XK_q, killclient, {0}},
    {MODKEY, XK_t, setlayout, {.v = &layouts[0]}}, /* tile */
    {MODKEY, XK_g, setlayout, {.v = &layouts[1]}}, /* grid */
    {MODKEY, XK_f, setlayout, {.v = &layouts[2]}}, /* floating */
    {MODKEY, XK_m, setlayout, {.v = &layouts[3]}}, /* monocle */
    {MODKEY, XK_s, setlayout, {.v = &layouts[4]}}, /* tcl */
    {MODKEY | ShiftMask, XK_space, togglefloating, {0}},
    {MODKEY, XK_0, view, {.ui = ~0}},
    {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},
    {MODKEY, XK_comma, focusmon, {.i = -1}},
    {MODKEY, XK_period, focusmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_o, spawn, {.v = browsercmd}},
    {MODKEY | ShiftMask, XK_f, spawn, {.v = fmcmd}},
    {MODKEY | ControlMask | ShiftMask, XK_f, spawn, {.v = termfm}},
    {MODKEY, XK_e, spawn, {.v = browseremail}},
    {MODKEY, XK_v, spawn, {.v = guieditor}},
    {MODKEY, XK_Print, spawn, {.v = windowshot}},
    {0, XK_Print, spawn, {.v = screenshot}},
    {0, XK_F12, spawn, {.v = nexttrack}},
    {0, XK_F11, spawn, {.v = playpause}},
    {0, XK_F10, spawn, {.v = prevtrack}},
    {0, XK_F15, spawn, {.v = thumbsup}},
    TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
        TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5) TAGKEYS(XK_7, 6) TAGKEYS(XK_8, 7)
            TAGKEYS(XK_9, 8){MODKEY | ShiftMask, XK_q, quit, {0}},
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or
 * ClkRootWin */
static Button buttons[] = {
    /* click                event mask      button          function argument
     */
    {ClkLtSymbol, 0, Button1, setlayout, {0}},
    {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
    {ClkWinTitle, 0, Button2, zoom, {0}},
    {ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
    {ClkClientWin, MODKEY, Button1, movemouse, {0}},
    {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin, MODKEY, Button3, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
};
