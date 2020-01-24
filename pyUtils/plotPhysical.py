import numpy as np
import argparse
import matplotlib.pyplot as plt
import pandas as pd


import matplotlib as mpl


def set_style(usetex=False):
    """ set a proffesional looking matplotlib style

    Keyword Arguments:
        usetex -- use the LaTeX Rendering engine, requires
                  LaTeX to be in the PATH

    """
    plt.rc('text', usetex=usetex)
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

if __name__ == "__main__":
    # Argument Parser 
    parser = argparse.ArgumentParser(description='Plot Data')
    parser.add_argument('file', metavar='<path/to/data/files>', type=str, help="Files to plot")
    parser.add_argument('-o', '--output', type=str, default="Figures/ThetaXi.pdf", metavar='<path/to/output/file>', help='output location')
    parser.add_argument('-t', '--tex', action='store_true', help='Use the tex rendering engine when plotting')

    args = parser.parse_args()

    data = np.load(args.file)

    set_style(usetex=args.tex)
    fig, axs = plt.subplots(2, 2, figsize=(20, 20))
    axs[0][0].plot(data[0], data[1])
    axs[0][0].plot(data[0], data[2])

    axs[0][0].set_xlabel(r"$\xi$", fontsize=17)
    axs[0][0].set_ylabel(r"$\theta$, $\frac{d\theta}{d\xi}$", fontsize=17)

    axs[1][0].plot(data[3], data[4])
    axs[0][1].plot(data[3], data[5])
    axs[1][1].plot(data[3], data[6])

    axs[1][0].set_xlabel(r"r [cm]", fontsize=17)
    axs[1][0].set_ylabel(r"$\rho$ [g cm$^{-3}$]", fontsize=17)

    axs[0][1].set_xlabel(r"r [cm]", fontsize=17)
    axs[0][1].set_ylabel(r"P [dyne]", fontsize=17)

    axs[1][1].set_xlabel(r"r [cm]", fontsize=17)
    axs[1][1].set_ylabel(r"T [K]", fontsize=17)

    plt.savefig(args.output, bbox_inches='tight')
