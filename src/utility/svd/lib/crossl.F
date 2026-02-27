      subroutine crossl(a,k,iunit,array)
#include "parm.h"
      dimension b(idl,jdl),a(nmon,nyr,nrot),array(idl,jdl),
     *  sum(idl,jdl,nmon),var(idl,jdl,nmon),vars(idl,jdl),
     *  cor(idl,jdl,nmon),s(nmon),v(nmon)
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
      do 90 j=1,jdl
      do 90 i=1,idl
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
      do 70 j=1,jdl
      do 70 i=1,idl
      array(i,j)=array(i,j)+(cor(i,j,imon)-sum(i,j,imon)*s(imon))
     1    /totalm
      vars(i,j)=vars(i,j)+(var(i,j,imon)-sum(i,j,imon)*sum(i,j,imon))
     1    /totalm
c     if(b(i,j).le.-1.e-9.and.imon.eq.nmon) then
c        print *,array(i,j),cor(i,j,1),vars(i,j),var(i,j,1),sum(i,j,1)
c     endif
   70 continue
   80 continue
      do 60 j=1,jdl
      do 60 i=1,idl
      x=vars(i,j)
c     if(b(i,j).le.-1.e-9) print *,'var at ',i,' ',j,' = ',x
      if(b(i,j).le.-888.and.b(i,j).ge.-999) go to 1
      if (x.lt.1.e-12) go to 1
      array(i,j)=array(i,j)/sqrt(x)/sqrt(vs)
c     array(i,j)=array(i,j)/sqrt(vs)
      go to 60
    1 array(i,j)=-1.e10
   60 continue
      return
      end
