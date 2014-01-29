run_in_target apt-get update | spin "Updating apt package lists"
run_in_target apt-get -fy install | spin "Fixing any missing dependencies"
run_in_target apt-get -y upgrade | spin "Installing latest security fixes"

