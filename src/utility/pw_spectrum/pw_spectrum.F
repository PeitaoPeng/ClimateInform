      PROGRAM POWER
#include "parm.h"
c
c  Read the EOF coeff for longpjan and compute spectrum.
c
c     PARAMETER (NDYS=21000)
c     PARAMETER (LAG=500,LLAG=LAG+1,neofs=4)
      REAL coeff(NDYS,neofs), x(NDYS), AR(LLAG), AI(LLAG)
      REAL ucoef(NDYS)
      REAL perd(LAG),pws(LAG,neofs)
c     DATA DELTAT/1./
      open(unit=10,form='unformated',access='direct',recl=NDYS)
      open(unit=60,form='unformated',access='direct',recl=ntopper-1)
      open(unit=70,form='formated')
c
      lllag=llag
c 
      pi=3.14159
      do k=1,neofs
	  read(10) ucoef
        do n=1,NDYS
          coeff(n,k)=ucoef(n)
        enddo
c       write(6,*) coeff
      enddo
      do k=1,neofs
        iu=70
        do n=1,ndys
          x(n)=coeff(n,k)
c         x(n)=sin(2*pi*n/6)
        enddo
        CALL CROSS(x,x,LAG,DELTAT,ndys,AR,AI,lllag)
c
c.......write out the FREQUENCY = (NLAG-1)/(2*TOTAL_LAGS)
c.......(PERIOD = 1/FREQUENCY)
c
        kp=0
        do ll=2,llag
          xl=float(ll)
          freq=(xl-1.)/(2.*float(lag))
          period=1./freq
          kp=kp+1
          perd(kp)=period
          pws(kp,k)=ar(ll)
          if(period.gt.ntopper.or.period.lt.nbotper) goto 999
c         write(iu,'(f8.3,1x,e14.6)') freq,ar(ll)
 999      continue
        enddo
      enddo
c
      do i=1,LAG
      write(6,888) perd(lag+1-i),pws(lag+1-i,1),
     &pws(lag+1-i,2),pws(lag+1-i,3)
      enddo
 888  format(1x,f8.3,1x,f8.3,1x,f8.3,1x,f8.3)
c
      STOP
      END
C
      SUBROUTINE CROSS (X,Y,LAG,DELTAT,NPOINT,AR,AI,LLAG)
#include "parm2.h"
C     PARAMETER (MAXLAG=501)
C
C  NOTE RESTRICTION: MAXLAG >= (LAG+1)
C
C  USES CROSS-CORRELATION METHOD ADAPTED FROM BMD-02T PROGRAM
C  X AND Y ARE THE SERIES TO BE CROSSED
C  LAG IS THE NUMBER OF LAGS
C  DELTAT IS THE SPACING BETWEEN DATA PTS IN INPUT SERIES
C  NPOINT IS THE NUMBER OF DATA POINTS IN THE INPUT SERIES
C  A(AR,AI) IS THE COMPLEX CROSS SPECTRUM (A=1,LAG+1)
C  IF X=Y, REAL(A) IS THE POWER SPECTRUM
C  A(1) CORRESPONDS TO ZERO FREQUENCY
C  A(N) CORRESPONDS TO FREQUENCY  (N-1)/(2*LAG*DELTAT)
C  A(LAG+1) CORRESPONDS TO FREQUENCY  1/(2*DELTAT)
C
C
      DIMENSION X(npoint),Y(npoint)
      DIMENSION RXY(MAXLAG), RYX(MAXLAG), ADDXY(MAXLAG), SUBXY(MAXLAG)
      DIMENSION CXY(MAXLAG), QXY(MAXLAG),AR(llag), AI(llag)
      EQUIVALENCE (RXY,CXY),(RYX,QXY)
c
      if(llag.gt.maxlag) then
        print *,'ERROR in CROSS. MAXLAG must be >= LLAG'
        print *,'MAXLAG=',MAXLAG,'  LLAG=',LLAG
        stop
      endif
c
      DO LL=1,LLAG
        AR(LL)=0.
        AI(LL)=0.
      ENDDO
c
      Q=3.14159/FLOAT(LAG)
      CONST=2.*DELTAT/3.14159
c
      SX=0.
      SY=0.
      DO 200 I=1,NPOINT
      SX=SX+X(I)
  200 SY=SY+Y(I)
      SX=SX/FLOAT(NPOINT)
      SY=SY/FLOAT(NPOINT)
      DO 201 I=1,NPOINT
      W=Y(I)
      X(I)=X(I)-SX
  201 Y(I)=W-SY
c
      DO 501 I=1,LLAG
      SXY=0.
      SYX=0.
      M=I-1
      L=NPOINT-M
      FL=L
      DO 502 J=1,L
      K=M+J
      SXY=SXY+X(J)*Y(K)
  502 SYX=SYX+X(K)*Y(J)
      RXY(I)=SXY/FL
  501 RYX(I)=SYX/FL
c
      DO 15 JP=1,LLAG
      ADDXY(JP)=RXY(JP)+RYX(JP)
   15 SUBXY(JP)=RXY(JP)-RYX(JP)
c
      ADDXY(1)=0.5*ADDXY(1)
      ADDXY(LLAG)=0.5*ADDXY(LLAG)
      SUBXY(1)=0.5*SUBXY(1)
      SUBXY(LLAG)=0.5*SUBXY(LLAG)
      S1=-Q
      DO 17 IH=1,LLAG
      CXY(IH)=0.0
      QXY(IH)=0.0
      S1=S1+Q
      S=-S1
      DO 17 JP=1,LLAG
      S=S+S1
      CXY(IH)=CXY(IH)+COS(S)*ADDXY(JP)
   17 QXY(IH)=QXY(IH)+SIN(S)*SUBXY(JP)
c
      DO 16 I=1,LLAG
      CXY(I)=CXY(I)*CONST*.5
   16 QXY(I)=QXY(I)*CONST*.5
c
      AR (1) =.54*CXY(1)+.46*CXY(2)
      AI (1) =.54*QXY(1)+.46*QXY(2)
c     A(1)=CMPLX(AR,AI)
      AR(LLAG)  =.54*CXY(LLAG)+.46*CXY(LLAG-1)
      AI(LLAG)  =.54*QXY(LLAG)+.46*QXY(LLAG-1)
c     A(LLAG)=CMPLX(AR,AI)
c
      KK=LLAG-1
      DO 18 J=2,KK
      AR (J) =.54*CXY(J)+.23*(CXY(J+1)+CXY(J-1))
      AI (J) =.54*QXY(J)+.23*(QXY(J+1)+QXY(J-1))
   18 CONTINUE
c  18 A(J)=CMPLX(AR,AI)
c
c.....comment this out 9/95 . why was this loop in here??
c     DO 202 I=1,NPOINT
c     W=Y(I)
c     X(I)=X(I)+SX
c202  Y(I)=W+SY
 
      RETURN
      END
