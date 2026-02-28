C       PROGRAM NAME = ar_mod.f
C       PROGRAMMER = Dr. Kwang-Y. Kim
C       CODE IDENTIFICATION NUMBER = AR_MOD/VERSION 1.0
C       CODE CLASSIFICATION = Scientific Computer Code
C       CREATION DATE = November 14, 1995
C       REVISION DATE = not revised
C       REVISION INFORMATION : not applicable
C
C *****************************************************************************

C       This program computes the AR model.


      PARAMETER (NPTS=9000, NORD=300) 
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

C ------- Analysis option
      PRINT *, '  Set the following option parameters.'
      PRINT *, '  IO1: create (=0) or read (=1) AR time series'
      PRINT *, '  IO2: sample (=0) or exact (=1) covariance function'
      PRINT *, '  IO3: confidence band for the spectral density ft'
      PRINT *, '       0: no   1: 80%   2: 90%   3: 95%   4:99%'
      PRINT *, '  IO4: peak confidence band'
      PRINT *, '       0: no   1: 80%   2: 90%   3: 95%   4:99%'
      PRINT *, '  IO5: prediction and confidence band'
      PRINT *, '       negative #: no prediction'
      PRINT *, '       0: no   1: 80%   2: 90%   3: 95%   4:99%'
      READ *, IO1, IO2, IO3, IO4, IO5

      OPEN(UNIT=8, FILE='corr.d', STATUS='UNKNOWN')
      OPEN(UNIT=9, FILE='pcorr.d', STATUS='UNKNOWN')
      OPEN(UNIT=10, FILE='crit.d', STATUS='UNKNOWN')
      OPEN(UNIT=11, FILE='arcf.d', STATUS='UNKNOWN')
      OPEN(UNIT=12, FILE='spec.d', STATUS='UNKNOWN')
      OPEN(UNIT=13, FILE='prdt.d', STATUS='UNKNOWN')

      IF (IO1.EQ.0) THEN
        PRINT *, '  Type the name and format of the input noise file.'
        READ 5, FILNMI, FORMTI
        PRINT *, '  Type the number of lines to skip.'
        READ *, NSKIP
        PRINT *, '  Type the number of data points.'
        READ *, NDT
        PRINT *, '  Type variance of white noise time series.'
        READ *, SIG
        OPEN(UNIT=4, FILE=FILNMI, STATUS='OLD')
        DO K=1,NSKIP
          READ(4,FORMTI)  SCR
        END DO
        READ(4,FORMTI)  (RN(I), I=1,2*NDT)
        PRINT *, '  Type the AR order.'
        READ *, IP
        PRINT *, '  Type the AR coefficients.'
        READ *, (A(I), I=1,IP)
        A(0) = 1.
        DO IR=IP+1,2*NDT
          SUM = 0.0
          DO I=1,IP
            SUM = SUM + A(I)*TS(IR-I)
          END DO
          TS(IR) = RN(IR)*SQRT(SIG) - SUM
        END DO
        DO I=1,NDT
          TS(I) = TS(I+NDT)
        END DO
        OPEN(UNIT=7, FILE='ts.d', STATUS='UNKNOWN')
        WRITE(7,'(6E13.5)')  (TS(I), I=1,NDT)
        CLOSE(UNIT=7)
      ELSE IF (IO1.EQ.1) THEN
        PRINT *, '  Type the name and format of the input data file.'
        READ 5, FILNMI, FORMTI
        PRINT *, '  Type the number of lines to skip.'
        READ *, NSKP
        PRINT *, '  Type the number of data points.'
        READ *, NDT
        OPEN(UNIT=4, FILE=FILNMI, STATUS='OLD')
        DO I=1,NSKP
          READ(4,FORMTI)  SCR
        END DO
        READ(4,FORMTI)  (TS(I), I=1,NDT)
      END IF
5     FORMAT(A50)

C ------- Calculate avg, std and var of the time series
      CALL STATS(AVG,STD,VAR,TS,NDT)

