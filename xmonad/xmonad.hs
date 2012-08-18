import XMonad


-- Expand on the default config, with few cusom values
-- Use urxvt as the default terminal

main = xmonad $ defaultConfig
  { borderWidth        = 2
  , terminal           = "urxvt"
  , normalBorderColor  = "#cccccc"
  , focusedBorderColor = "#cd8b00" }
