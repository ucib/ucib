# The Ultimate Cloud Image Builder

This program is designed to build an image of any supported OS, suitable for
deployment on any supported cloud platform.  Quite a feat, wouldn't you say?


# Usage

If you just want to build an image, it should be quite straightforward:

    ./ucib --os <os> --cloud <cloud> [other options]

Some cloud platforms will produce an image file of some sort in `builds/`,
while others will register the image somewhere in the cloud platform for you
to use -- the build system should tell you where it is.  The `--name`
parameter is to help you to identify the image, wherever it may have ended
up.

Pretty much every combination of `--os` and `--cloud` will require some
additional options.  If you add `--help` to the command line, you'll get the
full list of options that are available for your selection of `<os>` and
`<cloud>`.


# Supported build environments

Creating an image is a job that requires a number of tools to be installed
in the machine on which the build process is running.  In some cases, the
tools required to build an image for a particular OS won't even *exist* in
certain OSes.

Thus, I can't guarantee that every guest OS that `ucib` supports will be
installable using every host OS we support.  The best I can offer is that if
you run `ucib` on a host OS which is "fully-supported", the packages that
are needed to provide a necessary tool will be automatically installed IF
THEY ARE AVAILABLE.  No guarantees are given whether the tools required to
install every possible guest OS, or create an image for every possible cloud
platform, will be available on your OS.

If you are building on an unsupported host OS, your build may or may not
succeed.  If the build process needs packages installed on the host to
proceed, the build will fail and you will be told what program is missing,
so you can install it by hand.

At the time of writing, the following OSes are supported as build hosts:

 * Debian Wheezy


# Supported guest OSes / cloud platforms

Which OSes can be installed, and onto which cloud platforms they can be
installed, is simply a matter of whether or not a plugin has been written to
suit them.  

The set of available guest OSes and cloud platforms can be found by looking
in `plugins/os` and `plugins/cloud`, respectively.

If an OS you'd like to install, or a cloud platform you'd like to install
into, isn't available in UCIB, you are encouraged to develop it!  See the
next section.


# Development

UCIB is based around plugins -- very little of what ucib does is present in
the "core" of the program, and instead every aspect of the build process is
managed via plugins.

Plugins come in many flavours.  Some define the steps necessary to install a
guest OS, or the steps required to build an image for a given cloud
platform.  Others define disk partitioning schemes, additional package sets
to install, post-installation startup routines, or how to do certain things
inside of the host OS to help the build complete.

An overview of all the available plugin types is available in
`plugins/README.md`.  Each specific type of plugin has its own `README.md`
in its type directory (`plugins/<type>/README.md`), which describes the
interface which that plugin should implement.


## Contributing

You are strongly encouraged to contribute patches and plugins to UCIB. 
Please fork the [project repo](https://github.com/ucib/ucib) on Github, push
your changes to a feature branch, and submit a pull request.
