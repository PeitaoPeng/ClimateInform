CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C AR and LP-persistent prd
C===========================================================
#include "parm.h"
      real*4 fld1D(ltime)
      real*4 fld1DL(ltime),wout(ltime)
      real*4 fld1DH(ltime)
      real wk(ltime)
      real ts1(3*ltime-2),yh(3*ltime-2),yl(3*ltime-2)

      open(unit=10,form='unformated',access='direct',recl=ltime)
      open(unit=50,form='unformated',access='direct',recl=ltime)
c     open(unit=60,form='unformated',access='direct',recl=ltime)

C== read in data
c
        pi=3.14159
        do i=1,ltime
c         fld1D(i)=sin(2*pi*i*7/ltime)
        end do
c
        do m=1,1 !mode
        read(10) fld1D
        write(50) fld1D
        
C== filtering
c extend and filter the whole time series first
        do k=1,ltime
         wk(k)=fld1D(k)
        enddo
        write(6,666) wk
        call anom(wk,ltime)
        nn=3*ltime-2
        call setzero(ts1,nn)
        call t_extend(ltime,wk,nn,ts1)
        write(6,666) wk2
        call msf(nn,ts1,yh,yl,ph,pm,pl,fhl,dt)
c
        do k=1,ltime
         fld1DL(k)=yl(k+ltime-1)
         fld1DH(k)=yh(k+ltime-1)
         wout(k)=yl(k+ltime-1)
        enddo
        write(50) fld1DL
        write(50) fld1DH
        write(6,*)'finished whole time series'
 666  format(10f7.2)
c
c filter part of it and have the end point value
c
      do morder=2,2
      DO nend=30,ltime-1        !extend end point from t=31 to 71
c     write(6,*)'nend=',nend
        call setzero(ts1,nn)
        call setzero(wk,ltime)
        do k=1,nend
          wk(k)=fld1D(k)
        enddo
c       write(6,666) wk
        call auto_regr_pred(ltime,wk,nend,morder,pred)
c     write(6,*)'pred=',pred
c        wout(nend+1)=pred
c
        call t_extend(nend,wk,nn,ts1)
c       write(6,666) fld1D
c       write(6,666) wk
c       write(6,666) ts1
        mm=3*nend-2
        call msf(mm,ts1,yh,yl,ph,pm,pl,fhl,dt)
         fld1DL(nend)=yl(2*nend-1)
         fld1DH(nend)=yh(2*nend-1)
         wout(nend)=fld1DL(nend)
      END DO
      call acc_in_t(fld1D,wout,rms,acc,ltime,31)
      write(6,*)'morder=',morder,'rms=',rms,'  acc=',acc
      end do
c     write(50) fld1DL
      write(50) wout
c     write(60) fld1DH
      enddo !mode
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
C  antisymmetrically extend the time series
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine t_extend(n,ts1,m,ts2)
      dimension ts1(n),ts2(m)
      real leftend
      fac=0.
c
      leftend=ts1(1)
      rightend=ts1(n)
c
      do i=1,n-1
c     ts2(i)=(-ts1(n-i+1) + 2.0*leftend)*fac !*float(i)/float(n-1)
      ts2(i)=fac*ts1(n-i+1)  !symmetric extention
      enddo
c
      do i=1,n
      ts2(i+n-1)=ts1(i)
      enddo
c
      do i=1,n-1
c     ts2(i+n*2-1)=(2.0*rightend - ts1(n-i))*fac !*(n-i)/float(n-1)
      ts2(i+n*2-1)=fac*ts1(n-i)  !symmetric extention
      enddo
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  pad with 2 zero for each side
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine t_extend_2(n,ts1,ts2)
      dimension ts1(n),ts2(n+4)
c
      do i=1,n+4
      ts2(i)=0.
      enddo
c
      do i=1,n
      ts2(i+2)=ts1(i)
      enddo
c
      Return
      end


      SUBROUTINE acc_in_t(fld1,fld2,rms,acc,ltime,nstart)
      real*4 fld1(ltime),fld2(ltime)
c
      rms=0.
      acc=0.
      s1=0.
      s2=0.
      xy=0.
      xn=ltime-nstart+1
      do it=nstart,ltime
          rr=fld1(it)-fld2(it)
          rms=rms+rr*rr/xn
          s1=s1+fld1(it)*fld1(it)/xn
          s2=s2+fld2(it)*fld2(it)/xn
          xy=xy+fld1(it)*fld2(it)/xn
      end do
         rms=rms**0.5
         s1=s1**0.5
         s2=s2**0.5
         acc=xy/(s1*s2)
      return
      end
