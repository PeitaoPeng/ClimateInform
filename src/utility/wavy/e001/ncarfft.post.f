      SUBROUTINE CFFTB (N,C,WSAVE)                                      CFF00010
      DIMENSION       C(1)       ,WSAVE(1)                              CFF00020
      IF (N .EQ. 1) RETURN                                              CFF00030
      IW1 = N+N+1                                                       CFF00040
      IW2 = IW1+N+N                                                     CFF00050
      CALL CFFTB1 (N,C,WSAVE,WSAVE(IW1),WSAVE(IW2))                     CFF00060
      RETURN                                                            CFF00070
      END                                                               CFF00080
      SUBROUTINE CFFTB1 (N,C,CH,WA,IFAC)                                CFF00010
      DIMENSION       CH(1)      ,C(1)       ,WA(1)      ,IFAC(1)       CFF00020
      NF = IFAC(2)                                                      CFF00030
      NA = 0                                                            CFF00040
      L1 = 1                                                            CFF00050
      IW = 1                                                            CFF00060
      DO 116 K1=1,NF                                                    CFF00070
         IP = IFAC(K1+2)                                                CFF00080
         L2 = IP*L1                                                     CFF00090
         IDO = N/L2                                                     CFF00100
         IDOT = IDO+IDO                                                 CFF00110
         IDL1 = IDOT*L1                                                 CFF00120
         IF (IP .NE. 4) GO TO 103                                       CFF00130
         IX2 = IW+IDOT                                                  CFF00140
         IX3 = IX2+IDOT                                                 CFF00150
         IF (NA .NE. 0) GO TO 101                                       CFF00160
         CALL PASSB4 (IDOT,L1,C,CH,WA(IW),WA(IX2),WA(IX3))              CFF00170
         GO TO 102                                                      CFF00180
  101    CALL PASSB4 (IDOT,L1,CH,C,WA(IW),WA(IX2),WA(IX3))              CFF00190
  102    NA = 1-NA                                                      CFF00200
         GO TO 115                                                      CFF00210
  103    IF (IP .NE. 2) GO TO 106                                       CFF00220
         IF (NA .NE. 0) GO TO 104                                       CFF00230
         CALL PASSB2 (IDOT,L1,C,CH,WA(IW))                              CFF00240
         GO TO 105                                                      CFF00250
  104    CALL PASSB2 (IDOT,L1,CH,C,WA(IW))                              CFF00260
  105    NA = 1-NA                                                      CFF00270
         GO TO 115                                                      CFF00280
  106    IF (IP .NE. 3) GO TO 109                                       CFF00290
         IX2 = IW+IDOT                                                  CFF00300
         IF (NA .NE. 0) GO TO 107                                       CFF00310
         CALL PASSB3 (IDOT,L1,C,CH,WA(IW),WA(IX2))                      CFF00320
         GO TO 108                                                      CFF00330
  107    CALL PASSB3 (IDOT,L1,CH,C,WA(IW),WA(IX2))                      CFF00340
  108    NA = 1-NA                                                      CFF00350
         GO TO 115                                                      CFF00360
  109    IF (IP .NE. 5) GO TO 112                                       CFF00370
         IX2 = IW+IDOT                                                  CFF00380
         IX3 = IX2+IDOT                                                 CFF00390
         IX4 = IX3+IDOT                                                 CFF00400
         IF (NA .NE. 0) GO TO 110                                       CFF00410
         CALL PASSB5 (IDOT,L1,C,CH,WA(IW),WA(IX2),WA(IX3),WA(IX4))      CFF00420
         GO TO 111                                                      CFF00430
  110    CALL PASSB5 (IDOT,L1,CH,C,WA(IW),WA(IX2),WA(IX3),WA(IX4))      CFF00440
  111    NA = 1-NA                                                      CFF00450
         GO TO 115                                                      CFF00460
  112    IF (NA .NE. 0) GO TO 113                                       CFF00470
         CALL PASSB (NAC,IDOT,IP,L1,IDL1,C,C,C,CH,CH,WA(IW))            CFF00480
         GO TO 114                                                      CFF00490
  113    CALL PASSB (NAC,IDOT,IP,L1,IDL1,CH,CH,CH,C,C,WA(IW))           CFF00500
  114    IF (NAC .NE. 0) NA = 1-NA                                      CFF00510
  115    L1 = L2                                                        CFF00520
         IW = IW+(IP-1)*IDOT                                            CFF00530
  116 CONTINUE                                                          CFF00540
      IF (NA .EQ. 0) RETURN                                             CFF00550
      N2 = N+N                                                          CFF00560
      DO 117 I=1,N2                                                     CFF00570
         C(I) = CH(I)                                                   CFF00580
  117 CONTINUE                                                          CFF00590
      RETURN                                                            CFF00600
      END                                                               CFF00610
      SUBROUTINE CFFTF (N,C,WSAVE)                                      CFF00010
      DIMENSION       C(1)       ,WSAVE(1)                              CFF00020
      IF (N .EQ. 1) RETURN                                              CFF00030
      IW1 = N+N+1                                                       CFF00040
      IW2 = IW1+N+N                                                     CFF00050
      CALL CFFTF1 (N,C,WSAVE,WSAVE(IW1),WSAVE(IW2))                     CFF00060
      RETURN                                                            CFF00070
      END                                                               CFF00080
      SUBROUTINE CFFTF1 (N,C,CH,WA,IFAC)                                CFF00010
      DIMENSION       CH(1)      ,C(1)       ,WA(1)      ,IFAC(1)       CFF00020
      NF = IFAC(2)                                                      CFF00030
      NA = 0                                                            CFF00040
      L1 = 1                                                            CFF00050
      IW = 1                                                            CFF00060
      DO 116 K1=1,NF                                                    CFF00070
         IP = IFAC(K1+2)                                                CFF00080
         L2 = IP*L1                                                     CFF00090
         IDO = N/L2                                                     CFF00100
         IDOT = IDO+IDO                                                 CFF00110
         IDL1 = IDOT*L1                                                 CFF00120
         IF (IP .NE. 4) GO TO 103                                       CFF00130
         IX2 = IW+IDOT                                                  CFF00140
         IX3 = IX2+IDOT                                                 CFF00150
         IF (NA .NE. 0) GO TO 101                                       CFF00160
         CALL PASSF4 (IDOT,L1,C,CH,WA(IW),WA(IX2),WA(IX3))              CFF00170
         GO TO 102                                                      CFF00180
  101    CALL PASSF4 (IDOT,L1,CH,C,WA(IW),WA(IX2),WA(IX3))              CFF00190
  102    NA = 1-NA                                                      CFF00200
         GO TO 115                                                      CFF00210
  103    IF (IP .NE. 2) GO TO 106                                       CFF00220
         IF (NA .NE. 0) GO TO 104                                       CFF00230
         CALL PASSF2 (IDOT,L1,C,CH,WA(IW))                              CFF00240
         GO TO 105                                                      CFF00250
  104    CALL PASSF2 (IDOT,L1,CH,C,WA(IW))                              CFF00260
  105    NA = 1-NA                                                      CFF00270
         GO TO 115                                                      CFF00280
  106    IF (IP .NE. 3) GO TO 109                                       CFF00290
         IX2 = IW+IDOT                                                  CFF00300
         IF (NA .NE. 0) GO TO 107                                       CFF00310
         CALL PASSF3 (IDOT,L1,C,CH,WA(IW),WA(IX2))                      CFF00320
         GO TO 108                                                      CFF00330
  107    CALL PASSF3 (IDOT,L1,CH,C,WA(IW),WA(IX2))                      CFF00340
  108    NA = 1-NA                                                      CFF00350
         GO TO 115                                                      CFF00360
  109    IF (IP .NE. 5) GO TO 112                                       CFF00370
         IX2 = IW+IDOT                                                  CFF00380
         IX3 = IX2+IDOT                                                 CFF00390
         IX4 = IX3+IDOT                                                 CFF00400
         IF (NA .NE. 0) GO TO 110                                       CFF00410
         CALL PASSF5 (IDOT,L1,C,CH,WA(IW),WA(IX2),WA(IX3),WA(IX4))      CFF00420
         GO TO 111                                                      CFF00430
  110    CALL PASSF5 (IDOT,L1,CH,C,WA(IW),WA(IX2),WA(IX3),WA(IX4))      CFF00440
  111    NA = 1-NA                                                      CFF00450
         GO TO 115                                                      CFF00460
  112    IF (NA .NE. 0) GO TO 113                                       CFF00470
         CALL PASSF (NAC,IDOT,IP,L1,IDL1,C,C,C,CH,CH,WA(IW))            CFF00480
         GO TO 114                                                      CFF00490
  113    CALL PASSF (NAC,IDOT,IP,L1,IDL1,CH,CH,CH,C,C,WA(IW))           CFF00500
  114    IF (NAC .NE. 0) NA = 1-NA                                      CFF00510
  115    L1 = L2                                                        CFF00520
         IW = IW+(IP-1)*IDOT                                            CFF00530
  116 CONTINUE                                                          CFF00540
      IF (NA .EQ. 0) RETURN                                             CFF00550
      N2 = N+N                                                          CFF00560
      DO 117 I=1,N2                                                     CFF00570
         C(I) = CH(I)                                                   CFF00580
  117 CONTINUE                                                          CFF00590
      RETURN                                                            CFF00600
      END                                                               CFF00610
      SUBROUTINE CFFTI1 (N,WA,IFAC)                                     CFF00010
      DIMENSION       WA(1)      ,IFAC(1)    ,NTRYH(4)                  CFF00020
      DATA NTRYH(1),NTRYH(2),NTRYH(3),NTRYH(4)/3,4,2,5/                 CFF00030
      NL = N                                                            CFF00040
      NF = 0                                                            CFF00050
      J = 0                                                             CFF00060
  101 J = J+1                                                           CFF00070
      IF (J-4) 102,102,103                                              CFF00080
  102 NTRY = NTRYH(J)                                                   CFF00090
      GO TO 104                                                         CFF00100
  103 NTRY = NTRY+2                                                     CFF00110
  104 NQ = NL/NTRY                                                      CFF00120
      NR = NL-NTRY*NQ                                                   CFF00130
      IF (NR) 101,105,101                                               CFF00140
  105 NF = NF+1                                                         CFF00150
      IFAC(NF+2) = NTRY                                                 CFF00160
      NL = NQ                                                           CFF00170
      IF (NTRY .NE. 2) GO TO 107                                        CFF00180
      IF (NF .EQ. 1) GO TO 107                                          CFF00190
      DO 106 I=2,NF                                                     CFF00200
         IB = NF-I+2                                                    CFF00210
         IFAC(IB+2) = IFAC(IB+1)                                        CFF00220
  106 CONTINUE                                                          CFF00230
      IFAC(3) = 2                                                       CFF00240
  107 IF (NL .NE. 1) GO TO 104                                          CFF00250
      IFAC(1) = N                                                       CFF00260
      IFAC(2) = NF                                                      CFF00270
      TPI = 6.28318530717959                                            CFF00280
      ARGH = TPI/FLOAT(N)                                               CFF00290
      I = 2                                                             CFF00300
      L1 = 1                                                            CFF00310
      DO 110 K1=1,NF                                                    CFF00320
         IP = IFAC(K1+2)                                                CFF00330
         LD = 0                                                         CFF00340
         L2 = L1*IP                                                     CFF00350
         IDO = N/L2                                                     CFF00360
         IDOT = IDO+IDO+2                                               CFF00370
         IPM = IP-1                                                     CFF00380
         DO 109 J=1,IPM                                                 CFF00390
            I1 = I                                                      CFF00400
            WA(I-1) = 1.                                                CFF00410
            WA(I) = 0.                                                  CFF00420
            LD = LD+L1                                                  CFF00430
            FI = 0.                                                     CFF00440
            ARGLD = FLOAT(LD)*ARGH                                      CFF00450
            DO 108 II=4,IDOT,2                                          CFF00460
               I = I+2                                                  CFF00470
               FI = FI+1.                                               CFF00480
               ARG = FI*ARGLD                                           CFF00490
               WA(I-1) = COS(ARG)                                       CFF00500
               WA(I) = SIN(ARG)                                         CFF00510
  108       CONTINUE                                                    CFF00520
            IF (IP .LE. 5) GO TO 109                                    CFF00530
            WA(I1-1) = WA(I-1)                                          CFF00540
            WA(I1) = WA(I)                                              CFF00550
  109    CONTINUE                                                       CFF00560
         L1 = L2                                                        CFF00570
  110 CONTINUE                                                          CFF00580
      RETURN                                                            CFF00590
      END                                                               CFF00600
      SUBROUTINE CFFTI1 (N,WA,IFAC)                                     CFF00010
      DIMENSION       WA(1)      ,IFAC(1)    ,NTRYH(4)                  CFF00020
      DATA NTRYH(1),NTRYH(2),NTRYH(3),NTRYH(4)/3,4,2,5/                 CFF00030
      NL = N                                                            CFF00040
      NF = 0                                                            CFF00050
      J = 0                                                             CFF00060
  101 J = J+1                                                           CFF00070
      IF (J-4) 102,102,103                                              CFF00080
  102 NTRY = NTRYH(J)                                                   CFF00090
      GO TO 104                                                         CFF00100
  103 NTRY = NTRY+2                                                     CFF00110
  104 NQ = NL/NTRY                                                      CFF00120
      NR = NL-NTRY*NQ                                                   CFF00130
      IF (NR) 101,105,101                                               CFF00140
  105 NF = NF+1                                                         CFF00150
      IFAC(NF+2) = NTRY                                                 CFF00160
      NL = NQ                                                           CFF00170
      IF (NTRY .NE. 2) GO TO 107                                        CFF00180
      IF (NF .EQ. 1) GO TO 107                                          CFF00190
      DO 106 I=2,NF                                                     CFF00200
         IB = NF-I+2                                                    CFF00210
         IFAC(IB+2) = IFAC(IB+1)                                        CFF00220
  106 CONTINUE                                                          CFF00230
      IFAC(3) = 2                                                       CFF00240
  107 IF (NL .NE. 1) GO TO 104                                          CFF00250
      IFAC(1) = N                                                       CFF00260
      IFAC(2) = NF                                                      CFF00270
      TPI = 6.28318530717959                                            CFF00280
      ARGH = TPI/FLOAT(N)                                               CFF00290
      I = 2                                                             CFF00300
      L1 = 1                                                            CFF00310
      DO 110 K1=1,NF                                                    CFF00320
         IP = IFAC(K1+2)                                                CFF00330
         LD = 0                                                         CFF00340
         L2 = L1*IP                                                     CFF00350
         IDO = N/L2                                                     CFF00360
         IDOT = IDO+IDO+2                                               CFF00370
         IPM = IP-1                                                     CFF00380
         DO 109 J=1,IPM                                                 CFF00390
            I1 = I                                                      CFF00400
            WA(I-1) = 1.                                                CFF00410
            WA(I) = 0.                                                  CFF00420
            LD = LD+L1                                                  CFF00430
            FI = 0.                                                     CFF00440
            ARGLD = FLOAT(LD)*ARGH                                      CFF00450
            DO 108 II=4,IDOT,2                                          CFF00460
               I = I+2                                                  CFF00470
               FI = FI+1.                                               CFF00480
               ARG = FI*ARGLD                                           CFF00490
               WA(I-1) = COS(ARG)                                       CFF00500
               WA(I) = SIN(ARG)                                         CFF00510
  108       CONTINUE                                                    CFF00520
            IF (IP .LE. 5) GO TO 109                                    CFF00530
            WA(I1-1) = WA(I-1)                                          CFF00540
            WA(I1) = WA(I)                                              CFF00550
  109    CONTINUE                                                       CFF00560
         L1 = L2                                                        CFF00570
  110 CONTINUE                                                          CFF00580
      RETURN                                                            CFF00590
      END                                                               CFF00600
      SUBROUTINE COSQB (N,X,WSAVE)                                      COS00010
      DIMENSION       X(1)       ,WSAVE(1)                              COS00020
      DATA TSQRT2 /2.82842712474619/                                    COS00030
      IF (N-2) 101,102,103                                              COS00040
  101 X(1) = 4.*X(1)                                                    COS00050
      RETURN                                                            COS00060
  102 X1 = 4.*(X(1)+X(2))                                               COS00070
      X(2) = TSQRT2*(X(1)-X(2))                                         COS00080
      X(1) = X1                                                         COS00090
      RETURN                                                            COS00100
  103 CALL COSQB1 (N,X,WSAVE,WSAVE(N+1))                                COS00110
      RETURN                                                            COS00120
      END                                                               COS00130
      SUBROUTINE COSQB1 (N,X,W,XH)                                      COS00010
      DIMENSION       X(1)       ,W(1)       ,XH(1)                     COS00020
      NS2 = (N+1)/2                                                     COS00030
      NP2 = N+2                                                         COS00040
      DO 101 I=3,N,2                                                    COS00050
         XIM1 = X(I-1)+X(I)                                             COS00060
         X(I) = X(I)-X(I-1)                                             COS00070
         X(I-1) = XIM1                                                  COS00080
  101 CONTINUE                                                          COS00090
      X(1) = X(1)+X(1)                                                  COS00100
      MODN = MOD(N,2)                                                   COS00110
      IF (MODN .EQ. 0) X(N) = X(N)+X(N)                                 COS00120
      CALL RFFTB (N,X,XH)                                               COS00130
      DO 102 K=2,NS2                                                    COS00140
         KC = NP2-K                                                     COS00150
         XH(K) = W(K-1)*X(KC)+W(KC-1)*X(K)                              COS00160
         XH(KC) = W(K-1)*X(K)-W(KC-1)*X(KC)                             COS00170
  102 CONTINUE                                                          COS00180
      IF (MODN .EQ. 0) X(NS2+1) = W(NS2)*(X(NS2+1)+X(NS2+1))            COS00190
      DO 103 K=2,NS2                                                    COS00200
         KC = NP2-K                                                     COS00210
         X(K) = XH(K)+XH(KC)                                            COS00220
         X(KC) = XH(K)-XH(KC)                                           COS00230
  103 CONTINUE                                                          COS00240
      X(1) = X(1)+X(1)                                                  COS00250
      RETURN                                                            COS00260
      END                                                               COS00270
      SUBROUTINE COSQF (N,X,WSAVE)                                      COS00010
      DIMENSION       X(1)       ,WSAVE(1)                              COS00020
      DATA SQRT2 /1.4142135623731/                                      COS00030
      IF (N-2) 102,101,103                                              COS00040
  101 TSQX = SQRT2*X(2)                                                 COS00050
      X(2) = X(1)-TSQX                                                  COS00060
      X(1) = X(1)+TSQX                                                  COS00070
  102 RETURN                                                            COS00080
  103 CALL COSQF1 (N,X,WSAVE,WSAVE(N+1))                                COS00090
      RETURN                                                            COS00100
      END                                                               COS00110
      SUBROUTINE COSQF1 (N,X,W,XH)                                      COS00010
      DIMENSION       X(1)       ,W(1)       ,XH(1)                     COS00020
      NS2 = (N+1)/2                                                     COS00030
      NP2 = N+2                                                         COS00040
      DO 101 K=2,NS2                                                    COS00050
         KC = NP2-K                                                     COS00060
         XH(K) = X(K)+X(KC)                                             COS00070
         XH(KC) = X(K)-X(KC)                                            COS00080
  101 CONTINUE                                                          COS00090
      MODN = MOD(N,2)                                                   COS00100
      IF (MODN .EQ. 0) XH(NS2+1) = X(NS2+1)+X(NS2+1)                    COS00110
      DO 102 K=2,NS2                                                    COS00120
         KC = NP2-K                                                     COS00130
         X(K) = W(K-1)*XH(KC)+W(KC-1)*XH(K)                             COS00140
         X(KC) = W(K-1)*XH(K)-W(KC-1)*XH(KC)                            COS00150
  102 CONTINUE                                                          COS00160
      IF (MODN .EQ. 0) X(NS2+1) = W(NS2)*XH(NS2+1)                      COS00170
      CALL RFFTF (N,X,XH)                                               COS00180
      DO 103 I=3,N,2                                                    COS00190
         XIM1 = X(I-1)-X(I)                                             COS00200
         X(I) = X(I-1)+X(I)                                             COS00210
         X(I-1) = XIM1                                                  COS00220
  103 CONTINUE                                                          COS00230
      RETURN                                                            COS00240
      END                                                               COS00250
      SUBROUTINE COSQI (N,WSAVE)                                        COS00010
      DIMENSION       WSAVE(1)                                          COS00020
      DATA PIH /1.57079632679491/                                       COS00030
      DT = PIH/FLOAT(N)                                                 COS00040
      FK = 0.                                                           COS00050
      DO 101 K=1,N                                                      COS00060
         FK = FK+1.                                                     COS00070
         WSAVE(K) = COS(FK*DT)                                          COS00080
  101 CONTINUE                                                          COS00090
      CALL RFFTI (N,WSAVE(N+1))                                         COS00100
      RETURN                                                            COS00110
      END                                                               COS00120
      SUBROUTINE COST (N,X,WSAVE)                                       COS00010
      DIMENSION       X(1)       ,WSAVE(1)                              COS00020
      NM1 = N-1                                                         COS00030
      NP1 = N+1                                                         COS00040
      NS2 = N/2                                                         COS00050
      IF (N-2) 106,101,102                                              COS00060
  101 X1H = X(1)+X(2)                                                   COS00070
      X(2) = X(1)-X(2)                                                  COS00080
      X(1) = X1H                                                        COS00090
      RETURN                                                            COS00100
  102 IF (N .GT. 3) GO TO 103                                           COS00110
      X1P3 = X(1)+X(3)                                                  COS00120
      TX2 = X(2)+X(2)                                                   COS00130
      X(2) = X(1)-X(3)                                                  COS00140
      X(1) = X1P3+TX2                                                   COS00150
      X(3) = X1P3-TX2                                                   COS00160
      RETURN                                                            COS00170
  103 C1 = X(1)-X(N)                                                    COS00180
      X(1) = X(1)+X(N)                                                  COS00190
      DO 104 K=2,NS2                                                    COS00200
         KC = NP1-K                                                     COS00210
         T1 = X(K)+X(KC)                                                COS00220
         T2 = X(K)-X(KC)                                                COS00230
         C1 = C1+WSAVE(KC)*T2                                           COS00240
         T2 = WSAVE(K)*T2                                               COS00250
         X(K) = T1-T2                                                   COS00260
         X(KC) = T1+T2                                                  COS00270
  104 CONTINUE                                                          COS00280
      MODN = MOD(N,2)                                                   COS00290
      IF (MODN .NE. 0) X(NS2+1) = X(NS2+1)+X(NS2+1)                     COS00300
      CALL RFFTF (NM1,X,WSAVE(N+1))                                     COS00310
      XIM2 = X(2)                                                       COS00320
      X(2) = C1                                                         COS00330
      DO 105 I=4,N,2                                                    COS00340
         XI = X(I)                                                      COS00350
         X(I) = X(I-2)-X(I-1)                                           COS00360
         X(I-1) = XIM2                                                  COS00370
         XIM2 = XI                                                      COS00380
  105 CONTINUE                                                          COS00390
      IF (MODN .NE. 0) X(N) = XIM2                                      COS00400
  106 RETURN                                                            COS00410
      END                                                               COS00420
      SUBROUTINE COSTI (N,WSAVE)                                        COS00010
      DIMENSION       WSAVE(1)                                          COS00020
      DATA PI /3.14159265358979/                                        COS00030
      IF (N .LE. 3) RETURN                                              COS00040
      NM1 = N-1                                                         COS00050
      NP1 = N+1                                                         COS00060
      NS2 = N/2                                                         COS00070
      DT = PI/FLOAT(NM1)                                                COS00080
      FK = 0.                                                           COS00090
      DO 101 K=2,NS2                                                    COS00100
         KC = NP1-K                                                     COS00110
         FK = FK+1.                                                     COS00120
         WSAVE(K) = 2.*SIN(FK*DT)                                       COS00130
         WSAVE(KC) = 2.*COS(FK*DT)                                      COS00140
  101 CONTINUE                                                          COS00150
      CALL RFFTI (NM1,WSAVE(N+1))                                       COS00160
      RETURN                                                            COS00170
      END                                                               COS00180
      SUBROUTINE EZFFT1 (N,WA,IFAC)                                     EZF00010
      DIMENSION       WA(1)      ,IFAC(1)    ,NTRYH(4)                  EZF00020
      DATA NTRYH(1),NTRYH(2),NTRYH(3),NTRYH(4)/4,2,3,5/                 EZF00030
     1    ,TPI/6.28318530717959/                                        EZF00040
      NL = N                                                            EZF00050
      NF = 0                                                            EZF00060
      J = 0                                                             EZF00070
  101 J = J+1                                                           EZF00080
      IF (J-4) 102,102,103                                              EZF00090
  102 NTRY = NTRYH(J)                                                   EZF00100
      GO TO 104                                                         EZF00110
  103 NTRY = NTRY+2                                                     EZF00120
  104 NQ = NL/NTRY                                                      EZF00130
      NR = NL-NTRY*NQ                                                   EZF00140
      IF (NR) 101,105,101                                               EZF00150
  105 NF = NF+1                                                         EZF00160
      IFAC(NF+2) = NTRY                                                 EZF00170
      NL = NQ                                                           EZF00180
      IF (NTRY .NE. 2) GO TO 107                                        EZF00190
      IF (NF .EQ. 1) GO TO 107                                          EZF00200
      DO 106 I=2,NF                                                     EZF00210
         IB = NF-I+2                                                    EZF00220
         IFAC(IB+2) = IFAC(IB+1)                                        EZF00230
  106 CONTINUE                                                          EZF00240
      IFAC(3) = 2                                                       EZF00250
  107 IF (NL .NE. 1) GO TO 104                                          EZF00260
      IFAC(1) = N                                                       EZF00270
      IFAC(2) = NF                                                      EZF00280
      ARGH = TPI/FLOAT(N)                                               EZF00290
      IS = 0                                                            EZF00300
      NFM1 = NF-1                                                       EZF00310
      L1 = 1                                                            EZF00320
      IF (NFM1 .EQ. 0) RETURN                                           EZF00330
      DO 111 K1=1,NFM1                                                  EZF00340
         IP = IFAC(K1+2)                                                EZF00350
         L2 = L1*IP                                                     EZF00360
         IDO = N/L2                                                     EZF00370
         IPM = IP-1                                                     EZF00380
         ARG1 = FLOAT(L1)*ARGH                                          EZF00390
         CH1 = 1.                                                       EZF00400
         SH1 = 0.                                                       EZF00410
         DCH1 = COS(ARG1)                                               EZF00420
         DSH1 = SIN(ARG1)                                               EZF00430
         DO 110 J=1,IPM                                                 EZF00440
            CH1H = DCH1*CH1-DSH1*SH1                                    EZF00450
            SH1 = DCH1*SH1+DSH1*CH1                                     EZF00460
            CH1 = CH1H                                                  EZF00470
            I = IS+2                                                    EZF00480
            WA(I-1) = CH1                                               EZF00490
            WA(I) = SH1                                                 EZF00500
            IF (IDO .LT. 5) GO TO 109                                   EZF00510
            DO 108 II=5,IDO,2                                           EZF00520
               I = I+2                                                  EZF00530
               WA(I-1) = CH1*WA(I-3)-SH1*WA(I-2)                        EZF00540
               WA(I) = CH1*WA(I-2)+SH1*WA(I-3)                          EZF00550
  108       CONTINUE                                                    EZF00560
  109       IS = IS+IDO                                                 EZF00570
  110    CONTINUE                                                       EZF00580
         L1 = L2                                                        EZF00590
  111 CONTINUE                                                          EZF00600
      RETURN                                                            EZF00610
      END                                                               EZF00620
      SUBROUTINE EZFFTB (N,R,AZERO,A,B,WSAVE)                           EZF00010
      DIMENSION       R(1)       ,A(1)       ,B(1)       ,WSAVE(1)      EZF00020
      IF (N-2) 101,102,103                                              EZF00030
  101 R(1) = AZERO                                                      EZF00040
      RETURN                                                            EZF00050
  102 R(1) = AZERO+A(1)                                                 EZF00060
      R(2) = AZERO-A(1)                                                 EZF00070
      RETURN                                                            EZF00080
