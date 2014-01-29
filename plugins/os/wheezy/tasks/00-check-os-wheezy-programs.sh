if ! apt-file --help >/dev/null 2>&1; then
	# apt-file is presumably not available
	warning "apt-file is not installed; this isn't a fatal error, but it
	        will mean I can't automatically install programs that are
	        needed to build the image."
fi

check_program_available "debootstrap --help" "debootstrap"
check_program_available "shred --help" "shred"
