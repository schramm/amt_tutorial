#include "sch_utils.h"

#define MAX_MAT_BUFSIZE  ((int) 1e6)

MatrixXd read_matrix(const char *filename)
{
    int cols = 0, rows = 0;
    double buff[MAX_MAT_BUFSIZE];

    // Read numbers from file into buffer.
    ifstream infile;
    infile.open(filename);
    while (! infile.eof())
    {
        string line;
        getline(infile, line);

        int temp_cols = 0;
        stringstream stream(line);
        while(! stream.eof())
            stream >> buff[cols*rows+temp_cols++];

        if (temp_cols == 0)
            continue;

        if (cols == 0)
            cols = temp_cols;

        rows++;
    }

    infile.close();

    rows--;

    // Populate matrix with numbers.
    MatrixXd result(rows,cols);
    for (int i = 0; i < rows; i++)
        for (int j = 0; j < cols; j++)
            result(i,j) = buff[ cols*i+j ];

    return result;
};



void read_wave_file (const char * fname, float*& buffer, int* buffer_len )
{
    SNDFILE *sf;
    SF_INFO info;
    info.format = 0;
    sf = sf_open(fname,SFM_READ,&info);
    if (sf == NULL)
    {
        printf("Failed to open the file.\n");
        exit(-1);
    }

    printf ("Opened file '%s'\n", fname) ;
    printf ("    Sample rate : %d\n", info.samplerate ) ;
    printf ("    Channels    : %d\n", info.channels ) ;

    buffer_len[0] = info.channels*info.frames;

    buffer = (float *) malloc(buffer_len[0]*sizeof(float));
    sf_read_float(sf, buffer, buffer_len[0]);
    sf_close(sf);

    printf("wave file loaded.\n");
} /* read_file */

void write_wave_file (const char * fname, float* buffer, int buffer_size)
{
    if (buffer==NULL) return;

    SF_INFO sfinfo ;
    sfinfo.channels = 1;
    sfinfo.samplerate = 44100;
    sfinfo.format = SF_FORMAT_WAV | SF_FORMAT_PCM_16;

    SNDFILE * outfile = sf_open(fname, SFM_WRITE, &sfinfo);
    sf_count_t count = sf_write_float(outfile, &buffer[0], buffer_size) ;
    (void) count;
    sf_write_sync(outfile);
    sf_close(outfile);

    printf("output wave file saved: %s.\n", fname);
}


int compare_structs (const void *a, const void *b){

    t_amplitude_index *struct_a = (t_amplitude_index *) a;
    t_amplitude_index *struct_b = (t_amplitude_index *) b;

    if(struct_a->amplitude < struct_b->amplitude) return 1;
    if(struct_a->amplitude == struct_b->amplitude) return 0;
    if(struct_a->amplitude > struct_b->amplitude) return -1;

    return 0;
}


