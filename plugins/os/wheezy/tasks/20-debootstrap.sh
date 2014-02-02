if ! debootstrap  \
           --arch "${OPTS[arch]}" \
           --include "udev,locales \
           --exclude "dmidecode" \
           wheezy \
           "$TARGET" \
           "${OPTS[debootstrap-mirror]}" |& \
               tee "${WORKSPACE}/debootstrap_output" |
               spin "Running debootstrap"; then
	error "Debootstrap failed:"
	cat "${WORKSPACE}/debootstrap_output"
	exit 1
fi
