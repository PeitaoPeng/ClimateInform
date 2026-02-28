CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill (cor & rms) of OCN prd based on PC
C==========================================================
      include "parm.h"
      real fld1(nyr)
      real fld3(nyr*12),wk1(nyr*12)
      real fld2d(nyr,12)
c
      open(unit=11,form='unformatted',access='direct',recl=4*nyr)
      open(unit=12,form='unformatted',access='direct',recl=4*nyr)
      open(unit=13,form='unformatted',access='direct',recl=4*nyr)
      open(unit=14,form='unformatted',access='direct',recl=4*nyr)
      open(unit=15,form='unformatted',access='direct',recl=4*nyr)
      open(unit=16,form='unformatted',access='direct',recl=4*nyr)
      open(unit=17,form='unformatted',access='direct',recl=4*nyr)
      open(unit=18,form='unformatted',access='direct',recl=4*nyr)
      open(unit=19,form='unformatted',access='direct',recl=4*nyr)
      open(unit=20,form='unformatted',access='direct',recl=4*nyr)
      open(unit=21,form='unformatted',access='direct',recl=4*nyr)
      open(unit=22,form='unformatted',access='direct',recl=4*nyr)
c
      open(unit=30,form='unformatted',access='direct',recl=4)
      open(unit=40,form='formatted')

CCC read in data
      do m=1,12 
      iu=10+m
        read(iu,rec=1) fld1
      do k=1,nyr
        fld2d(k,m)=fld1(k)
      enddo
      enddo
CCC arrange the data in the oder of time
      k=0
      do n=1,nyr
      do m=1,12
      k=k+1
        fld3(k)=fld2d(n,m)
      enddo
      enddo
CCC 48 month runing avg
      nr=nyr*12  ! length of data
      call rm_48m(fld3,wk1,nr,48)

      iwt=0
      do n=1,nr
        ot1=wk1(n)
        ot2=fld3(n)
        iwt=iwt+1
        write(30,rec=iwt) ot1
        iwt=iwt+1
        write(30,rec=iwt) ot2
        write(40,888) ot1
      end do
 888  format(1x,f7.2)
      
      stop
      end
        
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero(a,n)
      real a(n)
      do 5 i=1,n
      a(i)=0.
  5   continue
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  get rid of mean
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine anom(a,n)
      real a(n)
      avg=0
      do 5 i=1,n-4
      avg=avg+a(i+2)/float(n-4)
  5   continue
      do 6 i=1,n-4
      a(i+2)=a(i+2)-avg
  6   continue
      return
      end


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  48MRM
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rm_48m(a,b,n,m)
      real a(n),b(n)
c
      do i=1,m-1
        b(i)=a(i)
      enddo
c
      do 5 i=m,n
        avg=0
        do 6 j=i-m+1,i
        avg=avg+a(j)/float(m)
  6   continue
        b(i)=avg
  5   continue
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  runing mean
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine runmean(a,n,b,m)
      real a(n),b(n)
c
      do i=1,m
        b(i)=a(i)
        b(n-i+1)=a(n-i+1)
      enddo
c
      do 5 i=m+1,n-m
        avg=0
        do 6 j=i-m,i+m
        avg=avg+a(j)/float(2*m+1)
  6   continue
        b(i)=avg
  5   continue
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

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  rms in time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rms(a,b,n,c)
      real a(n),b(n)
c
      c=0.
      do i=1,n
      c=c+(a(i)-b(i))*(a(i)-b(i))/float(n)
      enddo
      c=sqrt(c)
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  stdv of the time series
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine stdv(a,n,c)
      real a(n)
c
      avg_a=0.
      do i=1,n
        avg_a=avg_a+a(i)/float(n)
      enddo
c
      c=0.
      do i=1,n
      c=c+(a(i)-avg_a)*(a(i)-avg_a)/float(n)
      enddo
      c=sqrt(c)
c
      return
      end

