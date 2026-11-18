# ── Colors ────────────────────────────────────────────────────────────────────
PR_CYAN=$'%{\e[38;2;0;229;255m%}'
PR_MAGENTA=$'%{\e[38;2;255;0;180m%}'
PR_BLUE=$'%{\e[38;2;100;160;255m%}'
PR_VIOLET=$'%{\e[38;2;180;130;255m%}'
PR_GREY=$'%{\e[38;2;160;170;200m%}'
PR_DARK=$'%{\e[38;2;60;70;120m%}'
PR_NO_COLOUR=$'%{\e[0m%}'

# ── Git status ────────────────────────────────────────────────────────────────
ZSH_THEME_GIT_PROMPT_PREFIX=" ${PR_VIOLET}❯ "
ZSH_THEME_GIT_PROMPT_SUFFIX="${PR_NO_COLOUR}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=$' %{\e[38;2;0;229;255m%}✔'
ZSH_THEME_GIT_PROMPT_ADDED=$' %{\e[38;2;0;255;160m%}+'
ZSH_THEME_GIT_PROMPT_MODIFIED=$' %{\e[38;2;100;160;255m%}~'
ZSH_THEME_GIT_PROMPT_DELETED=$' %{\e[38;2;255;80;120m%}-'
ZSH_THEME_GIT_PROMPT_RENAMED=$' %{\e[38;2;100;255;218m%}→'
ZSH_THEME_GIT_PROMPT_UNMERGED=$' %{\e[38;2;255;200;0m%}!!'
ZSH_THEME_GIT_PROMPT_UNTRACKED=$' %{\e[38;2;255;140;66m%}?'

# ── Box drawing ───────────────────────────────────────────────────────────────
if [[ "${langinfo[CODESET]}" = UTF-8 ]]; then
  PR_SET_CHARSET=""
  PR_HBAR="─"
  PR_ULCORNER="╭"
  PR_LLCORNER="╰"
  PR_BULLET="❯"
else
  typeset -g -A altchar
  set -A altchar ${(s..)terminfo[acsc]}
  PR_SET_CHARSET="%{$terminfo[enacs]%}"
  PR_SHIFT_IN="%{$terminfo[smacs]%}"
  PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
  PR_HBAR="${PR_SHIFT_IN}${altchar[q]:--}${PR_SHIFT_OUT}"
  PR_ULCORNER="${PR_SHIFT_IN}${altchar[l]:--}${PR_SHIFT_OUT}"
  PR_LLCORNER="${PR_SHIFT_IN}${altchar[m]:--}${PR_SHIFT_OUT}"
  PR_BULLET=">"
fi

# ── Titlebar ──────────────────────────────────────────────────────────────────
case $TERM in
  xterm*) PR_TITLEBAR=$'%{\e]0;%~\a%}' ;;
  screen) PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %~\e\\%}' ;;
  *)      PR_TITLEBAR="" ;;
esac

[[ "$TERM" = "screen" ]] && PR_STITLE=$'%{\ekzsh\e\\%}' || PR_STITLE=""

# ── Width calculation ─────────────────────────────────────────────────────────
setopt prompt_subst
autoload -U add-zsh-hook

function theme_precmd {
  local TERMWIDTH=$(( COLUMNS - ${ZLE_RPROMPT_INDENT:-1} ))
  PR_FILLBAR=""
  PR_PWDLEN=""

  # Only the path and box-drawing characters occupy space.
  local fixed_chars="╭─[]────"
  local pwdsize=${#${(%):-%~}}

  local venvsize=0 rubysize=0 condasize=0
  (( $+functions[virtualenv_prompt_info] )) && venvsize=${#${(%):- $(virtualenv_prompt_info)}}
  (( $+functions[ruby_prompt_info] ))       && rubysize=${#${(%):- $(ruby_prompt_info)}}
  (( $+functions[conda_prompt_info] ))      && condasize=${#${(%):- $(conda_prompt_info)}}

  local occupied=$(( ${#fixed_chars} + pwdsize + venvsize + rubysize + condasize ))

  if (( occupied >= TERMWIDTH )); then
    (( PR_PWDLEN = TERMWIDTH - ${#fixed_chars} ))
    [[ $PR_PWDLEN -lt 4 ]] && PR_PWDLEN=4
  else
    local fill=$(( TERMWIDTH - occupied ))

    if [[ "${langinfo[CODESET]}" = UTF-8 ]]; then
      PR_FILLBAR="${(l:${fill}::─:)}"
    else
      PR_FILLBAR="${PR_SHIFT_IN}${(l:${fill}::${altchar[q]:--}:)}${PR_SHIFT_OUT}"
    fi
  fi
}

add-zsh-hook precmd theme_precmd

# ── Preexec ───────────────────────────────────────────────────────────────────
function theme_preexec {
  setopt local_options extended_glob
  if [[ "$TERM" = "screen" ]]; then
    local CMD=${1[(wr)^(*=*|sudo|-*)]}
    echo -n "\ek$CMD\e\\"
  fi
}

add-zsh-hook preexec theme_preexec

# ── Prompt ────────────────────────────────────────────────────────────────────
#
# Line 1: ╭─[ ~/path ]────────────────────────
# Line 2: ╰─( HH:MM:SS ❯ branch + ~ - → !! ? )─❯
#

PROMPT='${PR_SET_CHARSET}${PR_STITLE}${(e)PR_TITLEBAR}'\
'${PR_CYAN}╭─${PR_GREY}['\
'${PR_CYAN}%${PR_PWDLEN}<…<%~%<<'\
'${PR_GREY}]${PR_DARK}${PR_FILLBAR}'\
'${PR_CYAN}──'\
$'\n'\
'${PR_CYAN}╰─${PR_BLUE}(${PR_BLUE}%D{%H:%M:%S}'\
'$(git_prompt_info)$(git_prompt_status)'\
'${PR_BLUE})${PR_CYAN}─${PR_MAGENTA}${PR_BULLET} '\
'${PR_NO_COLOUR}'

# ── Right prompt: exit code ───────────────────────────────────────────────────
return_code=$'%(?.. %{\e[38;2;255;80;120m%}✕ %?)'"${PR_NO_COLOUR}"
RPROMPT='$return_code'

# ── Continuation prompt ───────────────────────────────────────────────────────
PS2='${PR_CYAN}──${PR_BLUE}(${PR_VIOLET}%_${PR_BLUE})─${PR_CYAN}─${PR_MAGENTA}${PR_BULLET} ${PR_NO_COLOUR}'

