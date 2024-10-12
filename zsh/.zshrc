# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZSH History properties.
HISTFILE="$HOME/.cache/zsh/.zsh_history"
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

bindkey '^[[A' history-search-forward
bindkey '^[[B' history-search-backward

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
autoload -U compinit && compinit
zinit cdreplay -q

# Completion settings
zstyle ':completion:*' matcher-list "m:{a-z}={A-Za-z}"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

eval "$(fzf --zsh)"

# Aliases
alias la='ls -lah --color'
alias c='clear -x'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh