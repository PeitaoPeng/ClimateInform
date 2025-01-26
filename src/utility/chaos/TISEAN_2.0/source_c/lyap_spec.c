/*Author: Rainer Hegger, last modified Sep 21, 1999  */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <limits.h>
#include <time.h>
#include <string.h>
#include "routines/tsa.h"

#define WID_STR "Estimates the spectrum of Lyapunov exponents using the\n\t\
method of Sano and Sawada."


#define OUT 10

#define BOX 512
#define EPSMAX 1.0

char epsset=0,stdo=1;
char INVERSE,*outfile=NULL;
char *infile=NULL;
unsigned long LENGTH=ULONG_MAX,ITERATIONS,exclude=0;
int DIMENSION=2,DELAY=1,MINNEIGHBORS=30;
unsigned int COLUMNS=1;
unsigned int verbosity=0xff;
double EPSSTEP=1.2;

double *series,min,intervall,averr=0.0,avneig=0.0,aveps=0.0;
double epsmin;
long imax=BOX-1,dim,count=0;
long **box,*list;
unsigned long *found;
double **mat,*vec,varianz,av;

void show_options(char *progname)
{
  what_i_do(progname,WID_STR);
  fprintf(stderr," Usage: %s [options]\n",progname);
  fprintf(stderr," Options:\n");
  fprintf(stderr,"Everything not being a valid option will be interpreted"
          " as a possible"
          " datafile.\nIf no datafile is given stdin is read. Just - also"
          " means stdin\n");
  fprintf(stderr,"\t-l # of datapoints [default is whole file]\n");
  fprintf(stderr,"\t-x # of lines to be ignored [default is 0]\n");
  fprintf(stderr,"\t-c column to read[default 1]\n");
  fprintf(stderr,"\t-m embedding dimension [default 2]\n");
  fprintf(stderr,"\t-d delay  [default 1]\n");
  fprintf(stderr,"\t-r epsilon size to start with [default "
  "(data interval)/1000]\n");
  fprintf(stderr,"\t-f factor to increase epsilon [default: 1.2]\n");
  fprintf(stderr,"\t-k # of neighbors to use [default: 30]\n");
  fprintf(stderr,"\t-n # of iterations [default: length]\n");
  fprintf(stderr,"\t-I invert the time series [default: no]\n");
  fprintf(stderr,"\t-o name of output file [default 'datafile'.lyaps]\n");
  fprintf(stderr,"\t-V verbosity level [default: 1]\n\t\t"
          "0='only panic messages'\n\t\t"
          "1='+ input/output messages'\n");
  fprintf(stderr,"\t-h show these options\n");
  fprintf(stderr,"\n");
  exit(0);
}

void scan_options(int n,char **argv)
{
  char *out;
  
  if ((out=check_option(argv,n,'l','u')) != NULL)
    sscanf(out,"%lu",&LENGTH);
  if ((out=check_option(argv,n,'x','u')) != NULL)
    sscanf(out,"%lu",&exclude);
  if ((out=check_option(argv,n,'c','u')) != NULL)
    sscanf(out,"%u",&COLUMNS);
  if ((out=check_option(argv,n,'d','u')) != NULL)
    sscanf(out,"%u",&DELAY);
  if ((out=check_option(argv,n,'m','u')) != NULL)
    sscanf(out,"%u",&DIMENSION);
  if ((out=check_option(argv,n,'n','u')) != NULL)
    sscanf(out,"%lu",&ITERATIONS);
  if ((out=check_option(argv,n,'r','f')) != NULL) {
    epsset=1;
    sscanf(out,"%lf",&epsmin);
  }
  if ((out=check_option(argv,n,'f','f')) != NULL)
    sscanf(out,"%lf",&EPSSTEP);
  if ((out=check_option(argv,n,'k','u')) != NULL)
    sscanf(out,"%u",&MINNEIGHBORS);
  if ((out=check_option(argv,n,'V','u')) != NULL)
    sscanf(out,"%u",&verbosity);
  if ((out=check_option(argv,n,'I','n')) != NULL)
    INVERSE=1;
  if ((out=check_option(argv,n,'o','o')) != NULL) {
    stdo=0;
    if (strlen(out) > 0)
      outfile=out;
  }
}
      
