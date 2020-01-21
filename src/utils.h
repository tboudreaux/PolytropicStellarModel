#ifndef UTILS
#define UTILS
#include<fstream>
#include<iostream>

using namespace std;


typedef double (* odeModel)(double vN, double *argv, int argc);

/* rk4(double yN, float h, unsigned long *model, double *argv, int argc)
 *
 * Desc: Runge-Kutta Fourth Order integrator
 * Params:
 * 		    yN[double]       - current function value
 * 		    h[float]         - step size
 *		    model[function*] - pointer to function to integrate
 *		    argv[double*]    - array of model function arguments
 *		    argc[int]        - number of arguments in argv
 * Returns:
 * 		    yN+1 [double]    - next value of function
 * Pre-State:
 * 		    Stateless
 * Post-State:
 * 		    Stateless
 * Exceptions:
 * 		    No Defined Exceptions
 */
double rk4(double yN, float h, odeModel model, double *argv, int argc);

/* vdot(double vN, double *argv, int argc)
 *
 * Desc: mid-way lane-emden equation of form v'=(-2/\xi)v - \theta^{n}
 * Params:
 * 		     vn[double]    - current value of v in the function
 * 		     argv[double*] - array of model arguments
 * 		     argc[int]     - number of arguments
 * Returns:
 * 		     v'[double]    - the derivitive of the function given above
 * Pre-State:
 * 			 Stateless
 * Post-State:
 * 			 Stateless
 * Exceptions:
 * 			 No Defined Exceptions
 */
double vdot(double vN, double *argv, int argc);

/*
 * a(int k, float n)
 *
 * Desc: Coefficients on xi in the power serise expansion of theta(xi)
 * Params: 
 * 		     k[int]      - order of the power serise coefficient
 * 		     n[float]    - polytropic index
 * Returns:
 * 		     a_k[double] - kth coefficient on power serise expansion of theta(xi)
 * Pre-State:
 * 		     Stateless
 * Post-State:
 * 			 Stateless
 * Exceptions:
 * 			 No Defined Exceptions 
 * Note:
 * 			Using large values for k (above ~15) will lead to stack overflows as the 
 * 			implicit tail recursion depth (1MB stack size) is exceeded
 */
double a(int k, float n);

/*
 * c(int m, float n)
 *
 * Desc: Coefficients on the power serice expansion of theta^n(xi)
 * Params:
 *          m[int]      - order of the power serise coefficient
 *          n[float]    - polytropic index
 * Returns:
 * 		    c_m[double] - mth coefficient on power serise expansion of theta^n(xi)
 * Pre-State:
 *          Stateless
 * Post-State:
 * 		    Stateless
 * Exceptions:
 *          No Defined Exceptions
 */
double c(int m, float n);

/*
 * theta_approx(double xi, float n, int itr)
 * 
 * Desc: Power serise approximation of theta(xi)
 * Params:
 * 		   xi[double]         - value of xi to approximate at
 * 		   n[float]           - polytropic index
 * 		   itr[int]           - number of terms in power serise to consider
 * Returns:
 * 		    theta(xi)[double] - approximation of theta at xi
 * Pre-State:
 * 			Stateless
 * Post-State:
 * 			Stateless
 * Exceptions:
 * 			No Defined Exceptions
 * Note:
 * 			Using large values for itr (above ~15) will lead to stack overflows as the 
 * 			implicit tail recursion depth (1MB stack size) is exceeded
 */
double theta_approx(double xi, float n, int itr);

/*
 * arange(float low, float high, float step)
 * 
 * Desc: Creates an array of doubles from low -> high seperated by step
 * Params:
 * 	        low[float]     - Initial value to start array at (inclusive)
 * 	        high[float]    - vaue to take array to (non inclusive)
 * 	        step[float]    - spaceing between values in array
 * Returns:
 * 		    array[double*] - pointer to an array of doubles from low - high spaced by step
 * Pre-State:
 * 			Stateless
 * Post-State:
 * 			Stateless
 * Exceptions:
 * 			Stack overflow: If requested size exceeds 1GB then the program will
 * 			exit with retcode 1 to avoid a stack overflow.
 */
double* arange(float low, float high, float step);

/*
 * save(const string& filename, double** state, int size)
 *
 * Desc: dumps values of xi, theta, and thetadot to binary file
 * Params:
 * 		    filename[string] - path of file to write to
 * 		    state[double**]  - 2D array of xi theta and thetadot
 * 		    size[int]        - length of xi
 * Returns:
 * 		    Void
 * Pre-State:
 * 			Stateless
 * Post-State:
 * 			File of name <filename> is created with binary dump of state
 * Exceptions:
 * 			No Defined Exceptions
 */
void save(const string& filename, double** state, int size);
#endif
