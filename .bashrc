# DON'T CHANGE THIS FILE

# You can define your custom configuration by adding
# files in ~/.config/bashrc
# or by creating a folder ~/.config/zshrc/custom
# with copies of files from ~/.config/zshrc
# -----------------------------------------------------

# Aliasses
alias niv="npm install vite --save-dev"

for f in ~/.config/bashrc/*; do
  if [ ! -d $f ]; then
    c=$(echo $f | sed -e "s=.config/bashrc=.config/bashrc/custom=")
    [[ -f $c ]] && source $c || source $f
  fi
done


export PATH="$PATH:/home/Zakkye/.foundry/bin"
