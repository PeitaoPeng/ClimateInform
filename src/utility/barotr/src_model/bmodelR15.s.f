CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC C
C     transfer data from spctral form to grid form and vice versa              C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE TRANSFORM(LTRANS,GRID,CSPEK)

C     THIS ROUTINE PERFORMS SPECTRAL OR INVERSE SPECTRAL TRANSFORM
C     ACCORDING TO WHETHER LTRANS IS +1 OR -1
C
C     IF LTRANS =  1 THEN TRANSFORM GRID     ---> SPECTRAL
C     IF LTRANS = -1 THEN TRANSFORM SPECTRAL ---> GRID
C

      PARAMETER(NW=15)
      PARAMETER(NLEG=NW+1,NLEGP=NW+2)
      PARAMETER(NM=NW)
      PARAMETER(NMP=NW+1)
      PARAMETER(NLONG=64)
      PARAMETER(NLATG=40)
C
      DIMENSION GRID(NLONG,NLATG)
      DIMENSION SPEK(2,NLEG,NMP)
      COMPLEX   CSPEK(NLEGP,NMP)
C
      IF(LTRANS.GT.0) THEN
      CALL TRNSFM15(GRID,SPEK)
C
        DO I=1,NLEG
        DO J=1,NMP
          CSPEK(I,J)=CMPLX(SPEK(1,I,J),SPEK(2,I,J))
        END DO
        END DO
