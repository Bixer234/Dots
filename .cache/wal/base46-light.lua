local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = "#e5e2e1",
  black = "#141313",
  darker_black = lighten("#141313", -3),
  black2 = lighten("#141313", 6),
  one_bg = lighten("#141313", 10),
  one_bg2 = lighten("#141313", 16),
  one_bg3 = lighten("#141313", 22),
  grey = "#47464b",
  grey_fg = lighten("#47464b", -10),
  grey_fg2 = lighten("#47464b", -20),
  light_grey = "#929095",
  red = "#ffb2b9",
  baby_pink = lighten("#ffb2b9", 10),
  pink = "#cdc4c7",
  line = "#929095",
  green = "#e8ffea",
  vibrant_green = lighten("#e8ffea", 10),
  blue = "#bdc2ff",
  nord_blue = lighten("#bdc2ff", 10),
  yellow = "#ffffff",
  sun = lighten("#ffffff", 10),
  purple = "#cdc4c7",
  dark_purple = lighten("#cdc4c7", -10),
  teal = "#474648",
  orange = "#ffb2b9",
  cyan = "#ffffff",
  statusline_bg = lighten("#141313", 6),
  pmenu_bg = "#47464b",
  folder_bg = lighten("#c8c5ca", 0),
  lightbg = lighten("#141313", 10),
}

M.base_16 = {
  base00 = "#141313",
  base01 = lighten("#47464b", 0),
  base02 = lighten("#47464b", 3),
  base03 = lighten("#929095", 0),
  base04 = lighten("#c8c5cb", 0),
  base05 = "#e5e2e1",
  base06 = lighten("#e5e2e1", 0),
  base07 = "#141313",
  base08 = "#ffb2b9",
  base09 = "#ffffff",
  base0A = "#bdc2ff",
  base0B = "#e8ffea",
  base0C = "#ffffff",
  base0D = lighten("#bdc2ff", 20),
  base0E = "#cdc4c7",
  base0F = "#e5e2e1",
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
      fg = "#cdc4c7",
    },
  },
  treesitter = {
    ["@comment"] = {
      fg = M.base_16.base03,
    },
    ["@string"] = {
      fg = "#cdc4c7",
    },
  },
}

return M
