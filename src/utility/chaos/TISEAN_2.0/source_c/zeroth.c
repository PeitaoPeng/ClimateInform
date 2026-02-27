/*Author: Rainer Hegger. Last modified: Sep 4, 1999 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include "routines/tsa.h"

#define WID_STR "Estimates the average forecast error for a zeroth\n\t\
order fit"

#ifndef _MATH_H
#include <math.h>
#endif

/*number of boxes for the neighbor search algorithm*/
#define NMAX 128

unsigned int nmax=(NMAX-1);
unsigned int verbosity=0xff;
long **box,*list;
unsigned long *found;
double *series;
double interval,min,epsilon;

char epsset=0;
char *infile=NULL;
char *outfile=NULL,stdo=1,clengthset=0;
unsigned int COLUMN=1,refstep=1;
int DIM=3,DELAY=1,MINN=30,STEP=1;
double EPS0=1.e-3,EPSF=1.2;
unsigned long LENGTH=ULONG_MAX,exclude=0,CLENGTH;

void show_options(char *progname)
{
  what_i_do(progname,WID_STR);
  fprintf(stderr," Usage: %s [options]\n",progname);
  fprintf(stderr," Options:\n");
  fprintf(stderr,"Everything not being a valid option will be interpreted"
          " as a possible"
          " datafile.\nIf no datafile is given stdin is read. Just - also"
          " means stdin\n");
  fprintf(stderr,"\t-l # of data to use [default: whole file]\n");
  fprintf(stderr,"\t-x # of lines to be ignored [default: 0]\n");
  fprintf(stderr,"\t-c column to read [default: 1]\n");
  fprintf(stderr,"\t-m embedding dimension [default: 3]\n");
  fprintf(stderr,"\t-d delay [default: 1]\n");
  fprintf(stderr,"\t-n # of reference points [default: length]\n");
  fprintf(stderr,"\t-S distance between reference points [default: %d]\n",
	  refstep);
  fprintf(stderr,"\t-k minimal number of neighbors for the fit "
	  "[default: 30]\n");
  fprintf(stderr,"\t-r neighborhoud size to start with "
	  "[default: (data interval)/1000]\n");
  fprintf(stderr,"\t-f factor to increase size [default: 1.2]\n");
  fprintf(stderr,"\t-s steps to forecast [default: 1]\n");
  fprintf(stderr,"\t-o output file [default: 'datafile.zer',"
	  " without -o: stdout]\n");
  fprintf(stderr,"\t-V verbosity level [default: 1]\n\t\t"
          "0='only panic messages'\n\t\t"
          "1='+ input/output messages'\n");
  fprintf(stderr,"\t-h show these options\n");
  exit(0);
}

void scan_options(int n,char **in)
{
  char *out;

  if ((out=check_option(in,n,'l','u')) != NULL)
    sscanf(out,"%lu",&LENGTH);
  if ((out=check_option(in,n,'x','u')) != NULL)
    sscanf(out,"%lu",&exclude);
  if ((out=check_option(in,n,'c','u')) != NULL)
    sscanf(out,"%u",&COLUMN);
  if ((out=check_option(in,n,'m','u')) != NULL)
    sscanf(out,"%u",&DIM);
  if ((out=check_option(in,n,'d','u')) != NULL)
    sscanf(out,"%u",&DELAY);
  if ((out=check_option(in,n,'n','u')) != NULL) {
    sscanf(out,"%lu",&CLENGTH);
    clengthset=1;
  }
  if ((out=check_option(in,n,'S','u')) != NULL) {
    sscanf(out,"%u",&refstep);
    if (refstep < 1) 
      refstep=1;
  }
  if ((out=check_option(in,n,'k','u')) != NULL)
    sscanf(out,"%u",&MINN);
  if ((out=check_option(in,n,'r','f')) != NULL) {
    epsset=1;
    sscanf(out,"%lf",&EPS0);
  }
  if ((out=check_option(in,n,'f','f')) != NULL)
    sscanf(out,"%lf",&EPSF);
  if ((out=check_option(in,n,'s','u')) != NULL)
    sscanf(out,"%u",&STEP);
  if ((out=check_option(in,n,'V','u')) != NULL)
    sscanf(out,"%u",&verbosity);
  if ((out=check_option(in,n,'o','o')) != NULL) {
    stdo=0;
    if (strlen(out) > 0)
      outfile=out;
  }
}

