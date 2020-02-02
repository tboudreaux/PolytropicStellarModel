#include<iostream>
#include<cmath>
#include<fstream>
#include<complex>
#include<string>
#include<vector>

#include "utils.h"
#include "integration.h"
#include "model.h"

// Macros to convert definitions into C type strings
#define STRINGIFY2(X) #X
#define STRINGIFY(X) STRINGIFY2(X)

using namespace std;

// function to pass as pointer definition
typedef double (* odeModel)(double vN, double *argv, int argc);


/*
 * main(int argc, const char* argv[])
 *
 * Desc: Numerically integrate theta over some range of xi
 * Params:
 * 		    theta_c[float] - central density in units of rho_0
 * 		    h[float]       - integration step size
 * 	 	    Xi0[float]     - initial value of xi to start at
 * 	  	    Xif[float]     - value of xi to integrate too
 * Returns:
 * 		    Exit Code[int] - 0
 * Pre-State:
 * 		    Stateless
 * Post-State:
 * 			File of name laneEmdenDataFile_<n>.binary exists with binary dump of xi, theta, thetadot
 * Exceptions:
 * 			No Defined Exceptions
 * Notes:
 * 		    Arguments given as: $ ./programName n h Xi0 Xif itr
 */
int main(int argc, const char* argv[]){

	double** state = NULL; // 2D array Xi, theta, thetadot, will be dumped to file
	double* parsedArgv = NULL;
	double modelArgv[3];
	long int nXi;
	double m = 0;
	double dm = 0;
	double h;
	parsedArgv = new double[argc-1];


	// Deal with the compile time options
	const int pstanot = PSTANOUT;
	string datadir = STRINGIFY(RDATADIR);
	const string dirAppend = "/";

	// If directory didn't have / add one
	if (datadir.compare(datadir.size() - dirAppend.size(), dirAppend.size(), dirAppend)){
		datadir.append(dirAppend);
	}


	// Convert command line args to doubles
	for (int arg=0; arg<argc-1; arg++){
		parsedArgv[arg] = stod(argv[arg+1]);
	}
	h = parsedArgv[1];

	// Total number of array elements in integration
	// (hi-low)/step
	nXi = ((parsedArgv[3]-parsedArgv[2])/h)+1;

	// initialize the 2D array
	state = new double*[3];
	state[0] = arange(parsedArgv[2], parsedArgv[3], h);
	for (int i = 1; i < 3; i++){
		state[i] = new double[nXi];
	}


	// Run the integration
	state[2][0] = 0;
	for(int i=0; i<nXi; i++){
		if (i==0){
			// Set the initial theta(xi) value based on the power serise expansion
			state[1][i] = parsedArgv[0];
		}	
		else{
			modelArgv[0] = state[0][i];
			modelArgv[1] = state[1][i-1];
			// Set up a window which is equivilent to zero to prevent the integrator
			// from jumping over zero
			if (state[1][i-1] > 1.0e-5){
				// Integrate with rk4
				state[2][i] = rk4(state[2][i-1], h, (odeModel)vdot_degenerate, modelArgv, 2);
				state[1][i] = state[2][i]*h + state[1][i-1];
			}
			// When the dimensionless density goes negative constrain it to zero
			else{
				state[1][i] = 0;
				state[2][i] = 0;
			}
		}
		// Only keep track of the mass where the equation is defined
		if (state[1][i] > 0){
			// Left endpoint reiemann-sum
			dm = pow(state[0][i], 2)*state[1][i]*h;
			m += dm;
		}
	}

	// Generate the metadata hash table for use as the header of the 
	// save file
	map<string, double> metadata;
	metadata.insert(pair<string, double>("theta_c", parsedArgv[0]));
	metadata.insert(pair<string, double>("num", nXi));
	metadata.insert(pair<string, double>("m", m));
	metadata.insert(pair<string, double>("xi0", parsedArgv[2]));
	metadata.insert(pair<string, double>("xif", parsedArgv[3]));
	metadata.insert(pair<string, double>("h", h));

	// print to stdout for use with ioredirection if one wants to work with a text file
	//  as opposed to a binary file
	if (pstanot == 1){
		cout << ">> HEADER" << endl;
		streamHeader(metadata, cout);
		cout << ">> BODY" << endl;
		for(int i = 0; i < nXi; i++){
			cout << state[0][i] << "," << state[1][i] << "," << state[2][i] << endl;
		}
	}

	// Dump the array state to a file
	// That file is a binary of doubles aranged so that the first nXi*sizeof(double) in bytes
	// is Xi, the second is theta, and the third is thetadot, therefore the total size of the
	// file in bytes should be 3*nXi*sizeof(double).
	save(datadir + "laneEmdenDataFile_" + to_string((float)parsedArgv[0])  + "-degenerate.dat", state, metadata);

	// Release the memory back to the operating system
	delete parsedArgv;
	for (int i = 0; i < 3; i++){
		delete[] state[i];
	}
	delete[] state;

	return 0;
}