C
      ELSE  
        DO I=1,NLEG
        DO J=1,NMP
          SPEK(1,I,J)=REAL(CSPEK(I,J))
          SPEK(2,I,J)=AIMAG(CSPEK(I,J))
        END DO
        END DO
      CALL EVLSCA(SPEK,GRID)
      END IF

      RETURN
      END
 
 
      SUBROUTINE EVLSCA(ARRS,ARRP)
      PARAMETER(NW=15)
      PARAMETER(NLEG=NW+1,NM=NW,NMP=NM+1)
      PARAMETER(NLATG=40,NLONG=64,NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      COMMON/POLY1/PLEG(NLEG,NMP,NLATG),DPLEG(NLEG,NMP,NLATG)
      COMMON/FFTAR1/TRIGS(IMAXT),IFAX(10)
      COMMON/FFTAR2/ARRAY(NLONGP,NLATG),WORK(NLONGP,NLATG)
      DIMENSION ARRS(2,NLEG,NMP),ARRP(NLONG,NLATG)
      IM1=2*NMP+1
      IM2=NLONGP
      DO 200 J=1,NLATG
      DO 120 IM=1,NMP
      DO 120 IC=1,2
      YSUM=0.0
      DO 100 N=1,NLEG
      YSUM=YSUM+ARRS(IC,N,IM)*PLEG(N,IM,J)
  100 CONTINUE
      ARRAY((IM-1)*2+IC,J)=YSUM
  120 CONTINUE
      DO 130 IM=IM1,IM2
      ARRAY(IM,J)=0.0
  130 CONTINUE
  200 CONTINUE
      INC=1
      ISIGN=+1
      JUMP=NLONGP
      LOT=NLATG
      CALL FFT991(ARRAY,WORK,TRIGS,IFAX,INC,JUMP,NLONG,LOT,ISIGN)
      DO 240 J=1,NLATG
      DO 240 I=1,NLONG
      ARRP(I,J)=ARRAY(I,J)
  240 CONTINUE
      RETURN
      END
 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C    gausian grid to spectral at R15 resolution
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE TRNSFM15(FIELDG,FLDSPC)
      PARAMETER(NW=15)
      PARAMETER(NLEG=NW+1)
      PARAMETER(NM=NW)
      PARAMETER(NMP=NW+1)
      PARAMETER(NLONG=64)
      PARAMETER(NLATG=40)
      PARAMETER(NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      PARAMETER(KHALF=(NLATG+1)/2)
      COMMON/GAUSS/RADG(NLATG),GWGT(NLATG)
      COMMON/POLY1/PLEG(NLEG,NMP,NLATG),DPLEG(NLEG,NMP,NLATG)
      COMMON/FFTAR1/TRIGS(IMAXT),IFAX(10)
      COMMON/FFTAR2/ARRAY(NLONGP,NLATG),WORK(NLONGP,NLATG)
      DIMENSION FIELDG(NLONG,NLATG)
      DIMENSION FLDSPC(2,NLEG,NMP)
      DO 20 IM=1,NMP
      DO 20 IN=1,NLEG
      DO 20 IC=1,2
      FLDSPC(IC,IN,IM)=0.0
   20 CONTINUE
      DO 60 JG=1,NLATG
      DO 40 IG=1,NLONG
      ARRAY(IG,JG)=FIELDG(IG,JG)
   40 CONTINUE
      ARRAY(NLONGP,JG)=0.0
   60 CONTINUE
      ISIGN=-1
      INC=1
      JUMP=NLONGP
      LOT=NLATG
      CALL FFT991(ARRAY,WORK,TRIGS,IFAX,INC,JUMP,NLONG,LOT,ISIGN)
      DO 200 JG=1,NLATG
      DO 180 IM=1,NMP
      DO 180 IN=1,NLEG
      FLDSPC(1,IN,IM)=FLDSPC(1,IN,IM)+ARRAY(2*IM-1,JG)*PLEG(IN,IM,JG)*
     1 GWGT(JG)
      FLDSPC(2,IN,IM)=FLDSPC(2,IN,IM)+ARRAY(2*IM  ,JG)*PLEG(IN,IM,JG)*
     1 GWGT(JG)
  180 CONTINUE
  200 CONTINUE
      RETURN
      END

 
      SUBROUTINE GLATS(KHALF,COLRAD,WGT,WGTCS,RCS2)
C***********************************************************************
C
C     GLATS : CALCULATES GAUSSIAN LATITUDES AND GAUSSIAN WEIGHTS
C             FOR USE IN GRID-SPECTRAL AND SPECTRAL-GRID TRANSFORMS.
C
C***********************************************************************
C
C     GLATS IS CALLED BY THE MAIN ROUTINE SMF.
C
C     GLATS CALLS THE FOLLOWING SUBROUTINE :  POLY
C
C***********************************************************************
C
C    ARGUMENT(DIMENSIONS)                       DESCRIPTION
C
C           KHALF                 INPUT : NUMBER OF GAUSSIAN LATITUDES
C                                         IN ONE HEMISPHERE. SET IN MAIN
C                                         ROUTINE "SMF".
C         COLRAD(KHALF)          OUTPUT : CO-LATITUDES FOR GAUSSIAN
C                                         LATITUDES IN ONE HEMISPHERE.
C          WGT(KHALF)            OUTPUT : GAUSSIAN WEIGHTS.
C         WGTCS(KHALF)           OUTPUT : GAUSSIAN WEIGHTS DIVIDED BY
C                                         COS(LATITUDE)**2.
C          RCS2(KHALF)           OUTPUT : 1.0/COS(LATITUDE)**2 AT
C                                         GAUSSIAN LATITUDES.
C
C***********************************************************************
C
C     GLATS DOES NOT REFER TO ANY COMMONS.
C
C***********************************************************************
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION COLRAD( KHALF ),WGT( KHALF ),WGTCS( KHALF )
      DIMENSION RCS2  ( KHALF )
      PRINT 101
 101  FORMAT ('0 I   COLAT   COLRAD     WGT', 12X, 'WGTCS',
     1 10X, 'ITER  RES')
      EPS=1.0D-12
      SI = 1.0D0
      K2=2*KHALF
      RK2=K2
      SCALE = 2.0/(RK2**2)
      K1=K2-1
      PI =DATAN(SI)* 4.0D0
      DRADZ = PI / 360.D0
      RAD = 0.0D0
      DO 1000 K=1,KHALF
      ITER=0
      DRAD=DRADZ
1     CALL POLY(K2,RAD,P2)
2     P1 =P2
      ITER=ITER+1
      RAD=RAD+DRAD
      CALL POLY(K2,RAD,P2)
      IF(SIGN(SI,P1).EQ.SIGN(SI,P2)) GO TO 2
      IF(DRAD.LT.EPS)GO TO 3
      RAD=RAD-DRAD
      DRAD = DRAD * 0.25D0
      GO TO 1
3     CONTINUE
      COLRAD(K)=RAD
      PHI = RAD * 180.0 / PI
      CALL POLY(K1,RAD,P1)
      X = COS(RAD)
      W = SCALE * (1.0D0 - X*X)/ (P1*P1)
      WGT(K) = W
      SN = SIN(RAD)
      W=W/(SN*SN)
      WGTCS(K) = W
      RC=1.0D0/(SN*SN)
      RCS2(K) = RC
      CALL POLY(K2,RAD,P1)
      PRINT 102,K,PHI,COLRAD(K),WGT(K),WGTCS(K),ITER,P1
 102  FORMAT(1H ,I2,2X,F6.2,2X,F10.7,2X,E13.7,2X,E13.7,2X,I4,2X,D13.7)
1000  CONTINUE
      RETURN
      END
 
      SUBROUTINE POLY(N,RAD,P)
C***********************************************************************
C
C     POLY : CALCULATES THE VALUE OF THE ORDINARY LEGENDRE FUNCTION
C            OF GIVEN ORDER AT A SPECIFIED LATITUDE.  USED TO
C            DETERMINE GAUSSIAN LATITUDES.
C
C***********************************************************************
C
C     POLY IS CALLED BY THE SUBROUTINE GLATS.
C
C     POLY CALLS NO SUBROUTINES.
C
C***********************************************************************
C
C    ARGUMENT(DIMENSIONS)                       DESCRIPTION
C
C             N                   INPUT : ORDER OF THE ORDINARY LEGENDRE
C                                         FUNCTION WHOSE VALUE IS TO BE
C                                         CALCULATED. SET IN ROUTINE
C                                         "GLATS".
C            RAD                  INPUT : COLATITUDE (IN RADIANS) AT
C                                         WHICH THE VALUE OF THE ORDINAR
C                                         LEGENDRE FUNCTION IS TO BE
C                                         CALCULATED. SET IN ROUTINE
C                                         "GLATS".
C             P                  OUTPUT : VALUE OF THE ORDINARY LEGENDRE
C                                         FUNCTION OF ORDER "N" AT
C                                         COLATITUDE "RAD".
C
C***********************************************************************
C
C     POLY DOES NOT REFER TO ANY COMMONS.
C
C***********************************************************************
      IMPLICIT REAL*8 (A-H,O-Z)
      X =DCOS(RAD)
      Y1 = 1.0D0
      Y2=X
      DO 1 I=2,N
      G=X*Y2
      Y3=G-Y1+G-(G-Y1)/FLOAT(I)
      Y1=Y2
      Y2=Y3
1     CONTINUE
      P=Y3
      RETURN
      END
      SUBROUTINE GENPNME15(DRAD,PLEGND,DPDU)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C DRAD    (INPUT) = LATITUDE IN RADIANS                                C
C PLEGND (OUTPUT) = VALUES OF LEGENDRE POLYNOMIALS                     C
C                    FOR ALL INDICES SPECIFIED BY NM AND NN            C
C DPDU   (OUTPUT) = VALUES OF  (1.0-U*U)*D(LEG. POLY.)/D(U),           C
C                    WHERE U = SIN(LATITUDE),                          C
C                    FOR ALL INDICES SPECIFIED BY NM AND NN            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  
C     REAL*4 DRAD
      PARAMETER(NM=15,NN=NM+1,NMP=NM+1,NUP=NM)
      DIMENSION PLEGND(NN,NMP),DPDU(NN,NMP)
      COMMON/EPSLON/EPS(NN,NMP),XXN(NN,NMP),XXM(NMP)
      XCOS=COS(DRAD)
      XSIN=SIN(DRAD)
      DO 6 IM=1,NMP
      XXM(IM)=IM-1
      DO 6 N=1,NN
      XXN(N,IM)=XXM(IM)+N-1
    6 CONTINUE
      EPS(1,1)=0.0
      DO 10 N=2,NN
      XN=XXN(N,1)
      EPS(N,1)=SQRT(XN*XN/(4.0E0*XN*XN-1.0E0))
   10 CONTINUE
      DO 20 IM=2,NMP
      XM=XXM(IM)
      DO 18 N=1,NN
      XN=XXN(N,IM)
      EPS(N,IM)=SQRT((XN*XN-XM*XM)/(4.0E0*XN*XN-1.0E0))
   18 CONTINUE
   20 CONTINUE
C----------------------------------------------------------------------
C     POLYNOMIALS AND DERIVATIVES FOR IM=1 (ZERO WAVENUMBER)
C----------------------------------------------------------------------
      U=XSIN
      SQ2=SQRT(2.0E0)
      SQ3=SQRT(3.0E0)
      PLEGND(1,1)=1.0E0/SQ2
      PLEGND(2,1)=U*SQ3/SQ2
      DPDU  (1,1)=0.0E0
      DPDU  (2,1)=SQ3/SQ2*(1.0E0-U*U)
      DO 40 N=2,NUP
      PLEGND(N+1,1)=(U*PLEGND(N,1)-EPS(N,1)*PLEGND(N-1,1))/EPS(N+1,1)
   40 CONTINUE
      DO 60 N=3,NN
      XN=XXN(N,1)
      DPDU(N,1)=(2.0E0*XN+1.0E0)*EPS(N,1)*PLEGND(N-1,1) -
     1           XN*U*PLEGND(N,1)
   60 CONTINUE
C----------------------------------------------------------------------
C     POLYNOMIALS AND DERIVATIVES FOR IM=.GT. 1 (NONZERO WAVENUMBERS)
C----------------------------------------------------------------------
      PREFAC=SQ3/2.0E0*XCOS
      DO 200 IM=2,NMP
      XM=XXM(IM)
      PLEGND(1,IM)=PREFAC
      DPDU  (1,IM)=-XM*U*PLEGND(1,IM)
      PLEGND(2,IM)=U*PLEGND(1,IM)/EPS(2,IM)
      DPDU  (2,IM)=-(XM+1.0E0)*U*PLEGND(2,IM) +
     1(2.0E0*XM+3.0E0)*EPS(2,IM)*PLEGND(1,IM)
      DO 140 N=2,NUP
      PLEGND(N+1,IM)=(U*PLEGND(N,IM)-EPS(N,IM)*PLEGND(N-1,IM))
     1 /EPS(N+1,IM)
  140 CONTINUE
      DO 160 N=3,NN
      XN=XXN(N,IM)
      COEF1=(2.0E0*XN+1.0E0)
      DPDU(N,IM)=COEF1*EPS(N,IM)*PLEGND(N-1,IM)-XN*U*PLEGND(N,IM)
  160 CONTINUE
      PREFAC=PREFAC*SQRT((2.0E0*XM+3.0E0)/(2.0E0*(XM+1.0E0)))*XCOS
      IF(PREFAC .LT. 1.0E-30) PREFAC=0.0E0
  200 CONTINUE
      RETURN
      END

      SUBROUTINE FFT991(A,WORK,TRIGS,IFAX,INC,JUMP,N,LOT,ISIGN)
C-----------------------------------------------------------------------
C        I=SQRT(-1)
C        0<X<2*PAI
C        MAX=N/2
C     F(X)=F(0)+F(  1)*EXP(-I*  1*X)+F(-  1)*EXP(+I*  1*X)
C              +F(  2)*EXP(-I*  2*X)+F(-  2)*EXP(+I*  2*X)
C              +........................
C              +F(  M)*EXP(-I*  M*X)+F(-  M)*EXP(+I*  M*X)
C              +........................
C              +F(MAX)*EXP(-I*MAX*X)+F(-MAX)*EXP(+I*MAX*X)
C-----------------------------------------------------------------------
C..  A    (JUMP,LOT)   ISIGN=+1
C                 INPUT ARRAY  FOR M=0,1,2,....,N/2
C                      A(2*M+1)=REAL(F(M))
C                      A(2*M+2)=AIMAG(F(M))
C                      A(  1)=COS(M= 0)   ,A(2)=0.
C                      A(  3)=COS(M= 1)   ,A(4)=SIN(M=1)
C                      A(  5)=COS(M= 2)   ,A(6)=SIN(M=2)
C                      .................................................
C                      A(N-1)=COS(M=N/2-1),A(N)=SIN(M=N/2-1)
C                      A(N+1)=COS(M=N/2)
C                 OUTPUT ARRAY
C                      GRID POINT VALUES
C                      A(N+1)=0.,......A(JUMP)=0.
C..  A    (JUMP,LOT)  ISIGN=-1
C                 INPUT ARRAY
C                      GRID POINT VALUES
C                      A(N+1)=0.,......A(JUMP)=0.
C                 OUTPUT ARRAY  FOR M=0,1,2,....,N/2
C                      A(2*M+1)=REAL(F(M))
C                      A(2*M+2)=AIMAG(F(M))
C                      A(  1)=COS(M= 0)   ,A(2)=0.
C                      A(  3)=COS(M= 1)   ,A(4)=SIN(M= 1)
C                      A(  5)=COS(M= 2)   ,A(6)=SIN(M= 2)
C                      .................................................
C                      A(N-1)=COS(M=N/2-1),A(N)=SIN(M=N/2-1)
C                      A(N+1)=COS(M=N/2)
C..  WORK (JUMP,LOT)     WORK  ARRAY
C..  TRIGS(.GT.1.5*IMAX) SIN,COS COEFFICIENT
C..  IFAX (10)           FACTORS OF IMAX
C..  INC                 INCREMENT OF DATA SPACING
C..  JUMP                JUMP.GE.N+1
C..  N                   NUMBER OF GRIDS TO BE TRASFORMED
C..  LOT                 NUMBER OF LINES TRANSFORMED SIMULTANEOUSLY
C..  ISIGN=+1            WAVE TO GRID TRANSFORM
C          -1            GRID TO WAVE TRANSFORM
C-----------------------------------------------------------------------
C
C     IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION A(*),WORK(*),TRIGS(*),IFAX(10)
C
      DATA IFP/1/
C
      IF(IFP.EQ.1) THEN
      IFP=0
      CALL FAX   (IFAX ,N,2)
      CALL FFTRIG(TRIGS,N,2)
      END IF
C
      NFAX=IFAX(1)
      NX=N+1
      NH=N/2
      INK=INC+INC
      IF(ISIGN.EQ.1) GO TO 30
C
      IGO=50
      IF(MOD(NFAX,2).EQ.1) GO TO 40
      IBASE=1
      JBASE=1
      DO 20 L=1,LOT
      I=IBASE
      J=JBASE
      DO 10 M=1,N
      WORK(J)=A(I)
      I=I+INC
      J=J+1
   10 CONTINUE
      IBASE=IBASE+JUMP
      JBASE=JBASE+NX
   20 CONTINUE
C
      IGO=60
      GO TO 40
C
   30 CONTINUE
      CALL FFT99A(A,WORK,TRIGS,INC,JUMP,N,LOT)
      IGO=60
C
   40 CONTINUE
      IA=1
      LA=1
      DO 80 K=1,NFAX
      IF(IGO.EQ.60) GO TO 60
   50 CONTINUE
      CALL VPASSM(A(IA),A(IA+INC),WORK(1),WORK(2),TRIGS,INK,2,JUMP,NX,
     $            LOT,NH,IFAX(K+1),LA)
      IGO=60
      GO TO 70
   60 CONTINUE
      CALL VPASSM(WORK(1),WORK(2),A(IA),A(IA+INC),TRIGS,2,INK,NX,JUMP,
     $            LOT,NH,IFAX(K+1),LA)
      IGO=50
   70 CONTINUE
      LA=LA*IFAX(K+1)
   80 CONTINUE
C
      IF(ISIGN.EQ.-1) GO TO 130
C
      IF(MOD(NFAX,2).EQ.1) GO TO 110
      IBASE=1
      JBASE=1
      DO 100 L=1,LOT
      I=IBASE
      J=JBASE
      DO 90 M=1,N
      A(J)=WORK(I)
      I=I+1
      J=J+INC
   90 CONTINUE
      IBASE=IBASE+NX
      JBASE=JBASE+JUMP
  100 CONTINUE
C
  110 CONTINUE
      RETURN
C
  130 CONTINUE
      CALL FFT99B(WORK,A,TRIGS,INC,JUMP,N,LOT)
C
  140 CONTINUE
      RETURN
C
      END
C----------------------------------------------------------------------
      SUBROUTINE FFT99A(A,WORK,TRIGS,INC,JUMP,N,LOT)
C     IMPLICIT REAL*8 (A-H,O-Z)
C
      DIMENSION A(*),WORK(*),TRIGS(*)
C
      NH=N/2
      NX=N+1
      INK=INC+INC
C
      IA=1
      IB=N*INC+1
      JA=1
      JB=2
      DO 10 L=1,LOT
      WORK(JA)=A(IA)+A(IB)
      WORK(JB)=A(IA)-A(IB)
      IA=IA+JUMP
      IB=IB+JUMP
      JA=JA+NX
      JB=JB+NX
   10 CONTINUE
C
      IABASE=2*INC+1
      IBBASE=(N-2)*INC+1
      JABASE=3
      JBBASE=N-1
C
      DO 30 K=3,NH,2
      IA=IABASE
      IB=IBBASE
      JA=JABASE
      JB=JBBASE
      C=TRIGS(N+K)
      S=TRIGS(N+K+1)
      DO 20 L=1,LOT
      WORK(JA)=(A(IA)+A(IB))-
     $         (S*(A(IA)-A(IB))+C*(A(IA+INC)+A(IB+INC)))
      WORK(JB)=(A(IA)+A(IB))+
     $         (S*(A(IA)-A(IB))+C*(A(IA+INC)+A(IB+INC)))
      WORK(JA+1)=(C*(A(IA)-A(IB))-S*(A(IA+INC)+A(IB+INC)))+
     $           (A(IA+INC)-A(IB+INC))
      WORK(JB+1)=(C*(A(IA)-A(IB))-S*(A(IA+INC)+A(IB+INC)))-
     $           (A(IA+INC)-A(IB+INC))
      IA=IA+JUMP
      IB=IB+JUMP
      JA=JA+NX
      JB=JB+NX
   20 CONTINUE
      IABASE=IABASE+INK
      IBBASE=IBBASE-INK
      JABASE=JABASE+2
      JBBASE=JBBASE-2
   30 CONTINUE
C
      IF(IABASE.NE.IBBASE) GO TO 50
      IA=IABASE
      JA=JABASE
      DO 40 L=1,LOT
      WORK(JA)=2.0*A(IA)
      WORK(JA+1)=-2.0*A(IA+INC)
      IA=IA+JUMP
      JA=JA+NX
   40 CONTINUE
C
   50 CONTINUE
      RETURN
C
      END
C----------------------------------------------------------------------
      SUBROUTINE FFT99B(WORK,A,TRIGS,INC,JUMP,N,LOT)
C     IMPLICIT REAL*8 (A-H,O-Z)
C
      DIMENSION WORK(*),A(*),TRIGS(*)
C
      NH=N/2
      NX=N+1
      INK=INC+INC
C
      SCALE=1.0/FLOAT(N)
      IA=1
      IB=2
      JA=1
      JB=N*INC+1
      DO 10 L=1,LOT
      A(JA)=SCALE*(WORK(IA)+WORK(IB))
      A(JB)=SCALE*(WORK(IA)-WORK(IB))
      A(JA+INC)=0.
      IA=IA+NX
      IB=IB+NX
      JA=JA+JUMP
      JB=JB+JUMP
   10 CONTINUE
C
      SCALE=0.5*SCALE
      IABASE=3
      IBBASE=N-1
      JABASE=2*INC+1
      JBBASE=(N-2)*INC+1
C
      DO 30 K=3,NH,2
      IA=IABASE
      IB=IBBASE
      JA=JABASE
      JB=JBBASE
      C=TRIGS(N+K  )
      S=TRIGS(N+K+1)
      DO 20 L=1,LOT
      A(JA)=SCALE*((WORK(IA)+WORK(IB))
     $      +(C*(WORK(IA+1)+WORK(IB+1))+S*(WORK(IA)-WORK(IB))))
      A(JB)=SCALE*((WORK(IA)+WORK(IB))
     $      -(C*(WORK(IA+1)+WORK(IB+1))+S*(WORK(IA)-WORK(IB))))
      A(JA+INC)=SCALE*((C*(WORK(IA)-WORK(IB))-S*(WORK(IA+1)+WORK(IB+1)))
     $          +(WORK(IB+1)-WORK(IA+1)))
      A(JB+INC)=SCALE*((C*(WORK(IA)-WORK(IB))-S*(WORK(IA+1)+WORK(IB+1)))
     $          -(WORK(IB+1)-WORK(IA+1)))
      IA=IA+NX
      IB=IB+NX
      JA=JA+JUMP
      JB=JB+JUMP
   20 CONTINUE
      IABASE=IABASE+2
      IBBASE=IBBASE-2
      JABASE=JABASE+INK
      JBBASE=JBBASE-INK
   30 CONTINUE
C
      IF(IABASE.NE.IBBASE) GO TO 50
      IA=IABASE
      JA=JABASE
      SCALE=2.0*SCALE
      DO 40 L=1,LOT
      A(JA)=SCALE*WORK(IA)
      A(JA+INC)=-SCALE*WORK(IA+1)
      IA=IA+NX
      JA=JA+JUMP
   40 CONTINUE
C
   50 CONTINUE
      RETURN
C
      END
C----------------------------------------------------------------------
      SUBROUTINE VPASSM(A,B,C,D,TRIGS,INC1,INC2,INC3,INC4,LOT,N,IFAC,LA)
C     IMPLICIT REAL*8 (A-H,O-Z)
C
      DIMENSION A(*),B(*),C(*),D(*),TRIGS(*)
      DATA INT/0/
C
      IF(INT.EQ.0) THEN
        RADI=ATAN(1.)/45.
        SIN60=SIN(60.*RADI)
        SIN36=SIN(36.*RADI)
        SIN72=SIN(72.*RADI)
        COS36=COS(36.*RADI)
        COS72=COS(72.*RADI)
        INT=1
      END IF
      M=N/IFAC
      IINK=M*INC1
      JINK=LA*INC2
      JUMP=(IFAC-1)*JINK
      IBASE=0
      JBASE=0
      IGO=IFAC-1
      IF(IGO.GT.4) RETURN
      GO TO (10,50,90,130),IGO
C
   10 CONTINUE
      IA=1
      JA=1
      IB=IA+IINK
      JB=JA+JINK
      DO 20 L=1,LA
      I=IBASE
      J=JBASE
      DO 15 IJK=1,LOT
      C(JA+J)=A(IA+I)+A(IB+I)
      D(JA+J)=B(IA+I)+B(IB+I)
      C(JB+J)=A(IA+I)-A(IB+I)
      D(JB+J)=B(IA+I)-B(IB+I)
      I=I+INC3
      J=J+INC4
   15 CONTINUE
      IBASE=IBASE+INC1
      JBASE=JBASE+INC2
   20 CONTINUE
      IF(LA.EQ.M) RETURN
      LA1=LA+1
      JBASE=JBASE+JUMP
      DO 40 K=LA1,M,LA
      KB=K+K-2
      C1=TRIGS(KB+1)
      S1=TRIGS(KB+2)
      DO 30 L=1,LA
      I=IBASE
      J=JBASE
      DO 25 IJK=1,LOT
      C(JA+J)=A(IA+I)+A(IB+I)
      D(JA+J)=B(IA+I)+B(IB+I)
      C(JB+J)=C1*(A(IA+I)-A(IB+I))-S1*(B(IA+I)-B(IB+I))
      D(JB+J)=S1*(A(IA+I)-A(IB+I))+C1*(B(IA+I)-B(IB+I))
      I=I+INC3
      J=J+INC4
   25 CONTINUE
      IBASE=IBASE+INC1
      JBASE=JBASE+INC2
   30 CONTINUE
      JBASE=JBASE+JUMP
   40 CONTINUE
      RETURN
C
   50 CONTINUE
      IA=1
      JA=1
      IB=IA+IINK
      JB=JA+JINK
      IC=IB+IINK
      JC=JB+JINK
      DO 60 L=1,LA
      I=IBASE
      J=JBASE
      DO 55 IJK=1,LOT
      C(JA+J)=A(IA+I)+(A(IB+I)+A(IC+I))
      D(JA+J)=B(IA+I)+(B(IB+I)+B(IC+I))
      C(JB+J)=(A(IA+I)-0.5*(A(IB+I)+A(IC+I)))-(SIN60*(B(IB+I)-B(IC+I)))
      C(JC+J)=(A(IA+I)-0.5*(A(IB+I)+A(IC+I)))+(SIN60*(B(IB+I)-B(IC+I)))
      D(JB+J)=(B(IA+I)-0.5*(B(IB+I)+B(IC+I)))+(SIN60*(A(IB+I)-A(IC+I)))
      D(JC+J)=(B(IA+I)-0.5*(B(IB+I)+B(IC+I)))-(SIN60*(A(IB+I)-A(IC+I)))
      I=I+INC3
      J=J+INC4
   55 CONTINUE
      IBASE=IBASE+INC1
      JBASE=JBASE+INC2
   60 CONTINUE
      IF(LA.EQ.M) RETURN
      LA1=LA+1
      JBASE=JBASE+JUMP
      DO 80 K=LA1,M,LA
      KB=K+K-2
      KC=KB+KB
      C1=TRIGS(KB+1)
      S1=TRIGS(KB+2)
      C2=TRIGS(KC+1)
      S2=TRIGS(KC+2)
      DO 70 L=1,LA
      I=IBASE
      J=JBASE
      DO 65 IJK=1,LOT
      C(JA+J)=A(IA+I)+(A(IB+I)+A(IC+I))
      D(JA+J)=B(IA+I)+(B(IB+I)+B(IC+I))
      C(JB+J)=
     $    C1*((A(IA+I)-0.5*(A(IB+I)+A(IC+I)))-(SIN60*(B(IB+I)-B(IC+I))))
     $   -S1*((B(IA+I)-0.5*(B(IB+I)+B(IC+I)))+(SIN60*(A(IB+I)-A(IC+I))))
      D(JB+J)=
     $    S1*((A(IA+I)-0.5*(A(IB+I)+A(IC+I)))-(SIN60*(B(IB+I)-B(IC+I))))
     $   +C1*((B(IA+I)-0.5*(B(IB+I)+B(IC+I)))+(SIN60*(A(IB+I)-A(IC+I))))
      C(JC+J)=
     $    C2*((A(IA+I)-0.5*(A(IB+I)+A(IC+I)))+(SIN60*(B(IB+I)-B(IC+I))))
     $   -S2*((B(IA+I)-0.5*(B(IB+I)+B(IC+I)))-(SIN60*(A(IB+I)-A(IC+I))))
      D(JC+J)=
     $    S2*((A(IA+I)-0.5*(A(IB+I)+A(IC+I)))+(SIN60*(B(IB+I)-B(IC+I))))
     $   +C2*((B(IA+I)-0.5*(B(IB+I)+B(IC+I)))-(SIN60*(A(IB+I)-A(IC+I))))
      I=I+INC3
      J=J+INC4
   65 CONTINUE
      IBASE=IBASE+INC1
      JBASE=JBASE+INC2
   70 CONTINUE
      JBASE=JBASE+JUMP
   80 CONTINUE
      RETURN
C
   90 CONTINUE
      IA=1
      JA=1
      IB=IA+IINK
      JB=JA+JINK
      IC=IB+IINK
      JC=JB+JINK
      ID=IC+IINK
      JD=JC+JINK
      DO 100 L=1,LA
      I=IBASE
      J=JBASE
      DO 95 IJK=1,LOT
      C(JA+J)=(A(IA+I)+A(IC+I))+(A(IB+I)+A(ID+I))
      C(JC+J)=(A(IA+I)+A(IC+I))-(A(IB+I)+A(ID+I))
      D(JA+J)=(B(IA+I)+B(IC+I))+(B(IB+I)+B(ID+I))
      D(JC+J)=(B(IA+I)+B(IC+I))-(B(IB+I)+B(ID+I))
      C(JB+J)=(A(IA+I)-A(IC+I))-(B(IB+I)-B(ID+I))
      C(JD+J)=(A(IA+I)-A(IC+I))+(B(IB+I)-B(ID+I))
      D(JB+J)=(B(IA+I)-B(IC+I))+(A(IB+I)-A(ID+I))
      D(JD+J)=(B(IA+I)-B(IC+I))-(A(IB+I)-A(ID+I))
      I=I+INC3
      J=J+INC4
   95 CONTINUE
      IBASE=IBASE+INC1
      JBASE=JBASE+INC2
  100 CONTINUE
      IF(LA.EQ.M) RETURN
      LA1=LA+1
      JBASE=JBASE+JUMP
      DO 120 K=LA1,M,LA
      KB=K+K-2
      KC=KB+KB
      KD=KC+KB
      C1=TRIGS(KB+1)
      S1=TRIGS(KB+2)
      C2=TRIGS(KC+1)
      S2=TRIGS(KC+2)
      C3=TRIGS(KD+1)
      S3=TRIGS(KD+2)
      DO 110 L=1,LA
      I=IBASE
      J=JBASE
      DO 105 IJK=1,LOT
      C(JA+J)=(A(IA+I)+A(IC+I))+(A(IB+I)+A(ID+I))
      D(JA+J)=(B(IA+I)+B(IC+I))+(B(IB+I)+B(ID+I))
      C(JC+J)=
     $    C2*((A(IA+I)+A(IC+I))-(A(IB+I)+A(ID+I)))
     $   -S2*((B(IA+I)+B(IC+I))-(B(IB+I)+B(ID+I)))
      D(JC+J)=
     $    S2*((A(IA+I)+A(IC+I))-(A(IB+I)+A(ID+I)))
     $   +C2*((B(IA+I)+B(IC+I))-(B(IB+I)+B(ID+I)))
      C(JB+J)=
     $    C1*((A(IA+I)-A(IC+I))-(B(IB+I)-B(ID+I)))
     $   -S1*((B(IA+I)-B(IC+I))+(A(IB+I)-A(ID+I)))
      D(JB+J)=
     $    S1*((A(IA+I)-A(IC+I))-(B(IB+I)-B(ID+I)))
     $   +C1*((B(IA+I)-B(IC+I))+(A(IB+I)-A(ID+I)))
      C(JD+J)=
     $    C3*((A(IA+I)-A(IC+I))+(B(IB+I)-B(ID+I)))
     $   -S3*((B(IA+I)-B(IC+I))-(A(IB+I)-A(ID+I)))
      D(JD+J)=
     $    S3*((A(IA+I)-A(IC+I))+(B(IB+I)-B(ID+I)))
     $   +C3*((B(IA+I)-B(IC+I))-(A(IB+I)-A(ID+I)))
      I=I+INC3
      J=J+INC4
  105 CONTINUE
      IBASE=IBASE+INC1
      JBASE=JBASE+INC2
  110 CONTINUE
      JBASE=JBASE+JUMP
  120 CONTINUE
      RETURN
C
  130 CONTINUE
      IA=1
      JA=1
      IB=IA+IINK
      JB=JA+JINK
      IC=IB+IINK
      JC=JB+JINK
      ID=IC+IINK
      JD=JC+JINK
      IE=ID+IINK
      JE=JD+JINK
      DO 140 L=1,LA
      I=IBASE
      J=JBASE
      DO 135 IJK=1,LOT
      C(JA+J)=A(IA+I)+(A(IB+I)+A(IE+I))+(A(IC+I)+A(ID+I))
      D(JA+J)=B(IA+I)+(B(IB+I)+B(IE+I))+(B(IC+I)+B(ID+I))
      C(JB+J)=(A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I)))
     $  -(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I)))
      C(JE+J)=(A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I)))
     $  +(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I)))
      D(JB+J)=(B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I)))
     $  +(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I)))
      D(JE+J)=(B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I)))
     $  -(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I)))
      C(JC+J)=(A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I)))
     $  -(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I)))
      C(JD+J)=(A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I)))
     $  +(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I)))
      D(JC+J)=(B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I)))
     $  +(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I)))
      D(JD+J)=(B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I)))
     $  -(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I)))
      I=I+INC3
      J=J+INC4
  135 CONTINUE
      IBASE=IBASE+INC1
      JBASE=JBASE+INC2
  140 CONTINUE
      IF(LA.EQ.M) RETURN
      LA1=LA+1
      JBASE=JBASE+JUMP
      DO 160 K=LA1,M,LA
      KB=K+K-2
      KC=KB+KB
      KD=KC+KB
      KE=KD+KB
      C1=TRIGS(KB+1)
      S1=TRIGS(KB+2)
      C2=TRIGS(KC+1)
      S2=TRIGS(KC+2)
      C3=TRIGS(KD+1)
      S3=TRIGS(KD+2)
      C4=TRIGS(KE+1)
      S4=TRIGS(KE+2)
      DO 150 L=1,LA
      I=IBASE
      J=JBASE
      DO 145 IJK=1,LOT
      C(JA+J)=A(IA+I)+(A(IB+I)+A(IE+I))+(A(IC+I)+A(ID+I))
      D(JA+J)=B(IA+I)+(B(IB+I)+B(IE+I))+(B(IC+I)+B(ID+I))
      C(JB+J)=
     $    C1*((A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I)))
     $      -(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I))))
     $   -S1*((B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I)))
     $      +(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I))))
      D(JB+J)=
     $    S1*((A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I)))
     $      -(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I))))
     $   +C1*((B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I)))
     $      +(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I))))
      C(JE+J)=
     $    C4*((A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I)))
     $      +(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I))))
     $   -S4*((B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I)))
     $      -(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I))))
      D(JE+J)=
     $    S4*((A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I)))
     $      +(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I))))
     $   +C4*((B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I)))
     $      -(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I))))
      C(JC+J)=
     $    C2*((A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I)))
     $      -(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I))))
     $   -S2*((B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I)))
     $      +(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I))))
      D(JC+J)=
     $    S2*((A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I)))
     $      -(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I))))
     $   +C2*((B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I)))
     $      +(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I))))
      C(JD+J)=
     $    C3*((A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I)))
     $      +(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I))))
     $   -S3*((B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I)))
     $      -(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I))))
      D(JD+J)=
     $    S3*((A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I)))
     $      +(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I))))
     $   +C3*((B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I)))
     $      -(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I))))
      I=I+INC3
      J=J+INC4
  145 CONTINUE
      IBASE=IBASE+INC1
      JBASE=JBASE+INC2
  150 CONTINUE
      JBASE=JBASE+JUMP
  160 CONTINUE
      RETURN
