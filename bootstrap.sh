#!/usr/bin/env bash
# shellcheck disable=SC2016,SC2034,SC1004,SC1091

make_home_symlink() {
  local file_name=$1
  ln -s "$SCRIPT_DIR/$file_name" "$HOME/$file_name"
}

make_bin() {
  mkdir "$BIN_DIR"
  echo 'export PATH='"$BIN_DIR"':$PATH' >> "$HOME/.bash_profile"
  echo "export EDITOR=nvim" >> .bash_profile
  source "$HOME/.bash_profile"
}

# efm-langserver is needed for the shellcheck plugin for nvim
install_efm() {
  local name="efm-langserver_v0.0.38_linux_amd64"
  wget -q "https://github.com/mattn/efm-langserver/releases/download/v0.0.38/$name.tar.gz"
  tar xf "$name.tar.gz"
  rm "$name.tar.gz"
  mv "$name/efm-langserver" "$BIN_DIR"
  rm -rf "$name"
}

install_lf() {
  local name="lf-linux-amd64.tar.gz"
  wget -q "https://github.com/gokcehan/lf/releases/download/r26/$name"
  tar xf "$name"
  rm "$name"
  mv "lf" "$BIN_DIR"
}

install_from_github() {
  local repository=$1; local name=$2; local new_name=$3
  [[ -z "$new_name" ]] && new_name="$name"

  curl -s "https://api.github.com/repos/$repository/releases/latest" \
    | jq -r ".assets[] | select(.name==\"$name\") | .browser_download_url" \
    | wget -qi -
  chmod +x "$name"
  mv "$name" "$BIN_DIR/$new_name"
}

set_git_aliases() {
  if [[ -f "$HOME/.gitconfig" ]]; then
    cat .git_aliases >> .gitconfig
  else
    cat .git_aliases > .gitconfig
  fi
}

install_nvim_plugins() {
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim --headless +PlugInstall +qall
}

install_dwm_tmux() {
  wget 'https://github.com/nelsonenzo/tmux-appimage/releases/download/3.2a/tmux.appimage' -O "$HOME/bin/tmux"
  chmod +x "$HOME/bin/tmux"

  mv dwm.tmux/bin/dwm.tmux "$HOME/bin"
  mv dwm.tmux/lib/dwm.tmux "$HOME/.local/lib"
}

create_local() {
  mkdir -p "$HOME/.local/bin"
  mkdir -p "$HOME/.local/lib"
  mkdir "$HOME/.config"
}

main() {
  SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
  BIN_DIR="$HOME/bin"

  dotfiles=(
    .tmux.conf
    .bash_aliases
    .config/nvim
    .config/lf
  )

  create_local

  for dotfile in "${dotfiles[@]}"; do
    make_home_symlink "$dotfile"
  done

  make_bin

  for bin in bin/*; do
    mv "$bin" "$BIN_DIR"
  done

  # set_git_aliases
  install_dwm_tmux
  install_efm
  install_lf
  install_from_github neovim/neovim nvim.appimage nvim
  install_nvim_plugins
}

main
