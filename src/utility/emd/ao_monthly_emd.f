C*****************************************************************
C  This is a program to culaculate Intrinsic Mode Functions (IMF)
C  and their Hilbert Transform for monthly AO index
C*****************************************************************
C
      program main
#include "parm.h"
c
c  The parameter LXY is the length of a original time series.
c  LEX is the length of the extended time series. LEX=3*LXY-2.
c  The LEX is defined for the series that associated with the
c  extended series.
c
c     parameter(LXY=1584,LEX=3*LXY)
c
      dimension datain(LXY)   ! read-in original time series
      dimension ximf(LEX)     ! The IMF for the extended 
      dimension spmax(LEX)    ! upper envelope, cubic spline
      dimension spmin(LEX)    ! lower envelope, cubic spline
      dimension ave(LEX)    ! the average of spmax and spmin
      dimension remp(LEX)   ! the input data to obtain IMF
      dimension rem(LEX)    ! (remp-ximf) the remainder
c
      dimension yimf(LXY)   ! the imagine part of IMF
      dimension theta(LXY)  ! atan(yimf/ximf)
      dimension omega(LXY)  ! d(theta)/dt
c
      dimension out1(nout),out2(nout),out3(nout)
      dimension out4(nout),out5(nout),out6(nout)
      integer nmax, nmin
c
c     open(unit=6,form='formated')
      open(unit=80,form='unformated',access='direct',recl=nout)
c------------------------------------------------------------
      PI=3.1415927
c
c-------------------------------------------------------------
c  Read in the original data
      call read_origin(datain)
c  Make the data extended in both ends
      call end_ext(datain,ximf)
c  leave a copy of the input data before IMF is calculated
      do i=1,LEX
        remp(i)=ximf(i)
      enddo
c
c     write(6,888) datain
c
      DO K=1,10    !loop for the order of EMD
c
      call EMD_IMF(ximf,rem,spmax,spmin,yimf,theta,omega,ave)
c
c=============================================================
c-------------------------------------------------------------
C  OUTPUT DATA
c
      write(6,*) "K=",K
      do n=1,nout
        out1(n)=-999.9
        out2(n)=-999.9
        out3(n)=-999.9
        out4(n)=-999.9
        out5(n)=-999.9
        out6(n)=-999.9
      enddo
c
      MM=2*LXY
      n=1+12
      do i=LXY+1,MM
        write(6,200) remp(i),spmax(i),ximf(i),yimf(i-LXY),
     |       theta(i),omega(i-LXY),rem(i),spmin(i),ave(i)
        out1(n)=remp(i)
        out2(n)=ximf(i)
        out3(n)=spmax(i)
        out4(n)=spmin(i)
        out5(n)=rem(i)
        out6(n)=omega(i-LXY)
        n=n+1
      enddo
c
      write(80) out1
      write(80) out2
      write(80) out3
      write(80) out4
      write(80) out5
      write(80) out6
c
      do i=1,LEX
        ximf(i)=rem(i)
      end do
c
      END DO !loop for EMD
 200  format(9f8.3)
 888  format(10f7.3)

      stop
      end


c*****************************************************************
C*******************  read_origin  *******************************
c
      subroutine read_origin(tavegl)
#include "parm.h"
c
c  Read in the original time series. In this case it is
c  tavegl.dat, the normalized Southern Oscillation Index. This
c  set of data is used to calculate mode 1 of the SOI index.
c
c
      dimension tavegl(LXY)      ! read-in original time series
c
      open(10,form="formatted")
c
      do i=1,LXY
        read(10,100) myear,tavegl(i)
      enddo
 100  format(I10,e14.5)
      return
      end
 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc in time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc(a,b,n,c)
      real a(n),b(n)
c
      avg_a=0.
      avg_b=0.
      do i=1,n
c       avg_a=avg_a+a(i)/float(n)
c       avg_b=avg_b+b(i)/float(n)
      enddo
c
      do i=1,n
      a(i)=a(i)-avg_a
      b(i)=b(i)-avg_b
      enddo
c
      sd_a=0
      sd_b=0
      ac=0
      do i=1,n
      sd_a=sd_a+a(i)*a(i)/float(n)
      sd_b=sd_b+b(i)*b(i)/float(n)
      ac=ac+a(i)*b(i)/float(n)
      enddo
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)
      c=ac/(sd_a*sd_b)
c
      return
      end
c
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  wrt out data on time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine wrt_out(iu,a,n)
      real a(n)
      open(unit=80,form='unformated',access='direct',recl=1)
c
      do i=1,n
        write(iu) a(i)
      enddo
c
      return
      end

C******************* END OF  PROGRAM *************************



      
