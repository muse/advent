DAY=$1
URL=http://adventofcode.com/2018/day/$DAY/input

if [[ ! -f srv/$DAY.in ]]; then
    source dev/session
    curl -# --cookie "session=$SESSION" -L $URL > srv/$DAY.in
fi
