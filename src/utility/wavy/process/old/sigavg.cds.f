CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  averaging daily cds spectral data to monthly mean
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      program mavg
C. imax=128 jmax=64   mp=41    for T40
C. imax=128 jmax=108  mp=41    for R40
C. imax=192 jmax=96   mp=63    for T62
C. imax=256 jmax=128  mp=81    for T80
C. imax=384 jmax=192  mp=127   for T126
C
#include "parm.h"
      PARAMETER (imax=128,jmax=64,mp=41,lromb=0,
     %  itr=(imax+2)/4*6,km=18,nr=20)
      parameter(kmax=mp*(mp+1)*(1-lromb)/2+mp*mp*lromb,
     %          mmax=imax/2)
C
      common /gausin/ glat(jmax),coa(jmax),sia(jmax),gw(jmax)
      common /fftcom/ ifax(10),trigs(itr),wk(imax,jmax)
      common /legply/ p(jmax,kmax),dp(jmax,kmax)
      common /gaudrd/ xg(imax),yg(jmax)
      complex wave(kmax),fs(kmax),
     %        fac(kmax),fac1(kmax),fac2(kmax)
     % ,fac3(kmax),fac4(kmax),wave1(kmax),wave2(kmax)
      complex wout(kmax),top(kmax),
     %wout2(kmax,73),wout3(kmax,73)
      real si(19),sl(18)
      integer lab85(8)
C
      er=6371.0*1000.0
      pi=3.14159
      do 10 m=1,mp
      fm=float(m-1)
      lmp=(m-1)*lromb
      do 10 n=m,mp+lmp
      k=k+1
      fn=-1.0*float(n*(n-1))
      xn=0.0
      if (n.ne.1) xn=er/fn  
      fac(k)=cmplx(er*xn,0.0)
      fac1(k)=cmplx(xn,0.0)
      fac2(k)=cmplx(0.0,fm*xn)
      fac3(k)=cmplx(0.0,fm)
      fs(k)  =cmplx(1.0,0.0)
      if(n.gt.20) fs(k)=0.
 10   continue
C
      write(6,*)'nday= ',nday
      call setzero(wout3,73*kmax)
C
      do 2000 ifile=1,nday
C
      iun=10+ifile
c
      read (iun)                           !! skip LAB
      read (iun,end=1000)     fhr,imo,iday,iyr,si,sl
      print *,'date= ',       fhr,imo,iday,iyr
      read (iun) top                       !!  Orography
c
c    print 18 sigma level positions
      do k=1,18
c     print *,si(k),sl(k)
      enddo
C
C...read in lnPs, T, D, Zeta, humidity
C
         do k=1,73
         read(iun) wave
      call asgn(wave,wout2(1,k),kmax)
         enddo
1000     continue
C...do accumulation
      do k=1,73
      do i=1,kmax
	 wout3(i,k)=wout3(i,k)+wout2(i,k)
      enddo
      enddo
      write(6,*)'global mean sfc tmp=',wout2(1,2)
C
 2000 continue
C
C===write out T40 data 
      iout=90
      write (iout) lab85                   !! skip LAB
      write (iout)     fhr,imo,iday,iyr,si,sl
      write (iout) top                     !!  Orography
           do 20 k=1,73
           do 30 i=1,kmax
              wout(i)=wout3(i,k)/float(nday)
  30  continue
      write(iout) wout
  20  continue
           stop
           end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  input: T40; output: R20
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine trunk(win,wout,wave,kmax,nr,mp)
      complex win(kmax),wout(nr+1,nr+1),wave(mp,mp)
      n=0
      do 5 i=1,mp
      do 5 j=i,mp
      n=n+1
      wave(i,j)=win(n)
  5   continue
      do 10 i=1,nr+1
      jy=i+nr
      j=0
      do 10 jj=i,jy
         j=j+1
         wout(j,i)=wave(i,jj)
  10  continue
      print *, wout(1,1)
      return
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

