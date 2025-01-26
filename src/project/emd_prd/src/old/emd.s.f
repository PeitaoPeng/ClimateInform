C*****************************************************************
      SUBROUTINE EMD_IMF(ximf,rem,spmax,spmin,yimf,theta,omega,ave)
#include "parm.h"
C*****************************************************************
C  This is a program to culaculate Intrinsic Mode Functions (IMF)
C  and their Hilbert Transform. The reference for the IMF is seen
C  in Huang et al., Proc. R. Soc. Lond. A(1998) V454, 903-995.
C*****************************************************************
c  The parameter LXY is the length of a original time series.
c  LEX is the length of the extended time series. LEX=3*LXY-2.
c  The LEX is defined for the series that associated with the
c  extended series.
c
c     parameter(LXY=1584,LEX=3*LXY)
c
      dimension tavegl(LXY)   ! read-in original time series
      dimension ximf(LEX)     ! The IMF for the extended 
      dimension spmax(LEX)    ! upper envelope, cubic spline
      dimension spmin(LEX)    ! lower envelope, cubic spline
      dimension ave(LEX)    ! the average of spmax and spmin
      dimension remp(LEX)   ! the input data to obtain IMF
      dimension rem(LEX)    ! (remp-ximf) the remainder
c
      dimension yimf(LXY)   ! the imagine part of IMF
      dimension theta(LXY)  ! atan(yimf/ximf)
      dimension omega(LXY)  ! d(theta)/dt
c
      dimension ttmp1(LEX), ttmp2(LEX)
      dimension temp(12),tmp2(6)
      integer nmax, nmin
c
      PI=3.1415927
c
c-------------------------------------------------------------
c
      call dampend(ximf,LEX)
c
c  leave a copy of the input data before IMF is calculated
      do i=1,LEX
        remp(i)=ximf(i)
      enddo
c=============================================================
c
c
c-------------------------------------------------------------
c  Find the maxima and minima for the envelopes, calculate the
C  IMF
      DO i=1,LEX           !initialize ttmp1 for calculate SD
          ttmp2(i)=ximf(i)
      ENDDO
c
      nmc2=10  !assign a anay number to initialize the nmc2
      neq=0    !assign a anay number to initialize the nmc2
      DO II=1,30
c
        call min_max(LEX,ximf,spmax,spmin,nmax,nmin)     
c       write(6,*) 'spmax',spmax
c
c  obtain the cubic spline envelope
c
        call splint(spmax,LEX,nmax)
        call splint(spmin,LEX,nmin)
c       write(6,*) 'spmin',spmin
  
        do i=1,LEX
          ave(i)=(spmax(i)+spmin(i))/2.0
          ximf(i)=ximf(i)-ave(i)
        enddo
c
      do i=1,LEX    !pass data from h(k) to h(k-1) and feed h(k)
        ttmp1(i)=ttmp2(i)
        ttmp2(i)=ximf(i)
      enddo
      nmc1=nmc2
      nmc2=nmax
      if(nmc1.eq.nmc2) neq=neq+1
c     if(neq.eq.5) go to 888
c
c== calculate SD
c
      df=0
      dn=0
      do i=1,LEX
        df=df+(ttmp1(i)-ttmp2(i))*(ttmp1(i)-ttmp2(i))
        dn=dn+ttmp1(i)*ttmp1(i)
      enddo
      sd=df/dn
      write(6,*) 'SD=',sd
      if(sd.lt.sd_cri) go to 888   !sd_cri(ao)=0.001; sd_cri(pna)=0.0001; sd_cri(nao)=0.0005

      ENDDO
  888 continue
      write(6,*) 'II=',II,' nmax=',nmax,' neq=',neq
c================================================================

c
c---------------------------------------------------------------
c  calculate the remainder
      do i=1,LEX
        rem(i)=remp(i)-ximf(i)
      enddo

      call hilbert(ximf,LEX,yimf,LXY)
