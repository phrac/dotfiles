/* FreeBSD volume/mixer control */
#if defined(__FreeBSD__)
    static const char *volup[]      =   { "mixer", "vol", "+2", NULL };
    static const char *voldown[]    =   { "mixer", "vol", "-2", NULL };
    static const char *volmute[]    =   { "mixer", "vol", "0", NULL };
#endif

/* OpenBSD volume/mixer control */
#if defined(__OpenBSD__)
    static const char *volup[]      =   { "mixerctl", "outputs.master=+2", NULL };
    static const char *voldown[]    =   { "mixerctl", "outputs.master=-2", NULL };
    static const char *volmute[]    =   { "mixerctl", "outputs.master.mute=toggle", NULL };
#endif


/* Standard commands */
static char dmenumon[2] = "0";
static const char *dmenucmd[]   =   { "rofi", "-show", "run", NULL };
/*static const char *termcmd[]    =   { "/home/derek/dotfiles/st/st", NULL }; */
static const char *termcmd[]    =   { "urxvtc", NULL};
static const char *browsercmd[] =   { "iridium", NULL };
static const char *screenshot[] =   { "/home/derek/bin/ss.py", NULL };
static const char *windowshot[] =   { "/home/derek/bin/ss.py", "-window", NULL };
static const char *nexttrack[]  =   { "cmus-remote", "-n", NULL };
static const char *prevtrack[]  =   { "cmus-remote", "-r", NULL };
static const char *playpause[]  =   { "cmus-remote", "-u", NULL };
static const char *thumbsup[]   =   { "cmus-remote", "-C", "win-add-p", NULL };
static const char *editor[]     =   { "$EDITOR", NULL };
static const char *guieditor[]  =   { "nvim-gtk", NULL };
static const char *fmcmd[]      =   { "thunar", NULL };
static const char *termfm[]     =   { "/home/derek/dotfiles/st/st", "-e" "ranger", NULL };
static const char *browseremail[] = { "surf", "protonmail.com", NULL };
static const char *decbright[]  =   { "xbacklight", "-dec", "10", "-steps", "1", NULL };
static const char *incbright[]  =   { "xbacklight", "-inc", "10", "-steps", "1", NULL };