C
      END
      SUBROUTINE FAX(IFAX,N,MODE)
C     IMPLICIT REAL*8 (A-H,O-Z)
C
      DIMENSION IFAX(10)
C
      NN=N
      IF(IABS(MODE).EQ.1) GO TO 10
      IF(IABS(MODE).EQ.8) GO TO 10
      NN=N/2
      IF((NN+NN).EQ.N) GO TO 10
      IFAX(1)=-99
      RETURN
C
   10 CONTINUE
      K=1
   20 CONTINUE
      IF(MOD(NN,4).NE.0) GO TO 30
      K=K+1
      IFAX(K)=4
      NN=NN/4
      IF(NN.EQ.1) GO TO 80
      GO TO 20
   30 CONTINUE
      IF(MOD(NN,2).NE.0) GO TO 40
      K=K+1
      IFAX(K)=2
      NN=NN/2
      IF(NN.EQ.1) GO TO 80
   40 CONTINUE
      IF(MOD(NN,3).NE.0) GO TO 50
      K=K+1
      IFAX(K)=3
      NN=NN/3
      IF(NN.EQ.1) GO TO 80
      GO TO 40
   50 CONTINUE
      L=5
      INC=2
   60 CONTINUE
      IF(MOD(NN,L).NE.0) GO TO 70
      K=K+1
      IFAX(K)=L
      NN=NN/L
      IF(NN.EQ.1) GO TO 80
      GO TO 60
   70 CONTINUE
      L=L+INC
      INC=6-INC
      GO TO 60
   80 CONTINUE
      IFAX(1)=K-1
      NFAX=IFAX(1)
      IF(NFAX.EQ.1) GO TO 110
      DO 100 II=2,NFAX
      ISTOP=NFAX+2-II
      DO 90 I=2,ISTOP
      IF(IFAX(I+1).GE.IFAX(I)) GO TO 90
      ITEM=IFAX(I)
      IFAX(I)=IFAX(I+1)
      IFAX(I+1)=ITEM
   90 CONTINUE
  100 CONTINUE
  110 CONTINUE
      RETURN