c     call hilbert2(ximf,LEX,yimf,LXY)  
c================================================================
c
c
c-----------------------------------------------------------------
c  calculate the phase angle and frequency
c
      do i=2,LXY-1
        dximf=(ximf(i+LXY+1)-ximf(i+LXY-1))/1.047
        dyimf=(yimf(i+1)-yimf(i-1))/1.047
        U2=ximf(i+LXY)*ximf(i+LXY)+yimf(i)*yimf(i)
        omega(i)=(ximf(i+LXY)*dyimf-yimf(i)*dximf)/U2
      enddo
      omega(1)=omega(2)
      omega(LXY)=omega(LXY-1)
c     call smooth(omega,LXY,101)
c================================================================
      return
      end


C*******************  end extension  *******************************
c
      subroutine end_ext(tavegl,ximf)
#include "parm.h"
c
c  Read in the original time series. In this case it is
c  tavegl.dat, the normalized Southern Oscillation Index. This
c  set of data is used to calculate mode 1 of the SOI index.
c
c     parameter(LXY=1584,LEX=LXY*3)
      parameter(next=n_ext)
c
      dimension tavegl(LXY)      ! read-in original time series
      dimension ximf(LEX)     ! The IMF for the extended
      dimension temp(12)
      dimension mtmp(12)
      dimension data1(next)    ! the first next value of tavegl
      dimension data2(next)    ! the last next value of tavegl
      real rightRef           ! the right reference value
      real leftRef            ! the left reference value
      real tmp, a, b
c
c  To reduce the effect of the end points to IMF, we design a
c  technology that will keep the property of the time series:
c  antisymmetrically extends the time series to the rhs and
c  lhs about the rightRef and leftRef, respectively. rightRef
c  is the right end value of the regression line of the last
c  200 data of tavegl and leftRef is the left end value of the
c  regression line of the first 200 data
c
c
      do i = 1, next
        data1(i) = tavegl(i)
        data2(i) = tavegl(LXY-next+i)
      enddo

c     call regression(200, data1, a, b, leftRef, tmp)
c     call regression(200, data2, a, b, tmp, rightRef)
      call cubic_fit(next, data1, leftRef, tmp)
      call cubic_fit(next, data2, tmp, rightRef)
      write(6,*) 'left=',leftRef
      write(6,*) 'right=',rightRef

      do i=1,LXY
        ximf(i)= -tavegl(LXY-i+1) + 2.0*leftRef
      enddo
      do i=1,LXY
        ximf(i+LXY)=tavegl(i)
      enddo
      do i=1,LXY
        ximf(i+LXY*2)= 2.0*rightRef - tavegl(LXY-i+1)
      enddo

c     write(77,15) (ximf(i),i=1,LEX)
 15   format(f10.4)


      return
      end

C**************** regression ***********************************
c
      subroutine regression(nsize, data, a, b, start, end)
c
c  This is a linear regresion subroutine to obtain y=a*x+b to
c  represent data. x is equally distributed from 1 to nsize
c  nsize :    data size
c  a     :    slope
c  start:     the leftend value of the regression line
c  end:       the rightend value of the regression line
c
      real data(nsize)

      sigamX = 0
      sigmaY = 0
      sigmaX2 = 0
      sigmaXY = 0

      do i = 1, nsize
        sigmaX = sigmaX + float(i)
        sigmaY = sigmaY + data(i)
        sigmaX2 = sigmaX2 + float(i)*float(i)
        sigmaXY = sigmaXY + float(i)*data(i)
      enddo

      ybar = sigmaY / float(nsize)
      xbar = sigmaX / float(nsize)

      temp1 = sigmaX2 - (sigmaX * sigmaX)/float(nsize)
      temp2 = sigmaXY - (sigmaX * sigmaY)/float(nsize)

      a = temp2 / temp1
      b = ybar - a*xbar

      start = b + a*1.0
      end = b + a*float(nsize)

      return
      end

C***************************************************************
C***************************************************************

      SUBROUTINE CUBIC_FIT(ndata,Y,start,end)
      PARAMETER(NMAX=1000,MMAX=50,TOL=1.E-5)
      parameter(ma=4, np=4, mp=200)
