# UCIB Host Support Plugins

These plugins are a little different to most, because rather than being
loaded individually as requested, they are *all* loaded at startup, and only
*one* of them is expected to actually do anything useful.

Essentially, host plugins should only have an `init.sh`, and they should
look something like this:

    if <some test to see if we're on the relevant OS>; then
        <define functions>
    fi
