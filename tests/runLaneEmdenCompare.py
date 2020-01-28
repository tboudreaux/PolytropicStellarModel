import numpy as np
from readCPython import load_C_output

if __name__ == "__main__":
    state, meta = load_C_output("../data/laneEmdenDataFile_1.000000-nonDegenerate.dat")
    ftheta = lambda xi: np.sin(xi)/xi

    theta = ftheta(state[0])

    print("Mean Differnce between exact and numeric solution: {}".format(np.mean(theta-state[1])))
