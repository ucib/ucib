if [ -n "${OPTS[mirror]}" ]; then
	mirroropt="--mirror=${OPTS[mirror]}"
fi

if ! rinse  \
           --arch "${OPTS[arch]}" \
           --distribution centos-6 \
           --cache 0 \
           "$mirroropt" \
           --directory "$TARGET" |&
               spin "Running bootstrap"; then
	fatal "Bootstrap failed"
	exit 1
fi

# OMFG rinse is terribad... it leaves all sorts of stuff broken.  So,
# we need to fix the metadata cache, and then fix all the stuff that
# was left broken.
run_in_target yum clean metadata >/dev/null 2>&1

((run_in_target yum check dependencies || true) \
	| grep 'has missing requires' \
	| sed 's/.\+has missing requires of //' \
	| sed 's/ [=<>].\+//' \
	| while read dep; do install_packages_in_target "$dep"; done) |& spin "Fixing the bootstrapped base image"
