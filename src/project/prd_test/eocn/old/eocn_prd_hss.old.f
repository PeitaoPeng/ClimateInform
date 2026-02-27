CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill (cor & rms) of OCN prd based on PC
C==========================================================
      include "parm.h"
      real r1d1(ntprd-30)
      real r2d(imax),skill(imax),eof(imax,mmax)
      real obs(imax),prd(imax),prd2(imax)
      real obs2d(imax,ntprd),prd2d(imax,ntprd)
      real grid(imax,ltime),wmoobs(imax,ntprd)
      real fld1(ltime)
      real fld2D(mmax,ltime)
      real fldprd(mmax,ntprd)
      real pcprd(mmax)
      real vrfy(mmax,ntprd)
      real wk1d1(ntprd),wk1d2(ntprd)
      real wk1d3(kp),wk1d4(kp)
c     dimension kk2d(mmax,12),kk(mmax),ksign(mmax)
      dimension kk2d(6,12),kk(mmax),ksign(6)
      dimension wk1(30),wk2(30)
      dimension obsn(imax,ntprd),prdn(imax,ntprd)
      dimension wk3(102),wk4(102)
      dimension iwk3(102),iwk4(102)
      dimension ms(kp),kmax(ntprd,mmax)
      dimension maxk(mmax)
      dimension kavg(mmax),kstd(mmax)
      dimension wavg(mmax),wstd(mmax)
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
c     data kk/17,23,23,29,8,5/    !NDJ  1 1 0 1 1 1
c     data kk/17,23,25,29,8,5/   !DJF  1 1 1 1 1 1

      data kk2d/9, 5, 5, 8, 7, 6,
     &8, 9, 5, 6, 6, 7,
     &7, 7, 7, 8, 6, 5,
     &8, 8, 8, 8, 9, 5,
     &5, 8, 4, 7, 9, 9,
     &8, 6, 7, 5, 7, 7,
     &4, 8, 3, 5, 7, 10,
     &6, 9, 8, 4, 7, 6,
     &9, 6, 8, 8, 7, 7,
     &7, 8, 8, 6, 7, 5,
     &8, 6, 6, 5, 5, 7,
     &7, 4, 5, 4, 5, 7/
      data ksign/1,1,1,1,1,1/
c
      open(unit=10,form='unformatted',access='direct',recl=4*ltime)
      open(unit=30,form='formatted')
      open(unit=15,form='unformatted',access='direct',recl=4*imax)
      open(unit=20,form='unformatted',access='direct',recl=4*imax)
      open(unit=25,form='unformatted',access='direct',recl=4*imax)
      open(unit=40,form='unformatted',access='direct',recl=4)
      open(unit=50,form='unformatted',access='direct',recl=4*imax)

C== assign kk and ksign
      do k=1,mmax
         kk(k)=kk2d(k,iseason)
      enddo
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
C== from JFM1991, use optimal k determined from latest 30 year data
C== the optimal K will be in the range of 1 -> 10
c
      call opt_k(fld2D,wk1d1,wk1d2,wk1d3,wk1d4,ms,kmax(it-60,m),
     &ltime,ntprd,mmax,kp,it,m)
c
      kt=kt+1
         avg=0
         do k=it-kmax(it-60,m),it-1
         avg=avg+fld2D(m,k)/float(kmax(it-60,m))
c        do k=it-kk(m),it-1
c        avg=avg+fld2D(m,k)/float(kk(m))
         end do
         fldprd(m,kt)=avg-clm4
         vrfy(m,kt)=fld2D(m,it)-clm4
      end do

      do it=71,ltime  !73=2003
c
      call opt_k(fld2D,wk1d1,wk1d2,wk1d3,wk1d4,ms,kmax(it-60,m),
     &ltime,ntprd,mmax,kp,it,m)
c
      kt=kt+1
         avg=0
         do k=it-kmax(it-60,m),it-1
         avg=avg+fld2D(m,k)/float(kmax(it-60,m))
