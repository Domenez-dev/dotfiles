# DON'T CHANGE THIS FILE

# You can define your custom configuration by adding
# files in ~/.config/bashrc
# or by creating a folder ~/.config/zshrc/custom
# with copies of files from ~/.config/zshrc
# -----------------------------------------------------

# Aliasses
alias niv="npm install vite --save-dev"

for f in ~/.config/bashrc/*; do
  if [ ! -d "$f" ]; then
    # Use bash parameter expansion for string replacement (faster than sed/subshell)
    c="${f/.config\/bashrc/.config\/bashrc\/custom}"
    [[ -f "$c" ]] && source "$c" || source "$f"
  fi
done

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion
complete -cf sudo

export PATH="$PATH:/home/Zakkye/.foundry/bin"
export WINEPREFIX="/home/Zakkye/Games/jc141/wine-prefix/" 
