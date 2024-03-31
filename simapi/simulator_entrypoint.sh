#!/bin/bash

# Execute the first command
python ./minitwit_simulator.py "http://minitwit-api:5001" true > ./simulator_output.txt

# Execute the second command
pytest ./minitwit_simulator_test.py
