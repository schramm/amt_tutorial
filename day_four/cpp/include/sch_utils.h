#ifndef __SCH_UTILS__
#define __SCH_UTILS__

#include <iostream>
#include <cstdio>
#include <fstream>
#include <ctime>
#include <ratio>
#include <chrono>
#include <string>
#include <vector>

#include <Eigen/Dense>
#include <sndfile.hh>

using namespace std::chrono;
using namespace std;
using namespace Eigen;
using Eigen::MatrixXd;

#define DBG printf


template <class data_type>
data_type sum_array(data_type* buffer, int buffer_length )
{
    data_type s=0;
    for (int i=0; i<buffer_length; i++)
    {
        s+=buffer[i];
    }
    return s;
}

template <class data_type>
data_type avg_array(data_type* buffer, int buffer_length )
{
    data_type s=0;
    for (int i=0; i<buffer_length; i++)
    {
        s+=buffer[i];
    }
    return s/buffer_length;
}

template <class data_type>
void norm_array(data_type* &buffer, int buffer_length )
{
    data_type s=0;
    for (int i=0; i<buffer_length; i++)
    {
        s+=buffer[i];
    }
    for (int i=0; i<buffer_length; i++)
    {
        buffer[i] = buffer[i]/s;
    }
}

template <class data_type>
double median_vector(vector<data_type> array)
{
    int size = array.size();

    if (size == 0)
    {
        return 0;  // Undefined, really.
    }
    else
    {
        sort(array.begin(), array.end());
        if (size % 2 == 0)
        {
            return (array[size / 2 - 1] + array[size / 2]) / 2;
        }
        else
        {
            return array[size / 2];
        }
    }
}


MatrixXd read_matrix(const char *filename);

void read_wave_file (const char * fname, float*& audio_buffer, int* buffer_len);
void write_wave_file (const char * fname, float* audio_buffer,	int buffer_len);

typedef struct _amplitude_index{ // Struct to store and order the values of the amplitudes preserving the index in the original array
    float amplitude;
    int index;
} t_amplitude_index;

int compare_structs (const void *a, const void *b);
/*
int compare_structs (const void *a, const void *b){

   t_amplitude_index *struct_a = (t_amplitude_index *) a;
   t_amplitude_index *struct_b = (t_amplitude_index *) b;

    if(struct_a->amplitude < struct_b->amplitude) return 1;
    if(struct_a->amplitude == struct_b->amplitude) return 0;
    if(struct_a->amplitude > struct_b->amplitude) return -1;

   return 0;
   //return struct_a->amplitude - struct_b->amplitude;
}
*/

#endif //utils


      
