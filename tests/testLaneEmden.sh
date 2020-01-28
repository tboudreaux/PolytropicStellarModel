#!/bin/bash

echo "Running Integration"
../integrate-nonDegenerate 1 0.00001 0.00001 4 12
echo "Integration Complete. Finding Exact Solution"
python runLaneEmdenCompare.py
echo "Cleaning Up"
rm ../data/laneEmdenDataFile_1.000000-nonDegenerate.dat
