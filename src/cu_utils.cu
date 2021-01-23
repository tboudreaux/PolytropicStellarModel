#include<iostream>
#include<fstream>
#include<thrust/complex.h>

#include "cu_utils.cuh"

typedef double (* odeModel)(double vN, double *argv, int argc);

using namespace std;

__device__ double a(int k, float n){
	// Recursion halting conditions based on boundary conditions
	// that theta(0) = 1 and that thetadot(0) = 0
	if (k == 0){
		return 1;
	}
	else if (k == 1){
		return 0;
	}
	else{
		// relation determined between a, c, and k in part one of project
		return -(c(k-2, n)/(pow((double)k, (double)2)+k));
	}
}


__device__ double c(int m, float n){
	// halting condition from formal power serise definition
	if (m == 0){
		return pow((double)a(0, n), (double)n);
	}
	else{
		double sum = 0;
		for (int k = 1; k <= m; k++){
			// relation from formal power serise
			sum += (k*n-m+k)*a(k, n)*c(m-k, n);
		}
		return (1/(m*a(0, n)))*sum;
	}

}

__device__ double theta_approx(double xi, float n, int itr){
	double theta = 0;
	for (int k=0; k<itr; k++){
		// General form of a power serise
		theta += a(k, n)*pow((double)xi, (double)k);
	}
	return theta;
}

__device__ double vdot_nonDegenerate(double vN, double *argv, int argc){
	return 1;
	// Use complex numbers because base could be negative
	thrust::complex<double> base = argv[1];
	thrust::complex<double> exp = argv[2];
	thrust::complex<double> secondTerm = pow(base, exp);
	return (-2/argv[0])*vN-secondTerm.real();
}

__device__ void single_polytrope(double* xiL, double* state, long int nXi, double polytropicIndex, double* parsedArgv, int polytropeNumber){
	__shared__ double modelArgv[3];
	double* modelState = NULL;
	double h = parsedArgv[1];


	// Pointer to the subpart of the array for this thread
	modelState = state + nXi*2*polytropeNumber;
	for(int i=0; i<nXi; i++){
		if (i==0){
			// Set the initial theta(xi) value based on the power serise expansion
			modelState[i*2] = theta_approx(modelState[i*2], polytropicIndex, 10);
		}	
		else{
			modelArgv[0] = xiL[i];
			modelArgv[1] = modelState[(i-1)*2];
			modelArgv[2] = polytropicIndex;
			// Integrate with rk4
			modelState[i*2+1] = rk4(modelState[(i-1)*2+1], h, (odeModel)vdot_nonDegenerate, modelArgv, 3);
			modelState[i*2] = modelState[i*2+1]*h + modelState[(i-1)*2];
			// When the dimensionless density goes negative constrain it to zero
		}
	}
}

__global__ void distribute_jobs(double* xiL, double* state, long int nXi, int totalModels, int TILELENGTH, double* parsedArgv){
	int polytropeNumber = blockIdx.x*TILELENGTH + threadIdx.x;
	/* printf("%d out of %d\n", polytropeNumber, totalModels); */
	if (polytropeNumber < totalModels)
	{
		// Distribute the polytropic index based on location in Grid
		float polytropicIndex = (polytropeNumber/(float)totalModels) * 2.0 + 0.1;
		// Call the single polytrope for this thread
		single_polytrope(xiL, state, nXi, polytropicIndex, parsedArgv, polytropeNumber);
	}
}

void errorCheck(int code, cudaError_t err)
{
    if(err != cudaSuccess) {
        printf("%s in %s at line %d (ERR NUM %d)\n",cudaGetErrorString(err),__FILE__,__LINE__,code);
        exit(EXIT_FAILURE);
	}
}

double* int_n_model(double* xiL_H, double xi0, double xif, double h, int models, long int nXi, double* parsedArgv, int argc){
	double* oList; // Output List - To be filled
	double* xiList;// xi list
	double* pargv; // command line argument list

	// Allocate and Copy Data from host to device
	errorCheck(1, cudaMalloc((void **) &xiList, sizeof(double)*(((xif-xi0)/h)+1)));
	errorCheck(2, cudaMemcpy(xiList, xiL_H, sizeof(double)*(((xif-xi0)/h)+1), cudaMemcpyHostToDevice)); 
	errorCheck(3, cudaMalloc((void **) &oList, sizeof(double)*nXi*2*models));	
	errorCheck(4, cudaMalloc((void **) &pargv, sizeof(double)*(argc-1)));
	errorCheck(5, cudaMemcpy(pargv, parsedArgv, sizeof(double)*(argc-1), cudaMemcpyHostToDevice));	

	// Base the CUDA grid size on the the models requested
	int TILELENGTH = 10;
	dim3 dimGrid(ceil(models/(float)TILELENGTH), 1, 1); dim3 dimBlock(TILELENGTH, 1, 1);

	distribute_jobs<<<dimGrid, dimBlock>>>(xiList, oList, nXi, models, TILELENGTH, pargv);
	// Wait for all threads to complete
	cudaDeviceSynchronize();

	double* state = new double[2*nXi*models];
	// Copy data from device to host
	errorCheck(6, cudaMemcpy(state, oList, sizeof(double)*2*nXi*models, cudaMemcpyDeviceToHost));
	return state;
}

__device__ double rk4(double yN, float h, odeModel model, double *argv, int argc){
	double k1, k2, k3, k4;
	k1 = h*model(yN, argv, argc);
	k2 = h*model(yN+k1/2, argv, argc);
	k3 = h*model(yN+k2/2, argv, argc);
	k4 = h*model(yN+k3, argv, argc);

	return yN+(k1/6.0)+(k2/3.0)+(k3/3.0)+(k4/6.0);
}
