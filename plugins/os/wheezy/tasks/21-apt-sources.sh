sources_list="${TARGET}/etc/apt/sources.list"

rm -f "$sources_list"

for mirror in ${OPTS[apt-mirrors]}; do
	cat <<EOF >>"$sources_list"
deb $mirror wheezy main
#deb-src $mirror wheezy main
EOF
done

cat <<EOF >>"$sources_list"
deb http://security.debian.org/ wheezy/updates main
#deb-src http://security.debian.org/ wheezy/updates main
EOF

parseopt "extra-repo" "true"

while optval "extra-repo" >/dev/null; do
	echo "$(optval extra-repo)" >>"$sources_list"
	parseopt "extra-repo" "true"
done
