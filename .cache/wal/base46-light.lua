local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = "#e6e2e0",
  black = "#141313",
  darker_black = lighten("#141313", -3),
  black2 = lighten("#141313", 6),
  one_bg = lighten("#141313", 10),
  one_bg2 = lighten("#141313", 16),
  one_bg3 = lighten("#141313", 22),
  grey = "#4b463f",
  grey_fg = lighten("#4b463f", -10),
  grey_fg2 = lighten("#4b463f", -20),
  light_grey = "#969087",
  red = "#ffb595",
  baby_pink = lighten("#ffb595", 10),
  pink = "#c7c7c1",
  line = "#969087",
  green = "#f0ffcc",
  vibrant_green = lighten("#f0ffcc", 10),
  blue = "#cebdff",
  nord_blue = lighten("#cebdff", 10),
  yellow = "#ffffff",
  sun = lighten("#ffffff", 10),
  purple = "#c7c7c1",
  dark_purple = lighten("#c7c7c1", -10),
  teal = "#494644",
  orange = "#ffb595",
  cyan = "#ffffff",
  statusline_bg = lighten("#141313", 6),
  pmenu_bg = "#4b463f",
  folder_bg = lighten("#ccc5c0", 0),
  lightbg = lighten("#141313", 10),
}

M.base_16 = {
  base00 = "#141313",
  base01 = lighten("#4b463f", 0),
  base02 = lighten("#4b463f", 3),
  base03 = lighten("#969087", 0),
  base04 = lighten("#cdc5bc", 0),
  base05 = "#e6e2e0",
  base06 = lighten("#e6e2e0", 0),
  base07 = "#141313",
  base08 = "#ffb595",
  base09 = "#ffffff",
  base0A = "#cebdff",
  base0B = "#f0ffcc",
  base0C = "#ffffff",
  base0D = lighten("#cebdff", 20),
  base0E = "#c7c7c1",
  base0F = "#e6e2e0",
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
      fg = "#c7c7c1",
    },
  },
  treesitter = {
    ["@comment"] = {
      fg = M.base_16.base03,
    },
    ["@string"] = {
      fg = "#c7c7c1",
    },
  },
}

return M
