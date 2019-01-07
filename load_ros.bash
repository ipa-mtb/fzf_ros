SOURCEDIR=`echo "$BASH_SOURCE" | grep -Eo ".+/"`
FULLSOURCEPATH=$SOURCEDIR

function loadif {
    if [ -f $SOURCEDIR$@ ]; then
        source $SOURCEDIR$@
    fi
}

command_exists () {
    hash "$1" &> /dev/null ;
}

export ROS_WORKSPACE=$HOME/git/ipa_navigation_catkin/src
export HIDE_PRINTOUTS=0

loadif ros_config.bash

if command_exists fzf ; then
    if [ -n "$PS1" ]; then
        if [ -f ~/.fzf.bash ]; then
            loadif "fzf_ros.bash"
        fi
    fi
fi
