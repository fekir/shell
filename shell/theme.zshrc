#!/usr/bin/env zsh

theme_minimal(){
  precmd () { }
  unset PROMPT
  unset PROMPT_COMMAND
  RPROMPT=''
  PS1='%(!.%F{red}#.%F{yellow}$)%f '
  PS2=' %F{blue}>%f '
  PS3=' %F{purple}?%f '
  PS4=' + '
  THEME_MINIMAL='true'
  export THEME_MINIMAL
}

theme_fix_mc(){
  RPROMPT=''
}

theme_powerline() {
  local file="/usr/share/powerline/bindings/zsh/powerline.zsh"
  if [ -f "$file" ]; then
    . "$file"
    unset THEME_MINIMAL
    return 0
  fi
  return 1
}

#http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
theme_git(){
  autoload -Uz vcs_info
  zstyle ':vcs_info:*' enable git
  setopt prompt_subst
  precmd () { vcs_info }

  local user="%F{green}%n"
  local cur_location="%B%F{blue}%50<...<%~%<<%b" # truncates after 50 character with ..., and replace home with ~

  local prompt_tail="%F{yellow}%# "
  local last_color="%f"
  local check_previous_ret='%(?.%F{green}✓.%F{red}✗[%?])'

  PROMPT="$user $cur_location $prompt_tail$last_color"
  RPROMPT="$check_previous_ret\$vcs_info_msg_0_$last_color"
  unset THEME_MINIMAL
}

# load theme
if [ "$THEME_MINIMAL" = "true" ]; then
  theme_minimal
elif theme_powerline; then
  :
else
  theme_git
fi

if [[ $+MC_SID = 1 ]] ; then
  theme_fix_mc
fi
