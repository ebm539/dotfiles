# enable terminal cursor, may be disabled as part of silent boot
setterm -cursor on

# comment out autostart_wm to disable wm autostart,
# set intended_wm to sway, i3, or some command
autostart_wm=1
intended_wm() {sway}

# zsh profiling, run `zprof`
#zmodload zsh/zprof

# disable terminal "bell"
setterm -blength 0 2>/dev/null

# source local zshrc if file exists
# $HOME in file checking, because ~ does not expand in quotes
if [ -f "$HOME/.zshrc.local" ]; then
		. ~/.zshrc.local
fi

# source zsh plugins, if they exist (may not exist if git submodules are not fetched)
# TODO: use an array to iterate over for scripts to source
if [ -f "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
		. ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
		. ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

#source <(navi widget zsh)

export EDITOR="vim"
export VISUAL="vim"

# ff2mpv breaks tty input
killff2mpv() {
		for pid in $(pgrep python3); do
				if [ $(strings /proc/$pid/cmdline | grep -c ff2mpv) -ge 1 ]; then
						kill $pid
				fi
		done
}


# wrapper function to run sway, then kill ff2mpv on sway exit
# (ff2mpv breaks tty input after sway exit)
sway() {
		export MOZ_ENABLE_WAYLAND=1
		export _JAVA_AWT_WM_NONREPARENTING=1
		/usr/bin/sway
		retVal=$? 
		killff2mpv
}

i3() {
		export MOZ_X11_EGL=1
		/usr/bin/startx /usr/bin/i3
		i3retVal=$? 
		killff2mpv
}

# If running from tty1 start sway
# if exit code is 0, exit shell (and implicit relogin)
if [[ "$(tty)" = "/dev/tty1" ]] && [ autostart_wm ]; then
		# run sway, if exit code 0 then exit shell (and restart sway)
		# `killall sway` returns exit code 0
		
		# set RGB range to full for HDMI monitors - not using a TV
		proptest -M i915 -D /dev/dri/card0 124 connector 98 1
		intended_wm
		# i3 does not match if statement on $mod+Shift+e
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

gammastepfunc () { if [ "$(pgrep gammastep | wc -l)" -eq "0" ]; then gammastep -m drm -t 6500:1900 -c ~/.config/gammastep/config.ini &>/dev/null &; fi }

#gammastepfunc

export HISTSIZE=50000
export SAVEHIST=100000

# ???
export XDG_CONFIG_HOME="$HOME/.config"

prompt default
