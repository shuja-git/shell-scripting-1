#!/bin/bash

source components/common.sh

MAX_LENGTH=$(cat components/*.sh  | grep -v -w cat | grep STAT_CHECK | awk -F '"' '{print $2}'  | awk '{ print length }'  | sort  | tail -1)

if [ $MAX_LENGTH -lt 24 ];then
  MAX_LENGTH=24
fi

NODEJS catalogue