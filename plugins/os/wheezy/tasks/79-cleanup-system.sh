if [ -f "${TARGET}/root/.bash_history" ]; then
	shred --remove "${TARGET}/root/.bash_history"
fi

rm -rf "${TARGET}/tmp/"* "${TARGET}/run/"*
find "${TARGET}/var/log" -type f | xargs --no-run-if-empty shred --remove
