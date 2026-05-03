static const char norm_fg[] = "#c9c8ba";
static const char norm_bg[] = "#242129";
static const char norm_border[] = "#8c8c82";

static const char sel_fg[] = "#c9c8ba";
static const char sel_bg[] = "#C4656C";
static const char sel_border[] = "#c9c8ba";

static const char urg_fg[] = "#c9c8ba";
static const char urg_bg[] = "#956566";
static const char urg_border[] = "#956566";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
