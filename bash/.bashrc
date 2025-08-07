# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
#
# Use VSCode instead of neovim as your default editor
# export EDITOR="code"
#
# Set a custom prompt with the directory revealed (alternatively use https://starship.rs)
# PS1="\W \[\e]0;\w\a\]$PS1"
#
#

alias cat='bat'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/cleyson/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/home/cleyson/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/cleyson/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/home/cleyson/Downloads/google-cloud-sdk/completion.bash.inc'; fi

PATH=~/.console-ninja/.bin:$PATH