C ------- Calculate the covariance function
C ---------- covariance function using Levinson's algorithm
      IF (IO2.EQ.1) THEN
        DO K=1,NORD
          PA(K,NORD) = A(K)
        END DO
        DO J=NORD-1,1,-1
          J1 = J+1
          DO K=1,J
            PA(K,J) = (PA(K,J1) - PA(J1,J1)*PA(J1-K,J1))
     &              / (1. - PA(J1,J1)**2)
          END DO
        END DO
        CO(0) = SIG
        DO K=1,NORD
          CO(0) = CO(0)/(1. - PA(K,K)**2)
        END DO
        DO IR=1,31
          JMAX = MIN(IR,NORD)
          IRMX = MIN(IR,NORD)
          SUM = 0.0
          DO J=1,JMAX
            SUM = SUM + PA(J,IRMX)*CO(IR-J)
          END DO
          CO(IR) = -SUM
        END DO 
C ---------- sample covariance function
      ELSE IF (IO2.EQ.0) THEN
        DO LAG=0,NORD
          SUM = 0.0
          DO I=1,NDT-LAG
            SUM = SUM + (TS(I)-AVG)*(TS(I+LAG)-AVG)
          END DO
          CO(LAG) = SUM/FLOAT(NDT)
C          CO(LAG) = SUM/FLOAT(NDT-LAG)
        END DO
      END IF
      PRINT *, CO(0)
      WRITE(8,'(3(I5,E13.5))')
     &   (I, 0., I, CO(I)/CO(0), I, -999.0, I=1,30)

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
      WRITE(9,'(3(I5,E13.5))')
     &   (I, 0., I, PC(I,I), I, -999.0, I=1,30)

      IF (IO1.EQ.0)  GO TO 25
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
      WRITE(10,'(6E13.5)')  (AIC(I), I=0,NORD)
      WRITE(10,'(6E13.5)')  (CAT(I), I=0,NORD)

C ------- Best orders
      NPK = 1
      IAICP(NPK) = 0
      DO I=1,NORD-1
        IF (AIC(I).LT.AIC(I-1) .AND. AIC(I).LT.AIC(I+1)) THEN
          NPK = NPK + 1
          IAICP(NPK) = I
        END IF
      END DO
      PRINT *, '  How many orders do you want to pick?'
      READ *, NMXO
      DO IR=1,NMXO
        AICM = 1.E+10
        DO I=1,NPK
          IF (AIC(IAICP(I)) .LT. AICM) THEN
            IPK = IAICP(I)
            AICM = AIC(IPK)
          END IF
        END DO
        AIC(IPK) = 1.E+10

        WRITE(11,10)  IPK, ERR(IPK), (PA(J,IPK), J=1,IPK)
        WRITE(6,10)  IPK, ERR(IPK), (PA(J,IPK), J=1,IPK)
10      FORMAT('AIC ORDER = ',I5,/,
     &         'Error Variance:',E13.5,/,
     &         'AR Coefficients:',10(/,6E13.5))
      END DO

      NPK = 1
      ICATP(NPK) = 0
      DO I=1,NORD-1
        IF (CAT(I).LT.CAT(I-1) .AND. CAT(I).LT.CAT(I+1)) THEN
          NPK = NPK + 1
          ICATP(NPK) = I
        END IF
      END DO
      DO IR=1,NMXO
        CATM = 1.E+10
        DO I=1,NPK
          IF (CAT(ICATP(I)) .LT. CATM) THEN
            IPK = ICATP(I)
            CATM = CAT(IPK)
          END IF
        END DO
        CAT(IPK) = 1.E+10

        WRITE(11,15)  IPK, ERR(IPK), (PA(J,IPK), J=1,IPK)
        WRITE(6,15)  IPK, ERR(IPK), (PA(J,IPK), J=1,IPK)
15      FORMAT('CAT Order =',I5,/,
     &         'Error Variance:',E13.5,/,
     &         'AR Coefficients:',10(/,6E13.5))
      END DO

C ------- Choose an order
20    CONTINUE
      PRINT *, '  Type the order of AR model for a spectral density.'
      READ(5,*,ERR=200) IP
      SIG = ERR(IP)
      A(0) = 1.
      DO J=1,IP
        A(J) = PA(J,IP)
      END DO

25    CONTINUE
      IF (IO3.EQ.0)  GO TO 70
C ------- Schur matrix
      DO 30 J=1,IP
      DO 30 I=1,IP
        AM(I,J) = 0.0
        BM(I,J) = 0.0
30    CONTINUE
      DO 35 I=1,IP
      DO 35 J=1,I
        AM(I,J) = A(IABS(I-J))
        BM(I,J) = A(IABS(IP-I+J))
