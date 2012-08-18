-- Xmonad configuration file
-- after changing this file, run "xmonad --recompile" to check for errors
-- to load the changes, press mod-q. mod is Alt by default

import XMonad


-- Expand on the default config, with few cusom values
-- Use urxvt as the default terminal
-- Use light grey (brushed metal color) as normal border
-- Use orange as selected border, red is too noticeable
main = xmonad $ defaultConfig
  { borderWidth        = 2
  , terminal           = "urxvt"
  , normalBorderColor  = "#cccccc"
  , focusedBorderColor = "#cd8b00" }
