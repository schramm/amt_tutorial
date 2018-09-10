

LIBS=-lm -lfftw3 -lsndfile  


#Start of the makefile

VPATH = ./src:./include:./obj

OUTPUT_OPTION = -o obj/$@

CXXFLAGS += -Wall -g -I./include -I ../../../thirdparty/eigen3.3.4/

Target1 = run_plca 
Target2 = build_dictionary 

Objects := $(notdir $(patsubst %.cpp,%.o,$(wildcard src/*.cpp)))

all: $(Target1)  $(Target2) 

$(Target1): $(Objects) run_plca.cpp
	$(CXX) $(CXXFLAGS) $(LIBS) run_plca.cpp  -o $(Target1) $(addprefix obj/,$(Objects))

$(Target2): $(Objects) build_dictionary.cpp
	$(CXX) $(CXXFLAGS) $(LIBS) build_dictionary.cpp  -o $(Target2) $(addprefix obj/,$(Objects))


#Beware of -f. It skips any confirmation/errors (e.g. file does not exist)

.PHONY: clean
clean:
	rm -f $(addprefix objects/,$(Objects)) $(Target1) $(Target2)


