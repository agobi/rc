#if [ -n "$SSH_AGENT_PID" -a -f ~/.agent -a `who | grep gwonder | wc -l` == 1 ]; then
#	PID=$SSH_AGENT_PID
#	. ~/.agent
#	if [ $SSH_AGENT_PID == $PID ]; then
#		eval `ssh-agent -k`
#		rm ~/.agent
#	fi
#fi

echo Goodbye.
case `tty` in
	/dev/ttyv[0-9]) clear
esac