double sort(long act,unsigned long nfound)
{
  double maxeps=0.0,dx,*abstand,dswap;
  int i,j,del,hf,iswap;

  check_alloc(abstand=(double*)malloc(nfound*sizeof(double)));

  for (i=0;i<nfound;i++) {
    hf=found[i];
    abstand[i]=fabs(series[act]-series[hf]);
    for (j=1;j<DIMENSION;j++) {
      del=j*DELAY;
      dx=fabs(series[act-del]-series[hf-del]);
      if (dx > abstand[i]) abstand[i]=dx;
    }
  }
  for (i=0;i<nfound-1;i++)
    for (j=i+1;j<nfound;j++)
      if (abstand[j]<abstand[i]) {
	dswap=abstand[i];
	abstand[i]=abstand[j];
	abstand[j]=dswap;
	iswap=found[i];
	found[i]=found[j];
	found[j]=iswap;
      }
  maxeps=abstand[MINNEIGHBORS-1];
  free(abstand);

  return maxeps;
}

void make_dynamics(double *dynamics,long act)
{
  long i,j=0,k,t=act;
  unsigned long nfound=0;
  double epsilon,hv,hv1;
  double new;
  
  for (epsilon=epsmin;epsilon<=EPSMAX;epsilon*=EPSSTEP) {
    make_box(series,box,list,LENGTH-DELAY,BOX,(unsigned int)DIMENSION,
	     DELAY,epsilon);
    nfound=find_neighbors(series,box,list,series+act,LENGTH-DELAY,BOX,
			  (unsigned int)DIMENSION,DELAY,epsilon,found);
    if (nfound >= MINNEIGHBORS) {
      epsilon=sort(act,nfound);
      nfound=MINNEIGHBORS;
      break;
    }
  }
  avneig+=nfound;
  aveps+=epsilon;
  epsmin=aveps/count;
  if (nfound < MINNEIGHBORS) {
    fprintf(stderr,"#Not enough neighbors found. Exiting\n");
    exit(1);
  }
  
  for (i=0;i<=DIMENSION;i++) {
    vec[i]=0.0;
    for (j=0;j<=DIMENSION;j++) 
      mat[i][j]=0.0;
  }
  
  for (i=0;i<nfound;i++) {
    act=found[i];
    hv=series[act+DELAY];
    vec[0] += hv;
    mat[0][0] += 1.0;
    for (j=1;j<=DIMENSION;j++)
      mat[0][j] += series[act-(j-1)*DELAY];
    for (j=1;j<=DIMENSION;j++) {
      hv1=series[act-(j-1)*DELAY];
      vec[j] += hv*hv1;
      for (k=j;k<=DIMENSION;k++)
	mat[j][k]+=series[act-(k-1)*DELAY]*hv1;
    }
  }

  for (i=0;i<=DIMENSION;i++) {
    vec[i]/=(double)nfound;
    for (j=i;j<=DIMENSION;j++)
      mat[j][i]=(mat[i][j]/=(double)nfound);
  }

  solvele(mat,vec,(unsigned int)(DIMENSION+1));
  
  for (i=1;i<=DIMENSION;i++)
    dynamics[DIMENSION-i]=vec[i];
  
  new=vec[0];
  for (i=1;i<=DIMENSION;i++)
    new += vec[i]*series[t-(i-1)*DELAY];

  averr += (new-series[t+DELAY])*(new-series[t+DELAY]);
}

