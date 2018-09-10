
#include "CQTransform.h"
#include "sch_utils.h"

using namespace std;

#define CQT_PI 3.141592653589793


CQTransform::CQTransform()
{
    cBufLen = 2048*2;

    load_cqt_kernel(); //TODO very import calling  this before to allocate memory

    pitch_range = CQT_BINS_SIZE;
    fft_size = CQT_FFT_SIZE;

    real = (float*) malloc(CQT_BINS_SIZE*sizeof(float)) ;
    imag = (float*) malloc(CQT_BINS_SIZE*sizeof(float)) ;

    in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * CQT_FFT_SIZE);
    out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * CQT_FFT_SIZE);

    blackmanharris_window=NULL;
/*
if (exist_file("fft_plan.bin"))
{
	DBG("loading fft plan...");
	 fftw_import_wisdom_from_filename("./data/fft_plan.bin");
	DBG(" loaded.\n");
	p = fftw_plan_dft_1d(CQT_FFT_SIZE, in, out, FFTW_FORWARD, FFTW_MEASURE);
} else
{
	DBG("creating a fft plan...");
	//p = fftw_plan_dft_1d(CQ_FFT_SIZE, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
	p = fftw_plan_dft_1d(CQT_FFT_SIZE,in,out, FFTW_FORWARD, FFTW_MEASURE);
	fftw_export_wisdom_to_filename("./data/fft_plan.bin");
	DBG("done.\n");
}
*/
    DBG("creating a fft plan...");
    cout << "creating a fft plan..." << endl;;
    //p = fftw_plan_dft_1d(CQ_FFT_SIZE, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
    p = fftw_plan_dft_1d(CQT_FFT_SIZE,in,out, FFTW_FORWARD, FFTW_MEASURE);

}

CQTransform::~CQTransform()
{
    free(real);
    free(imag);
    free(kernel_r);
    free(kernel_i);

    fftw_destroy_plan(p);
    fftw_free(in);
    fftw_free(out);

    free(blackmanharris_window);
//   DBG("cqt done\n.");
}

int CQTransform::load_cqt_kernel()
{
    DBG("loading CQT Kernel...\n");
    char* basedir = "./";
    string dirpath(basedir);
    dirpath += "/data/";

    DBG("looking for files at:%s ", dirpath.c_str());

    vector<string> dirFiles = listDictFiles(dirpath);

//	const char* fname_real = KERNEL_REAL_FILE;
//	const char* fname_imag = KERNEL_IMAG_FILE;
//	const char* fname_idx = KERNEL_IDX_FILE;

    char fname_real_canvas[500];
    char fname_imag_canvas[500];
    char fname_idx_canvas[500];

    sprintf(fname_real_canvas, "%s%s", dirpath.c_str(), dirFiles[1].c_str());
    sprintf(fname_imag_canvas, "%s%s", dirpath.c_str(), dirFiles[0].c_str());
    sprintf(fname_idx_canvas,  "%s%s", dirpath.c_str(), dirFiles[2].c_str());

    DBG("%s\n", fname_real_canvas);
    DBG("%s\n", fname_imag_canvas);
    DBG("%s\n", fname_idx_canvas);

    FILE *p_r, *p_i, *p_idx;

    // Name of file
    p_r = fopen(fname_real_canvas, "rb");
    p_i = fopen(fname_imag_canvas, "rb");
    p_idx = fopen(fname_idx_canvas, "rb");

    if (p_r==NULL || p_i == NULL || p_idx == NULL)
    {
        DBG("Error loading the CQT Kernel.\n ");// fflush(stdout);
        return 0;
    }

    double s1,s2,_minFreq,_maxFreq,bins;
    fread(&s1,sizeof(double), 1, p_r );
    fread(&s2,sizeof(double), 1, p_r );
    fread(&_minFreq,sizeof(double), 1, p_r );
    fread(&_maxFreq,sizeof(double), 1, p_r );
    fread(&bins,sizeof(double), 1, p_r );
    double tmp[5];
    fread(&tmp, sizeof(double), 5, p_i);
    fread(&tmp, sizeof(double), 5, p_idx);

    DBG("fft size:%f\n", s1);
    DBG("cqt bins:%f\n", s2);
    DBG("minFreq:%f\n", _minFreq);
    DBG("maxFreq:%f\n", _maxFreq);
    DBG("bins octave:%f\n", bins);

    CQT_FFT_SIZE = s1;
    CQT_BINS_SIZE = s2;
    minFreq = _minFreq;
    maxFreq = _maxFreq;
    BINS_OCTAVE = bins;
    CQT_KERNEL_SIZE = s1*s2;

    DBG("cqt kernel size: :%d\n", CQT_KERNEL_SIZE);


    // Allocate memory
    kernel_r =(double*) malloc(sizeof(double)*CQT_KERNEL_SIZE);
    kernel_i =(double*) malloc(sizeof(double)*CQT_KERNEL_SIZE);
    kernel_idx =(int*) malloc(sizeof(int)*CQT_BINS_SIZE*2);
    double* kernel_idx_tmp =(double*) malloc(sizeof(double)*CQT_BINS_SIZE*2);
    nnz =(int*) malloc(sizeof(int)*CQT_KERNEL_SIZE);

    // Reading the file
    fread(kernel_r,sizeof(double),CQT_KERNEL_SIZE,p_r);
    fread(kernel_i,sizeof(double),CQT_KERNEL_SIZE,p_i);
    fread(kernel_idx_tmp,sizeof(double),CQT_BINS_SIZE*2,p_idx);

    fclose(p_i);
    fclose(p_r);
    fclose(p_idx);
    DBG("CQT Kernel loaded.\n");//fflush(stdout);

    for (int i=0;i<CQT_BINS_SIZE;i++)
    {
        kernel_idx[i] = (int)kernel_idx_tmp[i];
        kernel_idx[i+CQT_BINS_SIZE] = (int)kernel_idx_tmp[i+CQT_BINS_SIZE];
        //	printf("%d %d \n ",kernel_idx[i], kernel_idx[i+CQ_BINS_SIZE] );
    }
    free(kernel_idx_tmp);

    return 1;
}


