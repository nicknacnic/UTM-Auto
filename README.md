# UTM Auto-Installer

**UTM Auto-Installer** is a shell script that allows users to automate deploying lab environments at scale.

## Installation

Clone the latest repository [GitHub](https://github.com/nicknac_nic/UTM-Auto).

Prior to deploying this script, you will want to go to [UTM's Gallery](https://mac.getutm.app/gallery/) to create your own VMs. Then you will want to share those VMs, compress them, and put them in a shared GDrive folder (mine has both 'stable' and 'dev' folders for testing), get the shasum of them as well.

Have end users make a shortcut to that folder in their drive, and then within Finder, find that directory, right click, and make it available offline. This predownloads the VMs onto user machines.

Edit auto.sh install, uninstall, and test functions to include your VM names and hashes. Put it in the same drive as the VMs, run the below (your filenames may vary):

                  cd / ; cd  /Volumes/GoogleDrive ; cd My* ; cd UTM-Auto-Install/install ;
                  chmod +x auto.sh ;
                  ./auto.sh -i && wait 



## Running auto.sh

This script utilizes GDrive Desktop on Mac M1 and UTM to properly build a lab. Usage:

```
$ ./auto.sh -h

This script builds a local lab environment.

Syntax: ./auto.sh -[i|h|u|...]

Options:

 -i    Install.
 -h    Print this help menu.
 -u    Uninstall.
 -o    Optional Install.
 -t    Testing.
 -r    Reinstall or Upgrade.
 -*    Don't try anything else.

```

The script options work as follows:

## Description of flags

_____________________________________________________________________________________________
| Flag      | Description                                                                   |
| --------- | ----------------------------------------------------------------------------- |
| -h        | Displays help menu                                                            |
| -i        | Runs the install script, installing homebrew, docker, utm, and pulling VMs    |
| -u        | Uninstalls all the above                                                      |
| -o        | Optional installs, requires user edit to uncomment desired packages           |
| -t        | Test, for script maintainers or beta program users to install other VMs       |
| -r        | Reinstall, for when beta goes to prod or someone corrupts a VM                |
---------------------------------------------------------------------------------------------