void gram_schmidt(double **delta,
		  double *stretch)
{
  double **dnew,norm,*diff;
  long i,j,k;
  
  check_alloc(diff=(double*)malloc(sizeof(double)*DIMENSION));
  check_alloc(dnew=(double**)malloc(sizeof(double*)*DIMENSION));
  for (i=0;i<DIMENSION;i++)
    check_alloc(dnew[i]=(double*)malloc(sizeof(double)*DIMENSION));

  for (i=0;i<DIMENSION;i++) {
    for (j=0;j<DIMENSION;j++) 
      diff[j]=0.0;
    for (j=0;j<i;j++) {
      norm=0.0;
      for (k=0;k<DIMENSION;k++)
	norm += delta[i][k]*dnew[j][k];
      for (k=0;k<DIMENSION;k++)
	diff[k] -= norm*dnew[j][k];
    }
    norm=0.0;
    for (j=0;j<DIMENSION;j++)
      norm += sqr(delta[i][j]+diff[j]);
    stretch[i]=(norm=sqrt(norm));
    for (j=0;j<DIMENSION;j++)
      dnew[i][j]=(delta[i][j]+diff[j])/norm;
  }
  for (i=0;i<DIMENSION;i++)
    for (j=0;j<DIMENSION;j++)
      delta[i][j]=dnew[i][j];

  free(diff);
  for (i=0;i<DIMENSION;i++)
    free(dnew[i]);
  free(dnew);
}

void make_iteration(double *dynamics,
		    double **delta)
{
  double **dnew;
  long i,j;

  check_alloc(dnew=(double**)malloc(sizeof(double*)*DIMENSION));
  for (i=0;i<DIMENSION;i++)
    check_alloc(dnew[i]=(double*)malloc(sizeof(double)*DIMENSION));

  for (i=0;i<DIMENSION;i++) 
    for (j=0;j<DIMENSION-1;j++)
      dnew[i][j]=delta[i][j+1];
  for (i=0;i<DIMENSION;i++) {
    dnew[i][DIMENSION-1]=dynamics[0]*delta[i][0];
    for (j=1;j<DIMENSION;j++)
      dnew[i][DIMENSION-1] += dynamics[j]*delta[i][j];
  }
  for (i=0;i<DIMENSION;i++)
    for (j=0;j<DIMENSION;j++)
      delta[i][j]=dnew[i][j];

  for (i=0;i<DIMENSION;i++)
    free(dnew[i]);
  free(dnew);
}

