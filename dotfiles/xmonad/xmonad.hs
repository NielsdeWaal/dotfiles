-- Base
import XMonad
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.MouseResize

-- Hooks
import XMonad.Actions.CycleWS (nextScreen, prevScreen)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

-- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

-- Layout Modifier
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))

-- Utils
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce -- Import spawnOnce

myFont :: String
myFont = "xft:Mononoki Nerd Font:bold:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask -- Set Mod key to win/super
  
myTerminal :: String
myTerminal = "kitty"
  
myEditor :: String
myEditor = "emacsclient -c -a emacs" -- Set emacs as default editor
  
myNormColor :: String
myNormColor   = "#292d3e"  -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#bbc5ff"  -- Border color of focused windows

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
  
myBorderWidth :: Dimension
myBorderWidth = 2          -- Sets border width for windows
  
myStartupHook :: X ()
myStartupHook = do           
    spawnOnce "nitrogen --restore &"           
    spawnOnce "picom --backend xrender &"           
    -- spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 18 &"           
    spawnOnce "/usr/bin/emacs --daemon &"           -- spawnOnce "kak -d -s mysession &"           
    spawnOnce "setxkbmap -option caps:escape"
    setWMName "LG3D"
  
xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]
  
myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape)
               -- $ ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
               $ ["www", "vid", "sys", "chat", "dev", "6", "7", "8", "9"]
  where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ "<fn=2>" ++ ws ++ "</fn>" ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

-- Layouts
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "tall"]
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
floats   = renamed [Replace "floats"]
           $ limitWindows 20 simplestFloat
magnify  = renamed [Replace "magnify"]
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ limitWindows 20 Full
grid     = renamed [Replace "grid"]
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
  
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               -- I've commented out the layouts I don't use.
               myDefaultLayout =     tall
                                 ||| magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| grid
                                 -- ||| spirals
                                 -- ||| threeCol
                                 -- ||| threeRow

-- Keybindings
myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --recompile")      -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")        -- Restarts xmonad
        , ("M-S-q", spawn "")        -- Restarts xmonad
        , ("M-S-e", io exitSuccess)                  -- Quits xmonad
        , ("M-p", spawn "rofi -show run")
        , ("M-S-p", spawn "dmenu_run")
        
        , ("M-<Return>", spawn myTerminal)                  -- Spawn the terminal

        , ("M-<Tab>", sendMessage NextLayout)               -- Switch to next layout
        , ("M-S-j", windows W.swapDown)                     -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)                       -- Swap focused window with prev window
        , ("M-h", sendMessage Shrink)                       -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                       -- Expand horiz window width
        , ("M-C-j", sendMessage MirrorShrink)               -- Shrink vert window width
        , ("M-C-k", sendMessage MirrorExpand)               -- Exoand vert window width

        
        -- , ("M-.", nextScreen)  -- Switch focus to next monitor
        -- , ("M-,", prevScreen)  -- Switch focus to prev monitor

        -- Emacs
        , ("C-e e", spawn "emacs")
        , ("C-e m", spawn "emacsclient -c -a 'emacs' --eval '(mu4e)'")
        -- Other applications
        , ("C-o p", spawn "pavucontrol")
        , ("C-o s", spawn "deepin-screenshot")
        , ("C-o z", spawn "zathura")
        , ("C-o c", spawn "chatterino")
        ]
        
-- Loghook
myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1.0

main :: IO ()
main = do
    xmproc0 <- spawnPipe "xmobar -x 0 /home/niels/.config/xmobar/xmobarrc0"
    xmonad $ ewmh def
        { manageHook = ( isFullscreen --> doFullFloat ) <+> manageDocks
        -- Run xmonad commands from command line with "xmonadctl command". Commands include:
        -- shrink, expand, next-layout, default-layout, restart-wm, xterm, kill, refresh, run,
        -- focus-up, focus-down, swap-up, swap-down, swap-master, sink, quit-wm. You can run
        -- "xmonadctl 0" to generate full list of commands written to ~/.xsession-errors.
        , handleEventHook    = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> docksEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP
                        -- { ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x  >> hPutStrLn xmproc2 x
                        { ppOutput = \x -> hPutStrLn xmproc0 x
                        , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#b3afc2" ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#ffffff" "" . shorten 60     -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> | </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
        } `additionalKeysP` myKeys
