if optval proxy >/dev/null; then
	echo "Acquire::http::Proxy \"$(optval proxy)\";" >"${TARGET}/etc/apt/apt.conf.d/50proxy"
fi

