#!/bin/sh

# utils
join_args() {
	local arg
	printf "%s" "$1"
	shift
	for arg in "$@"; do
		printf " "
		printf "%s" "${arg// /\ }"
	done
}

abort() {
	printf "Error: %s\n" "$1"
	exit 1
}

execute() {
	if ! "$@"; then
		abort "$(printf "could not execute command: %s" "$(join_args "$@")")"
	fi
}

# check if runing os macOS
if [ "$(uname)" != "Darwin" ]; then
	abort "this script only works on macOS"
fi

# create .42 directory
execute "mkdir" "-p" "$HOME/.42"

# clone dot42 inside the directory
execute "git" "clone" "https://github.com/30c27b/dot42" "$HOME/.42"

# launch dot42 setup command
execute "$HOME/.42/bin/dot42" "setup"

# give execute permission to shell scripts
execute "chmod" "-R" "+x" "$HOME/.42/scripts"

# install dot42 daemon
execute "cp" "$HOME/.42/daemon/dot42.plist" "$HOME/Library/LaunchAgents/com.30c27b.dot42.plist"

# done
execute "echo" "dot42 is now installed."