CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill (cor & rms) of OCN prd based on PC
C==========================================================
      include "parm.h"
      real fld1(ncd)
      real fld2d(ncd,nyr*12),fld3d(ncd,12,nyr)
c
      open(unit=11,form='unformatted',access='direct',recl=4*ncd)
      open(unit=12,form='unformatted',access='direct',recl=4*ncd)
      open(unit=13,form='unformatted',access='direct',recl=4*ncd)
      open(unit=14,form='unformatted',access='direct',recl=4*ncd)
      open(unit=15,form='unformatted',access='direct',recl=4*ncd)
      open(unit=16,form='unformatted',access='direct',recl=4*ncd)
      open(unit=17,form='unformatted',access='direct',recl=4*ncd)
      open(unit=18,form='unformatted',access='direct',recl=4*ncd)
      open(unit=19,form='unformatted',access='direct',recl=4*ncd)
      open(unit=20,form='unformatted',access='direct',recl=4*ncd)
      open(unit=21,form='unformatted',access='direct',recl=4*ncd)
      open(unit=22,form='unformatted',access='direct',recl=4*ncd)
c
      open(unit=30,form='unformatted',access='direct',recl=4*ncd)
      open(unit=40,form='formatted')
c
      open(unit=41,form='unformatted',access='direct',recl=4*ncd)
      open(unit=42,form='unformatted',access='direct',recl=4*ncd)
      open(unit=43,form='unformatted',access='direct',recl=4*ncd)
      open(unit=44,form='unformatted',access='direct',recl=4*ncd)
      open(unit=45,form='unformatted',access='direct',recl=4*ncd)
      open(unit=46,form='unformatted',access='direct',recl=4*ncd)
      open(unit=47,form='unformatted',access='direct',recl=4*ncd)
      open(unit=48,form='unformatted',access='direct',recl=4*ncd)
      open(unit=49,form='unformatted',access='direct',recl=4*ncd)
      open(unit=50,form='unformatted',access='direct',recl=4*ncd)
      open(unit=51,form='unformatted',access='direct',recl=4*ncd)
      open(unit=52,form='unformatted',access='direct',recl=4*ncd)

CCC read in data
c=read in nyr long data
      do m=1,12   ! jfm to djf
      iu=10+m
      do k=1,nyr
        read(iu,rec=k) fld1
        do i=1,ncd
          fld3d(i,m,k)=fld1(i)
        enddo
      enddo
      enddo
CCC arrange the data in the oder of time
      it=0
      do k=1,nyr
      do m=1,12
      it=it+1
        do i=1,ncd
          fld2d(i,it)=fld3d(i,m,k)
        enddo
      enddo
      enddo
      ntot=it
      write(6,*) 'ntot=',ntot
c
c write out sequenced data
      nst=4*12+1  !from jfm1995
      ir=0
      do n=nst,ntot
        do i=1,ncd
          fld1(i)=fld2d(i,n)
        enddo
      ir=ir+1
        write(30,rec=ir) fld1
      enddo
 888  format(10f7.1)
c
c=write out data for winter seasons: ndj djf jfm
      ir=0
      do m=1,1
      do k=1,nyr
        do i=1,ncd
          fld1(i)=fld3d(i,m,k)
        enddo
      ir=ir+1
        write(41,rec=ir) fld1
      enddo
      enddo
c
      do m=11,12
      do k=1,nyr
        do i=1,ncd
          fld1(i)=fld3d(i,m,k)
        enddo
      ir=ir+1
        write(41,rec=ir) fld1
      enddo
      enddo
c=write out data for summer seasons: mjj jja jas
      ir=0
      do m=3,5
      do k=1,nyr
        do i=1,ncd
          fld1(i)=fld3d(i,m,k)
        enddo
      ir=ir+1
        write(42,rec=ir) fld1
      enddo
      enddo
c
      
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
      subroutine rm_48m(a,b,n,nr,m)
      real a(n),b(n)
c
      do i=1,m-1
        b(i)=a(i)
      enddo
c
      do 5 i=m,nr
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