C
      DIMENSION X(NDATA),Y(NDATA),SIG(NDATA),A(MA),V(NP,NP),
     *    U(MP,NP),W(NP),B(NMAX),AFUNC(MMAX)

      dimension yf(ndata)

C Defining necessary data
      do i=1,ndata
        x(i)=float(i)*0.083333333
        sig(i)=1.0
      enddo

      DO 12 I=1,NDATA
        CALL FUNCS(X(I),AFUNC,MA)
        TMP=1./SIG(I)
        DO 11 J=1,MA
          U(I,J)=AFUNC(J)*TMP
11      CONTINUE
        B(I)=Y(I)*TMP
12    CONTINUE

      CALL SVDCMP(U,NDATA,MA,MP,NP,W,V)

      WMAX=0.
      DO 13 J=1,MA
        IF(W(J).GT.WMAX)WMAX=W(J)
13    CONTINUE
      THRESH=TOL*WMAX
      DO 14 J=1,MA
        IF(W(J).LT.THRESH)W(J)=0.
14    CONTINUE
      CALL SVBKSB(U,W,V,NDATA,MA,MP,NP,B,A)
      CHISQ=0.
      DO 16 I=1,NDATA
        CALL FUNCS(X(I),AFUNC,MA)
        SUM=0.
        DO 15 J=1,MA
          SUM=SUM+A(J)*AFUNC(J)
15      CONTINUE
        CHISQ=CHISQ+((Y(I)-SUM)/SIG(I))**2
        yf(I)= SUM
16    CONTINUE

      start = yf(1)
      leftEnd=yf(1)
      end = yf(ndata)

      RETURN
      END

C***************************************************************
C***************************************************************

      subroutine funcs(xx,afunc,ma)
      PARAMETER(NMAX=1000,MMAX=50,TOL=1.E-5)
      real afunc(mmax)
      do i = 1, ma
        afunc(i)=xx**(ma-i)
      enddo
      return
      end

C ***********************************************************
C ***********************************************************

      SUBROUTINE SVBKSB(U,W,V,M,N,MP,NP,B,X)
      PARAMETER (NMAX=100)
      DIMENSION U(MP,NP),W(NP),V(NP,NP),B(MP),X(NP),TMP(NMAX)
      DO 12 J=1,N
        S=0.
        IF(W(J).NE.0.)THEN
          DO 11 I=1,M
            S=S+U(I,J)*B(I)
11        CONTINUE
          S=S/W(J)
        ENDIF
        TMP(J)=S
12    CONTINUE
      DO 14 J=1,N
        S=0.
        DO 13 JJ=1,N
          S=S+V(J,JJ)*TMP(JJ)
13      CONTINUE
        X(J)=S
14    CONTINUE
      RETURN
      END

C***************************************************************
C***************************************************************

      SUBROUTINE SVDCMP(A,M,N,MP,NP,W,V)
      PARAMETER (NMAX=100)
      DIMENSION A(MP,NP),W(NP),V(NP,NP),RV1(NMAX)
      G=0.0
      SCALE=0.0
      ANORM=0.0
      DO 25 I=1,N
        L=I+1
        RV1(I)=SCALE*G
        G=0.0
        S=0.0
        SCALE=0.0
        IF (I.LE.M) THEN
          DO 11 K=I,M
            SCALE=SCALE+ABS(A(K,I))
11        CONTINUE
          IF (SCALE.NE.0.0) THEN
            DO 12 K=I,M
              A(K,I)=A(K,I)/SCALE
              S=S+A(K,I)*A(K,I)
12          CONTINUE
            F=A(I,I)
            G=-SIGN(SQRT(S),F)
            H=F*G-S
            A(I,I)=F-G
            IF (I.NE.N) THEN
              DO 15 J=L,N
                S=0.0
                DO 13 K=I,M
                  S=S+A(K,I)*A(K,J)
13              CONTINUE
                F=S/H
                DO 14 K=I,M
                  A(K,J)=A(K,J)+F*A(K,I)
