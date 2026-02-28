CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill of OCN prd based on RPC or other linear decomposition
C==========================================================
#include "parm.h"
      real r1d1(ntprd),r1d2(ntprd)
      real r2d(imax),r2d2(imax)
      real obs(imax),prd(imax)
      real obs2d(imax,ntprd),prd2d(imax,ntprd)
      real grid(imax,ltime),wmoobs(imax,ntprd)
      real fld1(ltime)
      real fld2(ntprd),sesat(ntprd)
      real fld2D(mmax,ltime)
      real fldprd(mmax,ntprd)
      real vrfy(mmax,ntprd)
      real nwarmyr(7),ncoldyr(7)
      dimension kk(mmax),ksign(mmax)
      data kk/30,1,25/
      data ksign/0,1,0/
      data nwarmyr/6,9,13,23,27,32,38/
      data ncoldyr/11,14,16,25,29,39,40/
c
      open(unit=10,form='unformated',access='direct',recl=ltime)
      open(unit=11,form='unformated',access='direct',recl=ltime)
      open(unit=30,form='formated')
      open(unit=40,form='unformated',access='direct',recl=imax)
      open(unit=45,form='unformated',access='direct',recl=imax)
      open(unit=50,form='unformated',access='direct',recl=imax)
      open(unit=55,form='unformated',access='direct',recl=imax)

C
CCC read in 102 cd data
C
      do it=1,ltime
        read(30,888) r2d
      do i=1,imax
        grid(i,it)=r2d(i)
      enddo
      enddo
 888  format(10f7.1)
C== define 30yr climate fields (31-60,41-70,51-80,61-90 and 71-00)
      do i=1,imax
        c1=0.0
        c2=0.0
        c3=0.0
        c4=0.0
        c5=0.0
      do k=1,30
        c1=c1+grid(i,k)/30.
        c2=c2+grid(i,k+10)/30.
        c3=c3+grid(i,k+20)/30.
        c4=c4+grid(i,k+30)/30.
        c5=c5+grid(i,k+40)/30.
      enddo
c== have anomalies wrt WMO
      kt=0
      do it=31,40  !31=1961; 40=1970
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c1
      enddo
      do it=41,50  !41=1971; 50=1980
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c2
      enddo
      do it=51,60  !51=1981; 60=1990
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c3
      enddo
      do it=61,70  !61=1991; 70=2000
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c4
      enddo
      do it=71,71  !71=2001
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c5
      enddo
      enddo  !loop for imax
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
c       fld2D(2,k)=fld1(k)
      enddo
C== loop over mode
      do m=1,mmax
C== define 30yr climate fields (51-80 and 61-90 and 71-00)
        clm1=0.0
        clm2=0.0
        clm3=0.0
        clm4=0.0
        clm5=0.0
      do k=1,30
        clm1=clm1+fld2D(m,k)/30.
        clm2=clm2+fld2D(m,k+10)/30.
        clm3=clm3+fld2D(m,k+20)/30.
        clm4=clm4+fld2D(m,k+30)/30.
        clm5=clm5+fld2D(m,k+40)/30.
      enddo
C== prediction with OCN
      kt=0
      do it=31,40  !32=1961; 41=1970
      kt=kt+1
         avg=0
         do k=it-kk(m),it-1
         avg=avg+fld2D(m,k)/float(kk(m))
         end do
         fldprd(m,kt)=avg-clm1
         vrfy(m,kt)=fld2D(m,it)-clm1
      end do

      do it=41,50  !41=1971; 50=1980
      kt=kt+1
         avg=0
         do k=it-kk(m),it-1
         avg=avg+fld2D(m,k)/float(kk(m))
         end do
         fldprd(m,kt)=avg-clm2
         vrfy(m,kt)=fld2D(m,it)-clm2
      end do

      do it=51,60  !51=1981; 61=1990
      kt=kt+1
         avg=0
         do k=it-kk(m),it-1
         avg=avg+fld2D(m,k)/float(kk(m))
         end do
         fldprd(m,kt)=avg-clm3
         vrfy(m,kt)=fld2D(m,it)-clm3
      end do

      do it=61,70  !61=1991; 70=2000
      kt=kt+1
         avg=0
         do k=it-kk(m),it-1
         avg=avg+fld2D(m,k)/float(kk(m))
         end do
         fldprd(m,kt)=avg-clm4
         vrfy(m,kt)=fld2D(m,it)-clm4
      end do

      do it=71,71  !71=2001
      kt=kt+1
         avg=0
         do k=it-kk(m),it-1
         avg=avg+fld2D(m,k)/float(kk(m))
         end do
         fldprd(m,kt)=avg-clm5
         vrfy(m,kt)=fld2D(m,it)-clm5
      end do
      ENDDO   !loop over mode
      write(6,*) 'kt=',kt
C==
      do it=1,ntprd
        sesat(it)=vrfy(2,it)
      enddo
      call normal(sesat,ntprd)
C== composite fields
      do i=1,imax
        obs(i)=0.
        prd(i)=0.
      enddo
      ic=0
c
      do it=1,ntprd-1
        if(sesat(it).gt.1.0) then
        ic=ic+1
        do i=1,imax
          obs(i)=obs(i)+wmoobs(i,it)
          prd(i)=prd(i)+wmoobs(i,it+1)
          r2d(i)=wmoobs(i,it)
          r2d2(i)=wmoobs(i,it+1)
        enddo
        iy=it+1960
        write(6,*)'iy=',iy
      write(45) r2d
      write(45) r2d2
        endif
      enddo
      write(6,*) 'total +ic=',ic
        do i=1,imax
          obs(i)=obs(i)/float(ic)
          prd(i)=prd(i)/float(ic)
        enddo
      write(40) obs
      write(40) prd
c
      do i=1,imax
        obs(i)=0.
        prd(i)=0.
      enddo
      ic=0
      do it=1,ntprd-1
        if(sesat(it).lt.-1.0) then
        ic=ic+1
        do i=1,imax
          obs(i)=obs(i)+wmoobs(i,it)
          prd(i)=prd(i)+wmoobs(i,it+1)
          r2d(i)=wmoobs(i,it)
          r2d2(i)=wmoobs(i,it+1)
        enddo
        iy=it+1960
        write(6,*)'iy=',iy
      write(50) r2d
      write(50) r2d2
        endif
      enddo
      write(6,*) 'total -ic=',ic
        do i=1,imax
          obs(i)=obs(i)/float(ic)
          prd(i)=prd(i)/float(ic)
        enddo
      write(40) obs
      write(40) prd
      do i=1,ntprd
        fld2(i)=vrfy(2,i)
      enddo
      write(6,888) fld2
c
C== select ENSO years
c
      do n=1,7
       do it=1,ntprd
        if(it.eq.nwarmyr(n)) then
        do i=1,imax
          r2d(i)=wmoobs(i,it)
        enddo
        iy=it+1960
        write(6,*)'iy=',iy
        write(55) r2d
        endif
       enddo
      enddo
c
      do n=1,7
       do it=1,ntprd
        if(it.eq.ncoldyr(n)) then
        do i=1,imax
          r2d(i)=wmoobs(i,it)
        enddo
        iy=it+1960
        write(6,*)'iy=',iy
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
