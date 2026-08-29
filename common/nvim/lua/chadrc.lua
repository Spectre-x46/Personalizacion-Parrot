local M = {}

M.ui = {
  theme = "onedark",
  theme_toggle = { "onedark", "one_light" },
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.plugins = "custom.plugins"

return M
