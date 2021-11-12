#!/usr/bin/env bash

# exit if when any command fails
set -e


function checkPip(){
    pip3 --version
}

function checkPython3(){
    python3 --version
}

function checkVirtualEnv(){
    virtualenv --version
}


function checkSysRequirements(){
    if ! checkPython3
    then
        echo "python 3 is not installed on the system, now installing......"
        sudo apt install python3
    elif ! checkPip
    then
        echo "pip3 is not installed on the system now installing......." 
        sudo apt-get -y install python3-pip
    elif ! checkVirtualEnv
    then
        echo "virtualenv is not installed, now installing......"
        pip3 install virtualenv
    fi
}


function parseArgs(){
    unset url
    ARGS=""
    
    VALID_ARGS=$(getopt -o u:,s --long url:,http_server -- "$@")
    if [[ $? -ne 0 ]]; then #if exit status is not 0 i.e last excuted command is not successful
        exit 1;
    fi
    
    eval set -- "$VALID_ARGS"
    while [ : ]; do
        case "$1" in
            -u | --url)
                ARGS="$ARGS $1 $2"
                url=$1
                shift 2
            ;;
            -s | --http_server)
                ARGS="$ARGS $1"
                shift
            ;;
            --) shift;
                break
            ;;
        esac
    done
    
    # exit if --url flag missing
    : ${url:?Missing --url}
    
    # return
    echo $ARGS
}

function runPythonScript(){
    
    # start virtual env
    virtualenv myvenv
    source ./myvenv/bin/activate
    
    # install dependencies
    pip install pywebcopy
    pip install requests
    
    # run python and pass arguments
    python ./args.py $@
}

function cleanup(){
    # cleanup
    deactivate
    rm -rf ./myvenv
}


function main(){
    checkSysRequirements
    FLAGS=$(parseArgs $@)
    echo $FLAGS
    runPythonScript $FLAGS
    cleanup
}

main $@ #$@ passes all the arguments passed to the script to the main function