C
      END
C----------------------------------------------------------------------
      SUBROUTINE FFTRIG(TRIGS,N,MODE)
C     IMPLICIT REAL*8 (A-H,O-Z)
C
      DIMENSION TRIGS(*)
C
      PI=2.0*ASIN(1.0)
      IMODE=IABS(MODE)
      NN=N
      IF(IMODE.GT.1.AND.IMODE.LT.6) NN=N/2
      DEL=(PI+PI)/FLOAT(NN)
      L=NN+NN
      DO 10 I=1,L,2
      ANGLE=0.5*FLOAT(I-1)*DEL
      TRIGS(I  )=COS(ANGLE)
      TRIGS(I+1)=SIN(ANGLE)
   10 CONTINUE
      IF(IMODE.EQ.1) RETURN
      IF(IMODE.EQ.8) RETURN
      DEL=0.5*DEL
      NH=(NN+1)/2
      L=NH+NH
      LA=NN+NN
      DO 20 I=1,L,2
      ANGLE=0.5*FLOAT(I-1)*DEL
      TRIGS(LA+I  )=COS(ANGLE)
      TRIGS(LA+I+1)=SIN(ANGLE)
   20 CONTINUE
      IF(IMODE.LE.3) RETURN
      DEL=0.5*DEL
      LA=LA+NN
      IF(MODE.EQ.5) GO TO 40
      DO 30 I=2,NN
      ANGLE=FLOAT(I-1)*DEL
      TRIGS(LA+I)=2.0*SIN(ANGLE)
   30 CONTINUE
      RETURN
   40 CONTINUE
      DEL=0.5*DEL
      DO 50 I=2,N
      ANGLE=FLOAT(I-1)*DEL
      TRIGS(LA+I)=SIN(ANGLE)
   50 CONTINUE
      RETURN
C
      END

