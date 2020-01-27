#ifndef MODEL
#define MODEL

#include<fstream>

using namespace std;
/* vdot_nonDegenerate(double vN, double *argv, int argc)
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
 * Notes:
 * 			 argv takes the form [xi_{i}, theta_{i}, n]
 */
double vdot_nonDegenerate(double vN, double *argv, int argc);

/* vdot_degenerate(double vN, double *argv, int argc)
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
double vdot_degenerate(double vN, double *argv, int argc);

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


#endif
