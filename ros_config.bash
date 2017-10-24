#------------------------------------------------------------------------------
# ROS
#------------------------------------------------------------------------------
#export ROSCONSOLE_FORMAT='[${node} ${severity} ${time}]: ${message}'
export ROS_LANG_DISABLE=genlisp # no one is using lisp...

alias dynreconf='rosrun rqt_reconfigure rqt_reconfigure'
alias rv="tmuxrun rviz"

alias rosderp='rosdep install --from-paths "$ROS_WORKSPACE" --ignore-src -y'
alias rosaction="rostopic list | grep '/result\|/goal\|/status\|/feedback\|/cancel'"


alias core="tmuxrun roscore"

alias ign="touch CATKIN_IGNORE"

alias rosmaster="change_rosmaster_to"
alias ros="change_rosmaster_to"

function rostmuxlaunch {
    tmux has-session -t $1 2>/dev/null
    if [ "$?" -eq 1 ] ; then
        tmux new-session -d -s $1
    fi
    #eval "tmux new-window -t $1 -n $2 'roslaunch $@; bash -i'"
    eval "tmux new-window -t $1 -n $2 '$DOTFILES_PATH/tmux_roslaunch.sh $@'"
}

function rosdepinstall {
    rosdep install --from-paths $1 --ignore-src --rosdistro $ROS_VERSION
}

function rosdepcheck {
    rosdep check --from-paths $1 --ignore-src --rosdistro $ROS_VERSION
}

function change_rosmaster_to {
    if [ "$#" -eq 0 ]; then
        echo -e "ROS master set to ${COLORGREEN}${ROS_MASTER_URI}${COLORNORMAL}!"
    elif [ "$#" -ne 1 ]; then
        export ROS_MASTER_URI=http://$1:1131$2
        echo "$1 $2" > ~/.current_rosmaster
        if [[ "$HIDE_PRINTOUTS" != yes ]]; then
            echo -e "ROS master set to ${COLORRED}${1}:1131${2}${COLORNORMAL}!"
        fi
    else
        export ROS_MASTER_URI=http://$1:11311

        if [[ "$HIDE_PRINTOUTS" != yes ]]; then
            if [[ "$1" == "localhost" ]] || [[ "$1" == "$(cat /etc/hostname)" ]]; then
                old_master=$(cat ~/.current_rosmaster)
                if [[ "$old_master" != "$1" ]]; then
                    echo -e "ROS master set to ${COLORGREEN}${1}${COLORNORMAL}!"
                fi
            else
                echo -e "ROS master set to ${COLORRED}${1}${COLORNORMAL}!"
            fi
        fi
        echo $1 > ~/.current_rosmaster

    fi
}

if [ -f ~/.current_rosmaster ]; then
    change_rosmaster_to $(cat ~/.current_rosmaster)
fi

rosloggersetlevel(){
    rosservice call $1/set_logger_level "{logger: 'rosout', level: '$2'}"
}

[ -n "$BASH" ] && complete -F "_roscomplete_launch" -o filenames "rostmuxlaunch"
