
#include "sch_utils.h"
#include "CQTransform.h"
#include "PLCA.h"

#include <dirent.h>
#include <cstring>
#include <iostream>
#include <vector>
#include <memory>
#include <string>
#include <algorithm>
#include <sys/types.h>

/*
void save_cqt(double* buffer,int  bufferLength)
{
	DBG("\nsaving cqt2 spectrogram:[%ld] datapoints.\n ", bufferLength); 


	FILE * pFile;
  	pFile = fopen ("cqt2.out", "wb");

 	if (pFile==NULL)
 	{
      DBG("CQT output2 file not created.\n");
      return;
   }
  	fwrite (buffer , sizeof(double), bufferLength , pFile);
  	fclose (pFile);

	DBG("saved\n "); //fflush(stdout);
}

*/


int main(int argc, char** argv)
{
   float* audiosig; 
   int n;
   float min_energ_th = 0.01; 



if (argc<2) 
{
   DBG("This command requires at least one argument: wave file path.\n");
   return 0;
}

if (argc>2)
{
   min_energ_th = atof(argv[2]);
   DBG("min energ th: %f \n", min_energ_th);
}


   CQTransform cqt;
   PLCA plca;
   plca.load_dictionary("./data/dict.cqt");

   int wsize = 4096;
   //int hsize = 2048;
   //int hsize = 512;
   int hsize = 256;
//   vector<double> sumsAll; 
//   vector<double> sums; 
//   vector<double*> frames;


   // open wave file
   cout << "file: "<<argv[1]<<endl;
   read_wave_file(argv[1], audiosig, &n);

   int c=0;
   double*cqtBuffer = new double[cqt.CQT_BINS_SIZE];
for (int i=0; i<n-wsize; i+=hsize)
{
   printf("\r%.4d",c++); fflush(stdout);
   float* frame = audiosig + i;
   cqt.process_cqt(frame, wsize, cqtBuffer);   
// norm_array(cqtBuffer, CQT_BINS_SIZE);
   plca.process(cqtBuffer);
}

delete audiosig;

cqt.save_cqt();
plca.save_plca();



//TODO free buffers!!!!
//
//
   return 0;
}




