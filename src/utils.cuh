#ifndef UTILS
#define UTILS
#include<fstream>
#include<iostream>
#include<map>

using namespace std;
/*
 * arange(float low, float high, float step)
 * 
 * Desc: Creates an array of doubles from low -> high seperated by step
 * Params:
 * 	        low[float]     - Initial value to start array at (inclusive)
 * 	        high[float]    - vaue to take array to (non inclusive)
 * 	        step[float]    - spaceing between values in array
 * Returns:
 * 		    array[double*] - pointer to an array of doubles from low - high spaced by step
 * Pre-State:
 * 			Stateless
 * Post-State:
 * 			Stateless
 * Exceptions:
 * 			Stack overflow: If requested size exceeds 1GB then the program will
 * 			exit with retcode 1 to avoid a stack overflow.
 */
double* arange(float low, float high, float step);

/*
 * save(const string& filename, double** state, int size)
 *
 * Desc: dumps values of xi, theta, and thetadot to binary file
 * Params:
 * 		    filename[string] - path of file to write to
 * 		    state[double**]  - 2D array of xi theta and thetadot
 * 		    size[int]        - length of xi
 * Returns:
 * 		    Void
 * Pre-State:
 * 			Stateless
 * Post-State:
 * 			File of name <filename> is created with binary dump of state
 * Exceptions:
 * 			No Defined Exceptions
 */
void save(const string& filename, double** state, map<string, double> &metadata);

/*
 * streamHeader(map<sting, double>, ostream)
 *
 * Desc: write the header to a general stream
 * Params:
 * 		  metadata[map<string, double>] - hash table of header
 * 		  stream[ostream]               - output stream to write to
 * Returns
 * 		  void
 * Pre-State:
 * 		  Stateless
 * Post-State:
 * 		 Header is written to stream as "# key:value"
 * Exceptions:
 * 		 No Defined Exceptions
 */
void streamHeader(map<string, double> &metadata, ostream &stream);

#endif
