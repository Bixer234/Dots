const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#0f0f18", /* black   */
  [1] = "#7E8197", /* red     */
  [2] = "#9D9AAA", /* green   */
  [3] = "#C2B8BD", /* yellow  */
  [4] = "#D3D1BB", /* blue    */
  [5] = "#C2BBC2", /* magenta */
  [6] = "#D4D3CC", /* cyan    */
  [7] = "#e8e2dc", /* white   */

  /* 8 bright colors */
  [8]  = "#a29e9a",  /* black   */
  [9]  = "#7E8197",  /* red     */
  [10] = "#9D9AAA", /* green   */
  [11] = "#C2B8BD", /* yellow  */
  [12] = "#D3D1BB", /* blue    */
  [13] = "#C2BBC2", /* magenta */
  [14] = "#D4D3CC", /* cyan    */
  [15] = "#e8e2dc", /* white   */

  /* special colors */
  [256] = "#0f0f18", /* background */
  [257] = "#e8e2dc", /* foreground */
  [258] = "#e8e2dc",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
