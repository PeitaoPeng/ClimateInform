      subroutine loadr(a,npt,iu,iuout)
#include "parm.h"
      real a(nmax,nmon,nyr)
      real fld(128,64)
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
       do j=42,52,2
	j2=j/2
	jj=(j2)/2
	jjj=jj*2
	if(jjj.eq.j2) then
	do i=44,102,2
	  if(fld(i,j).gt.-990) then
 	  n=n+1
	  a(n,im,iy)=fld(i,j)
          end if
        end do
	else
	do i=46,102,2
	  if(fld(i,j).gt.-990) then
 	  n=n+1
	  a(n,im,iy)=fld(i,j)
          end if
        end do
	end if
       end do
      end do
      end do
      npt=n
      write(6,*) 'extp sst npts= ',n
c
      return
      end
