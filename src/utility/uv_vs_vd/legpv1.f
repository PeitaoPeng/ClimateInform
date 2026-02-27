C---- THIS SUBROUTINE CALCULATES THE LEGENDER POLYNOMIALS AND THEIR 1ST LEG00010
C     ORDER DERIVATIVES FOR SPECTRAL BVE MODEL.                         LEG00020
C                                                                       LEG00030
C     ARRAY DEFINITION:                                                 LEG00040
C     GLAT(J)  GAUSSIAN LETITUDES, IN RADIANS (J=1,JGMAX S-EQ-N)        LEG00050
C     GW(J)    GAUSSIAN WEIGHTS                                         LEG00060
C     P(J,K)   LEGENDER POLYNOMIALS (K-STACKED IN MERIDIONAL            LEG00070
C              WAVENUMBER INCREASING DIRECTION                          LEG00080
C     DP(J,K)  1ST ORDER DERIVATIVES OF P(J,K)                          LEG00090
C     COA(J)   COSINE OF GAUSSIAN LATITUDES                             LEG00100
C---- SOA(J)   SINE   OF GAUSSIAN LATITUDES                             LEG00110
C                                                                       LEG00120
C                                                                       LEG00130
C---------------------------------------------------------------------- LEG00140
C                                                                       LEG00150
      SUBROUTINE GAUSSL(SIA,COA,GLAT,GW,JGMAX)                          LEG00160
C                                                                       LEG00170
C---- THIS ROUTINE CALCULATES THE GAUSSIAN LATITUDES                    LEG00180
C                                                                       LEG00190
      REAL*8 SIA(JGMAX),COA(JGMAX),GLAT(JGMAX),GW(JGMAX),               LEG00200
     $       PI2,X0,X1,X2,X3,P0,P1,P2,D0,D1,D2,DFN                      LEG00210
      X0=3.1415926535897932D0/FLOAT(4*JGMAX+2)      
      JH=(JGMAX+1)/2                                                    LEG00230
      PI2=ASIN(1.0)                                                 
      DO 30 J=1,JH                                                      LEG00250
      X1=COS(FLOAT(4*J-1)*X0) 
   10 P0=X1                                                             LEG00270
      P1=1.500*P0*P0-0.50                                           
      D0=1.00                                                      
      D1=3.00*P0                      
      DO 20 N=3,JGMAX                                                   LEG00310
      DFN=FLOAT(N)                                
      X2=(2.00*DFN-1.00)*P1          
      P2=(X1*X2-(DFN-1.00)*P0)/DFN  
      D2=X2+D0                                                          LEG00350
      P0=P1                                                             LEG00360
      P1=P2                                                             LEG00370
      D0=D1                                                             LEG00380
      D1=D2                                                             LEG00390
   20 CONTINUE                                                          LEG00400
      X3=P2/D2                                                          LEG00410
      X1=X1-X3                                                          LEG00420
      IF(ABS(X3).GE.1.E-14) GOTO 10  
      COA(J)=X1                                                         LEG00440
      GW(J)=2.000/((1.000-X1*X1)*D2*D2)                                 LEG00450
   30 CONTINUE                                                          LEG00460
      DO 40 J=1,JH                                                      LEG00470
      JJ=JGMAX-J+1                                                      LEG00480
      GLAT(JJ)=PI2-ACOS(COA(J)) 
      GLAT(J)=-GLAT(JJ)                                                 LEG00500
      SIA(JJ)=COA(J)                                                    LEG00510
      SIA(J)=-COA(J)                                                    LEG00520
      COA(J)=SQRT(1.000-COA(J)*COA(J))           
      COA(JJ)=COA(J)                                                    LEG00540
      GW(JJ)=GW(J)                                                      LEG00550
  40  CONTINUE                                                          LEG00560
      RETURN                                                            LEG00570
      END                                                               LEG00580
C                                                                       LEG00590
C-----------------------------------------------------------------------LEG00600
C                                                                       LEG00610
      SUBROUTINE LEGPOL(P,SIA,COA,KMAX,MMAX,NMAX,JGMAX,lromb)           LEG00620
C                                                                       LEG00630
C---- THIS ROUTINE THE NORMALIZED ASSOCIATED LEGENDER POLYNOMIALS AT    LEG00640
C     GAUSSIAN LATITUDES AND STORE INTO ARRAY P(JGMAX,KMAX)             LEG00650
C                                                                       LEG00660
      REAL    P(JGMAX,KMAX)                                             LEG00670
      REAL    SIA(JGMAX),COA(JGMAX),TEMP0,TEMP,FM,FM2,FN,FN2            LEG00680
      JH=(JGMAX+1)/2                                                    LEG00690
C     BAER'S NORMALIZATION INITIAL VALUE                                LEG00700
      DO 50 J=1,JH                                                      LEG00710
      K=0                                                               LEG00720
      DO 40 M=1,MMAX                                                    LEG00730
      K=K+1                                                             LEG00740
      FM=FLOAT(M-1)     
      FM2=FM+FM                                                         LEG00760
      IF (M.EQ.1) THEN                                                  LEG00770
      TEMP=SQRT(0.500)
      P(J,K)=TEMP                                                       LEG00790
      P1=P(J,K)                                                         LEG00800
      ELSE                                                              LEG00810
      TEMP= SQRT(1.000+1.000/FM2)                                       LEG00820
      P(J,K)=TEMP*COA(J)*P1                                             LEG00830
      P1=P(J,K)                                                         LEG00840
      ENDIF                                                             LEG00850
      K=K+1                                                             LEG00860
      TEMP= SQRT(FM2+3.000)                                             LEG00870
      P(J,K)=TEMP*SIA(J)*P(J,K-1)                                       LEG00880
      lmp=(m-1)*lromb
      DO 30 N=M+2,NMAX+lmp
      K=K+1                                                             LEG00900
      FM=FLOAT(M-1)  
      FN=FLOAT(N-1)  
      TEMP0=(2.000*FN+1.000)/(FN+FM)/(FN-FM)                            LEG00930
      TEMP= SQRT(TEMP0*(2.000*FN-1.000))                                LEG00940
      TEMP0=                                                            LEG00950
     $  SQRT(TEMP0*(FN+FM-1.000)*(FN-FM-1.000)/(2.000*FN-3.000))        LEG00960
      P(J,K)=TEMP*SIA(J)*P(J,K-1)-TEMP0*P(J,K-2)                        LEG00970
   30 CONTINUE                                                          LEG00980
   40 CONTINUE                                                          LEG00990
C                                                                       LEG01000
   50 CONTINUE                                                          LEG01010
      K=0                                                               LEG01020
      DO 60 M=1,MMAX                                                    LEG01030
      lmp=(m-1)*lromb
      DO 60 N=M,NMAX+lmp
      K=K+1                                                             LEG01050
      DO 60 J=1,JH                                                      LEG01060
      JJ=JGMAX-J+1                                                      LEG01070
      KMN=M+N                                                           LEG01080
      IF(MOD(KMN,2).EQ.1) P(JJ,K)=-P(J,K)                               LEG01090
      IF(MOD(KMN,2).EQ.0) P(JJ,K)=P(J,K)                                LEG01100
   60 CONTINUE                                                          LEG01110
      RETURN                                                            LEG01120
      END                                                               LEG01130
C                                                                       LEG01140
C---------------------------------------------------------------------  LEG01150
C                                                                       LEG01160
      SUBROUTINE DIFP(SIA,COA,P,DP,KMAX,MMAX,NMAX,JGMAX,lromb)
C                                                                       LEG01180
C---- THIS ROUTINE THE 1ST ORDER DERIVATIVES OF LEGENDER POLYNOMIALS    LEG01190
C     AT GUASSIAN LATITUDES, GIVES DP/COS(J),                           LEG01200
C     AND STORE INTO ARRAY DP(JGMAX,KMAX)                               LEG01210
C                                                                       LEG01220
      REAL   P(JGMAX,KMAX),DP(JGMAX,KMAX),EPSLON(127,127)
      REAL   SIA(JGMAX),COA(JGMAX),FM,FN                                LEG01240
C                                                                       LEG01250
C    EPSLON ARRAY INITIALIZED                                           LEG01260
C                                                                       LEG01270
      DO 10 M=1,MMAX                                                    LEG01280
      lmp=(m-1)*lromb
      DO 10 N=M,NMAX+lmp
      FM=FLOAT(M-1)
      FN=FLOAT(N-1)
      EPSLON(M,N)= SQRT((FN*FN-FM*FM)/(4.000*FN*FN-1.000))              LEG01320
   10 CONTINUE                                                          LEG01330
      DO 40 J=1,JGMAX                                                   LEG01340
      K=0                                                               LEG01350
      DO 30 M=1,MMAX                                                    LEG01360
      K=K+1                                                             LEG01370
      FM=FLOAT(M-1) 
      IF (M.EQ.MMAX) THEN                                               LEG01390
      DP(J,K)=-FM*SIA(J)*P(J,K)/COA(J)/COA(J)                           LEG01400
      ELSE                                                              LEG01410
      DP(J,K)=-FM*EPSLON(M,M+1)*P(J,K+1)/COA(J)/COA(J)                  LEG01420
      ENDIF                                                             LEG01430
      lmp=(m-1)*lromb
      DO 20 N=M+1,NMAX+lmp
      K=K+1                                                             LEG01450
      FN=FLOAT(N-1)  
      IF (N.EQ.NMAX) THEN                                               LEG01470
      DP(J,K)=((2.000*FN+1.000)*EPSLON(M,N)*P(J,K-1)                    LEG01480
     & -FN*SIA(J)*P(J,K))/COA(J)/COA(J)                                 LEG01490
      ELSE                                                              LEG01500
      DP(J,K)=((FN+1.000)*EPSLON(M,N)*P(J,K-1)                          LEG01510
     $   -FN*EPSLON(M,N+1)*P(J,K+1))/COA(J)/COA(J)                      LEG01520
      ENDIF                                                             LEG01530
  20  CONTINUE                                                          LEG01540
  30  CONTINUE                                                          LEG01550
  40  CONTINUE                                                          LEG01560
      RETURN                                                            LEG01570
      END                                                               LEG01580
