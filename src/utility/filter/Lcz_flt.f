CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  use Lanczos filter to treat daily data
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      program filter
#include "parm.h"
c     PARAMETER (imax=144,jmax=73)
      real fldin(imax,jmax), fldot(imax,jmax)
      real flt(n),wk(imax,jmax,2*n-1)
      real coef(n)
C
      open(unit=10,form='unformated',recl=imax*jmax)
      open(unit=15,form='unformated',access='direct',recl=n)
      open(unit=20,form='unformated',access='direct',recl=imax*jmax)
c
c.. read in filter
      read(15) flt 
      write(6,*) 'flt=',flt
c
      if(ipass.eq.1) then   ! low pass
      do i=1,n
        coef(i)=flt(i)
      enddo
      end if
c
      if(ipass.eq.2) then   ! high pass
        coef(1)=1-flt(1)
      do i=2,n
	coef(i)=-flt(i)
      end do
      end if
c
      do 2000 it=1,ltime
      read (10,end=1000) fldin
      write(6,*) 'fldin=',fldin(64,32)
c-> shifting
      do jt=1,2*n-2
       do i=1,imax
       do j=1,jmax
	 wk(i,j,jt)=wk(i,j,jt+1)
       end do
       end do
      end do
c-> feeding           
       do i=1,imax
       do j=1,jmax
         wk(i,j,2*n-1)=fldin(i,j)
       end do
       end do
      m=2*n-1
      IF(it.lt.m) go to 2000
c-> weighted mean
      call setzero(fldot,imax*jmax)
       do i=1,imax
       do j=1,jmax
         fldot(i,j)=coef(1)*wk(i,j,n)
       end do
       end do
c
       do i=1,imax
        do j=1,jmax
         do jt=1,n-1
	 fldot(i,j)=fldot(i,j)+
     &    coef(jt+1)*(wk(i,j,n-jt)+wk(i,j,n+jt))
         end do
        end do
       end do
c
      write(20) fldot
      write(6,*) 'fldout=',fldot(64,32)
 1000 continue
 2000 continue
      stop
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero         
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero(a,n)
      real a(n)
      do 5 i=1,n
      a(i)=0.
  5   continue
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  asgn a to b          
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine asgn(a,b,kmax)
      real a(kmax),b(kmax)
      do 5 i=1,kmax
      b(i)=a(i)
  5   continue
      return
      end

