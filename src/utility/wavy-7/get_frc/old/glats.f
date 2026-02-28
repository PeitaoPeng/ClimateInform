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
      EPS=1.0e-12
      SI = 1.0e0
      K2=2*KHALF
      RK2=K2
      SCALE = 2.0/(RK2**2)
      K1=K2-1
      PI =ATAN(SI)* 4.0e0
      DRADZ = PI / 360.e0
      RAD = 0.0e0
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
      DRAD = DRAD * 0.25e0
      GO TO 1
3     CONTINUE
      COLRAD(K)=RAD
      PHI = RAD * 180.0 / PI
      CALL POLY(K1,RAD,P1)
      X = COS(RAD)
      W = SCALE * (1.0e0 - X*X)/ (P1*P1)
      WGT(K) = W
      SN = SIN(RAD)
      W=W/(SN*SN)
      WGTCS(K) = W
      RC=1.0e0/(SN*SN)
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
      X =COS(RAD)
      Y1 = 1.0e0
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
