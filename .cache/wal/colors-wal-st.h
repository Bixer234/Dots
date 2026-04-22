const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#121212", /* black   */
  [1] = "#645B4E", /* red     */
  [2] = "#756755", /* green   */
  [3] = "#85725A", /* yellow  */
  [4] = "#897B67", /* blue    */
  [5] = "#958773", /* magenta */
  [6] = "#A4917A", /* cyan    */
  [7] = "#cac4bb", /* white   */

  /* 8 bright colors */
  [8]  = "#8d8982",  /* black   */
  [9]  = "#645B4E",  /* red     */
  [10] = "#756755", /* green   */
  [11] = "#85725A", /* yellow  */
  [12] = "#897B67", /* blue    */
  [13] = "#958773", /* magenta */
  [14] = "#A4917A", /* cyan    */
  [15] = "#cac4bb", /* white   */

  /* special colors */
  [256] = "#121212", /* background */
  [257] = "#cac4bb", /* foreground */
  [258] = "#cac4bb",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
