#!/bin/sh

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

function show_help {
	echo "./compile_and_flash [-f [-p SERIALPORT]] -u UEBUNG -a AUFGABE"
	echo "    -f"
	echo "       Flashe den ASURO nach dem Kompilieren mit asurocon"
	echo "    -p SERIALPORT"
	echo "       Benutze SERIALPORT zum Flashen (default: /dev/ttyS0)"
}

flash=0
serialport="ttyS0"
while getopts "h?u:a:fp:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    v)  verbose=1
        ;;
    u)  uebung=$OPTARG
        ;;
    a)  aufgabe=$OPTARG
        ;;
    f)  flash=1
        ;;
    p)  serialport=$OPTARG
	;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [ -z $uebung ]; then
	echo "-u UEBUNG nicht angegeben"
	show_help
	exit 1
fi
if [ -z $aufgabe ]; then
	echo "-a AUFGABE nicht angegeben"
	show_help
	exit 2
fi

OLDDIR=$(pwd)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd "$DIR"
cd "Übung $uebung";
make clean
make all TARGET="aufgabe$aufgabe";
make clean_nohex

if [ $? -eq 0 ] && [ $flash -eq 1 ]; then
	asuro-flashtool -$serialport "aufgabe$aufgabe.hex"
fi

cd "$OLDDIR"
exit $?
