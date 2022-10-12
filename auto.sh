############################################################
# Build 2, Rev. Oct 2022                                   #
#                                                          #
# Contributors:                                            #
# Nic Williams, nwillau900@gmail.com            aka Layer8 #
# License info at the very bottom.                         #
#                                                          #
#                                                          #
# For Mac M1 users                                         #
#                                                          #
#!/bin/bash                                                #



############################################################
# Typeface & Variables                                     #
############################################################
# From: https://levelup.gitconnected.com/5-modern-bash-scripting-techniques-that-only-a-few-programmers-know-4abb58ddadad
bold=$(tput bold)
underline=$(tput smul)
italic=$(tput sitm)
info=$(tput setaf 2)
error=$(tput setaf 160)
warn=$(tput setaf 214)
reset=$(tput sgr0)
url= #link to your shared GDrive
dir= #folder where VMs live
vm1= #name of first vm.utm.zip in folder
shavm1= #shasum of vm1.utm.zip
dev= #beta folder within GDrive

############################################################
# Help                                                     #
############################################################
Help()
{
   Start # Start spinner

   # Display Help
   echo "This script builds a local lab environment." ; echo
   echo "Syntax: ./auto -[i|h|u|...]" ; echo
   echo "Options:" ; echo
   echo " -i    Install."
   echo " -h    Print this help menu."
   echo " -u    Uninstall."
   echo " -o    Optional Install."
   echo " -t    Testing."
   echo " -r    Reinstall or Upgrade."
   echo "  *    Don't try anything else." ; echo
   sleep 5

   Stop # Kill spinner
}



############################################################
# Usage                                                    #
############################################################
Usage()
{
  echo "Usage: $0 <flag>"
  echo ; echo "Flags:"
  echo "-i install"
  echo "-u uninstall"
  echo "-h help"
  echo "-t testing (for your mods)"
  echo "-o optional (for extra content)"
  echo "-r reinstall (for remaking VMs)"
  echo "*  please don't try anything else :)"
  1>&2
  exit
}



############################################################
# Install                                                  #
############################################################
Install()
{
  Start # Start spinner

  # Create area for files
  echo ; echo "${info}INFO${reset}: Creating directory ~/Documents/UTM for file installs..." ; echo
  cd ~/Documents/ ; mkdir UTM && wait || Fail "Directory Creation Failed: $?"

  # Install Homebrew
  echo ; echo "${info}INFO${reset}: Installing Homebrew, a script manager for MacOS..." ; echo
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" && wait || Fail "Homebrew Installation Failed: $?"

  # Install Dependencies
  echo ; echo "${info}INFO${reset}: Installing dependencies so applications run properly..." ; echo
  brew install python && wait || Fail "Python Installation Failed: $?"
  brew install pip && wait || Fail "Pip Installation Failed: $?"
  brew install wget && wait || Fail "wget Installation Failed: $?"
  brew install figlet && wait || Fail "Figlet Installation Failed: $?"
  brew install md5sha1sum && wait || Fail "ShaSum Installation Failed: $?"
  brew tap homebrew/autoupdate && wait || Fail "Brew Autoupdate Installation Failed: $?"
  brew autoupdate start 86400 --upgrade && wait || Fail "Brew Autoupdate Start Failed: $?"

  # Install Apps
  echo ; echo "${info}INFO${reset}: Installing applications for use within the lab..." ; echo
  brew install --cask utm && wait || Fail "UTM Installation Failed: $?"
  brew install --cask docker && wait || Fail "Docker Installation Failed: $?"
  brew install --cask discord && wait || Fail "Discord Installation Failed: $?"

  # Wait for user input
  echo ; echo "${warn}WARNING${reset}: The script requires access to your GDrive." ; echo
  echo "You will also need google chrome installed." ; echo
  echo "You will need to ensure:" ; echo
  echo "1. You are logged in to your name@company.com account on both chrome and drive."
  echo "2. You have access to the repository the script pulls up."
  echo ; echo "Press any key to open the GDrive location, please read the manual there if you haven't." ; echo
  while [ true ]
  do
    read -t 3 -n 1
    if [ $? = 0 ]
      then
        # Open GDrive repo
        open -a "Google Chrome" $URL ; break
    else
    echo ; echo "Waiting for the open signal..." ; echo
    fi
  done

  # Wait for user input
  echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo ; echo
  echo "${warn}WARNING${reset}: Continue only if logged into the GDrive Desktop App." ; echo
  echo "Ensure the images are downloaded per manual instructions." ; echo
  echo "Press c to continue." ; echo
  echo "If unable, press e for exit until you have the correct access." ; echo
  count=0
  while :
  do
    read -n 1 k <&1
    if [[ $k = e ]]
      then
        echo ; echo "${error}ERROR${reset}: Quitting from the program, exiting the Matrix..." ; echo ; exit
    elif [[ $k = c ]]
      then
        echo ; echo "${warn}WARNING${reset}: Continuing... Down the rabbit hole..." ; echo ; break
    else =
        ((count=$count+1))
        echo ; echo "${info}INFO${reset}: You didn't select a valid option, press either e or c please..." ; echo
    fi
  done

  # Installing docker images
  echo ; echo "${info}INFO${reset}: Pulling containers for enhanced toolset use..." ; echo
  docker pull metasploitframework/metasploit-framework && wait || Fail "Metasploit Installation Failed: $?"
  docker pull ubuntu && wait || Fail "Ubuntu Installation Failed: $?"

  # UTM image copying, copy 156/157 for each VM
  echo ; echo "${info}INFO${reset}: 'Acquiring' VMs (you wouldn't download a car)..." ; echo
  cd  /Volumes/GoogleDrive ; cd My* ; cd $dir
  cp $vm1.utm.zip ~/Library/Containers/com.utmapp.UTM/Data/Documents/OSX.zip && wait $! || Fail "$vm1 Copy Failed: $?"
  echo "$shavm1 *$vm1.utm.zip" | sha1sum -c - && wait || Fail "$vm1 Checksum Failed: $?"


  # ASCII art
  echo ; echo "${info}INFO${reset}: Beginning Auto build..." ; echo ; echo
  figlet -f slant "auto.sh" ; echo ; sleep 5

  # UTM Configuration
  cd ~/Library/Containers/com.utmapp.UTM/Data/Docduments/
  unzip $vm1.utm.zip && wait || Fail "$vm1 VM Unzip Failed: $?" ; rm $vm1.utm.zip
  echo ; echo "${info}SUCCESS${reset}: Process completed successfully." ; echo

  Stop # Kill spinner
}