float*  CQTransform::create_blackmanharris_window(int N)
{
    if (N<0)
    {
        cout << "N must be > 0." << endl;
    }
    N = round(N);
    //% Reference:
    //% [1] fredric j. harris [sic], On the Use of Windows for Harmonic
    //%  Analysis with the Discrete Fourier Transform, Proceedings of
    //% the IEEE, Vol. 66, No. 1, January 1978
    //% Coefficients obtained from page 65 of [1]
    float a[] = {0.35875, 0.48829, 0.14128, 0.01168};
    float B[4];
    float x[N];
    float* w = new float[N];

    for (int i=0; i<N; i++)
    {
        x[i]=(i*2*CQT_PI)/(N-1);
    }

    B[0] =  a[0];
    B[1] = -a[1];
    B[2] =  a[2];
    B[3] = -a[3];

    for (int i=0; i<N; i++)
    {
        w[i] = cos(x[i]*0)*B[0]+cos(x[i]*1)*B[1]+cos(x[i]*2)*B[2]+cos(x[i]*3)*B[3];
    }

    return w;
}

void CQTransform::process_cqt(float* in_real, int buffer_size,  double* out_real )
{
    int minIDX = 0;
    int maxIDX = 0;

    if (blackmanharris_window==NULL)
    {
        blackmanharris_window = create_blackmanharris_window(buffer_size);
    }

    //copy data to CQT space
#pragma omp parallel for
    for (int i=0; i<buffer_size; i++)
    {
        //in[i][0] = (double)in_real[i] * blackmanharris_window[i];
        in[i][0] = (double)in_real[i];
        in[i][1] = 0;
    }

    for (int i=buffer_size; i<CQT_FFT_SIZE; i++)
    {   //padd with zeros
        in[i][0] = 0;
        in[i][1] = 0;
    }

	fftw_execute(p); /* repeat as needed */

#pragma omp parallel for
    for (int i=0; i<CQT_BINS_SIZE; i++) // coln //TODO define useful range smaller than CQ_BINS_SIZE
    {
        real[i] = 0;
        imag[i] = 0;

        minIDX = kernel_idx[i] - 1;
        maxIDX = kernel_idx[i + CQT_BINS_SIZE] - 1;

        for (int j = minIDX; j <= maxIDX; j++) //TODO make this loop size variable
        {
            real[i] += out[j][0] * kernel_r[i * CQT_FFT_SIZE + j] - out[j][1] * kernel_i[i * CQT_FFT_SIZE + j];
            imag[i] += out[j][0] * kernel_i[i * CQT_FFT_SIZE + j] + out[j][1] * kernel_r[i * CQT_FFT_SIZE + j];
        }

        double v = sqrt(real[i] * real[i] + imag[i] * imag[i]);
        //double v = sqrt(real[i]*real[i]+imag[i]*imag[i])/CQ_FFT_SIZE;
        out_real[i] = v;
        cqt_spec.push_back(v); // TODO

    }
}


