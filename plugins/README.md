# UCIB Plugins

This directory contains directories for each of the different plugin types
that are known to UCIB.  You can get more information on how each plugin
type works, and how to implement your own plugin of that type, by examining
the `README.md` in each of those directories.


# Available Plugin Types

The types of plugins that are currently supported are:

 * `cloud` -- Support for a given cloud platform.  They should primarily
   consist of tasks needed to create the basic disk image (ready for
   partitioning by `partitioner` plugins), and to package up the built
   system for use by the cloud platform after the build is complete.
 
 * `host` -- Support for a given host OS as the build environment.
 
 * `package` -- Installs (and optionally configures) a particular software
   package into the built image.
 
 * `misc` -- Plugins for which no other category exists.  These will
   typically need to be activated by hand (via the `--plugin` command-line
   option) and may do all manner of odd-ball things.  The major misc plugin
   of note is the `ucib` plugin, which contains the core functionality of
   UCIB itself.

 * `os` -- Tasks needed to install a guest OS into an image.  Typically
   these plugins will define tasks to do a "bootstrap" installation into the
   root filesystem, and perform any necessary post-installation package
   installs and whatnot.
 
 * `partitioner` -- Provides a specific task, `10-partition-image.sh`, which
   does the base partitioning of the disk image in a particular scheme.


# Plugin Structure

All plugins must have a file in the base of their tree named `init.sh`. 
This script is sourced when the plugin is loaded.  It should do any work
necessary to setup the plugin for use.  Some plugin types *only* consist of
an `init.sh`, while for other plugin types, `init.sh` can often be empty --
but it *must* exist, or else the directory will not be recognised as a
plugin.

The other standardised directories, which may or may not exist (depending on
what type of plugin it is and whether or not it needs that functionality)
are:

 * `tasks` -- Where task scripts are kept, if needed.  All task files in
   this directory are automatically registered when the plugin is loaded.
 
 * `files` -- Where files to be installed into the image being build are
   kept, if needed.


# Task Run Milestones

The numbering space for tasks is 00-99.  To assist plugins in coordinating
their operations, these are the current "milestones" that are well-defined
and should be adhered to by all plugins that don't want to get glared at.

 * 00 -- All sanity checking (programs, permissions, etc) before anything
   actually gets done.

 * 01 --  $WORKSPACE is created.
 
 * 10 -- `10-partition-image.sh` runs, creates all necessary partitions,
   sets (at least) PARTITIONS[/].
 
 * 20 -- Bootstrap OS installation takes place.
 
 * 80 -- All filesystems are unmounted.
