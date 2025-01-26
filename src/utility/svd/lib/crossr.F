      subroutine crossr(a,k,iunit,array)
#include "parm.h"
      dimension b(idr,jdr),a(nmon,nyr,nrot),array(idr,jdr),
     *  sum(idr,jdr,nmon),var(idr,jdr,nmon),vars(idr,jdr),
     *  cor(idr,jdr,nmon),s(nmon),v(nmon)
      rewind iunit
      cor=0.
      sum=0.
      var=0.
      s=0.
      v=0.
      totaly=nyr
      totalm=nmon
      do 100 iyr=1,nyr
      do 100 imon=1,nmon
      read(iunit) b
      s(imon)=s(imon)+a(imon,iyr,k)/totaly  
      v(imon)=v(imon)+a(imon,iyr,k)*a(imon,iyr,k)/totaly  
      do 90 j=1,jdr
      do 90 i=1,idr
      sum(i,j,imon)=sum(i,j,imon)+b(i,j)/totaly
      var(i,j,imon)=var(i,j,imon)+b(i,j)*b(i,j)/totaly
      cor(i,j,imon)=cor(i,j,imon)+b(i,j)*a(imon,iyr,k)/totaly
   90 continue
  100 continue
      array=0.
      vars=0.
      vs=0.
      do 80 imon=1,nmon
      vs=vs+(v(imon)-s(imon)*s(imon))/totalm
      do 70 j=1,jdr
      do 70 i=1,idr
      array(i,j)=array(i,j)+(cor(i,j,imon)-sum(i,j,imon)*s(imon))
     1    /totalm
      vars(i,j)=vars(i,j)+(var(i,j,imon)-sum(i,j,imon)*sum(i,j,imon))
     1    /totalm
   70 continue
   80 continue
      do 60 j=1,jdr
      do 60 i=1,idr
      x=vars(i,j)
      if(b(i,j).le.-888.and.b(i,j).ge.-999) go to 1
      if (x.lt.1.e-12) go to 1
      array(i,j)=array(i,j)/sqrt(x)/sqrt(vs)
c     array(i,j)=array(i,j)/sqrt(vs)
      go to 60
    1 array(i,j)=-1.e10
   60 continue
      return
      end