c        do k=it-kk(m),it-1
c        avg=avg+fld2D(m,k)/float(kk(m))
         end do
         fldprd(m,kt)=avg-clm5
         vrfy(m,kt)=fld2D(m,it)-clm5
      end do
      ENDDO   !loop over mode
C
C== construct obs and prd
C
      do it=1,ntprd
c
      do i=1,imax
        obs(i)=0.
        prd(i)=0.
      enddo
c
      do i=1,imax
        obs(i)=wmoobs(i,it)
      do m=1,mmax
        prd(i)=prd(i)+ksign(m)*fldprd(m,it)*eof(i,m)
      enddo
      enddo
c     write(20,rec=it) obs
c     write(25,rec=it) prd
      do i=1,imax
        prd2d(i,it)=prd(i)
      enddo
      enddo !loop over time
c
c==normalize prd and obs
c
      do i=1,imax
c  have stdv for 61-90
      do k=1,30
        wk1(k)=wmoobs(i,k)
        wk2(k)=prd2d(i,k)
      enddo
      call stdv(wk1,30,sdo)
      call stdv(wk2,30,sdp)
c  normalize for 61-00
      do k=1,40
        obsn(i,k)=wmoobs(i,k)/sdo
        prdn(i,k) = prd2d(i,k)/sdp
      enddo
c  have stdv for 71-00
      do k=1,30
        wk1(k)=wmoobs(i,k+10)
        wk2(k)=prd2d(i,k+10)
      enddo
      call stdv(wk1,30,sdo)
      call stdv(wk2,30,sdp)
c  normalize for 01-present
      do k=41,ntprd
        obsn(i,k)=wmoobs(i,k)/sdo
        prdn(i,k)=prd2d(i,k)/sdp
      enddo

      enddo !loop for i (1->imax)
c
cc write out normalized obs and prd
c
      do it=1,ntprd-30
      do i=1,imax
        obs(i)=obsn(i,it+30)
        prd(i)=prdn(i,it+30)
      enddo
      write(20,rec=it) obs
      write(25,rec=it) prd
      enddo
c
c= write out non-normalized obs and prd
c
      do it=1,ntprd-30
        do i=1,imax
          prd(i)=prd2d(i,it+30)
        end do
        write(50,rec=it) prd
      end do
c    
c== have Heidke skill
c
     
      a=0.4308 
      b=-0.4308 

      avghs=0
      do k=1,ntprd-30

      do i=1,imax
        wk3(i)=obsn(i,k+30)
        wk4(i)=prdn(i,k+30)
      enddo
      
      call terc102(wk3,a,b,iwk3)
      call terc102(wk4,a,b,iwk4)
        
      ximax=102.
      call heidke(iwk3,iwk4,h,hs,ximax)
      avghs=avghs+hs/float(ntprd-30)
      r1d1(k)=hs
      write(6,999) k,h,hs
 999  format(I3,3x,f6.1,3x,f6.1)
      enddo

      do it=1,ntprd-30
      write(40,rec=it) r1d1(it)
      enddo

      write(6,*) 'avg_hs=',avghs
c
      do it=1,20
        do m=1,mmax
        maxk(m)=kmax(it,m)
        enddo
      write(6,*) 'it= ',it,'  maxk= ',maxk
      enddo

      do m=1,mmax
        wavg(m)=0
        do it=1,ntprd-30
        wavg(m)=wavg(m)+kmax(it,m)
        enddo
        wavg(m)=wavg(m)/float(ntprd-30)
        kavg(m)=wavg(m)
      enddo
      write(6,*) 'avg k= ',kavg(1),',',kavg(2),',',kavg(3),',',
     &kavg(4),',',kavg(5),',',kavg(6),','
      do m=1,mmax
        wstd(m)=0
        do it=1,ntprd-30
        wstd(m)=wstd(m)+(kmax(it,m)-wavg(m))*(kmax(it,m)-wavg(m))
        enddo
        kstd(m)=sqrt(wstd(m)/float(ntprd-30))
      enddo
      write(6,*) 'std k= ',kstd
      
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
C  acc in time domain for the latest m yrs
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc(a,b,n,m,c)
      real a(n),b(n)
c
      avg_a=0.
      avg_b=0.
      do i=n-m+1,n