14              CONTINUE
15            CONTINUE
            ENDIF
            DO 16 K= I,M
              A(K,I)=SCALE*A(K,I)
16          CONTINUE
          ENDIF
        ENDIF
        W(I)=SCALE *G
        G=0.0
        S=0.0
        SCALE=0.0
        IF ((I.LE.M).AND.(I.NE.N)) THEN
          DO 17 K=L,N
            SCALE=SCALE+ABS(A(I,K))
17        CONTINUE
          IF (SCALE.NE.0.0) THEN
            DO 18 K=L,N
              A(I,K)=A(I,K)/SCALE
              S=S+A(I,K)*A(I,K)
18          CONTINUE
            F=A(I,L)
            G=-SIGN(SQRT(S),F)
            H=F*G-S
            A(I,L)=F-G
            DO 19 K=L,N
              RV1(K)=A(I,K)/H
19          CONTINUE
            IF (I.NE.M) THEN
              DO 23 J=L,M
                S=0.0
                DO 21 K=L,N
                  S=S+A(J,K)*A(I,K)
21              CONTINUE
                DO 22 K=L,N
                  A(J,K)=A(J,K)+S*RV1(K)
22              CONTINUE
23            CONTINUE
            ENDIF
            DO 24 K=L,N
              A(I,K)=SCALE*A(I,K)
24          CONTINUE
          ENDIF
        ENDIF
        ANORM=MAX(ANORM,(ABS(W(I))+ABS(RV1(I))))
25    CONTINUE
      DO 32 I=N,1,-1
        IF (I.LT.N) THEN
          IF (G.NE.0.0) THEN
            DO 26 J=L,N
              V(J,I)=(A(I,J)/A(I,L))/G
26          CONTINUE
            DO 29 J=L,N
              S=0.0
              DO 27 K=L,N
                S=S+A(I,K)*V(K,J)
27            CONTINUE
              DO 28 K=L,N
                V(K,J)=V(K,J)+S*V(K,I)
28            CONTINUE
29          CONTINUE
          ENDIF
          DO 31 J=L,N
            V(I,J)=0.0
            V(J,I)=0.0
31        CONTINUE
        ENDIF
        V(I,I)=1.0
        G=RV1(I)
        L=I
32    CONTINUE
      DO 39 I=N,1,-1
        L=I+1
        G=W(I)
        IF (I.LT.N) THEN
          DO 33 J=L,N
            A(I,J)=0.0
33        CONTINUE
        ENDIF
        IF (G.NE.0.0) THEN
          G=1.0/G
          IF (I.NE.N) THEN
            DO 36 J=L,N
              S=0.0
              DO 34 K=L,M
                S=S+A(K,I)*A(K,J)
34            CONTINUE
              F=(S/A(I,I))*G
              DO 35 K=I,M
                A(K,J)=A(K,J)+F*A(K,I)
35            CONTINUE
36          CONTINUE
          ENDIF
          DO 37 J=I,M
            A(J,I)=A(J,I)*G
37        CONTINUE
        ELSE
          DO 38 J= I,M
            A(J,I)=0.0
38        CONTINUE
        ENDIF
        A(I,I)=A(I,I)+1.0
39    CONTINUE
      DO 49 K=N,1,-1
        DO 48 ITS=1,30
          DO 41 L=K,1,-1
            NM=L-1
            IF ((ABS(RV1(L))+ANORM).EQ.ANORM)  GO TO 2
            IF ((ABS(W(NM))+ANORM).EQ.ANORM)  GO TO 1
41        CONTINUE
1         C=0.0
          S=1.0
          DO 43 I=L,K
            F=S*RV1(I)
            IF ((ABS(F)+ANORM).NE.ANORM) THEN
              G=W(I)
              H=SQRT(F*F+G*G)
              W(I)=H
              H=1.0/H
              C= (G*H)
              S=-(F*H)
              DO 42 J=1,M
                Y=A(J,NM)
                Z=A(J,I)
                A(J,NM)=(Y*C)+(Z*S)
                A(J,I)=-(Y*S)+(Z*C)
