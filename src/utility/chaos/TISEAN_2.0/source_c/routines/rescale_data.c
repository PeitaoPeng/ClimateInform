/*Author: Rainer Hegger Last modified: February 28th, 1998 */
void rescale_data(double *x,unsigned long l,double *min,double *interval)
{
  int i;
  
  *min=*interval=x[0];
  
  for (i=1;i<l;i++) {
    if (x[i] < *min) *min=x[i];
    if (x[i] > *interval) *interval=x[i];
  }
  *interval -= *min;
  
  for (i=0;i<l;i++)
    x[i]=(x[i]- *min)/ *interval;
}
