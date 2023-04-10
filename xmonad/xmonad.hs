-- Core
import XMonad                                  hiding ( (|||) )
import System.Exit                             ( exitSuccess )
import System.IO                               ( hPutStrLn )
import qualified XMonad.StackSet               as W
import Graphics.X11.ExtraTypes.XF86
-- Data
import Data.Maybe                              ( isJust )
import Data.Monoid
import Data.Tree
import qualified Data.Map                      as M
-- Actions
import XMonad.Actions.CopyWindow               ( copyToAll, kill1, killAllOtherCopies )
import XMonad.Actions.CycleWS                  ( WSType(..), nextScreen, prevScreen )
import XMonad.Actions.FloatKeys
import XMonad.Actions.FloatSnap
import XMonad.Actions.MouseResize
import XMonad.Actions.RotSlaves                ( rotAllDown, rotSlavesDown )
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WithAll                  ( sinkAll )
-- Hooks
import XMonad.ManageHook
import XMonad.Hooks.ManageDocks                ( ToggleStruts(..), avoidStruts, manageDocks, docks )
import XMonad.Hooks.DynamicLog                 ( PP(..), dynamicLogWithPP, shorten, wrap, xmobarColor, xmobarPP )
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageHelpers              ( doCenterFloat, doFullFloat, isFullscreen )
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
-- Layouts
import XMonad.Layout.ThreeColumns
import XMonad.Layout.GridVariants              ( Grid(Grid) )
import XMonad.Layout.Tabbed
import XMonad.Layout.Magnifier                 as Mag
import XMonad.Layout.CenteredMaster
import XMonad.Layout.Accordion
-- Layouts Modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows              ( limitWindows )
import XMonad.Layout.MultiToggle               ( (??), EOT(EOT), mkToggle, single )
import XMonad.Layout.MultiToggle.Instances     ( StdTransformers( MIRROR, NBFULL, NOBORDERS) )
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed                   ( Rename(Replace), renamed )
import XMonad.Layout.ResizableTile
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.IfMax
import XMonad.Layout.WindowArranger            ( WindowArrangerMsg(..), windowArrange )
import XMonad.Layout.WindowNavigation
import XMonad.Layout.LayoutCombinators         (JumpToLayout(..), (|||))
import qualified XMonad.Layout.MultiToggle     as MT ( Toggle(..) )
import qualified XMonad.Layout.ToggleLayouts   as T ( ToggleLayout(Toggle), toggleLayouts )
-- Utilities
import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor
import XMonad.Util.EZConfig
import XMonad.Util.Font
import XMonad.Util.Run
import XMonad.Util.NamedScratchpad

-- StartUps
theStartupHook :: X ()
theStartupHook = do
  setWMName "LG3D"
  spawnOnce "picom &"
  spawnOnce "dunst &"
  spawnOnce "nitrogen --restore &"
  spawnOnce "xset -b &"
  spawnOnce "xsetroot -cursor_name left_ptr &"
  spawnOnce "/usr/libexec/polkit-gnome-authentication-agent-1 &"

-- Layouts
theSpacing ::
  Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
theSpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

theSpacing' :: -- Single window with no gaps
  Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
theSpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

tabSpacing :: Integer -> Integer -> l a -> ModifiedLayout Spacing l a
tabSpacing i j = spacingRaw False (Border i i i i) True (Border j j j j) True

-- 侀 恵 舘 ﱚ ﱢ 頻 984640
tallWindows =
  renamed [Replace "<fc=#c099ff,#2f334d>\60360 </fc>"]
  $ limitWindows 6
  $ theSpacing 12
  $ ResizableTall 1 (3 / 100) (1 / 2) []
threeColumns =
  renamed [Replace "<fc=#ff966c,#2f334d>\988294 </fc>"]
  $ limitWindows 6
  $ theSpacing 12
  $ ThreeColMid 1 (3 / 100) (3 / 7)
tabbedWindows =
  renamed [Replace "<fc=#4fd6be,#2f334d>\989321 </fc>"]
  -- $ noBorders
  $ tabSpacing 24 0
  $ tabbedBottom shrinkText tabConfig
