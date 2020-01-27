# build C++ version of a lane-emden integrator
CC = g++
CFLAGS = -g -Wall
HEADERDIRS = src
BINDIR = bin
DATADIR = data
PSTANOT = 0

default: all

all: lane-emden-nonDegenerate.o lane-emden-degenerate.o utils.o model.o integration.o
	@mkdir -p $(BINDIR)
	$(CC) $(CFLAGS) -D RDATADIR=$(DATADIR) -D PSTANOUT=$(PSTANOT) -I $(HEADERDIRS) -o integrate-nonDegenerate lane-emden.o utils.o model.o integration.o
	$(CC) $(CFLAGS) -D RDATADIR=$(DATADIR) -D PSTANOUT=$(PSTANOT) -I $(HEADERDIRS) -o integrate-degenerate lane-emden-degenerate.o utils.o model.o integration.o
	@mv *.o $(BINDIR)/
	@mv integrate $(BINDIR)/
	@ln -s $(BINDIR)/integrate-nonDegenerate ./integrate-nonDegenerate
	@ln -s $(BINDIR)/integrate-degenerate ./integrate-degenerate
	@mkdir -p $(DATADIR)
	@ln -s ../$(DATADIR) pyUtils/$(DATADIR)
	
lane-emden-nonDegenerate.o: $(HEADERDIRS)/lane-emden-nonDegenerate.cpp $(HEADERDIRS)/utils.h $(HEADERDIRS)/model.h $(HEADERDIRS)/integration.h
	$(CC) $(CFLAGS) -D RDATADIR=$(DATADIR) -D PSTANOUT=$(PSTANOT) -I $(HEADERDIRS) -c $(HEADERDIRS)/lane-emden-nonDegenerate.cpp

lane-emden-degenerate.o: $(HEADERDIRS)/lane-emden-degenerate.cpp $(HEADERDIRS)/utils.h $(HEADERDIRS)/model.h $(HEADERDIRS)/integration.h
	$(CC) $(CFLAGS) -D RDATADIR=$(DATADIR) -D PSTANOUT=$(PSTANOT) -I $(HEADERDIRS) -c $(HEADERDIRS)/lane-emden-degenerate.cpp

utils.o: $(HEADERDIRS)/utils.cpp $(HEADERDIRS)/utils.h
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -c $(HEADERDIRS)/utils.cpp

model.o: $(HEADERDIRS)/model.cpp $(HEADERDIRS)/model.h
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -c $(HEADERDIRS)/model.cpp

integration.o: $(HEADERDIRS)/integration.cpp $(HEADERDIRS)/integration.h
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -c $(HEADERDIRS)/integration.cpp

cleanData:
	@rm -r $(DATADIR)
	@mkdir $(DATADIR)

data:
	@mkdir -p $(DATADIR)

clean:
	@rm integrate-nonDegenerate
	@rm integrate-degenerate
	@rm pyUtils/$(DATADIR)
	@rm -r $(BINDIR)/
	@rm -r $(DATADIR)