42            CONTINUE
            ENDIF
43        CONTINUE
2         Z=W(K)
          IF (L.EQ.K) THEN
            IF (Z.LT.0.0) THEN
              W(K)=-Z
              DO 44 J=1,N
                V(J,K)=-V(J,K)
44            CONTINUE
            ENDIF
            GO TO 3
          ENDIF
          IF (ITS.EQ.30) PAUSE 'No convergence in 30 iterations'
          X=W(L)
          NM=K-1
          Y=W(NM)
          G=RV1(NM)
          H=RV1(K)
          F=((Y-Z)*(Y+Z)+(G-H)*(G+H))/(2.0*H*Y)
          G=SQRT(F*F+1.0)
          F=((X-Z)*(X+Z)+H*((Y/(F+SIGN(G,F)))-H))/X
          C=1.0
          S=1.0
          DO 47 J=L,NM
            I=J+1
            G=RV1(I)
            Y=W(I)
            H=S*G
            G=C*G
            Z=SQRT(F*F+H*H)
            RV1(J)=Z
            C=F/Z
            S=H/Z
            F= (X*C)+(G*S)
            G=-(X*S)+(G*C)
            H=Y*S
            Y=Y*C
            DO 45 NM=1,N
              X=V(NM,J)
              Z=V(NM,I)
              V(NM,J)= (X*C)+(Z*S)
              V(NM,I)=-(X*S)+(Z*C)
45          CONTINUE
            Z=SQRT(F*F+H*H)
            W(J)=Z
            IF (Z.NE.0.0) THEN
              Z=1.0/Z
              C=F*Z
              S=H*Z
            ENDIF
            F= (C*G)+(S*Y)
            X=-(S*G)+(C*Y)
            DO 46 NM=1,M
              Y=A(NM,J)
              Z=A(NM,I)
              A(NM,J)= (Y*C)+(Z*S)
              A(NM,I)=-(Y*S)+(Z*C)
46          CONTINUE
47        CONTINUE
          RV1(L)=0.0
          RV1(K)=F
          W(K)=X
48      CONTINUE
3       CONTINUE
49    CONTINUE
      RETURN
      END

C***************************************************************
C********************* dampend *********************************
C
      subroutine dampend(ximf,N)
#include "parm.h"
c
c  The calculation of a cubic spline usually assumes that
c  the time series have zero derivatives at the both ends.
c  This is a routine to gradually damp the time series toward
c  the two ends. The values at the two ends are calucalted
c  averages from the starting 200 values and the ending 200 
c  values. The first 1000 and the last 1000 values are gradually
c  damped toward the ends values.
c
      real ximf(N)
c
      NEND=50
      NDAMP=n_ext
      afront=0
      aend=0

      do i=1,NEND
        afront=afront+ximf(i)
      enddo
c
      KK=N-NEND+1
      do i=KK,N
        aend=aend+ximf(i)
      enddo
c
      afront=afront/float(NEND)
      aend=aend/float(NEND)
c
      do i=1,NDAMP
        ximf(i)=(ximf(i)-afront)*float(i)/float(NDAMP)
        ximf(i)=ximf(i)+afront
      enddo

      is = N - NDAMP + 1
      do i=is,N
        ximf(i)=(ximf(i)-aend)*float(N-i+1)/float(NDAMP)
        ximf(i)=ximf(i)+aend
      enddo

      return
      end

C******************************************************************
C****************** min_max ***************************************
C
      subroutine min_max(LEX,ximf,spmax,spmin,nmax,nmin)
C
c  This is a routine to define maxima and minima from series ximf.
c  All the extrema are defined as the corresponding values of 
c  ximf in spmax and spmin. All non-extrema values in spmax and
c  spmin are defined as 1.0e31.
c
      real ximf(LEX),spmax(LEX),spmin(LEX)
      integer nmax, nmin