C                                                                       EZF00090
C     TO SUPRESS REPEATED INITIALIZATION, REMOVE THE FOLLOWING STATEMENTEZF00100
C     ( CALL EZFFTI(N,WSAVE) ) FROM BOTH EZFFTF AND EZFFTB AND INSERT ITEZF00110
C     AT THE BEGINNING OF YOUR PROGRAM FOLLOWING THE DEFINITION OF N.   EZF00120
C                                                                       EZF00130
  103 CALL EZFFTI (N,WSAVE)                                             EZF00140
C                                                                       EZF00150
      NS2 = (N-1)/2                                                     EZF00160
      DO 104 I=1,NS2                                                    EZF00170
         R(2*I) = .5*A(I)                                               EZF00180
         R(2*I+1) = -.5*B(I)                                            EZF00190
  104 CONTINUE                                                          EZF00200
      R(1) = AZERO                                                      EZF00210
      IF (MOD(N,2) .EQ. 0) R(N) = A(NS2+1)                              EZF00220
      CALL RFFTB (N,R,WSAVE(N+1))                                       EZF00230
      RETURN                                                            EZF00240
      END                                                               EZF00250
C FISHPAK21  FROM PORTLIB                                  11/10/79     EZF00010
      SUBROUTINE EZFFTF (N,R,AZERO,A,B,WSAVE)                           EZF00020
C                                                                       EZF00030
C                       VERSION 3  JUNE 1979                            EZF00040
C                                                                       EZF00050
      DIMENSION       R(1)       ,A(1)       ,B(1)       ,WSAVE(1)      EZF00060
      IF (N-2) 101,102,103                                              EZF00070
  101 AZERO = R(1)                                                      EZF00080
      RETURN                                                            EZF00090
  102 AZERO = .5*(R(1)+R(2))                                            EZF00100
      A(1) = .5*(R(1)-R(2))                                             EZF00110
      RETURN                                                            EZF00120
C                                                                       EZF00130
C     TO SUPRESS REPEATED INITIALIZATION, REMOVE THE FOLLOWING STATEMENTEZF00140
C     ( CALL EZFFTI(N,WSAVE) ) FROM BOTH EZFFTF AND EZFFTB AND INSERT ITEZF00150
C     AT THE BEGINNING OF YOUR PROGRAM FOLLOWING THE DEFINITION OF N.   EZF00160
C                                                                       EZF00170
  103 CALL EZFFTI (N,WSAVE)                                             EZF00180
C                                                                       EZF00190
      DO 104 I=1,N                                                      EZF00200
         WSAVE(I) = R(I)                                                EZF00210
  104 CONTINUE                                                          EZF00220
      CALL RFFTF (N,WSAVE,WSAVE(N+1))                                   EZF00230
      CF = 2./FLOAT(N)                                                  EZF00240
      CFM = -CF                                                         EZF00250
      AZERO = .5*CF*WSAVE(1)                                            EZF00260
      NS2 = (N+1)/2                                                     EZF00270
      NS2M = NS2-1                                                      EZF00280
      DO 105 I=1,NS2M                                                   EZF00290
         A(I) = CF*WSAVE(2*I)                                           EZF00300
         B(I) = CFM*WSAVE(2*I+1)                                        EZF00310
  105 CONTINUE                                                          EZF00320
      IF (MOD(N,2) .EQ. 0) A(NS2) = .5*CF*WSAVE(N)                      EZF00330
      RETURN                                                            EZF00340
      END                                                               EZF00350
      SUBROUTINE EZFFTI (N,WSAVE)                                       EZF00010
      DIMENSION       WSAVE(1)                                          EZF00020
      IF (N .EQ. 1) RETURN                                              EZF00030
      CALL EZFFT1 (N,WSAVE(2*N+1),WSAVE(3*N+1))                         EZF00040
      RETURN                                                            EZF00050
      END                                                               EZF00060
      SUBROUTINE PASSB (NAC,IDO,IP,L1,IDL1,CC,C1,C2,CH,CH2,WA)          PAS00010
      DIMENSION       CH(IDO,L1,IP)          ,CC(IDO,IP,L1)          ,  PAS00020
     1                C1(IDO,L1,IP)          ,WA(1)      ,C2(IDL1,IP),  PAS00030
     2                CH2(IDL1,IP)                                      PAS00040
      IDOT = IDO/2                                                      PAS00050
      NT = IP*IDL1                                                      PAS00060
      IPP2 = IP+2                                                       PAS00070
      IPPH = (IP+1)/2                                                   PAS00080
      IDP = IP*IDO                                                      PAS00090