35    CONTINUE
      DO 40 I=1,IP
      DO 40 J=1,IP
        SUM1 = 0.0
        SUM2 = 0.0
        DO K=1,IP
          SUM1 = SUM1 + AM(I,K)*AM(J,K)
          SUM2 = SUM2 + BM(I,K)*BM(J,K)
        END DO
        SMAT(I,J) = SUM1 - SUM2
40    CONTINUE
      SMAT(IP+1,IP+1) = 2./SIG**2

C ------- Vector Gamma
      DO I=0,IP
        GAM(I) = 0.
        DO J=0,IP-I
          GAM(I) = GAM(I) + A(J)*A(J+I)
        END DO
        GAM(I) = GAM(I)/SIG
      END DO

C ------- Matrix B
      DO 50 J=1,IP+1
        BMAT(J,IP+1) = SIG*GAM(J-1)
      DO 50 K=1,IP
        IF (K+J-1.GT.IP) THEN
          CA1 = 0.
        ELSE
          CA1 = A(K+J-1)
        END IF
        IF ((K-J+1.GT.IP) .OR. (K-J+1.LT.0)) then
          CA2 = 0.
        ELSE
          CA2 = A(K-J+1)
        END IF
        BMAT(J,K) = CA1*CA2/SIG
50    CONTINUE

C ------- Matrix D
      DO 60 I=1,IP+1
      DO 60 J=1,IP+1
        SUM = 0.
        DO 55 K=1,IP+1
        DO 55 L=1,IP+1
          SUM = SUM + BMAT(I,K)*SMAT(K,L)*BMAT(J,L)
55      CONTINUE
        DMAT(I,J) = SUM
60    CONTINUE

70    CONTINUE
C ------- Calculate the spectral density from impulse response function
      DOMG = 0.5/FLOAT(NDT)
      DO 80 IR=0,NDT
        OMG = TPI*FLOAT(IR)*DOMG
        ARG = (0.,0.)
        DO K=0,IP
          ARG = ARG + A(K)*CEXP(JIMAG*OMG*FLOAT(K))
        END DO
        SP(IR) = SIG/CABS(ARG)**2
        IF (IO3.EQ.0)  GO TO 80
C ---------- error bound
        X(1) = 1.
        DO I=2,IP+1
          X(I) = 2.*COS(OMG*FLOAT(I-1))
        END DO
        SUM = 0.
        DO 75 J=1,IP+1
        DO 75 K=1,IP+1
          SUM = SUM + X(J)*DMAT(J,K)*X(K)
75      CONTINUE
        SUM = SQRT(XI(IO3,IP+1)*SUM/FLOAT(NDT))
        SPL = MAX(1./(1./SP(IR) + SUM)/VAR, EXP(-6.))
        IF (SUM .GT. 1./SP(IR)) THEN
          SPU = EXP(6.)
        ELSE
          SPU = 1./(1./SP(IR) - SUM)/VAR
        END IF
        WRITE(12,'(6E13.5)')  ALOG(SPL), ALOG(SP(IR)/VAR), ALOG(SPU)
80    CONTINUE
      IF (IO3.EQ.0)  WRITE(12,'(6E13.5)')  (ALOG(SP(IR)/VAR), IR=0,NDT)

C ------- Peak frequency
      IF (IO4.EQ.0)  GO TO 130
      NPK = 0
      DO I=1,NDT-1
        IF (SP(I).GT.SP(I-1) .AND. SP(I).GT.SP(I+1)) THEN
          NPK = NPK + 1
          IAICP(NPK) = I
        END IF
      END DO
      WRITE(6,90)  (IAICP(I), SP(IAICP(I)), I=1,NPK)
90    FORMAT(5(I4,E12.5))

95    PRINT *, '  Type the peak frequency number.'
      READ(5,*,ERR=130)  IPK

      OMG = FLOAT(IPK)*DOMG
C      H1 = 1./SP(IPK-1)
C      H2 = 1./SP(IPK)
C      H3 = 1./SP(IPK+1)
C      HP = SIG*(H1 - 2.*H2 + H3)/(DOMG*DOMG)
      HP = 0.
      DO I=1,IP
        HP = HP + FLOAT(I)**2*GAM(I)*COS(TPI*FLOAT(I)*OMG)
      END DO
      HP = -8*PI**2*HP*SIG

      DO I=1,IP
        X(I) = FLOAT(I)*SIN(TPI*FLOAT(I)*OMG)
      END DO

      DO 100 I=1,IP
      DO 100 J=1,IP
        K1 = I+J
        K2 = J-I
        IF ((K1.LT.0) .OR. (K1.GT.IP)) THEN
          CA1 = 0.0
        ELSE
          CA1 = A(K1)
        END IF
        IF ((K2.LT.0) .OR. (K2.GT.IP)) THEN
          CA2 = 0.0
        ELSE
          CA2 = A(K2)
        END IF
        CMAT(I,J) = CA1 + CA2
