grep -Eio "invalid user .+ " auth.log | awk '{print $3}' | sort | uniq -c > invalid_user.sh

or

grep -Eio "invalid user .+ \[" auth.log | awk '{print $3}' | sort | uniq -c > invalid_user.sh

or

grep -Eio "invalid user .+ [preauth]" auth.log | awk '{print $3}' | sort | uniq -c > invalid_user.sh
