#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
# insert teams
cat games.csv | while IFS="," read YEAR _ WINNER OPPONENT _ _
do
  if [[ $YEAR != 'year' ]]
  then
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER=$($PSQL "insert into teams(name) values('$WINNER');")
    fi
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT=$($PSQL "insert into teams(name) values('$OPPONENT');")
    fi
  fi
done

# insert games
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
    INSERT_GAME=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS);")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
  fi
done