#!/bin/bash

../integrate-nonDegenerate 1 0.00001 0.00001 4 12
python runLaneEmdenCompare.py
