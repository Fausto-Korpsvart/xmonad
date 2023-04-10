-- http://projects.haskell.org/xmobar/
-- plugins: http://projects.haskell.org/xmobar/#system-monitor-plugins.

Config { font     = "xft:Lilex Nerd Font:pixelsize=17:antialias=true:hinting=true"
       , additionalFonts = ["xft:Symbols Nerd Font:pixelsize=13:antialias=true" ]
       , bgColor  = "#222436"
       , fgColor  = "#c8d3f5"
       , position = TopSize C 100 35
       , alpha    = 255
       , sepChar  =  "%"
       , alignSep = "}{"
       , lowerOnStart = True
       , iconRoot = "/home/korpsvart/.xmonad/xmobar/icons/"
       , template = "\
                     \ <fc=#0db9d7,#2f334d> %date% </fc>\
                     \ <fc=#c3e88d,#2f334d> 󱩑 %brightness% </fc>\
                     \ <fc=#c099ff,#2f334d> 󰕾 %volumeLevel% </fc>\
                     \ <fc=#4fd6be,#2f334d> %battery% </fc>\
                     \ <fc=#ff9e64,#2f334d> 󰌏 %kbd% </fc>\
                     \}<fc=#65bcff,#2f334d> %UnsafeStdinReader% </fc>{\
                     \ <fc=#ff757f,#2f334d> %multicoretemp% </fc>\
                     \ <fc=#ff966c,#2f334d> %cpufreq%</fc>\
                     \ <fc=#82aaff,#2f334d> %cpu%</fc>\
                     \ <fc=#c099ff,#2f334d> %memory%</fc>\
                     \ <fc=#0db9d7,#2f334d> %dynnetwork%</fc> "

       , commands =
            [ Run UnsafeStdinReader
            , Run Date          "<fc=#ff966c,#2f334d>󰸗 </fc>%a.%d.%b<fc=#ff966c,#2f334d>  </fc>%H:%M" "date" 20
            , Run Weather       "MSLP" ["-t", "<skyCondition><tempC>°C <rh>%"] 30
            , Run Com           "/bin/bash" ["-c", "~/.xmonad/xmobar/scripts/volumeLevel.sh"] "volumeLevel" 10
            , Run Com           "/bin/bash" ["-c", "~/.xmonad/xmobar/scripts/brightness.sh"] "brightness" 10
            , Run Kbd           [( "gb" , "gb"), ("gb(extd)", "gb+"), ("latam" , "es")]
            , Run DiskU         [("/", "<used> <free>"), ("/mnt/iomega", "<used>")] [] 20
            , Run DiskIO        [("/", "<write> <read>"), ("/mnt/iomega", "<total>")] [] 20
            , Run Memory        ["-t", "<usedratio>% 󱦘 "] 20
            , Run MultiCoreTemp ["-t", "<max>°C "] 20
            , Run CpuFreq       ["-t", "<cpu0>GHz  "] 20
            , Run Cpu           ["-t", "<total>% 󰘷 "] 20
            , Run Battery       ["--template" ,"<acstatus>"
                                 ,"--Low"      ,"10"
                                 ,"--High"     ,"90"
                                 ,"--"
                                 ,"-o" ,""
                                 ,"--lows",    "<fc=#e26a75,#2f334d>  </fc><left>%"
                                 ,"--mediums", "<fc=#ff966c,#2f334d>  </fc><left>%"
                                 ,"--highs",   "<fc=#4fd6be,#2f334d>  </fc><left>%"
                                 ,"-O" ,"<fc=#ff966c,#2f334d>  </fc><left>%"
                                 ,"-i" ,"<fc=#4fd6be,#2f334d>  </fc><left>%"
                                 ,"-a" ,"notify-send -u critical 'Plug me in, I am dying 󱓇 !!'"
                                 ,"-A" ,"20"
                                 ] 10
            , Run DynNetwork     [ "--template" , "<tx>kB/s <fc=#ff966c,#2f334d>󰁝 󰁅 </fc><rx>kB/s<fc=#ff966c,#2f334d>󰖩 </fc>"
                                 , "--Low"      , "1000"
                                 , "--High"     , "5000"
                                 ] 30
            ]
       }

-- DISABLED<[[[
-- For DynNetwork: <dev><fc=#ff966c,#2f334d>  </fc>
--  iconRoot = "~/.xmonad/xmobar/icons"
-- , Run Com           "bash" ["-c", "checkupdates | wc -l"] "updates" 10
--, border   = BottomB
--, borderColor =  "#82aaff"
-- , template = "<fc=#0db9d7,#2f334d> %date% </fc> <fc=#82aaff,#2f334d>   %MSLP% </fc> <fc=#4fd6be,#2f334d>%battery%</fc> <fc=#c099ff,#2f334d>  %volumeLevel% </fc> <fc=#ff9e64,#2f334d>  %kbd% </fc> <fc=#7dcfff,#2f334d>  %updates%  </fc>}<fc=#c8d3f5> %XMonadLog% </fc>{<fc=#7dcfff,#2f334d>  %wlp6s0%</fc> <fc=#ff966c,#2f334d> %cpufreq%</fc> <fc=#82aaff,#2f334d> %cpu%</fc> <fc=#c099ff,#2f334d> %memory% </fc> <fc=#ff757f,#2f334d> %multicoretemp% </fc> <fc=#e0af68,#2f334d> %diskio%  </fc> <fc=#0db9d7,#2f334d> %disku%   </fc>"
--, Run Network       "wlp6s0" ["-t","<fc=#ff966c,#2f334d> </fc><tx> <fc=#ff966c,#2f334d> </fc><rx> kB/s <fc=#ff966c,#2f334d> </fc>"] 30]]]>
