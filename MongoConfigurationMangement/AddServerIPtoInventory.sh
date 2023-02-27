#!/bin/bash

ServerIP=$(terraform output | grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
echo '[all]' > inventory
echo $ServerIP >> inventory
