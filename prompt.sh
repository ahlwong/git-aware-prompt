parse_git_branch() { 
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`;
  if [ ! "${BRANCH}" == "" ]; then
    STAT=`parse_git_dirty`;
    echo "${txtcyn}[${BRANCH}${txtpur}${STAT}${txtcyn}]${txtrst}";
  else
    echo "";
  fi
}

parse_git_dirty() { 
  local status=`git status 2>&1 | tee`;
  local dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`;
  local untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`;
  local ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`;
  local newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`;
  local renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`;
  local deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`;
  local bits='';
  if [ "${renamed}" == "0" ]; then
    bits=">${bits}";
  fi;
  if [ "${ahead}" == "0" ]; then
    bits="*${bits}";
  fi;
  if [ "${newfile}" == "0" ]; then
    bits="+${bits}";
  fi;
  if [ "${untracked}" == "0" ]; then
    bits="?${bits}";
  fi;
  if [ "${deleted}" == "0" ]; then
    bits="x${bits}";
  fi;
  if [ "${dirty}" == "0" ]; then
    bits="!${bits}";
  fi;
  if [ ! "${bits}" == "" ]; then
    echo " ${bits}";
  else
    echo "";
  fi
}

# export PS1='\u@\h:\w \[`parse_git_branch`\] '

# PROMPT_COMMAND="find_git_branch; find_git_dirty; $PROMPT_COMMAND"

# Default Git enabled prompt with dirty state
# export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Another variant:
# export PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "

# Default Git enabled root prompt (for use with "sudo -s")
# export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