100   CONTINUE

      DO 110 I=1,IP
      DO 110 J=1,IP
        SUM = 0.0
        DO 105 K=1,IP
        DO 105 L=1,IP
          SUM = SUM + CMAT(I,K)*SMAT(K,L)*CMAT(J,L)
105     CONTINUE
        DMAT(I,J) = SUM
110   CONTINUE

      SUM = 0.
      DO 120 J=1,IP
      DO 120 K=1,IP
        SUM = SUM + X(J)*DMAT(J,K)*X(K)
120   CONTINUE
      STD = SQRT(SUM/(HP/TPI)**2)
      OMG1 = OMG - ZA(IO4)*STD/SQRT(FLOAT(NDT))
      OMG2 = OMG + ZA(IO4)*STD/SQRT(FLOAT(NDT))
      PRINT *, OMG1, OMG, OMG2
      PRINT *, 1./OMG2, 1./OMG, 1./OMG1
      GO TO 95

130   CONTINUE
      IF (IO5.LT.0)  GO TO 200
C ------- Prediction (best unbiased linear predictor)
      PRINT *, '  Type how many points you want to predict.'
      READ *, NPRD
      IF (IO5.GT.0)  GO TO 140
C ---------- direct method 
      DO IR=NDT+1,NDT+NPRD
        SUM = 0.0
        DO I=1,IP
          SUM = SUM + A(I)*(TS(IR-I)-AVG)
        END DO
        TS(IR) = -SUM + AVG
      END DO
      WRITE(13,'(6E13.5)')  (TS(I), I=1,NDT+NPRD)
      GO TO 150
C ---------- modified Cholesky decomposition method
140   CONTINUE
      DO K=1,NORD
        PA(K,NORD) = A(K)
      END DO
      DO J=NORD-1,1,-1
        J1 = J+1
        DO K=1,J
          PA(K,J) = (PA(K,J1) - PA(J1,J1)*PA(J1-K,J1))
     &            / (1. - PA(J1,J1)**2)
        END DO
      END DO
      CO(0) = SIG
      DO K=1,NORD
        CO(0) = CO(0)/(1. - PA(K,K)**2)
      END DO
      DO IR=1,NDT+NPRD
        JMAX = MIN(IR,NORD)
        IRMX = MIN(IR,NORD)
        SUM = 0.0
        DO J=1,JMAX
          SUM = SUM + PA(J,IRMX)*CO(IR-J)
        END DO
        CO(IR) = -SUM
      END DO 
      CALL TOEPL(CO,COV,NPTS,NDT+NPRD)
      CALL MCHOL(COV,TRL,DIA,NPTS,NDT+NPRD)
      EPS(1) = TS(1) - AVG
      DO IR=2,NDT+NPRD
        SUM = 0.0
        DO I=1,IR-1
          SUM = SUM + TRL(IR,I)*EPS(I)
        END DO
        EPS(IR) = TS(IR) - AVG - SUM
      END DO
      DO IR=NDT+1,NDT+NPRD
        SUM = 0.0
        DO I=IR-NDT,IR-1
          SUM = SUM + TRL(IR,IR-I)*EPS(IR-I)
        END DO
        TS(IR) = SUM + AVG
      END DO
      DO IR=NDT+1,NDT+NPRD
        SUM = 0.0
        DO I=0,IR-NDT-1
          SUM = SUM + TRL(IR,IR-I)**2*DIA(IR-I)
        END DO
        EPS(IR) = ZA(IO5)*SQRT(SUM)
      END DO
      WRITE(13,'(3E13.5)')  (SPVAL, TS(I), SPVAL, I=1,NDT)
      WRITE(13,'(3E13.5)')
     &   (TS(I)-EPS(I), TS(I), TS(I)+EPS(I), I=NDT+1,NDT+NPRD)

C ------- Repeat for other AR spectra
150   IF (IO1.EQ.1)  GO TO 20

