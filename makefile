# build C version of nbody simulator
CC = g++
CFLAGS = -g -Wall
HEADERDIRS = src
BINDIR = bin

default: all

all: lane-emden.o utils.o
	@mkdir -p $(BINDIR)
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -o integrate lane-emden.o utils.o
	@mv *.o $(BINDIR)/
	@mv integrate $(BINDIR)/
	@ln -s $(BINDIR)/integrate ./integrate
	@mkdir -p data
	
lane-emden.o: $(HEADERDIRS)/lane-emden.cpp $(HEADERDIRS)/utils.h
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -c $(HEADERDIRS)/lane-emden.cpp

utils.o: $(HEADERDIRS)/utils.cpp $(HEADERDIRS)/utils.h
	$(CC) $(CFLAGS) -I $(HEADERDIRS) -c $(HEADERDIRS)/utils.cpp

cleanData:
	@rm -r data
	@mkdir data

data:
	@mkdir -p data

clean:
	@rm integrate
	@rm -r $(BINDIR)/
	@rm -r data

