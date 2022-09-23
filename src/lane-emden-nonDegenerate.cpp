#include<iostream>
#include<cmath>
#include<fstream>
#include<complex>
#include<string>
#include<map>

#include "utils.h"
#include "integration.h"
#include "model.h"

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
 * 		    n[float]       - polytroic index
 * 		    h[float]       - integration step size
 * 	 	    Xi0[float]     - initial value of xi to start at
 * 	  	    Xif[float]     - value of xi to integrate too
 * 		    itr[int]       - number of terms in power serise to use to approximation theta(xi=Xi0)
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

	// Total number of array elements in integration
	// (hi-low)/step
	nXi = ((parsedArgv[3]-parsedArgv[2])/parsedArgv[1])+1;

	// initialize the 2D array
	state = new double*[3];
	state[0] = arange(parsedArgv[2], parsedArgv[3], parsedArgv[1]);
	for (int i = 1; i < 3; i++){
		state[i] = new double[nXi];
	}


	// Run the integration
	state[2][0] = 0;
	for(int i=0; i<nXi; i++){
		if (i==0){
			// Set the initial theta(xi) value based on the power serise expansion
			state[1][i] = theta_approx(state[0][i], parsedArgv[0], parsedArgv[4]);
		}	
		else{
			modelArgv[0] = state[0][i];
			modelArgv[1] = state[1][i-1];
			modelArgv[2] = parsedArgv[0];
			// Integrate with rk4
			state[2][i] = rk4(state[2][i-1], parsedArgv[1], (odeModel)vdot_nonDegenerate, modelArgv, 3);
			state[1][i] = state[2][i]*parsedArgv[1] + state[1][i-1];
		}
	}

	// Generate the metadata hash table for use as the header of the 
	// save file
	map<string, double> metadata;
	metadata.insert(pair<string, double>("n", parsedArgv[0]));
	metadata.insert(pair<string, double>("num", nXi));
	metadata.insert(pair<string, double>("xi0", parsedArgv[2]));
	metadata.insert(pair<string, double>("xif", parsedArgv[3]));
	metadata.insert(pair<string, double>("h", parsedArgv[1]));

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
	save(datadir + "laneEmdenDataFile_" + to_string((float)parsedArgv[0])  + "-nonDegenerate.dat", state, metadata);

	// Release the memory back to the operating system
	delete parsedArgv;
	for (int i = 0; i < 3; i++){
		delete[] state[i];
	}
	delete[] state;

	return 0;
}

