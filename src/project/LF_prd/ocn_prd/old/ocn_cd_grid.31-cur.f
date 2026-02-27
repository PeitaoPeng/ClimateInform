CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C OCN on grids
C===========================================================
      include "parm.h"
      parameter(kp=10)
      real fld1(ltime)
      real fld2D(ngrd,ltime)
      real grid(ngrd,ltime)
      real fldin(ngrd),accf(ngrd)
      real vrfy(ngrd,ntprd),prd2d(ngrd,ntprd)
      real prd1d(ntprd)
      real score1(ngrd),score2(ngrd)
      real coef(mmax,ltime)
      real eof(ngrd,mmax),r2d(ngrd)
      real obs(ngrd),prd(ngrd),clm5
c
      open(unit=10,form='formatted')
      open(unit=11,form='unformatted',access='direct',recl=4*ltime)
      open(unit=12,form='unformatted',access='direct',recl=4*ngrd)
      open(unit=20,form='formatted')
      open(unit=30,form='unformatted',access='direct',recl=4*ngrd)
      open(unit=40,form='formatted')

CCC read in data from EOF expansion
c== read in pc data
      do m=1,mmax
        read(11,rec=m) fld1
      do k=1,ltime
        coef(m,k)=fld1(k)
      enddo
      enddo
c== read in regr data
      do m=1,mmax
        read(12,rec=m) r2d
      do i=1,ngrd
        eof(i,m)=r2d(i)
      enddo
      enddo
c== reconstruct 3-D data with coef and eof
      do it=1,ltime
c
      do i=1,ngrd
        r2d(i)=0.
      enddo
c
      do i=1,ngrd
      do m=1,mmax
        r2d(i)=r2d(i)+coef(m,it)*eof(i,m)
      enddo
      enddo
c
      do i=1,ngrd
        fld2D(i,it)=r2d(i)
      enddo
      write(40,888) r2d
c
      ENDDO
c
C== read in data from grid
c
      do it=1,ltime
        read(10,888) fldin
      do k=1,ngrd
        grid(k,it)=fldin(k)   
c       fld2D(k,it)=fldin(k)   !comment it means using EOF constructed datd for prd
      enddo
      enddo
 888  format(10f7.1)
C
C== define 30yr climate fields (31-60,41-70,51-80,61-90 and 71-00)
C
      do i=1,ngrd
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
      vrfy(i,kt)=grid(i,it)-c1
      enddo
      do it=41,50  !41=1971; 50=1980
      kt=kt+1
      vrfy(i,kt)=grid(i,it)-c2
      enddo
      do it=51,60  !51=1981; 60=1990
      kt=kt+1
      vrfy(i,kt)=grid(i,it)-c3
      enddo
      do it=61,70  !61=1991; 70=2000
      kt=kt+1
      vrfy(i,kt)=grid(i,it)-c4
      enddo
      do it=71,ltime  !71=2001
      kt=kt+1
      vrfy(i,kt)=grid(i,it)-c5
      enddo
      enddo  !loop for ngrd
C== loop over grids
      do m=1,ngrd
C== define 30yr climate fields (31-60,41-70,51-80,61-90 and 71-00)
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
C== test different K(the length of period of avg)
      kk=kp
      kt=0
      do it=31,40  !31=1961; 40=1970
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         prd2d(m,kt)=avg-clm1
      end do

      do it=41,50  !41=1971; 50=1980
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         prd2d(m,kt)=avg-clm2
      end do

      do it=51,60  !51=1981; 60=1990
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         prd2d(m,kt)=avg-clm3
      end do

      do it=61,70  !61=1991; 70=2000
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         prd2d(m,kt)=avg-clm4
      end do

      do it=71,ltime  !71=2001
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         prd2d(m,kt)=avg-clm5
      end do
c== using vrfy to vrfy
      do it=1,ntprd
        obs(it)=vrfy(m,it)
        prd1d(it)=prd2d(m,it)
      enddo
C== acc calculation
      call acc(prd1d,obs,ntprd,ac)
      call rms(prd1d,obs,ntprd,rm)
      score1(m)=ac
      score2(m)=rm
 999  format(5x,10f6.2)
      ENDDO   !loop over grid points
      write(20,*) 'AC score of predition'
      write(20,999) score1
      write(20,999) score2
C
      write(30) score1
c     write(30) score2
 900  format(10f7.2)
 777  format(10I8)
      call acc(prd2d,vrfy,ntprd*ngrd,tac)
      call rms(prd2d,vrfy,ntprd*ngrd,trm)
      write(6,*)'acc_avg=',tac,'rsm_avg=',trm
C
C== prd for next year (real prd)
C
      DO m=1,ngrd
         avg=0
         do k=ltime+1-kp,ltime
         avg=avg+fld2D(m,k)/float(kk)
         end do
         prd(m)=avg-clm5
      END DO
c     write(30) prd
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

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc in time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc(a,b,n,c)
      real a(n),b(n)
c
      avg_a=0.
      avg_b=0.
      do i=1,n
        avg_a=avg_a+a(i)/float(n)
        avg_b=avg_b+b(i)/float(n)
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

