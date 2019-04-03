#!/usr/bin/env bash
#{{{ MARK:Header
#**************************************************************
##### Author: EPERPICH
##### Date: Tue Apr  2 18:08:45 EDT 2019
##### Purpose: bash script to
##### Notes:
#}}}***********************************************************
E_BADARGS=85

if [ ! -n "$1" ]
then
  echo "Usage: `basename $0` argument1 argument2 etc."
  exit $E_BADARGS
fi  
images_folder="`pwd`/images"
teams_folder="`pwd`/teams"
echo

index=1
argString=""

echo "Listing args with \$* (unquoted):"
for arg in $*
do
  pokemon="$images_folder/$arg.png"
  if [ -f $pokemon ]; then
    echo "Arg #$index = $arg"
    let "index+=1"
    pokemonList="$pokemonList$arg"
    argString="$argString $images_folder/$arg.png"
  fi
done             # Unquoted $* sees arguments as separate words. 
echo "Arg list seen as separate words."
echo "$argString"
pokemonList="$pokemonList.png"
echo "$pokemonList"

convert $argString -geometry '+1+1' -gravity center -background none +append "$teams_folder/$pokemonList"
exit 0