c
      nmax=0
      nmin=0

      spmax(1)=ximf(1)
      spmax(LEX)=ximf(LEX)
      spmin(1)=spmax(1)
      spmin(LEX)=spmax(LEX)

      nmax=2
      nmin=2

      do i=2,LEX-1
        if(ximf(i).ge.ximf(i-1).and.ximf(i).ge.ximf(i+1)) then
          spmax(i)=ximf(i)
          nmax=nmax+1
        else
          spmax(i)=1.0e31
        endif
        if(ximf(i).le.ximf(i-1).and.ximf(i).le.ximf(i+1)) then
          spmin(i)=ximf(i)
          nmin=nmin+1
        else
          spmin(i)=1.0e31
        endif
      enddo

      return
      end


C******************************************************************
C********************* splint *************************************
c
      SUBROUTINE SPLINT(YA,LEX,N)
c  This is a program of cubic spline interpolation. The imported
c  series, YA have a length of LEX, with N numbers of value
c  not equal to 1.0E31. The program is to use the cubic line to
c  interpolate the values for the points other thatn these N
c  numbers.
c
      DIMENSION YA(LEX)
      DIMENSION LX(N),Y(N),Y2(N)
c
c  The following code is to realocate the series of X(N), Y(N)
c
      IF(N.EQ.0) RETURN

      J=1
      DO I=1, LEX
        IF( YA(I).LT.1.0E30 ) THEN
          LX(J)=I
          Y(J)=YA(I)
          J=J+1
        ENDIF
      ENDDO
c
c  The following code is used to calculate the second order 
c  derivative, set the derivatives at both ends to be 0's.
c
      YP1=0.0
      YPN=0.0
      CALL SPLINE(LX,Y,N,YP1,YPN,Y2)
c
c  calculate the cubic spline
c
      DO I=2,N
        KLO=LX(I-1)
        KHI=LX(I)
        H=FLOAT(KHI-KLO)
        DO J=KLO+1,KHI-1
          A=FLOAT(KHI-J)/H
          B=FLOAT(J-KLO)/H
          YA(J)=A*Y(I-1)+B*Y(I)+
     |         ((A*A*A-A)*Y2(I-1)+(B*B*B-B)*Y2(I))*(H*H)/6.0
        ENDDO
      ENDDO

      RETURN
      END


C*****************************************************************
C******************** spline *************************************
c
      SUBROUTINE SPLINE(LX,Y,N,YP1,YPN,Y2)
      PARAMETER (NMAX=1000)
      DIMENSION X(N),Y(N),Y2(N),U(NMAX), LX(N)

      DO i=1,N
        X(I)=FLOAT(LX(I))
      ENDDO

      IF (YP1.GT..99E30) THEN
        Y2(1)=0.
        U(1)=0.
      ELSE
        Y2(1)=-0.5
        U(1)=(3./(X(2)-X(1)))*((Y(2)-Y(1))/(X(2)-X(1))-YP1)
      ENDIF
      DO 11 I=2,N-1
        SIG=(X(I)-X(I-1))/(X(I+1)-X(I-1))
        P=SIG*Y2(I-1)+2.
        Y2(I)=(SIG-1.)/P
        U(I)=(6.*((Y(I+1)-Y(I))/(X(I+1)-X(I))-(Y(I)-Y(I-1))
     *      /(X(I)-X(I-1)))/(X(I+1)-X(I-1))-SIG*U(I-1))/P
11    CONTINUE
      IF (YPN.GT..99E30) THEN
        QN=0.
        UN=0.
      ELSE
        QN=0.5
        UN=(3./(X(N)-X(N-1)))*(YPN-(Y(N)-Y(N-1))/(X(N)-X(N-1)))
      ENDIF
      Y2(N)=(UN-QN*U(N-1))/(QN*Y2(N-1)+1.)
      DO 12 K=N-1,1,-1
        Y2(K)=Y2(K)*Y2(K+1)+U(K)
12    CONTINUE
      RETURN
      END


C**************************************************************
C*********************** hilbert2 *****************************
C
      SUBROUTINE HILBERT2(X,N,Y,M)
