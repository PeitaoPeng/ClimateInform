CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  use Lanczos filter to treat daily data
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      program filter
#include "parm.h"
      real fildin(imax,jmax), fldot(imax,jmax)
      real flt(n),coef(n),wk(imax,jmax,2*n-1)
      real tsin(ltime),tsout(ltime),twk(ltime)
      real yh(ltime),yl(ltime)
C
      open(unit=10,form='unformated',access='direct',recl=ltime)
      open(unit=15,form='unformated',recl=n)
      open(unit=20,form='unformated',access='direct',recl=ltime)
c
c.. read in filter
      read(15) flt 
c
      if(ipass.eq.1) then   ! low pass
      do i=1,n
        coef(i)=flt(i)
c       coef(i)=1./float(2*n-1)   ! running mean with 2n-1 points
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
c== read input data
      read(10) tsin
      call setzero(tsout,ltime)
      do 2000 it=1,ltime
      write(6,*) 'it=',it
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
         wk(i,j,2*n-1)=tsin(it)
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
      tsout(it-n+1)=fldot(1,1)
      write(6,*) 'it=',it,'  tsout=',fldot
 2000 continue
      write(20) tsout
      write(6,*) 'coef=',coef
C== KARO filter
      pr1=6
      pr2=6
      call FLTM(tsin,tsout,pr1,pr2,ipass)
      write(20) tsout
C== Wang filter
      ph=4
      pm=6
      pl=8
      fhl=0.7
      dt=1
      call msf(ltime,tsin,yh,yl,ph,pm,pl,fhl,dt)
      write(20) yl
      stop
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero         
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero(a,n)
      complex a(n)
      do 5 i=1,n
      a(i)=0.
  5   continue
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  asgn a to b          
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine asgn(a,b,kmax)
      complex a(kmax),b(kmax)
      do 5 i=1,kmax
      b(i)=a(i)
  5   continue
      return
      end

