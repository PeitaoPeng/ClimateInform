/*Author: Rainer Hegger Last modified: Sep 4, 1999 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <limits.h>
#include "routines/tsa.h"

#define WID_STR "This programs makes a recurrence plot for the data."

#define BOX 1024

unsigned long length=ULONG_MAX,exclude=0;
unsigned int column=1,dim=1,delay=1;
unsigned int verbosity=0xff;
double eps=1.e-3,fraction=1.0;
char *outfile=NULL,stdo=1;
char *infile=NULL;
char epsset=0;

double *series;
long box[BOX],*list;

void show_options(char *progname)
{
  what_i_do(progname,WID_STR);
  fprintf(stderr,"Usage: %s [options]\n",progname);
  fprintf(stderr,"Options:\n");
  fprintf(stderr,"Everything not being a valid option will be interpreted"
          " as a possible"
          " datafile.\nIf no datafile is given stdin is read. Just - also"
          " means stdin\n");
  fprintf(stderr,"\t-l # of data to use [Default: whole file]\n");
  fprintf(stderr,"\t-x # of lines to be ignored [Default: 0]\n");
  fprintf(stderr,"\t-c column to read [Default: 1]\n");
  fprintf(stderr,"\t-m embedding dimension [Default: 1]\n");
  fprintf(stderr,"\t-d delay [Default: 1]\n");
  fprintf(stderr,"\t-r size of the neighbourhood "
	  "[Default: (data interval)/1000]\n");
  fprintf(stderr,"\t-%% print only a percentage of points found [Default: "
	  " 100.0]\n");
  fprintf(stderr,"\t-o output file name [Default: 'datafile'.rec\n"
	  "\t\twithout -o: stdout]\n");
  fprintf(stderr,"\t-V verbosity level [Default: 1]\n\t\t"
          "0='only panic messages'\n\t\t"
          "1='+ input/output messages'\n");
  fprintf(stderr,"\t-h show these options\n");
  exit(0);
}

void scan_options(int n,char **in)
{
  char *out;

  if ((out=check_option(in,n,'l','u')) != NULL)
    sscanf(out,"%lu",&length);
  if ((out=check_option(in,n,'x','u')) != NULL)
    sscanf(out,"%lu",&exclude);
  if ((out=check_option(in,n,'c','u')) != NULL)
    sscanf(out,"%u",&column);
  if ((out=check_option(in,n,'m','u')) != NULL)
    sscanf(out,"%u",&dim);
  if ((out=check_option(in,n,'d','u')) != NULL)
    sscanf(out,"%u",&delay);
  if ((out=check_option(in,n,'V','u')) != NULL)
    sscanf(out,"%u",&verbosity);
  if ((out=check_option(in,n,'r','f')) != NULL) {
    epsset=1;
    sscanf(out,"%lf",&eps);
  }
  if ((out=check_option(in,n,'%','f')) != NULL) {
    sscanf(out,"%lf",&fraction);
    fraction /= 100.0;
  }
  if ((out=check_option(in,n,'o','o')) != NULL) {
    stdo=0;
    if (strlen(out) > 0)
      outfile=out;
  }
}

void lmake_box(void)
{
  int i,x;
  double epsinv;
  int ibox=BOX-1;

  epsinv=1./eps;

  for (i=0;i<BOX;i++)
    box[i] = -1;

  for (i=(dim-1)*delay;i<length;i++) {
    x=(int)(series[i]*epsinv)&ibox;
    list[i]=box[x];
    box[x]=i;
  }
}

void lfind_neighbors(void)
{
  int i,i1,j,j1;
  int ibox=BOX-1;
  long n,element;
  double dx,epsinv;
  FILE *fout=NULL;

  epsinv=1./eps;
  rnd_init(0x9834725L);

  if (!stdo) {
    fout=fopen(outfile,"w");
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Opened %s for writing\n",outfile);
  }
  else {
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Writing to stdout\n");
  }

  for (n=(dim-1)*delay;n<length;n++) {
    i=(int)(series[n]*epsinv)&ibox;
    for (i1=i-1;i1<=i+1;i1++) {
      element=box[i1&ibox];
      while (element >= n) {
	for (j=0;j<dim;j++) {
	  j1=j*delay;
	  dx=fabs(series[n-j1]-series[element-j1]);
	  if (dx > eps)
	    break;
	}
	if (j == dim)
	  if (((double)rnd69069()/ULONG_MAX) <= fraction) {
	    if (!stdo)
	      fprintf(fout,"%ld %ld\n",n,element);
	    else
	      fprintf(stdout,"%ld %ld\n",n,element);
	  }
	element=list[element];
      }
    }
  }
  if (!stdo)
    fclose(fout);
}

int main(int argc,char **argv)
{
  char stdi=0;
  double min,max;

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
      strcat(outfile,".rec");
    }
    else {
      check_alloc(outfile=(char*)calloc((size_t)10,(size_t)1));
      strcpy(outfile,"stdin.rec");
    }
  }
  if (!stdo)
    test_outfile(outfile);

  series=(double*)get_series(infile,&length,exclude,column,verbosity);
  rescale_data(series,length,&min,&max);

  if (epsset)
    eps /= max;

  check_alloc(list=(long*)malloc(sizeof(long)*length));
  
  lmake_box();
  lfind_neighbors();

  return 0;
}
