
#include <iostream>
#include <fstream>
#include <stdlib.h>

#include "sch_utils.h"
#include "PLCA.h"
#include "CQTransform.h"


PLCA::PLCA()
{
    box_size = BOX_SIZE;
    ready_to_process=false;
    //
    cout << "PLCA EM Iterations: " << EM_ITERATIONS  << endl;
    cout << "PLCA BOX SIZE: " << BOX_SIZE  << endl;
}

PLCA::~PLCA()
{

}

void PLCA::reset()
{
    // initialise latent variables
    activation.fill(1.0/PITCH_RANGE); //uniform
    //amps.fill(0.0);
    memset(amps, 0, PITCH_RANGE*sizeof(double));


    //alpha = PLCA_ALPHA;
    //th_min = PLCA_THRESHOLD_MIN;
    //scale = PLCA_SCALE;
    //cout << "done. " << endl;
}


void PLCA::process(double* in ) // array size must be 99
{
    if (!ready_to_process)
    {
        cout << "PLCA not ready. error loading dictionary." << endl;
        return;
    }
    reset();

    double spar_coeff = 1.25;
    // convert input data to Eigen matrix format
    in_cqt = Map<MatrixXd>( in, CQT_BINS_SIZE, 1 );

    double energ = in_cqt.sum();
    //cout << "plca terations ";
    for (int iter=0; iter<EM_ITERATIONS; iter++)
    {
        xa = ww*activation; // matrix produt
        D = in_cqt.array()/(xa.array()+EPS); // div element wise
        D.transposeInPlace();
        wd = D * ww; // matrix product
        wd.transposeInPlace();
        activation = activation.array()*wd.array(); // prod element wise

        // sparsity
        activation = activation.array().pow(spar_coeff);
        // normalise
        activation = activation/(activation.sum()+EPS);
        activation = activation*energ;
    }

    double *data = activation.data();
    for (int i=0; i<PITCH_RANGE/NUM_TPL; i++)
    {
        amps_aggregate[i] = 0;
        for (int j=0; j<NUM_TPL;j++)
        {
            amps_aggregate[i] += 100*data[i*NUM_TPL+j];
        }
    }

    data =  filter_amps_over_time();

    for (int i=0; i<PITCH_RANGE/NUM_TPL;i++)
    {
        plca_vec.push_back(data[i]);
    }
}

//double* PLCA::filter_amps_over_freq()
//{
//
//    for (int i=0; i<PITCH_RANGE/NUM_TPL-1; i++)
//    {
//        double a,b;
//        a = amps_aggregate[i];
//        b = amps_aggregate[i+1];
//
//        if (b>a) amps_aggregate[i] =  amps_aggregate[i]*0.2;
//        else   amps_aggregate[i+1] =  amps_aggregate[i+1]*0.2;
//    }
//    return amps_aggregate;
//}

double * PLCA::filter_amps_over_time()
{
    for (int i=0; i<PITCH_RANGE/NUM_TPL; i++)
    {
        box_filter[i][current_filter_col] = amps_aggregate[i];
    }

    current_filter_col = fmod(current_filter_col+1,min(BOX_SIZE, box_size));

    for (int i=0; i<PITCH_RANGE/NUM_TPL;i++)
    {
        amps_aggregate[i]=0;
        for (int j=0; j<BOX_SIZE; j++)
        {
            amps_aggregate[i] += box_filter[i][j];
        }
        amps_aggregate[i] = amps_aggregate[i]/BOX_SIZE;
        if (amps_aggregate[i]<0.01)
        {
            amps_aggregate[i]=0;
        }
    }
    return amps_aggregate;
}



bool PLCA::load_dictionary(string dict_path)
{
    char* basedir = "./";
    char fname_dict[1000];
    sprintf(fname_dict, "%s/%s", basedir, dict_path.c_str());

    DBG("loading PLCA load_dictionary...  %s\n", fname_dict);
    FILE *p;

//	const char* fname_dict = PLCA_DICTIONARY_FILE;
    p = fopen(fname_dict, "rb");
    if (p==NULL)
    {

        DBG("Error loading PLCA dictionary.\n");
        exit(-1);
        return false;
    }

    fread(&CQT_BINS_SIZE,sizeof(int),1,p);
    fread(&PITCH_RANGE,sizeof(int),1,p);
    fread(&NUM_TPL,sizeof(int),1,p);

    cout << "CQT_BINS_SIZEZ: " << CQT_BINS_SIZE << endl;
    cout << "PITCH_RANGE: " << PITCH_RANGE << endl;
    cout << "NUM_TPL: " << NUM_TPL << endl;

    // Allocate memory
    double* dict =(double*) malloc(sizeof(double)*CQT_BINS_SIZE*PITCH_RANGE);

    // Reading the file
    fread(dict,sizeof(double),CQT_BINS_SIZE*PITCH_RANGE,p);

    fclose(p);
    DBG("PLCA dictionary [%s] loaded.\n", dict_path.c_str());


    ww = Map<MatrixXd>( dict, CQT_BINS_SIZE, PITCH_RANGE );

    activation.resize(PITCH_RANGE,1);
    wd.resize(1, PITCH_RANGE);
    ww.resize(CQT_BINS_SIZE, PITCH_RANGE);
    xa.resize(1,CQT_BINS_SIZE);
    in_cqt.resize(1,CQT_BINS_SIZE);
    D.resize(1,CQT_BINS_SIZE);

    amps_aggregate = new double[PITCH_RANGE/NUM_TPL];
    amps = new double[PITCH_RANGE];
    box_filter = new double*[PITCH_RANGE/NUM_TPL];
    box_filter_loop = new double*[PITCH_RANGE];
    for (int i=0; i<PITCH_RANGE/NUM_TPL;i++)
    {
        box_filter[i] = new double[BOX_SIZE];
        memset (box_filter[i],0, sizeof(double)*BOX_SIZE);
    }
    for (int i=0; i<PITCH_RANGE;i++)
    {
        box_filter_loop[i] = new double[BOX_SIZE];
        memset (box_filter_loop[i],0, sizeof(double)*BOX_SIZE);
    }

    ready_to_process=true;
    return true;
}



void PLCA::save_plca()
{

    char* basedir = "./";
    char fname_out[1000];
    sprintf(fname_out, "%s/%s", basedir, "plca.out");

    DBG("\nsaving plca output:[%ld] datapoints.\n ", plca_vec.size());
    double* buffer = &plca_vec[0];

    FILE * pFile;
    //pFile = fopen ("plca.out", "wb");
    pFile = fopen (fname_out, "wb");
    fwrite (buffer , sizeof(double), plca_vec.size() , pFile);
    fclose (pFile);
    DBG("saved\n ");
}



