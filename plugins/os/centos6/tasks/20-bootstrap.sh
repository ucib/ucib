if [ -n "${OPTS[mirror]}" ]; then
	mirroropt="--mirror=${OPTS[mirror]}"
fi

if check_program_available "rinse" "rinse" "n"; then
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
else
	case "${OPTS[arch]}" in
		"amd64")
			centos_release_package_arch="x86_64"
			centos_mirror_arch="x86_64"
			;;
		"i386")
			centos_release_package_arch="i686"
			centos_mirror_arch="i386"
			;;
		*)
			fatal "Unknown architecture: ${OPTS[arch]}";;
	esac

	if [ -n "${OPTS[mirror]}" ]; then
		centos_mirror_url="${OPTS[mirror]}"
	else
		centos_mirror_url="http://mirror.centos.org/centos/6/os/${centos_mirror_arch}/Packages"
	fi

	centos_release_package_url="${centos_mirror_url}/centos-release-6-7.el6.centos.12.3.${centos_release_package_arch}.rpm"

	mkdir -p "${TARGET}/var/lib/rpm"
	rpm --root="$TARGET" --initdb
	cat >/tmp/repokey <<EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.5 (GNU/Linux)

mQINBE4P06MBEACqn48FZgYkG2QrtUAVDV58H6LpDYEcTcv4CIFSkgs6dJ9TavCW
NyPBZRpM2R+Rg5eVqlborp7TmktBP/sSsxc8eJ+3P2aQWSWc5ol74Y0OznJUCrBr
bIdypJllsD9Fe+h7gLBXTh3vdBEWr2lR+xA+Oou8UlO2gFbVFQqMafUgU1s0vqaE
/hHH0TzwD0/tJ6eqIbHwVR/Bu6kHFK4PwePovhfvyYD9Y+C0vOYd5Ict2vbLHz1f
QBDZObv4M6KN3j7nzme47hKtdMd+LwFqxM5cXfM6b5doDulWPmuGV78VoX6OR7el
x1tlfpuiFeuXYnImm5nTawArcQ1UkXUSYcTUKShJebRDLR3BycxR39Q9jtbOQ29R
FumHginovEhdUcinRr22eRXgcmzpR00zFIWoFCwHh/OCtG14nFhefuZ8Z80qbVhW
2J9+/O4tksv9HtQBmQNOK5S8C4HNF2M8AfOWNTr8esFSDc0YA5/cxzdfOOtWam/w
lBpNcUUSSgddRsBwijPuWhVA3NmA/uQlJtAo4Ji5vo8cj5MTPG3+U+rfNqRxu1Yc
ioXRo4LzggPscaTZX6V24n0fzw0J2k7TT4sX007k+7YXwEMqmHpcMYbDNzdCzUer
Zilh5hihJwvGfdi234W3GofttoO+jaAZjic7a3p6cO1ICMgfVqrbZCUQVQARAQAB
tEZDZW50T1MtNiBLZXkgKENlbnRPUyA2IE9mZmljaWFsIFNpZ25pbmcgS2V5KSA8
Y2VudG9zLTYta2V5QGNlbnRvcy5vcmc+iQI8BBMBAgAmBQJOD9OjAhsDBQkSzAMA
BgsJCAcDAgQVAggDBBYCAwECHgECF4AACgkQCUb8osEFud6ajRAAnb6d+w6Y/v/d
MSy7UEy4rNquArix8xhqBwwjoGXpa37OqTvvcJrftZ1XgtzmTbkqXc+9EFch0C+w
ST10f+H0SPTUGuPwqLkg27snUkDAv1B8laub+l2L9erzCaRriH8MnFyxt5v1rqWA
mVlRymzgXK+EQDr+XOgMm1CvxVY3OwdjdoHNox4TdVQWlZl83xdLXBxkd5IRciNm
sg5fJAzAMeg8YsoDee3m4khg9gEm+/Rj5io8Gfk0nhQpgGGeS1HEXl5jzTb44zQW
qudkfcLEdUMOECbu7IC5Z1wrcj559qcp9C94IwQQO+LxLwg4kHffvZjCaOXDRiya
h8KGsEDuiqwjU9HgGq9fa0Ceo3OyUazUi+WnOxBLVIQ8cUZJJ2Ia5PDnEsz59kCp
JmBZaYPxUEteMtG3yDTa8c8jUnJtMPpkwpSkeMBeNr/rEH4YcBoxuFjppHzQpJ7G
hZRbOfY8w97TgJbfDElwTX0/xX9ypsmBezgGoOvOkzP9iCy9YUBc9q/SNnflRWPO
sMVrjec0vc6ffthu2xBdigBXhL7x2bphWzTXf2T067k+JOdoh5EGney6LhQzcp8m
YCTENStCR+L/5XwrvNgRBnoXe4e0ZHet1CcCuBCBvSmsPHp5ml21ahsephnHx+rl
JNGtzulnNP07RyfzQcpCNFH7W4lXzqM=
=jrWY
-----END PGP PUBLIC KEY BLOCK-----
EOF
	# For reasons I cannot fathom, <(cat ...) doesn't work on this
	rpm --root="$TARGET" --import /tmp/repokey
	rm -f /tmp/repokey
	wget -O /tmp/centos_release.rpm "$centos_release_package_url" |& spin "Downloading centos-release RPM"
	rpm --root="$TARGET" -i --nodeps /tmp/centos_release.rpm
	rm -f /tmp/centos_release.rpm
	yum --installroot="$TARGET" install -y rpm-build yum util-linux-ng |& spin "Installing base system"

	cp /etc/resolv.conf "$TARGET/etc/"

	[ -d "${TARGET}/dev" ]         || mkdir -p "${TARGET}/dev"
	[ -e "${prefix}/dev/zero" ]    || mknod -m 666 "${prefix}/dev/zero" c 1 5
	[ -e "${prefix}/dev/random" ]  || mknod -m 666 "${prefix}/dev/random" c 1 8
	[ -e "${prefix}/dev/urandom" ] || mknod -m 666 "${prefix}/dev/urandom" c 1 9
fi
