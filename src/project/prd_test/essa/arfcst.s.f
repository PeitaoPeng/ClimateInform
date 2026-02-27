C       PROGRAM NAME = ar_mod.f
C       PROGRAMMER = Dr. Kwang-Y. Kim
C       CODE IDENTIFICATION NUMBER = AR_MOD/VERSION 1.0
C       CODE CLASSIFICATION = Scientific Computer Code
C       CREATION DATE = November 14, 1995
C       REVISION DATE = not revised
C       REVISION INFORMATION : not applicable
C
C *****************************************************************************
C       This program computes the AR model for prediction (ARMPRD).

      SUBROUTINE ARPRD(TINP,NDT,TPRD,NPRD)


      PARAMETER (NPTS=9000, NORD=30) 

      DIMENSION TINP(NPTS),TPRD(NPRD)

      DIMENSION RN(2*NPTS), TS(NPTS), CO(0:NPTS), PC(NPTS,NPTS),
     &          SG(0:NPTS), SP(0:NPTS), A(0:NORD), PA(NORD,NORD),
     &          ERR(NORD)
      DIMENSION SMAT(NORD,NORD), BMAT(NORD,NORD), CMAT(NORD,NORD),
     &          DMAT(NORD,NORD), AM(NORD,NORD), BM(NORD,NORD),
     &          GAM(NORD), X(NORD)
      DIMENSION AIC(0:NORD), CAT(0:NORD), IAICP(NORD), ICATP(NORD)
      DIMENSION COV(NPTS,NPTS), TRL(NPTS,NPTS), DIA(NPTS), EPS(NPTS)
      DIMENSION XI(4,30), ZA(4)
      CHARACTER*50 FILNMI, FORMTI
      COMPLEX ARG, JIMAG
      DATA JIMAG / (0., 1.) /
      DATA XI / 1.50, 2.71, 3.84, 6.63, 3.19, 4.61, 5.99, 9.21,
     &          4.58, 6.25, 7.81, 11.3, 6.00, 7.78, 9.49, 13.3,
     &          7.16, 9.24, 11.1, 15.1, 8.56, 10.6, 12.6, 16.8,
     &          9.80, 12.0, 14.1, 18.5, 11.0, 13.4, 15.5, 20.1,
     &          12.2, 14.7, 16.9, 21.7, 13.4, 16.0, 18.3, 23.2,
     &          14.6, 17.3, 19.7, 24.7, 15.8, 18.6, 21.0, 26.2,
     &          17.0, 19.8, 22.4, 27.7, 18.2, 21.1, 23.7, 29.1,
     &          19.3, 22.3, 25.0, 30.6, 20.5, 23.5, 26.3, 32.0,
     &          21.6, 24.8, 27.6, 33.4, 22.8, 26.0, 28.9, 34.8,
     &          23.9, 27.2, 30.1, 36.2, 25.0, 28.4, 31.4, 37.6,
     &          26.2, 29.6, 32.7, 38.9, 27.3, 30.8, 33.9, 40.3,
     &          28.4, 32.0, 35.2, 41.6, 29.6, 33.2, 36.4, 43.0,
     &          30.7, 34.4, 37.7, 44.3, 31.8, 35.6, 38.9, 45.6,
     &          32.9, 36.7, 40.1, 47.0, 34.0, 37.9, 41.3, 48.3,
     &          35.1, 39.1, 42.6, 49.6, 36.3, 40.3, 43.8, 50.9 /
      DATA ZA / 1.282, 1.645, 1.960, 2.576 /
      DATA SPVAL / -999.0 /

      PI = 4.0*ATAN(1.0)
      TPI = 2.0*PI

C----read in time series 
        DO I=1,NDT
          TS(I) = TINP(I)
        END DO
C ------- Calculate avg, std and var of the time series
      CALL STATS(AVG,STD,VAR,TS,NIN)

C ------- Calculate the covariance function
C ---------- covariance function using Levinson's algorithm
C ---------- sample covariance function
        DO LAG=0,NORD
          SUM = 0.0
          DO I=1,NDT-LAG
            SUM = SUM + (TS(I)-AVG)*(TS(I+LAG)-AVG)
          END DO
C         CO(LAG) = SUM/FLOAT(NDT)
          CO(LAG) = SUM/FLOAT(NDT-LAG)
        END DO
      PRINT *, 'CO=',CO(0)
c     WRITE(8,'(3(I5,E13.5))')
c    &   (I, 0., I, CO(I)/CO(0), I, -999.0, I=1,30)

