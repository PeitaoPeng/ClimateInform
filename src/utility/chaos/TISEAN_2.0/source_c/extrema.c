/*Author: Rainer Hegger Last modified: Sep 3, 1999 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <limits.h>
#include "routines/tsa.h"

#define WID_STR "Determines the maxima (minima) of a time series"


unsigned long length=ULONG_MAX,exclude=0;
unsigned int column=1;
unsigned int verbosity=0xff;
double mintime=0.0;
char maxima=1;
char stdo=1;
char *outfile=NULL;
char *infile=NULL;

void show_options(char *progname)
{
  what_i_do(progname,WID_STR);
  fprintf(stderr,"Usage: %s [options]\n",progname);
  fprintf(stderr,"Options:\n");
  fprintf(stderr,"Everything not being a valid option will be interpreted"
          " as a possible"
          " datafile.\nIf no datafile is given stdin is read. Just - also"
          " means stdin\n");
  fprintf(stderr,"\t-l # of points to use [Default: whole file]\n");
  fprintf(stderr,"\t-x # of lines to be ignored [Default: 0]\n");
  fprintf(stderr,"\t-c column to read [Default: 1]\n");
  fprintf(stderr,"\t-z determine minima instead of maxima [Default: maxima]\n");
  fprintf(stderr,"\t-t minimal required time between two extrema "
	  "[Default: 0.0]\n");
  fprintf(stderr,"\t-o output file name [Default: 'datafile'.ext,"
	  " without -o: stdout]\n");
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
  if ((out=check_option(in,n,'z','n')) != NULL)
    maxima=0;
  if ((out=check_option(in,n,'t','f')) != NULL)
    sscanf(out,"%lf",&mintime);
  if ((out=check_option(in,n,'V','u')) != NULL)
    sscanf(out,"%u",&verbosity);
  if ((out=check_option(in,n,'o','o')) != NULL) {
    stdo=0;
    if (strlen(out) > 0)
      outfile=out;
  }
}

int main(int argc,char **argv)
{
  char stdi=0,firstfound=0;
  unsigned long i;
  double *series;
  double x[3],a,b,c,lasttime,nexttime;
  FILE *fout=NULL;

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
      sprintf(outfile,"%s.ext",infile);
    }
    else {
      check_alloc(outfile=(char*)calloc((size_t)10,(size_t)1));
      sprintf(outfile,"stdin.ext");
    }
  }

  series=(double*)get_series(infile,&length,exclude,column,verbosity);

  if (!stdo) {
    test_outfile(outfile);    
    fout=fopen(outfile,"w");
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Opened %s for writing\n",outfile);
  }
  else {
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Writing to stdout\n");
  }

  lasttime=0.0;
  x[0]=series[0];
  x[1]=series[1];
  for (i=2;i<length;i++) {
    x[2]=series[i];
    if (maxima) {
      if ((x[1] >= x[0]) && (x[1] > x[2])) {
	a=x[1];
	b=(x[2]-x[0])/2.0;
	c=(x[2]-2.0*x[1]+x[0])/2.0;
	nexttime=(double)i-b/2.0/c-1.;
	if ((nexttime-lasttime) >= mintime) {
	  if (firstfound) {
	    if (!stdo)
	      fprintf(fout,"%e %e\n",a-b*b/4.0/c,nexttime-lasttime);
	    else
	      fprintf(stdout,"%e %e\n",a-b*b/4.0/c,nexttime-lasttime);
	  }
	  firstfound=1;
	  lasttime=nexttime;
	}
      }
    }
    else {
      if ((x[1] <= x[0]) && (x[1] < x[2])) {
	a=x[1];
	b=(x[2]-x[0])/2.0;
	c=(x[2]-2.0*x[1]+x[0])/2.0;
	nexttime=(double)i-b/2.0/c-1.;
	if ((nexttime-lasttime) >= mintime) {
	  if (firstfound) {
	    if (!stdo)
	      fprintf(fout,"%e %e\n",a-b*b/4.0/c,nexttime-lasttime);
	    else
	      fprintf(stdout,"%e %e\n",a-b*b/4.0/c,nexttime-lasttime);
	  }
	  firstfound=1;
	  lasttime=nexttime;
	}
      }
    }
    x[0]=x[1];
    x[1]=x[2];
  }
  if (!stdo)
    fclose(fout);

  return 0;
}
