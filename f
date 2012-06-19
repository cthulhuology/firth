clear
STTY=$(stty -g)
stty raw
./firth
stty "$STTY"
