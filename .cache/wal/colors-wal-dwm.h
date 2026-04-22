static const char norm_fg[] = "#cac4bb";
static const char norm_bg[] = "#121212";
static const char norm_border[] = "#8d8982";

static const char sel_fg[] = "#cac4bb";
static const char sel_bg[] = "#756755";
static const char sel_border[] = "#cac4bb";

static const char urg_fg[] = "#cac4bb";
static const char urg_bg[] = "#645B4E";
static const char urg_border[] = "#645B4E";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
