#ifndef CU_UTILS
#define CU_UTILS

typedef double (* odeModel)(double vN, double *argv, int argc);

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
__device__ double a(int k, float n);

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
__device__ double c(int m, float n);

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
__device__ double theta_approx(double xi, float n, int itr);

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
__device__ double vdot_nonDegenerate(double vN, double *argv, int argc);


/*
 * single_polytrope(double* xiL, double* state, long int nXi, int polytropicIndex, double* parsedArgv, int polytropeNumber)
 *
 * Desc: Compute the solutions to Theta and Theta dot for a single polytropic index, n. Meant to run as a single thread in a warp
 * Params:
 *		   xiL[double*]			- List of xi values (same for all n)
 *		   state[double*]		- Location to save results to
 *		   nXi[long int]		- Total number of xi values
 *		   polytropicIndex[int] - polytropic index, n
 *         parsedArgv[double*]  - list of arguments from command line
 *         polytropeNumber[int] - Which of the n models is this
 *
 * Returns:
 *		   N/A 
 * Pre-State:
 *         N/A
 * Post-State:
 *         State array filled with Theta and Theta dot for a single n per thread
 * Exceptions:
 *         No defined exceptions
 *
 */
__device__ void single_polytrope(double* xiL, double* state, long int nXi, int polytropicIndex, double* parsedArgv, int polytropeNumber);

/*
 * distribute_jobs(double* xiL, double* state, long int nXi, int totalModels, int TILELENGTH, double* parsedArgv)
 *
 * Desc: Distribute polytrope jobs around to a variety of threads
 * Params:
 *		   xiL[double*]			- List of xi values (same for all n)
 *		   state[double*]		- Location to save results to
 *		   nXi[long int]		- Total number of xi values
 *		   totalModels[int]     - Total Number of models to compute
 *         TILELENGTH[int]      - The CUDA tile length
 *         parsedArgv[double*]  - list of arguments from command line
 *
 * Returns:
 *		   N/A 
 * Pre-State:
 *         N/A
 * Post-State:
 *         State array filled with Theta and Theta dot for all requested n
 * Exceptions:
 *         No defined exceptions
 *
 */
__global__ void distribute_jobs(double* xiL, double* state, long int nXi, int totalModels, int TILELENGTH, double* parsedArgv);

/*
 * errorCheck(int code, cudaError_t err)
 *
 * Desc: Check if Kernel errors occur and is so alert into User Space
 * Params:
 *        code[int]				- User defined code, which error message is what
 * 		  err[cudaError_t] 		- CUDA function result
 * Returns:
 *		  N/A
 * Pre-State:
 *		  N/A
 * Post-State:
 * 		  N/A
 * Exceptions:
 * 		  No defined exceptions
 *
 */
void errorCheck(int code, cudaError_t err);

/*
 * int_n_model(double* xiL_H, double xi0, double xif, double h, int models, long int nXi, double* parsedArgv, int argc)
 *
 * Desc: Allocate memory on Device, copy data to and from, and setup kernel
 * Params:
 *		   xiL_H[double*]		- List of xi values from host (same for all n)
 *		   xi0[double]			- Lower bound value on Xi
 * 		   xif[double]			- Upper bound value on Xi
 *		   h[double]			- Step size for Xi array
 *		   models[int]          - Total Number of models to compute
 *		   nXi[long int]		- Total number of xi values
 *         parsedArgv[double*]  - list of arguments from command line
 *		   argc[int]			- Total number of command line arguments provided
 *
 * Returns:
 *		   state[double*]		- Filled array storing Theta and Theta dot for all models 
 * Pre-State:
 *         N/A
 * Post-State:
 * 		   N/A
 * Exceptions:
 *         No defined exceptions
 *
 */
double* int_n_model(double* xiL_H, double xi0, double xif, double h, int models, long int nXi, double* parsedArgv, int argc);

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
__device__ double rk4(double yN, float h, odeModel model, double *argv, int argc);

#endif
