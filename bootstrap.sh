#!/usr/bin/env bash
# shellcheck disable=SC2016,SC2034,SC1004,SC1091

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

make_home_symlink() {
  local file_name=$1
  ln -s "$SCRIPT_DIR/$1" "$HOME/$1" &> /dev/null
}

make_bin() {
  mkdir "$HOME/bin"
  echo 'export PATH=$HOME/bin:$PATH' >> "$HOME/.bash_profile"
  source "$HOME/.bash_profile"
}

# efm-langserver is needed for the shellcheck plugin for nvim
install_efm() {
  go install github.com/mattn/efm-langserver@latest
  echo 'export PATH=$HOME/go/bin:$PATH' >> .bash_profile
}

install_from_github() {
  local repository=$1; local name=$2
  curl -s "https://api.github.com/repos/$repository/releases/latest" \
    | jq -r ".assets[] | select(.name==\"$name\") | .browser_download_url" \
    | wget -qi -
  chmod +x "$name"
  mv "$name" "$HOME/bin"
}

set_git_aliases() {
  cat .git_aliases >> .gitconfig
}

install_nvim_plugins() {
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim +PlugInstall +qall
}

dotfiles=(
  .tmux.conf
  .bash_aliases
  .config/nvim
  .config/lf
)

for dotfile in "${dotfiles[@]}"; do
  make_home_symlink "$dotfile"
done

make_bin
set_git_aliases
install_efm
install_from_github neovim/neovim nvim.appimage
install_nvim_plugins
