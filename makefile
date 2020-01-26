# build C++ version of a lane-emden integrator
CC = g++
CFLAGS = -g -Wall
HEADERDIRS = src
BINDIR = bin
DATADIR = data
PSTANOT = 0

default: all

all: lane-emden.o utils.o model.o integration.o
	@mkdir -p $(BINDIR)
	$(CC) $(CFLAGS) -D RDATADIR=$(DATADIR) -D PSTANOUT=$(PSTANOT) -I $(HEADERDIRS) -o integrate lane-emden.o utils.o model.o integration.o
	@mv *.o $(BINDIR)/
	@mv integrate $(BINDIR)/
	@ln -s $(BINDIR)/integrate ./integrate
	@mkdir -p $(DATADIR)
	@ln -s ../$(DATADIR) pyUtils/$(DATADIR)
	
lane-emden.o: $(HEADERDIRS)/lane-emden.cpp $(HEADERDIRS)/utils.h $(HEADERDIRS)/model.h $(HEADERDIRS)/integration.h
	$(CC) $(CFLAGS) -D RDATADIR=$(DATADIR) -D PSTANOUT=$(PSTANOT) -I $(HEADERDIRS) -c $(HEADERDIRS)/lane-emden.cpp

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
	@rm integrate
	@rm pyUtils/$(DATADIR)
	@rm -r $(BINDIR)/
	@rm -r $(DATADIR)

