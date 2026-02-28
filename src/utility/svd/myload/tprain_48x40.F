      subroutine loadl(a,npt,iu,iuout)
#include "parm.h"
      real a(nmax,nmon,nyr)
      real fld(48,40)
c     read(iu) npt,nummo,numyr
      
c     nmaxpr=nmax
c     write(*,1) iu,npt,nummo,numyr
c   1 format('READ FIELD from UNIT',i3,' #pts= ',i4,
c    * ' #mons=',i4,' #yrs=',i4)
c     if(npt.gt.nmax.or.nummo.ne.nmon.or.numyr.ne.nyr) then
c        print *,'ERROR!! Check parameter settings and retry.'
c        print *,'nmax=',nmaxpr,' npt=',npt
c        stop
c     endif
c
      do iy=1,nyr
      do im=1,nmon
      read(iu) fld
      write(iuout) fld
      n=0
c
       do j=15,26
	do i=1,48 
 	  n=n+1
	  a(n,im,iy)=fld(i,j)
        end do
       end do
c
      end do
      end do
      npt=n
      write(6,*) 'tprain nts= ',n
c
      return
      end
