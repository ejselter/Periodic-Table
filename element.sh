#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


#define checking functions
 #number
  NUMBER(){
    ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass,properties.melting_point_celsius ,properties.boiling_point_celsius ,types.type FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number='$1'")
  }

  #symbol
  SYMBOL(){
    ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass,properties.melting_point_celsius ,properties.boiling_point_celsius ,types.type FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON properties.type_id=types.type_id WHERE elements.symbol='$1'")
  }

  #name
  NAME(){
    ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass,properties.melting_point_celsius ,properties.boiling_point_celsius ,types.type FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON properties.type_id=types.type_id WHERE elements.name='$1'")
  }

#check if argument exists
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit

else
  case $1 in
  [0-9]*            ) NUMBER $1 ;;
  [A-Z] | [A-Z][a-z]) SYMBOL $1 ;;
  [A-Z][a-z]*       ) NAME $1 ;;
  esac
  
  #get info from variable if provided with number
 
  if [[ -z $ELEMENT_INFO ]]
  then
    echo -e "I could not find that element in the database."
    
  else
    IFS="|"
    read ATOMIC_NUMBER SYMBOL NAME MASS MELT BOIL TYPE <<< $(echo "$ELEMENT_INFO")
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
fi
