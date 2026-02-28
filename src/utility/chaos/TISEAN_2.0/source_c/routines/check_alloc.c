/* Author: Rainer Hegger Last modified: Jul 15, 1999 */
#include <stdlib.h>
#include <stdio.h>

void check_alloc(void *pnt)
{
  if (pnt == NULL) {
    fprintf(stderr,"Couldn't allocate enough memory. Exiting\n");
    exit(127);
  }
}
