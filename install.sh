#!/bin/bash
# Use only if you need to perform changes on the user system such as installing software

[[ -z $(which mpc) ]] && sudo apt-get install mpc
[[ -z $(which bc) ]] && sudo apt-get install bc