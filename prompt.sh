git_prompt_status() {
  local branch=`parse_git_branch`;
  local dirty=`parse_git_dirty`;
  if [ ! "${branch}" == "" ]; then
    echo -e "[${branch}${dirty}] ";
  else
    echo "";
  fi
}

git_prompt_status_colored() {
  local branch=`parse_git_branch`;
  local dirty=`parse_git_dirty`;
  if [ ! "${branch}" == "" ]; then
    echo -e "\x01${txtcyn}\x02[${branch}\x01${txtpur}\x02${dirty}\x01${txtcyn}\x02]\x01${txtrst}\x02 ";
  else
    echo "";
  fi
}

parse_git_branch() { 
  local branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`;
  echo "${branch}";
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

# OSX
# export PS1='\u@\h:\w `git_prompt_status`'

# Ubuntu
# if [ "$color_prompt" = yes ]; then
#   PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$(git_prompt_status)\$ "
# else
#   PS1="\${debian_chroot:+(\$debian_chroot)}\u@\h:\w \$(git_prompt_status)\$ "
# fi
