      subroutine crosst(a,b,va,vb,cov)
#include "parm.h"
      dimension a(nmon,nyr,nrot),b(nmon,nyr,nrot)
      dimension cov(nf),va(nf),vb(nf),suma(nf),sumb(nf)
      total=nyr*nmon
      cov=0.
      va=0.
      vb=0.
      suma=0.
      sumb=0.
      do 100 k=1,nf
      do 90 iyr=1,nyr
      do 90 imon=1,nmon
      cov(k)=cov(k)+a(imon,iyr,k)*b(imon,iyr,k)/total
      va(k)=va(k)+a(imon,iyr,k)*a(imon,iyr,k)/total
      vb(k)=vb(k)+b(imon,iyr,k)*b(imon,iyr,k)/total
      suma(k)=suma(k)+a(imon,iyr,k)/total
      sumb(k)=sumb(k)+b(imon,iyr,k)/total
   90 continue
  100 continue
      do 110 k=1,nf
        cov(k)=cov(k)-suma(k)*sumb(k)
  110 continue
      write(6,1)
    1 format(/,2x,'covariance between a and b')
      write(6,2) (cov(k),k=1,nf)
    2 format(2x,5e11.4)
      do 200 k=1,nf
      x=va(k)-suma(k)*suma(k)
      y=vb(k)-sumb(k)*sumb(k)
      cov(k)=cov(k)/sqrt(x)/sqrt(y)
  200 continue
      write(6,3)
    3 format(/,2x,'correlation coeff between a and b')
      write(6,2) (cov(k),k=1,nf)
      return
      end
