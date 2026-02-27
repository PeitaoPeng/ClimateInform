      program detrend
#include "parm.h"
      dimension fld(nt),fldnew(nt)
      dimension fld2d(imax,jmax),fld3d(imax,jmax,nt)
      dimension xslop(imax,jmax),ycut(imax,jmax)
      character*80 fln
      character*80 fln2

      open(10,form='unformated',access='direct',recl=imax*jmax)
      open(20,form='unformated',access='direct',recl=imax*jmax)
      open(30,form='unformated',access='direct',recl=imax*jmax)

      write(6,*) 'read in data'

      do 30 it=1,nt
c     read(10,rec=it*3) fld2d
      read(10,rec=it) fld2d

      do i=1,imax
      do j=1,jmax
        fld3d(i,j,it)=fld2d(i,j)
      end do
      end do

  30  continue

      do i=1,imax
      do j=1,jmax
         xslop(i,j)=-999.0
      end do
      end do

      do 20 i=1,imax
      do 20 j=1,jmax

      IF(abs(fld3d(i,j,50)).gt.900) go to 20

      do it=1,nt
      fld(it)=fld3d(i,j,it)
      if(abs(fld(it)).gt.900) go to 20
      end do

      call notrend(nt,fld,fldnew,a1,b1)

      do it =1,nt
      fld3d(i,j,it)=fldnew(it)
      end do
      xslop(i,j)=a1
      ycut(i,j)=b1

  20  continue

      do it=1,nt
      do i=1,imax
      do j=1,jmax
        fld2d(i,j)=fld3d(i,j,it)
      end do
      end do
      write(20,rec=it) fld2d
      end do

      write(20,rec=nt+1) xslop
      write(30,rec=1) xslop
      write(30,rec=2) ycut
      stop
      end

      subroutine notrend(n,z1,z2,a1,b1)
c   --This routine calculates the linear trend in time series 1,
c   --and constructs a time series 2 that has no
c   --trend and mean.
c   --INPUT: z1;  OUTPUT: z2, the desired series. Note: z1c 
c   --(not output) is detrended versions of z1. 
      dimension z1(n),z2(n)
c   --get origins and trend parameters of z1
      call trend(z1,n,xbar1,a1,b1,e1)  
      write(6,12)xbar1
   12 format('mean for series 1',f8.3)
c   --construct z2, having no but all other features as in z1
      DO 44 i=1,n
         b1=b1+a1
         z2(i)=z1(i)-b1+xbar1
   44 continue
      return
      end
      SUBROUTINE TREND(Z,N,XBAR,A,B,E)
      DIMENSION Z(N)
C THIS SUBR. COMPUTES LINEAR TREND LINE Y=A*X+B FOR THE TIME SERIES Z(N)
C USING FORMULAS FROM SPSS MANUAL PP.293,294. (B=origin, A=slope) IT ALSO
C COMPUTES STD. ERR.OF ESTIMATE (I.E. THE STD. DEV. OF THE RESIDUALS.--bugged!)
      SUMZ=0.0
      SUMZZ=0.0
      SUMN=0.0
      SUMNN=0.0
      SUMNZ=0.0
      RM=0.
      DO 10 I=1,N
      RM=RM+1.
      SUMZ=SUMZ+Z(I)
      SUMZZ=SUMZZ+Z(I)*Z(I)
      SUMN=SUMN+I
      SUMNN=SUMNN+I*I
      SUMNZ=SUMNZ+I*Z(I)
   10 CONTINUE
      XBAR=SUMZ/RM
      A=(RM*SUMNZ-SUMN*SUMZ)/(RM*SUMNN-SUMN*SUMN)
      B=(SUMZ*SUMNN-SUMN*SUMNZ)/(RM*SUMNN-SUMN*SUMN)
C   --NEXT, GET E (standard error of estimate) AND ITS ABS VALUE
      E=(SUMZZ-A*SUMZ-B*SUMNZ)/(RM-2.0)
      E=ABS(E)
      E=SQRT(E)
      RETURN
      END
