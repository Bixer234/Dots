static const char norm_fg[] = "#e8e2dc";
static const char norm_bg[] = "#0f0f18";
static const char norm_border[] = "#a29e9a";

static const char sel_fg[] = "#e8e2dc";
static const char sel_bg[] = "#9D9AAA";
static const char sel_border[] = "#e8e2dc";

static const char urg_fg[] = "#e8e2dc";
static const char urg_bg[] = "#7E8197";
static const char urg_border[] = "#7E8197";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
