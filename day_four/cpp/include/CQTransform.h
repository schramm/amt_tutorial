#ifndef __CQT__
#define __CQT__


// its size is fixed
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <math.h>
#include <string.h>
#include <vector>
#include <fftw3.h>


#include <sys/stat.h>
#include <unistd.h>
#include <memory>
#include <algorithm>
#include <sys/types.h>
#include <dirent.h>


using namespace std;

class  CQTransform {
   public:

      CQTransform();
      ~CQTransform();

      void process_cqt(float* in_real, int buffer_size,  double* out_real );
      void save_cqt();


    int CQT_FFT_SIZE;
    int CQT_BINS_SIZE;
    int minFreq;
    int maxFreq;
    int BINS_OCTAVE;
    int CQT_KERNEL_SIZE;

private:
        float circBuffer[2048*2];
        int cBufLen;
        float* real;
        float* imag;

        fftw_complex* in;
        fftw_complex* out;
        fftw_plan p;

        double* kernel_r;
        double* kernel_i;
        int* kernel_idx;
        int* nnz;
        vector<double> cqt_spec;

        double out_real[2048*2];
        int pitch_range;
        int fft_size;

       float* create_blackmanharris_window(int N);
       float* blackmanharris_window;

        int load_cqt_kernel();


};


int dictImagFileFilter(const struct dirent *dir);
int dictRealFileFilter(const struct dirent *dir);
int dictIdxFileFilter(const struct dirent *dir);
vector<string> listDictFiles(string dirpath);




//
int exist_file(const char *name);

void reset_circ_buffer(float *circBuffer, int cBufLen);
void shift_circ_buffer(float *circBuffer, int cBufLen, float *inputBlock, const int blockLen);


#endif //CQTransform


