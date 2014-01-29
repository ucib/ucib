# The only locale we can be pretty sure we'll need...
echo "C ISO-8859-1" >"${TARGET}/etc/locale.gen"

run_in_target locale-gen >/dev/null 2>&1
