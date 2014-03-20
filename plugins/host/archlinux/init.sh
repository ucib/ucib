if lsb_release -is | grep -qi arch; then
	debug "Found an ArchLinux host environment. Initialising host plugin"

	# Update the pacman sync databases
	pacman -Sy --noprogressbar |& spin "Updating pacman sync databases" || fatal "Coult not update pacman sync databases"

	install_program_in_host() {
		local program="$1"

		debug "Attempting to find and install a package to satisfy our requirement for '$program'"

		# We aren't able to search for packages containing $program
		# with pacman, so let's assume the $program we need to
		# install is contained within a package of the same name.
		# The user can intervene if this is not the case.

		debug "Searching for package named '$program'"
		local pkg="$(pacman -Ssq ^$program\$)"

		if [ -n "$pkg" ]; then
			debug "Found package. Attempting to install"
			pacman -Sq --noprogressbar --noconfirm $pkg |& spin "Installing '$pkg'" || \
				fatal "Could not install required package $pkg. Please install it manually"
		else
			debug "Could not find package. Bailing"

			fatal "The build process requires '$program' in order to complete, but I can't find a
			      package that contains it. Please install the relevant software manually."
		fi
	}

	debug "Finished initialising ArchLinux host plugin"
fi
