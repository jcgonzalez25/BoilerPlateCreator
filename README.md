# Creates Language Boiler Plates For Bash Terminal
## Usage 
`boiler <languageOfBoiler> [option] [FileName]`
## Base Example:
`>boiler c example1`
Creates a c file named example1.c with all the default libraries and a main function
### Options
---
### -ex 
  Creates boiler plate file of <strong>languageOfBoiler</strong> with a excercise question relative to <strong>languageOfBoiler</strong>
  ##### Example: Creating a js exercise file
  `>boiler js -ex`
  ##### Note: Will be prompted with categories of exercise problems i.e loops,algorithms,recursion etc.

### -addTo PathToFile(s)
Appends link to File or Files
##### Example: Creates css file called app and appends a link to app.css in index.htm
`>boiler css -addTo index.html app` 
### -include PathToFile(s)
Creates boiler plate file of a languageOfBoiler with a question relative to languageOfBoiler
##### Example: Creates an html file called app.html that has all the .js files and .css files linked onto it
`>boiler html -include *.js *.css app` 
##### Note For -addTo and -include options:
-Path may be relative <br>
-All Arguments must have an extension or will throw an error

### -help
Help with boiler usage, information on options and usage will be displayed
