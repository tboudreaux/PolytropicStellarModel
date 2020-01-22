#include <iostream>
#include <complex>
#include <cmath>

#include "model.h"

double vdot(double vN, double *argv, int argc){
	// Use complex numbers because base could be negative
	complex<double> base = argv[1];
	complex<double> exp = argv[2];
	complex<double> secondTerm = pow(base, exp);
	return (-2/argv[0])*vN-secondTerm.real();
}


double a(int k, float n){
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
		return -(c(k-2, n)/(pow(k, 2)+k));
	}
}


double c(int m, float n){
	// halting condition from formal power serise definition
	if (m == 0){
		return pow(a(0, n), n);
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


double theta_approx(double xi, float n, int itr){
	double theta = 0;
	for (int k=0; k<itr; k++){
		// General form of a power serise
		theta += a(k, n)*pow(xi, k);
	}
	return theta;
}
