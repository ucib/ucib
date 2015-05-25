sources_list="${TARGET}/etc/apt/sources.list"

rm -f "$sources_list"

for mirror in ${OPTS[apt-mirrors]}; do
	cat <<EOF >>"$sources_list"
deb $mirror jessie main
#deb-src $mirror jessie main
EOF
done

cat <<EOF >>"$sources_list"
deb http://security.debian.org/ jessie/updates main
#deb-src http://security.debian.org/ jessie/updates main
EOF

for repo in "${EXTRA_APT_REPOS[@]}"; do
	echo "$repo" >>"$sources_list"
done
