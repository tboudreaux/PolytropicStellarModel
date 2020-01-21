#include<iostream>
#include<cmath>
#include<fstream>
#include<complex>

#include"utils.h"

using namespace std;
typedef double (* odeModel)(double vN, double *argv, int argc);

double rk4(double yN, float h, odeModel model, double *argv, int argc){
	double k1, k2, k3, k4;
	k1 = h*model(yN, argv, argc);
	k2 = h*model(yN+k1/2, argv, argc);
	k3 = h*model(yN+k2/2, argv, argc);
	k4 = h*model(yN+k3, argv, argc);

	return yN+(k1/6.0)+(k2/3.0)+(k3/3.0)+(k4/6.0);
}


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


double* arange(float low, float high, float step){
	double* ts = NULL;
	long int size;
	size = (high-low)/step;
	// Check for request for too much memory
	if (size*8 > 1000000000){
		cerr << "Error! You are trying to run a simulation which will take over a GB of memory to store.";
		cerr << " Please reduce integrateion time, or increase time step." << endl;
		cerr << "Total Requested Memory: " << size*8/1000000000.0 << " GB" << endl;
		exit(1);
	}
	ts = new double[size];
	for (int i = 0; i < size; i++){
		// add correct element to each location in array
		ts[i] = low+step*i;
	}
	return ts;
}

void save(const string& filename, double** state, int size){
	ofstream stateFile;

	// cast c++ type string to c type string
	stateFile.open(filename.c_str());
	if (stateFile.is_open()){
		// write each sub array in state one at a time
		for (int col = 0; col < 3; col++){
			//dump a binary
			stateFile.write((char*)state[col], size*sizeof(double));
		}
	}
	stateFile.close();
}
