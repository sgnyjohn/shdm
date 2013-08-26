

###########################################
## cdm-licence
## 
dispLivre() {
	# Get the first empty display.
	display=0
	while ((display < 7)); do
		if dpyinfo=$(xdpyinfo -display ":$display.0" 2>&1 1>/dev/null) ||
			# Display is in use by another user.
			[[ "$dpyinfo" == 'No protocol specified'* ]] ||
			# Invalid MIT cookie.
			[[ "$dpyinfo" == 'Invalid MIT'* ]]
		then
			let display+=1
		else
			break
		fi
	done
	echo $display
}
##########################################
## cdm-licence
## 
opcoesLogon() {
	if [[ "${#binlist[@]}" == 0 && -d /etc/X11/Sessions ]]; then
		binlist=($(find /etc/X11/Sessions -maxdepth 1 -type f))
		flaglist=($(sed 's/[[:digit:]]\+/X/g' <<< ${!binlist[@]}))
		namelist=(${binlist[@]##*/})
	fi

	# If $binlist is not set in cdmrc or by files in /etc/X11/Sessions,
	# try .desktop files in /usr/share/xsessions/ .

	if [[ "${#binlist[@]}" == 0 && -d /usr/share/xsessions ]]; then
		desktopsessions=($(find /usr/share/xsessions/ -regex .\*.desktop))
		#TODO: allow full quoting and expansion according to desktop entry spec:
		# http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#exec-variables

		for ((count=0; count < ${#desktopsessions[@]}; count++)); do
			# TryExec key is there to determine if executable is present,
			# but as we are going to test the Exec key anyway, we ignore it.
			execkey=$(sed -n -e 's/^Exec=//p' <${desktopsessions[${count}]})
			namekey=$(sed -n -e 's/^Name=//p' <${desktopsessions[${count}]})
			if [[ -n ${execkey} && -n ${namekey} ]]; then
				# The .desktop files allow there Exec keys to use $PATH lookup.
				binitem="$(which $(cut -f 1 -d ' ' <<< ${execkey}))"
				# If which fails to return valid path, skip to next .desktop file.
				if [[ $? != 0 ]]; then continue; fi
				binlist+=("${binitem} $(cut -s -f 2- -d ' ' <<< ${execkey})")
				flaglist+=('X')
				namelist+=("${namekey}")
			fi
		done
	fi
}