200   STOP
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
      ENDPROGRAM NAME = ar_mod.f
C       PROGRAMMER = Dr. Kwang-Y. Kim
C       CODE IDENTIFICATION NUMBER = AR_MOD/VERSION 1.0
C       CODE CLASSIFICATION = Scientific Computer Code
C       CREATION DATE = November 14, 1995
C       REVISION DATE = not revised
C       REVISION INFORMATION : not applicable
C
C *****************************************************************************

C       This program computes the AR model.


      PARAMETER (NPTS=9000, NORD=300) 
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

C ------- Analysis option
      PRINT *, '  Set the following option parameters.'
      PRINT *, '  IO1: create (=0) or read (=1) AR time series'
      PRINT *, '  IO2: sample (=0) or exact (=1) covariance function'
      PRINT *, '  IO3: confidence band for the spectral density ft'
      PRINT *, '       0: no   1: 80%   2: 90%   3: 95%   4:99%'
      PRINT *, '  IO4: peak confidence band'
      PRINT *, '       0: no   1: 80%   2: 90%   3: 95%   4:99%'
      PRINT *, '  IO5: prediction and confidence band'
      PRINT *, '       negative #: no prediction'
      PRINT *, '       0: no   1: 80%   2: 90%   3: 95%   4:99%'
      READ *, IO1, IO2, IO3, IO4, IO5

      OPEN(UNIT=8, FILE='corr.d', STATUS='UNKNOWN')
      OPEN(UNIT=9, FILE='pcorr.d', STATUS='UNKNOWN')
      OPEN(UNIT=10, FILE='crit.d', STATUS='UNKNOWN')
      OPEN(UNIT=11, FILE='arcf.d', STATUS='UNKNOWN')
      OPEN(UNIT=12, FILE='spec.d', STATUS='UNKNOWN')
      OPEN(UNIT=13, FILE='prdt.d', STATUS='UNKNOWN')

      IF (IO1.EQ.0) THEN
        PRINT *, '  Type the name and format of the input noise file.'
        READ 5, FILNMI, FORMTI
        PRINT *, '  Type the number of lines to skip.'
        READ *, NSKIP
        PRINT *, '  Type the number of data points.'
        READ *, NDT
        PRINT *, '  Type variance of white noise time series.'
        READ *, SIG
        OPEN(UNIT=4, FILE=FILNMI, STATUS='OLD')
        DO K=1,NSKIP
          READ(4,FORMTI)  SCR
        END DO
        READ(4,FORMTI)  (RN(I), I=1,2*NDT)
        PRINT *, '  Type the AR order.'
        READ *, IP
        PRINT *, '  Type the AR coefficients.'
        READ *, (A(I), I=1,IP)
        A(0) = 1.
        DO IR=IP+1,2*NDT
          SUM = 0.0
          DO I=1,IP
            SUM = SUM + A(I)*TS(IR-I)
          END DO
          TS(IR) = RN(IR)*SQRT(SIG) - SUM
        END DO
        DO I=1,NDT
          TS(I) = TS(I+NDT)
        END DO
        OPEN(UNIT=7, FILE='ts.d', STATUS='UNKNOWN')
        WRITE(7,'(6E13.5)')  (TS(I), I=1,NDT)
        CLOSE(UNIT=7)
      ELSE IF (IO1.EQ.1) THEN
        PRINT *, '  Type the name and format of the input data file.'
        READ 5, FILNMI, FORMTI
        PRINT *, '  Type the number of lines to skip.'
        READ *, NSKP
        PRINT *, '  Type the number of data points.'
        READ *, NDT
        OPEN(UNIT=4, FILE=FILNMI, STATUS='OLD')
        DO I=1,NSKP
          READ(4,FORMTI)  SCR
        END DO
        READ(4,FORMTI)  (TS(I), I=1,NDT)
      END IF
5     FORMAT(A50)

C ------- Calculate avg, std and var of the time series
      CALL STATS(AVG,STD,VAR,TS,NDT)