############################################################
# Uninstall                                                  #
############################################################
Uninstall()
{
  Start # Start spinner

  echo ; figlet -f slant "Auto.sh" ; echo ; echo "Saying goodbye..." ; echo ; sleep 5

  # Wait for user input
  echo ; echo "Press y for yes." ; echo ; echo "Press n for no." ; echo
  echo "${warn}WARNING${reset}: Do you want to obliterate your local UTM lab, docker containers, and homebrew?" ; echo
  echo "${error}NOTE${reset}: This includes all software from the original install." ; echo
  count=0
  while :
  do
    read -n 1 k <&1
    if [[ $k = n ]]
      then
        echo ; echo "${error}ERROR${reset}: Stopping the madness, to return another day..." ; echo ; exit
    elif [[ $k = y ]]
      then
        echo ; echo "${warn}WARNING${reset}: Scorching the Earth, smashing the stacks..." ; echo ; break
    else =
      ((count=$count+1)) ; echo "${info}INFO${reset}: You didn't select a valid option, press either y or n please..."
    fi
  done

  # Remove area for files
  echo ; echo "${info}INFO${reset}: Removing directory ~/Documents/UTM for file installs..." ; echo
  sudo rm -r ~/Documents/UTM && wait || Fail "UTM Directory Deletion Failed: $?"
  sudo rm -r ~/Library/Containers/com.utmapp.UTM/Data/Docduments/ && wait || Fail "UTM Data Directory Deletion Failed: $?"

  # Uninstall Dependencies
  echo ; echo "${info}INFO${reset}: Uninstalling dependencies so applications run properly..." ; echo
  brew uninstall python && wait || Fail "Python Uninstall Failed: $?"
  brew uninstall pip && wait || Fail "Pip Uninstall Failed: $?"
  brew uninstall wget && wait || Fail "wget Uninstall Failed: $?"
  brew uninstall figlet && wait || Fail "Figlet Uninstall Failed: $?"
  brew uninstall md5sha1sum && wait || Fail "ShaSum Uninstall Failed: $?"

  # Install Apps
  echo ; echo "${info}INFO${reset}: Uninstalling applications for use within the lab..." ; echo
  brew uninstall --cask utm && wait || Fail "UTM Uninstall Failed: $?"
  brew uninstall --cask discord && wait || Fail "Discord Uninstall Failed: $?"
  brew uninstall --cask google-chrome && wait || Fail "Chrome Uninstall Failed: $?"
  brew autoupdate delete && wait || Fail "Brew Autoupdate Stop Failed: $?"
  brew untap homebrew/autoupdate && wait || Fail "Brew Autoupdate Uninstall Failed: $?"
  brew clean && wait || Fail "Brew Clean Failed: $?"

  # Uninstall Docker Images
  echo ; echo "${info}INFO${reset}: Pruning containers for enhanced toolset use..." ; echo
  docker prune && wait || Fail "Docker Prune Failed: $?"
  docker image rm metasploitframework/metasploit-framework && wait || Fail "Metasploit Uninstall Failed: $?"
  docker image rm ubuntu && wait || Fail "Ubuntu Uninstall Failed: $?"
  brew uninstall --cask docker && wait || Fail "Docker Uninstall Failed: $?"

  # Uninstall homebrew
  echo ; echo "${info}INFO${reset}: Uninstalling Homebrew, a script manager for MacOS..." ; echo
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" && wait || Fail "Brew Uninstall Failed: $?"

  Stop # Kill spinner
}



