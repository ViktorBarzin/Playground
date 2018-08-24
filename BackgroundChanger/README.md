# What is this?

Leaving workstations unlocked is a serious security issue that people continue doing.
Finding such a workstation may lead to a compromise to the entire organisation so people need learn to always lock their computers.

Running the **setup.exe** file on a Windows machine would change its wallpaper every time the workstation is unlocked.
To make it less obvious, wallpaper changes occur after a random interval between 5 and 60 minutes.


# How to install

Simply download and run **setup.exe** on any 64 bit Windows machine (tested with Windows 10 editions). The next time the 
workstation is unlocked the background will be changed with a random 4k image.

# How does it work

You can read the source of **setup.ps1** but I'll explain it briefly here:
1. Creates a base directory to store all external files that are needed - jpeg and bmp images
2. Downloads **iex-ps-online.exe** from github which is just an exe wrapper for executing remote powershell scripts via **iex** and **downloadstring**. (I've written this wrapper so it is as stealthy as possible - running a powershell script shows the powershell window for a brief amount of time and I don't want that).
3. Creates a scheduled task that executes **iex-ps-online.exe** on every workstation unlock event (4801)
4. Enables logging of these events, since they are not logged by default
 
#### So what happens when the workstation is unlocked

1. **iex-ps-online.exe** is run.
2. Then it executes the content of **change-background.ps1** script which can be found in this repo(all done without touching the disk) - currently it is simply doing some magic stuff to download a picture and set it as a background image but could always be something more malicious.


PS: The exe files are simple wrappers for the powershell scripts so that the powershell window does not show.

# TODO:
Add a video demonstrating its workings...
