      program correlation
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C===========================================================
      real fld2d(mode+2,ltime)
      real rcoef(ltime)
      real datain(nin)
c
      open(unit=10,form='unformated',access='direct',recl=nin)
      open(unit=11,form='unformated',access='direct',recl=ltime)
      open(unit=20,form='formated')
      open(unit=30,form='formated')
c
c read in ori, imf and residual
      read(10,rec=1) datain  !original
      do i=1,ltime
        fld2d(1,i)=datain(i+12)
      enddo
c
      do m=1,mode
      read(10,rec=(m-1)*6+2) datain  !imf
      do i=1,ltime
        fld2d(m+1,i)=datain(i+12)
      enddo
      enddo
c
      read(10,rec=(mode-1)*6+5) datain  !trend
      do i=1,ltime
        fld2d(mode+2,i)=datain(i+12)
      enddo
c==write out formatted raw data, imf and trend
      ir=1
      do ny=1950,2002
      do month=1,12
c
      write(20,666) ny,month,fld2d(1,ir),fld2d(2,ir),fld2d(3,ir),
     &fld2d(4,ir),fld2d(5,ir),fld2d(6,ir),fld2d(7,ir),fld2d(8,ir)
c
      write(30,555) fld2d(1,ir)
c
      ir=ir+1
      enddo
      enddo
 666  format(1x,I6,1x,I4,1x,8f7.3)
 555  format(1x,f7.3)
c
      stop
      END


      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end
