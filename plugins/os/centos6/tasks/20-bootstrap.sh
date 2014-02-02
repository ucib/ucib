if [ -n "${OPTS[mirror]}" ]; then
	mirroropt="--mirror=${OPTS[mirror]}"
fi

if ! rinse  \
           --arch "${OPTS[arch]}" \
           --distribution centos-6 \
           "$mirroropt" \
           --directory "$TARGET" |&
               tee "${WORKSPACE}/rinse_output" |
               spin "Running bootstrap"; then
	error "Bootstrap failed:"
	cat "${WORKSPACE}/rinse_output"
	exit 1
fi
