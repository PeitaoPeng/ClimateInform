/*Author: Rainer Hegger Last modified: Mar 20, 1999 */
#include <stdio.h>
#include <stdlib.h>

void test_outfile(char *name)
{
  FILE *file;
  
  file=fopen(name,"a");
  if (file == NULL) {
    fprintf(stderr,"Couldn't open %s for writing. Exiting\n",name);
    exit(127);
  }
  fclose(file);
}
