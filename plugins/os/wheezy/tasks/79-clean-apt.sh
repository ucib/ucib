run_in_target apt-get -y autoremove --purge >/dev/null 2>&1
run_in_target apt-get clean >/dev/null 2>&1
run_in_target rm -rf /var/lib/apt/lists/*