C                                                                       PAS00100
      IF (IDO .LT. L1) GO TO 106                                        PAS00110
      DO 103 J=2,IPPH                                                   PAS00120
         JC = IPP2-J                                                    PAS00130
         DO 102 K=1,L1                                                  PAS00140
            DO 101 I=1,IDO                                              PAS00150
               CH(I,K,J) = CC(I,J,K)+CC(I,JC,K)                         PAS00160
               CH(I,K,JC) = CC(I,J,K)-CC(I,JC,K)                        PAS00170
  101       CONTINUE                                                    PAS00180
  102    CONTINUE                                                       PAS00190
  103 CONTINUE                                                          PAS00200
      DO 105 K=1,L1                                                     PAS00210
         DO 104 I=1,IDO                                                 PAS00220
            CH(I,K,1) = CC(I,1,K)                                       PAS00230
  104    CONTINUE                                                       PAS00240
  105 CONTINUE                                                          PAS00250
      GO TO 112                                                         PAS00260
  106 DO 109 J=2,IPPH                                                   PAS00270
         JC = IPP2-J                                                    PAS00280
         DO 108 I=1,IDO                                                 PAS00290
            DO 107 K=1,L1                                               PAS00300
               CH(I,K,J) = CC(I,J,K)+CC(I,JC,K)                         PAS00310
               CH(I,K,JC) = CC(I,J,K)-CC(I,JC,K)                        PAS00320
  107       CONTINUE                                                    PAS00330
  108    CONTINUE                                                       PAS00340
  109 CONTINUE                                                          PAS00350
      DO 111 I=1,IDO                                                    PAS00360
         DO 110 K=1,L1                                                  PAS00370
            CH(I,K,1) = CC(I,1,K)                                       PAS00380
  110    CONTINUE                                                       PAS00390
  111 CONTINUE                                                          PAS00400
  112 IDL = 2-IDO                                                       PAS00410
      INC = 0                                                           PAS00420
      DO 116 L=2,IPPH                                                   PAS00430
         LC = IPP2-L                                                    PAS00440
         IDL = IDL+IDO                                                  PAS00450
         DO 113 IK=1,IDL1                                               PAS00460
            C2(IK,L) = CH2(IK,1)+WA(IDL-1)*CH2(IK,2)                    PAS00470
            C2(IK,LC) = WA(IDL)*CH2(IK,IP)                              PAS00480
  113    CONTINUE                                                       PAS00490
         IDLJ = IDL                                                     PAS00500
         INC = INC+IDO                                                  PAS00510
         DO 115 J=3,IPPH                                                PAS00520
            JC = IPP2-J                                                 PAS00530
            IDLJ = IDLJ+INC                                             PAS00540
            IF (IDLJ .GT. IDP) IDLJ = IDLJ-IDP                          PAS00550
            WAR = WA(IDLJ-1)                                            PAS00560
            WAI = WA(IDLJ)                                              PAS00570
            DO 114 IK=1,IDL1                                            PAS00580
               C2(IK,L) = C2(IK,L)+WAR*CH2(IK,J)                        PAS00590
               C2(IK,LC) = C2(IK,LC)+WAI*CH2(IK,JC)                     PAS00600
  114       CONTINUE                                                    PAS00610
  115    CONTINUE                                                       PAS00620
  116 CONTINUE                                                          PAS00630
      DO 118 J=2,IPPH                                                   PAS00640
         DO 117 IK=1,IDL1                                               PAS00650
            CH2(IK,1) = CH2(IK,1)+CH2(IK,J)                             PAS00660
  117    CONTINUE                                                       PAS00670
  118 CONTINUE                                                          PAS00680
      DO 120 J=2,IPPH                                                   PAS00690
         JC = IPP2-J                                                    PAS00700
         DO 119 IK=2,IDL1,2                                             PAS00710
            CH2(IK-1,J) = C2(IK-1,J)-C2(IK,JC)                          PAS00720
            CH2(IK-1,JC) = C2(IK-1,J)+C2(IK,JC)                         PAS00730
            CH2(IK,J) = C2(IK,J)+C2(IK-1,JC)                            PAS00740
            CH2(IK,JC) = C2(IK,J)-C2(IK-1,JC)                           PAS00750
  119    CONTINUE                                                       PAS00760
  120 CONTINUE                                                          PAS00770
      NAC = 1                                                           PAS00780
      IF (IDO .EQ. 2) RETURN                                            PAS00790
      NAC = 0                                                           PAS00800
      DO 121 IK=1,IDL1                                                  PAS00810
         C2(IK,1) = CH2(IK,1)                                           PAS00820
  121 CONTINUE                                                          PAS00830
      DO 123 J=2,IP                                                     PAS00840
         DO 122 K=1,L1                                                  PAS00850
            C1(1,K,J) = CH(1,K,J)                                       PAS00860
            C1(2,K,J) = CH(2,K,J)                                       PAS00870
  122    CONTINUE                                                       PAS00880
  123 CONTINUE                                                          PAS00890
      IF (IDOT .GT. L1) GO TO 127                                       PAS00900
      IDIJ = 0                                                          PAS00910
      DO 126 J=2,IP                                                     PAS00920
         IDIJ = IDIJ+2                                                  PAS00930
         DO 125 I=4,IDO,2                                               PAS00940
            IDIJ = IDIJ+2                                               PAS00950
            DO 124 K=1,L1                                               PAS00960
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)-WA(IDIJ)*CH(I,K,J)  PAS00970
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)+WA(IDIJ)*CH(I-1,K,J)    PAS00980
  124       CONTINUE                                                    PAS00990
  125    CONTINUE                                                       PAS01000
  126 CONTINUE                                                          PAS01010
      RETURN                                                            PAS01020
  127 IDJ = 2-IDO                                                       PAS01030
      DO 130 J=2,IP                                                     PAS01040
         IDJ = IDJ+IDO                                                  PAS01050
         DO 129 K=1,L1                                                  PAS01060
            IDIJ = IDJ                                                  PAS01070
            DO 128 I=4,IDO,2                                            PAS01080
               IDIJ = IDIJ+2                                            PAS01090
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)-WA(IDIJ)*CH(I,K,J)  PAS01100
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)+WA(IDIJ)*CH(I-1,K,J)    PAS01110
  128       CONTINUE                                                    PAS01120
  129    CONTINUE                                                       PAS01130
  130 CONTINUE                                                          PAS01140
      RETURN                                                            PAS01150
      END                                                               PAS01160
      SUBROUTINE PASSB2 (IDO,L1,CC,CH,WA1)                              PAS00010
      DIMENSION       CC(IDO,2,L1)           ,CH(IDO,L1,2)           ,  PAS00020
     1                WA1(1)                                            PAS00030
      IF (IDO .GT. 2) GO TO 102                                         PAS00040
      DO 101 K=1,L1                                                     PAS00050
         CH(1,K,1) = CC(1,1,K)+CC(1,2,K)                                PAS00060
         CH(1,K,2) = CC(1,1,K)-CC(1,2,K)                                PAS00070
         CH(2,K,1) = CC(2,1,K)+CC(2,2,K)                                PAS00080
         CH(2,K,2) = CC(2,1,K)-CC(2,2,K)                                PAS00090
  101 CONTINUE                                                          PAS00100
      RETURN                                                            PAS00110
  102 DO 104 K=1,L1                                                     PAS00120
         DO 103 I=2,IDO,2                                               PAS00130
            CH(I-1,K,1) = CC(I-1,1,K)+CC(I-1,2,K)                       PAS00140
            TR2 = CC(I-1,1,K)-CC(I-1,2,K)                               PAS00150
            CH(I,K,1) = CC(I,1,K)+CC(I,2,K)                             PAS00160
            TI2 = CC(I,1,K)-CC(I,2,K)                                   PAS00170
            CH(I,K,2) = WA1(I-1)*TI2+WA1(I)*TR2                         PAS00180
            CH(I-1,K,2) = WA1(I-1)*TR2-WA1(I)*TI2                       PAS00190
  103    CONTINUE                                                       PAS00200
  104 CONTINUE                                                          PAS00210
      RETURN                                                            PAS00220
      END                                                               PAS00230
      SUBROUTINE PASSB3 (IDO,L1,CC,CH,WA1,WA2)                          PAS00010
      DIMENSION       CC(IDO,3,L1)           ,CH(IDO,L1,3)           ,  PAS00020
     1                WA1(1)     ,WA2(1)                                PAS00030
      DATA TAUR,TAUI /-.5,.866025403784439/                             PAS00040
      IF (IDO .NE. 2) GO TO 102                                         PAS00050
      DO 101 K=1,L1                                                     PAS00060
         TR2 = CC(1,2,K)+CC(1,3,K)                                      PAS00070
         CR2 = CC(1,1,K)+TAUR*TR2                                       PAS00080
         CH(1,K,1) = CC(1,1,K)+TR2                                      PAS00090
         TI2 = CC(2,2,K)+CC(2,3,K)                                      PAS00100
         CI2 = CC(2,1,K)+TAUR*TI2                                       PAS00110
         CH(2,K,1) = CC(2,1,K)+TI2                                      PAS00120
         CR3 = TAUI*(CC(1,2,K)-CC(1,3,K))                               PAS00130
         CI3 = TAUI*(CC(2,2,K)-CC(2,3,K))                               PAS00140
         CH(1,K,2) = CR2-CI3                                            PAS00150
         CH(1,K,3) = CR2+CI3                                            PAS00160
         CH(2,K,2) = CI2+CR3                                            PAS00170
         CH(2,K,3) = CI2-CR3                                            PAS00180
  101 CONTINUE                                                          PAS00190
      RETURN                                                            PAS00200
  102 DO 104 K=1,L1                                                     PAS00210
         DO 103 I=2,IDO,2                                               PAS00220
            TR2 = CC(I-1,2,K)+CC(I-1,3,K)                               PAS00230
            CR2 = CC(I-1,1,K)+TAUR*TR2                                  PAS00240
            CH(I-1,K,1) = CC(I-1,1,K)+TR2                               PAS00250
            TI2 = CC(I,2,K)+CC(I,3,K)                                   PAS00260
            CI2 = CC(I,1,K)+TAUR*TI2                                    PAS00270
            CH(I,K,1) = CC(I,1,K)+TI2                                   PAS00280
            CR3 = TAUI*(CC(I-1,2,K)-CC(I-1,3,K))                        PAS00290
            CI3 = TAUI*(CC(I,2,K)-CC(I,3,K))                            PAS00300
            DR2 = CR2-CI3                                               PAS00310
            DR3 = CR2+CI3                                               PAS00320
            DI2 = CI2+CR3                                               PAS00330
            DI3 = CI2-CR3                                               PAS00340
            CH(I,K,2) = WA1(I-1)*DI2+WA1(I)*DR2                         PAS00350
            CH(I-1,K,2) = WA1(I-1)*DR2-WA1(I)*DI2                       PAS00360
            CH(I,K,3) = WA2(I-1)*DI3+WA2(I)*DR3                         PAS00370
            CH(I-1,K,3) = WA2(I-1)*DR3-WA2(I)*DI3                       PAS00380
  103    CONTINUE                                                       PAS00390
  104 CONTINUE                                                          PAS00400
      RETURN                                                            PAS00410
      END                                                               PAS00420
      SUBROUTINE PASSB4 (IDO,L1,CC,CH,WA1,WA2,WA3)                      PAS00010
      DIMENSION       CC(IDO,4,L1)           ,CH(IDO,L1,4)           ,  PAS00020
     1                WA1(1)     ,WA2(1)     ,WA3(1)                    PAS00030
      IF (IDO .NE. 2) GO TO 102                                         PAS00040
      DO 101 K=1,L1                                                     PAS00050
         TI1 = CC(2,1,K)-CC(2,3,K)                                      PAS00060
         TI2 = CC(2,1,K)+CC(2,3,K)                                      PAS00070
         TR4 = CC(2,4,K)-CC(2,2,K)                                      PAS00080
         TI3 = CC(2,2,K)+CC(2,4,K)                                      PAS00090
         TR1 = CC(1,1,K)-CC(1,3,K)                                      PAS00100
         TR2 = CC(1,1,K)+CC(1,3,K)                                      PAS00110
         TI4 = CC(1,2,K)-CC(1,4,K)                                      PAS00120
         TR3 = CC(1,2,K)+CC(1,4,K)                                      PAS00130
         CH(1,K,1) = TR2+TR3                                            PAS00140
         CH(1,K,3) = TR2-TR3                                            PAS00150
         CH(2,K,1) = TI2+TI3                                            PAS00160
         CH(2,K,3) = TI2-TI3                                            PAS00170
         CH(1,K,2) = TR1+TR4                                            PAS00180
         CH(1,K,4) = TR1-TR4                                            PAS00190
         CH(2,K,2) = TI1+TI4                                            PAS00200
         CH(2,K,4) = TI1-TI4                                            PAS00210
  101 CONTINUE                                                          PAS00220
      RETURN                                                            PAS00230
  102 DO 104 K=1,L1                                                     PAS00240
         DO 103 I=2,IDO,2                                               PAS00250
            TI1 = CC(I,1,K)-CC(I,3,K)                                   PAS00260
            TI2 = CC(I,1,K)+CC(I,3,K)                                   PAS00270
            TI3 = CC(I,2,K)+CC(I,4,K)                                   PAS00280
            TR4 = CC(I,4,K)-CC(I,2,K)                                   PAS00290
            TR1 = CC(I-1,1,K)-CC(I-1,3,K)                               PAS00300
            TR2 = CC(I-1,1,K)+CC(I-1,3,K)                               PAS00310
            TI4 = CC(I-1,2,K)-CC(I-1,4,K)                               PAS00320
            TR3 = CC(I-1,2,K)+CC(I-1,4,K)                               PAS00330
            CH(I-1,K,1) = TR2+TR3                                       PAS00340
            CR3 = TR2-TR3                                               PAS00350
            CH(I,K,1) = TI2+TI3                                         PAS00360
            CI3 = TI2-TI3                                               PAS00370
            CR2 = TR1+TR4                                               PAS00380
            CR4 = TR1-TR4                                               PAS00390
            CI2 = TI1+TI4                                               PAS00400
            CI4 = TI1-TI4                                               PAS00410
            CH(I-1,K,2) = WA1(I-1)*CR2-WA1(I)*CI2                       PAS00420
            CH(I,K,2) = WA1(I-1)*CI2+WA1(I)*CR2                         PAS00430
            CH(I-1,K,3) = WA2(I-1)*CR3-WA2(I)*CI3                       PAS00440
            CH(I,K,3) = WA2(I-1)*CI3+WA2(I)*CR3                         PAS00450
            CH(I-1,K,4) = WA3(I-1)*CR4-WA3(I)*CI4                       PAS00460
            CH(I,K,4) = WA3(I-1)*CI4+WA3(I)*CR4                         PAS00470
  103    CONTINUE                                                       PAS00480
  104 CONTINUE                                                          PAS00490
      RETURN                                                            PAS00500
      END                                                               PAS00510
      SUBROUTINE PASSB5 (IDO,L1,CC,CH,WA1,WA2,WA3,WA4)                  PAS00010
      DIMENSION       CC(IDO,5,L1)           ,CH(IDO,L1,5)           ,  PAS00020
     1                WA1(1)     ,WA2(1)     ,WA3(1)     ,WA4(1)        PAS00030
      DATA TR11,TI11,TR12,TI12 /.309016994374947,.951056516295154,      PAS00040
     1-.809016994374947,.587785252292473/                               PAS00050
      IF (IDO .NE. 2) GO TO 102                                         PAS00060
      DO 101 K=1,L1                                                     PAS00070
         TI5 = CC(2,2,K)-CC(2,5,K)                                      PAS00080
         TI2 = CC(2,2,K)+CC(2,5,K)                                      PAS00090
         TI4 = CC(2,3,K)-CC(2,4,K)                                      PAS00100
         TI3 = CC(2,3,K)+CC(2,4,K)                                      PAS00110
         TR5 = CC(1,2,K)-CC(1,5,K)                                      PAS00120
         TR2 = CC(1,2,K)+CC(1,5,K)                                      PAS00130
         TR4 = CC(1,3,K)-CC(1,4,K)                                      PAS00140
         TR3 = CC(1,3,K)+CC(1,4,K)                                      PAS00150
         CH(1,K,1) = CC(1,1,K)+TR2+TR3                                  PAS00160
         CH(2,K,1) = CC(2,1,K)+TI2+TI3                                  PAS00170
         CR2 = CC(1,1,K)+TR11*TR2+TR12*TR3                              PAS00180
         CI2 = CC(2,1,K)+TR11*TI2+TR12*TI3                              PAS00190
         CR3 = CC(1,1,K)+TR12*TR2+TR11*TR3                              PAS00200
         CI3 = CC(2,1,K)+TR12*TI2+TR11*TI3                              PAS00210
         CR5 = TI11*TR5+TI12*TR4                                        PAS00220
         CI5 = TI11*TI5+TI12*TI4                                        PAS00230
         CR4 = TI12*TR5-TI11*TR4                                        PAS00240
         CI4 = TI12*TI5-TI11*TI4                                        PAS00250
         CH(1,K,2) = CR2-CI5                                            PAS00260
         CH(1,K,5) = CR2+CI5                                            PAS00270
         CH(2,K,2) = CI2+CR5                                            PAS00280
         CH(2,K,3) = CI3+CR4                                            PAS00290
         CH(1,K,3) = CR3-CI4                                            PAS00300
         CH(1,K,4) = CR3+CI4                                            PAS00310
         CH(2,K,4) = CI3-CR4                                            PAS00320
         CH(2,K,5) = CI2-CR5                                            PAS00330
  101 CONTINUE                                                          PAS00340
      RETURN                                                            PAS00350
  102 DO 104 K=1,L1                                                     PAS00360
         DO 103 I=2,IDO,2                                               PAS00370
            TI5 = CC(I,2,K)-CC(I,5,K)                                   PAS00380
            TI2 = CC(I,2,K)+CC(I,5,K)                                   PAS00390
            TI4 = CC(I,3,K)-CC(I,4,K)                                   PAS00400
            TI3 = CC(I,3,K)+CC(I,4,K)                                   PAS00410
            TR5 = CC(I-1,2,K)-CC(I-1,5,K)                               PAS00420
            TR2 = CC(I-1,2,K)+CC(I-1,5,K)                               PAS00430
            TR4 = CC(I-1,3,K)-CC(I-1,4,K)                               PAS00440
            TR3 = CC(I-1,3,K)+CC(I-1,4,K)                               PAS00450
            CH(I-1,K,1) = CC(I-1,1,K)+TR2+TR3                           PAS00460
            CH(I,K,1) = CC(I,1,K)+TI2+TI3                               PAS00470
            CR2 = CC(I-1,1,K)+TR11*TR2+TR12*TR3                         PAS00480
            CI2 = CC(I,1,K)+TR11*TI2+TR12*TI3                           PAS00490
            CR3 = CC(I-1,1,K)+TR12*TR2+TR11*TR3                         PAS00500
            CI3 = CC(I,1,K)+TR12*TI2+TR11*TI3                           PAS00510
            CR5 = TI11*TR5+TI12*TR4                                     PAS00520
            CI5 = TI11*TI5+TI12*TI4                                     PAS00530
            CR4 = TI12*TR5-TI11*TR4                                     PAS00540
            CI4 = TI12*TI5-TI11*TI4                                     PAS00550
            DR3 = CR3-CI4                                               PAS00560
            DR4 = CR3+CI4                                               PAS00570
            DI3 = CI3+CR4                                               PAS00580
            DI4 = CI3-CR4                                               PAS00590
            DR5 = CR2+CI5                                               PAS00600
            DR2 = CR2-CI5                                               PAS00610
            DI5 = CI2-CR5                                               PAS00620
            DI2 = CI2+CR5                                               PAS00630
            CH(I-1,K,2) = WA1(I-1)*DR2-WA1(I)*DI2                       PAS00640
            CH(I,K,2) = WA1(I-1)*DI2+WA1(I)*DR2                         PAS00650
            CH(I-1,K,3) = WA2(I-1)*DR3-WA2(I)*DI3                       PAS00660
            CH(I,K,3) = WA2(I-1)*DI3+WA2(I)*DR3                         PAS00670
            CH(I-1,K,4) = WA3(I-1)*DR4-WA3(I)*DI4                       PAS00680
            CH(I,K,4) = WA3(I-1)*DI4+WA3(I)*DR4                         PAS00690
            CH(I-1,K,5) = WA4(I-1)*DR5-WA4(I)*DI5                       PAS00700
            CH(I,K,5) = WA4(I-1)*DI5+WA4(I)*DR5                         PAS00710
  103    CONTINUE                                                       PAS00720
  104 CONTINUE                                                          PAS00730
      RETURN                                                            PAS00740
      END                                                               PAS00750
      SUBROUTINE PASSF (NAC,IDO,IP,L1,IDL1,CC,C1,C2,CH,CH2,WA)          PAS00010
      DIMENSION       CH(IDO,L1,IP)          ,CC(IDO,IP,L1)          ,  PAS00020
     1                C1(IDO,L1,IP)          ,WA(1)      ,C2(IDL1,IP),  PAS00030
     2                CH2(IDL1,IP)                                      PAS00040
      IDOT = IDO/2                                                      PAS00050
      NT = IP*IDL1                                                      PAS00060
      IPP2 = IP+2                                                       PAS00070
      IPPH = (IP+1)/2                                                   PAS00080
      IDP = IP*IDO                                                      PAS00090
