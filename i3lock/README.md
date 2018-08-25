# README

Fork of the popular [i3lock screen saver](https://github.com/i3/i3lock).
I've changed it up so whenever a key press occurs, a camera shot is taken and the taken picture is used as a lock screen wallpaper.

This is an awesome way to leave your workstation seemingly unlocked and when someone tries to mess with it, they will be caught in their tracks.

# How does it work
Once you lock your screen using the lock script in this repo, a screenshot of
your screen(s) is taken and it is used as lock screen for i3lock.

Then if someone presses any key on your keyboard, a photo is taken and it is
used as new lockscreen wallpaper.

So to prevent taking a photo of yourself every time when you're unlocking your
workstation, I've added a little exception to what I said above - a photo will
be taken only if the pressed key is not the 1st character of your password -
thus you won't be taking photos of yourself all the time.

The line you would want to adjust is **453** in i3lock.c - change the
**XKB_KEY** to whatever is the 1st character of your password (the
documentation includes all the possible keys; I've left 7 as an example, my
password does not start with that key)

If you have any other ideas on how to detect a malicious press, feel free to
submit a pull request.

# Requirements
Read the [README of i3lock](https://github.com/i3/i3lock/blob/master/README.md) to get an idea for the libraries you need.
Google is your best friend to find the package names for your distro.

Also, since I'm lazy and I didn't bother to take camera photos and do image
manipulation in c, you will need **ImageMagick** and **streamer**(sudo apt
install streamer). ImageMagick is used to convert and resize images and
streamer is used to take the camera shot.

# Build procedure
Download the i3lock source code and replace **i3lock.c** with the one provided
in this repo.
Then proceed with the build process as normal.
