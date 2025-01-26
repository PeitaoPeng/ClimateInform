/*Author: Rainer Hegger, Last modified: Feb 10, 1999 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <math.h>
#include "routines/tsa.h"

#define WID_STR "Makes an AR ansatz to the data and gives the coefficients\
\n\tand the residues"

unsigned long length=ULONG_MAX,exclude=0;
unsigned int column=1,poles=5;
unsigned int verbosity=0xff;
char *outfile=NULL,stdo=1;
char *infile=NULL;
double *series;

void show_options(char *progname)
{
  what_i_do(progname,WID_STR);
  fprintf(stderr," Usage: %s [options]\n",progname);
  fprintf(stderr," Options:\n");
  fprintf(stderr,"Everything not being a valid option will be interpreted"
	  " as a possible"
	  " datafile.\nIf no datafile is given stdin is read. Just - also"
	  " means stdin\n");
  fprintf(stderr,"\t-l length of file [default is whole file]\n");
  fprintf(stderr,"\t-x # of lines to be ignored [default is 0]\n");
  fprintf(stderr,"\t-c column to read [default is 1]\n");
  fprintf(stderr,"\t-p #order of AR-Fit [default is 5]\n");
  fprintf(stderr,"\t-o output file name [default is 'datafile'.ar]\n");
  fprintf(stderr,"\t-V verbosity level [default is 1]\n\t\t"
	  "0='only panic messages'\n\t\t"
	  "1='+ input/output messages'\n");
  fprintf(stderr,"\t-h show these options\n\n");
  exit(0);
}

void scan_options(int argc,char **argv)
{
  char *out;

  if ((out=check_option(argv,argc,'p','u')) != NULL)
    sscanf(out,"%u",&poles);
  if ((out=check_option(argv,argc,'l','u')) != NULL)
    sscanf(out,"%lu",&length);
  if ((out=check_option(argv,argc,'x','u')) != NULL)
    sscanf(out,"%lu",&exclude);
  if ((out=check_option(argv,argc,'c','u')) != NULL)
    sscanf(out,"%u",&column);
  if ((out=check_option(argv,argc,'V','u')) != NULL)
    sscanf(out,"%u",&verbosity);
  if ((out=check_option(argv,argc,'o','o')) != NULL) {
    stdo=0;
    if (strlen(out) > 0)
      outfile=out;
  }
}

int main(int argc,char **argv)
{
  char stdi=0;
  double pm,h;
  long i,j,k,hi,hj;
  FILE *file;
  double **mat,*vec,*diff,av,var;

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
      check_alloc(outfile=(char*)calloc(strlen(infile)+4,(size_t)1));
      strcpy(outfile,infile);
      strcat(outfile,".ar");
    }
    else {
      check_alloc(outfile=(char*)calloc((size_t)9,(size_t)1));
      strcpy(outfile,"stdin.ar");
    }
  }
  if (!stdo)
    test_outfile(outfile);

  series=(double*)get_series(infile,&length,exclude,column,verbosity);
  variance(series,length,&av,&var);
  for (i=0;i<length;i++)
    series[i] -= av;

  if (poles >= length)
    poles=length-1;
  
  check_alloc(vec=(double*)malloc(sizeof(double)*poles));
  check_alloc(mat=(double**)malloc(sizeof(double*)*poles));
  for (i=0;i<poles;i++)
    check_alloc(mat[i]=(double*)malloc(sizeof(double)*poles));

  for (i=0;i<poles;i++) {
    vec[i]=0.0;
    for (j=0;j<poles;j++)
      mat[i][j]=0.0;
  }
  for (i=poles-1;i<length-1;i++) {
    hi=i+1;
    for (j=0;j<poles;j++) {
      hj=i-j;
      vec[j] += series[hi]*series[hj];
      for (k=j;k<poles;k++)
	mat[j][k] += series[hj]*series[i-k];
    }
  }
  for (i=0;i<poles;i++) {
    vec[i] /= (length-poles);
    for (j=i;j<poles;j++) {
      mat[i][j] /= (length-poles);
      mat[j][i]=mat[i][j];
    }
  }

  solvele(mat,vec,poles);

  check_alloc(diff=(double*)malloc(sizeof(double)*length));
  pm=0.0;
  for (i=poles-1;i<length-1;i++) {
    h=0.0;
    hi=i+1;
    for (j=0;j<poles;j++)
      h += series[i-j]*vec[j];
    diff[i] = series[hi]-h;
    pm += diff[i]*diff[i];
  }

  if (!stdo) {
    file=fopen(outfile,"w");
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Opened %s for output\n",outfile);
    fprintf(file,"#forecast error= %e\n",sqrt(pm/(length-poles)));
    for (i=0;i<poles;i++)
      fprintf(file,"# %e\n",vec[i]);
    for (i=poles-1;i<length-1;i++)
      fprintf(file,"%e\n",diff[i]);
    fclose(file);
  }
  else {
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Writing to stdout\n");
    fprintf(stdout,"#forecast error= %e\n",sqrt(pm/(length-poles)));
    for (i=0;i<poles;i++)
      fprintf(stdout,"# %e\n",vec[i]);
    for (i=poles-1;i<length-1;i++)
      fprintf(stdout,"%e\n",diff[i]);
  }

  return 0;
}




