CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill (cor & rms) of OCN prd based on PC
C==========================================================
      parameter(imx=144,jmx=37)
      parameter(imo=100,jmo=25)
      real obs(imx,jmx)
      real pot(imo,jmo)
      real ex(imo,jmo),ey(imo,jmo)
C
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4*imo*jmo)
c
c have potential field
      read(10,rec=1) obs
      do i=1,imo
      do j=1,jmo
        pot(i,j)=obs(i,j)
      enddo
      enddo
c have ex component
      do i=1,imo
      do j=1,jmo
         ex(i,j)=-9999.0
         ey(i,j)=-9999.0
      enddo
      enddo
     
      dx=100
      dy=100
   
      do i=1,imo-1
      do j=1,jmo-1
         ex(i,j)=(pot(i+1,j)-pot(i,j))/dx
         ey(i,j)=(pot(i,j+1)-pot(i,j))/dy
      enddo
      enddo
c
      write(20,rec=1) pot
      write(20,rec=2) ex
      write(20,rec=3) ey
c
      stop
      end
        

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc in time domain for the latest m yrs
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc(a,b,n,kp,c)
      real a(n),b(n)
c
      avg_a=0.
      avg_b=0.
c
      do i=1,n-kp
        avg_a=avg_a+a(i)/float(n-kp)
        avg_b=avg_b+b(i)/float(n-kp)
      enddo
c
      do i=1,n-kp
      a(i)=a(i)-avg_a
      b(i)=b(i)-avg_b
      enddo
c
      sd_a=0
      sd_b=0
      ac=0
      do i=1,n-kp
      sd_a=sd_a+a(i)*a(i)/float(n-kp)
      sd_b=sd_b+b(i)*b(i)/float(n-kp)
      ac=ac+a(i)*b(i)/float(n-kp)
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
      subroutine rms(a,b,n,kp,c)
      real a(n),b(n)
c
      c=0.
      do i=1,n-kp
      c=c+(a(i)-b(i))*(a(i)-b(i))/float(n-kp)
      enddo
      c=sqrt(c)
c
      return
      end
c
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  stdv
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine stdv(a,n,c)
      real a(n)
c
      ks=1
      ke=n 
c
      avg=0.
      do i=ks,ke
      avg=avg+a(i)/float(n)
      enddo
c
      c=0.
      do i=ks,ke
      c=c+(a(i)-avg)*(a(i)-avg)/float(n)
      enddo
      c=sqrt(c)
c
      return
      end
c
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine opt_ocn_k(ts1,ack,rmsk,mack,mrmsk,ltime,kp)
      dimension ts1(ltime)
      dimension ack(kp),rmsk(kp)
      dimension obs(ltime),prd(ltime)
      real ms(kp),ms2(kp)
      real mms1,mms2
C== prediction with OCN
C== test different K(the length of period of avg)
      do kk=1,kp  !loop over K
      kt=0
      do it=kp+1,ltime 
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+ts1(k)/float(kk)
         end do
         prd(kt)=avg
         obs(kt)=ts1(it)
      end do
C== ac calculation for data
      call acc(obs,prd,ltime,kp,ack(kk))
      call rms(obs,prd,ltime,kp,rmsk(kk))
c     write(6,*) 'ac=',score

      ENDDO   !loop over kk

C===  select optimal K
        do k=1,kp
        ms(k)=ack(k)
        ms2(k)=rmsk(k)
        enddo
        mms1=AMAX1(ms(1),ms(2),ms(3),ms(4),ms(5),ms(6),ms(7),
     &ms(8),ms(9),ms(10),ms(11),ms(12),ms(13),ms(14),ms(15),ms(16),
     &ms(17),ms(18),ms(19),ms(20),ms(21),ms(22),ms(23),ms(24),ms(25),
     &ms(26),ms(27),ms(28),ms(29),ms(30),ms(31),ms(32),ms(33),ms(34),
     &ms(35),ms(36),ms(37),ms(38),ms(39),ms(40),ms(41),ms(42),ms(43),
     &ms(44),ms(45),ms(46),ms(47),ms(48),ms(49),ms(50))
        mms2=AMIN1(ms2(1),ms2(2),ms2(3),ms2(4),ms2(5),
     &ms2(6),ms2(7),ms2(8),ms2(9),ms2(10),ms2(11),ms2(12),ms2(13),
     &ms2(14),ms2(15),ms2(16),ms2(17),ms2(18),ms2(19),ms2(20),ms2(21),
     &ms2(22),ms2(23),ms2(24),ms2(25),ms2(26),ms2(27),ms2(28),ms2(29),
     &ms2(30),ms2(31),ms2(32),ms2(33),ms2(34),ms2(35),ms2(36),ms2(37),
     &ms2(38),ms2(39),ms2(40),ms2(41),ms2(42),ms2(43),ms2(44),ms2(45),
     &ms2(46),ms2(47),ms2(48),ms2(49),ms2(50))
c
      do k=1,kp
          if (mms1.eq.ms(k)) then
            mack=k
            go to 1000
          end if
 1000 enddo
      do k=1,kp
          if (mms2.eq.ms2(k)) then
            mrmsk=k
            go to 2000
          end if
        enddo
 2000 continue
c
      return
      end
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ocn_fst(obs,prd,ltime,kk)
      dimension obs(ltime),prd(ltime)
