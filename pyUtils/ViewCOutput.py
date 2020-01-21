#!/usr/bin/env python
# coding: utf-8


from readCPython import load_C_output
from getXi1 import find_root

import matplotlib.pyplot as plt
import numpy as np
import os
import argparse

import matplotlib as mpl

def set_style():
    plt.rc('text', usetex=True)
    plt.rc('font', family='Serif')


    mpl.rcParams['figure.figsize'] = [10, 7]
    mpl.rcParams['font.size'] = 17

    mpl.rcParams['savefig.dpi'] = 150
    mpl.rcParams['xtick.minor.visible'] = True
    mpl.rcParams['ytick.minor.visible'] = True
    mpl.rcParams['xtick.direction'] = 'in'
    mpl.rcParams['ytick.direction'] = 'in'

    mpl.rcParams['xtick.top'] = True
    mpl.rcParams['ytick.right'] = True

    mpl.rcParams['xtick.major.size'] = 6
    mpl.rcParams['xtick.minor.size'] = 3

    mpl.rcParams['ytick.major.size'] = 6
    mpl.rcParams['ytick.minor.size'] = 3

    mpl.rcParams['xtick.labelsize'] = 13
    mpl.rcParams['ytick.labelsize'] = 13


def extract_theta_dot_xi(dataFiles):
    STATE = list()
    N = list()
    for dataFile in dataFiles:
        N.append(float(dataFile.split("_")[1][:-7]))
        STATE.append(load_C_output(dataFile))
    return N, STATE


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Plot Data')
    parser.add_argument('files', metavar='<path/to/data/files>', type=str, nargs='+', help="Files to plot")
    parser.add_argument('-o', '--output', type=str, default="Figures/ThetaXi.pdf", metavar='<path/to/output/file>', help='output location')
    parser.add_argument('-r', '--root',  action='store_true', help='Also plot the crosshairs showing xi1')

    args = parser.parse_args()
    dataFiles = filter(lambda x: '.binary' in x, args.files)
    N, states = extract_theta_dot_xi(dataFiles)

    set_style()

    fig, ax = plt.subplots(1, 1, figsize=(10, 7))
    for n, state in zip(N, states):
        ax.plot(state[0], state[1], label=r"$\theta_{{n={}}}$".format(n))
        ax.plot(state[0], state[2], linestyle='--', label=r"$\left(\frac{{d\theta}}{{d\xi}}\right)_{{n={}}}$".format(n))
    if args.root:
        xi1Approx, theta1Approx = find_root(state[0], state[1])
        ax.axvline(x=xi1Approx, linestyle=':', color='black', alpha=0.5)
        ax.axhline(y=0, linestyle=':', color='black', alpha=0.5)
    ax.set_xlabel(r'$\xi$', fontsize=17)
    ax.set_ylabel(r'$\theta$, $\frac{d\theta}{d\xi}$', fontsize=17)
    plt.legend()

    plt.savefig(args.output, bbox_inches='tight')