C ------- Calculate the covariance function
C ---------- covariance function using Levinson's algorithm
      IF (IO2.EQ.1) THEN
        DO K=1,NORD
          PA(K,NORD) = A(K)
        END DO
        DO J=NORD-1,1,-1
          J1 = J+1
          DO K=1,J
            PA(K,J) = (PA(K,J1) - PA(J1,J1)*PA(J1-K,J1))
     &              / (1. - PA(J1,J1)**2)
          END DO
        END DO
        CO(0) = SIG
        DO K=1,NORD
          CO(0) = CO(0)/(1. - PA(K,K)**2)
        END DO
        DO IR=1,31
          JMAX = MIN(IR,NORD)
          IRMX = MIN(IR,NORD)
          SUM = 0.0
          DO J=1,JMAX
            SUM = SUM + PA(J,IRMX)*CO(IR-J)
          END DO
          CO(IR) = -SUM
        END DO 
C ---------- sample covariance function
      ELSE IF (IO2.EQ.0) THEN
        DO LAG=0,NORD
          SUM = 0.0
          DO I=1,NDT-LAG
            SUM = SUM + (TS(I)-AVG)*(TS(I+LAG)-AVG)
          END DO
          CO(LAG) = SUM/FLOAT(NDT)
C          CO(LAG) = SUM/FLOAT(NDT-LAG)
        END DO
      END IF
      PRINT *, CO(0)
      WRITE(8,'(3(I5,E13.5))')
     &   (I, 0., I, CO(I)/CO(0), I, -999.0, I=1,30)

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
      WRITE(9,'(3(I5,E13.5))')
     &   (I, 0., I, PC(I,I), I, -999.0, I=1,30)

      IF (IO1.EQ.0)  GO TO 25
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
      WRITE(10,'(6E13.5)')  (AIC(I), I=0,NORD)
      WRITE(10,'(6E13.5)')  (CAT(I), I=0,NORD)

C ------- Best orders
      NPK = 1
      IAICP(NPK) = 0
      DO I=1,NORD-1
        IF (AIC(I).LT.AIC(I-1) .AND. AIC(I).LT.AIC(I+1)) THEN
          NPK = NPK + 1
          IAICP(NPK) = I
        END IF
      END DO
      PRINT *, '  How many orders do you want to pick?'
      READ *, NMXO
      DO IR=1,NMXO
        AICM = 1.E+10
        DO I=1,NPK
          IF (AIC(IAICP(I)) .LT. AICM) THEN
            IPK = IAICP(I)
            AICM = AIC(IPK)
          END IF
        END DO
        AIC(IPK) = 1.E+10

        WRITE(11,10)  IPK, ERR(IPK), (PA(J,IPK), J=1,IPK)
        WRITE(6,10)  IPK, ERR(IPK), (PA(J,IPK), J=1,IPK)
10      FORMAT('AIC ORDER = ',I5,/,
     &         'Error Variance:',E13.5,/,
     &         'AR Coefficients:',10(/,6E13.5))
      END DO

      NPK = 1
      ICATP(NPK) = 0
      DO I=1,NORD-1
        IF (CAT(I).LT.CAT(I-1) .AND. CAT(I).LT.CAT(I+1)) THEN
          NPK = NPK + 1
          ICATP(NPK) = I
        END IF
      END DO
      DO IR=1,NMXO
        CATM = 1.E+10
        DO I=1,NPK
          IF (CAT(ICATP(I)) .LT. CATM) THEN
            IPK = ICATP(I)
            CATM = CAT(IPK)
          END IF
        END DO
        CAT(IPK) = 1.E+10

        WRITE(11,15)  IPK, ERR(IPK), (PA(J,IPK), J=1,IPK)
        WRITE(6,15)  IPK, ERR(IPK), (PA(J,IPK), J=1,IPK)
15      FORMAT('CAT Order =',I5,/,
     &         'Error Variance:',E13.5,/,
     &         'AR Coefficients:',10(/,6E13.5))
      END DO

C ------- Choose an order
20    CONTINUE
      PRINT *, '  Type the order of AR model for a spectral density.'
      READ(5,*,ERR=200) IP
      SIG = ERR(IP)
      A(0) = 1.
      DO J=1,IP
        A(J) = PA(J,IP)
      END DO

25    CONTINUE
      IF (IO3.EQ.0)  GO TO 70
C ------- Schur matrix
      DO 30 J=1,IP
      DO 30 I=1,IP
        AM(I,J) = 0.0
        BM(I,J) = 0.0
30    CONTINUE
      DO 35 I=1,IP
      DO 35 J=1,I
        AM(I,J) = A(IABS(I-J))
        BM(I,J) = A(IABS(IP-I+J))
