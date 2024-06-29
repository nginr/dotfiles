#!/usr/bin/bash
# Modified from (upekkha) [https://github.com/upekkha/dotfiles/blob/master/.bash_profile]

# ------  custom bash prompt  --------{{{
my_command_prompt() {

    # Display git branch and dirty status
    git_status_prompt
    # Display name of activated venv
    venv_status_prompt

    # Define colors
    local WHITE="\[\033[1;37m\]"
    local GREEN="\[\033[0;32m\]"
    local CYAN="\[\033[0;36m\]"
    local GRAY="\[\033[0;37m\]"
    local BLUE="\[\033[0;34m\]"
    local MAGENTA="\[\033[0;35m\]"
    local RED="\[\033[0;31m\]"
    local YELLOW="\[\033[0;33m\]"

    # Define root prompt
    export SUDO_PS1="${RED}\u@\h:${MAGENTA}\w/ ${GRAY}"

    USRNAME=`whoami`
    if [ "$USRNAME" == "root" ]; then
        export PS1="${RED}\u@\h:${MAGENTA}\w/ ${GRAY}"
    else
        export PS1="${BLUE}\u${GRAY}@${GREEN}\h:${MAGENTA}\W${YELLOW}\${GITSTAT}\${VENVSTAT} ${GRAY}> "
    fi
}

function git_status_prompt #{{{
{
    local GITSTATUS=`git status 2>&1`

    # Retrieve current branch
    if [[ ${GITSTATUS} =~ On\ branch\ ([^[:space:]]+) ]]; then
        GITBRANCH=${BASH_REMATCH[1]}
    fi

    if [[ ${GITSTATUS} =~ "ot a git repository" ]]; then
        # No git repo
        GITSTAT=""
    elif [[ ${GITSTATUS} =~ "must be run in a work tree" ]]; then
        # Bare git repo
        GITSTAT=""
    elif [[ ${GITSTATUS} =~ "working tree clean" ]]; then
        # Clean repo
        GITSTAT=" [${GITBRANCH}]"
    else
        # Dirty repo
        GITSTAT=" [${GITBRANCH} ±]"
    fi
}
#}}}

function venv_status_prompt #{{{
{
    local VENVNAME="${VIRTUAL_ENV##*/}"

    if [[ -z $VENVNAME ]]; then
        VENVSTAT=""
    else
        VENVSTAT="(${VENVNAME})"
    fi
}
#}}}

PROMPT_COMMAND=my_command_prompt
