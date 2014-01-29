check_program_available "(kpartx || true) | grep -q 'usage : kpartx'" "kpartx"
check_program_available "(zerofree || true) |& grep 'usage: zerofree'" "zerofree"
