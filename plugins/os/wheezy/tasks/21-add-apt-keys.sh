parseopt "apt-key-url" "true"

while optval "apt-key-url" >/dev/null; do
	wget -O - -q "$(optval apt-key-url)" | run_in_target apt-key add -
	parseopt "apt-key-url" "true"
done
