Polytrope Project Numerical Integrator
Thomas M. Boudreaux
===================

Compilation Instructions:
	- To compile $ make
	- There are two compile time arguemnts which may be set
		- DATADIR will set where that data files are written to (will make the folder to)
		- PSTANOT will determine if the output is also written to standard output
			- This is in addition to dumping to a dat file which will always happen
			- 0 to supress standard output
			- 1 to print to standard output
		- Examples of use
			- $ make PSTANOT=1 DATADIR=results
				- this will print to standard out and save binaries in a folder called results
			- $ make
				- this will use the default values of PSTANOT=0 and DATADIR=data

Run Time Instructions:
	- there are two executable files, integrate-nonDegenerate and integrate-degenerate
		- running the nonDegenerate file with integrate a polytrope
		- running the degenerate model will integrate a white dwarf model
	- To run $ ./integrate-[non][d/D]generate [n/theta_c] [h] [xi0] [xif] [itr]
  		    n/theta_c[float]       - polytroic index(non degenerate case)/central density (degenerate case)
  		    h[float]       - integration step size
  	 	    xi0[float]     - initial value of xi to start at
  	  	    xif[float]     - value of xi to integrate too
  		    [itr[int]]       - number of terms in power serise to use to approximation theta(xi=Xi0) only used in non degenerate case

Data File Format Specs:
	- After running either executable a file will be saved to whatever data director was spesificed at compile
	  time, by default this is a directory called "data"
		- That file will have the input polytropic index in it along with the either being degenerate or non degenerate
		- The file has a header and a body
			- The header is an set of ASCII key value pairs
			- The body is a byte stream of c++ type doubles
			- The file starts with ">> HEADER"
			- The header continues until the line ">> BODY"
				- After this line the next line is the byte stream

Data View Instructions:
	- To generate graphs of the data:
		- Use the included script <pyUtils/ViewCOutput.py>
			- $ python pyUtils/ViewCOutput.py <path/to/fileA> <path/to/fileB>
			- the script can plot either one data file or multiple
				- If plotting multiple the script can place them all on one figure
				  or break them out into seperate figures
			- Command line options can be shown by running
				- $ python pyUtils.py --help
	- To Get the value of Xi1
		- Use the uncluded script <pyUtils/getXi1.py>
			- $ python getXi1.py <path/to/file>
		- Command line options can be shown by running
			- $ python getXi1.py --help

	- If you want to generate the figures of all the dataruns on seperate plots use something like from the pyUtils directory
		- $ ls data/*.dat | awk '{split($0,a,"/"); print a[2]}' | xargs -I{} ./ViewCOutput.py data/{} -o Figures/Multi_{}.pdf

Physical Scaling quantities:
	- To generate the physical scalings from xi, theta, and dtheta use the python script <pyUtils/convertToPhysical.py>
		- $ python pyUtils/convertToPhysical.py <path/to/dat/file>
			- use --help to see command line options
	- To plot the physical quantities use the python script <pyUtils/plotPhysical.py>
		- $ python pyUtils/plotPhysical.py <path/to/physically/scaled/data/file> --output <path/to/save/figure>
			- use --help to see command line options

Tests:
	- To test the code use the script <tests/testLaneEmden.sh>
		- To do this you have to have compiled the integrator and had DATADIR=data (or change the path in the python file in tests)
		- This script will integrate a polytrope of n=1 from 0.00001 to 4 xi with a step size of 0.00001 
		- It will then use an the resultant xi array from that integration to compute the exact solution in the n=1 case
			- sin(xi)/xi
		- Finally it will take the arithmatic mean of the differences
			- Smaller values of the this imply that the integrator is returning a solution close to the exact solution.
