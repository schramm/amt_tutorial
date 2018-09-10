
#include "sch_utils.h"
//#include "sch_globals.cpp"
#include "CQTransform.h"
//#include "PLCA.h"

 
#include <dirent.h>
#include <cstring>
#include <iostream>
#include <vector>
#include <memory>
#include <string>
#include <algorithm>
#include <sys/types.h>
#include <dirent.h>


int wavfilter(const struct dirent *dir)
// post: returns 1/true if name of dir ends in .wav
{
   const char *s = dir->d_name;
   int len = strlen(s) - 4;	// index of start of . in .wav
   if(len >= 0)
   {
      if (strncmp(s + len, ".wav", 4) == 0)
      {
         return 1;
      }  
   }
   return 0;
}

vector<string> listwaves(string dirpath)
{
    vector<string> files; 
   struct dirent **eps;
   int n;

   n = scandir (dirpath.c_str(), &eps, wavfilter, alphasort);
   if (n >= 0)
   {
      int cnt;
      for (cnt = 0; cnt < n; ++cnt)
        // puts (eps[cnt]->d_name);
         files.push_back(eps[cnt]->d_name);
   }
   else
   perror ("Couldn't open the directory");

   return files;
}



void save_cqt(double* buffer,int cqt_bins_size, int pitch_range, int num_tpl, int  bufferLength, string fileout)
{
	DBG("\nsaving cqt2 spectrogram:[%ld] datapoints.\n ", bufferLength); 


	FILE * pFile;
  	pFile = fopen (fileout.c_str(), "wb");

 	if (pFile==NULL)
 	{
      DBG("CQT output2 file not created.\n");
      return;
   }
  	fwrite (&cqt_bins_size , sizeof(int), 1 , pFile);
  	fwrite (&pitch_range , sizeof(int), 1 , pFile);
  	fwrite (&num_tpl , sizeof(int), 1 , pFile);
  	fwrite (buffer , sizeof(double), bufferLength , pFile);
  	fclose (pFile);

	DBG("saved\n "); //fflush(stdout);
}




int main(int argc, char** argv)
{
   float* audiosig; 
   int n;
   float min_energ_th = 0.01; 
   string fileout;
   int num_tpl=1;


   fileout = "./data/dict.cqt";

if (argc<2) 
{
   DBG("This command requires at least one argument: directory path which contains the wave files.\n");
   cout << "usage:  cqt_template input_samples_dir   cqt_dict.out  min_th  num_templates"  << endl;
   return 0;
}

if (argc<5)
{
   fileout = "dict.cqt";
} else fileout = argv[2]; 

if (argc>3)
{
   min_energ_th = atof(argv[3]);

}
   DBG("min energ th: %f \n", min_energ_th);

if (argc>4)
{
   num_tpl =  atoi(argv[4]);
}

   DBG("num_tpl: %d \n", num_tpl);

   vector<string> files  = listwaves(argv[1]);
for (int y=0; y<files.size(); y++)
{
   cout << "wave: " << files[y] << endl;
}



   CQTransform cqt;

vector<vector<float> > templates;
for (int p=0; p<files.size(); p++)
{

   vector<double*> frames;
   int wsize = 4096;
   int hsize = 256;

   //PLCA plca;
   vector<double> sumsAll; 
   vector<double> sums; 
    float  part01[]  = {0.0,  1.0};
    float  part02[]  = {0.0, 0.20,0.60, 1.0};
   float* partitions = part01;
   if (num_tpl==3)
   {
      partitions = part02;
   }

// open wave file
//    
   string filepath = argv[1];
   filepath += files[p].c_str();

 cout << "file: "<<filepath.c_str()<<endl;
   read_wave_file(filepath.c_str(), audiosig, &n);

DBG("cqt bins: %lu \n", cqt.CQT_BINS_SIZE);

for (int i=0; i<n-wsize; i+=hsize)
{
   double*cqtBuffer = new double[cqt.CQT_BINS_SIZE];
   float* frame = audiosig + i;
   cqt.process_cqt(frame, wsize, cqtBuffer);   

   double s = sum_array(cqtBuffer, cqt.CQT_BINS_SIZE);
   sumsAll.push_back(s);
   if (s>min_energ_th)
   {
      norm_array(cqtBuffer, cqt.CQT_BINS_SIZE);
      frames.push_back(cqtBuffer);
      sums.push_back(s);
   } 
}
cout <<endl;
delete audiosig;

int totalFrames = frames.size();
DBG("total frames: %lu \n", totalFrames);

// partitions
for (int k=0; k<num_tpl; k++)
{

   int iniP = floor(partitions[k]*(float)totalFrames);
   int endP = floor(partitions[k+1]*(float)totalFrames);

   DBG("range: %d  %d\n", iniP, endP);

   vector<float> tpl;
   for (int j=0; j<cqt.CQT_BINS_SIZE; j++)
   {
      vector<float> bin;
      for (int i=iniP; i<endP; i++)
      {
         bin.push_back(frames[i][j]);
      }
      tpl.push_back(median_vector(bin));
   }

   /*
   vector<float> tpl_low(tpl);
   vector<float> tpl_high(tpl);
   tpl_low.erase(tpl_low.begin());
   tpl_low.push_back(0);
   tpl_high.pop_back();
   tpl_high.insert(tpl_high.begin(),0);
*/

 //  templates.push_back(tpl_low);
   templates.push_back(tpl);
 //  templates.push_back(tpl_high);
}  

DBG("frames: %lu \n ", frames.size());
//cqt.save_cqt();

}


vector<double> cqtValues;
for (int i=0; i<templates.size(); i++)
{ 
   for (int j=0; j<cqt.CQT_BINS_SIZE; j++)
   {
         cqtValues.push_back(templates[i][j]);
   }
}
	double* buffer = &cqtValues[0];
   save_cqt(buffer, cqt.CQT_BINS_SIZE, templates.size(), num_tpl, cqtValues.size(), fileout);


//TODO free buffers!!!!
//
   return 0;
}




