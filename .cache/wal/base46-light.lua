local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = "#e7e1e1",
  black = "#151313",
  darker_black = lighten("#151313", -3),
  black2 = lighten("#151313", 6),
  one_bg = lighten("#151313", 10),
  one_bg2 = lighten("#151313", 16),
  one_bg3 = lighten("#151313", 22),
  grey = "#4e4446",
  grey_fg = lighten("#4e4446", -10),
  grey_fg2 = lighten("#4e4446", -20),
  light_grey = "#9a8e8f",
  red = "#ffb3b4",
  baby_pink = lighten("#ffb3b4", 10),
  pink = "#d8c3b0",
  line = "#9a8e8f",
  green = "#f0ffcc",
  vibrant_green = lighten("#f0ffcc", 10),
  blue = "#cebdff",
  nord_blue = lighten("#cebdff", 10),
  yellow = "#ffffff",
  sun = lighten("#ffffff", 10),
  purple = "#d8c3b0",
  dark_purple = lighten("#d8c3b0", -10),
  teal = "#4e4446",
  orange = "#ffb3b4",
  cyan = "#ffffff",
  statusline_bg = lighten("#151313", 6),
  pmenu_bg = "#4e4446",
  folder_bg = lighten("#dac0c4", 0),
  lightbg = lighten("#151313", 10),
}

M.base_16 = {
  base00 = "#151313",
  base01 = lighten("#4e4446", 0),
  base02 = lighten("#4e4446", 3),
  base03 = lighten("#9a8e8f", 0),
  base04 = lighten("#d1c3c4", 0),
  base05 = "#e7e1e1",
  base06 = lighten("#e7e1e1", 0),
  base07 = "#151313",
  base08 = "#ffb3b4",
  base09 = "#ffffff",
  base0A = "#cebdff",
  base0B = "#f0ffcc",
  base0C = "#ffffff",
  base0D = lighten("#cebdff", 20),
  base0E = "#d8c3b0",
  base0F = "#e7e1e1",
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
      fg = "#d8c3b0",
    },
  },
  treesitter = {
    ["@comment"] = {
      fg = M.base_16.base03,
    },
    ["@string"] = {
      fg = "#d8c3b0",
    },
  },
}

return M
