LOG_FILE=/tmp/roboshop.log
rm -f ${LOG_FILE}

STAT_CHECK() {
  LENGTH=$(echo $2 |awk '{ print length }' )
  echo $LENGTH
  LEFT=$((${MAX_LENGTH} - ${LENGTH}))
  while [ $LEFT -gt 0 ]; do
    SPACE=$(echo -n "|")
    LEFT=$((${LEFT}-1))
  done
  echo $SPACE
  exit
  if [ $1 -ne 0 ]; then
    echo -e "\e[1m${2} - \e[1;31mFAILED\e[0m"
    exit 1
  else
    echo -e "\e[1m${2} - \e[1;32mSUCCESS\e[0m"
  fi
}

set-hostname -skip-apply ${COMPONENT}

DOWNLOAD() {
  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip" &>>${LOG_FILE}
  STAT_CHECK $? "Download ${1} Code"
  cd /tmp
  unzip -o /tmp/${1}.zip &>>${LOG_FILE}
  STAT_CHECK $? "Extract ${1} Code"
}

