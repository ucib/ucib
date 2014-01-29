# Cloud platform plugins

This directory contains the plugins to tell `ucib` how to build images for
various cloud platforms.  The appropriate one for your image build can be
selected by using the `--cloud <cloud>` command-line option.


# Writing a new platform plugin

It really is quite simple.  There's very little to be done in `init.sh`,
typically just provide some quick usage information, and perhaps define some
configuration parameters you might need.  You've got to write tasks to setup
the image (or use an existing `misc` plugin, if your platform uses a
well-known image format), configure a few things after the base build has
completed (like networking and a bootloader), then finish off with packaging
it all up and (optionally) registering it with the platform service.
