      subroutine exvar(a,var,idiv,n,varx)
#include "parm.h"
      dimension a(nmax,nf),var(nf),varx(nf)
      varx=0.
      total=n
      do 100 k=1,nf
      x=var(k)
      if (idiv.eq.0) x=1.
      do 90 i=1,n
      varx(k)=varx(k)+a(i,k)*a(i,k)/total/x
   90 continue
  100 continue
      return
      end