tabConfig =
  def
    { fontName            = "xft:Lilex Nerd Font:bold:size=13"
    , activeColor         = "#2f334d"
    , activeBorderColor   = "#2f334d"
    , activeTextColor     = "#c099ff"
    , inactiveColor       = "#222436"
    , inactiveBorderColor = "#222436"
    , inactiveTextColor   = "#3b4261"
    }
wideAccordion  =
  renamed [Replace "<fc=#ffc777,#2f334d>\60280 </fc>"]
  $ limitWindows 10
  $ tabSpacing 20 0
  $ Mirror Accordion
windowsGrids =
  renamed [Replace "<fc=#b8db87,#2f334d>\987610 </fc>"] -- \61449
  $ limitWindows 6
  $ theSpacing 12
  $ mkToggle (single MIRROR)
  $ Grid (4 / 3)
singleWindow =
  renamed [Replace "<fc=#fca7ea,#2f334d>\60236 </fc>"]
  $ noBorders
  $ limitWindows 10
  $ theSpacing 12 Full

toggleFloat w = windows ( \s -> if M.member w (W.floating s)
            then W.sink w s
            else W.float w (W.RationalRect (1 / 3) (1 / 4) (1 / 2) (1 / 2)) s )

theLayoutHook =
  avoidStruts
  -- $ magnifierOff
    $ smartBorders
    $ mouseResize
    $ windowArrange
    $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) theLayout
  where
    theLayout =
      tallWindows
        ||| threeColumns
        ||| tabbedWindows
        ||| wideAccordion
        ||| windowsGrids
        ||| singleWindow

-- Workspaces
theWorkspaces :: [String]
theWorkspaces =
  clickable
      [ "\58923 "
      , "\984479 "
      , "\62601 "
      , "\59258 "
      , "\61485 "
      , "\61441 "
      -- , "\984505 "
      -- , "<fc=#ffc777,#2f334d>\59258 </fc>"
      ]
  where
    clickable l =
      [ "<action=xdotool key alt+" ++ show i ++ "> " ++ ws ++ "</action>"
        | (i, ws) <- zip [1 .. 9] l
      ]

-- Icons for workspace modes.
currentWorkspace :: String -> String
currentWorkspace _ = "<fc=#0db9d7,#2f334d> \61842 </fc>"

visibleWorkspace :: String -> String
visibleWorkspace _ = "<fc=#e26a75,#2f334d> \61708 </fc>"

hiddenNWinWspace :: String -> String
hiddenNWinWspace _ = "<fc=#394b70,#2f334d> \61708 </fc>"

hiddenWorkspaces :: String -> String
hiddenWorkspaces _ = "<fc=#485a86,#2f334d> \61708 </fc>"

urgentWorkspaces :: String -> String
urgentWorkspaces _ = "<fc=#c53b53,#2f334d> \61546 </fc>"

-- Xmobar
theLogHook xmobar0 = -- xmobar1
  xmobarPP
    { ppOutput          = hPutStrLn xmobar0 -- x >> hPutStrLn xmobar1 x
    , ppSep             = "<fc=#c8d3f5,#2f334d> · </fc>"
    , ppCurrent         = xmobarColor "#0db9d7" "#2f334d" . wrap "" "" . xmobarBorder "Bottom" "#0db9d7" 3
    , ppVisible         = xmobarColor "#e26a75" "#2f334d" . wrap "" ""
    , ppHiddenNoWindows = xmobarColor "#394b70" "#2f334d" . wrap "" ""
    , ppHidden          = xmobarColor "#485a86" "#2f334d" . wrap "" ""
    , ppUrgent          = xmobarColor "#c53b53" "#2f334d" . wrap "" ""
    , ppTitle           = xmobarColor "#c8d3f5" "#2f334d" . shorten 50
    , ppOrder           = \(ws : l : t : ex) -> [l] ++ [ws] ++ ex
    , ppExtras          = [windowCount]
    }
  where
    nonNSP = WSIs (return (\ws -> W.tag ws /= "nsp"))
    nonEmptyNonNSP = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))

-- Window Count
windowCount :: X (Maybe String)
windowCount =
  gets $
    Just
      . show
      . length
      . W.integrate'
      . W.stack
      . W.workspace
      . W.current
      . windowset

