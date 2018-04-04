#! /bin/bash

# Crontab list for Check_mk or nagios 
#
# list of system crontab only in /var/spool
# 
# (c) 2018, Edoardo Marchetti <marchetti.edoardo@gmail.com>
# https://github.com/jas31085/Libra_310-Script-Collection
#

# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

while [[ -n "$1" ]]; do
  case $1 in
    --help | -h | *)
      sed -n '2,9p' "$0" | tr -d '#'
      exit 3
      ;;
  esac
  shift
done

# info distro linux
if [[ -f /etc/os-release ]]; then
	OS=$(cat /etc/os-release | grep -i "^id=" | sed 's/ID=//' | sed 's/\"//g')
fi

# crontab dir for distro linux
if [[ $OS == "debian" ]]; then
	CRON_FILE="/var/spool/cron/crontabs/*"
	elif [[ $OS == "centos" ]]; then
	 	CRON_FILE="/var/spool/cron/*"
fi


#list of user with cron jobs
EXITCODE=0
echo "<<<crontab>>>"

for f in $CRON_FILE
do
	# List user
	USER=$(echo $f | awk -F "/" '{print $NF}')
	# FILE=$(echo $f | grep -v "#" | grep -v "^[A-Z]")

	#lettura singolo file per info
	i=1
	while read line; do

		NAME="$(echo "$line"| grep -v "#" | grep -v "^[A-Z]" |cut -d " " -f 6-)"
		MINUTE="$(echo "$line" | grep -v "#" | grep -v "^[A-Z]" | awk '{print $1}')"
		HOUR="$(echo "$line" | grep -v "#" | grep -v "^[A-Z]" | awk '{print $2}')"
		Day_of_MONTH="$(echo "$line" | grep -v "#" | grep -v "^[A-Z]" | awk '{print $3}')"
		MONTH="$(echo "$line" | grep -v "#" | grep -v "^[A-Z]" | awk '{print $4}')"
		Day_Of_Week="$(echo "$line" | grep -v "#" | grep -v "^[A-Z]" | awk '{print $5}')"

		# se la linea è piena stampa le info
		if [[ -n "$NAME" ]]; then
											# user  command m h dom mon dow 
		 	echo $EXITCODE" Crontab-"$USER$i" - User: "$USER" - m: "$MINUTE" - H: "$HOUR" - DoM: "$Day_of_MONTH" - M: "$MONTH" - DoW: "$Day_Of_Week" - Exec: "$NAME
		 	i=$((i + 1))
		fi
	done <$f	
done




