CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  select years with RPC2 (or SESAT index) > stdv
C  anom_2 is for anom wrt clim of different sections
C==========================================================
#include "parm.h"
      real r1d1(ntprd),r1d2(ntprd)
      real r2d(imax,jmax),r2d2(imax,jmax)
      real obs(imax,jmax),prd(imax,jmax)
      real obs2d(imax,jmax,ntprd),prd2d(imax,jmax,ntprd)
      real grid(imax,jmax,ltime)
      real fld1(ltime)
      real fld2(ntprd),sesat(ntprd)
      real fld2D(mmax,ltime)
      real fldprd(mmax,ntprd)
      real vrfy(mmax,ntprd)
      real nwarmyr(8),ncoldyr(9)
      data nwarmyr/28,36,39,43,53,57,62,68/
      data ncoldyr/20,25,41,44,46,55,59,69,70/
c
      open(unit=10,form='unformated',access='direct',recl=ltime)
      open(unit=11,form='unformated',access='direct',recl=ltime)
      open(unit=30,form='unformated',access='direct',recl=imax*jmax)
      open(unit=45,form='unformated',access='direct',recl=imax*jmax)
      open(unit=50,form='unformated',access='direct',recl=imax*jmax)
      open(unit=55,form='unformated',access='direct',recl=imax*jmax)

C
CCC read in 102 cd data
C
      do it=1,ltime
        read(30) r2d
      do i=1,imax
      do j=1,jmax
        grid(i,j,it)=r2d(i,j)
      enddo
      enddo
      enddo
C
      call anom_2(grid,ngrd,ltime,36)  !have anom wrt the clime of different sectors
C
CCC read in rpc data
C
      do m=1,mmax
        read(10,rec=m) fld1
      do k=1,ltime
        fld2D(m,k)=fld1(k)
      enddo
      enddo
      read(11)  fld1
      do k=1,ltime
c      fld2D(2,k)=-fld1(k)
      enddo
c
      call anom_2(fld2D,mmax,ltime,36)
c
      do it=1,ntprd
        sesat(it)=fld2D(2,it)
      enddo
      call normal(sesat,ntprd)
C== select fields
      do i=1,imax
      do j=1,jmax
        obs(i,j)=0.
        prd(i,j)=0.
      enddo
      enddo
      ic=0
c
      do it=1,ntprd-1
        if(sesat(it).gt.1.0) then
        ic=ic+1
        do i=1,imax
        do j=1,jmax
          obs(i,j)=obs(i,j)+grid(i,j,it)
          prd(i,j)=prd(i,j)+grid(i,j,it+1)
          r2d(i,j)=grid(i,j,it)
          r2d2(i,j)=grid(i,j,it+1)
        enddo
        enddo
        iy=it+1930
        write(6,*)'set > 1 iy=',iy
      write(45) r2d
      write(45) r2d2
        endif
      enddo
      write(6,*) 'total +ic=',ic
        do i=1,imax
        do j=1,jmax
          obs(i,j)=obs(i,j)/float(ic)
          prd(i,j)=prd(i,j)/float(ic)
        enddo
        enddo
      write(40) obs
      write(40) prd
c
      do i=1,imax
      do j=1,jmax
        obs(i,j)=0.
        prd(i,j)=0.
      enddo
      enddo
      ic=0
      do it=1,ntprd-1
        if(sesat(it).lt.-1.0) then
        ic=ic+1
        do i=1,imax
        do j=1,jmax
          obs(i,j)=obs(i,j)+grid(i,j,it)
          prd(i,j)=prd(i,j)+grid(i,j,it+1)
          r2d(i,j)=grid(i,j,it)
          r2d2(i,j)=grid(i,j,it+1)
        enddo
        enddo
        iy=it+1930
        write(6,*)'set < -1 iy=',iy
      write(50) r2d
      write(50) r2d2
        endif
      enddo
      write(6,*) 'total -ic=',ic
        do i=1,imax
        do j=1,jmax
          obs(i,j)=obs(i,j)/float(ic)
          prd(i,j)=prd(i,j)/float(ic)
        enddo
        enddo
      write(40) obs
      write(40) prd
      do i=1,ntprd
        fld2(i)=vrfy(2,i)
      enddo
c
C== select ENSO years
c
      do n=1,8
       do it=1,ntprd
        if(it.eq.nwarmyr(n)) then
        do i=1,imax
        do j=1,jmax
          r2d(i,j)=grid(i,j,it)
        enddo
        enddo
        iy=it+1930
        write(6,*)'warm iy=',iy
        write(55) r2d
        endif
       enddo
      enddo
c
      do n=1,9
       do it=1,ntprd
        if(it.eq.ncoldyr(n)) then
        do i=1,imax
        do j=1,jmax
          r2d(i,j)=grid(i,j,it)
        enddo
        enddo
        iy=it+1930
        write(6,*)'cold iy=',iy
        write(55) r2d
        endif
       enddo
      enddo
      
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
C  runing mean
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine anom_2(a,m,n,n1)
      real a(m,n)
C
      DO j=1,m
      avg=0
      do i=1,n1
        avg=avg+a(j,i)/float(n1)
      enddo
      do i=1,n1
        a(j,i)=a(j,i)-avg
      enddo
c
      avg=0
      do i=n1+1,n
        avg=avg+a(j,i)/float(n-n1)
      enddo
      do i=n1+1,n
        a(j,i)=a(j,i)-avg
      enddo
      ENDDO
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

      SUBROUTINE normal(rot,ltime)
      DIMENSION rot(ltime)
      avg=0
      do i=1,ltime
      avg=avg+rot(i)/float(ltime)
      enddo
c
      do i=1,ltime
      rot(i)=rot(i)-avg
      enddo
c
      sd=0.
      do i=1,ltime
        sd=sd+rot(i)*rot(i)/float(ltime)
      enddo
        sd=sqrt(sd)
      do i=1,ltime
        rot(i)=rot(i)/sd
      enddo
      return
      end