c       avg_a=avg_a+a(i)/float(m)
c       avg_b=avg_b+b(i)/float(m)
      enddo
c
      do i=n-m+1,n
      a(i)=a(i)-avg_a
      b(i)=b(i)-avg_b
      enddo
c
      sd_a=0
      sd_b=0
      ac=0
      do i=n-m+1,n
      sd_a=sd_a+a(i)*a(i)/float(m)
      sd_b=sd_b+b(i)*b(i)/float(m)
      ac=ac+a(i)*b(i)/float(m)
      enddo
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)
      c=ac/(sd_a*sd_b)
c     
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  rms in time domain for the latest m yrs
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rms(a,b,n,m,c)
      real a(n),b(n)
c
      c=0.
      do i=n-m+1,n
      c=c+(a(i)-b(i))*(a(i)-b(i))/float(m)
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

      subroutine opt_k(fld2D,fldprd,vrfy,score1,score2,ms,maxk,
     &ltime,ntprd,mmax,kp,ite,im)
c
      dimension fld2D(mmax,ltime),fldprd(ntprd),vrfy(ntprd)
      dimension score1(kp),score2(kp)
      dimension ms(kp)
C== define 30yr climate fields (31-60,41-70,51-80,61-90,71-00)
        clm1=0.0
        clm2=0.0
        clm3=0.0
        clm4=0.0
        clm5=0.0
      do k=1,30
        clm1=clm1+fld2D(im,k)/30.
        clm2=clm2+fld2D(im,k+10)/30.
        clm3=clm3+fld2D(im,k+20)/30.
        clm4=clm4+fld2D(im,k+30)/30.
        clm5=clm5+fld2D(im,k+40)/30.
      enddo
C== prediction with OCN
C== test different K(the length of period of avg)
      do kk=1,kp  !loop over K
      kt=0
      do it=31,40  !31=1961; 40=1970
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(im,k)/float(kk)
         end do
         fldprd(kt)=avg-clm1
         vrfy(kt)=fld2D(im,it)-clm1
      end do

      do it=41,50  !41=1971; 50=1980
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(im,k)/float(kk)
         end do
         fldprd(kt)=avg-clm2
         vrfy(kt)=fld2D(im,it)-clm2
      end do

      do it=51,60  !51=1981; 61=1990
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(im,k)/float(kk)
         end do
         fldprd(kt)=avg-clm3
         vrfy(kt)=fld2D(im,it)-clm3
      end do

      itend=70
      if (ite.gt.60.and.ite.le.70) itend=ite

      do it=61,itend  !61=1991; 70=2000

      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(im,k)/float(kk)
         end do
         fldprd(kt)=avg-clm4
         vrfy(kt)=fld2D(im,it)-clm4
      end do

      if (ite.gt.60.and.ite.le.70) go to 1100

      do it=71,ite  !73=2003
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(im,k)/float(kk)
         end do
         fldprd(kt)=avg-clm5
         vrfy(kt)=fld2D(im,it)-clm5
      end do

 1100 continue

C== acc calculation for the latest 30 yr data
      call acc(fldprd,vrfy,ntprd,30,ac)
      call rms(fldprd,vrfy,ntprd,30,rm)
      score1(kk)=ac
      score2(kk)=rm

      ENDDO   !loop over kk

C===  select optimal K
        do k=1,kp
c       ms(k)=1000*score1(k)
        ms(k)=1000*score2(k)
        enddo
c       mms=max0(ms(1),ms(2),ms(3),ms(4),ms(5),ms(6),ms(7),ms(8),ms(9),
        mms=min0(ms(1),ms(2),ms(3),ms(4),ms(5),ms(6),ms(7),ms(8),ms(9),
     &ms(10))
        do k=1,kp
          if (mms.eq.ms(k)) then
            maxk=k
            go to 1000
          end if
        enddo
 1000 continue
c
c     write(20,*) 'optimal K for each mode'
c     write(20,777) maxk
c     write(20,*) 'AC score of optimal predition for each mode'
c     write(20,999) accf
c
      return
      end