35    CONTINUE
      DO 40 I=1,IP
      DO 40 J=1,IP
        SUM1 = 0.0
        SUM2 = 0.0
        DO K=1,IP
          SUM1 = SUM1 + AM(I,K)*AM(J,K)
          SUM2 = SUM2 + BM(I,K)*BM(J,K)
        END DO
        SMAT(I,J) = SUM1 - SUM2
40    CONTINUE
      SMAT(IP+1,IP+1) = 2./SIG**2

C ------- Vector Gamma
      DO I=0,IP
        GAM(I) = 0.
        DO J=0,IP-I
          GAM(I) = GAM(I) + A(J)*A(J+I)
        END DO
        GAM(I) = GAM(I)/SIG
      END DO

C ------- Matrix B
      DO 50 J=1,IP+1
        BMAT(J,IP+1) = SIG*GAM(J-1)
      DO 50 K=1,IP
        IF (K+J-1.GT.IP) THEN
          CA1 = 0.
        ELSE
          CA1 = A(K+J-1)
        END IF
        IF ((K-J+1.GT.IP) .OR. (K-J+1.LT.0)) then
          CA2 = 0.
        ELSE
          CA2 = A(K-J+1)
        END IF
        BMAT(J,K) = CA1*CA2/SIG
50    CONTINUE

C ------- Matrix D
      DO 60 I=1,IP+1
      DO 60 J=1,IP+1
        SUM = 0.
        DO 55 K=1,IP+1
        DO 55 L=1,IP+1
          SUM = SUM + BMAT(I,K)*SMAT(K,L)*BMAT(J,L)
55      CONTINUE
        DMAT(I,J) = SUM
60    CONTINUE

70    CONTINUE
C ------- Calculate the spectral density from impulse response function
      DOMG = 0.5/FLOAT(NDT)
      DO 80 IR=0,NDT
        OMG = TPI*FLOAT(IR)*DOMG
        ARG = (0.,0.)
        DO K=0,IP
          ARG = ARG + A(K)*CEXP(JIMAG*OMG*FLOAT(K))
        END DO
        SP(IR) = SIG/CABS(ARG)**2
        IF (IO3.EQ.0)  GO TO 80
C ---------- error bound
        X(1) = 1.
        DO I=2,IP+1
          X(I) = 2.*COS(OMG*FLOAT(I-1))
        END DO
        SUM = 0.
        DO 75 J=1,IP+1
        DO 75 K=1,IP+1
          SUM = SUM + X(J)*DMAT(J,K)*X(K)
75      CONTINUE
        SUM = SQRT(XI(IO3,IP+1)*SUM/FLOAT(NDT))
        SPL = MAX(1./(1./SP(IR) + SUM)/VAR, EXP(-6.))
        IF (SUM .GT. 1./SP(IR)) THEN
          SPU = EXP(6.)
        ELSE
          SPU = 1./(1./SP(IR) - SUM)/VAR
        END IF
        WRITE(12,'(6E13.5)')  ALOG(SPL), ALOG(SP(IR)/VAR), ALOG(SPU)
80    CONTINUE
      IF (IO3.EQ.0)  WRITE(12,'(6E13.5)')  (ALOG(SP(IR)/VAR), IR=0,NDT)

C ------- Peak frequency
      IF (IO4.EQ.0)  GO TO 130
      NPK = 0
      DO I=1,NDT-1
        IF (SP(I).GT.SP(I-1) .AND. SP(I).GT.SP(I+1)) THEN
          NPK = NPK + 1
          IAICP(NPK) = I
        END IF
      END DO
      WRITE(6,90)  (IAICP(I), SP(IAICP(I)), I=1,NPK)
90    FORMAT(5(I4,E12.5))

95    PRINT *, '  Type the peak frequency number.'
      READ(5,*,ERR=130)  IPK

      OMG = FLOAT(IPK)*DOMG
C      H1 = 1./SP(IPK-1)
C      H2 = 1./SP(IPK)
C      H3 = 1./SP(IPK+1)
C      HP = SIG*(H1 - 2.*H2 + H3)/(DOMG*DOMG)
      HP = 0.
      DO I=1,IP
        HP = HP + FLOAT(I)**2*GAM(I)*COS(TPI*FLOAT(I)*OMG)
      END DO
      HP = -8*PI**2*HP*SIG

      DO I=1,IP
        X(I) = FLOAT(I)*SIN(TPI*FLOAT(I)*OMG)
      END DO

      DO 100 I=1,IP
      DO 100 J=1,IP
        K1 = I+J
        K2 = J-I
        IF ((K1.LT.0) .OR. (K1.GT.IP)) THEN
          CA1 = 0.0
        ELSE
          CA1 = A(K1)
        END IF
        IF ((K2.LT.0) .OR. (K2.GT.IP)) THEN
          CA2 = 0.0
        ELSE
          CA2 = A(K2)
        END IF
        CMAT(I,J) = CA1 + CA2
