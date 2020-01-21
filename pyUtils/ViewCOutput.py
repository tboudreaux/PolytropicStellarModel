#!/usr/bin/env python
# coding: utf-8


from readCPython import load_C_output
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
    parser.add_argument('files', metavar='f', type=str, nargs='+', help="Files to plot")
    parser.add_argument('--output', '-o', type=str, default="Figures/ThetaXi.pdf", metavar='o', help='output location')
    parser.add_argument('--shared', type=bool, default='store_false', metavar='s', help='place all polytropes on the same plot')

    args = parser.parse_args()
    dataFiles = filter(lambda x: '.binary' in x, args.files)
    N, states = extract_theta_dot_xi(dataFiles)

    set_style()
    if args.shared:
        fig, ax = plt.subplots(1, 1, figsize=(10, 7))
        for n, state in zip(N, states):
            ax.plot(state[0], state[1], label=r"$\theta_{{n={}}}$".format(n))
            ax.plot(state[0], state[2], linestyle='--', label=r"$\left(\frac{{d\theta}}{{d\xi}}\right)_{{n={}}}$".format(n))
        ax.set_xlabel(r'$\xi$', fontsize=17)
        ax.set_ylabel(r'$\theta$, $\frac{d\theta}{d\xi}$', fontsize=17)
        plt.legend()

        plt.savefig(args.output, bbox_inches='tight')
    else:
        for n, state in zip(N, states):
            fig, ax = plt.subplots(1, 1, figsize=(10, 7))
            ax.plot(state[0], state[1], label=r"$\theta_{{n={}}}$".format(n))
            ax.plot(state[0], state[2], linestyle='--', label=r"$\left(\frac{{d\theta}}{{d\xi}right)_{{n={}}}$".format(n))
            ax.set_xlabel(r'$\xi$', fontsize=17)
            ax.set_ylabel(r'$\theta$, $\frac{d\theta}{d\xi}$', fontsize=17)
            plt.legend()
            filename = args.output.split('.')
            filename[0] = "{}_n={}".format(filename[0])
            filename = '.'.join(filename)
            plt.savefig(filename, bbox_inches='tight')