C                                                                       PAS00100
      IF (IDO .LT. L1) GO TO 106                                        PAS00110
      DO 103 J=2,IPPH                                                   PAS00120
         JC = IPP2-J                                                    PAS00130
         DO 102 K=1,L1                                                  PAS00140
            DO 101 I=1,IDO                                              PAS00150
               CH(I,K,J) = CC(I,J,K)+CC(I,JC,K)                         PAS00160
               CH(I,K,JC) = CC(I,J,K)-CC(I,JC,K)                        PAS00170
  101       CONTINUE                                                    PAS00180
  102    CONTINUE                                                       PAS00190
  103 CONTINUE                                                          PAS00200
      DO 105 K=1,L1                                                     PAS00210
         DO 104 I=1,IDO                                                 PAS00220
            CH(I,K,1) = CC(I,1,K)                                       PAS00230
  104    CONTINUE                                                       PAS00240
  105 CONTINUE                                                          PAS00250
      GO TO 112                                                         PAS00260
  106 DO 109 J=2,IPPH                                                   PAS00270
         JC = IPP2-J                                                    PAS00280
         DO 108 I=1,IDO                                                 PAS00290
            DO 107 K=1,L1                                               PAS00300
               CH(I,K,J) = CC(I,J,K)+CC(I,JC,K)                         PAS00310
               CH(I,K,JC) = CC(I,J,K)-CC(I,JC,K)                        PAS00320
  107       CONTINUE                                                    PAS00330
  108    CONTINUE                                                       PAS00340
  109 CONTINUE                                                          PAS00350
      DO 111 I=1,IDO                                                    PAS00360
         DO 110 K=1,L1                                                  PAS00370
            CH(I,K,1) = CC(I,1,K)                                       PAS00380
  110    CONTINUE                                                       PAS00390
  111 CONTINUE                                                          PAS00400
  112 IDL = 2-IDO                                                       PAS00410
      INC = 0                                                           PAS00420
      DO 116 L=2,IPPH                                                   PAS00430
         LC = IPP2-L                                                    PAS00440
         IDL = IDL+IDO                                                  PAS00450
         DO 113 IK=1,IDL1                                               PAS00460
            C2(IK,L) = CH2(IK,1)+WA(IDL-1)*CH2(IK,2)                    PAS00470
            C2(IK,LC) = -WA(IDL)*CH2(IK,IP)                             PAS00480
  113    CONTINUE                                                       PAS00490
         IDLJ = IDL                                                     PAS00500
         INC = INC+IDO                                                  PAS00510
         DO 115 J=3,IPPH                                                PAS00520
            JC = IPP2-J                                                 PAS00530
            IDLJ = IDLJ+INC                                             PAS00540
            IF (IDLJ .GT. IDP) IDLJ = IDLJ-IDP                          PAS00550
            WAR = WA(IDLJ-1)                                            PAS00560
            WAI = WA(IDLJ)                                              PAS00570
            DO 114 IK=1,IDL1                                            PAS00580
               C2(IK,L) = C2(IK,L)+WAR*CH2(IK,J)                        PAS00590
               C2(IK,LC) = C2(IK,LC)-WAI*CH2(IK,JC)                     PAS00600
  114       CONTINUE                                                    PAS00610
  115    CONTINUE                                                       PAS00620
  116 CONTINUE                                                          PAS00630
      DO 118 J=2,IPPH                                                   PAS00640
         DO 117 IK=1,IDL1                                               PAS00650
            CH2(IK,1) = CH2(IK,1)+CH2(IK,J)                             PAS00660
  117    CONTINUE                                                       PAS00670
  118 CONTINUE                                                          PAS00680
      DO 120 J=2,IPPH                                                   PAS00690
         JC = IPP2-J                                                    PAS00700
         DO 119 IK=2,IDL1,2                                             PAS00710
            CH2(IK-1,J) = C2(IK-1,J)-C2(IK,JC)                          PAS00720
            CH2(IK-1,JC) = C2(IK-1,J)+C2(IK,JC)                         PAS00730
            CH2(IK,J) = C2(IK,J)+C2(IK-1,JC)                            PAS00740
            CH2(IK,JC) = C2(IK,J)-C2(IK-1,JC)                           PAS00750
  119    CONTINUE                                                       PAS00760
  120 CONTINUE                                                          PAS00770
      NAC = 1                                                           PAS00780
      IF (IDO .EQ. 2) RETURN                                            PAS00790
      NAC = 0                                                           PAS00800
      DO 121 IK=1,IDL1                                                  PAS00810
         C2(IK,1) = CH2(IK,1)                                           PAS00820
  121 CONTINUE                                                          PAS00830
      DO 123 J=2,IP                                                     PAS00840
         DO 122 K=1,L1                                                  PAS00850
            C1(1,K,J) = CH(1,K,J)                                       PAS00860
            C1(2,K,J) = CH(2,K,J)                                       PAS00870
  122    CONTINUE                                                       PAS00880
  123 CONTINUE                                                          PAS00890
      IF (IDOT .GT. L1) GO TO 127                                       PAS00900
      IDIJ = 0                                                          PAS00910
      DO 126 J=2,IP                                                     PAS00920
         IDIJ = IDIJ+2                                                  PAS00930
         DO 125 I=4,IDO,2                                               PAS00940
            IDIJ = IDIJ+2                                               PAS00950
            DO 124 K=1,L1                                               PAS00960
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)+WA(IDIJ)*CH(I,K,J)  PAS00970
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)-WA(IDIJ)*CH(I-1,K,J)    PAS00980
  124       CONTINUE                                                    PAS00990
  125    CONTINUE                                                       PAS01000
  126 CONTINUE                                                          PAS01010
      RETURN                                                            PAS01020
  127 IDJ = 2-IDO                                                       PAS01030
      DO 130 J=2,IP                                                     PAS01040
         IDJ = IDJ+IDO                                                  PAS01050
         DO 129 K=1,L1                                                  PAS01060
            IDIJ = IDJ                                                  PAS01070
            DO 128 I=4,IDO,2                                            PAS01080
               IDIJ = IDIJ+2                                            PAS01090
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)+WA(IDIJ)*CH(I,K,J)  PAS01100
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)-WA(IDIJ)*CH(I-1,K,J)    PAS01110
  128       CONTINUE                                                    PAS01120
  129    CONTINUE                                                       PAS01130
  130 CONTINUE                                                          PAS01140
      RETURN                                                            PAS01150
      END                                                               PAS01160
      SUBROUTINE PASSF2 (IDO,L1,CC,CH,WA1)                              PAS00010
      DIMENSION       CC(IDO,2,L1)           ,CH(IDO,L1,2)           ,  PAS00020
     1                WA1(1)                                            PAS00030
      IF (IDO .GT. 2) GO TO 102                                         PAS00040
      DO 101 K=1,L1                                                     PAS00050
         CH(1,K,1) = CC(1,1,K)+CC(1,2,K)                                PAS00060
         CH(1,K,2) = CC(1,1,K)-CC(1,2,K)                                PAS00070
         CH(2,K,1) = CC(2,1,K)+CC(2,2,K)                                PAS00080
         CH(2,K,2) = CC(2,1,K)-CC(2,2,K)                                PAS00090
  101 CONTINUE                                                          PAS00100
      RETURN                                                            PAS00110
  102 DO 104 K=1,L1                                                     PAS00120
         DO 103 I=2,IDO,2                                               PAS00130
            CH(I-1,K,1) = CC(I-1,1,K)+CC(I-1,2,K)                       PAS00140
            TR2 = CC(I-1,1,K)-CC(I-1,2,K)                               PAS00150
            CH(I,K,1) = CC(I,1,K)+CC(I,2,K)                             PAS00160
            TI2 = CC(I,1,K)-CC(I,2,K)                                   PAS00170
            CH(I,K,2) = WA1(I-1)*TI2-WA1(I)*TR2                         PAS00180
            CH(I-1,K,2) = WA1(I-1)*TR2+WA1(I)*TI2                       PAS00190
  103    CONTINUE                                                       PAS00200
  104 CONTINUE                                                          PAS00210
      RETURN                                                            PAS00220
      END                                                               PAS00230
      SUBROUTINE PASSF3 (IDO,L1,CC,CH,WA1,WA2)                          PAS00010
      DIMENSION       CC(IDO,3,L1)           ,CH(IDO,L1,3)           ,  PAS00020
     1                WA1(1)     ,WA2(1)                                PAS00030
      DATA TAUR,TAUI /-.5,-.866025403784439/                            PAS00040
      IF (IDO .NE. 2) GO TO 102                                         PAS00050
      DO 101 K=1,L1                                                     PAS00060
         TR2 = CC(1,2,K)+CC(1,3,K)                                      PAS00070
         CR2 = CC(1,1,K)+TAUR*TR2                                       PAS00080
         CH(1,K,1) = CC(1,1,K)+TR2                                      PAS00090
         TI2 = CC(2,2,K)+CC(2,3,K)                                      PAS00100
         CI2 = CC(2,1,K)+TAUR*TI2                                       PAS00110
         CH(2,K,1) = CC(2,1,K)+TI2                                      PAS00120
         CR3 = TAUI*(CC(1,2,K)-CC(1,3,K))                               PAS00130
         CI3 = TAUI*(CC(2,2,K)-CC(2,3,K))                               PAS00140
         CH(1,K,2) = CR2-CI3                                            PAS00150
         CH(1,K,3) = CR2+CI3                                            PAS00160
         CH(2,K,2) = CI2+CR3                                            PAS00170
         CH(2,K,3) = CI2-CR3                                            PAS00180
  101 CONTINUE                                                          PAS00190
      RETURN                                                            PAS00200
  102 DO 104 K=1,L1                                                     PAS00210
         DO 103 I=2,IDO,2                                               PAS00220
            TR2 = CC(I-1,2,K)+CC(I-1,3,K)                               PAS00230
            CR2 = CC(I-1,1,K)+TAUR*TR2                                  PAS00240
            CH(I-1,K,1) = CC(I-1,1,K)+TR2                               PAS00250
            TI2 = CC(I,2,K)+CC(I,3,K)                                   PAS00260
            CI2 = CC(I,1,K)+TAUR*TI2                                    PAS00270
            CH(I,K,1) = CC(I,1,K)+TI2                                   PAS00280
            CR3 = TAUI*(CC(I-1,2,K)-CC(I-1,3,K))                        PAS00290
            CI3 = TAUI*(CC(I,2,K)-CC(I,3,K))                            PAS00300
            DR2 = CR2-CI3                                               PAS00310
            DR3 = CR2+CI3                                               PAS00320
            DI2 = CI2+CR3                                               PAS00330
            DI3 = CI2-CR3                                               PAS00340
            CH(I,K,2) = WA1(I-1)*DI2-WA1(I)*DR2                         PAS00350
            CH(I-1,K,2) = WA1(I-1)*DR2+WA1(I)*DI2                       PAS00360
            CH(I,K,3) = WA2(I-1)*DI3-WA2(I)*DR3                         PAS00370
            CH(I-1,K,3) = WA2(I-1)*DR3+WA2(I)*DI3                       PAS00380
  103    CONTINUE                                                       PAS00390
  104 CONTINUE                                                          PAS00400
      RETURN                                                            PAS00410
      END                                                               PAS00420
      SUBROUTINE PASSF4 (IDO,L1,CC,CH,WA1,WA2,WA3)                      PAS00010
      DIMENSION       CC(IDO,4,L1)           ,CH(IDO,L1,4)           ,  PAS00020
     1                WA1(1)     ,WA2(1)     ,WA3(1)                    PAS00030
      IF (IDO .NE. 2) GO TO 102                                         PAS00040
      DO 101 K=1,L1                                                     PAS00050
         TI1 = CC(2,1,K)-CC(2,3,K)                                      PAS00060
         TI2 = CC(2,1,K)+CC(2,3,K)                                      PAS00070
         TR4 = CC(2,2,K)-CC(2,4,K)                                      PAS00080
         TI3 = CC(2,2,K)+CC(2,4,K)                                      PAS00090
         TR1 = CC(1,1,K)-CC(1,3,K)                                      PAS00100
         TR2 = CC(1,1,K)+CC(1,3,K)                                      PAS00110
         TI4 = CC(1,4,K)-CC(1,2,K)                                      PAS00120
         TR3 = CC(1,2,K)+CC(1,4,K)                                      PAS00130
         CH(1,K,1) = TR2+TR3                                            PAS00140
         CH(1,K,3) = TR2-TR3                                            PAS00150
         CH(2,K,1) = TI2+TI3                                            PAS00160
         CH(2,K,3) = TI2-TI3                                            PAS00170
         CH(1,K,2) = TR1+TR4                                            PAS00180
         CH(1,K,4) = TR1-TR4                                            PAS00190
         CH(2,K,2) = TI1+TI4                                            PAS00200
         CH(2,K,4) = TI1-TI4                                            PAS00210
  101 CONTINUE                                                          PAS00220
      RETURN                                                            PAS00230
  102 DO 104 K=1,L1                                                     PAS00240
         DO 103 I=2,IDO,2                                               PAS00250
            TI1 = CC(I,1,K)-CC(I,3,K)                                   PAS00260
            TI2 = CC(I,1,K)+CC(I,3,K)                                   PAS00270
            TI3 = CC(I,2,K)+CC(I,4,K)                                   PAS00280
            TR4 = CC(I,2,K)-CC(I,4,K)                                   PAS00290
            TR1 = CC(I-1,1,K)-CC(I-1,3,K)                               PAS00300
            TR2 = CC(I-1,1,K)+CC(I-1,3,K)                               PAS00310
            TI4 = CC(I-1,4,K)-CC(I-1,2,K)                               PAS00320
            TR3 = CC(I-1,2,K)+CC(I-1,4,K)                               PAS00330
            CH(I-1,K,1) = TR2+TR3                                       PAS00340
            CR3 = TR2-TR3                                               PAS00350
            CH(I,K,1) = TI2+TI3                                         PAS00360
            CI3 = TI2-TI3                                               PAS00370
            CR2 = TR1+TR4                                               PAS00380
            CR4 = TR1-TR4                                               PAS00390
            CI2 = TI1+TI4                                               PAS00400
            CI4 = TI1-TI4                                               PAS00410
            CH(I-1,K,2) = WA1(I-1)*CR2+WA1(I)*CI2                       PAS00420
            CH(I,K,2) = WA1(I-1)*CI2-WA1(I)*CR2                         PAS00430
            CH(I-1,K,3) = WA2(I-1)*CR3+WA2(I)*CI3                       PAS00440
            CH(I,K,3) = WA2(I-1)*CI3-WA2(I)*CR3                         PAS00450
            CH(I-1,K,4) = WA3(I-1)*CR4+WA3(I)*CI4                       PAS00460
            CH(I,K,4) = WA3(I-1)*CI4-WA3(I)*CR4                         PAS00470
  103    CONTINUE                                                       PAS00480
  104 CONTINUE                                                          PAS00490
      RETURN                                                            PAS00500
      END                                                               PAS00510
      SUBROUTINE PASSF5 (IDO,L1,CC,CH,WA1,WA2,WA3,WA4)                  PAS00010
      DIMENSION       CC(IDO,5,L1)           ,CH(IDO,L1,5)           ,  PAS00020
     1                WA1(1)     ,WA2(1)     ,WA3(1)     ,WA4(1)        PAS00030
      DATA TR11,TI11,TR12,TI12 /.309016994374947,-.951056516295154,     PAS00040
     1-.809016994374947,-.587785252292473/                              PAS00050
      IF (IDO .NE. 2) GO TO 102                                         PAS00060
      DO 101 K=1,L1                                                     PAS00070
         TI5 = CC(2,2,K)-CC(2,5,K)                                      PAS00080
         TI2 = CC(2,2,K)+CC(2,5,K)                                      PAS00090
         TI4 = CC(2,3,K)-CC(2,4,K)                                      PAS00100
         TI3 = CC(2,3,K)+CC(2,4,K)                                      PAS00110
         TR5 = CC(1,2,K)-CC(1,5,K)                                      PAS00120
         TR2 = CC(1,2,K)+CC(1,5,K)                                      PAS00130
         TR4 = CC(1,3,K)-CC(1,4,K)                                      PAS00140
         TR3 = CC(1,3,K)+CC(1,4,K)                                      PAS00150
         CH(1,K,1) = CC(1,1,K)+TR2+TR3                                  PAS00160
         CH(2,K,1) = CC(2,1,K)+TI2+TI3                                  PAS00170
         CR2 = CC(1,1,K)+TR11*TR2+TR12*TR3                              PAS00180
         CI2 = CC(2,1,K)+TR11*TI2+TR12*TI3                              PAS00190
         CR3 = CC(1,1,K)+TR12*TR2+TR11*TR3                              PAS00200
         CI3 = CC(2,1,K)+TR12*TI2+TR11*TI3                              PAS00210
         CR5 = TI11*TR5+TI12*TR4                                        PAS00220
         CI5 = TI11*TI5+TI12*TI4                                        PAS00230
         CR4 = TI12*TR5-TI11*TR4                                        PAS00240
         CI4 = TI12*TI5-TI11*TI4                                        PAS00250
         CH(1,K,2) = CR2-CI5                                            PAS00260
         CH(1,K,5) = CR2+CI5                                            PAS00270
         CH(2,K,2) = CI2+CR5                                            PAS00280
         CH(2,K,3) = CI3+CR4                                            PAS00290
         CH(1,K,3) = CR3-CI4                                            PAS00300
         CH(1,K,4) = CR3+CI4                                            PAS00310
         CH(2,K,4) = CI3-CR4                                            PAS00320
         CH(2,K,5) = CI2-CR5                                            PAS00330
  101 CONTINUE                                                          PAS00340
      RETURN                                                            PAS00350
  102 DO 104 K=1,L1                                                     PAS00360
         DO 103 I=2,IDO,2                                               PAS00370
            TI5 = CC(I,2,K)-CC(I,5,K)                                   PAS00380
            TI2 = CC(I,2,K)+CC(I,5,K)                                   PAS00390
            TI4 = CC(I,3,K)-CC(I,4,K)                                   PAS00400
            TI3 = CC(I,3,K)+CC(I,4,K)                                   PAS00410
            TR5 = CC(I-1,2,K)-CC(I-1,5,K)                               PAS00420
            TR2 = CC(I-1,2,K)+CC(I-1,5,K)                               PAS00430
            TR4 = CC(I-1,3,K)-CC(I-1,4,K)                               PAS00440
            TR3 = CC(I-1,3,K)+CC(I-1,4,K)                               PAS00450
            CH(I-1,K,1) = CC(I-1,1,K)+TR2+TR3                           PAS00460
            CH(I,K,1) = CC(I,1,K)+TI2+TI3                               PAS00470
            CR2 = CC(I-1,1,K)+TR11*TR2+TR12*TR3                         PAS00480
            CI2 = CC(I,1,K)+TR11*TI2+TR12*TI3                           PAS00490
            CR3 = CC(I-1,1,K)+TR12*TR2+TR11*TR3                         PAS00500
            CI3 = CC(I,1,K)+TR12*TI2+TR11*TI3                           PAS00510
            CR5 = TI11*TR5+TI12*TR4                                     PAS00520
            CI5 = TI11*TI5+TI12*TI4                                     PAS00530
            CR4 = TI12*TR5-TI11*TR4                                     PAS00540
            CI4 = TI12*TI5-TI11*TI4                                     PAS00550
            DR3 = CR3-CI4                                               PAS00560
            DR4 = CR3+CI4                                               PAS00570
            DI3 = CI3+CR4                                               PAS00580
            DI4 = CI3-CR4                                               PAS00590
            DR5 = CR2+CI5                                               PAS00600
            DR2 = CR2-CI5                                               PAS00610
            DI5 = CI2-CR5                                               PAS00620
            DI2 = CI2+CR5                                               PAS00630
            CH(I-1,K,2) = WA1(I-1)*DR2+WA1(I)*DI2                       PAS00640
            CH(I,K,2) = WA1(I-1)*DI2-WA1(I)*DR2                         PAS00650
            CH(I-1,K,3) = WA2(I-1)*DR3+WA2(I)*DI3                       PAS00660
            CH(I,K,3) = WA2(I-1)*DI3-WA2(I)*DR3                         PAS00670
            CH(I-1,K,4) = WA3(I-1)*DR4+WA3(I)*DI4                       PAS00680
            CH(I,K,4) = WA3(I-1)*DI4-WA3(I)*DR4                         PAS00690
            CH(I-1,K,5) = WA4(I-1)*DR5+WA4(I)*DI5                       PAS00700
            CH(I,K,5) = WA4(I-1)*DI5-WA4(I)*DR5                         PAS00710
  103    CONTINUE                                                       PAS00720
  104 CONTINUE                                                          PAS00730
      RETURN                                                            PAS00740
      END                                                               PAS00750
      SUBROUTINE RADB2 (IDO,L1,CC,CH,WA1)                               RAD00010
      DIMENSION       CC(IDO,2,L1)           ,CH(IDO,L1,2)           ,  RAD00020
     1                WA1(1)                                            RAD00030
      DO 101 K=1,L1                                                     RAD00040
         CH(1,K,1) = CC(1,1,K)+CC(IDO,2,K)                              RAD00050
         CH(1,K,2) = CC(1,1,K)-CC(IDO,2,K)                              RAD00060
  101 CONTINUE                                                          RAD00070
      IF (IDO-2) 107,105,102                                            RAD00080
  102 IDP2 = IDO+2                                                      RAD00090
      DO 104 K=1,L1                                                     RAD00100
         DO 103 I=3,IDO,2                                               RAD00110
            IC = IDP2-I                                                 RAD00120
            CH(I-1,K,1) = CC(I-1,1,K)+CC(IC-1,2,K)                      RAD00130
            TR2 = CC(I-1,1,K)-CC(IC-1,2,K)                              RAD00140
            CH(I,K,1) = CC(I,1,K)-CC(IC,2,K)                            RAD00150
            TI2 = CC(I,1,K)+CC(IC,2,K)                                  RAD00160
            CH(I-1,K,2) = WA1(I-2)*TR2-WA1(I-1)*TI2                     RAD00170
            CH(I,K,2) = WA1(I-2)*TI2+WA1(I-1)*TR2                       RAD00180
  103    CONTINUE                                                       RAD00190
  104 CONTINUE                                                          RAD00200
      IF (MOD(IDO,2) .EQ. 1) RETURN                                     RAD00210
  105 DO 106 K=1,L1                                                     RAD00220
         CH(IDO,K,1) = CC(IDO,1,K)+CC(IDO,1,K)                          RAD00230
         CH(IDO,K,2) = -(CC(1,2,K)+CC(1,2,K))                           RAD00240
  106 CONTINUE                                                          RAD00250
  107 RETURN                                                            RAD00260
      END                                                               RAD00270
      SUBROUTINE RADB3 (IDO,L1,CC,CH,WA1,WA2)                           RAD00010
      DIMENSION       CC(IDO,3,L1)           ,CH(IDO,L1,3)           ,  RAD00020
     1                WA1(1)     ,WA2(1)                                RAD00030
      DATA TAUR,TAUI /-.5,.866025403784439/                             RAD00040
      DO 101 K=1,L1                                                     RAD00050
         TR2 = CC(IDO,2,K)+CC(IDO,2,K)                                  RAD00060
         CR2 = CC(1,1,K)+TAUR*TR2                                       RAD00070
         CH(1,K,1) = CC(1,1,K)+TR2                                      RAD00080
         CI3 = TAUI*(CC(1,3,K)+CC(1,3,K))                               RAD00090
         CH(1,K,2) = CR2-CI3                                            RAD00100
         CH(1,K,3) = CR2+CI3                                            RAD00110
  101 CONTINUE                                                          RAD00120
      IF (IDO .EQ. 1) RETURN                                            RAD00130
      IDP2 = IDO+2                                                      RAD00140
      DO 103 K=1,L1                                                     RAD00150
         DO 102 I=3,IDO,2                                               RAD00160
            IC = IDP2-I                                                 RAD00170
            TR2 = CC(I-1,3,K)+CC(IC-1,2,K)                              RAD00180
            CR2 = CC(I-1,1,K)+TAUR*TR2                                  RAD00190
            CH(I-1,K,1) = CC(I-1,1,K)+TR2                               RAD00200
            TI2 = CC(I,3,K)-CC(IC,2,K)                                  RAD00210
            CI2 = CC(I,1,K)+TAUR*TI2                                    RAD00220
            CH(I,K,1) = CC(I,1,K)+TI2                                   RAD00230
            CR3 = TAUI*(CC(I-1,3,K)-CC(IC-1,2,K))                       RAD00240
            CI3 = TAUI*(CC(I,3,K)+CC(IC,2,K))                           RAD00250
            DR2 = CR2-CI3                                               RAD00260
            DR3 = CR2+CI3                                               RAD00270
            DI2 = CI2+CR3                                               RAD00280
            DI3 = CI2-CR3                                               RAD00290
            CH(I-1,K,2) = WA1(I-2)*DR2-WA1(I-1)*DI2                     RAD00300
            CH(I,K,2) = WA1(I-2)*DI2+WA1(I-1)*DR2                       RAD00310
            CH(I-1,K,3) = WA2(I-2)*DR3-WA2(I-1)*DI3                     RAD00320
            CH(I,K,3) = WA2(I-2)*DI3+WA2(I-1)*DR3                       RAD00330
  102    CONTINUE                                                       RAD00340
  103 CONTINUE                                                          RAD00350
      RETURN                                                            RAD00360
      END                                                               RAD00370
      SUBROUTINE RADB4 (IDO,L1,CC,CH,WA1,WA2,WA3)                       RAD00010
      DIMENSION       CC(IDO,4,L1)           ,CH(IDO,L1,4)           ,  RAD00020
     1                WA1(1)     ,WA2(1)     ,WA3(1)                    RAD00030
      DATA SQRT2 /1.414213562373095/                                    RAD00040
      DO 101 K=1,L1                                                     RAD00050
         TR1 = CC(1,1,K)-CC(IDO,4,K)                                    RAD00060
         TR2 = CC(1,1,K)+CC(IDO,4,K)                                    RAD00070
         TR3 = CC(IDO,2,K)+CC(IDO,2,K)                                  RAD00080
         TR4 = CC(1,3,K)+CC(1,3,K)                                      RAD00090
         CH(1,K,1) = TR2+TR3                                            RAD00100
         CH(1,K,2) = TR1-TR4                                            RAD00110
         CH(1,K,3) = TR2-TR3                                            RAD00120
         CH(1,K,4) = TR1+TR4                                            RAD00130
  101 CONTINUE                                                          RAD00140
      IF (IDO-2) 107,105,102                                            RAD00150
  102 IDP2 = IDO+2                                                      RAD00160
      DO 104 K=1,L1                                                     RAD00170
         DO 103 I=3,IDO,2                                               RAD00180
            IC = IDP2-I                                                 RAD00190
            TI1 = CC(I,1,K)+CC(IC,4,K)                                  RAD00200
            TI2 = CC(I,1,K)-CC(IC,4,K)                                  RAD00210
            TI3 = CC(I,3,K)-CC(IC,2,K)                                  RAD00220
            TR4 = CC(I,3,K)+CC(IC,2,K)                                  RAD00230
            TR1 = CC(I-1,1,K)-CC(IC-1,4,K)                              RAD00240
            TR2 = CC(I-1,1,K)+CC(IC-1,4,K)                              RAD00250
            TI4 = CC(I-1,3,K)-CC(IC-1,2,K)                              RAD00260
            TR3 = CC(I-1,3,K)+CC(IC-1,2,K)                              RAD00270
            CH(I-1,K,1) = TR2+TR3                                       RAD00280
            CR3 = TR2-TR3                                               RAD00290
            CH(I,K,1) = TI2+TI3                                         RAD00300
            CI3 = TI2-TI3                                               RAD00310
            CR2 = TR1-TR4                                               RAD00320
            CR4 = TR1+TR4                                               RAD00330
            CI2 = TI1+TI4                                               RAD00340
            CI4 = TI1-TI4                                               RAD00350
            CH(I-1,K,2) = WA1(I-2)*CR2-WA1(I-1)*CI2                     RAD00360
            CH(I,K,2) = WA1(I-2)*CI2+WA1(I-1)*CR2                       RAD00370
            CH(I-1,K,3) = WA2(I-2)*CR3-WA2(I-1)*CI3                     RAD00380
            CH(I,K,3) = WA2(I-2)*CI3+WA2(I-1)*CR3                       RAD00390
            CH(I-1,K,4) = WA3(I-2)*CR4-WA3(I-1)*CI4                     RAD00400
            CH(I,K,4) = WA3(I-2)*CI4+WA3(I-1)*CR4                       RAD00410
  103    CONTINUE                                                       RAD00420
  104 CONTINUE                                                          RAD00430
      IF (MOD(IDO,2) .EQ. 1) RETURN                                     RAD00440
  105 CONTINUE                                                          RAD00450
      DO 106 K=1,L1                                                     RAD00460
         TI1 = CC(1,2,K)+CC(1,4,K)                                      RAD00470
         TI2 = CC(1,4,K)-CC(1,2,K)                                      RAD00480
         TR1 = CC(IDO,1,K)-CC(IDO,3,K)                                  RAD00490
         TR2 = CC(IDO,1,K)+CC(IDO,3,K)                                  RAD00500
         CH(IDO,K,1) = TR2+TR2                                          RAD00510
         CH(IDO,K,2) = SQRT2*(TR1-TI1)                                  RAD00520
         CH(IDO,K,3) = TI2+TI2                                          RAD00530
         CH(IDO,K,4) = -SQRT2*(TR1+TI1)                                 RAD00540
  106 CONTINUE                                                          RAD00550
  107 RETURN                                                            RAD00560
      END                                                               RAD00570
      SUBROUTINE RADB5 (IDO,L1,CC,CH,WA1,WA2,WA3,WA4)                   RAD00010
      DIMENSION       CC(IDO,5,L1)           ,CH(IDO,L1,5)           ,  RAD00020
     1                WA1(1)     ,WA2(1)     ,WA3(1)     ,WA4(1)        RAD00030
      DATA TR11,TI11,TR12,TI12 /.309016994374947,.951056516295154,      RAD00040
     1-.809016994374947,.587785252292473/                               RAD00050
      DO 101 K=1,L1                                                     RAD00060
         TI5 = CC(1,3,K)+CC(1,3,K)                                      RAD00070
         TI4 = CC(1,5,K)+CC(1,5,K)                                      RAD00080
         TR2 = CC(IDO,2,K)+CC(IDO,2,K)                                  RAD00090
         TR3 = CC(IDO,4,K)+CC(IDO,4,K)                                  RAD00100
         CH(1,K,1) = CC(1,1,K)+TR2+TR3                                  RAD00110
         CR2 = CC(1,1,K)+TR11*TR2+TR12*TR3                              RAD00120
         CR3 = CC(1,1,K)+TR12*TR2+TR11*TR3                              RAD00130
         CI5 = TI11*TI5+TI12*TI4                                        RAD00140
         CI4 = TI12*TI5-TI11*TI4                                        RAD00150
         CH(1,K,2) = CR2-CI5                                            RAD00160
         CH(1,K,3) = CR3-CI4                                            RAD00170
         CH(1,K,4) = CR3+CI4                                            RAD00180
         CH(1,K,5) = CR2+CI5                                            RAD00190
  101 CONTINUE                                                          RAD00200
      IF (IDO .EQ. 1) RETURN                                            RAD00210
      IDP2 = IDO+2                                                      RAD00220
      DO 103 K=1,L1                                                     RAD00230
         DO 102 I=3,IDO,2                                               RAD00240
            IC = IDP2-I                                                 RAD00250
            TI5 = CC(I,3,K)+CC(IC,2,K)                                  RAD00260
            TI2 = CC(I,3,K)-CC(IC,2,K)                                  RAD00270
            TI4 = CC(I,5,K)+CC(IC,4,K)                                  RAD00280
            TI3 = CC(I,5,K)-CC(IC,4,K)                                  RAD00290
            TR5 = CC(I-1,3,K)-CC(IC-1,2,K)                              RAD00300
            TR2 = CC(I-1,3,K)+CC(IC-1,2,K)                              RAD00310
            TR4 = CC(I-1,5,K)-CC(IC-1,4,K)                              RAD00320
            TR3 = CC(I-1,5,K)+CC(IC-1,4,K)                              RAD00330
            CH(I-1,K,1) = CC(I-1,1,K)+TR2+TR3                           RAD00340
            CH(I,K,1) = CC(I,1,K)+TI2+TI3                               RAD00350
            CR2 = CC(I-1,1,K)+TR11*TR2+TR12*TR3                         RAD00360
            CI2 = CC(I,1,K)+TR11*TI2+TR12*TI3                           RAD00370
            CR3 = CC(I-1,1,K)+TR12*TR2+TR11*TR3                         RAD00380
            CI3 = CC(I,1,K)+TR12*TI2+TR11*TI3                           RAD00390
            CR5 = TI11*TR5+TI12*TR4                                     RAD00400
            CI5 = TI11*TI5+TI12*TI4                                     RAD00410
            CR4 = TI12*TR5-TI11*TR4                                     RAD00420
            CI4 = TI12*TI5-TI11*TI4                                     RAD00430
            DR3 = CR3-CI4                                               RAD00440
            DR4 = CR3+CI4                                               RAD00450
            DI3 = CI3+CR4                                               RAD00460
            DI4 = CI3-CR4                                               RAD00470
            DR5 = CR2+CI5                                               RAD00480
            DR2 = CR2-CI5                                               RAD00490
            DI5 = CI2-CR5                                               RAD00500
            DI2 = CI2+CR5                                               RAD00510
            CH(I-1,K,2) = WA1(I-2)*DR2-WA1(I-1)*DI2                     RAD00520
            CH(I,K,2) = WA1(I-2)*DI2+WA1(I-1)*DR2                       RAD00530
            CH(I-1,K,3) = WA2(I-2)*DR3-WA2(I-1)*DI3                     RAD00540
            CH(I,K,3) = WA2(I-2)*DI3+WA2(I-1)*DR3                       RAD00550
            CH(I-1,K,4) = WA3(I-2)*DR4-WA3(I-1)*DI4                     RAD00560
            CH(I,K,4) = WA3(I-2)*DI4+WA3(I-1)*DR4                       RAD00570
            CH(I-1,K,5) = WA4(I-2)*DR5-WA4(I-1)*DI5                     RAD00580
            CH(I,K,5) = WA4(I-2)*DI5+WA4(I-1)*DR5                       RAD00590
  102    CONTINUE                                                       RAD00600
  103 CONTINUE                                                          RAD00610
      RETURN                                                            RAD00620
      END                                                               RAD00630
      SUBROUTINE RADBG (IDO,IP,L1,IDL1,CC,C1,C2,CH,CH2,WA)              RAD00010
      DIMENSION       CH(IDO,L1,IP)          ,CC(IDO,IP,L1)          ,  RAD00020
     1                C1(IDO,L1,IP)          ,C2(IDL1,IP),              RAD00030
     2                CH2(IDL1,IP)           ,WA(1)                     RAD00040
      DATA TPI/6.28318530717959/                                        RAD00050
      ARG = TPI/FLOAT(IP)                                               RAD00060
      DCP = COS(ARG)                                                    RAD00070
      DSP = SIN(ARG)                                                    RAD00080
      IDP2 = IDO+2                                                      RAD00090
      NBD = (IDO-1)/2                                                   RAD00100
      IPP2 = IP+2                                                       RAD00110
      IPPH = (IP+1)/2                                                   RAD00120
      IF (IDO .LT. L1) GO TO 103                                        RAD00130
      DO 102 K=1,L1                                                     RAD00140
         DO 101 I=1,IDO                                                 RAD00150
            CH(I,K,1) = CC(I,1,K)                                       RAD00160
  101    CONTINUE                                                       RAD00170
  102 CONTINUE                                                          RAD00180
      GO TO 106                                                         RAD00190
  103 DO 105 I=1,IDO                                                    RAD00200
         DO 104 K=1,L1                                                  RAD00210
            CH(I,K,1) = CC(I,1,K)                                       RAD00220
  104    CONTINUE                                                       RAD00230
  105 CONTINUE                                                          RAD00240
  106 DO 108 J=2,IPPH                                                   RAD00250
         JC = IPP2-J                                                    RAD00260
         J2 = J+J                                                       RAD00270
         DO 107 K=1,L1                                                  RAD00280
            CH(1,K,J) = CC(IDO,J2-2,K)+CC(IDO,J2-2,K)                   RAD00290
            CH(1,K,JC) = CC(1,J2-1,K)+CC(1,J2-1,K)                      RAD00300
  107    CONTINUE                                                       RAD00310
  108 CONTINUE                                                          RAD00320
      IF (IDO .EQ. 1) GO TO 116                                         RAD00330
      IF (NBD .LT. L1) GO TO 112                                        RAD00340
      DO 111 J=2,IPPH                                                   RAD00350
         JC = IPP2-J                                                    RAD00360
         DO 110 K=1,L1                                                  RAD00370
            DO 109 I=3,IDO,2                                            RAD00380
               IC = IDP2-I                                              RAD00390
               CH(I-1,K,J) = CC(I-1,2*J-1,K)+CC(IC-1,2*J-2,K)           RAD00400
               CH(I-1,K,JC) = CC(I-1,2*J-1,K)-CC(IC-1,2*J-2,K)          RAD00410
               CH(I,K,J) = CC(I,2*J-1,K)-CC(IC,2*J-2,K)                 RAD00420
               CH(I,K,JC) = CC(I,2*J-1,K)+CC(IC,2*J-2,K)                RAD00430
  109       CONTINUE                                                    RAD00440
  110    CONTINUE                                                       RAD00450
  111 CONTINUE                                                          RAD00460
      GO TO 116                                                         RAD00470
  112 DO 115 J=2,IPPH                                                   RAD00480
         JC = IPP2-J                                                    RAD00490
         DO 114 I=3,IDO,2                                               RAD00500
            IC = IDP2-I                                                 RAD00510
            DO 113 K=1,L1                                               RAD00520
               CH(I-1,K,J) = CC(I-1,2*J-1,K)+CC(IC-1,2*J-2,K)           RAD00530
               CH(I-1,K,JC) = CC(I-1,2*J-1,K)-CC(IC-1,2*J-2,K)          RAD00540
               CH(I,K,J) = CC(I,2*J-1,K)-CC(IC,2*J-2,K)                 RAD00550
               CH(I,K,JC) = CC(I,2*J-1,K)+CC(IC,2*J-2,K)                RAD00560
  113       CONTINUE                                                    RAD00570
  114    CONTINUE                                                       RAD00580
  115 CONTINUE                                                          RAD00590
  116 AR1 = 1.                                                          RAD00600
      AI1 = 0.                                                          RAD00610
      DO 120 L=2,IPPH                                                   RAD00620
         LC = IPP2-L                                                    RAD00630
         AR1H = DCP*AR1-DSP*AI1                                         RAD00640
         AI1 = DCP*AI1+DSP*AR1                                          RAD00650
         AR1 = AR1H                                                     RAD00660
         DO 117 IK=1,IDL1                                               RAD00670
            C2(IK,L) = CH2(IK,1)+AR1*CH2(IK,2)                          RAD00680
            C2(IK,LC) = AI1*CH2(IK,IP)                                  RAD00690
  117    CONTINUE                                                       RAD00700
         DC2 = AR1                                                      RAD00710
         DS2 = AI1                                                      RAD00720
         AR2 = AR1                                                      RAD00730
         AI2 = AI1                                                      RAD00740
         DO 119 J=3,IPPH                                                RAD00750
            JC = IPP2-J                                                 RAD00760
            AR2H = DC2*AR2-DS2*AI2                                      RAD00770
            AI2 = DC2*AI2+DS2*AR2                                       RAD00780
            AR2 = AR2H                                                  RAD00790
            DO 118 IK=1,IDL1                                            RAD00800
               C2(IK,L) = C2(IK,L)+AR2*CH2(IK,J)                        RAD00810
               C2(IK,LC) = C2(IK,LC)+AI2*CH2(IK,JC)                     RAD00820
  118       CONTINUE                                                    RAD00830
  119    CONTINUE                                                       RAD00840
  120 CONTINUE                                                          RAD00850
      DO 122 J=2,IPPH                                                   RAD00860
         DO 121 IK=1,IDL1                                               RAD00870
            CH2(IK,1) = CH2(IK,1)+CH2(IK,J)                             RAD00880
  121    CONTINUE                                                       RAD00890
  122 CONTINUE                                                          RAD00900
      DO 124 J=2,IPPH                                                   RAD00910
         JC = IPP2-J                                                    RAD00920
         DO 123 K=1,L1                                                  RAD00930
            CH(1,K,J) = C1(1,K,J)-C1(1,K,JC)                            RAD00940
            CH(1,K,JC) = C1(1,K,J)+C1(1,K,JC)                           RAD00950
  123    CONTINUE                                                       RAD00960
  124 CONTINUE                                                          RAD00970
      IF (IDO .EQ. 1) GO TO 132                                         RAD00980
      IF (NBD .LT. L1) GO TO 128                                        RAD00990
      DO 127 J=2,IPPH                                                   RAD01000
         JC = IPP2-J                                                    RAD01010
         DO 126 K=1,L1                                                  RAD01020
            DO 125 I=3,IDO,2                                            RAD01030
               CH(I-1,K,J) = C1(I-1,K,J)-C1(I,K,JC)                     RAD01040
               CH(I-1,K,JC) = C1(I-1,K,J)+C1(I,K,JC)                    RAD01050
               CH(I,K,J) = C1(I,K,J)+C1(I-1,K,JC)                       RAD01060
               CH(I,K,JC) = C1(I,K,J)-C1(I-1,K,JC)                      RAD01070
  125       CONTINUE                                                    RAD01080
  126    CONTINUE                                                       RAD01090
  127 CONTINUE                                                          RAD01100
      GO TO 132                                                         RAD01110
  128 DO 131 J=2,IPPH                                                   RAD01120
         JC = IPP2-J                                                    RAD01130
         DO 130 I=3,IDO,2                                               RAD01140
            DO 129 K=1,L1                                               RAD01150
               CH(I-1,K,J) = C1(I-1,K,J)-C1(I,K,JC)                     RAD01160
               CH(I-1,K,JC) = C1(I-1,K,J)+C1(I,K,JC)                    RAD01170
               CH(I,K,J) = C1(I,K,J)+C1(I-1,K,JC)                       RAD01180
               CH(I,K,JC) = C1(I,K,J)-C1(I-1,K,JC)                      RAD01190
  129       CONTINUE                                                    RAD01200
  130    CONTINUE                                                       RAD01210
  131 CONTINUE                                                          RAD01220
  132 CONTINUE                                                          RAD01230
      IF (IDO .EQ. 1) RETURN                                            RAD01240
      DO 133 IK=1,IDL1                                                  RAD01250
         C2(IK,1) = CH2(IK,1)                                           RAD01260
  133 CONTINUE                                                          RAD01270
      DO 135 J=2,IP                                                     RAD01280
         DO 134 K=1,L1                                                  RAD01290
            C1(1,K,J) = CH(1,K,J)                                       RAD01300
  134    CONTINUE                                                       RAD01310
  135 CONTINUE                                                          RAD01320
      IF (NBD .GT. L1) GO TO 139                                        RAD01330
      IS = -IDO                                                         RAD01340
      DO 138 J=2,IP                                                     RAD01350
         IS = IS+IDO                                                    RAD01360
         IDIJ = IS                                                      RAD01370
         DO 137 I=3,IDO,2                                               RAD01380
            IDIJ = IDIJ+2                                               RAD01390
            DO 136 K=1,L1                                               RAD01400
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)-WA(IDIJ)*CH(I,K,J)  RAD01410
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)+WA(IDIJ)*CH(I-1,K,J)    RAD01420
  136       CONTINUE                                                    RAD01430
  137    CONTINUE                                                       RAD01440
  138 CONTINUE                                                          RAD01450
      GO TO 143                                                         RAD01460
  139 IS = -IDO                                                         RAD01470
      DO 142 J=2,IP                                                     RAD01480
         IS = IS+IDO                                                    RAD01490
         DO 141 K=1,L1                                                  RAD01500
            IDIJ = IS                                                   RAD01510
            DO 140 I=3,IDO,2                                            RAD01520
               IDIJ = IDIJ+2                                            RAD01530
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)-WA(IDIJ)*CH(I,K,J)  RAD01540
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)+WA(IDIJ)*CH(I-1,K,J)    RAD01550
  140       CONTINUE                                                    RAD01560
  141    CONTINUE                                                       RAD01570
  142 CONTINUE                                                          RAD01580
  143 RETURN                                                            RAD01590
      END                                                               RAD01600
      SUBROUTINE RADF2 (IDO,L1,CC,CH,WA1)                               RAD00010
      DIMENSION       CH(IDO,2,L1)           ,CC(IDO,L1,2)           ,  RAD00020
     1                WA1(1)                                            RAD00030
      DO 101 K=1,L1                                                     RAD00040
         CH(1,1,K) = CC(1,K,1)+CC(1,K,2)                                RAD00050
         CH(IDO,2,K) = CC(1,K,1)-CC(1,K,2)                              RAD00060
  101 CONTINUE                                                          RAD00070
      IF (IDO-2) 107,105,102                                            RAD00080
  102 IDP2 = IDO+2                                                      RAD00090
      DO 104 K=1,L1                                                     RAD00100
         DO 103 I=3,IDO,2                                               RAD00110
            IC = IDP2-I                                                 RAD00120
            TR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)               RAD00130
            TI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)               RAD00140
            CH(I,1,K) = CC(I,K,1)+TI2                                   RAD00150
            CH(IC,2,K) = TI2-CC(I,K,1)                                  RAD00160
            CH(I-1,1,K) = CC(I-1,K,1)+TR2                               RAD00170
            CH(IC-1,2,K) = CC(I-1,K,1)-TR2                              RAD00180
  103    CONTINUE                                                       RAD00190
  104 CONTINUE                                                          RAD00200
      IF (MOD(IDO,2) .EQ. 1) RETURN                                     RAD00210
  105 DO 106 K=1,L1                                                     RAD00220
         CH(1,2,K) = -CC(IDO,K,2)                                       RAD00230
         CH(IDO,1,K) = CC(IDO,K,1)                                      RAD00240
  106 CONTINUE                                                          RAD00250
  107 RETURN                                                            RAD00260
      END                                                               RAD00270
      SUBROUTINE RADF3 (IDO,L1,CC,CH,WA1,WA2)                           RAD00010
      DIMENSION       CH(IDO,3,L1)           ,CC(IDO,L1,3)           ,  RAD00020
     1                WA1(1)     ,WA2(1)                                RAD00030
      DATA TAUR,TAUI /-.5,.866025403784439/                             RAD00040
      DO 101 K=1,L1                                                     RAD00050
         CR2 = CC(1,K,2)+CC(1,K,3)                                      RAD00060
         CH(1,1,K) = CC(1,K,1)+CR2                                      RAD00070
         CH(1,3,K) = TAUI*(CC(1,K,3)-CC(1,K,2))                         RAD00080
         CH(IDO,2,K) = CC(1,K,1)+TAUR*CR2                               RAD00090
  101 CONTINUE                                                          RAD00100
      IF (IDO .EQ. 1) RETURN                                            RAD00110
      IDP2 = IDO+2                                                      RAD00120
      DO 103 K=1,L1                                                     RAD00130
         DO 102 I=3,IDO,2                                               RAD00140
            IC = IDP2-I                                                 RAD00150
            DR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)               RAD00160
            DI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)               RAD00170
            DR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)               RAD00180
            DI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)               RAD00190
            CR2 = DR2+DR3                                               RAD00200
            CI2 = DI2+DI3                                               RAD00210
            CH(I-1,1,K) = CC(I-1,K,1)+CR2                               RAD00220
            CH(I,1,K) = CC(I,K,1)+CI2                                   RAD00230
            TR2 = CC(I-1,K,1)+TAUR*CR2                                  RAD00240
            TI2 = CC(I,K,1)+TAUR*CI2                                    RAD00250
            TR3 = TAUI*(DI2-DI3)                                        RAD00260
            TI3 = TAUI*(DR3-DR2)                                        RAD00270
            CH(I-1,3,K) = TR2+TR3                                       RAD00280
            CH(IC-1,2,K) = TR2-TR3                                      RAD00290
            CH(I,3,K) = TI2+TI3                                         RAD00300
            CH(IC,2,K) = TI3-TI2                                        RAD00310
  102    CONTINUE                                                       RAD00320
  103 CONTINUE                                                          RAD00330
      RETURN                                                            RAD00340
      END                                                               RAD00350
      SUBROUTINE RADF4 (IDO,L1,CC,CH,WA1,WA2,WA3)                       RAD00010
      DIMENSION       CC(IDO,L1,4)           ,CH(IDO,4,L1)           ,  RAD00020
     1                WA1(1)     ,WA2(1)     ,WA3(1)                    RAD00030
      DATA HSQT2 /.7071067811865475/                                    RAD00040
      DO 101 K=1,L1                                                     RAD00050
         TR1 = CC(1,K,2)+CC(1,K,4)                                      RAD00060
         TR2 = CC(1,K,1)+CC(1,K,3)                                      RAD00070
         CH(1,1,K) = TR1+TR2                                            RAD00080
         CH(IDO,4,K) = TR2-TR1                                          RAD00090
         CH(IDO,2,K) = CC(1,K,1)-CC(1,K,3)                              RAD00100
         CH(1,3,K) = CC(1,K,4)-CC(1,K,2)                                RAD00110
  101 CONTINUE                                                          RAD00120
      IF (IDO-2) 107,105,102                                            RAD00130
  102 IDP2 = IDO+2                                                      RAD00140
      DO 104 K=1,L1                                                     RAD00150
         DO 103 I=3,IDO,2                                               RAD00160
            IC = IDP2-I                                                 RAD00170
            CR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)               RAD00180
            CI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)               RAD00190
            CR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)               RAD00200
            CI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)               RAD00210
            CR4 = WA3(I-2)*CC(I-1,K,4)+WA3(I-1)*CC(I,K,4)               RAD00220
            CI4 = WA3(I-2)*CC(I,K,4)-WA3(I-1)*CC(I-1,K,4)               RAD00230
            TR1 = CR2+CR4                                               RAD00240
            TR4 = CR4-CR2                                               RAD00250
            TI1 = CI2+CI4                                               RAD00260
            TI4 = CI2-CI4                                               RAD00270
            TI2 = CC(I,K,1)+CI3                                         RAD00280
            TI3 = CC(I,K,1)-CI3                                         RAD00290
            TR2 = CC(I-1,K,1)+CR3                                       RAD00300
            TR3 = CC(I-1,K,1)-CR3                                       RAD00310
            CH(I-1,1,K) = TR1+TR2                                       RAD00320
            CH(IC-1,4,K) = TR2-TR1                                      RAD00330
            CH(I,1,K) = TI1+TI2                                         RAD00340
            CH(IC,4,K) = TI1-TI2                                        RAD00350
            CH(I-1,3,K) = TI4+TR3                                       RAD00360
            CH(IC-1,2,K) = TR3-TI4                                      RAD00370
            CH(I,3,K) = TR4+TI3                                         RAD00380
            CH(IC,2,K) = TR4-TI3                                        RAD00390
  103    CONTINUE                                                       RAD00400
  104 CONTINUE                                                          RAD00410
      IF (MOD(IDO,2) .EQ. 1) RETURN                                     RAD00420
  105 CONTINUE                                                          RAD00430
      DO 106 K=1,L1                                                     RAD00440
         TI1 = -HSQT2*(CC(IDO,K,2)+CC(IDO,K,4))                         RAD00450
         TR1 = HSQT2*(CC(IDO,K,2)-CC(IDO,K,4))                          RAD00460
         CH(IDO,1,K) = TR1+CC(IDO,K,1)                                  RAD00470
         CH(IDO,3,K) = CC(IDO,K,1)-TR1                                  RAD00480
         CH(1,2,K) = TI1-CC(IDO,K,3)                                    RAD00490
         CH(1,4,K) = TI1+CC(IDO,K,3)                                    RAD00500
  106 CONTINUE                                                          RAD00510
  107 RETURN                                                            RAD00520
      END                                                               RAD00530
      SUBROUTINE RADF5 (IDO,L1,CC,CH,WA1,WA2,WA3,WA4)                   RAD00010
      DIMENSION       CC(IDO,L1,5)           ,CH(IDO,5,L1)           ,  RAD00020
     1                WA1(1)     ,WA2(1)     ,WA3(1)     ,WA4(1)        RAD00030
      DATA TR11,TI11,TR12,TI12 /.309016994374947,.951056516295154,      RAD00040
     1-.809016994374947,.587785252292473/                               RAD00050
      DO 101 K=1,L1                                                     RAD00060
         CR2 = CC(1,K,5)+CC(1,K,2)                                      RAD00070
         CI5 = CC(1,K,5)-CC(1,K,2)                                      RAD00080
         CR3 = CC(1,K,4)+CC(1,K,3)                                      RAD00090
         CI4 = CC(1,K,4)-CC(1,K,3)                                      RAD00100
         CH(1,1,K) = CC(1,K,1)+CR2+CR3                                  RAD00110
         CH(IDO,2,K) = CC(1,K,1)+TR11*CR2+TR12*CR3                      RAD00120
         CH(1,3,K) = TI11*CI5+TI12*CI4                                  RAD00130
         CH(IDO,4,K) = CC(1,K,1)+TR12*CR2+TR11*CR3                      RAD00140
         CH(1,5,K) = TI12*CI5-TI11*CI4                                  RAD00150
  101 CONTINUE                                                          RAD00160
      IF (IDO .EQ. 1) RETURN                                            RAD00170
      IDP2 = IDO+2                                                      RAD00180
      DO 103 K=1,L1                                                     RAD00190
         DO 102 I=3,IDO,2                                               RAD00200
            IC = IDP2-I                                                 RAD00210
            DR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)               RAD00220
            DI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)               RAD00230
            DR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)               RAD00240
            DI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)               RAD00250
            DR4 = WA3(I-2)*CC(I-1,K,4)+WA3(I-1)*CC(I,K,4)               RAD00260
            DI4 = WA3(I-2)*CC(I,K,4)-WA3(I-1)*CC(I-1,K,4)               RAD00270
            DR5 = WA4(I-2)*CC(I-1,K,5)+WA4(I-1)*CC(I,K,5)               RAD00280
            DI5 = WA4(I-2)*CC(I,K,5)-WA4(I-1)*CC(I-1,K,5)               RAD00290
            CR2 = DR2+DR5                                               RAD00300
            CI5 = DR5-DR2                                               RAD00310
            CR5 = DI2-DI5                                               RAD00320
            CI2 = DI2+DI5                                               RAD00330
            CR3 = DR3+DR4                                               RAD00340
            CI4 = DR4-DR3                                               RAD00350
            CR4 = DI3-DI4                                               RAD00360
            CI3 = DI3+DI4                                               RAD00370
            CH(I-1,1,K) = CC(I-1,K,1)+CR2+CR3                           RAD00380
            CH(I,1,K) = CC(I,K,1)+CI2+CI3                               RAD00390
            TR2 = CC(I-1,K,1)+TR11*CR2+TR12*CR3                         RAD00400
            TI2 = CC(I,K,1)+TR11*CI2+TR12*CI3                           RAD00410
            TR3 = CC(I-1,K,1)+TR12*CR2+TR11*CR3                         RAD00420
            TI3 = CC(I,K,1)+TR12*CI2+TR11*CI3                           RAD00430
            TR5 = TI11*CR5+TI12*CR4                                     RAD00440
            TI5 = TI11*CI5+TI12*CI4                                     RAD00450
            TR4 = TI12*CR5-TI11*CR4                                     RAD00460
            TI4 = TI12*CI5-TI11*CI4                                     RAD00470
            CH(I-1,3,K) = TR2+TR5                                       RAD00480
            CH(IC-1,2,K) = TR2-TR5                                      RAD00490
            CH(I,3,K) = TI2+TI5                                         RAD00500
            CH(IC,2,K) = TI5-TI2                                        RAD00510
            CH(I-1,5,K) = TR3+TR4                                       RAD00520
            CH(IC-1,4,K) = TR3-TR4                                      RAD00530
            CH(I,5,K) = TI3+TI4                                         RAD00540
            CH(IC,4,K) = TI4-TI3                                        RAD00550
  102    CONTINUE                                                       RAD00560
  103 CONTINUE                                                          RAD00570
      RETURN                                                            RAD00580
      END                                                               RAD00590
      SUBROUTINE RADFG (IDO,IP,L1,IDL1,CC,C1,C2,CH,CH2,WA)              RAD00010
      DIMENSION       CH(IDO,L1,IP)          ,CC(IDO,IP,L1)          ,  RAD00020
     1                C1(IDO,L1,IP)          ,C2(IDL1,IP),              RAD00030
     2                CH2(IDL1,IP)           ,WA(1)                     RAD00040
      DATA TPI/6.28318530717959/                                        RAD00050
      ARG = TPI/FLOAT(IP)                                               RAD00060
      DCP = COS(ARG)                                                    RAD00070
      DSP = SIN(ARG)                                                    RAD00080
      IPPH = (IP+1)/2                                                   RAD00090
      IPP2 = IP+2                                                       RAD00100
      IDP2 = IDO+2                                                      RAD00110
      NBD = (IDO-1)/2                                                   RAD00120
      IF (IDO .EQ. 1) GO TO 119                                         RAD00130
      DO 101 IK=1,IDL1                                                  RAD00140
         CH2(IK,1) = C2(IK,1)                                           RAD00150
  101 CONTINUE                                                          RAD00160
      DO 103 J=2,IP                                                     RAD00170
         DO 102 K=1,L1                                                  RAD00180
            CH(1,K,J) = C1(1,K,J)                                       RAD00190
  102    CONTINUE                                                       RAD00200
  103 CONTINUE                                                          RAD00210
      IF (NBD .GT. L1) GO TO 107                                        RAD00220
      IS = -IDO                                                         RAD00230
      DO 106 J=2,IP                                                     RAD00240
         IS = IS+IDO                                                    RAD00250
         IDIJ = IS                                                      RAD00260
         DO 105 I=3,IDO,2                                               RAD00270
            IDIJ = IDIJ+2                                               RAD00280
            DO 104 K=1,L1                                               RAD00290
               CH(I-1,K,J) = WA(IDIJ-1)*C1(I-1,K,J)+WA(IDIJ)*C1(I,K,J)  RAD00300
               CH(I,K,J) = WA(IDIJ-1)*C1(I,K,J)-WA(IDIJ)*C1(I-1,K,J)    RAD00310
  104       CONTINUE                                                    RAD00320
  105    CONTINUE                                                       RAD00330
  106 CONTINUE                                                          RAD00340
      GO TO 111                                                         RAD00350
  107 IS = -IDO                                                         RAD00360
      DO 110 J=2,IP                                                     RAD00370
         IS = IS+IDO                                                    RAD00380
         DO 109 K=1,L1                                                  RAD00390
            IDIJ = IS                                                   RAD00400
            DO 108 I=3,IDO,2                                            RAD00410
               IDIJ = IDIJ+2                                            RAD00420
               CH(I-1,K,J) = WA(IDIJ-1)*C1(I-1,K,J)+WA(IDIJ)*C1(I,K,J)  RAD00430
               CH(I,K,J) = WA(IDIJ-1)*C1(I,K,J)-WA(IDIJ)*C1(I-1,K,J)    RAD00440
  108       CONTINUE                                                    RAD00450
  109    CONTINUE                                                       RAD00460
  110 CONTINUE                                                          RAD00470
  111 IF (NBD .LT. L1) GO TO 115                                        RAD00480
      DO 114 J=2,IPPH                                                   RAD00490
         JC = IPP2-J                                                    RAD00500
         DO 113 K=1,L1                                                  RAD00510
            DO 112 I=3,IDO,2                                            RAD00520
               C1(I-1,K,J) = CH(I-1,K,J)+CH(I-1,K,JC)                   RAD00530
               C1(I-1,K,JC) = CH(I,K,J)-CH(I,K,JC)                      RAD00540
               C1(I,K,J) = CH(I,K,J)+CH(I,K,JC)                         RAD00550
               C1(I,K,JC) = CH(I-1,K,JC)-CH(I-1,K,J)                    RAD00560
  112       CONTINUE                                                    RAD00570
  113    CONTINUE                                                       RAD00580
  114 CONTINUE                                                          RAD00590
      GO TO 121                                                         RAD00600
  115 DO 118 J=2,IPPH                                                   RAD00610
         JC = IPP2-J                                                    RAD00620
         DO 117 I=3,IDO,2                                               RAD00630
            DO 116 K=1,L1                                               RAD00640
               C1(I-1,K,J) = CH(I-1,K,J)+CH(I-1,K,JC)                   RAD00650
               C1(I-1,K,JC) = CH(I,K,J)-CH(I,K,JC)                      RAD00660
               C1(I,K,J) = CH(I,K,J)+CH(I,K,JC)                         RAD00670
               C1(I,K,JC) = CH(I-1,K,JC)-CH(I-1,K,J)                    RAD00680
  116       CONTINUE                                                    RAD00690
  117    CONTINUE                                                       RAD00700
  118 CONTINUE                                                          RAD00710
      GO TO 121                                                         RAD00720
  119 DO 120 IK=1,IDL1                                                  RAD00730
         C2(IK,1) = CH2(IK,1)                                           RAD00740
  120 CONTINUE                                                          RAD00750
  121 DO 123 J=2,IPPH                                                   RAD00760
         JC = IPP2-J                                                    RAD00770
         DO 122 K=1,L1                                                  RAD00780
            C1(1,K,J) = CH(1,K,J)+CH(1,K,JC)                            RAD00790
            C1(1,K,JC) = CH(1,K,JC)-CH(1,K,J)                           RAD00800
  122    CONTINUE                                                       RAD00810
  123 CONTINUE                                                          RAD00820
