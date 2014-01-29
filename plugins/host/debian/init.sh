if [ -e /etc/debian_version ]; then
	install_program_in_host() {
		local program="$1"
		
		if [ -n "$(which apt-file)" ]; then
			apt-file update |& spin "Updating apt-file database"

			debug "Looking for a package containing bin/$program"
			pkg="$(apt-file search -l "bin/$program")"
			
			if [ -n "$pkg" ]; then
				apt-get install -y $pkg |& spin "Installing '$pkg' to provide '$program'"
			else
				fatal "The build process requires '$program'
				      in order to complete, but I can't find
				      a package that contains it.  Please
				      install the relevant software manually."
			fi
		else
			fatal "We need to install a package containing the
			      program '$program', but apt-file is not available
			      to help me find it.  Please install apt-file, or
			      install the required package manually."
		fi
	}
fi
