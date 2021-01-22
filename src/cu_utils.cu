#include<iostream>
#include<fstream>

using namespace std;

__device__ void single_polytrope(double* state, long int nXi, int totalModels, int TILELENGTH){
	__shared__ double modelArgv[3];
	polytropeNumber = blockIdx.x*TILELENGTH + threadIdx.x;

	if (polytropeNumber < totalModels)
	{
		statePtr = state + sizeof(double)*nXi*2*polytropeNumber;
		for(int i=0; i<nXi; i++){
			if (i==0){
				// Set the initial theta(xi) value based on the power serise expansion
				statePtr[1][i] = parsedArgv[0];
			}	
			else{
				modelArgv[0] = statePtr[0][i];
				modelArgv[1] = statePtr[1][i-1];
				// Set up a window which is equivilent to zero to prevent the integrator
				// from jumping over zero
				if (statePtr[1][i-1] > 1.0e-5){
					// Integrate with rk4
					statePtr[2][i] = rk4(state[2][i-1], h, (odeModel)vdot_degenerate, modelArgv, 2);
					statePtr[1][i] = state[2][i]*h + state[1][i-1];
				}
				// When the dimensionless density goes negative constrain it to zero
				else{
					statePtr[1][i] = 0;
					statePtr[2][i] = 0;
				}
			}
			// Only keep track of the mass where the equation is defined
			if (statePtr[1][i] > 0){
				// Left endpoint reiemann-sum
				dm = pow(statePtr[0][i], 2)*state[1][i]*h;
				m += dm;
			}
		}
	}
}

void errorCheck(int code, cudaError_t err)
{
    if(err != cudaSuccess) {
        printf("%s in %s at line %d\n",cudaGetErrorString(err),__FILE__,__LINE__);
        exit(EXIT_FAILURE);
    }
}

void int_n_model(double* xiL_H, double xi0, double xif, double h, int models){
	double* oList;
	double* xiList;
	errorCheck(1, cudaMalloc((void **) &xiList, sizeof(double)*(((xif-xi0)/h)+1)));
	errorCheck(2, cudaMemcpy(xiList, xiL_H, sizeof(double)*(((xif-xi0)/h)+1), cudaMemcpyHostToDevice)); 
	errorCheck(3, cudaMalloc((void **) &oList, sizeof(double)*nXi*2*models));	



}
