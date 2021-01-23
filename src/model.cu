#include <iostream>
#include <thrust/complex.h>

#include "model.cuh"


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
