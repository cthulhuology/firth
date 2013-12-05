clear
STTY=$(stty -g)
stty raw -echo
./firth
stty "$STTY"