-- ScratchPads
theScratchPads :: [NamedScratchpad]
theScratchPads =
  [ NS "dir" spawnDir findDir manageDir
  , NS "tel" spawnTel findTel manageTel
  , NS "msg" spawnMsg findMsg manageMsg
  , NS "blu" spawnBlu findBlu manageBlu
  ]
  where
    spawnDir  = "nautilus"
    findDir   = className =? "org.gnome.Nautilus"
    manageDir = defaultFloating
    spawnTel  = "TelegramDesktop"
    findTel   = className =? "TelegramDesktop"
    manageTel = defaultFloating
    spawnMsg  = "caprine"
    findMsg   = className =? "Caprine"
    manageMsg = defaultFloating
    spawnBlu  = "blueman-manager"
    findBlu   = className =? "Blueman-manager"
    manageBlu = defaultFloating

-- Window Rules
theManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
theManageHook =
  composeAll
    [ className =? "Arandr"             --> doCenterFloat
    , className =? "Nitrogen"           --> doCenterFloat
    , className =? "Alacritty"          --> doCenterFloat
    , className =? "Dconf-editor"       --> doCenterFloat
    , className =? "Lxappearance"       --> doCenterFloat
    , className =? "org.gnome.Nautilus" --> doCenterFloat
    , className =? "Blueman-manager"    --> doCenterFloat
    , className =? "Gcolor3"            --> doCenterFloat
    , className =? "Typora"             --> doCenterFloat
    , className =? "Gnome-calculator"   --> doCenterFloat
    , className =? "Gnome-screenshot"   --> doCenterFloat
    , className =? "File-roller"        --> doCenterFloat
    , className =? "TelegramDesktop"    --> doCenterFloat
    , className =? "Caprine"            --> doCenterFloat
    , title     =? "Picture-in-picture" --> doCenterFloat
    , title     =? "Picture-in-Picture" --> doCenterFloat
    , title     =? "Select Folder"      --> doCenterFloat
    , title     =? "Save File"          --> doCenterFloat
    , title     =? "Media viewer"       --> doCenterFloat
    , title     =? "Quit GIMP"          --> doCenterFloat
    , className =? "spotify"            --> doShift (theWorkspaces !! 2)
    , className =? "brave-browser"      --> doShift (theWorkspaces !! 2)
    , className =? "firefox"            --> doShift (theWorkspaces !! 2)
    , className =? "figma-linux"        --> doShift (theWorkspaces !! 1)

    ]

