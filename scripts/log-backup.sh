#!/bin/bash

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3

#log file Path
LOG_RESOURCE_PATH=/var/log/

#Retention Period
RETENTION_PERIOD=10;

#List of Log Files
LOG_FILES=(
    "audit/audit.log"
);


YEAR=$(date +'%Y');
MONTH=$(date +'%m');
DAY=$(date +'%d');


#Get Retention Period
BEFORE_RETENTION_PERIOD_YEAR=$(date --date="$RETENTION_PERIOD days ago" +'%Y');
BEFORE_RETENTION_PERIOD_MONTH=$(date --date="$RETENTION_PERIOD days ago" +'%m');
BEFORE_RETENTION_PERIOD_DAY=$(date --date="$RETENTION_PERIOD days ago" +'%d');

OLD_LOG_PREFIX=$BEFORE_RETENTION_PERIOD_YEAR-$BEFORE_RETENTION_PERIOD_MONTH-$BEFORE_RETENTION_PERIOD_DAY;
NEW_LOG_PREFIX=$YEAR-$MONTH-$DAY;


for LOG_FILE in "${LOG_FILES[@]}"
do
    echo "Backup old "$LOG_FILE" for today $NEW_LOG_PREFIX";
    mv $LOG_RESOURCE_PATH$LOG_FILE $LOG_RESOURCE_PATH$NEW_LOG_PREFIX-$LOG_FILE;

    echo "Create new log file "$LOG_FILE;
    touch $LOG_RESOURCE_PATH$LOG_FILE;

    if [ -f "$LOG_RESOURCE_PATH$OLD_LOG_PREFIX-$LOG_FILE" ]; then
        echo "Delete log file $OLD_LOG_PREFIX-$LOG_FILE";
        rm -f $LOG_RESOURCE_PATH$OLD_LOG_PREFIX-$LOG_FILE;
    fi

done

echo "-----------------------------------------------------------------------------------------------------------------";