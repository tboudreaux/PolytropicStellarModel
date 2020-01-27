#include<iostream>
#include<cmath>
#include<fstream>
#include<complex>

#include"utils.h"

using namespace std;
typedef double (* odeModel)(double vN, double *argv, int argc);

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

void save(const string& filename, double** state, map<string, double> &metadata){
	map<string, double>::iterator it;
	ofstream stateFile;

	// cast c++ type string to c type string
	stateFile.open(filename.c_str());
	if (stateFile.is_open()){
		stateFile << ">> HEADER" << endl;
		for (it = metadata.begin(); it != metadata.end(); it++){
			stateFile << "# " << it->first << ":" << it->second << endl;
		}
		stateFile << ">> BODY" << endl;
		// write each sub array in state one at a time
		for (int col = 0; col < 3; col++){
			//dump a binary
			stateFile.write((char*)state[col], ((int)metadata.at("num"))*sizeof(double));
		}
	}
	stateFile.close();
}
