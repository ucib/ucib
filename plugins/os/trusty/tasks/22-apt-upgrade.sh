run_in_target apt-get update 2>&1 | spin "Updating apt package lists"
run_in_target apt-get -fy install 2>&1 | spin "Fixing any missing dependencies"
run_in_target apt-get -y upgrade 2>&1 | spin "Installing latest security fixes"

