      SUBROUTINE GENPNM(DRAD,PLEGND,DPDU)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C DRAD    (INPUT) = LATITUDE IN RADIANS                                C
C PLEGND (OUTPUT) = VALUES OF LEGENDRE POLYNOMIALS                     C
C                    FOR ALL INDICES SPECIFIED BY NM AND NN            C
C DPDU   (OUTPUT) = VALUES OF  (1.0-U*U)*D(LEG. POLY.)/D(U),           C
C                    WHERE U = SIN(LATITUDE),                          C
C                    FOR ALL INDICES SPECIFIED BY NM AND NN            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*4 DRAD
      PARAMETER(NM=40,NN=NM+1,NMP=NM+1,NUP=NM)
      DIMENSION PLEGND(NN,NMP),DPDU(NN,NMP),EPS(NN,NMP)
      DIMENSION XXN(NN,NMP),XXM(NMP)
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
      EPS(N,1)=DSQRT(XN*XN/(4.0D0*XN*XN-1.0D0))
   10 CONTINUE
      DO 20 IM=2,NMP
      XM=XXM(IM)
      DO 18 N=1,NN
      XN=XXN(N,IM)
      EPS(N,IM)=DSQRT((XN*XN-XM*XM)/(4.0D0*XN*XN-1.0D0))
   18 CONTINUE
   20 CONTINUE
C----------------------------------------------------------------------
C     POLYNOMIALS AND DERIVATIVES FOR IM=1 (ZERO WAVENUMBER)
C----------------------------------------------------------------------
      U=XSIN
      SQ2=DSQRT(2.0D0)
      SQ3=DSQRT(3.0D0)
      PLEGND(1,1)=1.0D0/SQ2
      PLEGND(2,1)=U*SQ3/SQ2
      DPDU  (1,1)=0.0D0
      DPDU  (2,1)=SQ3/SQ2*(1.0D0-U*U)
      DO 40 N=2,NUP
      PLEGND(N+1,1)=(U*PLEGND(N,1)-EPS(N,1)*PLEGND(N-1,1))/EPS(N+1,1)
   40 CONTINUE
      DO 60 N=3,NN
      XN=XXN(N,1)
      DPDU(N,1)=(2.0D0*XN+1.0D0)*EPS(N,1)*PLEGND(N-1,1) -
     1           XN*U*PLEGND(N,1)
   60 CONTINUE
C----------------------------------------------------------------------
C     POLYNOMIALS AND DERIVATIVES FOR IM=.GT. 1 (NONZERO WAVENUMBERS)
C----------------------------------------------------------------------
      PREFAC=SQ3/2.0D0*XCOS
      DO 200 IM=2,NMP
      XM=XXM(IM)
      PLEGND(1,IM)=PREFAC
      DPDU  (1,IM)=-XM*U*PLEGND(1,IM)
      PLEGND(2,IM)=U*PLEGND(1,IM)/EPS(2,IM)
      DPDU  (2,IM)=-(XM+1.0D0)*U*PLEGND(2,IM) +
     1(2.0D0*XM+3.0D0)*EPS(2,IM)*PLEGND(1,IM)
      DO 140 N=2,NUP
      PLEGND(N+1,IM)=(U*PLEGND(N,IM)-EPS(N,IM)*PLEGND(N-1,IM))
     1 /EPS(N+1,IM)
  140 CONTINUE
      DO 160 N=3,NN
      XN=XXN(N,IM)
      COEF1=(2.0D0*XN+1.0D0)
      DPDU(N,IM)=COEF1*EPS(N,IM)*PLEGND(N-1,IM)-XN*U*PLEGND(N,IM)
  160 CONTINUE
      PREFAC=PREFAC*DSQRT((2.0D0*XM+3.0D0)/(2.0D0*(XM+1.0D0)))*XCOS
      IF(PREFAC .LT. 1.0D-40) PREFAC=0.0D0
  200 CONTINUE
      RETURN
      END