############################################################
# Spinner                                                  #
############################################################
# From: https://willcarh.art/blog/how-to-write-better-bash-spinners
Spinner()
{
  while :
  do
    for s in / - \\ \|
      do printf "\r$s"
      sleep .1
    done
  done
}

spinner_pid=
Start()
{
  set +m
  { Spinner & } 2>/dev/null
  spinner_pid=$!
}

Stop()
{
  { kill -9 $spinner_pid && wait; } 2>/dev/null
  set -m
  echo -en "\033[2K\r"
}



############################################################
# Failure                                                  #
############################################################
Fail()
{
    echo "$1" >&2
    exit 1
}


############################################################
# Optional Installs                                        #
############################################################
# For development work, attempting new modules, etc..
Optional()
{
  sed -n 282,355p SAD-LoL.sh # Show Optional() area of this file by line number.
  # Delete the # and save the file and rerun the script for optional installs.

  # Code Environment
  #brew install --cask atom   # Atom IDE

  # Cybersecurity Stuff
  #brew install john                              # Password hash cracker
  #brew install aircrack-ng                       # WPA password cracker
  #brew install fcrackzip                         # Password protected zip crack
  #brew install nmap                              # Network map
  #brew install mtr                               # Network monitoring tool
  #brew install --cask angry-ip-scanner           # A better nmap
  #brew install --cask wireshark                  # Packet captures
  #brew install --cask ghidra                     # Malware reverse engineering

  # Flightsim - A full-suite DNS exfil toolset
  #brew install go && wait
  #brew install git && wait
  #cd ~
  #git clone https://github.com/alphasoc/flightsim && wait
  #cd flightsim
  #go build && wait
  #./flightsim --help

  # GHOSTS NPC Automation
  #open -a "Google Chrome https://github.com/cmu-sei/GHOSTS
  #cd ~
  #git clone https://github.com/cmu-sei/GHOSTS
  #cd GHOSTS
  #cd src
  #cd Ghosts.api
  #docker-compose up -d
  #open -a "Google Chrome http://localhost:5000/api/home" # API controller
  #open -a "Google Chrome http://localhost:3000" # Grafana instance

  # Mystery Commands
  #curl -s -L http://bit.ly/10hA8iC | bash

  # MITRE Caldera
  #cd ~
  #git clone https://github.com/mitre/caldera.git --recursive
  #cd caldera
  #docker build . --build-arg WIN_BUILD=true -t caldera:latest
  #docker run -p 8888:8888 caldera:latest
  #open -a "Google Chrome" http://localhost:8888
  #login: red/admin
  # Caldera Slack
  #open -a "Google Chrome" https://join.slack.com/t/mitre-caldera/shared_invite/zt-rvngjjpw-OQHAqpUT87DcyClTosF8dQ

  # Games - Shell Programming History :)
  #brew install --cask emacs
  #emacs -batch -l dunnet
  #open -a "Google Chrome" https://gist.github.com/kiedtl/06f728a414a7804826c378b214bf7726
  ###
  #brew install zork
  #open -a "Google Chrome" https://web.mit.edu/marleigh/www/portfolio/Files/zork/transcript.html
  ###
  #brew install open-adventure
  #open -a "Google Chrome" https://almy.us/dungeon.html
  ###
  #brew install cataclysm
  ###
  #ssh sshtron.zachlatta.com

}


