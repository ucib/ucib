sources_list="${TARGET}/etc/apt/sources.list"

rm -f "$sources_list"

for mirror in ${OPTS[apt-mirrors]}; do
	cat <<EOF >>"$sources_list"
deb $mirror trusty main universe
EOF
done

cat <<EOF >>"$sources_list"
deb http://security.ubuntu.com/ubuntu trusty-security main universe
EOF

for repo in "${EXTRA_APT_REPOS[@]}"; do
	echo "$repo" >>"$sources_list"
done