100   CONTINUE

      DO 110 I=1,IP
      DO 110 J=1,IP
        SUM = 0.0
        DO 105 K=1,IP
        DO 105 L=1,IP
          SUM = SUM + CMAT(I,K)*SMAT(K,L)*CMAT(J,L)
105     CONTINUE
        DMAT(I,J) = SUM
110   CONTINUE

      SUM = 0.
      DO 120 J=1,IP
      DO 120 K=1,IP
        SUM = SUM + X(J)*DMAT(J,K)*X(K)
120   CONTINUE
      STD = SQRT(SUM/(HP/TPI)**2)
      OMG1 = OMG - ZA(IO4)*STD/SQRT(FLOAT(NDT))
      OMG2 = OMG + ZA(IO4)*STD/SQRT(FLOAT(NDT))
      PRINT *, OMG1, OMG, OMG2
      PRINT *, 1./OMG2, 1./OMG, 1./OMG1
      GO TO 95

130   CONTINUE
      IF (IO5.LT.0)  GO TO 200
C ------- Prediction (best unbiased linear predictor)
      PRINT *, '  Type how many points you want to predict.'
      READ *, NPRD
      IF (IO5.GT.0)  GO TO 140
C ---------- direct method 
      DO IR=NDT+1,NDT+NPRD
        SUM = 0.0
        DO I=1,IP
          SUM = SUM + A(I)*(TS(IR-I)-AVG)
        END DO
        TS(IR) = -SUM + AVG
      END DO
      WRITE(13,'(6E13.5)')  (TS(I), I=1,NDT+NPRD)
      GO TO 150
C ---------- modified Cholesky decomposition method
140   CONTINUE
      DO K=1,NORD
        PA(K,NORD) = A(K)
      END DO
      DO J=NORD-1,1,-1
        J1 = J+1
        DO K=1,J
          PA(K,J) = (PA(K,J1) - PA(J1,J1)*PA(J1-K,J1))
     &            / (1. - PA(J1,J1)**2)
        END DO
      END DO
      CO(0) = SIG
      DO K=1,NORD
        CO(0) = CO(0)/(1. - PA(K,K)**2)
      END DO
      DO IR=1,NDT+NPRD
        JMAX = MIN(IR,NORD)
        IRMX = MIN(IR,NORD)
        SUM = 0.0
        DO J=1,JMAX
          SUM = SUM + PA(J,IRMX)*CO(IR-J)
        END DO
        CO(IR) = -SUM
      END DO 
      CALL TOEPL(CO,COV,NPTS,NDT+NPRD)
      CALL MCHOL(COV,TRL,DIA,NPTS,NDT+NPRD)
      EPS(1) = TS(1) - AVG
      DO IR=2,NDT+NPRD
        SUM = 0.0
        DO I=1,IR-1
          SUM = SUM + TRL(IR,I)*EPS(I)
        END DO
        EPS(IR) = TS(IR) - AVG - SUM
      END DO
      DO IR=NDT+1,NDT+NPRD
        SUM = 0.0
        DO I=IR-NDT,IR-1
          SUM = SUM + TRL(IR,IR-I)*EPS(IR-I)
        END DO
        TS(IR) = SUM + AVG
      END DO
      DO IR=NDT+1,NDT+NPRD
        SUM = 0.0
        DO I=0,IR-NDT-1
          SUM = SUM + TRL(IR,IR-I)**2*DIA(IR-I)
        END DO
        EPS(IR) = ZA(IO5)*SQRT(SUM)
      END DO
      WRITE(13,'(3E13.5)')  (SPVAL, TS(I), SPVAL, I=1,NDT)
      WRITE(13,'(3E13.5)')
     &   (TS(I)-EPS(I), TS(I), TS(I)+EPS(I), I=NDT+1,NDT+NPRD)

C ------- Repeat for other AR spectra
150   IF (IO1.EQ.1)  GO TO 20

200   STOP
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