C                                                                       RAD00830
      AR1 = 1.                                                          RAD00840
      AI1 = 0.                                                          RAD00850
      DO 127 L=2,IPPH                                                   RAD00860
         LC = IPP2-L                                                    RAD00870
         AR1H = DCP*AR1-DSP*AI1                                         RAD00880
         AI1 = DCP*AI1+DSP*AR1                                          RAD00890
         AR1 = AR1H                                                     RAD00900
         DO 124 IK=1,IDL1                                               RAD00910
            CH2(IK,L) = C2(IK,1)+AR1*C2(IK,2)                           RAD00920
            CH2(IK,LC) = AI1*C2(IK,IP)                                  RAD00930
  124    CONTINUE                                                       RAD00940
         DC2 = AR1                                                      RAD00950
         DS2 = AI1                                                      RAD00960
         AR2 = AR1                                                      RAD00970
         AI2 = AI1                                                      RAD00980
         DO 126 J=3,IPPH                                                RAD00990
            JC = IPP2-J                                                 RAD01000
            AR2H = DC2*AR2-DS2*AI2                                      RAD01010
            AI2 = DC2*AI2+DS2*AR2                                       RAD01020
            AR2 = AR2H                                                  RAD01030
            DO 125 IK=1,IDL1                                            RAD01040
               CH2(IK,L) = CH2(IK,L)+AR2*C2(IK,J)                       RAD01050
               CH2(IK,LC) = CH2(IK,LC)+AI2*C2(IK,JC)                    RAD01060
  125       CONTINUE                                                    RAD01070
  126    CONTINUE                                                       RAD01080
  127 CONTINUE                                                          RAD01090
      DO 129 J=2,IPPH                                                   RAD01100
         DO 128 IK=1,IDL1                                               RAD01110
            CH2(IK,1) = CH2(IK,1)+C2(IK,J)                              RAD01120
  128    CONTINUE                                                       RAD01130
  129 CONTINUE                                                          RAD01140