void CQTransform::save_cqt()
{
    DBG("\nsaving cqt spectrogram:[%ld] datapoints.\n ", cqt_spec.size()); //fflush(stdout);
    double* buffer = &cqt_spec[0];

    FILE * pFile;
    pFile = fopen ("cqt.out", "wb");

    if (pFile==NULL)
    {
        DBG("CQT output file not created.\n");
        return;
    }
    fwrite (buffer , sizeof(double), cqt_spec.size() , pFile);
    fclose (pFile);

    DBG("saved\n "); //fflush(stdout);
}



inline int exist_file (const char* name) {
    FILE *file;
    file = fopen(name, "r");

    if (file) {
        fclose(file);
        return 1;
    } else {
        return 0;
    }
}

void reset_circ_buffer(float* circBuffer, int cBufLen)
{
    memset(circBuffer, 0, cBufLen*sizeof(float));
}


void shift_circ_buffer(float* circBuffer, int cBufLen, float* inputBlock, const int blockLen)
{
    int i;
    for (i=0;i<cBufLen-blockLen; i++)
    {
        circBuffer[i] = circBuffer[i+blockLen];
    }
    for (i=0; i<blockLen; i++)
    {
        circBuffer[cBufLen-blockLen+i] = inputBlock[i];
    }
}


int dictImagFileFilter(const struct dirent *dir)
{
    const char *s = dir->d_name;
    int len = strlen(s) - 8;	// index of start of imag.bin
    if(len >= 0)
    {
        if (strncmp(s + len, "imag.bin", 8) == 0)
        {
            return 1;
        }
    }
    return 0;
}
int dictRealFileFilter(const struct dirent *dir)
{
    const char *s = dir->d_name;
    int len = strlen(s) - 8;	// index of start of real.bin
    if(len >= 0)
    {
        if (strncmp(s + len, "real.bin", 8) == 0)
        {
            return 1;
        }
    }
    return 0;
}
int dictIdxFileFilter(const struct dirent *dir)
{
    const char *s = dir->d_name;
    int len = strlen(s) - 7;	// index of start of idx.bin
    if(len >= 0)
    {
        if (strncmp(s + len, "idx.bin", 7) == 0)
        {
            return 1;
        }
    }
    return 0;
}


vector<string> listDictFiles(string dirpath)
{
    vector<string> files;
    struct dirent **eps;
    int n;

    n = scandir (dirpath.c_str(), &eps, dictImagFileFilter, alphasort);
    if (n >= 0)
    {
        int cnt;
        for (cnt = 0; cnt < n; ++cnt)
        {
            // puts (eps[cnt]->d_name);
            files.push_back(eps[cnt]->d_name);
            break;
        }

    }
    else
        perror ("Couldn't open the directory");

    n = scandir (dirpath.c_str(), &eps, dictRealFileFilter, alphasort);
    if (n >= 0)
    {
        int cnt;
        for (cnt = 0; cnt < n; ++cnt) {
            // puts (eps[cnt]->d_name);
            files.push_back(eps[cnt]->d_name);
            break;
        }
    }
    else
        perror ("Couldn't open the directory");

    n = scandir (dirpath.c_str(), &eps, dictIdxFileFilter, alphasort);
    if (n >= 0)
    {
        int cnt;
        for (cnt = 0; cnt < n; ++cnt) {
            // puts (eps[cnt]->d_name);
            files.push_back(eps[cnt]->d_name);
            break;
        }
    }
    else
        perror ("Couldn't open the directory");

    return files;
}