double make_fit(long act,unsigned long number,long istep)
{
  double casted=0.0;
  int i;
  
  for (i=0;i<number;i++)
    casted += series[found[i]+istep];
  casted /= number;

  return (casted-series[act+istep])*(casted-series[act+istep]);
}

int main(int argc,char **argv)
{
  char stdi=0;
  char alldone,*done;
  long i,j;
  unsigned long *hfound;
  unsigned long actfound;
  unsigned long clength;
  long hi;
  double rms,av,*error;
  FILE *file;

  if (scan_help(argc,argv))
    show_options(argv[0]);
  
  scan_options(argc,argv);
#ifndef OMIT_WHAT_I_DO
  if (verbosity&VER_INPUT)
    what_i_do(argv[0],WID_STR);
#endif

  infile=search_datafile(argc,argv,&COLUMN,verbosity);
  if (infile == NULL)
    stdi=1;

  if (outfile == NULL) {
    if (!stdi) {
      check_alloc(outfile=(char*)calloc(strlen(infile)+5,(size_t)1));
      sprintf(outfile,"%s.zer",infile);
    }
    else {
      check_alloc(outfile=(char*)calloc((size_t)10,(size_t)1));
      sprintf(outfile,"stdin.zer");
    }
  }
  if (!stdo)
    test_outfile(outfile);

  series=(double*)get_series(infile,&LENGTH,exclude,COLUMN,verbosity);
  if (!clengthset)
    CLENGTH=LENGTH;

  rescale_data(series,LENGTH,&min,&interval);
  variance(series,LENGTH,&av,&rms);
  
  check_alloc(list=(long*)malloc(sizeof(long)*LENGTH));
  check_alloc(found=(unsigned long*)malloc(sizeof(long)*LENGTH));
  check_alloc(hfound=(unsigned long*)malloc(sizeof(long)*LENGTH));
  check_alloc(done=(char*)malloc(sizeof(char)*LENGTH));
  check_alloc(box=(long**)malloc(sizeof(long*)*NMAX));
  check_alloc(error=(double*)malloc(sizeof(double)*STEP));
  for (i=0;i<STEP;i++)
    error[i]=0.0;

  for (i=0;i<NMAX;i++)
    check_alloc(box[i]=(long*)malloc(sizeof(long)*NMAX));
    
  for (i=0;i<LENGTH;i++)
    done[i]=0;

  alldone=0;
  if (epsset)
    EPS0 /= interval;

  epsilon=EPS0/EPSF;
  clength=((CLENGTH*refstep+STEP) <= LENGTH) ? CLENGTH : (LENGTH-STEP)/refstep;

  while (!alldone) {
    alldone=1;
    epsilon*=EPSF;
    make_box(series,box,list,LENGTH-STEP,NMAX,(unsigned int)DIM,
	     (unsigned int)DELAY,epsilon);
    for (i=(DIM-1)*DELAY;i<clength;i++)
      if (!done[i]) {
	hi=i*refstep;
	actfound=find_neighbors(series,box,list,series+hi,LENGTH,NMAX,
				(unsigned int)DIM,(unsigned int)DELAY,
				epsilon,hfound);
	actfound=exclude_interval(actfound,hi-STEP+1,hi+STEP+(DIM-1)*DELAY-1,
				  hfound,found);
	if (actfound >= MINN) {
	  for (j=1;j<=STEP;j++)
	    error[j-1] += make_fit(hi,actfound,j);
	  done[i]=1;
	}
	alldone &= done[i];
      }
  }
  if (stdo) {
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Writing to stdout\n");
    for (i=0;i<STEP;i++)
      fprintf(stdout,"%lu %e\n",i+1,sqrt(error[i]/(clength-(DIM-1)*DELAY))/rms);
  }
  else {
    file=fopen(outfile,"w");
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Opened %s for writing\n",outfile);
    for (i=0;i<STEP;i++)
      fprintf(file,"%lu %e\n",i+1,sqrt(error[i]/(clength-(DIM-1)*DELAY))/rms);
    fclose(file);
  }
  
  return 0;
}