C                                                                       RAD01150
      IF (IDO .LT. L1) GO TO 132                                        RAD01160
      DO 131 K=1,L1                                                     RAD01170
         DO 130 I=1,IDO                                                 RAD01180
            CC(I,1,K) = CH(I,K,1)                                       RAD01190
  130    CONTINUE                                                       RAD01200
  131 CONTINUE                                                          RAD01210
      GO TO 135                                                         RAD01220
  132 DO 134 I=1,IDO                                                    RAD01230
         DO 133 K=1,L1                                                  RAD01240
            CC(I,1,K) = CH(I,K,1)                                       RAD01250
  133    CONTINUE                                                       RAD01260
  134 CONTINUE                                                          RAD01270
  135 DO 137 J=2,IPPH                                                   RAD01280
         JC = IPP2-J                                                    RAD01290
         J2 = J+J                                                       RAD01300
         DO 136 K=1,L1                                                  RAD01310
            CC(IDO,J2-2,K) = CH(1,K,J)                                  RAD01320
            CC(1,J2-1,K) = CH(1,K,JC)                                   RAD01330
  136    CONTINUE                                                       RAD01340
  137 CONTINUE                                                          RAD01350
      IF (IDO .EQ. 1) RETURN                                            RAD01360
      IF (NBD .LT. L1) GO TO 141                                        RAD01370
      DO 140 J=2,IPPH                                                   RAD01380
         JC = IPP2-J                                                    RAD01390
         J2 = J+J                                                       RAD01400
         DO 139 K=1,L1                                                  RAD01410
            DO 138 I=3,IDO,2                                            RAD01420
               IC = IDP2-I                                              RAD01430
               CC(I-1,J2-1,K) = CH(I-1,K,J)+CH(I-1,K,JC)                RAD01440
               CC(IC-1,J2-2,K) = CH(I-1,K,J)-CH(I-1,K,JC)               RAD01450
               CC(I,J2-1,K) = CH(I,K,J)+CH(I,K,JC)                      RAD01460
               CC(IC,J2-2,K) = CH(I,K,JC)-CH(I,K,J)                     RAD01470
  138       CONTINUE                                                    RAD01480
  139    CONTINUE                                                       RAD01490
  140 CONTINUE                                                          RAD01500
      RETURN                                                            RAD01510
  141 DO 144 J=2,IPPH                                                   RAD01520
         JC = IPP2-J                                                    RAD01530
         J2 = J+J                                                       RAD01540
         DO 143 I=3,IDO,2                                               RAD01550
            IC = IDP2-I                                                 RAD01560
            DO 142 K=1,L1                                               RAD01570
               CC(I-1,J2-1,K) = CH(I-1,K,J)+CH(I-1,K,JC)                RAD01580
               CC(IC-1,J2-2,K) = CH(I-1,K,J)-CH(I-1,K,JC)               RAD01590
               CC(I,J2-1,K) = CH(I,K,J)+CH(I,K,JC)                      RAD01600
               CC(IC,J2-2,K) = CH(I,K,JC)-CH(I,K,J)                     RAD01610
  142       CONTINUE                                                    RAD01620
  143    CONTINUE                                                       RAD01630
  144 CONTINUE                                                          RAD01640
      RETURN                                                            RAD01650
      END                                                               RAD01660
      SUBROUTINE RFFTB (N,R,WSAVE)                                      RFF00010
      DIMENSION       R(1)       ,WSAVE(1)                              RFF00020
      IF (N .EQ. 1) RETURN                                              RFF00030
      CALL RFFTB1 (N,R,WSAVE,WSAVE(N+1),WSAVE(2*N+1))                   RFF00040
      RETURN                                                            RFF00050
      END                                                               RFF00060
      SUBROUTINE RFFTB1 (N,C,CH,WA,IFAC)                                RFF00010
      DIMENSION       CH(1)      ,C(1)       ,WA(1)      ,IFAC(1)       RFF00020
      NF = IFAC(2)                                                      RFF00030
      NA = 0                                                            RFF00040
      L1 = 1                                                            RFF00050
      IW = 1                                                            RFF00060
      DO 116 K1=1,NF                                                    RFF00070
         IP = IFAC(K1+2)                                                RFF00080
         L2 = IP*L1                                                     RFF00090
         IDO = N/L2                                                     RFF00100
         IDL1 = IDO*L1                                                  RFF00110
         IF (IP .NE. 4) GO TO 103                                       RFF00120
         IX2 = IW+IDO                                                   RFF00130
         IX3 = IX2+IDO                                                  RFF00140
         IF (NA .NE. 0) GO TO 101                                       RFF00150
         CALL RADB4 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3))                RFF00160
         GO TO 102                                                      RFF00170
  101    CALL RADB4 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3))                RFF00180
  102    NA = 1-NA                                                      RFF00190
         GO TO 115                                                      RFF00200
  103    IF (IP .NE. 2) GO TO 106                                       RFF00210
         IF (NA .NE. 0) GO TO 104                                       RFF00220
         CALL RADB2 (IDO,L1,C,CH,WA(IW))                                RFF00230
         GO TO 105                                                      RFF00240
  104    CALL RADB2 (IDO,L1,CH,C,WA(IW))                                RFF00250
  105    NA = 1-NA                                                      RFF00260
         GO TO 115                                                      RFF00270
  106    IF (IP .NE. 3) GO TO 109                                       RFF00280
         IX2 = IW+IDO                                                   RFF00290
         IF (NA .NE. 0) GO TO 107                                       RFF00300
         CALL RADB3 (IDO,L1,C,CH,WA(IW),WA(IX2))                        RFF00310
         GO TO 108                                                      RFF00320
  107    CALL RADB3 (IDO,L1,CH,C,WA(IW),WA(IX2))                        RFF00330
  108    NA = 1-NA                                                      RFF00340
         GO TO 115                                                      RFF00350
  109    IF (IP .NE. 5) GO TO 112                                       RFF00360
         IX2 = IW+IDO                                                   RFF00370
         IX3 = IX2+IDO                                                  RFF00380
         IX4 = IX3+IDO                                                  RFF00390
         IF (NA .NE. 0) GO TO 110                                       RFF00400
         CALL RADB5 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3),WA(IX4))        RFF00410
         GO TO 111                                                      RFF00420
  110    CALL RADB5 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3),WA(IX4))        RFF00430
  111    NA = 1-NA                                                      RFF00440
         GO TO 115                                                      RFF00450
  112    IF (NA .NE. 0) GO TO 113                                       RFF00460
         CALL RADBG (IDO,IP,L1,IDL1,C,C,C,CH,CH,WA(IW))                 RFF00470
         GO TO 114                                                      RFF00480
  113    CALL RADBG (IDO,IP,L1,IDL1,CH,CH,CH,C,C,WA(IW))                RFF00490
  114    IF (IDO .EQ. 1) NA = 1-NA                                      RFF00500
  115    L1 = L2                                                        RFF00510
         IW = IW+(IP-1)*IDO                                             RFF00520
  116 CONTINUE                                                          RFF00530
      IF (NA .EQ. 0) RETURN                                             RFF00540
      DO 117 I=1,N                                                      RFF00550
         C(I) = CH(I)                                                   RFF00560
  117 CONTINUE                                                          RFF00570
      RETURN                                                            RFF00580
      END                                                               RFF00590
      SUBROUTINE RFFTF (N,R,WSAVE)                                      RFF00010
      DIMENSION       R(1)       ,WSAVE(1)                              RFF00020
      IF (N .EQ. 1) RETURN                                              RFF00030
      CALL RFFTF1 (N,R,WSAVE,WSAVE(N+1),WSAVE(2*N+1))                   RFF00040
      RETURN                                                            RFF00050
      END                                                               RFF00060
      SUBROUTINE RFFTF1 (N,C,CH,WA,IFAC)                                RFF00010
      DIMENSION       CH(1)      ,C(1)       ,WA(1)      ,IFAC(1)       RFF00020
      NF = IFAC(2)                                                      RFF00030
      NA = 1                                                            RFF00040
      L2 = N                                                            RFF00050
      IW = N                                                            RFF00060
      DO 111 K1=1,NF                                                    RFF00070
         KH = NF-K1                                                     RFF00080
         IP = IFAC(KH+3)                                                RFF00090
         L1 = L2/IP                                                     RFF00100
         IDO = N/L2                                                     RFF00110
         IDL1 = IDO*L1                                                  RFF00120
         IW = IW-(IP-1)*IDO                                             RFF00130
         NA = 1-NA                                                      RFF00140
         IF (IP .NE. 4) GO TO 102                                       RFF00150
         IX2 = IW+IDO                                                   RFF00160
         IX3 = IX2+IDO                                                  RFF00170
         IF (NA .NE. 0) GO TO 101                                       RFF00180
         CALL RADF4 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3))                RFF00190
         GO TO 110                                                      RFF00200
  101    CALL RADF4 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3))                RFF00210
         GO TO 110                                                      RFF00220
  102    IF (IP .NE. 2) GO TO 104                                       RFF00230
         IF (NA .NE. 0) GO TO 103                                       RFF00240
         CALL RADF2 (IDO,L1,C,CH,WA(IW))                                RFF00250
         GO TO 110                                                      RFF00260
  103    CALL RADF2 (IDO,L1,CH,C,WA(IW))                                RFF00270
         GO TO 110                                                      RFF00280
  104    IF (IP .NE. 3) GO TO 106                                       RFF00290
         IX2 = IW+IDO                                                   RFF00300
         IF (NA .NE. 0) GO TO 105                                       RFF00310
         CALL RADF3 (IDO,L1,C,CH,WA(IW),WA(IX2))                        RFF00320
         GO TO 110                                                      RFF00330
  105    CALL RADF3 (IDO,L1,CH,C,WA(IW),WA(IX2))                        RFF00340
         GO TO 110                                                      RFF00350
  106    IF (IP .NE. 5) GO TO 108                                       RFF00360
         IX2 = IW+IDO                                                   RFF00370
         IX3 = IX2+IDO                                                  RFF00380
         IX4 = IX3+IDO                                                  RFF00390
         IF (NA .NE. 0) GO TO 107                                       RFF00400
         CALL RADF5 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3),WA(IX4))        RFF00410
         GO TO 110                                                      RFF00420
  107    CALL RADF5 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3),WA(IX4))        RFF00430
         GO TO 110                                                      RFF00440
  108    IF (IDO .EQ. 1) NA = 1-NA                                      RFF00450
         IF (NA .NE. 0) GO TO 109                                       RFF00460
         CALL RADFG (IDO,IP,L1,IDL1,C,C,C,CH,CH,WA(IW))                 RFF00470
         NA = 1                                                         RFF00480
         GO TO 110                                                      RFF00490
  109    CALL RADFG (IDO,IP,L1,IDL1,CH,CH,CH,C,C,WA(IW))                RFF00500
         NA = 0                                                         RFF00510
  110    L2 = L1                                                        RFF00520
  111 CONTINUE                                                          RFF00530
      IF (NA .EQ. 1) RETURN                                             RFF00540
      DO 112 I=1,N                                                      RFF00550
         C(I) = CH(I)                                                   RFF00560
  112 CONTINUE                                                          RFF00570
      RETURN                                                            RFF00580
      END                                                               RFF00590
      SUBROUTINE RFFTI (N,WSAVE)                                        RFF00010
      DIMENSION       WSAVE(1)                                          RFF00020
      IF (N .EQ. 1) RETURN                                              RFF00030
      CALL RFFTI1 (N,WSAVE(N+1),WSAVE(2*N+1))                           RFF00040
      RETURN                                                            RFF00050
      END                                                               RFF00060
      SUBROUTINE RFFTI1 (N,WA,IFAC)                                     RFF00010
      DIMENSION       WA(1)      ,IFAC(1)    ,NTRYH(4)                  RFF00020
      DATA NTRYH(1),NTRYH(2),NTRYH(3),NTRYH(4)/4,2,3,5/                 RFF00030
      NL = N                                                            RFF00040
      NF = 0                                                            RFF00050
      J = 0                                                             RFF00060
  101 J = J+1                                                           RFF00070
      IF (J-4) 102,102,103                                              RFF00080
  102 NTRY = NTRYH(J)                                                   RFF00090
      GO TO 104                                                         RFF00100
  103 NTRY = NTRY+2                                                     RFF00110
  104 NQ = NL/NTRY                                                      RFF00120
      NR = NL-NTRY*NQ                                                   RFF00130
      IF (NR) 101,105,101                                               RFF00140
  105 NF = NF+1                                                         RFF00150
      IFAC(NF+2) = NTRY                                                 RFF00160
      NL = NQ                                                           RFF00170
      IF (NTRY .NE. 2) GO TO 107                                        RFF00180
      IF (NF .EQ. 1) GO TO 107                                          RFF00190
      DO 106 I=2,NF                                                     RFF00200
         IB = NF-I+2                                                    RFF00210
         IFAC(IB+2) = IFAC(IB+1)                                        RFF00220
  106 CONTINUE                                                          RFF00230
      IFAC(3) = 2                                                       RFF00240
  107 IF (NL .NE. 1) GO TO 104                                          RFF00250
      IFAC(1) = N                                                       RFF00260
      IFAC(2) = NF                                                      RFF00270
      TPI = 6.28318530717959                                            RFF00280
      ARGH = TPI/FLOAT(N)                                               RFF00290
      IS = 0                                                            RFF00300
      NFM1 = NF-1                                                       RFF00310
      L1 = 1                                                            RFF00320
      IF (NFM1 .EQ. 0) RETURN                                           RFF00330
      DO 110 K1=1,NFM1                                                  RFF00340
         IP = IFAC(K1+2)                                                RFF00350
         LD = 0                                                         RFF00360
         L2 = L1*IP                                                     RFF00370
         IDO = N/L2                                                     RFF00380
         IPM = IP-1                                                     RFF00390
         DO 109 J=1,IPM                                                 RFF00400
            LD = LD+L1                                                  RFF00410
            I = IS                                                      RFF00420
            ARGLD = FLOAT(LD)*ARGH                                      RFF00430
            FI = 0.                                                     RFF00440
            DO 108 II=3,IDO,2                                           RFF00450
               I = I+2                                                  RFF00460
               FI = FI+1.                                               RFF00470
               ARG = FI*ARGLD                                           RFF00480
               WA(I-1) = COS(ARG)                                       RFF00490
               WA(I) = SIN(ARG)                                         RFF00500
  108       CONTINUE                                                    RFF00510
            IS = IS+IDO                                                 RFF00520
  109    CONTINUE                                                       RFF00530
         L1 = L2                                                        RFF00540
  110 CONTINUE                                                          RFF00550
      RETURN                                                            RFF00560
      END                                                               RFF00570
      SUBROUTINE SINQB (N,X,WSAVE)                                      SIN00010
      DIMENSION       X(1)       ,WSAVE(1)                              SIN00020
      IF (N .GT. 1) GO TO 101                                           SIN00030
      X(1) = 4.*X(1)                                                    SIN00040
      RETURN                                                            SIN00050
  101 NS2 = N/2                                                         SIN00060
      DO 102 K=2,N,2                                                    SIN00070
         X(K) = -X(K)                                                   SIN00080
  102 CONTINUE                                                          SIN00090
      CALL COSQB (N,X,WSAVE)                                            SIN00100
      DO 103 K=1,NS2                                                    SIN00110
         KC = N-K                                                       SIN00120
         XHOLD = X(K)                                                   SIN00130
         X(K) = X(KC+1)                                                 SIN00140
         X(KC+1) = XHOLD                                                SIN00150
  103 CONTINUE                                                          SIN00160
      RETURN                                                            SIN00170
      END                                                               SIN00180
      SUBROUTINE SINQF (N,X,WSAVE)                                      SIN00010
      DIMENSION       X(1)       ,WSAVE(1)                              SIN00020
      IF (N .EQ. 1) RETURN                                              SIN00030
      NS2 = N/2                                                         SIN00040
      DO 101 K=1,NS2                                                    SIN00050
         KC = N-K                                                       SIN00060
         XHOLD = X(K)                                                   SIN00070
         X(K) = X(KC+1)                                                 SIN00080
         X(KC+1) = XHOLD                                                SIN00090
  101 CONTINUE                                                          SIN00100
      CALL COSQF (N,X,WSAVE)                                            SIN00110
      DO 102 K=2,N,2                                                    SIN00120
         X(K) = -X(K)                                                   SIN00130
  102 CONTINUE                                                          SIN00140
      RETURN                                                            SIN00150
      END                                                               SIN00160
      SUBROUTINE SINQI (N,WSAVE)                                        SIN00010
      DIMENSION       WSAVE(1)                                          SIN00020
      CALL COSQI (N,WSAVE)                                              SIN00030
      RETURN                                                            SIN00040
      END                                                               SIN00050
      SUBROUTINE SINT (N,X,WSAVE)                                       SIN00010
      DIMENSION       X(1)       ,WSAVE(1)                              SIN00020
      DATA SQRT3 /1.73205080756888/                                     SIN00030
      IF (N-2) 101,102,103                                              SIN00040
  101 X(1) = X(1)+X(1)                                                  SIN00050
      RETURN                                                            SIN00060
  102 XH = SQRT3*(X(1)+X(2))                                            SIN00070
      X(2) = SQRT3*(X(1)-X(2))                                          SIN00080
      X(1) = XH                                                         SIN00090
      RETURN                                                            SIN00100
  103 NP1 = N+1                                                         SIN00110
      NS2 = N/2                                                         SIN00120
      X1 = X(1)                                                         SIN00130
      X(1) = 0.                                                         SIN00140
      DO 104 K=1,NS2                                                    SIN00150
         KC = NP1-K                                                     SIN00160
         T1 = X1-X(KC)                                                  SIN00170
         T2 = WSAVE(K)*(X1+X(KC))                                       SIN00180
         X1 = X(K+1)                                                    SIN00190
         X(K+1) = T1+T2                                                 SIN00200
         X(KC+1) = T2-T1                                                SIN00210
  104 CONTINUE                                                          SIN00220
      MODN = MOD(N,2)                                                   SIN00230
      IF (MODN .NE. 0) X(NS2+2) = 4.*X1                                 SIN00240
      CALL RFFTF (NP1,X,WSAVE(NS2+1))                                   SIN00250
      X(1) = .5*X(1)                                                    SIN00260
      DO 105 I=3,N,2                                                    SIN00270
         XIM1 = X(I-1)                                                  SIN00280
         X(I-1) = -X(I)                                                 SIN00290
         X(I) = X(I-2)+XIM1                                             SIN00300
  105 CONTINUE                                                          SIN00310
      IF (MODN .NE. 0) RETURN                                           SIN00320
      X(N) = -X(N+1)                                                    SIN00330
      RETURN                                                            SIN00340
      END                                                               SIN00350
      SUBROUTINE SINTI (N,WSAVE)                                        SIN00010
      DIMENSION       WSAVE(1)                                          SIN00020
      DATA PI /3.14159265358979/                                        SIN00030
      IF (N .LE. 1) RETURN                                              SIN00040
      NP1 = N+1                                                         SIN00050
      NS2 = N/2                                                         SIN00060
      DT = PI/FLOAT(NP1)                                                SIN00070
      FK = 0.                                                           SIN00080
      DO 101 K=1,NS2                                                    SIN00090
         FK = FK+1.                                                     SIN00100
         WSAVE(K) = 2.*SIN(FK*DT)                                       SIN00110
  101 CONTINUE                                                          SIN00120
      CALL RFFTI (NP1,WSAVE(NS2+1))                                     SIN00130
      RETURN                                                            SIN00140
      END                                                               SIN00150
