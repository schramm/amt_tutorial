#ifndef __PLCA__
#define __PLCA__


#include <iostream>
#include <fstream>
#include "sch_utils.h"

#define EPS  2.2204e-16
#define BOX_SIZE 20

#define EM_ITERATIONS 15
//#define PLCA_ALPHA 0.5
//#define PLCA_THRESHOLD_MIN 0.0001
//#define PLCA_SCALE 1
#define PLCA_DICTIONARY_FILE "data/dict.cqt"


#include <Eigen/Dense>
using namespace Eigen;


class PLCA
{
	private:
	MatrixXd  activation;
	MatrixXd  wd;
	MatrixXd  ww;
	MatrixXd  xa;
	MatrixXd  in_cqt;
	MatrixXd  D;
	int current_filter_col;
	int current_filter_col_loop;

    bool ready_to_process;
	vector<double> plca_vec;


	public:

	PLCA();
	~PLCA();
	bool load_dictionary(string dict_path);
	void process(double* in);
	void reset();
	void save_plca();

   double * filter_amps_over_time();
   int box_size;

   double *amps;
   double *amps_aggregate;
   double **box_filter;
   double **box_filter_loop;

	double alpha;
	double th_min;
	double scale;

   int PITCH_RANGE;
   int CQT_BINS_SIZE;
   int NUM_TPL;


};

#endif //__PLCA__
