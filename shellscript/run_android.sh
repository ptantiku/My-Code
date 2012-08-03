#!/bin/bash
########################################
# Run android emulator named "Test_ICS #
# usage: ./run_android.sh              #
# developer: ptantiku                  #
########################################

emulator -no-snapshot -cpu-delay 0 -no-boot-anim -cache ./cache -avd Test_ICS