int main(int argc,char **argv)
{
  char stdi=0;
  double **delta,*dynamics,*lfactor;
  double *factor,dim;
  double *hseries;
  long start,i,j;
  time_t lasttime,newtime;
  FILE *file=NULL;

  if (scan_help(argc,argv))
    show_options(argv[0]);

  ITERATIONS=ULONG_MAX;
  
  scan_options(argc,argv);
#ifndef OMIT_WHAT_I_DO
  if (verbosity&VER_INPUT)
    what_i_do(argv[0],WID_STR);
#endif

  infile=search_datafile(argc,argv,&COLUMNS,verbosity);
  if (infile == NULL)
    stdi=1;

  if (outfile == NULL) {
    if (!stdi) {
      check_alloc(outfile=(char*)calloc(strlen(infile)+7,(size_t)1));
      strcpy(outfile,infile);
      strcat(outfile,".lyaps");
    }
    else {
      check_alloc(outfile=(char*)calloc((size_t)12,(size_t)1));
      strcpy(outfile,"stdin.lyaps");
    }
  }
  if (!stdo)
    test_outfile(outfile);

  dim=DELAY*(DIMENSION-1);

  series=(double*)get_series(infile,&LENGTH,exclude,COLUMNS,verbosity);
  if (MINNEIGHBORS > (LENGTH-DELAY*(DIMENSION-1)-1)) {
    fprintf(stderr,"Your time series is not long enough to find %d neighbors!"
	    " Exiting.\n",MINNEIGHBORS);
    exit(127);
  }
  rescale_data(series,LENGTH,&min,&intervall);
  variance(series,LENGTH,&av,&varianz);

  if (INVERSE) {
    check_alloc(hseries=(double*)malloc(sizeof(double)*LENGTH));
    for (i=0;i<LENGTH;i++)
      hseries[LENGTH-1-i]=series[i];
    for (i=0;i<LENGTH;i++)
      series[i]=hseries[i];
    free(hseries);
  }

  if (!epsset)
    epsmin=1./1000.;
  else
    epsmin /= intervall;

  check_alloc(box=(long**)malloc(sizeof(long*)*BOX));
  for (i=0;i<BOX;i++)
    check_alloc(box[i]=(long*)malloc(sizeof(long)*BOX));

  check_alloc(list=(long*)malloc(sizeof(long)*LENGTH));
  check_alloc(found=(unsigned long*)malloc(sizeof(long)*LENGTH));
  check_alloc(dynamics=(double*)malloc(sizeof(double)*DIMENSION));
  check_alloc(factor=(double*)malloc(sizeof(double)*DIMENSION));
  check_alloc(lfactor=(double*)malloc(sizeof(double)*DIMENSION));
  check_alloc(delta=(double**)malloc(sizeof(double*)*DIMENSION));
  for (i=0;i<DIMENSION;i++)
    check_alloc(delta[i]=(double*)malloc(sizeof(double)*DIMENSION));
  
  check_alloc(vec=(double*)malloc(sizeof(double)*(DIMENSION+1)));
  check_alloc(mat=(double**)malloc(sizeof(double*)*(DIMENSION+1)));
  for (i=0;i<=DIMENSION;i++)
    check_alloc(mat[i]=(double*)malloc(sizeof(double)*(DIMENSION+1)));

  for (i=0;i<DIMENSION;i++) {
    factor[i]=0.0;
    for (j=0;j<DIMENSION;j++)
      if (i<=j) delta[i][j]=1.0;
      else delta[i][j]=0.0;
  }
  gram_schmidt(delta,lfactor);
  
  start=ITERATIONS;
  if (start>(LENGTH-DELAY)) 
    start=LENGTH-DELAY;

  if (!stdo) {
    file=fopen(outfile,"w");
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Opened %s for writing\n",outfile);
  }
  else {
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Writing to stdout\n");
  }

  time(&lasttime);
  for (i=(DIMENSION-1)*DELAY;i<start;i++) {
    count++;
    make_dynamics(dynamics,i);
    make_iteration(dynamics,delta);
    gram_schmidt(delta,lfactor);
    for (j=0;j<DIMENSION;j++) {
      factor[j] += log(lfactor[j])/(double)DELAY;
    }
    if (((time(&newtime)-lasttime) > OUT) || (i == (start-1))) {
      time(&lasttime);
      if (!stdo) {
	fprintf(file,"%ld ",count);
	for (j=0;j<DIMENSION;j++) 
	  fprintf(file,"%e ",factor[j]/count);
	fprintf(file,"\n");
	fflush(file);
      }
      else {
	fprintf(stdout,"%ld ",count);
	for (j=0;j<DIMENSION;j++) 
	  fprintf(stdout,"%e ",factor[j]/count);
	fprintf(stdout,"\n");
      }
    }
  }
  
  dim=0.0;
  for (i=0;i<DIMENSION;i++) {
    dim += factor[i];
    if (dim < 0.0)
      break;
  }
  if (i < DIMENSION)
    dim=i+(dim-factor[i])/fabs(factor[i]);
  else
    dim=DIMENSION;
  if (!stdo) {
    fprintf(file,"#Average relative forecast error= %e\n",
	    sqrt(averr/count)/varianz);
    fprintf(file,"#Average Neighborhood Size= %e\n",aveps*intervall/count);
    fprintf(file,"#estimated KY-Dimension= %f\n",dim);
  }
  else {
    fprintf(stdout,"#Average relative forecast error= %e\n",
	    sqrt(averr/count)/varianz);
    fprintf(stdout,"#Average Neighborhood Size= %e\n",aveps*intervall/count);
    fprintf(stdout,"#estimated KY-Dimension= %f\n",dim);
  }
  if (!stdo)
    fclose(file);

  return 0;
}
