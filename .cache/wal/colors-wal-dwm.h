static const char norm_fg[] = "#ddd1bc";
static const char norm_bg[] = "#181915";
static const char norm_border[] = "#9a9283";

static const char sel_fg[] = "#ddd1bc";
static const char sel_bg[] = "#668B75";
static const char sel_border[] = "#ddd1bc";

static const char urg_fg[] = "#ddd1bc";
static const char urg_bg[] = "#50B448";
static const char urg_border[] = "#50B448";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
