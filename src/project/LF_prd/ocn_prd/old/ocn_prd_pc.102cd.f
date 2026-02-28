CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill (cor & rms) of OCN prd based on PC
C==========================================================
      include "parm.h"
      real r1d1(ntprd),r1d2(ntprd),r1d3(ntprd)
      real r2d(imax),skill(imax),eof(imax,mmax)
      real obs(imax),prd(imax),prd2(imax)
      real obs2d(imax,ntprd),prd2d(imax,ntprd)
      real grid(imax,ltime),wmoobs(imax,ntprd)
      real fld1(ltime)
      real fld2D(mmax,ltime)
      real fldprd(mmax,ntprd)
      real pcprd(mmax)
      real vrfy(mmax,ntprd)
      real clm5(mmax)
      dimension kk2d(6,12),kk(6),ksign(6)
      dimension stdvm(6)
      dimension stdvg(imax)
c
c     data kk/17,10,25,29,30,4/  !JFM  1 1 1 1 1 1
c     data kk/15,12,15,8,30,5/   !FMA  1 1 1 1 1 1
c     data kk/15,12,12,8,30,6/   !MAM  1 1 1 1 1 1
c     data kk/17,16,12,9,8,6/    !AMJ  1 1 1 1 1 1
c     data kk/17,16,12,10,9,6/   !MJJ  1 1 1 1 1 1
c     data kk/18,15,8,9,7,7/     !JJA  1 1 1 1 1 1
c     data kk/18,15,8,8,7,9/     !JAS  1 1 1 1 1 1
c     data kk/18,15,8,8,7,9/     !ASO  1 1 1 1 1 1
c     data kk/19,15,8,9,17,9/    !SON  1 1 1 1 1 1
c     data kk/19,15,23,8,8,5/    !OND  1 1 1 1 1 1
c     data kk/17,23,23,29,8,5/   !NDJ  1 1 0 1 1 1
c     data kk/17,23,25,29,8,5/   !DJF  1 1 1 1 1 1
      data kk2d/17,10,25,29,30,4,
     &15,12,15,8,30,5,
     &15,12,12,8,30,6,
     &17,16,12,9,8,6,
     &17,16,12,10,9,6,
     &18,15,8,9,7,7,
     &18,15,8,8,7,9,
     &18,15,8,8,7,9,
     &19,15,8,9,17,9,
     &19,15,23,8,8,5,
     &17,23,23,29,8,5,
     &17,23,25,29,8,5/
      data ksign/1,1,1,1,1,1/
c
      open(unit=10,form='unformatted',access='direct',recl=4*ltime)
      open(unit=30,form='formatted')
      open(unit=15,form='unformatted',access='direct',recl=4*imax)
      open(unit=20,form='unformatted',access='direct',recl=4*imax)
      open(unit=25,form='unformatted',access='direct',recl=4*ntprd)
      open(unit=35,form='formatted')
      open(unit=40,form='formatted')

C== assign kk and ksign
      do k=1,mmax
         kk(k)=kk2d(k,iseason)
      enddo
      write(6,*) 'kk=',kk
      if (iseason.eq.11) ksign(3)=0
C== read in 102 cd data
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
      do it=71,ltime  !71=2001
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c5
      enddo
      enddo  !loop for imax
C== write out WMO anom
      DO it=1,ltime-30
        do id=1,imax
          r2d(id)=wmoobs(id,it)
        end do
        write(35,666) r2d
      END DO
C== read in pc data
      do m=1,mmax
        read(10,rec=m) fld1
      do k=1,ltime
        fld2D(m,k)=fld1(k)
      enddo
      enddo
C== read in regr data
      do m=1,mmax
        read(15,rec=m) r2d
      do i=1,imax
        eof(i,m)=r2d(i)
      enddo
      enddo
C== loop over mode
      do m=1,mmax
