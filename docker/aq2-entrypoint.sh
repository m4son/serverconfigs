#!/bin/bash
set -e

while read var; do
  [ -z "${!var}" ] && { echo "$var is empty or not set. Yes, even if you aren't playing 3teams, just fill in dummy info. Exiting."; exit 1; }
done << EOF
TEAM_1_NAME
TEAM_2_NAME
TEAM_3_NAME
TEAM_1_MODEL
TEAM_1_SKIN
TEAM_2_MODEL
TEAM_2_SKIN
TEAM_3_MODEL
TEAM_3_SKIN
AQ_HOSTNAME
AQ_PORT
AQ_CONFIG
AQ_MAXCLIENTS
AQ_RCON_PASSWORD
AQ_REDIRECT_SERVER
AQ_TIMELIMIT
AQ_FRAGLIMIT
AQ_ROUNDLIMIT
EOF

if [[ ${AQ_RCON_PASSWORD} = "pleaseupdateme" ]]; then
  echo "You didn't update the AQ_RCON_PASSWORD value!"
  echo "This should be secret and not shared, but simple enough to type."
  echo "It's also adjustable if you want to change it at any time,"
  echo "just change the value in the .env file and restart the server."
  exit 1
fi

## Replace with actual values
sed -i "s/TEAM_1_NAME/${TEAM_1_NAME}/g" /opt/aq2/action/action.ini
sed -i "s/TEAM_2_NAME/${TEAM_2_NAME}/g" /opt/aq2/action/action.ini
sed -i "s/TEAM_3_NAME/${TEAM_3_NAME}/g" /opt/aq2/action/action.ini
sed -i "s/TEAM_1_MODEL/${TEAM_1_MODEL}/g" /opt/aq2/action/action.ini
sed -i "s/TEAM_1_SKIN/${TEAM_1_SKIN}/g" /opt/aq2/action/action.ini
sed -i "s/TEAM_2_MODEL/${TEAM_2_MODEL}/g" /opt/aq2/action/action.ini
sed -i "s/TEAM_2_SKIN/${TEAM_2_SKIN}/g" /opt/aq2/action/action.ini
sed -i "s/TEAM_3_MODEL/${TEAM_3_MODEL}/g" /opt/aq2/action/action.ini
sed -i "s/TEAM_3_SKIN/${TEAM_3_SKIN}/g" /opt/aq2/action/action.ini

## Run q2proded

/opt/aq2/q2proded +set game action \
+set hostname "${AQ_HOSTNAME}" \
+set net_port "${AQ_PORT}" \
+set sv_redirect_address ${AQ_REDIRECT_SERVER} \
+set timelimit ${AQ_TIMELIMIT} \
+set fraglimit ${AQ_FRAGLIMIT} \
+set roundlimit ${AQ_ROUNDLIMIT} \
+exec ${AQ_CONFIG}.cfg
