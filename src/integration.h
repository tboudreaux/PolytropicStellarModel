#ifndef INT
#define INT

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
#endif
