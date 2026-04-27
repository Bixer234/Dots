static const char norm_fg[] = "#c1caca";
static const char norm_bg[] = "#0d0d0d";
static const char norm_border[] = "#878d8d";

static const char sel_fg[] = "#c1caca";
static const char sel_bg[] = "#75817E";
static const char sel_border[] = "#c1caca";

static const char urg_fg[] = "#c1caca";
static const char urg_bg[] = "#687576";
static const char urg_border[] = "#687576";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