c  Calculate the imagine part of Hilbert Transform. The method
c  is base on Fourier Transform. 
c
      DIMENSION X(N), Y(M), Z(N)
      DIMENSION A(N), B(N)            ! coefficient
c
      PI=3.141592654
c
      XL=FLOAT(N-1)     ! length of domain
      CC=2.0/XL         !  2/(xr-xl)
c
c  calculate the coefficients
      DO I=1,N
        TMP1=0
        TMP2=0
        FI=FLOAT(I-1)
        DO J=1,N
          XPOS=FLOAT(J-1)
          ANGLE=2.0*FI*PI*(XPOS-XL)/XL
          TMP1=TMP1+COS(ANGLE)*X(J)
          TMP2=TMP2+SIN(ANGLE)*X(J)
        ENDDO
        A(I)=TMP1*CC
        B(I)=TMP2*CC
      ENDDO
        
c  Switch coefficient to obtain Hilbert transform
      DO I=1,N
        TEMP=0
        XPOS=FLOAT(I-1)
        DO J=1,N/2
          FJ=FLOAT(J-1)
          ANGLE=2.0*FJ*PI*(XPOS-XL)/XL
          TEMP=TEMP-B(J)*COS(ANGLE)+SIN(ANGLE)*A(J)
        ENDDO
        Z(I)=TEMP
      ENDDO

c  assign data to Y
      DO I=1,M
        Y(I)=Z(I+M-1)
      ENDDO
 
      RETURN
      END

C**************************************************************
C********************** hilbert *******************************
C
      SUBROUTINE HILBERT(X,N,Y,M)
c  Calculate the imagine part of Hilbert Transform. The method
c  is base on Oppenheimer and Schafer (1975).
c  INPUT: X(N)
c  OUTPUT: Y(M)
C  HERE N=3M-2
c
      DIMENSION X(N), Y(M)
      REAL V

      PI = 3.1415926

      DO I=1,M
        TMP = 0.0
C       DO J=1,2*M-1
        DO J=1,N
          L=J-M-1
          CALL HL(L,V)
C         TMP=TMP+V*X(I+M-1-L)
          TMP=TMP+V*X(I+M-L)
        ENDDO
        Y(I)=TMP
      ENDDO
   
      RETURN
      END


C**************************************************************

      SUBROUTINE HL(L, V)
c  a function used for Hilbert Transform. 
c
      PI=3.1415926

      IF(L.EQ.0) THEN
        V=0
      ELSE
        FL=FLOAT(L)
        V=2.0*SIN(PI*FL/2.0)*SIN(PI*FL/2.0)/(PI*FL)
      END IF

      RETURN
      END

     
C***************************************************************
      SUBROUTINE SMOOTH(X,LXY,N)
c
c  a subroutine that smooth X using N point running mean.
c  N should be a odds number. LXY is the length of X
c     
      DIMENSION Y(LXY), X(LXY)
c
      N2=N/2
      NS=N2+1
      NE=LXY-N2

      AVE=0
      DO I=1,LXY
        AVE=AVE+X(I)
      ENDDO
      AVE=AVE/FLOAT(LXY)

      DO I=1,LXY
        IF(X(I).LT.0.0) X(I)=AVE
      ENDDO
      
      DO I=NS,NE
        TEMP=0
        DO J=1,N
          TEMP=TEMP+X(I-NS+J)
        ENDDO
        Y(I)=TEMP/FLOAT(N)
      ENDDO

      DO I=1,N2
        TEMP=0
        NL=2*I-1
        DO J=1,NL
          TEMP=TEMP+X(J)
        ENDDO
        Y(I)=TEMP/FLOAT(I)
      ENDDO

      DO I=NE+1,LXY
        TEMP=0
        NL=(LXY-I)*2+1
        NP=LXY-NL+1
        DO J=NP,LXY
          TEMP=TEMP+X(J)
        ENDDO
        Y(I)=TEMP/FLOAT(NL)
      ENDDO

      RETURN
      END
          
C******************* END OF  PROGRAM *************************

      