############################################################
# Reinstalling Broken VMs                                  #
############################################################
# For development work, attempting new modules, etc..
Reinstall()
{
  Start # Start spinner

  # Wait for user input
  echo ; echo "Press y for yes." ; echo ; echo "Press n for no." ; echo
  echo "${warn}WARNING${reset}: Do you understand this will DELETE VMs?" ; echo
  echo "${error}NOTE${reset}: To change which files are deleted/reinstalled, edit this script by making a local copy and running it." ; echo
  count=0
  while :
  do
    read -n 1 k <&1
    if [[ $k = n ]]
      then
        echo ; echo "${error}ERROR${reset}: Stopping the madness, to return another day..." ; echo ; exit
    elif [[ $k = y ]]
      then
        echo ; echo "${warn}WARNING${reset}: Scorching the Earth, smashing the stacks..." ; echo ; break
    else =
      ((count=$count+1)) ; echo "${info}INFO${reset}: You didn't select a valid option, press either y or n please..."
    fi
  done

  # Remove the old VM images and directories, if you wish to reinstall only one, add a # before the lines you don't want to run
  rm ~/Library/Containers/com.utmapp.UTM/Data/Documents/$vm1.utm && wait $! || Fail "UTM $vm1 Deletion Failed: $?"
  rm -rf ~/Documents/UTM && wait $! || Fail "UTM Folder Delection Failed: $?"
  cd ~/Documents/ ; mkdir UTM && wait || Fail "Directory Creation Failed: $?"

  # UTM image copying
  echo ; echo "${info}INFO${reset}: 'Acquiring' VMs (you wouldn't download a car)..." ; echo
  cd  /Volumes/GoogleDrive ; cd My* ; cd $dir
  cp $vm1.utm.zip ~/Library/Containers/com.utmapp.UTM/Data/Documents/$vm1.utm.zip && wait $! || Fail "$vm1 Copy Failed: $?"
  echo "$shavm1 *$vm1.utm.zip" | sha1sum -c - && wait || Fail "$vm1 Checksum Failed: $?"

  # UTM Configuration
  cd ~/Library/Containers/com.utmapp.UTM/Data/Docduments/
  unzip $vm1.utm.zip && wait || Fail "$vm1 Unzip Failed: $?" ; rm $vm1.utm.zip
  echo ; echo "${info}SUCCESS${reset}: Process completed successfully." ; echo

  Stop # Kill spinner
}


############################################################
# Testing Space                                            #
############################################################
# For development work, attempting new modules, etc..
Test()
{
  cd ~/Documents/UTM
  mkdir dev
  cd dev

  # Pull Dev VMs
  cd / ; cd  /Volumes/GoogleDrive ; cd My* ; cd $dir/dev
  cp Test.utm.zip ~/Library/Containers/com.utmapp.UTM/Data/Documents/Test.utm.zip && wait $! || Fail "Test VM Copy Failed: $?"
  cd ~/Library/Containers/com.utmapp.UTM/Data/Documents/
  echo "testshasum *Test.utm.zip" | shasum -c - && wait || Fail "Test Checksum Failed: $?"
  unzip Test.utm.zip && wait || Fail "VM Unzip Failed: $?" ; rm Test.utm.zip
}



############################################################
############################################################
# Main program                                             #
############################################################
############################################################
# Get the options
[ $# -eq 0 ] && Usage
while getopts "ihuntor" flag
  do
   case ${flag} in
      h) # Display help menu
         echo ; echo "${info}INFO${reset}: You selected help..." ; echo
         Help && wait  || Fail "Help Function Failed: $?"
         ;;

      i) # Run installer
         echo ; echo "${info}INFO${reset}: You selected install..." ; echo ; sleep 2
         Install && wait  || Fail "Install Function Failed: $?" ; echo
         echo "${info}SUCCESS${reset}:Auto Install Successful." ; echo
         ;;

      u) # Run uninstaller
         echo
         echo "${info}INFO${reset}: You selected uninstall..." ; echo ; sleep 2
         Uninstall && wait  || Fail "Uninstall Function Failed: $?" ; echo
         echo "${info}SUCCESS${reset}:Auto Uninstall Successful." ; echo
         ;;

      n) # Easter egg
         Start ; echo ; echo "${error}ERROR${reset}: Launching nuclear warheads..." ; echo
         sleep 2 ; echo ; echo "Say goodbye to all this history:" ; echo ; sleep 1
         cat /usr/share/calendar/calendar.history ; echo
         echo "${warn}EASTER EGG${reset}: Buy me a beer? Venmo: @nicknac_nic" ; Stop
         ;;

     t) # Testing
         echo ; echo "${info}INFO${reset}: You are testing..." ; echo
         (Test && wait)  || Fail "Test Function Failed: $?"
         ;;

     o) # Optional
         echo ; echo "${info}INFO${reset}: You are installing optional software..." ; echo
         Optional && wait  || Fail "Optional Functions Failed: $?"
         ;;

     r) # Reinstall
         echo ; echo "${info}INFO${reset}: You are reinstalling VMs..." ; echo
         Reinstall && wait  || Fail "Reinstall Functions Failed: $?"
         ;;

     \?) # Invalid option catch
         echo ; echo "${info}INFO${reset}: You tried something else..." ; echo ; Usage
         ;;
   esac
done





# MIT Commons Open Source License
#
# Copyright 2022 Nic Williams, aka Layer8
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
