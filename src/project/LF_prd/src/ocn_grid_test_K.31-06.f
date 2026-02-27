CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C OCN based on REOFs or other linear decompositions
C===========================================================
      include "parm.h"
      parameter(kp=30)
      real fld1(ltime)
      real fld2D(ngrd,ltime)
      real fldin(ngrd),accf(ngrd),rmsf(ngrd)
      dimension ms(kp),maxk(ngrd)
      real vrfy(ntprd),fldprd(ntprd)
      real score1(ngrd,kp),score2(ngrd,kp)
c
      open(unit=10,form='formatted')
      open(unit=20,form='formatted')
      open(unit=30,form='unformatted',access='direct',recl=4*ngrd)

C== read in data
      do it=1,ltime
        read(10,888) fldin
      do k=1,ngrd
        fld2D(k,it)=fldin(k)
      enddo
      enddo
 888  format(10f7.1)
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
      do kk=1,kp  !loop over K
      kt=0
      do it=31,40  !31=1961; 40=1970
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         fldprd(kt)=avg-clm1
         vrfy(kt)=fld2D(m,it)-clm1
      end do

      do it=41,50  !41=1971; 50=1980
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         fldprd(kt)=avg-clm2
         vrfy(kt)=fld2D(m,it)-clm2
      end do

      do it=51,60  !51=1981; 60=1990
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         fldprd(kt)=avg-clm3
         vrfy(kt)=fld2D(m,it)-clm3
      end do

      do it=61,70  !61=1991; 70=2000
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         fldprd(kt)=avg-clm4
         vrfy(kt)=fld2D(m,it)-clm4
      end do

      do it=71,ltime  !71=2001
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         fldprd(kt)=avg-clm5
         vrfy(kt)=fld2D(m,it)-clm5
      end do
C== acc calculation
      call acc(fldprd,vrfy,ntprd,ac)
      call rms(fldprd,vrfy,ntprd,rm)
      score1(m,kk)=ac
      score2(m,kk)=rm
      ENDDO   !loop over K
 999  format(5x,10f6.2)

      ENDDO   !loop over grid points
C===  select optimal K for each grid
      do n=1,ngrd
        do k=1,kp
        ms(k)=1000*score1(n,k)
        enddo
        mms=max0(ms(1),ms(2),ms(3),ms(4),ms(5),ms(6),ms(7),ms(8),ms(9),
     &ms(10),ms(11),ms(12),ms(13),ms(14),ms(15),ms(16),ms(17),ms(18),
     &ms(19),ms(20),ms(21),ms(22),ms(23),ms(24),ms(25),ms(26),
     &ms(27),ms(28),ms(29),ms(30))
        do k=1,kp
          if (mms.eq.ms(k)) then
            maxk(n)=k
            accf(n)=score1(n,k)
            rmsf(n)=score2(n,k)
            go to 1000
          end if
 1000 continue
        enddo
      enddo
      write(20,*) 'optimal K for each cd'
      write(20,777) maxk
      write(20,*) 'AC score of predition'
      write(20,999) accf
C
      do i=1,ngrd
        fldin(i)=maxk(i)
      enddo
      write(30) fldin
C
      write(30) accf
      write(6,900) accf
      write(6,777) maxk
 900  format(10f7.2)
 777  format(10I8)
      tac=0.
      trm=0.
      xmk=0.
      do i=1,ngrd
        if(accf(i).lt.0.) accf(i)=0.
        tac=tac+accf(i)/102.
        trm=trm+rmsf(i)/102.
        xmk=xmk+maxk(i)/102.
      enddo
      write(6,*)'acc_avg=',tac,'rms_avg=',trm
      write(6,*)'avg_max_K=',xmk
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

