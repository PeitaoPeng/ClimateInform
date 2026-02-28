/*Author: Rainer Hegger Last modified: Sep 4, 1999 */
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <limits.h>
#include <time.h>
#include "routines/tsa.h"

#define WID_STR "Adds noise to a time series"

char *outfile=NULL,cgaussian,stout=1;
char *infile=NULL;
char absolute=0;
unsigned long length=ULONG_MAX,exclude=0,iseed=3441341;
unsigned int column=1;
unsigned int verbosity=0xff;
double *array,noiselevel=0.05,sigmax=0.0;

void show_options(char *progname)
{
  what_i_do(progname,WID_STR);
  fprintf(stderr," Usage: %s [Options]\n\n",progname);
  fprintf(stderr," Options:\n");
  fprintf(stderr,"Everything not being a valid option will be interpreted"
          " as a possible"
          " datafile.\nIf no datafile is given stdin is read. Just - also"
          " means stdin\n");
  fprintf(stderr,"\t-l # of points to be used [Default is whole file]\n");
  fprintf(stderr,"\t-x # of lines to be ignored [Default is %lu]\n",exclude);
  fprintf(stderr,"\t-c column to read  [Default is %u]\n",column);
  fprintf(stderr,"\t-%% noiselevel in %% [Default is %.1e%%]\n",
	  noiselevel*100.0);
  fprintf(stderr,"\t-r absolute noise level (or absolute variance in case\n"
	  "\t\tof gaussian noise) [Default is not set]\n");
  fprintf(stderr,"\t-g (use gaussian noise)     [Default is uniform]\n");
  fprintf(stderr,"\t-I seed for the rnd-generator (If seed=0, the time\n"
	  "\t\tcommand is used to set the seed) [Default is fixed]\n");
  fprintf(stderr,"\t-o outfile [Without argument 'datafile'.noi;"
	  " Without -o stdout is used]\n");
  fprintf(stderr,"\t-V verbosity level [Default is 1]\n\t\t"
          "0='only panic messages'\n\t\t"
          "1='+ input/output messages'\n");
  fprintf(stderr,"  -h show these options");
  fprintf(stderr,"\n");
  exit(0);
}

void scan_options(int n,char** in)
{
  char *out;
  
  if ((out=check_option(in,n,'l','u')) != NULL)
    sscanf(out,"%lu",&length);
  if ((out=check_option(in,n,'x','u')) != NULL)
    sscanf(out,"%lu",&exclude);
  if ((out=check_option(in,n,'c','u')) != NULL)
    sscanf(out,"%u",&column);
  if ((out=check_option(in,n,'%','f')) != NULL) {
    sscanf(out,"%lf",&noiselevel);
    noiselevel /= 100.0;
  }
  if ((out=check_option(in,n,'r','f')) != NULL) {
    sscanf(out,"%lf",&noiselevel);
    absolute=1;
  }
  if ((out=check_option(in,n,'g','n')) != NULL)
    cgaussian=1;
  if ((out=check_option(in,n,'I','u')) != NULL) {
    sscanf(out,"%lu",&iseed);
    if (iseed == 0)
      iseed=(unsigned long)time((time_t*)&iseed);
  }
  if ((out=check_option(in,n,'V','u')) != NULL)
    sscanf(out,"%u",&verbosity);
  if ((out=check_option(in,n,'o','o')) != NULL) {
    stout=0;
    if (strlen(out) > 0)
      outfile=out;
  }
}

void equidistri(void) 
{
  int i;
  double limit,equinorm;
  
  equinorm=(double)ULONG_MAX;
  if (!absolute)
    limit=2.0*sqrt(3.0)*sigmax*noiselevel;
  else
    limit=2.0*noiselevel;
  for (i=0;i<length;i++)
    array[i] += (limit*((double)rnd_1279()/equinorm-0.5));
} 

void gauss(void)
{
  int i;
  double glevel;

  if (!absolute)
    glevel=noiselevel*sigmax;
  else
    glevel=noiselevel;
  for (i=0;i<length;i++)
    array[i] += gaussian(glevel);
}

int main(int argc,char** argv)
{
  char stdi=0;
  long i;
  double av=0.0;
  FILE *fout;

  if (scan_help(argc,argv))
    show_options(argv[0]);

  scan_options(argc,argv);
#ifndef OMIT_WHAT_I_DO
  if (verbosity&VER_INPUT)
    what_i_do(argv[0],WID_STR);
#endif

  infile=search_datafile(argc,argv,&column,verbosity);
  if (infile == NULL)
    stdi=1;

  if (outfile == NULL) {
    if (!stdi) {
      check_alloc(outfile=(char*)calloc(strlen(infile)+5,(size_t)1));
      strcpy(outfile,infile);
      strcat(outfile,".noi");
    }
    else {
      check_alloc(outfile=(char*)calloc((size_t)10,(size_t)1));
      strcpy(outfile,"stdin.noi");
    }
  }
  if (!stout)
    test_outfile(outfile);

  array=(double*)get_series(infile,&length,exclude,column,verbosity);
  if (!absolute) {
    variance(array,length,&av,&sigmax);
    if (sigmax == 0.0) {
      fprintf(stderr,"Variance of the data is Zero. Use the -r flag!\n");
      exit(127);
    }
  }

  rnd_init(iseed);

  for (i=0;i<10000;i++) rnd_1279();

  if (!cgaussian)
    equidistri();
  else
    gauss();

  if (!stout) {
    fout=fopen(outfile,"w");
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Opened %s for writing\n",outfile);
    for (i=0;i<length;i++)
      fprintf(fout,"%e\n",array[i]);
    fclose(fout);
  }
  else {
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Writing to stdout\n");
    for (i=0;i<length;i++)
      fprintf(stdout,"%e\n",array[i]);
  }

  return 0;
}