C== define 30yr climate fields (51-80 and 61-90 and 71-00)
        clm1=0.0
        clm2=0.0
        clm3=0.0
        clm4=0.0
        clm5(m)=0.0
      do k=1,30
        clm1=clm1+fld2D(m,k)/30.
        clm2=clm2+fld2D(m,k+10)/30.
        clm3=clm3+fld2D(m,k+20)/30.
        clm4=clm4+fld2D(m,k+30)/30.
        clm5(m)=clm5(m)+fld2D(m,k+40)/30.
      enddo
C== prediction with OCN
      kt=0
      do it=31,40  !31=1961; 40=1970
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

      do it=71,ltime  !73=2003
      kt=kt+1
         avg=0
         do k=it-kk(m),it-1
         avg=avg+fld2D(m,k)/float(kk(m))
         end do
         fldprd(m,kt)=avg-clm5(m)
         vrfy(m,kt)=fld2D(m,it)-clm5(m)
      end do
      ENDDO   !loop over mode
C
C==  stdv of fldprd
C
      do m=1,mmax
        do k=1,ntprd
          r1d1(k)=fldprd(m,k)
        enddo
c     write(6,*) r1d1
        call stdv(r1d1,ntprd,stdvm(m))
      enddo
      write(6,*) 'stdv of fldprd=',stdvm
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
        obs(i)=obs(i)+ksign(m)*vrfy(m,it)*eof(i,m)
c       prd(i)=prd(i)+ksign(m)*fldprd(m,it)*eof(i,m)*stdvm(1)/stdvm(m)
        prd(i)=prd(i)+ksign(m)*fldprd(m,it)*eof(i,m)
      enddo
      enddo
      write(40,666) prd
      do i=1,imax
        obs2d(i,it)=obs(i)
        prd2d(i,it)=prd(i)
      enddo
      enddo !loop over time
c== skill of prd
      do i=1,imax
        do it=1,ntprd
          r1d1(it)=wmoobs(i,it)
          r1d2(it)=prd2d(i,it)
        enddo
        call acc(r1d1,r1d2,ntprd,ac)
        call rms(r1d1,r1d2,ntprd,rm)
          r2d(i)=ac 
          skill(i)=rm 
      enddo
c     write(6,777) r2d
      write(20,rec=1) r2d
      write(20,rec=2) skill
 777  format(10f7.2)
 666  format(10f6.1)
      call acc(wmoobs,prd2d,ntprd*102,tac)
      call rms(wmoobs,prd2d,ntprd*102,trm)
      write(6,*)'acc_avg=',tac,'rsm_avg=',trm
      rewind (10)
      rewind (30)
      rewind (15)
C== write out prd and vrfy time series
      do m=1,mmax
        do it=1,ntprd
          r1d1(it)=fldprd(m,it)
          r1d2(it)=vrfy(m,it)
        enddo
        write(25,rec=1) r1d1
        write(25,rec=2) r1d2
      enddo
C
C== prd for next year (real prd)
C
      DO m=1,mmax
         avg=0
         do k=ltime+1-kk(m),ltime
         avg=avg+fld2D(m,k)/float(kk(m))
         end do
         pcprd(m)=avg-clm5(m)
      ENDDO
c
c= stdv of 1971-2000
c
      do i=1,imax
        stdvg(i)=0.
      do it=11,40
        stdvg(i)=stdvg(i)+wmoobs(i,it)*wmoobs(i,it)/30.
      enddo
        stdvg(i)=sqrt(stdvg(i))
      enddo

      do i=1,imax
        prd(i)=0.
      enddo
c
      do i=1,imax
      do m=1,mmax
c       prd(i)=prd(i)+ksign(m)*pcprd(m)*eof(i,m)*stdvm(1)/stdvm(m)
        prd(i)=prd(i)+ksign(m)*pcprd(m)*eof(i,m)
      enddo
      enddo
c have prd=prd/stdv
      do i=1,imax
        prd2(i)=prd(i)/stdvg(i)
      enddo
      write(20) prd
      write(20) prd2
c     write(6,*) 'real prd :'
c     write(6,888) prd

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
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  stdv of the time series
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine stdv(a,n,c)
      real a(n)
c
      avg_a=0.
      do i=1,n
c       avg_a=avg_a+a(i)/float(n)
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
