CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  calculate hss from the output of sequence_short-out.f
C  the input is normalized obs and prd
C==========================================================
      include "parm.h"
      real r1d1(nss),r1d2(nss),r1d3(nss)
      dimension i1d1(nss),i1d2(nss),i1d3(nss)
      dimension wk1(ncd),wk2(ncd)
      dimension wk3(ncd),wk4(ncd)
      dimension iwk3(ncd),iwk4(ncd)
      dimension obs(ncd,nss),prd(ncd,nss)
      dimension iobs(ncd,nss),iprd(ncd,nss)
c
      open(unit=10,form='unformatted',access='direct',recl=4*ncd)
      open(unit=20,form='unformatted',access='direct',recl=4*ncd)
      open(unit=30,form='unformatted',access='direct',recl=4)
      open(unit=40,form='unformatted',access='direct',recl=4*ncd)

c== have data
      do is=1,nss
        read(10,rec=is) wk1
        read(20,rec=is) wk2
        do i=1,ncd
        prd(i,is)=wk1(i)
        obs(i,is)=wk2(i)
        end do
      enddo
 888  format(10f7.1)
c
c== have hss time series
c
      a=0.4308 
      b=-0.4308 

      avghs=0
      do k=1,nss

      do i=1,ncd
        wk3(i)=obs(i,k)
        wk4(i)=prd(i,k)
      enddo

      call terc102(wk3,a,b,iwk3) 
      call terc102(wk4,a,b,iwk4) 

      do i=1,ncd
        iobs(i,k)=iwk3(i)
        iprd(i,k)=iwk4(i)
      enddo
      
      call heidke(iwk3,iwk4,h,hs,ncd)

      write(30,rec=k) hs
      avghs=avghs+hs/float(nss)
      write(6,*) 'ns=',k,'hit#=',h,'hss=',hs

      enddo  !for k
c
      write(6,*) 'avg_hs=',avghs
c
c== have hss map
c
      vaghs=0.
      do i=1,ncd
        do k=1,nss
          i1d1(k)=iobs(i,k)
          i1d2(k)=iprd(i,k)
        enddo
        call heidke(i1d1,i1d2,h,wk1(i),nss)
        vaghs=avghs+wk1(i)/float(ncd)
      enddo
      write(40,rec=1) wk1
      write(6,888) wk1
      write(6,*) 'CONUS avg_hs=',avghs
      
      stop
      end
        
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero2(a,m,n)
      real a(m,n)
c
      do i=1,m
      do j=1,n
        a(i,j)=0.
      end do
      end do
c
      return
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

      SUBROUTINE terc102(t,a,b,it3) 
c* transforms 102 temperatures into 102 terciled values 
      DIMENSION t(102),it3(102) 
      DO 11 i=1,102 
      icd=i 
      IF (t(icd).le.b)it3(i)=-1 
      IF (t(icd).ge.a)it3(i)=1 
      IF (t(icd).lt.a.and.t(icd).gt.b)it3(i)=0 
11    CONTINUE 
      RETURN 
      END 

      subroutine heidke(it1,it2,h,ss,ncd) 
      dimension it1(ncd),it2(ncd) 
      h=0. 
      tot=0. 
      do i=1,ncd 
      tot=tot+1. 
      if (it1(i).eq.it2(i))h=h+1. 
      enddo 
      ss=(h-tot/3.)/(tot-tot/3.)*100. 
      return 
      end 

      subroutine heidke1(it1,it2,h,ss2,tot) 
c     subroutine heidke1(it1,it2,h,j,j1,m,tot,ict) 
      dimension it1(102),it2(102),ict(-1:2,-1:2,14) 
      h=0. 
      tot=0. 
      do i=1,102 
c     ict(it1(i),it2(i),m)=ict(it1(i),it2(i),m)+1 
c     ict(it1(i),it2(i),14)=ict(it1(i),it2(i),14)+1 
      if (it1(i).eq.0)goto 987 
      tot=tot+1. 
      if (it1(i).eq.it2(i))h=h+1. 
987   continue 
      enddo 
      ss=-9999999. 
      if (tot.gt.0)ss=(h-tot/3.)/(tot-tot/3.)*100. 
      ss2=ss*tot/102. 
c     write(6,100)h,ss,ss2,tot/102.,j,j1,m,tot 
100   format(1h ,'heidke A&B', 4f6.1,3i5,f6.0) 
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