-- Keybindings
theAditionalKeys :: [(String, X ())]
theAditionalKeys =
  [ ("C-S-q",      io exitSuccess)
  , ("C-S-w",      spawn "killall xmobar; xmonad --recompile; xmonad --restart")
  , ("C-q",        kill1)
  , ("C-S-n",      nextScreen)
  , ("C-S-p",      prevScreen)
  , ("C-;",        windows W.focusDown)
  , ("C-'",        windows W.focusUp)
  , ("C-S-;",      windows W.swapDown)
  , ("C-S-'",      windows W.swapUp)
  , ("C-S-m",      windows $ W.swapMaster . W.focusDown)
  , ("C-S-h",      sendMessage Shrink)
  , ("C-S-l",      sendMessage Expand)
  , ("C-S-j",      sendMessage MirrorShrink)
  , ("C-S-k",      sendMessage MirrorExpand)
  , ("C-/",        sendMessage NextLayout)        -- Switch to next layout
  , ("C-S-/",      sendMessage FirstLayout)
  , ("C-1",        sendMessage $ JumpToLayout "<fc=#c099ff,#2f334d>\60360 </fc>")
  , ("C-2",        sendMessage $ JumpToLayout "<fc=#ff966c,#2f334d>\988294 </fc>")
  , ("C-3",        sendMessage $ JumpToLayout "<fc=#4fd6be,#2f334d>\989321 </fc>")
  , ("C-4",        sendMessage $ JumpToLayout "<fc=#ffc777,#2f334d>\60280 </fc>")
  , ("C-6",        sendMessage $ JumpToLayout "<fc=#b8db87,#2f334d>\987610 </fc>")
  , ("C-5",        sendMessage $ JumpToLayout "<fc=#fca7ea,#2f334d>\60236 </fc>")
  , ("C-b",        sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
  , ("C-S-b",      sendMessage $ MT.Toggle NOBORDERS)
  , ("C-S-f",      withFocused toggleFloat)
  , ("C-S-s",      sinkAll) -- withFocused $ windows . W.sink
  , ("M-C-m",      sendMessage Toggle)
  , ("M-C-=",      sendMessage MagnifyMore)
  , ("M-C--",      sendMessage MagnifyLess)
  , ("C-S-c",      windows copyToAll)
  , ("C-S-d",      killAllOtherCopies)
  , ("M-C-h",      withFocused (keysMoveWindow (-50, 0))) -- Move Floats
  , ("M-C-k",      withFocused (keysMoveWindow (0, -50)))
  , ("M-C-j",      withFocused (keysMoveWindow (0, 50)))
  , ("M-C-l",      withFocused (keysMoveWindow (50, 0)))
  , ("C-S-=",      withFocused (keysResizeWindow (10, 10) (1, 1))) -- Resize Floats
  , ("C-S--",      withFocused (keysResizeWindow (-10, -10) (1, 1)))
  , ("M-C-y",      withFocused $ snapMove L Nothing) -- Snap Floats
  , ("M-C-i",      withFocused $ snapMove U Nothing)
  , ("M-C-u",      withFocused $ snapMove D Nothing)
  , ("M-C-o",      withFocused $ snapMove R Nothing)
  , ("M-S-y",      withFocused (keysResizeWindow (10, 0) (1, 1)))
  , ("M-S-i",      withFocused (keysResizeWindow (0, 10) (1, 1)))
  , ("M-S-u",      withFocused (keysResizeWindow (0, -10) (1, 1)))
  , ("M-S-o",      withFocused (keysResizeWindow (-10, 0) (1, 1)))
    -- Apps
  , ("M-<Return>", spawn "kitty tmux")
  , ("C-<Space>",  spawn "rofi -show drun")
  , ("M-a",        spawn "brave-browser")
  , ("M-s",        spawn "spotify")
  , ("M-<F7>",     spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
  , ("M-<F8>",     spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
  , ("M-<F9>",     spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
  , ("M-f",        namedScratchpadAction theScratchPads "frf")
  , ("M-g",        namedScratchpadAction theScratchPads "dir")
  , ("M-t",        namedScratchpadAction theScratchPads "tel")
  , ("M-c",        namedScratchpadAction theScratchPads "msg")
  , ("M-z",        namedScratchpadAction theScratchPads "blu")
    -- Utilities
  , ("M-p",        spawn "xset r rate 300 50")
  , ("C-0",        spawn "setxkbmap -layout gb -variant extd")
  , ("C-9",        spawn "setxkbmap -layout gb")
  , ("C-8",        spawn "setxkbmap -layout latam")
  , ("M-<F10>",    spawn "amixer set Master toggle")
  , ("M-<F11>",    spawn "amixer set Master 5%-")
  , ("M-<F12>",    spawn "amixer set Master 5%+")
  , ("M-<F2>",     spawn "brightnessctl set +1%")
  , ("M-<F1>",     spawn "brightnessctl set 1%-")
  ]

-- Main Function
main :: IO ()
main = do
  xmproc0 <- spawnPipe "xmobar -x 0 ~/.xmonad/xmobar/xmobar0.hs"
  -- xmproc1 <- spawnPipe "xmobar -x 1 ~/.xmonad/xmobar/xmobar1.hs"
  -- xmproc2 <- spawnPipe "xmobar -x 1 ~/.xmonad/xmobar/xmobar2.hs"
  xmonad
    . ewmh
    . ewmhFullscreen
    . docks
    $ def
      { focusFollowsMouse  = False
      , modMask            = mod1Mask
      , terminal           = "kitty tmux"
      , manageHook         = theManageHook
      , startupHook        = theStartupHook
      , layoutHook         = theLayoutHook
      , workspaces         = theWorkspaces
      , normalBorderColor  = "#394b70"
      , focusedBorderColor = "#0db9d7"
      , borderWidth        = 3
      , logHook            = dynamicLogWithPP (theLogHook xmproc0) >> updatePointer (0.5,0.5) (0.5, 0.5)
      } `additionalKeysP` theAditionalKeys
