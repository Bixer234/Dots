const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#0d0d0d", /* black   */
  [1] = "#687576", /* red     */
  [2] = "#75817E", /* green   */
  [3] = "#6B7E81", /* yellow  */
  [4] = "#77898B", /* blue    */
  [5] = "#869896", /* magenta */
  [6] = "#90A19F", /* cyan    */
  [7] = "#c1caca", /* white   */

  /* 8 bright colors */
  [8]  = "#878d8d",  /* black   */
  [9]  = "#687576",  /* red     */
  [10] = "#75817E", /* green   */
  [11] = "#6B7E81", /* yellow  */
  [12] = "#77898B", /* blue    */
  [13] = "#869896", /* magenta */
  [14] = "#90A19F", /* cyan    */
  [15] = "#c1caca", /* white   */

  /* special colors */
  [256] = "#0d0d0d", /* background */
  [257] = "#c1caca", /* foreground */
  [258] = "#c1caca",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
