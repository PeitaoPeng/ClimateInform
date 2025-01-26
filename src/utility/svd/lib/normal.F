      subroutine normal(adata,icount)
#include "parm.h"
      dimension adata(nmax,nmon,nyr),sum(nmax,nmon)
#ifdef norml
      dimension var(nmax,nmon)
      var=0.
#endif
      total=nyr
      print *,'icount=',icount
      sum=0.
      do 200 iyr=1,nyr
      do 190 imon=1,nmon
      do 180 ipt=1,icount
      sum(ipt,imon)=sum(ipt,imon)+adata(ipt,imon,iyr)/total
#ifdef norml
      var(ipt,imon)=var(ipt,imon)+adata(ipt,imon,iyr)
     1    *adata(ipt,imon,iyr)/total
#endif
  180 continue
  190 continue
  200 continue
#ifdef norml
      do 170 imon=1,nmon
      do 170 ipt=1,icount
      x=var(ipt,imon)-sum(ipt,imon)*sum(ipt,imon)
      if (x.lt.1.e-15) go to 1 
      var(ipt,imon)=sqrt(x)
      go to 170
    1 var(ipt,imon)=-1000.
      write(6,2) ipt
    2 format(10x,'variance negative at point ',i5)
  170 continue
#endif
      do 160 iyr=1,nyr
      do 160 imon=1,nmon
      do 150 ipt=1,icount
      adata(ipt,imon,iyr)=adata(ipt,imon,iyr)-sum(ipt,imon)
  150 continue
  160 continue
#ifdef norml
      print *,'Normalize data'
      do 260 iyr=1,nyr
      do 260 imon=1,nmon
      do 250 ipt=1,icount
      if (var(ipt,imon).lt.0.) go to 3
      adata(ipt,imon,iyr)=adata(ipt,imon,iyr)/var(ipt,imon)
      go to 250
    3 adata(ipt,imon,iyr)=0.
  250 continue
  260 continue
#endif
      return
      end
