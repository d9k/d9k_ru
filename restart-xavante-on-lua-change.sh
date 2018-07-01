#!/bin/bash

# before script run do "sudo apt install inotify-tools"

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
XAVANTE_PID=

cd ${PROJECT_DIR}

function stopOtherInstances {
   ps aux | grep -i "${PROJECT_DIR}/start-server.lua" | grep -v "^grep" | awk {'print $2'} | xargs -I __file__ kill -9 __file__  2>/dev/null
}

function restartXavante {
  if [[ -n "$XAVANTE_PID" ]]; then
    kill $XAVANTE_PID
    sleep 1
  fi
  lua $PROJECT_DIR/start-server.lua &
  XAVANTE_PID=$!
  echo "Xavante process id is ${XAVANTE_PID}"
}

stopOtherInstances #()
restartXavante #()

# kill child processes on exit:
# (https://stackoverflow.com/a/11697822/1760643)

function killChildProcAndExit {
  jobs -p | xargs kill 2>/dev/null
  exit
}

function onSigKill {
  stopOtherInstances #()
  killChildProcAndExit #()
}

# unable to set SIGKILL trap on Linux (WHAAAAI?)
trap onSigKill SIGINT SIGTERM

while true; do
    #echo "something happened"
    #filename=$(inotifywait -t 10 -e MODIFY -r -q --format "w=%w | f=%f | e=%e" .)
    #filename=$(inotifywait -r -q --format "w=%w | f=%f | e=%e" "${PROJECT_DIR}"); echo $filename; continue
    filename=$(inotifywait -e MODIFY -e CREATE -e DELETE -r -q --format "%w%f" "${PROJECT_DIR}")
    if [[ "$filename" == "" ]]; then
      #echo "just rescan"
      continue
    fi

    if echo "$filename" | grep -q "^$PROJECT_DIR/runtime"; then
      echo "runtime file \"$filename\" changed. no restart"
      continue
    fi

    if [[ "$filename" == *.lua ]]; then
      echo "[$(date --rfc-3339=seconds)] File \"$filename\" changed. Restarting xavante.."
      restartXavante
    fi
    #echo "$filename"
done
