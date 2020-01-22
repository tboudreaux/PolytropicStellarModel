# build C++ version of a lane-emden integrator
CC = g++
CFLAGS = -g -Wall
HEADERDIRS = src
BINDIR = bin

default: all

all: lane-emden.o utils.o model.o integration.o
	@mkdir -p $(BINDIR)
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -o integrate lane-emden.o utils.o model.o integration.o
	@mv *.o $(BINDIR)/
	@mv integrate $(BINDIR)/
	@ln -s $(BINDIR)/integrate ./integrate
	@mkdir -p data
	
lane-emden.o: $(HEADERDIRS)/lane-emden.cpp $(HEADERDIRS)/utils.h $(HEADERDIRS)/model.h $(HEADERDIRS)/integration.h
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -c $(HEADERDIRS)/lane-emden.cpp

utils.o: $(HEADERDIRS)/utils.cpp $(HEADERDIRS)/utils.h
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -c $(HEADERDIRS)/utils.cpp

model.o: $(HEADERDIRS)/model.cpp $(HEADERDIRS)/model.h
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -c $(HEADERDIRS)/model.cpp

integration.o: $(HEADERDIRS)/integration.cpp $(HEADERDIRS)/integration.h
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -c $(HEADERDIRS)/integration.cpp

cleanData:
	@rm -r data
	@mkdir data

data:
	@mkdir -p data

clean:
	@rm integrate
	@rm -r $(BINDIR)/
	@rm -r data

