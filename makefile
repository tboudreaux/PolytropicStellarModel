# build CUDA version of a lane-emden integrator
CC = nvcc
CFLAGS = -lineinfo -g
HEADERDIRS = src
BINDIR = bin
DATADIR = data
PSTANOT = 0

default: all

all: lane-emden-nonDegenerate.o utils.o cu_utils.o
	@mkdir -p $(BINDIR)
	@mkdir -p $(DATADIR)
	$(CC) $(CFLAGS) -D RDATADIR=$(DATADIR) -D PSTANOUT=$(PSTANOT) -I $(HEADERDIRS) -o integrate-nonDegenerate lane-emden-nonDegenerate.o utils.o cu_utils.o
	@mv *.o $(BINDIR)/
	
lane-emden-nonDegenerate.o: $(HEADERDIRS)/lane-emden-nonDegenerate.cu $(HEADERDIRS)/utils.cuh $(HEADERDIRS)/cu_utils.cuh
	$(CC) $(CFLAGS) -D RDATADIR=$(DATADIR) -D PSTANOUT=$(PSTANOT) -I $(HEADERDIRS) -c $(HEADERDIRS)/lane-emden-nonDegenerate.cu

utils.o: $(HEADERDIRS)/utils.cu $(HEADERDIRS)/utils.cuh
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -c $(HEADERDIRS)/utils.cu

cu_utils.o:	$(HEADERDIRS)/cu_utils.cu $(HEADERDIRS)/cu_utils.cuh
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -c $(HEADERDIRS)/cu_utils.cu

cleanData:
	@rm -r $(DATADIR)
	@mkdir $(DATADIR)

data:
	@mkdir -p $(DATADIR)

clean:
	@rm -r $(BINDIR)/
	@rm -r $(DATADIR)
	@rm integrate-nonDegenerate

