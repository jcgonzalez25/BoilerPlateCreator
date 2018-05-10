#!/bin/bash

includeFiles=()
languageOfIncludeFiles=()
addToFiles=()
languageOfAddToFiles=()
forFlagInput=()
includeFlagInput=()
languages=( php css html c js java )
commandInput=($*)
[[ ${#commandInput[@]} -eq 0 ]] && exit 1
sizeOfCommand=${#commandInput[@]}
language="${commandInput[0]}"
nameOfFile="${commandInput[-1]}"
include=()

#launch to be used by both excercise feature and boiler creation feater
#last minute change

#making editor visible to the networking functions
editor=
function launch(){
  editor=$1
  case "$editor" in
    "vim")
       vim "$2"
     ;;
     "vi")
       vi "$2"
     ;;
     "pico")
       pico "$2"
     ;;
     "nano")
       nano "$2"
     ;;
     "kate")
       kate "$2"
     ;;
  esac
  printf "FILE:\n %s \nHAS BEEN CREATED\n" "$2"
}

#
#  BOILER PLATE CREATOR FUNCTIONS 
#

function printC(){
  index=0
  for l in ${languageOfIncludeFiles[@]};do
    if [[ $l == "c" ]];then
      printf "#include<%s>\n" "${includeFiles[$index]}"
    fi
    let index+=1 
  done
}
function createC(){
  printf "#include<stdio.h>\n#include<stdlib.h>\n#include<string.h>\n"
  [[ $# -eq 1 ]] && printf "/*%s*/\n" "$1"
  printC
  printf "int main(int argc, char *argv[]){\n}"
}
function createPython(){
  [[ $# -eq 1 ]] && printf "\"\"\"%s\"\"\"\n" "$1"
}
function createJava(){
  [[ $# -eq 1 ]] && printf "/*%s*/" "$1"
  printf "class $nameOfFIile\n{\n\tpublic static void main(String[] args)\n\t{\n\t}\n}"
}
function printPHP(){
  index=0
  for l in ${languageOfIncludeFiles[@]};do
    if [[ $l == "php" ]];then
      printf "\n include '%s'" "${includeFiles[$index]}"
    fi
    let index+=1 
  done
}
function createPhp(){
  printf "<?php\n"
  [[ $# -eq 1 ]] && printf "/*%s*/\n" "$1"
  printPHP
  printf "\n//php CODE HERE\n?>"
}
function createJavascript(){
  question="//$1"
  printf "$question"
}
#NOTE: printCSS & printJS function are for html file linking
function printCSS(){
  index=0
  for l in ${languageOfIncludeFiles[@]};do
    if [[ $l == "css" ]];then
      printf "\n  <link rel='stylesheet' href='%s'>" "${includeFiles[$index]}"
    fi
    let index+=1 
  done
}
function printJS(){
  index=0
  for l in ${languageOfIncludeFiles[@]};do
    if [[ $l == "js" ]];then
      printf "\n<script src='%s'></script>" "${includeFiles[$index]}"
    fi
    let index+=1 
  done
}
function createHtml(){
  printf "<!DOCTYPE html>\n<html>\n<head>"
  printCSS
  printf "\n  <title>Page Title</title>\n</head>\n<body>\n  <!--Code -->"
  printJS
  printf "\n</body>\n</html>"
}
function createCss(){
  printf ""
}
#
# END OF BOILER PLATE CREATOR FUNCTIONS 
#



#
#  TODOS 
#    IMPLEMENT INOTIFY ON THE CREATED FILE EXCERCISE QUESTION 


#
#  FUTURE 
#    add multiple languages!
#




#
#  NETWORKING EXCERICISE FUNCTIONS
#
links=()
excerciseTopics=()
indexOfChoosenExcecise=
usersEditor=
function getTopicFrom(){
  ln=$1
  ln=$(echo "$ln" | cut -d / -f 3)
  ln=$(echo "$ln" | cut -d . -f 1)
  echo "$ln"
}
function createLinks(){
  betaLinks=$1
  webRoot="https://www.w3resource.com"
  for betaLink in ${betaLinks[@]};do
    excerciseTopics+=($(getTopicFrom "$betaLink"))
    betaLink=$(echo "$betaLink"|tr -d \")
    links+=($webRoot$betaLink)
  done
}
function getExcerciseTopics(){
  
  if [[ $language == "js" ]];then
    webData="$(wget https://www.w3resource.com/javascript-exercises/ -q -O -)"
    betaLinks="$(echo "$webData" | grep '.*<li><a href="/javascript-exercises.*' )"
    betaLinks="$(echo "$betaLinks" | sed 's|.*href=||')"
    betaLinks=($(echo "$betaLinks" | sed 's|>.*||'))
    createLinks $betaLinks
  elif [[ $language == "c" ]];then
    webData="$(wget https://www.w3resource.com/c-programming-exercises/ -q -O -)"
    betaLinks="$(echo "$webData" | grep '<li><a href=".*/c-programming-exercises.*' )"
    betaLinks=${betaLinks//https:\/\/www.w3resource.com/}
    betaLinks="$(echo "$betaLinks" | sed 's|.*href=||')"
    betaLinks=($(echo "$betaLinks" | sed 's|>.*||'))
    createLinks $betaLinks
  elif [[ $language == "php" ]];then
    webData="$(wget https://www.w3resource.com/php-exercises/ -q -O -)"
    betaLinks="$(echo "$webData" | grep '<li><a href=".*/php-exercises.*' )"
    betaLinks=${betaLinks//https:\/\/www.w3resource.com/}
    betaLinks="$(echo "$betaLinks" | sed 's|.*href=||')"
    betaLinks=($(echo "$betaLinks" | sed 's|>.*||'))
    createLinks $betaLinks
  elif [[ $language == "python" ]];then
    webData="$(wget https://www.w3resource.com/python-exercises/ -q -O -)"
    betaLinks="$(echo "$webData" | grep '<li><a href=".*/python-exercises.*' )"
    betaLinks=${betaLinks//https:\/\/www.w3resource.com/}
    betaLinks="$(echo "$betaLinks" | sed 's|.*href=||')"
    betaLinks=($(echo "$betaLinks" | sed 's|>.*||'))
    createLinks $betaLinks
    #TO DO FIGURE OUT PYTHON IMPLEMENTATION
  elif [[ $language == "java" ]];then
    webData="$(wget https://www.w3resource.com/java-exercises/ -q -O -)"
    betaLinks="$(echo "$webData" | grep '<li><a href=".*/java-exercises.*' )"
    betaLinks=${betaLinks//https:\/\/www.w3resource.com/}
    betaLinks="$(echo "$betaLinks" | sed 's|.*href=||')"
    betaLinks=($(echo "$betaLinks" | sed 's|>.*||'))
    createLinks $betaLinks
  fi
  count=0
}
function promptExcercises(){
  count=0
  for ln in "${excerciseTopics[@]}";do
    printf "%d->%s\n" "$count" "$ln"
    let count++
  done

}
function getExcerciseQuestion(){
  oldIFS="$IFS"
  IFS=$'\n'
  let questionNumber="$2"-1
  excerciseLink="$1"
  excerciseWebData="$(wget $excerciseLink -q -O -)"
  excerciseWebData=$(echo "$excerciseWebData" | grep -E '<p.*' | grep -E '<strong>[0-9]' | sed -e 's/<[^>]*>//g' | sed 's|Go to the editor||g')
  excerciseWebData=($(echo "$excerciseWebData"))
  echo "${excerciseWebData[$questionNumber]}"
  IFS="$oldIFS"
}
function collectUnansweredQuestionNumber(){
  topic="$1"
  statisticFile="~/\.boilerExcerciseStatistics"
  if grep "$topic" ~/\.boilerExcerciseStatistics &> /dev/null;then
    statsForTopic=$(grep "$topic" ~/\.boilerExcerciseStatistics)
    oldIFS=$IFS 
    IFS="@"
    questions=($(grep "$1" ~/\.boilerExcerciseStatistics))
    sed -i "s|$statsForTopic|DELETE|g" ~/\.boilerExcerciseStatistics
    sed -i '/DELETE/d' ~/\.boilerExcerciseStatistics
    statsForTopic="$statsForTopic""@""${#questions[@]}"
    echo "$statsForTopic" >> ~/\.boilerExcerciseStatistics
    let question="${#questions[@]}"
    echo "$question"
    IFS=$oldIFS
  else
    echo "$topic""@1" >> ~/\.boilerExcerciseStatistics
    echo "1"
  fi
}
function createQuestionFile(){
  topic="$1"
  question="$2"
  questionNumber=$(echo "$question" | head -c 1)
  qFileName="$questionNumber""${excerciseTopics[$indexOfChoosenExcecise]}"
  if [[ "$language" == "js" ]];then
    qFileName="$qFileName"".js"
    createJavascript "$question" >> "$qFileName"
  elif [[ "$language" == "c" ]];then
    createC "$question" >> "$questionNumber""${excerciseTopics[$indexOfChoosenExcecise]}"".c"
    qFileName="$qFileName"".c"
  elif [[ "$language" == "php" ]];then
    createPhp "$question" >> "$questionNumber""${excerciseTopics[$indexOfChoosenExcecise]}"".php"
    qFileName="$qFileName"".php"
  elif [[ "$language" == "python" ]];then
    createPython "$question" >> "$questionNumber""${excerciseTopics[$indexOfChoosenExcecise]}"".py"
    qFileName="$qFileName"".py"
  elif [[ "$language" == "java" ]];then
    createJava "$question" >> "$questionNumber""${excerciseTopics[$indexOfChoosenExcecise]}"".java"
    qFileName="$qFileName"".java"
  fi
  topic="$1"
  launch "$editor" "$qFileName"
}
ChoosenTopicUrl=""
questionNumber=
function createExcerciseFile(){
  ChoosenTopicUrl=$1
  questionNumber=$(collectUnansweredQuestionNumber "$ChoosenTopicUrl")
  question=$(getExcerciseQuestion "$ChoosenTopicUrl" "$questionNumber")
  createQuestionFile "$ChoosenTopicUrl" "$question"

}
function handleChoosenExcercise(){
  choosen=$1
  numberOfExcercises=${#links[@]}
  if [[ $choosen -gt $numberOfExcercises  ]] || [[ $choosen -lt 0 ]] || [[ $choosen -eq $numberOfExcercises ]];then
    echo "Sorry Choice Invalid File Excercise Not Created"
    exit 1
  fi
  #Passing Actual URL
  createExcerciseFile "${links[$choosen]}"
  

}
function initExcercise(){
  getExcerciseTopics
  if [[ $language == "js" ]];then
    printf "you have choosen JS EXERCISES please Choose By Number\n------------------\n"
  elif [[ $language == "c" ]];then
    printf "You Have Choosen C Exercises please Choose By Number\n-------------------\n" 
  elif [[ $language == "php" ]];then
    printf " You HaveChoosen PHP Exercises Please Choose By Number\n-----------------\n"
  elif [[ $language == "python" ]];then
    printf " You HaveChoosen PYTHON Exercises Please Choose By Number\n-----------------\n"
    printf "NOTE: python practice might have bugs\n"
  fi
  promptExcercises
  read -p 'CHOICE > ' choosenExcercise
  indexOfChoosenExcecise=$choosenExcercise
  handleChoosenExcercise "$choosenExcercise"

}

#
#  END OF NETWORKING EXCERCISE FEATURE
#


function printError(){
  printf "INVALID COMMAND USAGE run boiler -help for guidance\n"
  exit 1
}
function indexFileByLanguage(){
  whatArray=$2
  if [[ ! $1 =~ .*\..*  ]];then
    printf "FILE:%s HAS NO EXTENSION NAME\n" $1
    exit
  fi
  lang=$(printf "%s" $1 | cut -d '.' -f 2)
  if [[ $whatArray == "include" ]];then
    languageOfIncludeFiles+=($lang)
  elif [[ $whatArray == "addto" ]];then
    languageOfAddToFiles+=($lang)
  fi
}
function getFlagInputAtIndex(){
  indexOffset=$1
  flag=$2
  [[ "$flag" == "-include" ]] && endPoint="-addto"
  [[ "$flag" == "-addto" ]] && endPoint="-include"
  
  for (( i=$indexOffset ; i < $sizeOfCommand - 1; i++ ));do
    [[ "${commandInput[$i]}" == "$endPoint" ]] && break  
    if [[ $flag == "-include" ]];then
      includeFiles+=(${commandInput[$i]})
      indexFileByLanguage ${commandInput[$i]} "include"
    elif [[ $flag == "-addto" ]];then
      addToFiles+=(${commandInput[$i]})
      indexFileByLanguage ${commandInput[$i]} "addto"
    fi
  done

  if [[ $flag == "-include" ]];then
    [[ ${#includeFiles[@]} -eq 0 ]] && printError 
  elif [[ $flag == "-addto" ]];then
    [[ ${#addToFiles[@]} -eq 0 ]] && printError
  fi
}

function pursueOption(){
  flag=$1
  readyForArgs="false"
  currentIndex=0
  for com in ${commandInput[@]};do
    [[ $currentIndex -eq $sizeOfCommand ]] && break
    if [[ "$readyForArgs" == "true" ]];then
      let readyForArgs="done"
      getFlagInputAtIndex $currentIndex $flag
    fi
    if [[ "$com" == "$flag" ]];then
      readyForArgs="true"
    fi
    let currentIndex+=1
  done
}
function printHelpMessage(){
  #sorry for the long printf
  printf "Create Boiler Files\nUSAGE: boiler \e[4mlanguageOfBoiler\e[0m [option] [FileName]\n\t-ex\t CREATES EXERCISE FILE W/ QUESTION \e[4mNO FILE NAME NEEDED\e[0m\n\t-addTo   <files>\tadd Boiler To <files>\n\t-include <files>\tinclude   <files> in boiler file\n\t-help\t help on boiler command usage\nNOTE: -addto & -include file(s) must have an extension (i.e. somefile.js somefile.php)\nEXAMPLE:\n\t>boiler html -include *.js *.css app\n\t-Creates an html file called app.html that has all \n\tthe .js files and .css files linked onto it\n\t>boiler js -ex\n\t-Creates a javascript exercise file\n\t>boiler c example1\n\t-Creates a c file named example1.c with all the \n\tdefault libraries and a main function\n"
  exit 0

}
function initCommandArguments(){
  if [[ $sizeOfCommand -eq 0 ]];then
    printError
    exit 1
  elif [[ $sizeOfCommand -eq 1 ]];then
    [[ ${commandInput[0]} == "-help" ]] || printError
    printHelpMessage 
  elif [[ $sizeOfCommand -eq 2 ]];then
    if [[ ${commandInput[-1]} == "-ex" ]];then
      initExcercise
      exit 0
    fi 
  elif [[ $sizeOfCommand -gt 2 ]];then 
      if [[ "${commandInput[1]}" == "-include" ]];then
	pursueOption "-addto"
	getFlagInputAtIndex 2 "-include"
      elif [[ "${commandInput[1]}" == "-addto" ]];then 
	pursueOption "-include" 
	getFlagInputAtIndex 2 "-addto"
      else
        printError 
      fi    
  fi
}
function validLanguage(){
  #Minor Fix 
  [[ ${commandInput[-1]} == "-help" ]] && return 0
  for l in ${languages[@]};do
    if [[ "$language" == "$l" ]];then
      return 0
    fi
  done
  return 1
}
function checkDuplicate(){
  for file in *;do
    if [[ $file == "$nameOfFile.$language" ]];then
      printf "File Name: %s.%s Already Exists\n" $nameOfFIile $language
      exit 1
    fi
  done
}
function checkCommandForValidFileName(){
  if [[ ${commandInput[-1]} =~ .*\..* ]];then 
    printf "INVALID COMMAND USAGE\n%s can not contain a extension\nor no file name was given\n\nboiler -help for more info\n" $nameOfFile
    exit 1
  fi
}
function initialErrorChecking(){
  checkCommandForValidFileName
  if ! validLanguage;then
    printf "boiler: Language %s is not found\nuse boiler -help for info on boiler command\n" $language
    exit 1
  fi
  checkDuplicate
}
function checkAllAddToFilesExist(){
  for aFile in ${addToFiles[@]};do
    if [[ ! -f $aFile ]];then
      printf "add to file %s doesnt exist\n" $aFile
      exit 1
    fi
  done
}
function addLinkTo(){
  fileToAddLink=$1 
  languageOfTheFile=$2
  boilerLanguage=$3
  #languageofthefile where links will be added
  if [[ $languageOfTheFile == "html" ]];then
    if [[ $boilerLanguage == "js" ]];then
      sed -i 's|</body>|\ninsert\n</body>|g' $fileToAddLink
      link="<script src='$nameOfFile'></script>"
      commd="s|insert|"$link"|g"
      sed -i "$commd" $fileToAddLink
    elif [[ $boilerLanguage == "css" ]];then
      sed -i 's|<head>|<head>\ninsert|g' $fileToAddLink
      link="<link rel='stylesheet' href='"$nameOfFile"'></link>"
      commd="s|insert|"$link"|g"
      sed -i "$commd" $fileToAddLink
    fi
  elif [[ $languageOfTheFile == "php" ]];then
    if [[ $boilerLanguage == "php" ]];then
      firstLine=$(head -n 1 $fileToAddLink)
      commd="s|"$firstLine"|"$firstLine"INSERTME|g"
      sed -i "$commd" $fileToAddLink
      link="include '"$nameOfTheFile"'\n"
      commd="s|INSERTME|"$link"|g"
      sed -i "$commd" $fileToAddLink
    else
      printf "PHP FILE CAN NOT BE LINKED TO OTHER SOURCES" 
      exit 1
    fi
  fi
}
function implementAddToFlag(){
  index=0
  for f in ${addToFiles[@]};do
    addLinkTo $f ${languageOfAddToFiles[$index]} $language
    let index+=1 
  done
}
function addToFilesFor(){
  if [[ ${#addToFiles[@]} -gt 0 ]];then
    checkAllAddToFilesExist 
    implementAddToFlag 
  fi
}
editors=( vim vi pico nano kate )
function configureBoilerSettings(){
  if [[ $1 -lt 0 || $1 -ge ${#editors[@]} ]];then
    printf "YOU MUST CHOOSE BETWEEN LIST GIVEN\n"
    exit 1
  else 
    printf "autoEditor:true\neditor:%s" "${editors[$1]}" >> ~/.boilersettings
  fi  
}
function launchEditor(){
  autoEditorSetting=`grep "autoEditor" $HOME/\.boilersettings`
  if [ -z $autoEditorSetting ];then
    printf "Would you Like To Auto Launch a specified Editor On Boiler Creation?(y/n)\n" 
    read input
    if [[ $input == "y" ]];then
      printf "What Editor Would You Like To Launch Automatically?\n"
      printf "CHOOSE BY NUMBER\n0->vim\n1->vi\n2->pico\n3->nano\n4->kate\n"
      read editorIndexChoosen
      printf "Are you sure?\n" 
      read checker
      if [[ $checker == "y" || $checker == "yes" ]];then
        configureBoilerSettings $editorIndexChoosen 
      elif [[ $checker == "n" || $checker == "no" ]];then 
        launchEditor
      else
        printf "INPROPER INPUT $checker\n"
	exit 0
      fi
    elif [[ $input == "n" ]];then
      printf "Auto Editor Setting Disable, you may edit the .boilersetting file in your home directory if you wish to enable\n"
    fi
  else
    if [[ $autoEditorSetting = *"true"* ]];then
      usersEditor=`grep 'editor' $HOME/.boilersettings | cut -d':' -f2`
      launch "$usersEditor" "$1"
    fi
  fi
}
function handleLanguage(){
  boilerLanguage=$1
  nameOfFile="$nameOfFile.$boilerLanguage"
  if [[ "$boilerLanguage" == "php" ]];then
    createPhp >> "$nameOfFile"  
  elif [[ "$boilerLanguage" == "c" ]];then
    createC >> "$nameOfFile" 
  elif [[ "$boilerLanguage" == "js" ]];then
    createJavascript >> "$nameOfFile" 
  elif [[ "$boilerLanguage" == "html" ]];then
    createHtml >> "$nameOfFile" 
  elif [[ "$boilerLanguage" == "node" ]];then
    createNode >> "$nameOfFile"
  elif [[ "$boilerLanguage" == "css" ]];then
    createCss >> "$nameOfFile"
  elif [[ "$boilerLanguage" == "java" ]];then
    createJava >> "$nameOfFile" 
  fi
  addToFilesFor $boilerLanguage
  launchEditor "$nameOfFile" 
}
function main(){
  initialErrorChecking
  initCommandArguments
  handleLanguage "$language"
}
main
