# OS support

These plugins contain all of the tasks and support functions required to
install a particular OS inside of an arbitrary cloud platform's container
format.


# Required Tasks

There aren't any specific *named* tasks that need to be provided, however
you should make whatever task does the base installation happen at `20`, and
any post-bootstrap configuration tasks happen between `21` and `29`
(inclusive).


# Required Functions

There are a number of things that need to be done for only *some* cloud
platforms, and not others, and unfortunately they're done differently for
different OSes.  In order to accommodate this dilemma, OS plugins are
required to implement a number of functions, which platform plugins can call
if they're needed.  In order to be considered a fully-functional OS plugin,
you MUST implement all of these functions.  If they are a NOOP for your OS,
they can be empty, but they MUST exist.  Define them in your OS plugin's
`init.sh` file.

 * `create_user <username> [realname [password]]` -- Create a user in the
   guest OS.  If [realname] is not provided, it defaults to the username,
   and if [password] is not provided, the account is disabled from being
   able to login using a password (so you better set some SSH keys!).

 * `dhcp_interface <interface>` -- Configure the specified interface name to
   be configured by DHCP at startup.

 * `disable_console [keep1]` -- Turn off all consoles.  If the optional
   argument `[keep1]` is provided, then one console is left available.

 * `install_init_script <file>` -- Install the specified file as an init
   script within the system, and enable it to be run at boot.  The name of
   service will be the basename of the file.

 * `install_package_containing <file>` -- Given an absolute filename,
   attempt to find a package containing that file and install it in the
   image being built.  Returns 0 if a package was installed, and 1
   otherwise, and does *not* produce any output.

 * `set_hostname <hostname>` -- Set the system's hostname to the provided
   hostname.
 
 * `set_password <username> <password>` -- Set the password for a given user
   to the plaintext password `<password>`.  This should only be needed for
   system accounts like `root`, because you can set the password for a user
   you create when you create it.
