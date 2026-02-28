CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill of OCN prd based on RPC or other linear decomposition
C==========================================================
#include "parm.h"
      real r1d1(ntprd),r1d2(ntprd)
      real r2d(imax),reof(imax,mmax)
      real obs(imax),prd(imax)
      real obs2d(imax,ntprd),prd2d(imax,ntprd)
      real grid(imax,ltime),wmoobs(imax,ntprd)
      real fld1(ltime)
      real fld2D(mmax,ltime)
      real fldprd(mmax,ntprd)
      real vrfy(mmax,ntprd)
      dimension kk(mmax),ksign(mmax)
      data kk/1,1,1/
      data ksign/1,1,1/
c
      open(unit=10,form='unformated',access='direct',recl=ltime)
      open(unit=11,form='unformated',access='direct',recl=ltime)
      open(unit=30,form='formated')
      open(unit=15,form='unformated',access='direct',recl=imax)
      open(unit=20,form='unformated',access='direct',recl=imax)

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
c       fld2D(2,k)=-fld1(k)
      enddo
C== read in regr data
      do m=1,mmax
        read(15,rec=m) r2d
      do i=1,imax
        reof(i,m)=r2d(i)
      enddo
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
C== construct obs and prd
      do it=1,ntprd
c
      do i=1,imax
        obs(i)=0.
        prd(i)=0.
      enddo
c
      do i=1,imax
      do m=1,mmax
        obs(i)=obs(i)+ksign(m)*vrfy(m,it)*reof(i,m)
        prd(i)=prd(i)+ksign(m)*fldprd(m,it)*reof(i,m)
      enddo
      enddo
c     write(20) obs
      write(40,888) prd
      do i=1,imax
        obs2d(i,it)=obs(i)
        prd2d(i,it)=prd(i)
      enddo
      enddo !loop over time
c== cor of prd vs obs
      do it=1,ntprd
c       r1d2(it)=-fld2D(2,it+29)
        r1d2(it)= fldprd(3,it)
      enddo
      do i=1,imax
        do it=1,ntprd
          r1d1(it)=wmoobs(i,it)
        enddo
        call acc(r1d1,r1d2,ntprd,ac)
          r2d(i)=ac 
      enddo
      write(6,777) r2d
      write(20) r2d
 777  format(10f7.2)
      tac=0.
      do i=1,imax
        tac=tac+r2d(i)/102.
      enddo
      write(6,*)'acc_avg=',tac

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
