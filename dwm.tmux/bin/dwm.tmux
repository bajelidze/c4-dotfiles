#!/bin/bash

declare window_panes killlast mfact
declare default_mfact=50

newpanecurdir() {
  last_pane=$((window_panes))
  tmux \
    split-window -t :.$last_pane -c "#{pane_current_path}"\; \
    select-layout main-vertical\; \
    resize-pane -t :.1 -x "$mfact%"
}

killpane() {
  if (( window_panes > 1 )); then
    if (( window_panes == 2 )); then 
      mfact=$default_mfact
      tmux setenv mfact "$mfact"
    fi
    tmux kill-pane -t :.\; \
         select-layout main-vertical\; \
         resize-pane -t :.1 -x "$mfact%"
  else
    if (( killlast != 0 )); then
      tmux kill-window
    fi
  fi
}

nextpane() {
  tmux select-pane -t :.+
}

prevpane() {
  tmux select-pane -t :.-
}

rotateccw() {
  tmux swap-pane -s :. -t :.-\; select-pane -t :.-
}

rotatecw() {
  tmux swap-pane -s :. -t :.+\; select-pane -t :.+
}

promote() {
  tmux swap-pane -s :. -t :.1\; select-pane -t :.1
}

layouttile() {
  tmux select-layout main-vertical\; resize-pane -t :.1 -x "$mfact%"
}

float() {
  tmux resize-pane -Z
}

incmfact() {
  fact=$((mfact + 5))
  if (( fact <= 95 )); then
    tmux \
      setenv mfact $fact\; \
      resize-pane -t :.1 -x "$fact%"
  fi
}

decmfact() {
  fact=$((mfact - 5))
  if (( fact >= 5 )); then
    tmux \
      setenv mfact $fact\; \
      resize-pane -t :.1 -x "$fact%"
  fi
}

if (( $# < 1 )); then
  echo "dwm.tmux.sh [command]"
  exit
fi

command=$1
read -r window_panes killlast mfact <<< "$(tmux display -p "#{window_panes} #{killlast} #{mfact}")"

case $command in
  newpanecurdir) newpanecurdir;;
  killpane) killpane;;
  nextpane) nextpane;;
  prevpane) prevpane;;
  rotateccw) rotateccw;;
  rotatecw) rotatecw;;
  promote) promote;;
  layouttile) layouttile;;
  float) float;;
  incmfact) incmfact;;
  decmfact) decmfact;;
  *) echo "unknown command"; exit 1;;
esac
