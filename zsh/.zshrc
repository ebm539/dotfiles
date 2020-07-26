setterm -cursor on

zmodload zsh/zprof

setterm -blength 0 2>/dev/null

source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source <(navi widget zsh)

export EDITOR="vim"
export VISUAL="vim"
export TERMINAL="alacritty"
export MOZ_WEBRENDER=1

# wrapper function to run sway, then kill ff2mpv on sway exit
# (ff2mpv breaks tty input after sway exit)
sway() {
		export MOZ_ENABLE_WAYLAND=1
		#also breaks nottetris2 (with an error)
		export _JAVA_AWT_WM_NONREPARENTING=1
		# set rgb range to full, this is a hdmi monitor
		proptest -M i915 -D /dev/dri/card0 124 connector 98 1
		/usr/bin/sway
		retVal=$? 
		for pid in $(pgrep python3); do
				if [ $(strings /proc/$pid/cmdline | grep -c ff2mpv) -ge 1 ]; then
						kill $pid
				fi
		done
}

i3() {
		/usr/bin/startx /usr/bin/i3
		i3retVal=$? 
		for pid in $(pgrep python3); do
				if [ $(strings /proc/$pid/cmdline | grep -c ff2mpv) -ge 1 ]; then
						kill $pid
				fi
		done
}

# If running from tty1 start sway
# if exit code is 0, exit shell (and implicit relogin)
if [[ "$(tty)" = "/dev/tty1" ]]; then
		# run sway, if exit code 0 then exit shell (and restart sway)
		# `killall sway` returns exit code 0
		sway
		if [ $retVal -eq 0 ]; then
				exit
		fi
fi

# Set GPG TTY
export GPG_TTY=$(tty)

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null

# use ccache compiler binaries
export PATH="/usr/lib/ccache/bin:$PATH"

# https://superuser.com/a/902508
zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

alias cp='cp --reflink=auto'
alias grep='grep -i'
alias zsh-launch-speed="repeat 5 time zsh -i -c exit"
alias gen-ssh-key="ssh-keygen -C "$(whoami)@$(hostname)-$(date -I)" -t ed25519"
alias pacman-mirror="awk '/^Server/ {split(\$3,a,\"$\"); print a[1];exit}' /etc/pacman.d/mirrorlist"
alias mpc="mpc --host ~/.config/mpd/socket"

redshiftfunc () { if [ "$(pgrep redshift | wc -l)" -eq "0" ]; then redshift -m drm -t 6500:1900 &>/dev/null &; fi }

#redshiftfunc

export HISTSIZE=50000
export SAVEHIST=100000

export XDG_CONFIG_HOME="$HOME/.config"

prompt default
