Polytrope Project Numerical Integrator
Thomas M. Boudreaux
===================

Compilation Instructions:
	- To compile $ make

Run Time Instructions:
	- To run $ ./Integrate [n] [h] [xi0] [xif] [itr]
  		    n[float]       - polytroic index
  		    h[float]       - integration step size
  	 	    xi0[float]     - initial value of xi to start at
  	  	    xif[float]     - value of xi to integrate too
  		    itr[int]       - number of terms in power serise to use to approximation theta(xi=Xi0)

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
