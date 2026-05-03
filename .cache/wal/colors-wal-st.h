const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#242129", /* black   */
  [1] = "#956566", /* red     */
  [2] = "#C4656C", /* green   */
  [3] = "#938C79", /* yellow  */
  [4] = "#B39379", /* blue    */
  [5] = "#CD9B7A", /* magenta */
  [6] = "#797E84", /* cyan    */
  [7] = "#c9c8ba", /* white   */

  /* 8 bright colors */
  [8]  = "#8c8c82",  /* black   */
  [9]  = "#956566",  /* red     */
  [10] = "#C4656C", /* green   */
  [11] = "#938C79", /* yellow  */
  [12] = "#B39379", /* blue    */
  [13] = "#CD9B7A", /* magenta */
  [14] = "#797E84", /* cyan    */
  [15] = "#c9c8ba", /* white   */

  /* special colors */
  [256] = "#242129", /* background */
  [257] = "#c9c8ba", /* foreground */
  [258] = "#c9c8ba",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
