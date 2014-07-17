for url in "${!APT_KEY_URLS[@]}"; do
	wget -O - -q "$url" | run_in_target apt-key add -
done
