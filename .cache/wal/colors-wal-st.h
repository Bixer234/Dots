const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#181915", /* black   */
  [1] = "#50B448", /* red     */
  [2] = "#668B75", /* green   */
  [3] = "#A99068", /* yellow  */
  [4] = "#E8AE53", /* blue    */
  [5] = "#D5A96D", /* magenta */
  [6] = "#669787", /* cyan    */
  [7] = "#ddd1bc", /* white   */

  /* 8 bright colors */
  [8]  = "#9a9283",  /* black   */
  [9]  = "#50B448",  /* red     */
  [10] = "#668B75", /* green   */
  [11] = "#A99068", /* yellow  */
  [12] = "#E8AE53", /* blue    */
  [13] = "#D5A96D", /* magenta */
  [14] = "#669787", /* cyan    */
  [15] = "#ddd1bc", /* white   */

  /* special colors */
  [256] = "#181915", /* background */
  [257] = "#ddd1bc", /* foreground */
  [258] = "#ddd1bc",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
