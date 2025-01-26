CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill (cor & rms) of OCN prd based on PC
C==========================================================
#include "parm.h"
      real r1d1(nyr),r1d2(nyr),r1d3(nyr)
      dimension wkt1(nyr*12),wkt2(nyr*12)
      dimension wkt3(nyr*12),wkt4(nyr*12)
      dimension w1(30),w2(30)
      dimension wk1(ncd),wk2(ncd)
      dimension wk3(ncd),wk4(ncd)
      dimension iwk3(ncd),iwk4(ncd)
      dimension sst(12,nyr),sclm(12)
      dimension obs(ncd,12,nyr),prd(ncd,nyr)
      dimension oclm(ncd,12)
      dimension hsk1(12,nyr),hsk2(12,nyr)
c
      open(unit=10,form='formated')
      open(unit=20,form='unformated',access='direct',recl=1)
      open(unit=30,form='unformated',access='direct',recl=1)

C== read in cd Tsfc and nino34 sst
C=  skip data of 1931.1-1949.12
      iskip=12*19 
      do it=1,iskip
        read(10,888) wk1
      end do
c== have data of 1950.1-2003.12
      do iy=1,nyr
      do  m=1,12
        read(10,888) wk1
        do i=1,ncd
        obs(i,m,iy)=wk1(i)
        end do
        read(20) xx
        sst(m,iy)=xx
      enddo
      enddo
 888  format(10f7.1)
 777  format(10f7.2)

C
C== define 30yr climate fields (71-00)
C
      call setzero2(oclm,ncd,12)
      do i=1,ncd
      do m=1,12
      do iy=22,51
        oclm(i,m)=oclm(i,m)+obs(i,m,iy)/30.
      enddo
      enddo
      enddo

      call setzero(sclm,12)
      do m=1,12
      do iy=22,51
        sclm(m)=sclm(m)+sst(m,iy)/30.
      enddo
      enddo
C
C== have anomalies wrt climate 71-00
C
      do iy=1,nyr
      do  m=1,12
      do  i=1,ncd
         obs(i,m,iy)=obs(i,m,iy)-oclm(i,m)
      enddo
         sst(m,iy)  =sst(m,iy)-sclm(m)
      enddo
      enddo

C== 3-mon running mean of the data
C for Tsfc
      ntl=nyr*12
      DO i=1,ncd 
      it=0
      do iy=1,nyr
      do m=1,12
      it=it+1
        wkt1(it)=obs(i,m,iy)
      enddo
      enddo
      call runmean(wkt1,ntl,wkt2,1)
      wkt2(1)=(wkt1(1)+wkt1(2))/2.
      wkt2(ntl)=(wkt1(ntl)+wkt1(ntl-1))/2.
      it=0
      do iy=1,nyr
      do m=1,12
      it=it+1
        obs(i,m,iy)=wkt2(it)
      enddo
      enddo
      ENDDO
C for nino34
      it=0
      do iy=1,nyr
      do m=1,12
      it=it+1
        wkt1(it)=sst(m,iy)
      enddo
      enddo
      call runmean(wkt1,ntl,wkt2,1)
      wkt2(1)=(wkt1(1)+wkt1(2))/2.
      wkt2(ntl)=(wkt1(ntl)+wkt1(ntl-1))/2.
      it=0
      do iy=1,nyr
      do m=1,12
      it=it+1
        sst(m,iy)=wkt2(it)
      enddo
      enddo
C
C== have prd field and have H skill
C
      DO m=1,12   !for each season
C== have regression pattern of Tsfc to nino34
      ss=0
      do iy=1,nyr
        ss=ss+sst(m,iy)*sst(m,iy)/float(nyr)
      enddo
      ss=sqrt(ss)
c
      do i=1,ncd
      st=0
      do iy=1,nyr
        st=st+obs(i,m,iy)*sst(m,iy)/float(nyr)
      end do
        regr=st/ss
      do iy=1,nyr
        prd(i,iy)=regr*sst(m,iy)/ss
      end do
      end do
c
c==normalize prd and obs
c
      do i=1,ncd
c  have stdv for 70-00
      do iy=1,30
        w1(iy)=obs(i,m,iy+21)
        w2(iy)=prd(i,iy+21)
      enddo
      call stdv(w1,30,sdo)
      call stdv(w2,30,sdp)
c  normalize data
      do iy=1,nyr
        obs(i,m,iy)=obs(i,m,iy)/sdo
        prd(i,iy) = prd(i,iy)/sdp
      enddo
      enddo !loop for ncd
c
c== have Heidke skill
c
      a=0.4308 
      b=-0.4308 

      avghs=0
      avghs1=0
      avg_tot=0
      do k=1,nyr

      do i=1,ncd
        wk3(i)=obs(i,m,k)
        wk4(i)=prd(i,k)
      enddo
c     write(6,*) 'ny=',k
c     write(6,777) wk3
c     write(6,777) wk4
      
      call terc102(wk3,a,b,iwk3)
      call terc102(wk4,a,b,iwk4)
        
      call heidke(iwk3,iwk4,h,hs,ncd)
      call heidke1(iwk4,iwk3,h1,hs1,tot)
      hsk1(m,k)=hs
      hsk2(m,k)=hs1
      avghs=avghs+hs/float(nyr)
      avghs1=avghs1+hs1/float(nyr)
      avg_tot=avg_tot+tot/float(nyr)
c     write(6,999) k,h,hs,h1,hs1,tot
 999  format(I3,3x,f6.1,3x,f6.1,3x,f6.1,3x,f6.1,3x,f6.1)

      enddo  !for k
      END DO ! for month
c
      it=0
      do k=1,nyr
      do m=1,12 
      it=it+1
      wkt1(it)=hsk1(m,k)
      wkt3(it)=hsk2(m,k)
      enddo
      enddo
      call rm_48m(wkt1,wkt2,ntl,ntl,48)
      call rm_48m(wkt3,wkt4,ntl,ntl,48)
c
      do k=1,ntl
      write(30) wkt2(k)
      write(30) wkt4(k)
      enddo

      write(6,*) 'avg_hs=',avghs
      write(6,*) 'avg_hs1=',avghs1
      write(6,*) 'avg_tot=',avg_tot
      
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

      subroutine heidke(it1,it2,h,ss,tot) 
c     subroutine heidke(it1,it2,h,j,j1,m,tot) 
      dimension it1(102),it2(102) 
      h=0. 
      tot=0. 
      do i=1,102 
      tot=tot+1. 
      if (it1(i).eq.it2(i))h=h+1. 
      enddo 
      ss=(h-tot/3.)/(tot-tot/3.)*100. 
c     write(6,100)h,ss,j,j1,m,tot 
100   format(1h ,2f6.1,3i5,f6.0) 
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