C== prediction with OCN
C== test different K(the length of period of avg)
      kt=0
      do it=kk+1,ltime 
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+obs(k)/float(kk)
         end do
         prd(kt+kk)=avg
      enddo
      do k=1,kk
      prd(k)=999.0
      enddo
c
      return
      end
c
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine opt_slp_k(ts1,ack,rmsk,mack,mrmsk,ltime,kp)
      dimension ts1(ltime)
      dimension ack(kp),rmsk(kp)
      dimension obs(ltime),prd(ltime)
      dimension wk(kp)
      real ms(kp),ms2(kp)
      real mms1,mms2
C== prediction with OCN
C== test different K(the length of period of avg)
      do kk=2,kp  !loop over K
      do it=kp+1,ltime 
      mt=0
      do kt=it-kk,it-1
      mt=mt+1
        wk(mt)=ts1(kt)
      enddo
      call slope_ext(wk,kp,kk,fcst)
         prd(it)=fcst
         obs(it)=ts1(it)
      end do
C== ac calculation for data
      call acc(obs,prd,ltime,kp,ack(kk))
      call rms(obs,prd,ltime,kp,rmsk(kk))
c     write(6,*) 'ac=',score

      ENDDO   !loop over kk

C===  select optimal K
        do k=2,kp
        ms(k)=ack(k)
        ms2(k)=rmsk(k)
        enddo
        mms1=AMAX1(ms(2),ms(3),ms(4),ms(5),ms(6),ms(7),
     &ms(8),ms(9),ms(10),ms(11),ms(12),ms(13),ms(14),ms(15),ms(16),
     &ms(17),ms(18),ms(19),ms(20),ms(21),ms(22),ms(23),ms(24),ms(25),
     &ms(26),ms(27),ms(28),ms(29),ms(30),ms(31),ms(32),ms(33),ms(34),
     &ms(35),ms(36),ms(37),ms(38),ms(39),ms(40),ms(41),ms(42),ms(43),
     &ms(44),ms(45),ms(46),ms(47),ms(48),ms(49),ms(50))
        mms2=AMIN1(ms2(2),ms2(3),ms2(4),ms2(5),
     &ms2(6),ms2(7),ms2(8),ms2(9),ms2(10),ms2(11),ms2(12),ms2(13),
     &ms2(14),ms2(15),ms2(16),ms2(17),ms2(18),ms2(19),ms2(20),ms2(21),
     &ms2(22),ms2(23),ms2(24),ms2(25),ms2(26),ms2(27),ms2(28),ms2(29),
     &ms2(30),ms2(31),ms2(32),ms2(33),ms2(34),ms2(35),ms2(36),ms2(37),
     &ms2(38),ms2(39),ms2(40),ms2(41),ms2(42),ms2(43),ms2(44),ms2(45),
     &ms2(46),ms2(47),ms2(48),ms2(49),ms2(50))
c
      do k=2,kp
          if (mms1.eq.ms(k)) then
            mack=k
            go to 1000
          end if
 1000 enddo
      do k=2,kp
          if (mms2.eq.ms2(k)) then
            mrmsk=k
            go to 2000
          end if
        enddo
 2000 continue
      ack(1)=999.0
      rmsk(1)=999.0
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine slp_fst(obs,prd,ltime,kp)
      dimension obs(ltime),prd(ltime)
      dimension wk(kp)
c
      do it=kp+1,ltime 
      mt=0
      do kt=it-kp,it-1
      mt=mt+1
        wk(mt)=obs(kt)
      enddo
      call slope_ext(wk,kp,kp,fcst)
         prd(it)=fcst
      enddo
      do k=1,kp
      prd(k)=999.0
      enddo
c
      return
      end
c
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to calculate slope and do extended forecast
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine slope_ext(y,n,m,p)
      real y(n)
      real lxx, lxy
c
      xb=0
      yb=0
      do i=1,m
        xb=xb+float(i)/float(m)
        yb=yb+y(i)/float(m)
      enddo
c
      lxx=0.
      lxy=0.
      do i=1,m
      lxx=lxx+(i-xb)*(i-xb)
      lxy=lxy+(i-xb)*(y(i)-yb)
      enddo
      b=lxy/lxx
      a=yb-b*xb
      p=a+b*(m+1)
c
      return
      end

      FUNCTION ran1(idum)
      INTEGER idum,IA,IM,IQ,IR,NTAB,NDIV
      REAL ran1,AM,EPS,RNMX
      PARAMETER (IA=16807,IM=2147483647,AM=1./IM,IQ=127773,IR=2836,
     *NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
      INTEGER j,k,iv(NTAB),iy
      SAVE iv,iy
      DATA iv /NTAB*0/, iy /0/
      if (idum.le.0.or.iy.eq.0) then
        idum=max(-idum,1)
        do 11 j=NTAB+8,1,-1
          k=idum/IQ
          idum=IA*(idum-k*IQ)-IR*k
          if (idum.lt.0) idum=idum+IM
          if (j.le.NTAB) iv(j)=idum
  11    continue
        iy=iv(1)
      endif
      k=idum/IQ
      idum=IA*(idum-k*IQ)-IR*k
      if (idum.lt.0) idum=idum+IM
      j=1+iy/NDIV
      iy=iv(j)
      iv(j)=idum
      ran1=min(AM*iy,RNMX)
      return
      END

