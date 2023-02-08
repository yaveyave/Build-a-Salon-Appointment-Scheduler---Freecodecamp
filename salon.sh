#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"


MENU(){
  #if [[ $1 ]]
  #then 
  #  echo -e "\n$1"
  #fi 
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES" | while IFS="|" read  SER_ID NAME
  do 
    echo "$SER_ID) $NAME"
  done
  echo -e Please, enter the service of your choice:
  read SERVICE_ID_SELECTED
 
  SELECT_SERVICE_SELECTED=$($PSQL "SELECT service_id FROM services WHERE $SERVICE_ID_SELECTED = service_id")
  
  if [[ -z $SELECT_SERVICE_SELECTED ]] 
  then 
    echo -e "\nI could not find that service. What would you like today?"
    MENU
  else
    echo "All Right!"
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE '$CUSTOMER_PHONE' = phone ")
    if [[ -z $CUSTOMER_NAME ]]
    then 
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERTAR_NOM_PH=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi
    SERVICES_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo -e "\nWhat time would you like your $SERVICES_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ $SERVICE_TIME ]] 
    then 
      INSERTAR_RESUL=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
      if [[ $INSERTAR_RESUL ]]
      then 
        echo "I have put you down for a $SERVICES_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
      fi
    fi
  fi
}

MENU
