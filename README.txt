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
		 - Use the included notebook <ViewCOutput.ipynb>
		 - Use the included python script <ViewCOutput.py> 
