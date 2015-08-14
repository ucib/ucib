if ! check_program_available "rinse" "rinse" "n"; then
	if ! check_program_available "yum --help" "yum" "n" && ! check_program_available "rpm --help" "rpm" "n"; then
		fatal "Neither 'rinse' nor 'yum'+'rpm' are available; cannot build a CentOS 6 image"
	fi
fi
check_program_available "wget --help" "wget"
check_program_available "shred --help" "shred"
