/*Author: Rainer Hegger Last modified: May 23th, 1998 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void variance(double *s,unsigned long l,double *av,double *var)
{
  unsigned long i;
  double h;
  
  *av= *var=0.0;

  for (i=0;i<l;i++) {
    h=s[i];
    *av += h;
    *var += h*h;
  }
  *av /= (double)l;
  *var=sqrt(fabs((*var)/(double)l-(*av)*(*av)));
}

