#include "integration.h"

typedef double (* odeModel)(double vN, double *argv, int argc);

double rk4(double yN, float h, odeModel model, double *argv, int argc){
	double k1, k2, k3, k4;
	k1 = h*model(yN, argv, argc);
	k2 = h*model(yN+k1/2, argv, argc);
	k3 = h*model(yN+k2/2, argv, argc);
	k4 = h*model(yN+k3, argv, argc);

	return yN+(k1/6.0)+(k2/3.0)+(k3/3.0)+(k4/6.0);
}
