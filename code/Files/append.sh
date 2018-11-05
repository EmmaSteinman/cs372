#!/usr/bin/env bash
COUNTER=0
while [ $COUNTER -lt 5000 ]; do
  echo a >> file1
  echo COUNTER $COUNTER
  let COUNTER=COUNTER+1
done
