local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = "#e6e2de",
  black = "#141311",
  darker_black = lighten("#141311", -3),
  black2 = lighten("#141311", 6),
  one_bg = lighten("#141311", 10),
  one_bg2 = lighten("#141311", 16),
  one_bg3 = lighten("#141311", 22),
  grey = "#49473d",
  grey_fg = lighten("#49473d", -10),
  grey_fg2 = lighten("#49473d", -20),
  light_grey = "#959085",
  red = "#ffb595",
  baby_pink = lighten("#ffb595", 10),
  pink = "#bfcab5",
  line = "#959085",
  green = "#f0ffcc",
  vibrant_green = lighten("#f0ffcc", 10),
  blue = "#cebdff",
  nord_blue = lighten("#cebdff", 10),
  yellow = "#ffffff",
  sun = lighten("#ffffff", 10),
  purple = "#bfcab5",
  dark_purple = lighten("#bfcab5", -10),
  teal = "#4a473c",
  orange = "#ffb595",
  cyan = "#ffffff",
  statusline_bg = lighten("#141311", 6),
  pmenu_bg = "#49473d",
  folder_bg = lighten("#cfc6a9", 0),
  lightbg = lighten("#141311", 10),
}

M.base_16 = {
  base00 = "#141311",
  base01 = lighten("#49473d", 0),
  base02 = lighten("#49473d", 3),
  base03 = lighten("#959085", 0),
  base04 = lighten("#cbc6ba", 0),
  base05 = "#e6e2de",
  base06 = lighten("#e6e2de", 0),
  base07 = "#141311",
  base08 = "#ffb595",
  base09 = "#ffffff",
  base0A = "#cebdff",
  base0B = "#f0ffcc",
  base0C = "#ffffff",
  base0D = lighten("#cebdff", 20),
  base0E = "#bfcab5",
  base0F = "#e6e2de",
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
      fg = "#bfcab5",
    },
  },
  treesitter = {
    ["@comment"] = {
      fg = M.base_16.base03,
    },
    ["@string"] = {
      fg = "#bfcab5",
    },
  },
}

return M
