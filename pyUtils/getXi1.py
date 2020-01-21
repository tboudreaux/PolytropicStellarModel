from readCPython import load_C_output
import numpy as np
import argparse


def find_root(x, y):
    idx = (np.abs(y)).argmin()
    return x[idx], y[idx]


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Plot Data')
    parser.add_argument('path', metavar='i', type=str, help="Files to extract Xi1")

    args = parser.parse_args()
    state = load_C_output(args.path)
    x1approx, thetax1approx = find_root(state[0], state[1])

    print(x1approx, thetax1approx)