C ------- Partial autocorrelation (Levinson's algorithm)
      SG(0) = CO(0)
      PC(1,1) = CO(1)/CO(0)
      SG(1) = SG(0)*(1. - PC(1,1)**2)
      DO IR=1,30
        IA = IR+1
        SUM = 0.0
        DO K=1,IR
          SUM = SUM + PC(IR,K)*CO(IA-K)
        END DO
        PC(IA,IA) = (CO(IA) - SUM)/SG(IR)
        DO K=1,IR
          PC(IA,K) = PC(IR,K) - PC(IA,IA)*PC(IR,IA-K)
        END DO
        SG(IA) = SG(IR)*(1. - PC(IA,IA)**2)
      END DO 

C ------- Reconstruction of AR coefficients (Levinson Recursion)
C ------- AIC and CAT criteria
      PA(1,1) = -CO(1)/CO(0)
      ERR(1) = CO(0)*(1.-PA(1,1)**2)
      AIC(0) = FLOAT(NDT)*ALOG(ERR(1))
      CAT(0) = -(1. + 1./FLOAT(NDT))/CO(0)
      TSIG = FLOAT(NDT)/FLOAT(NDT-1)*ERR(1)
      SSIG = SSIG + 1./TSIG
      DO J=2,NORD
        JM = J-1
        AIC(JM) = FLOAT(NDT)*ALOG(ERR(JM)) + 2.*FLOAT(JM)
        CAT(JM) = SSIG/FLOAT(NDT) - 1./TSIG
        SUM = 0.0
        DO K=1,JM
          SUM = SUM + PA(K,JM)*CO(J-K)
        END DO
        PA(J,J) = -(CO(J) + SUM)/ERR(JM)
        DO K=1,JM
          PA(K,J) = PA(K,JM) + PA(J,J)*PA(J-K,JM)
        END DO
        ERR(J) = ERR(JM)*(1.-PA(J,J)**2)
        TSIG = FLOAT(NDT)/FLOAT(NDT-J)*ERR(J)
        SSIG = SSIG + 1./TSIG
      END DO
      AIC(NORD) = FLOAT(NDT)*ALOG(ERR(NORD)) + 2.*FLOAT(NORD)
      CAT(NORD) = SSIG/FLOAT(NDT) - 1./TSIG

C ------- Best orders
      NPK = 1
      IAICP(NPK) = 0
      DO I=1,NORD-1
        IF (AIC(I).LT.AIC(I-1) .AND. AIC(I).LT.AIC(I+1)) THEN
          NPK = NPK + 1
          IAICP(NPK) = I
        END IF
      END DO
c     PRINT *, '  How many orders do you want to pick?'
c     READ *, NMXO
      NMXO=1
      DO IR=1,NMXO
        AICM = 1.E+10
        DO I=1,NPK
          IF (AIC(IAICP(I)) .LT. AICM) THEN
            IPK = IAICP(I)
            AICM = AIC(IPK)
          END IF
        END DO
        AIC(IPK) = 1.E+10

      WRITE(6,*) 'order=',IPK,'err=',ERR(IPK),'AC=',(PA(J,IPK),J=1,IPK)
      WRITE(6,*) 'avg=',AVG
      END DO

C ------- Prediction (best unbiased linear predictor)
      DO IR=NDT+1,NDT+NPRD
        SUM = 0.0
        DO I=1,IPK
          SUM = SUM + PA(I,IPK)*(TS(IR-I)-AVG)
        END DO
        TS(IR) = -SUM + AVG
        TPRD(IR-NDT) = TS(IR)
      END DO

      RETURN
      END

      SUBROUTINE STATS(AVG,STD,VAR,ARR,N)

      DIMENSION ARR(N)

      AVG = 0.0
      DO I=1,N
        AVG = AVG + ARR(I)
      END DO
      AVG = AVG/FLOAT(N)

      VAR = 0.0
      DO I=1,N
        VAR = VAR + (ARR(I)-AVG)**2
      END DO
      VAR = VAR/FLOAT(N)
      STD = SQRT(VAR)

      RETURN
      END

      SUBROUTINE TOEPL(CO,COV,NPTS,NDM)

C       This routine generates a Toeplitz matrix.

      DIMENSION CO(0:NPTS), COV(NPTS,NPTS)

      DO 10 I=1,NDM
      DO 10 J=1,NDM
        COV(I,J) = CO(IABS(J-I))
10    CONTINUE

      RETURN
      END

      SUBROUTINE MCHOL(COV,TRL,DIA,NPTS,NDM)

C       This routine conducts Modified Cholesky Decomposition.

      DIMENSION COV(NPTS,NPTS), TRL(NPTS,NPTS), DIA(NPTS)

C ------- Modified Cholesky decomposition
      DIA(1) = COV(1,1)
      TRL(1,1) = 1.
      DO I=2,NDM
        DO J=1,I-1
          SUM = 0.0
          DO L=1,J-1
            SUM = SUM + TRL(I,L)*DIA(L)*TRL(J,L)
          END DO
          TRL(I,J) = (COV(I,J) - SUM)/DIA(J)
        END DO
        SUM = 0.0
        DO L=1,I-1
          SUM = SUM + DIA(L)*TRL(I,L)**2
        END DO
        DIA(I) = COV(I,I) - SUM
        TRL(I,I) = 1.
      END DO

      RETURN
      END
      SUBROUTINE LUDCMP(A,N,NP,INDX,D)

C       Given an N x N matrix A, with physical dimension NP, this routine
C       replaces it by the LU decomposition of a rowwise permutation of
C       itself.  A and N are input.  A is output; INDX is an output vector 
C       which records the row permutation effected by the partial pivoting;
C       D is output as +/-1 depending on whether the number of row 
C       interchanges was even or odd, respectively.  This routine is used
C       in combination with LUBKSBR to solve linear equations or invert a 
C       matrix.

      PARAMETER (NMAX=9000, TINY=1.0E-20)
      DIMENSION INDX(N), VV(NMAX), A(NP,NP)


        D = 1.
C ---------- Find maximum entry in each row -- scaling factor
      DO 10 I=1,N
          AAMAX = 0.
        DO 5 J=1,N
          IF (ABS(A(I,J)) .GT. AAMAX)  AAMAX = ABS(A(I,J))
5       CONTINUE
        IF (AAMAX .EQ. 0.)  STOP
        VV(I) = 1./AAMAX
10    CONTINUE

C ---------- LU decomposition
      DO 50 J=1,N
        IF (J .GT. 1)  THEN
          DO 20 I=1,J-1
            SUM = A(I,J)
            IF (I .GT. 1)  THEN
              DO 15 K=1,I-1
                SUM = SUM - A(I,K)*A(K,J)
15            CONTINUE
              A(I,J) = SUM
            END IF
20        CONTINUE
        END IF

          AAMAX = 0.
        DO 30 I=J,N
          SUM = A(I,J)
          IF (J .GT. 1)  THEN
            DO 25 K=1,J-1
              SUM = SUM - A(I,K)*A(K,J)
25          CONTINUE
            A(I,J) = SUM
          END IF
          DUM = VV(I)*ABS(SUM)
          IF (DUM .GE. AAMAX)  THEN
            IMAX = I
            AAMAX = DUM
          END IF
30      CONTINUE

        IF (J .NE. IMAX)  THEN
          DO 35 K=1,N
            CUM = A(IMAX,K)
            A(IMAX,K) = A(J,K)
            A(J,K) = CUM
35        CONTINUE
          D = -D
          VV(IMAX) = VV(J)
        END IF
        INDX(J) = IMAX
        IF (J .NE. N)  THEN
          IF (A(J,J) .EQ. 0.)  A(J,J) = TINY
          CUM = 1./A(J,J)
          DO 40 I=J+1,N
            A(I,J) = A(I,J)*CUM
40        CONTINUE
        END IF
50    CONTINUE
      IF (A(N,N) .EQ. 0.)  A(N,N) = TINY

      RETURN
      END

      SUBROUTINE LUBKSB(A,N,NP,INDX,B)

C       Solves the set of N linear equations AX = B.  Here A is input, not
C       as the matrix A but as its LU decomposition, determined by the routine 
C       LUDCMP.  INDX is input as the permutation vector returned by LUDCMP.
C       B is input as the right-hand side vector B, and returns with the 
C       solution vector X.  A, N, NP and INDX are not modified by this routine
C       and can be left in place for successive calls with different right-
C       hand sides B.  This routine takes into account the possibility that 
C       B will begin with many zero elements, so it is efficient for use in
C       matrix inversion.

      DIMENSION INDX(N), A(NP,NP), B(N)


C ---------- Ly = b
        II = 0
      DO 10 I=1,N
        LL = INDX(I)
        SUM = B(LL)
        B(LL) = B(I)
        IF (II .NE. 0)  THEN
          DO 5 J=II,I-1
            SUM = SUM - A(I,J)*B(J)
5         CONTINUE
        ELSE IF (SUM .NE. 0.)  THEN
          II = I
        END IF
        B(I) = SUM
10    CONTINUE

C ---------- Ux = y
      DO 20 I=N,1,-1
        SUM = B(I)
        IF (I .LT. N)  THEN
          DO 15 J=I+1,N
            SUM = SUM - A(I,J)*B(J)
15        CONTINUE
        END IF
        B(I) = SUM/A(I,I)
20    CONTINUE

      RETURN
      END

