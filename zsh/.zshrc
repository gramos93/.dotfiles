# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ZSH History properties.
HISTFILE="$HOME/.cache/zsh/.zsh_history"
[ ! -f $HISTFILE ] && mkdir -p "$(dirname $HISTFILE)" && touch "$HISFILE"

HISTSIZE=5000
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Keybindings
bindkey '^[[B' history-search-forward  # Down-arrow
bindkey '^[[A' history-search-backward # Up-arrow
bindkey  "^[[H"   beginning-of-line    # Home
bindkey  "^[[F"   end-of-line          # End
bindkey  "^[[1~"   beginning-of-line    # Home for tmux
bindkey  "^[[4~"   end-of-line          # End for tmux
bindkey '^[[1;5C' emacs-forward-word   # Ctrl-Right
bindkey '^[[1;5D' emacs-backward-word  # Ctrl-left
bindkey '^H' backward-kill-word        # Ctrl-BackSpace
bindkey '5~' kill-word                 # Ctrl-Del
bindkey "^[[3~" delete-char            # Del

# Set Plugin Manager Directory
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"

#Initialize Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add plugins
zinit ice depth=1; zinit light zsh-users/zsh-syntax-highlighting
zinit ice depth=1; zinit light zsh-users/zsh-completions
zinit ice depth=1; zinit light zsh-users/zsh-autosuggestions

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Completion settings
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=**'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

eval "$(fzf --zsh)"

# Aliases
alias la='ls -lah --color'
alias c='clear -x'

# Local bins
PATH="$HOME/.local/bin:$PATH"

# Bun Installation
PATH="$HOME/.bun/bin:$PATH"

# bun completions
[ -s "${HOME}/.bun/_bun" ] && source "/home/gramos/.bun/_bun"

FNM_PATH="/home/gramos/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="${HOME}/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fnm
