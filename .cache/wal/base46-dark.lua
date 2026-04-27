local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = "#e4e2e1",
  black = "#131313",
  darker_black = lighten("#131313", -3),
  black2 = lighten("#131313", 6),
  one_bg = lighten("#131313", 10),
  one_bg2 = lighten("#131313", 16),
  one_bg3 = lighten("#131313", 22),
  grey = "#434848",
  grey_fg = lighten("#434848", -10),
  grey_fg2 = lighten("#434848", -20),
  light_grey = "#8d9291",
  red = "#ffb595",
  baby_pink = lighten("#ffb595", 10),
  pink = "#c8c5cf",
  line = "#8d9291",
  green = "#e8ffea",
  vibrant_green = lighten("#e8ffea", 10),
  blue = "#afc6ff",
  nord_blue = lighten("#afc6ff", 10),
  yellow = "#ffffff",
  sun = lighten("#ffffff", 10),
  purple = "#c8c5cf",
  dark_purple = lighten("#c8c5cf", -10),
  teal = "#464a4a",
  orange = "#ffb595",
  cyan = "#ffffff",
  statusline_bg = lighten("#131313", 6),
  pmenu_bg = "#434848",
  folder_bg = lighten("#bec8c8", 0),
  lightbg = lighten("#131313", 10),
}

M.base_16 = {
  base00 = "#131313",
  base01 = lighten("#434848", 0),
  base02 = lighten("#434848", 3),
  base03 = lighten("#8d9291", 0),
  base04 = lighten("#c3c7c7", 0),
  base05 = "#e4e2e1",
  base06 = lighten("#e4e2e1", 0),
  base07 = "#131313",
  base08 = "#ffb595",
  base09 = "#ffffff",
  base0A = "#afc6ff",
  base0B = "#e8ffea",
  base0C = "#ffffff",
  base0D = lighten("#afc6ff", 20),
  base0E = "#c8c5cf",
  base0F = "#e4e2e1",
}

M.type = "dark"

M.polish_hl = {
  defaults = {
    Comment = {
      italic = true,
      fg = M.base_16.base03,
    },
  },
  Syntax = {
    String = {
      fg = "#c8c5cf",
    },
  },
  treesitter = {
    ["@comment"] = {
      fg = M.base_16.base03,
    },
    ["@string"] = {
      fg = "#c8c5cf",
    },
  },
}

return M
