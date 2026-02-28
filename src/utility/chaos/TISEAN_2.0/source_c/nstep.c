/*Author: Rainer Hegger. Last modified: Sep 4, 1999 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include "routines/tsa.h"
#include <math.h>

#define WID_STR "Makes a local linear fit and iterates a trajectory"

#define NMAX 128

char onscreen=1,epsset=0,*outfile=NULL;
char *infile=NULL;
unsigned int nmax=(NMAX-1);
unsigned int verbosity=0xff;
long **box,*list,*found;
double *series,*cast;
double interval,min,varianz,epsilon;

int DIM=2,DELAY=1;
unsigned int COLUMN=1;
int MINN=30;
unsigned long LENGTH=ULONG_MAX,FLENGTH=1000,exclude=0;
double EPS0=1.e-3,EPSF=1.2;

void show_options(char *progname)
{
  what_i_do(progname,WID_STR);
  fprintf(stderr," Usage: %s [Options]\n",progname);
  fprintf(stderr," Options:\n");
  fprintf(stderr,"Everything not being a valid option will be interpreted"
          " as a possible"
          " datafile.\nIf no datafile is given stdin is read. Just - also"
          " means stdin\n");
  fprintf(stderr,"\t-l # of data to be used [default whole file]\n");
  fprintf(stderr,"\t-x # of lines to be ignored [default 0]\n");
  fprintf(stderr,"\t-c column [default 1]\n");
  fprintf(stderr,"\t-m dimension [default 2]\n");
  fprintf(stderr,"\t-d delay [default 1]\n");
  fprintf(stderr,"\t-L # of iterations [default 1000]\n");
  fprintf(stderr,"\t-k # of neighbors  [default 30]\n");
  fprintf(stderr,"\t-r size of initial neighborhood ["
	  " default (data interval)/1000]\n");
  fprintf(stderr,"\t-f factor to increase size [default 1.2]\n");
  fprintf(stderr,"\t-o output file [default 'datafile'.cast;"
	  " no -o means write to stdout]\n");
  fprintf(stderr,"\t-V verbosity level [default 1]\n\t\t"
          "0='only panic messages'\n\t\t"
          "1='+ input/output messages'\n");
  fprintf(stderr,"\t-h  show these options\n");
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
  if ((out=check_option(in,n,'L','u')) != NULL)
    sscanf(out,"%lu",&FLENGTH);
  if ((out=check_option(in,n,'k','u')) != NULL)
    sscanf(out,"%u",&MINN);
  if ((out=check_option(in,n,'V','u')) != NULL)
    sscanf(out,"%u",&verbosity);
  if ((out=check_option(in,n,'r','f')) != NULL) {
    epsset=1;
    sscanf(out,"%lf",&EPS0);
  }
  if ((out=check_option(in,n,'f','f')) != NULL)
    sscanf(out,"%lf",&EPSF);
  if ((out=check_option(in,n,'o','o')) != NULL) {
    onscreen=0;
    if (strlen(out) > 0)
      outfile=out;
  }
}

void put_in_boxes(void)
{
  int i,j,n;
  static int dim;
  double epsinv;

  dim=(DIM-1)*DELAY;
  epsinv=1.0/epsilon;
  for (i=0;i<NMAX;i++)
    for (j=0;j<NMAX;j++)
      box[i][j]= -1;

  for (n=dim;n<LENGTH-1;n++) {
    i=(int)(series[n]*epsinv)&nmax;
    j=(int)(series[n-dim]*epsinv)&nmax;
    list[n]=box[i][j];
    box[i][j]=n;
  }
}

unsigned int hfind_neighbors(void)
{
  int i,j,i1,i2,j1,k,element;
  static int dim;
  unsigned nfound=0;
  double max,dx,epsinv;

  dim=(DIM-1)*DELAY;
  epsinv=1.0/epsilon;
  i=(int)(cast[dim]*epsinv)&nmax;
  j=(int)(cast[0]*epsinv)&nmax;
  
  for (i1=i-1;i1<=i+1;i1++) {
    i2=i1&nmax;
    for (j1=j-1;j1<=j+1;j1++) {
      element=box[i2][j1&nmax];
      while (element != -1) {
	max=0.0;
	for (k=0;k<=dim;k += DELAY) {
	  dx=fabs(series[element-k]-cast[dim-k]);
	  max=(dx>max) ? dx : max;
	  if (max > epsilon)
	    break;
	}
	if (max <= epsilon)
	  found[nfound++]=element;
	element=list[element];
      }
    }
  }
  return nfound;
}

double make_fit(int number)
{
  double casted;
  double **mat,*vec,hs;
  double hc;
  int i,j,k,which;
  static int dim;

  dim=(DIM-1)*DELAY;
  check_alloc(vec=(double*)malloc(sizeof(double)*(DIM+1)));
  check_alloc(mat=(double**)malloc(sizeof(double*)*(DIM+1)));
  for (i=0;i<=DIM;i++)
    check_alloc(mat[i]=(double*)malloc(sizeof(double)*(DIM+1)));

  for (i=0;i<=DIM;i++) {
    vec[i]=0.0;
    for (j=0;j<=DIM;j++)
      mat[i][j]=0.0;
  }
  
  for (k=0;k<number;k++) {
    which=found[k];
    vec[0] += series[which+1];
    for (i=1;i<=DIM;i++)
      mat[0][i] += series[which-(i-1)*DELAY];
  }
  mat[0][0]=(double)number;

  for (k=0;k<number;k++) {
    which=found[k];
    for (i=1;i<=DIM;i++) {
      hs=series[which-(i-1)*DELAY];
      vec[i] += series[which+1]*hs;
      for (j=i;j<=DIM;j++)
	mat[i][j] += series[which-(j-1)*DELAY]*hs;
    }
  }
  for (i=0;i<=DIM;i++) {
    vec[i] /= number;
    for (j=i;j<=DIM;j++) {
      mat[i][j] /= number;
      mat[j][i]=mat[i][j];
    }
  }

  solvele(mat,vec,(unsigned int)(DIM+1));

  hc=vec[0];
  for (i=1;i<=DIM;i++)
    hc += vec[i]*cast[dim-(i-1)*DELAY];
  casted=hc;

  free(vec);
  for (i=0;i<=DIM;i++)
    free(mat[i]);
  free(mat);

  return casted;
}

int main(int argc,char **argv)
{
  char alldone,stdi=0;
  int i,j,actfound,dim;
  double av,newcast;
  FILE *file=NULL;

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
      check_alloc(outfile=(char*)calloc(strlen(infile)+6,(size_t)1));
      strcpy(outfile,infile);
      strcat(outfile,".cast");
    }
    else {
      check_alloc(outfile=(char*)calloc((size_t)11,(size_t)1));
      strcpy(outfile,"stdin.cast");
    }
  }
  if (!onscreen)
    test_outfile(outfile);

  dim=(DIM-1)*DELAY;
  series=(double*)get_series(infile,&LENGTH,exclude,COLUMN,verbosity);
  rescale_data(series,LENGTH,&min,&interval);
  variance(series,LENGTH,&av,&varianz);
  check_alloc(cast=(double*)malloc(sizeof(double)*(dim+1)));
  check_alloc(list=(long*)malloc(sizeof(long)*LENGTH));
  check_alloc(found=(long*)malloc(sizeof(long)*LENGTH));
  check_alloc(box=(long**)malloc(sizeof(long*)*NMAX));
  for (i=0;i<NMAX;i++)
    check_alloc(box[i]=(long*)malloc(sizeof(long)*NMAX));
  
  if (epsset)
    EPS0 /= interval;

  for (i=0;i<dim+1;i++)
    cast[i]=series[LENGTH-1-dim+i];
  
  if (!onscreen) {
    file=fopen(outfile,"w");
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Opened %s for writing\n",outfile);
  }
  else {
    if (verbosity&VER_INPUT)
      fprintf(stderr,"Writing to stdout\n");
  }

  for (i=0;i<FLENGTH;i++) {
    alldone=0;
    epsilon=EPS0/EPSF;
    while (!alldone) {
      epsilon*=EPSF;
      put_in_boxes();
      actfound=hfind_neighbors();
      if (actfound >= MINN) {
	newcast=make_fit(actfound);
	if (onscreen) {
	  printf("%e\n",newcast*interval+min);
	  fflush(stdout);
	}
	else {
	  fprintf(file,"%e\n",newcast*interval+min);
	  fflush(file);
	}
	alldone=1;
	if ((newcast>2.0) || (newcast< -1.0)) {
	  fprintf(stderr,"Forecast failed. Escaping data region!\n");
	  exit(127);
	}
	for (j=0;j<dim;j++)
	  cast[j]=cast[j+1];
	cast[dim]=newcast;
      }
    }
  }
  if (!onscreen)
    fclose(file);

  return 0;
}
