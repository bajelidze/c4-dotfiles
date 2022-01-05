setenv -g tmuxdwm_version 0.1.0
setenv -g killlast 1 # Toggle killing last pane
setenv -g mfact 50   # Main pane area factor

set -g command-alias[101] newpanecurdir='run-shell "dwm.tmux newpanecurdir"'
set -g command-alias[102] killpane='run-shell "dwm.tmux killpane"'
set -g command-alias[103] nextpane='run-shell "dwm.tmux nextpane"'
set -g command-alias[104] prevpane='run-shell "dwm.tmux prevpane"'
set -g command-alias[105] rotateccw='run-shell "dwm.tmux rotateccw"'
set -g command-alias[106] rotatecw='run-shell "dwm.tmux rotatecw"'
set -g command-alias[107] promote='run-shell "dwm.tmux promote"'
set -g command-alias[108] layouttile='run-shell "dwm.tmux layouttile"'
set -g command-alias[109] float='run-shell "dwm.tmux float"'
set -g command-alias[110] incmfact='run-shell "dwm.tmux incmfact"'
set -g command-alias[111] decmfact='run-shell "dwm.tmux decmfact"'

set-hook -g pane-exited 'run-shell "dwm.tmux layouttile"'

bind -n M-Enter newpanecurdir
bind -n M-q killpane
bind -n M-j nextpane
bind -n M-k prevpane
bind -n M-K rotateccw
bind -n M-J rotatecw
bind -n M-s promote
# bind -n M-f layouttile
bind -n M-f float
bind -n M-h decmfact
bind -n M-l incmfact
