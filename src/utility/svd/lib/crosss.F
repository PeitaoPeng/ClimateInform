      subroutine crosss(a,s,inor,n,cor)
#include "parm.h"
      dimension a(nmon,nyr,nrot),s(nmax,nmon,nyr),cor(nmax,nf),
     1    v1(nmax),sum1(nmax)
      total=nyr*nmon
      cor=0.
      do 100 k=1,nf
      v1=0.
      v2=0.
      sum1=0.
      sum2=0.
      do 90 iyr=1,nyr
      do 90 imon=1,nmon
      sum2=sum2+a(imon,iyr,k)/total
      v2=v2+a(imon,iyr,k)*a(imon,iyr,k)/total
      do 80 i=1,n
      v1(i)=v1(i)+s(i,imon,iyr)*s(i,imon,iyr)/total
      cor(i,k)=cor(i,k)+s(i,imon,iyr)*a(imon,iyr,k)/total
      sum1(i)=sum1(i)+s(i,imon,iyr)/total
   80 continue
   90 continue
      var=sqrt(v2-sum2*sum2)
      if (inor.eq.0) go to 100
      do 70 i=1,n
      x=v1(i)-sum1(i)*sum1(i)
      x=sqrt(x)
      cor(i,k)=(cor(i,k)-sum1(i)*sum2)/x/var
   70 continue
  100 continue
      return
      end
