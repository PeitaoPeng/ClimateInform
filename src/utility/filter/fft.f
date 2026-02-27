C FISHPAK21  FROM PORTLIB                                  11/10/79     NCA00010
      SUBROUTINE EZFFTF (N,R,AZERO,A,B,WSAVE)                           NCA00020
C                                                                       NCA00030
C                       VERSION 3  JUNE 1979                            NCA00040
C                                                                       NCA00050
      DIMENSION       R(*)       ,A(*)       ,B(*)       ,WSAVE(*)      NCA00060
      IF (N-2) 101,102,103                                              NCA00070
  101 AZERO = R(1)                                                      NCA00080
      RETURN                                                            NCA00090
  102 AZERO = .5*(R(1)+R(2))                                            NCA00100
      A(1) = .5*(R(1)-R(2))                                             NCA00110
      RETURN                                                            NCA00120
C                                                                       NCA00130
C     TO SUPRESS REPEATED INITIALIZATION, REMOVE THE FOLLOWING STATEMENTNCA00140
C     ( CALL EZFFTI(N,WSAVE) ) FROM BOTH EZFFTF AND EZFFTB AND INSERT ITNCA00150
C     AT THE BEGINNING OF YOUR PROGRAM FOLLOWING THE DEFINITION OF N.   NCA00160
C                                                                       NCA00170
  103 CALL EZFFTI (N,WSAVE)                                             NCA00180
C                                                                       NCA00190
      DO 104 I=1,N                                                      NCA00200
         WSAVE(I) = R(I)                                                NCA00210
  104 CONTINUE                                                          NCA00220
      CALL RFFTF (N,WSAVE,WSAVE(N+1))                                   NCA00230
      CF = 2./FLOAT(N)                                                  NCA00240
      CFM = -CF                                                         NCA00250
      AZERO = .5*CF*WSAVE(1)                                            NCA00260
      NS2 = (N+1)/2                                                     NCA00270
      NS2M = NS2-1                                                      NCA00280
      DO 105 I=1,NS2M                                                   NCA00290
         A(I) = CF*WSAVE(2*I)                                           NCA00300
         B(I) = CFM*WSAVE(2*I+1)                                        NCA00310
  105 CONTINUE                                                          NCA00320
      IF (MOD(N,2) .EQ. 0) A(NS2) = .5*CF*WSAVE(N)                      NCA00330
      RETURN                                                            NCA00340
      END                                                               NCA00350
      SUBROUTINE EZFFTB (N,R,AZERO,A,B,WSAVE)                           NCA00360
      DIMENSION       R(*)       ,A(*)       ,B(*)       ,WSAVE(*)      NCA00370
      IF (N-2) 101,102,103                                              NCA00380
  101 R(1) = AZERO                                                      NCA00390
      RETURN                                                            NCA00400
  102 R(1) = AZERO+A(1)                                                 NCA00410
      R(2) = AZERO-A(1)                                                 NCA00420
      RETURN                                                            NCA00430
C                                                                       NCA00440
C     TO SUPRESS REPEATED INITIALIZATION, REMOVE THE FOLLOWING STATEMENTNCA00450
C     ( CALL EZFFTI(N,WSAVE) ) FROM BOTH EZFFTF AND EZFFTB AND INSERT ITNCA00460
C     AT THE BEGINNING OF YOUR PROGRAM FOLLOWING THE DEFINITION OF N.   NCA00470
C                                                                       NCA00480
  103 CALL EZFFTI (N,WSAVE)                                             NCA00490
C                                                                       NCA00500
      NS2 = (N-1)/2                                                     NCA00510
      DO 104 I=1,NS2                                                    NCA00520
         R(2*I) = .5*A(I)                                               NCA00530
         R(2*I+1) = -.5*B(I)                                            NCA00540
  104 CONTINUE                                                          NCA00550
      R(1) = AZERO                                                      NCA00560
      IF (MOD(N,2) .EQ. 0) R(N) = A(NS2+1)                              NCA00570
      CALL RFFTB (N,R,WSAVE(N+1))                                       NCA00580
      RETURN                                                            NCA00590
      END                                                               NCA00600
      SUBROUTINE EZFFTI (N,WSAVE)                                       NCA00610
      DIMENSION       WSAVE(*)                                          NCA00620
      IF (N .EQ. 1) RETURN                                              NCA00630
      CALL EZFFT1 (N,WSAVE(2*N+1),WSAVE(3*N+1))                         NCA00640
      RETURN                                                            NCA00650
      END                                                               NCA00660
      SUBROUTINE EZFFT1 (N,WA,IFAC)                                     NCA00670
      DIMENSION       WA(*)      ,IFAC(*)    ,NTRYH(4)                  NCA00680
      DATA NTRYH(1),NTRYH(2),NTRYH(3),NTRYH(4)/4,2,3,5/                 NCA00690
     1    ,TPI/6.28318530717959/                                        NCA00700
      NL = N                                                            NCA00710
      NF = 0                                                            NCA00720
      J = 0                                                             NCA00730
  101 J = J+1                                                           NCA00740
      IF (J-4) 102,102,103                                              NCA00750
  102 NTRY = NTRYH(J)                                                   NCA00760
      GO TO 104                                                         NCA00770
  103 NTRY = NTRY+2                                                     NCA00780
  104 NQ = NL/NTRY                                                      NCA00790
      NR = NL-NTRY*NQ                                                   NCA00800
      IF (NR) 101,105,101                                               NCA00810
  105 NF = NF+1                                                         NCA00820
      IFAC(NF+2) = NTRY                                                 NCA00830
      NL = NQ                                                           NCA00840
      IF (NTRY .NE. 2) GO TO 107                                        NCA00850
      IF (NF .EQ. 1) GO TO 107                                          NCA00860
      DO 106 I=2,NF                                                     NCA00870
         IB = NF-I+2                                                    NCA00880
         IFAC(IB+2) = IFAC(IB+1)                                        NCA00890
  106 CONTINUE                                                          NCA00900
      IFAC(3) = 2                                                       NCA00910
  107 IF (NL .NE. 1) GO TO 104                                          NCA00920
      IFAC(1) = N                                                       NCA00930
      IFAC(2) = NF                                                      NCA00940
      ARGH = TPI/FLOAT(N)                                               NCA00950
      IS = 0                                                            NCA00960
      NFM1 = NF-1                                                       NCA00970
      L1 = 1                                                            NCA00980
      IF (NFM1 .EQ. 0) RETURN                                           NCA00990
      DO 111 K1=1,NFM1                                                  NCA01000
         IP = IFAC(K1+2)                                                NCA01010
         L2 = L1*IP                                                     NCA01020
         IDO = N/L2                                                     NCA01030
         IPM = IP-1                                                     NCA01040
         ARG1 = FLOAT(L1)*ARGH                                          NCA01050
         CH1 = 1.                                                       NCA01060
         SH1 = 0.                                                       NCA01070
         DCH1 = COS(ARG1)                                               NCA01080
         DSH1 = SIN(ARG1)                                               NCA01090
         DO 110 J=1,IPM                                                 NCA01100
            CH1H = DCH1*CH1-DSH1*SH1                                    NCA01110
            SH1 = DCH1*SH1+DSH1*CH1                                     NCA01120
            CH1 = CH1H                                                  NCA01130
            I = IS+2                                                    NCA01140
            WA(I-1) = CH1                                               NCA01150
            WA(I) = SH1                                                 NCA01160
            IF (IDO .LT. 5) GO TO 109                                   NCA01170
            DO 108 II=5,IDO,2                                           NCA01180
               I = I+2                                                  NCA01190
               WA(I-1) = CH1*WA(I-3)-SH1*WA(I-2)                        NCA01200
               WA(I) = CH1*WA(I-2)+SH1*WA(I-3)                          NCA01210
  108       CONTINUE                                                    NCA01220
  109       IS = IS+IDO                                                 NCA01230
  110    CONTINUE                                                       NCA01240
         L1 = L2                                                        NCA01250
  111 CONTINUE                                                          NCA01260
      RETURN                                                            NCA01270
      END                                                               NCA01280
      SUBROUTINE COSTI (N,WSAVE)                                        NCA01290
      DIMENSION       WSAVE(*)                                          NCA01300
      DATA PI /3.14159265358979/                                        NCA01310
      IF (N .LE. 3) RETURN                                              NCA01320
      NM1 = N-1                                                         NCA01330
      NP1 = N+1                                                         NCA01340
      NS2 = N/2                                                         NCA01350
      DT = PI/FLOAT(NM1)                                                NCA01360
      FK = 0.                                                           NCA01370
      DO 101 K=2,NS2                                                    NCA01380
         KC = NP1-K                                                     NCA01390
         FK = FK+1.                                                     NCA01400
         WSAVE(K) = 2.*SIN(FK*DT)                                       NCA01410
         WSAVE(KC) = 2.*COS(FK*DT)                                      NCA01420
  101 CONTINUE                                                          NCA01430
      CALL RFFTI (NM1,WSAVE(N+1))                                       NCA01440
      RETURN                                                            NCA01450
      END                                                               NCA01460
      SUBROUTINE COST (N,X,WSAVE)                                       NCA01470
      DIMENSION       X(*)       ,WSAVE(*)                              NCA01480
      NM1 = N-1                                                         NCA01490
      NP1 = N+1                                                         NCA01500
      NS2 = N/2                                                         NCA01510
      IF (N-2) 106,101,102                                              NCA01520
  101 X1H = X(1)+X(2)                                                   NCA01530
      X(2) = X(1)-X(2)                                                  NCA01540
      X(1) = X1H                                                        NCA01550
      RETURN                                                            NCA01560
  102 IF (N .GT. 3) GO TO 103                                           NCA01570
      X1P3 = X(1)+X(3)                                                  NCA01580
      TX2 = X(2)+X(2)                                                   NCA01590
      X(2) = X(1)-X(3)                                                  NCA01600
      X(1) = X1P3+TX2                                                   NCA01610
      X(3) = X1P3-TX2                                                   NCA01620
      RETURN                                                            NCA01630
  103 C1 = X(1)-X(N)                                                    NCA01640
      X(1) = X(1)+X(N)                                                  NCA01650
      DO 104 K=2,NS2                                                    NCA01660
         KC = NP1-K                                                     NCA01670
         T1 = X(K)+X(KC)                                                NCA01680
         T2 = X(K)-X(KC)                                                NCA01690
         C1 = C1+WSAVE(KC)*T2                                           NCA01700
         T2 = WSAVE(K)*T2                                               NCA01710
         X(K) = T1-T2                                                   NCA01720
         X(KC) = T1+T2                                                  NCA01730
  104 CONTINUE                                                          NCA01740
      MODN = MOD(N,2)                                                   NCA01750
      IF (MODN .NE. 0) X(NS2+1) = X(NS2+1)+X(NS2+1)                     NCA01760
      CALL RFFTF (NM1,X,WSAVE(N+1))                                     NCA01770
      XIM2 = X(2)                                                       NCA01780
      X(2) = C1                                                         NCA01790
      DO 105 I=4,N,2                                                    NCA01800
         XI = X(I)                                                      NCA01810
         X(I) = X(I-2)-X(I-1)                                           NCA01820
         X(I-1) = XIM2                                                  NCA01830
         XIM2 = XI                                                      NCA01840
  105 CONTINUE                                                          NCA01850
      IF (MODN .NE. 0) X(N) = XIM2                                      NCA01860
  106 RETURN                                                            NCA01870
      END                                                               NCA01880
      SUBROUTINE SINTI (N,WSAVE)                                        NCA01890
      DIMENSION       WSAVE(*)                                          NCA01900
      DATA PI /3.14159265358979/                                        NCA01910
      IF (N .LE. 1) RETURN                                              NCA01920
      NP1 = N+1                                                         NCA01930
      NS2 = N/2                                                         NCA01940
      DT = PI/FLOAT(NP1)                                                NCA01950
      FK = 0.                                                           NCA01960
      DO 101 K=1,NS2                                                    NCA01970
         FK = FK+1.                                                     NCA01980
         WSAVE(K) = 2.*SIN(FK*DT)                                       NCA01990
  101 CONTINUE                                                          NCA02000
      CALL RFFTI (NP1,WSAVE(NS2+1))                                     NCA02010
      RETURN                                                            NCA02020
      END                                                               NCA02030
      SUBROUTINE SINT (N,X,WSAVE)                                       NCA02040
      DIMENSION       X(*)       ,WSAVE(*)                              NCA02050
      DATA SQRT3 /1.73205080756888/                                     NCA02060
      IF (N-2) 101,102,103                                              NCA02070
  101 X(1) = X(1)+X(1)                                                  NCA02080
      RETURN                                                            NCA02090
  102 XH = SQRT3*(X(1)+X(2))                                            NCA02100
      X(2) = SQRT3*(X(1)-X(2))                                          NCA02110
      X(1) = XH                                                         NCA02120
      RETURN                                                            NCA02130
  103 NP1 = N+1                                                         NCA02140
      NS2 = N/2                                                         NCA02150
      X1 = X(1)                                                         NCA02160
      X(1) = 0.                                                         NCA02170
      DO 104 K=1,NS2                                                    NCA02180
         KC = NP1-K                                                     NCA02190
         T1 = X1-X(KC)                                                  NCA02200
         T2 = WSAVE(K)*(X1+X(KC))                                       NCA02210
         X1 = X(K+1)                                                    NCA02220
         X(K+1) = T1+T2                                                 NCA02230
         X(KC+1) = T2-T1                                                NCA02240
  104 CONTINUE                                                          NCA02250
      MODN = MOD(N,2)                                                   NCA02260
      IF (MODN .NE. 0) X(NS2+2) = 4.*X1                                 NCA02270
      CALL RFFTF (NP1,X,WSAVE(NS2+1))                                   NCA02280
      X(1) = .5*X(1)                                                    NCA02290
      DO 105 I=3,N,2                                                    NCA02300
         XIM1 = X(I-1)                                                  NCA02310
         X(I-1) = -X(I)                                                 NCA02320
         X(I) = X(I-2)+XIM1                                             NCA02330
  105 CONTINUE                                                          NCA02340
      IF (MODN .NE. 0) RETURN                                           NCA02350
      X(N) = -X(N+1)                                                    NCA02360
      RETURN                                                            NCA02370
      END                                                               NCA02380
      SUBROUTINE COSQI (N,WSAVE)                                        NCA02390
      DIMENSION       WSAVE(*)                                          NCA02400
      DATA PIH /1.57079632679491/                                       NCA02410
      DT = PIH/FLOAT(N)                                                 NCA02420
      FK = 0.                                                           NCA02430
      DO 101 K=1,N                                                      NCA02440
         FK = FK+1.                                                     NCA02450
         WSAVE(K) = COS(FK*DT)                                          NCA02460
  101 CONTINUE                                                          NCA02470
      CALL RFFTI (N,WSAVE(N+1))                                         NCA02480
      RETURN                                                            NCA02490
      END                                                               NCA02500
      SUBROUTINE COSQF (N,X,WSAVE)                                      NCA02510
      DIMENSION       X(*)       ,WSAVE(*)                              NCA02520
      DATA SQRT2 /1.4142135623731/                                      NCA02530
      IF (N-2) 102,101,103                                              NCA02540
  101 TSQX = SQRT2*X(2)                                                 NCA02550
      X(2) = X(1)-TSQX                                                  NCA02560
      X(1) = X(1)+TSQX                                                  NCA02570
  102 RETURN                                                            NCA02580
  103 CALL COSQF1 (N,X,WSAVE,WSAVE(N+1))                                NCA02590
      RETURN                                                            NCA02600
      END                                                               NCA02610
      SUBROUTINE COSQF1 (N,X,W,XH)                                      NCA02620
      DIMENSION       X(*)       ,W(*)       ,XH(*)                     NCA02630
      NS2 = (N+1)/2                                                     NCA02640
      NP2 = N+2                                                         NCA02650
      DO 101 K=2,NS2                                                    NCA02660
         KC = NP2-K                                                     NCA02670
         XH(K) = X(K)+X(KC)                                             NCA02680
         XH(KC) = X(K)-X(KC)                                            NCA02690
  101 CONTINUE                                                          NCA02700
      MODN = MOD(N,2)                                                   NCA02710
      IF (MODN .EQ. 0) XH(NS2+1) = X(NS2+1)+X(NS2+1)                    NCA02720
      DO 102 K=2,NS2                                                    NCA02730
         KC = NP2-K                                                     NCA02740
         X(K) = W(K-1)*XH(KC)+W(KC-1)*XH(K)                             NCA02750
         X(KC) = W(K-1)*XH(K)-W(KC-1)*XH(KC)                            NCA02760
  102 CONTINUE                                                          NCA02770
      IF (MODN .EQ. 0) X(NS2+1) = W(NS2)*XH(NS2+1)                      NCA02780
      CALL RFFTF (N,X,XH)                                               NCA02790
      DO 103 I=3,N,2                                                    NCA02800
         XIM1 = X(I-1)-X(I)                                             NCA02810
         X(I) = X(I-1)+X(I)                                             NCA02820
         X(I-1) = XIM1                                                  NCA02830
  103 CONTINUE                                                          NCA02840
      RETURN                                                            NCA02850
      END                                                               NCA02860
      SUBROUTINE COSQB (N,X,WSAVE)                                      NCA02870
      DIMENSION       X(*)       ,WSAVE(*)                              NCA02880
      DATA TSQRT2 /2.82842712474619/                                    NCA02890
      IF (N-2) 101,102,103                                              NCA02900
  101 X(1) = 4.*X(1)                                                    NCA02910
      RETURN                                                            NCA02920
  102 X1 = 4.*(X(1)+X(2))                                               NCA02930
      X(2) = TSQRT2*(X(1)-X(2))                                         NCA02940
      X(1) = X1                                                         NCA02950
      RETURN                                                            NCA02960
  103 CALL COSQB1 (N,X,WSAVE,WSAVE(N+1))                                NCA02970
      RETURN                                                            NCA02980
      END                                                               NCA02990
      SUBROUTINE COSQB1 (N,X,W,XH)                                      NCA03000
      DIMENSION       X(*)       ,W(*)       ,XH(*)                     NCA03010
      NS2 = (N+1)/2                                                     NCA03020
      NP2 = N+2                                                         NCA03030
      DO 101 I=3,N,2                                                    NCA03040
         XIM1 = X(I-1)+X(I)                                             NCA03050
         X(I) = X(I)-X(I-1)                                             NCA03060
         X(I-1) = XIM1                                                  NCA03070
  101 CONTINUE                                                          NCA03080
      X(1) = X(1)+X(1)                                                  NCA03090
      MODN = MOD(N,2)                                                   NCA03100
      IF (MODN .EQ. 0) X(N) = X(N)+X(N)                                 NCA03110
      CALL RFFTB (N,X,XH)                                               NCA03120
      DO 102 K=2,NS2                                                    NCA03130
         KC = NP2-K                                                     NCA03140
         XH(K) = W(K-1)*X(KC)+W(KC-1)*X(K)                              NCA03150
         XH(KC) = W(K-1)*X(K)-W(KC-1)*X(KC)                             NCA03160
  102 CONTINUE                                                          NCA03170
      IF (MODN .EQ. 0) X(NS2+1) = W(NS2)*(X(NS2+1)+X(NS2+1))            NCA03180
      DO 103 K=2,NS2                                                    NCA03190
         KC = NP2-K                                                     NCA03200
         X(K) = XH(K)+XH(KC)                                            NCA03210
         X(KC) = XH(K)-XH(KC)                                           NCA03220
  103 CONTINUE                                                          NCA03230
      X(1) = X(1)+X(1)                                                  NCA03240
      RETURN                                                            NCA03250
      END                                                               NCA03260
      SUBROUTINE SINQI (N,WSAVE)                                        NCA03270
      DIMENSION       WSAVE(*)                                          NCA03280
      CALL COSQI (N,WSAVE)                                              NCA03290
      RETURN                                                            NCA03300
      END                                                               NCA03310
      SUBROUTINE SINQF (N,X,WSAVE)                                      NCA03320
      DIMENSION       X(*)       ,WSAVE(*)                              NCA03330
      IF (N .EQ. 1) RETURN                                              NCA03340
      NS2 = N/2                                                         NCA03350
      DO 101 K=1,NS2                                                    NCA03360
         KC = N-K                                                       NCA03370
         XHOLD = X(K)                                                   NCA03380
         X(K) = X(KC+1)                                                 NCA03390
         X(KC+1) = XHOLD                                                NCA03400
  101 CONTINUE                                                          NCA03410
      CALL COSQF (N,X,WSAVE)                                            NCA03420
      DO 102 K=2,N,2                                                    NCA03430
         X(K) = -X(K)                                                   NCA03440
  102 CONTINUE                                                          NCA03450
      RETURN                                                            NCA03460
      END                                                               NCA03470
      SUBROUTINE SINQB (N,X,WSAVE)                                      NCA03480
      DIMENSION       X(*)       ,WSAVE(*)                              NCA03490
      IF (N .GT. 1) GO TO 101                                           NCA03500
      X(1) = 4.*X(1)                                                    NCA03510
      RETURN                                                            NCA03520
  101 NS2 = N/2                                                         NCA03530
      DO 102 K=2,N,2                                                    NCA03540
         X(K) = -X(K)                                                   NCA03550
  102 CONTINUE                                                          NCA03560
      CALL COSQB (N,X,WSAVE)                                            NCA03570
      DO 103 K=1,NS2                                                    NCA03580
         KC = N-K                                                       NCA03590
         XHOLD = X(K)                                                   NCA03600
         X(K) = X(KC+1)                                                 NCA03610
         X(KC+1) = XHOLD                                                NCA03620
  103 CONTINUE                                                          NCA03630
      RETURN                                                            NCA03640
      END                                                               NCA03650
      SUBROUTINE CFFTI (N,WSAVE)                                        NCA03660
      DIMENSION       WSAVE(*)                                          NCA03670
      IF (N .EQ. 1) RETURN                                              NCA03680
      IW1 = N+N+1                                                       NCA03690
      IW2 = IW1+N+N                                                     NCA03700
      CALL CFFTI1 (N,WSAVE(IW1),WSAVE(IW2))                             NCA03710
      RETURN                                                            NCA03720
      END                                                               NCA03730
      SUBROUTINE CFFTI1 (N,WA,IFAC)                                     NCA03740
      DIMENSION       WA(*)      ,IFAC(*)    ,NTRYH(4)                  NCA03750
      DATA NTRYH(1),NTRYH(2),NTRYH(3),NTRYH(4)/3,4,2,5/                 NCA03760
      NL = N                                                            NCA03770
      NF = 0                                                            NCA03780
      J = 0                                                             NCA03790
  101 J = J+1                                                           NCA03800
      IF (J-4) 102,102,103                                              NCA03810
  102 NTRY = NTRYH(J)                                                   NCA03820
      GO TO 104                                                         NCA03830
  103 NTRY = NTRY+2                                                     NCA03840
  104 NQ = NL/NTRY                                                      NCA03850
      NR = NL-NTRY*NQ                                                   NCA03860
      IF (NR) 101,105,101                                               NCA03870
  105 NF = NF+1                                                         NCA03880
      IFAC(NF+2) = NTRY                                                 NCA03890
      NL = NQ                                                           NCA03900
      IF (NTRY .NE. 2) GO TO 107                                        NCA03910
      IF (NF .EQ. 1) GO TO 107                                          NCA03920
      DO 106 I=2,NF                                                     NCA03930
         IB = NF-I+2                                                    NCA03940
         IFAC(IB+2) = IFAC(IB+1)                                        NCA03950
  106 CONTINUE                                                          NCA03960
      IFAC(3) = 2                                                       NCA03970
  107 IF (NL .NE. 1) GO TO 104                                          NCA03980
      IFAC(1) = N                                                       NCA03990
      IFAC(2) = NF                                                      NCA04000
      TPI = 6.28318530717959                                            NCA04010
      ARGH = TPI/FLOAT(N)                                               NCA04020
      I = 2                                                             NCA04030
      L1 = 1                                                            NCA04040
      DO 110 K1=1,NF                                                    NCA04050
         IP = IFAC(K1+2)                                                NCA04060
         LD = 0                                                         NCA04070
         L2 = L1*IP                                                     NCA04080
         IDO = N/L2                                                     NCA04090
         IDOT = IDO+IDO+2                                               NCA04100
         IPM = IP-1                                                     NCA04110
         DO 109 J=1,IPM                                                 NCA04120
            I1 = I                                                      NCA04130
            WA(I-1) = 1.                                                NCA04140
            WA(I) = 0.                                                  NCA04150
            LD = LD+L1                                                  NCA04160
            FI = 0.                                                     NCA04170
            ARGLD = FLOAT(LD)*ARGH                                      NCA04180
            DO 108 II=4,IDOT,2                                          NCA04190
               I = I+2                                                  NCA04200
               FI = FI+1.                                               NCA04210
               ARG = FI*ARGLD                                           NCA04220
               WA(I-1) = COS(ARG)                                       NCA04230
               WA(I) = SIN(ARG)                                         NCA04240
  108       CONTINUE                                                    NCA04250
            IF (IP .LE. 5) GO TO 109                                    NCA04260
            WA(I1-1) = WA(I-1)                                          NCA04270
            WA(I1) = WA(I)                                              NCA04280
  109    CONTINUE                                                       NCA04290
         L1 = L2                                                        NCA04300
  110 CONTINUE                                                          NCA04310
      RETURN                                                            NCA04320
      END                                                               NCA04330
      SUBROUTINE CFFTB (N,C,WSAVE)                                      NCA04340
      DIMENSION       C(*)       ,WSAVE(*)                              NCA04350
      IF (N .EQ. 1) RETURN                                              NCA04360
      IW1 = N+N+1                                                       NCA04370
      IW2 = IW1+N+N                                                     NCA04380
      CALL CFFTB1 (N,C,WSAVE,WSAVE(IW1),WSAVE(IW2))                     NCA04390
      RETURN                                                            NCA04400
      END                                                               NCA04410
      SUBROUTINE CFFTB1 (N,C,CH,WA,IFAC)                                NCA04420
      DIMENSION       CH(*)      ,C(*)       ,WA(*)      ,IFAC(*)       NCA04430
      NF = IFAC(2)                                                      NCA04440
      NA = 0                                                            NCA04450
      L1 = 1                                                            NCA04460
      IW = 1                                                            NCA04470
      DO 116 K1=1,NF                                                    NCA04480
         IP = IFAC(K1+2)                                                NCA04490
         L2 = IP*L1                                                     NCA04500
         IDO = N/L2                                                     NCA04510
         IDOT = IDO+IDO                                                 NCA04520
         IDL1 = IDOT*L1                                                 NCA04530
         IF (IP .NE. 4) GO TO 103                                       NCA04540
         IX2 = IW+IDOT                                                  NCA04550
         IX3 = IX2+IDOT                                                 NCA04560
         IF (NA .NE. 0) GO TO 101                                       NCA04570
         CALL PASSB4 (IDOT,L1,C,CH,WA(IW),WA(IX2),WA(IX3))              NCA04580
         GO TO 102                                                      NCA04590
  101    CALL PASSB4 (IDOT,L1,CH,C,WA(IW),WA(IX2),WA(IX3))              NCA04600
  102    NA = 1-NA                                                      NCA04610
         GO TO 115                                                      NCA04620
  103    IF (IP .NE. 2) GO TO 106                                       NCA04630
         IF (NA .NE. 0) GO TO 104                                       NCA04640
         CALL PASSB2 (IDOT,L1,C,CH,WA(IW))                              NCA04650
         GO TO 105                                                      NCA04660
  104    CALL PASSB2 (IDOT,L1,CH,C,WA(IW))                              NCA04670
  105    NA = 1-NA                                                      NCA04680
         GO TO 115                                                      NCA04690
  106    IF (IP .NE. 3) GO TO 109                                       NCA04700
         IX2 = IW+IDOT                                                  NCA04710
         IF (NA .NE. 0) GO TO 107                                       NCA04720
         CALL PASSB3 (IDOT,L1,C,CH,WA(IW),WA(IX2))                      NCA04730
         GO TO 108                                                      NCA04740
  107    CALL PASSB3 (IDOT,L1,CH,C,WA(IW),WA(IX2))                      NCA04750
  108    NA = 1-NA                                                      NCA04760
         GO TO 115                                                      NCA04770
  109    IF (IP .NE. 5) GO TO 112                                       NCA04780
         IX2 = IW+IDOT                                                  NCA04790
         IX3 = IX2+IDOT                                                 NCA04800
         IX4 = IX3+IDOT                                                 NCA04810
         IF (NA .NE. 0) GO TO 110                                       NCA04820
         CALL PASSB5 (IDOT,L1,C,CH,WA(IW),WA(IX2),WA(IX3),WA(IX4))      NCA04830
         GO TO 111                                                      NCA04840
  110    CALL PASSB5 (IDOT,L1,CH,C,WA(IW),WA(IX2),WA(IX3),WA(IX4))      NCA04850
  111    NA = 1-NA                                                      NCA04860
         GO TO 115                                                      NCA04870
  112    IF (NA .NE. 0) GO TO 113                                       NCA04880
         CALL PASSB (NAC,IDOT,IP,L1,IDL1,C,C,C,CH,CH,WA(IW))            NCA04890
         GO TO 114                                                      NCA04900
  113    CALL PASSB (NAC,IDOT,IP,L1,IDL1,CH,CH,CH,C,C,WA(IW))           NCA04910
  114    IF (NAC .NE. 0) NA = 1-NA                                      NCA04920
  115    L1 = L2                                                        NCA04930
         IW = IW+(IP-1)*IDOT                                            NCA04940
  116 CONTINUE                                                          NCA04950
      IF (NA .EQ. 0) RETURN                                             NCA04960
      N2 = N+N                                                          NCA04970
      DO 117 I=1,N2                                                     NCA04980
         C(I) = CH(I)                                                   NCA04990
  117 CONTINUE                                                          NCA05000
      RETURN                                                            NCA05010
      END                                                               NCA05020
      SUBROUTINE PASSB2 (IDO,L1,CC,CH,WA1)                              NCA05030
      DIMENSION       CC(IDO,2,L1)           ,CH(IDO,L1,2)           ,  NCA05040
     1                WA1(*)                                            NCA05050
      IF (IDO .GT. 2) GO TO 102                                         NCA05060
      DO 101 K=1,L1                                                     NCA05070
         CH(1,K,1) = CC(1,1,K)+CC(1,2,K)                                NCA05080
         CH(1,K,2) = CC(1,1,K)-CC(1,2,K)                                NCA05090
         CH(2,K,1) = CC(2,1,K)+CC(2,2,K)                                NCA05100
         CH(2,K,2) = CC(2,1,K)-CC(2,2,K)                                NCA05110
  101 CONTINUE                                                          NCA05120
      RETURN                                                            NCA05130
  102 DO 104 K=1,L1                                                     NCA05140
         DO 103 I=2,IDO,2                                               NCA05150
            CH(I-1,K,1) = CC(I-1,1,K)+CC(I-1,2,K)                       NCA05160
            TR2 = CC(I-1,1,K)-CC(I-1,2,K)                               NCA05170
            CH(I,K,1) = CC(I,1,K)+CC(I,2,K)                             NCA05180
            TI2 = CC(I,1,K)-CC(I,2,K)                                   NCA05190
            CH(I,K,2) = WA1(I-1)*TI2+WA1(I)*TR2                         NCA05200
            CH(I-1,K,2) = WA1(I-1)*TR2-WA1(I)*TI2                       NCA05210
  103    CONTINUE                                                       NCA05220
  104 CONTINUE                                                          NCA05230
      RETURN                                                            NCA05240
      END                                                               NCA05250
      SUBROUTINE PASSB3 (IDO,L1,CC,CH,WA1,WA2)                          NCA05260
      DIMENSION       CC(IDO,3,L1)           ,CH(IDO,L1,3)           ,  NCA05270
     1                WA1(*)     ,WA2(*)                                NCA05280
      DATA TAUR,TAUI /-.5,.866025403784439/                             NCA05290
      IF (IDO .NE. 2) GO TO 102                                         NCA05300
      DO 101 K=1,L1                                                     NCA05310
         TR2 = CC(1,2,K)+CC(1,3,K)                                      NCA05320
         CR2 = CC(1,1,K)+TAUR*TR2                                       NCA05330
         CH(1,K,1) = CC(1,1,K)+TR2                                      NCA05340
         TI2 = CC(2,2,K)+CC(2,3,K)                                      NCA05350
         CI2 = CC(2,1,K)+TAUR*TI2                                       NCA05360
         CH(2,K,1) = CC(2,1,K)+TI2                                      NCA05370
         CR3 = TAUI*(CC(1,2,K)-CC(1,3,K))                               NCA05380
         CI3 = TAUI*(CC(2,2,K)-CC(2,3,K))                               NCA05390
         CH(1,K,2) = CR2-CI3                                            NCA05400
         CH(1,K,3) = CR2+CI3                                            NCA05410
         CH(2,K,2) = CI2+CR3                                            NCA05420
         CH(2,K,3) = CI2-CR3                                            NCA05430
  101 CONTINUE                                                          NCA05440
      RETURN                                                            NCA05450
  102 DO 104 K=1,L1                                                     NCA05460
         DO 103 I=2,IDO,2                                               NCA05470
            TR2 = CC(I-1,2,K)+CC(I-1,3,K)                               NCA05480
            CR2 = CC(I-1,1,K)+TAUR*TR2                                  NCA05490
            CH(I-1,K,1) = CC(I-1,1,K)+TR2                               NCA05500
            TI2 = CC(I,2,K)+CC(I,3,K)                                   NCA05510
            CI2 = CC(I,1,K)+TAUR*TI2                                    NCA05520
            CH(I,K,1) = CC(I,1,K)+TI2                                   NCA05530
            CR3 = TAUI*(CC(I-1,2,K)-CC(I-1,3,K))                        NCA05540
            CI3 = TAUI*(CC(I,2,K)-CC(I,3,K))                            NCA05550
            DR2 = CR2-CI3                                               NCA05560
            DR3 = CR2+CI3                                               NCA05570
            DI2 = CI2+CR3                                               NCA05580
            DI3 = CI2-CR3                                               NCA05590
            CH(I,K,2) = WA1(I-1)*DI2+WA1(I)*DR2                         NCA05600
            CH(I-1,K,2) = WA1(I-1)*DR2-WA1(I)*DI2                       NCA05610
            CH(I,K,3) = WA2(I-1)*DI3+WA2(I)*DR3                         NCA05620
            CH(I-1,K,3) = WA2(I-1)*DR3-WA2(I)*DI3                       NCA05630
  103    CONTINUE                                                       NCA05640
  104 CONTINUE                                                          NCA05650
      RETURN                                                            NCA05660
      END                                                               NCA05670
      SUBROUTINE PASSB4 (IDO,L1,CC,CH,WA1,WA2,WA3)                      NCA05680
      DIMENSION       CC(IDO,4,L1)           ,CH(IDO,L1,4)           ,  NCA05690
     1                WA1(*)     ,WA2(*)     ,WA3(*)                    NCA05700
      IF (IDO .NE. 2) GO TO 102                                         NCA05710
      DO 101 K=1,L1                                                     NCA05720
         TI1 = CC(2,1,K)-CC(2,3,K)                                      NCA05730
         TI2 = CC(2,1,K)+CC(2,3,K)                                      NCA05740
         TR4 = CC(2,4,K)-CC(2,2,K)                                      NCA05750
         TI3 = CC(2,2,K)+CC(2,4,K)                                      NCA05760
         TR1 = CC(1,1,K)-CC(1,3,K)                                      NCA05770
         TR2 = CC(1,1,K)+CC(1,3,K)                                      NCA05780
         TI4 = CC(1,2,K)-CC(1,4,K)                                      NCA05790
         TR3 = CC(1,2,K)+CC(1,4,K)                                      NCA05800
         CH(1,K,1) = TR2+TR3                                            NCA05810
         CH(1,K,3) = TR2-TR3                                            NCA05820
         CH(2,K,1) = TI2+TI3                                            NCA05830
         CH(2,K,3) = TI2-TI3                                            NCA05840
         CH(1,K,2) = TR1+TR4                                            NCA05850
         CH(1,K,4) = TR1-TR4                                            NCA05860
         CH(2,K,2) = TI1+TI4                                            NCA05870
         CH(2,K,4) = TI1-TI4                                            NCA05880
  101 CONTINUE                                                          NCA05890
      RETURN                                                            NCA05900
  102 DO 104 K=1,L1                                                     NCA05910
         DO 103 I=2,IDO,2                                               NCA05920
            TI1 = CC(I,1,K)-CC(I,3,K)                                   NCA05930
            TI2 = CC(I,1,K)+CC(I,3,K)                                   NCA05940
            TI3 = CC(I,2,K)+CC(I,4,K)                                   NCA05950
            TR4 = CC(I,4,K)-CC(I,2,K)                                   NCA05960
            TR1 = CC(I-1,1,K)-CC(I-1,3,K)                               NCA05970
            TR2 = CC(I-1,1,K)+CC(I-1,3,K)                               NCA05980
            TI4 = CC(I-1,2,K)-CC(I-1,4,K)                               NCA05990
            TR3 = CC(I-1,2,K)+CC(I-1,4,K)                               NCA06000
            CH(I-1,K,1) = TR2+TR3                                       NCA06010
            CR3 = TR2-TR3                                               NCA06020
            CH(I,K,1) = TI2+TI3                                         NCA06030
            CI3 = TI2-TI3                                               NCA06040
            CR2 = TR1+TR4                                               NCA06050
            CR4 = TR1-TR4                                               NCA06060
            CI2 = TI1+TI4                                               NCA06070
            CI4 = TI1-TI4                                               NCA06080
            CH(I-1,K,2) = WA1(I-1)*CR2-WA1(I)*CI2                       NCA06090
            CH(I,K,2) = WA1(I-1)*CI2+WA1(I)*CR2                         NCA06100
            CH(I-1,K,3) = WA2(I-1)*CR3-WA2(I)*CI3                       NCA06110
            CH(I,K,3) = WA2(I-1)*CI3+WA2(I)*CR3                         NCA06120
            CH(I-1,K,4) = WA3(I-1)*CR4-WA3(I)*CI4                       NCA06130
            CH(I,K,4) = WA3(I-1)*CI4+WA3(I)*CR4                         NCA06140
  103    CONTINUE                                                       NCA06150
  104 CONTINUE                                                          NCA06160
      RETURN                                                            NCA06170
      END                                                               NCA06180
      SUBROUTINE PASSB5 (IDO,L1,CC,CH,WA1,WA2,WA3,WA4)                  NCA06190
      DIMENSION       CC(IDO,5,L1)           ,CH(IDO,L1,5)           ,  NCA06200
     1                WA1(*)     ,WA2(*)     ,WA3(*)     ,WA4(*)        NCA06210
      DATA TR11,TI11,TR12,TI12 /.309016994374947,.951056516295154,      NCA06220
     1-.809016994374947,.587785252292473/                               NCA06230
      IF (IDO .NE. 2) GO TO 102                                         NCA06240
      DO 101 K=1,L1                                                     NCA06250
         TI5 = CC(2,2,K)-CC(2,5,K)                                      NCA06260
         TI2 = CC(2,2,K)+CC(2,5,K)                                      NCA06270
         TI4 = CC(2,3,K)-CC(2,4,K)                                      NCA06280
         TI3 = CC(2,3,K)+CC(2,4,K)                                      NCA06290
         TR5 = CC(1,2,K)-CC(1,5,K)                                      NCA06300
         TR2 = CC(1,2,K)+CC(1,5,K)                                      NCA06310
         TR4 = CC(1,3,K)-CC(1,4,K)                                      NCA06320
         TR3 = CC(1,3,K)+CC(1,4,K)                                      NCA06330
         CH(1,K,1) = CC(1,1,K)+TR2+TR3                                  NCA06340
         CH(2,K,1) = CC(2,1,K)+TI2+TI3                                  NCA06350
         CR2 = CC(1,1,K)+TR11*TR2+TR12*TR3                              NCA06360
         CI2 = CC(2,1,K)+TR11*TI2+TR12*TI3                              NCA06370
         CR3 = CC(1,1,K)+TR12*TR2+TR11*TR3                              NCA06380
         CI3 = CC(2,1,K)+TR12*TI2+TR11*TI3                              NCA06390
         CR5 = TI11*TR5+TI12*TR4                                        NCA06400
         CI5 = TI11*TI5+TI12*TI4                                        NCA06410
         CR4 = TI12*TR5-TI11*TR4                                        NCA06420
         CI4 = TI12*TI5-TI11*TI4                                        NCA06430
         CH(1,K,2) = CR2-CI5                                            NCA06440
         CH(1,K,5) = CR2+CI5                                            NCA06450
         CH(2,K,2) = CI2+CR5                                            NCA06460
         CH(2,K,3) = CI3+CR4                                            NCA06470
         CH(1,K,3) = CR3-CI4                                            NCA06480
         CH(1,K,4) = CR3+CI4                                            NCA06490
         CH(2,K,4) = CI3-CR4                                            NCA06500
         CH(2,K,5) = CI2-CR5                                            NCA06510
  101 CONTINUE                                                          NCA06520
      RETURN                                                            NCA06530
  102 DO 104 K=1,L1                                                     NCA06540
         DO 103 I=2,IDO,2                                               NCA06550
            TI5 = CC(I,2,K)-CC(I,5,K)                                   NCA06560
            TI2 = CC(I,2,K)+CC(I,5,K)                                   NCA06570
            TI4 = CC(I,3,K)-CC(I,4,K)                                   NCA06580
            TI3 = CC(I,3,K)+CC(I,4,K)                                   NCA06590
            TR5 = CC(I-1,2,K)-CC(I-1,5,K)                               NCA06600
            TR2 = CC(I-1,2,K)+CC(I-1,5,K)                               NCA06610
            TR4 = CC(I-1,3,K)-CC(I-1,4,K)                               NCA06620
            TR3 = CC(I-1,3,K)+CC(I-1,4,K)                               NCA06630
            CH(I-1,K,1) = CC(I-1,1,K)+TR2+TR3                           NCA06640
            CH(I,K,1) = CC(I,1,K)+TI2+TI3                               NCA06650
            CR2 = CC(I-1,1,K)+TR11*TR2+TR12*TR3                         NCA06660
            CI2 = CC(I,1,K)+TR11*TI2+TR12*TI3                           NCA06670
            CR3 = CC(I-1,1,K)+TR12*TR2+TR11*TR3                         NCA06680
            CI3 = CC(I,1,K)+TR12*TI2+TR11*TI3                           NCA06690
            CR5 = TI11*TR5+TI12*TR4                                     NCA06700
            CI5 = TI11*TI5+TI12*TI4                                     NCA06710
            CR4 = TI12*TR5-TI11*TR4                                     NCA06720
            CI4 = TI12*TI5-TI11*TI4                                     NCA06730
            DR3 = CR3-CI4                                               NCA06740
            DR4 = CR3+CI4                                               NCA06750
            DI3 = CI3+CR4                                               NCA06760
            DI4 = CI3-CR4                                               NCA06770
            DR5 = CR2+CI5                                               NCA06780
            DR2 = CR2-CI5                                               NCA06790
            DI5 = CI2-CR5                                               NCA06800
            DI2 = CI2+CR5                                               NCA06810
            CH(I-1,K,2) = WA1(I-1)*DR2-WA1(I)*DI2                       NCA06820
            CH(I,K,2) = WA1(I-1)*DI2+WA1(I)*DR2                         NCA06830
            CH(I-1,K,3) = WA2(I-1)*DR3-WA2(I)*DI3                       NCA06840
            CH(I,K,3) = WA2(I-1)*DI3+WA2(I)*DR3                         NCA06850
            CH(I-1,K,4) = WA3(I-1)*DR4-WA3(I)*DI4                       NCA06860
            CH(I,K,4) = WA3(I-1)*DI4+WA3(I)*DR4                         NCA06870
            CH(I-1,K,5) = WA4(I-1)*DR5-WA4(I)*DI5                       NCA06880
            CH(I,K,5) = WA4(I-1)*DI5+WA4(I)*DR5                         NCA06890
  103    CONTINUE                                                       NCA06900
  104 CONTINUE                                                          NCA06910
      RETURN                                                            NCA06920
      END                                                               NCA06930
      SUBROUTINE PASSB (NAC,IDO,IP,L1,IDL1,CC,C1,C2,CH,CH2,WA)          NCA06940
      DIMENSION       CH(IDO,L1,IP)          ,CC(IDO,IP,L1)          ,  NCA06950
     1                C1(IDO,L1,IP)          ,WA(*)      ,C2(IDL1,IP),  NCA06960
     2                CH2(IDL1,IP)                                      NCA06970
      IDOT = IDO/2                                                      NCA06980
      NT = IP*IDL1                                                      NCA06990
      IPP2 = IP+2                                                       NCA07000
      IPPH = (IP+1)/2                                                   NCA07010
      IDP = IP*IDO                                                      NCA07020
C                                                                       NCA07030
      IF (IDO .LT. L1) GO TO 106                                        NCA07040
      DO 103 J=2,IPPH                                                   NCA07050
         JC = IPP2-J                                                    NCA07060
         DO 102 K=1,L1                                                  NCA07070
            DO 101 I=1,IDO                                              NCA07080
               CH(I,K,J) = CC(I,J,K)+CC(I,JC,K)                         NCA07090
               CH(I,K,JC) = CC(I,J,K)-CC(I,JC,K)                        NCA07100
  101       CONTINUE                                                    NCA07110
  102    CONTINUE                                                       NCA07120
  103 CONTINUE                                                          NCA07130
      DO 105 K=1,L1                                                     NCA07140
         DO 104 I=1,IDO                                                 NCA07150
            CH(I,K,1) = CC(I,1,K)                                       NCA07160
  104    CONTINUE                                                       NCA07170
  105 CONTINUE                                                          NCA07180
      GO TO 112                                                         NCA07190
  106 DO 109 J=2,IPPH                                                   NCA07200
         JC = IPP2-J                                                    NCA07210
         DO 108 I=1,IDO                                                 NCA07220
            DO 107 K=1,L1                                               NCA07230
               CH(I,K,J) = CC(I,J,K)+CC(I,JC,K)                         NCA07240
               CH(I,K,JC) = CC(I,J,K)-CC(I,JC,K)                        NCA07250
  107       CONTINUE                                                    NCA07260
  108    CONTINUE                                                       NCA07270
  109 CONTINUE                                                          NCA07280
      DO 111 I=1,IDO                                                    NCA07290
         DO 110 K=1,L1                                                  NCA07300
            CH(I,K,1) = CC(I,1,K)                                       NCA07310
  110    CONTINUE                                                       NCA07320
  111 CONTINUE                                                          NCA07330
  112 IDL = 2-IDO                                                       NCA07340
      INC = 0                                                           NCA07350
      DO 116 L=2,IPPH                                                   NCA07360
         LC = IPP2-L                                                    NCA07370
         IDL = IDL+IDO                                                  NCA07380
         DO 113 IK=1,IDL1                                               NCA07390
            C2(IK,L) = CH2(IK,1)+WA(IDL-1)*CH2(IK,2)                    NCA07400
            C2(IK,LC) = WA(IDL)*CH2(IK,IP)                              NCA07410
  113    CONTINUE                                                       NCA07420
         IDLJ = IDL                                                     NCA07430
         INC = INC+IDO                                                  NCA07440
         DO 115 J=3,IPPH                                                NCA07450
            JC = IPP2-J                                                 NCA07460
            IDLJ = IDLJ+INC                                             NCA07470
            IF (IDLJ .GT. IDP) IDLJ = IDLJ-IDP                          NCA07480
            WAR = WA(IDLJ-1)                                            NCA07490
            WAI = WA(IDLJ)                                              NCA07500
            DO 114 IK=1,IDL1                                            NCA07510
               C2(IK,L) = C2(IK,L)+WAR*CH2(IK,J)                        NCA07520
               C2(IK,LC) = C2(IK,LC)+WAI*CH2(IK,JC)                     NCA07530
  114       CONTINUE                                                    NCA07540
  115    CONTINUE                                                       NCA07550
  116 CONTINUE                                                          NCA07560
      DO 118 J=2,IPPH                                                   NCA07570
         DO 117 IK=1,IDL1                                               NCA07580
            CH2(IK,1) = CH2(IK,1)+CH2(IK,J)                             NCA07590
  117    CONTINUE                                                       NCA07600
  118 CONTINUE                                                          NCA07610
      DO 120 J=2,IPPH                                                   NCA07620
         JC = IPP2-J                                                    NCA07630
         DO 119 IK=2,IDL1,2                                             NCA07640
            CH2(IK-1,J) = C2(IK-1,J)-C2(IK,JC)                          NCA07650
            CH2(IK-1,JC) = C2(IK-1,J)+C2(IK,JC)                         NCA07660
            CH2(IK,J) = C2(IK,J)+C2(IK-1,JC)                            NCA07670
            CH2(IK,JC) = C2(IK,J)-C2(IK-1,JC)                           NCA07680
  119    CONTINUE                                                       NCA07690
  120 CONTINUE                                                          NCA07700
      NAC = 1                                                           NCA07710
      IF (IDO .EQ. 2) RETURN                                            NCA07720
      NAC = 0                                                           NCA07730
      DO 121 IK=1,IDL1                                                  NCA07740
         C2(IK,1) = CH2(IK,1)                                           NCA07750
  121 CONTINUE                                                          NCA07760
      DO 123 J=2,IP                                                     NCA07770
         DO 122 K=1,L1                                                  NCA07780
            C1(1,K,J) = CH(1,K,J)                                       NCA07790
            C1(2,K,J) = CH(2,K,J)                                       NCA07800
  122    CONTINUE                                                       NCA07810
  123 CONTINUE                                                          NCA07820
      IF (IDOT .GT. L1) GO TO 127                                       NCA07830
      IDIJ = 0                                                          NCA07840
      DO 126 J=2,IP                                                     NCA07850
         IDIJ = IDIJ+2                                                  NCA07860
         DO 125 I=4,IDO,2                                               NCA07870
            IDIJ = IDIJ+2                                               NCA07880
            DO 124 K=1,L1                                               NCA07890
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)-WA(IDIJ)*CH(I,K,J)  NCA07900
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)+WA(IDIJ)*CH(I-1,K,J)    NCA07910
  124       CONTINUE                                                    NCA07920
  125    CONTINUE                                                       NCA07930
  126 CONTINUE                                                          NCA07940
      RETURN                                                            NCA07950
  127 IDJ = 2-IDO                                                       NCA07960
      DO 130 J=2,IP                                                     NCA07970
         IDJ = IDJ+IDO                                                  NCA07980
         DO 129 K=1,L1                                                  NCA07990
            IDIJ = IDJ                                                  NCA08000
            DO 128 I=4,IDO,2                                            NCA08010
               IDIJ = IDIJ+2                                            NCA08020
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)-WA(IDIJ)*CH(I,K,J)  NCA08030
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)+WA(IDIJ)*CH(I-1,K,J)    NCA08040
  128       CONTINUE                                                    NCA08050
  129    CONTINUE                                                       NCA08060
  130 CONTINUE                                                          NCA08070
      RETURN                                                            NCA08080
      END                                                               NCA08090
      SUBROUTINE CFFTF (N,C,WSAVE)                                      NCA08100
      DIMENSION       C(*)       ,WSAVE(*)                              NCA08110
      IF (N .EQ. 1) RETURN                                              NCA08120
      IW1 = N+N+1                                                       NCA08130
      IW2 = IW1+N+N                                                     NCA08140
      CALL CFFTF1 (N,C,WSAVE,WSAVE(IW1),WSAVE(IW2))                     NCA08150
      RETURN                                                            NCA08160
      END                                                               NCA08170
      SUBROUTINE CFFTF1 (N,C,CH,WA,IFAC)                                NCA08180
      DIMENSION       CH(*)      ,C(*)       ,WA(*)      ,IFAC(*)       NCA08190
      NF = IFAC(2)                                                      NCA08200
      NA = 0                                                            NCA08210
      L1 = 1                                                            NCA08220
      IW = 1                                                            NCA08230
      DO 116 K1=1,NF                                                    NCA08240
         IP = IFAC(K1+2)                                                NCA08250
         L2 = IP*L1                                                     NCA08260
         IDO = N/L2                                                     NCA08270
         IDOT = IDO+IDO                                                 NCA08280
         IDL1 = IDOT*L1                                                 NCA08290
         IF (IP .NE. 4) GO TO 103                                       NCA08300
         IX2 = IW+IDOT                                                  NCA08310
         IX3 = IX2+IDOT                                                 NCA08320
         IF (NA .NE. 0) GO TO 101                                       NCA08330
         CALL PASSF4 (IDOT,L1,C,CH,WA(IW),WA(IX2),WA(IX3))              NCA08340
         GO TO 102                                                      NCA08350
  101    CALL PASSF4 (IDOT,L1,CH,C,WA(IW),WA(IX2),WA(IX3))              NCA08360
  102    NA = 1-NA                                                      NCA08370
         GO TO 115                                                      NCA08380
  103    IF (IP .NE. 2) GO TO 106                                       NCA08390
         IF (NA .NE. 0) GO TO 104                                       NCA08400
         CALL PASSF2 (IDOT,L1,C,CH,WA(IW))                              NCA08410
         GO TO 105                                                      NCA08420
  104    CALL PASSF2 (IDOT,L1,CH,C,WA(IW))                              NCA08430
  105    NA = 1-NA                                                      NCA08440
         GO TO 115                                                      NCA08450
  106    IF (IP .NE. 3) GO TO 109                                       NCA08460
         IX2 = IW+IDOT                                                  NCA08470
         IF (NA .NE. 0) GO TO 107                                       NCA08480
         CALL PASSF3 (IDOT,L1,C,CH,WA(IW),WA(IX2))                      NCA08490
         GO TO 108                                                      NCA08500
  107    CALL PASSF3 (IDOT,L1,CH,C,WA(IW),WA(IX2))                      NCA08510
  108    NA = 1-NA                                                      NCA08520
         GO TO 115                                                      NCA08530
  109    IF (IP .NE. 5) GO TO 112                                       NCA08540
         IX2 = IW+IDOT                                                  NCA08550
         IX3 = IX2+IDOT                                                 NCA08560
         IX4 = IX3+IDOT                                                 NCA08570
         IF (NA .NE. 0) GO TO 110                                       NCA08580
         CALL PASSF5 (IDOT,L1,C,CH,WA(IW),WA(IX2),WA(IX3),WA(IX4))      NCA08590
         GO TO 111                                                      NCA08600
  110    CALL PASSF5 (IDOT,L1,CH,C,WA(IW),WA(IX2),WA(IX3),WA(IX4))      NCA08610
  111    NA = 1-NA                                                      NCA08620
         GO TO 115                                                      NCA08630
  112    IF (NA .NE. 0) GO TO 113                                       NCA08640
         CALL PASSF (NAC,IDOT,IP,L1,IDL1,C,C,C,CH,CH,WA(IW))            NCA08650
         GO TO 114                                                      NCA08660
  113    CALL PASSF (NAC,IDOT,IP,L1,IDL1,CH,CH,CH,C,C,WA(IW))           NCA08670
  114    IF (NAC .NE. 0) NA = 1-NA                                      NCA08680
  115    L1 = L2                                                        NCA08690
         IW = IW+(IP-1)*IDOT                                            NCA08700
  116 CONTINUE                                                          NCA08710
      IF (NA .EQ. 0) RETURN                                             NCA08720
      N2 = N+N                                                          NCA08730
      DO 117 I=1,N2                                                     NCA08740
         C(I) = CH(I)                                                   NCA08750
  117 CONTINUE                                                          NCA08760
      RETURN                                                            NCA08770
      END                                                               NCA08780
      SUBROUTINE PASSF2 (IDO,L1,CC,CH,WA1)                              NCA08790
      DIMENSION       CC(IDO,2,L1)           ,CH(IDO,L1,2)           ,  NCA08800
     1                WA1(*)                                            NCA08810
      IF (IDO .GT. 2) GO TO 102                                         NCA08820
      DO 101 K=1,L1                                                     NCA08830
         CH(1,K,1) = CC(1,1,K)+CC(1,2,K)                                NCA08840
         CH(1,K,2) = CC(1,1,K)-CC(1,2,K)                                NCA08850
         CH(2,K,1) = CC(2,1,K)+CC(2,2,K)                                NCA08860
         CH(2,K,2) = CC(2,1,K)-CC(2,2,K)                                NCA08870
  101 CONTINUE                                                          NCA08880
      RETURN                                                            NCA08890
  102 DO 104 K=1,L1                                                     NCA08900
         DO 103 I=2,IDO,2                                               NCA08910
            CH(I-1,K,1) = CC(I-1,1,K)+CC(I-1,2,K)                       NCA08920
            TR2 = CC(I-1,1,K)-CC(I-1,2,K)                               NCA08930
            CH(I,K,1) = CC(I,1,K)+CC(I,2,K)                             NCA08940
            TI2 = CC(I,1,K)-CC(I,2,K)                                   NCA08950
            CH(I,K,2) = WA1(I-1)*TI2-WA1(I)*TR2                         NCA08960
            CH(I-1,K,2) = WA1(I-1)*TR2+WA1(I)*TI2                       NCA08970
  103    CONTINUE                                                       NCA08980
  104 CONTINUE                                                          NCA08990
      RETURN                                                            NCA09000
      END                                                               NCA09010
      SUBROUTINE PASSF3 (IDO,L1,CC,CH,WA1,WA2)                          NCA09020
      DIMENSION       CC(IDO,3,L1)           ,CH(IDO,L1,3)           ,  NCA09030
     1                WA1(*)     ,WA2(*)                                NCA09040
      DATA TAUR,TAUI /-.5,-.866025403784439/                            NCA09050
      IF (IDO .NE. 2) GO TO 102                                         NCA09060
      DO 101 K=1,L1                                                     NCA09070
         TR2 = CC(1,2,K)+CC(1,3,K)                                      NCA09080
         CR2 = CC(1,1,K)+TAUR*TR2                                       NCA09090
         CH(1,K,1) = CC(1,1,K)+TR2                                      NCA09100
         TI2 = CC(2,2,K)+CC(2,3,K)                                      NCA09110
         CI2 = CC(2,1,K)+TAUR*TI2                                       NCA09120
         CH(2,K,1) = CC(2,1,K)+TI2                                      NCA09130
         CR3 = TAUI*(CC(1,2,K)-CC(1,3,K))                               NCA09140
         CI3 = TAUI*(CC(2,2,K)-CC(2,3,K))                               NCA09150
         CH(1,K,2) = CR2-CI3                                            NCA09160
         CH(1,K,3) = CR2+CI3                                            NCA09170
         CH(2,K,2) = CI2+CR3                                            NCA09180
         CH(2,K,3) = CI2-CR3                                            NCA09190
  101 CONTINUE                                                          NCA09200
      RETURN                                                            NCA09210
  102 DO 104 K=1,L1                                                     NCA09220
         DO 103 I=2,IDO,2                                               NCA09230
            TR2 = CC(I-1,2,K)+CC(I-1,3,K)                               NCA09240
            CR2 = CC(I-1,1,K)+TAUR*TR2                                  NCA09250
            CH(I-1,K,1) = CC(I-1,1,K)+TR2                               NCA09260
            TI2 = CC(I,2,K)+CC(I,3,K)                                   NCA09270
            CI2 = CC(I,1,K)+TAUR*TI2                                    NCA09280
            CH(I,K,1) = CC(I,1,K)+TI2                                   NCA09290
            CR3 = TAUI*(CC(I-1,2,K)-CC(I-1,3,K))                        NCA09300
            CI3 = TAUI*(CC(I,2,K)-CC(I,3,K))                            NCA09310
            DR2 = CR2-CI3                                               NCA09320
            DR3 = CR2+CI3                                               NCA09330
            DI2 = CI2+CR3                                               NCA09340
            DI3 = CI2-CR3                                               NCA09350
            CH(I,K,2) = WA1(I-1)*DI2-WA1(I)*DR2                         NCA09360
            CH(I-1,K,2) = WA1(I-1)*DR2+WA1(I)*DI2                       NCA09370
            CH(I,K,3) = WA2(I-1)*DI3-WA2(I)*DR3                         NCA09380
            CH(I-1,K,3) = WA2(I-1)*DR3+WA2(I)*DI3                       NCA09390
  103    CONTINUE                                                       NCA09400
  104 CONTINUE                                                          NCA09410
      RETURN                                                            NCA09420
      END                                                               NCA09430
      SUBROUTINE PASSF4 (IDO,L1,CC,CH,WA1,WA2,WA3)                      NCA09440
      DIMENSION       CC(IDO,4,L1)           ,CH(IDO,L1,4)           ,  NCA09450
     1                WA1(*)     ,WA2(*)     ,WA3(*)                    NCA09460
      IF (IDO .NE. 2) GO TO 102                                         NCA09470
      DO 101 K=1,L1                                                     NCA09480
         TI1 = CC(2,1,K)-CC(2,3,K)                                      NCA09490
         TI2 = CC(2,1,K)+CC(2,3,K)                                      NCA09500
         TR4 = CC(2,2,K)-CC(2,4,K)                                      NCA09510
         TI3 = CC(2,2,K)+CC(2,4,K)                                      NCA09520
         TR1 = CC(1,1,K)-CC(1,3,K)                                      NCA09530
         TR2 = CC(1,1,K)+CC(1,3,K)                                      NCA09540
         TI4 = CC(1,4,K)-CC(1,2,K)                                      NCA09550
         TR3 = CC(1,2,K)+CC(1,4,K)                                      NCA09560
         CH(1,K,1) = TR2+TR3                                            NCA09570
         CH(1,K,3) = TR2-TR3                                            NCA09580
         CH(2,K,1) = TI2+TI3                                            NCA09590
         CH(2,K,3) = TI2-TI3                                            NCA09600
         CH(1,K,2) = TR1+TR4                                            NCA09610
         CH(1,K,4) = TR1-TR4                                            NCA09620
         CH(2,K,2) = TI1+TI4                                            NCA09630
         CH(2,K,4) = TI1-TI4                                            NCA09640
  101 CONTINUE                                                          NCA09650
      RETURN                                                            NCA09660
  102 DO 104 K=1,L1                                                     NCA09670
         DO 103 I=2,IDO,2                                               NCA09680
            TI1 = CC(I,1,K)-CC(I,3,K)                                   NCA09690
            TI2 = CC(I,1,K)+CC(I,3,K)                                   NCA09700
            TI3 = CC(I,2,K)+CC(I,4,K)                                   NCA09710
            TR4 = CC(I,2,K)-CC(I,4,K)                                   NCA09720
            TR1 = CC(I-1,1,K)-CC(I-1,3,K)                               NCA09730
            TR2 = CC(I-1,1,K)+CC(I-1,3,K)                               NCA09740
            TI4 = CC(I-1,4,K)-CC(I-1,2,K)                               NCA09750
            TR3 = CC(I-1,2,K)+CC(I-1,4,K)                               NCA09760
            CH(I-1,K,1) = TR2+TR3                                       NCA09770
            CR3 = TR2-TR3                                               NCA09780
            CH(I,K,1) = TI2+TI3                                         NCA09790
            CI3 = TI2-TI3                                               NCA09800
            CR2 = TR1+TR4                                               NCA09810
            CR4 = TR1-TR4                                               NCA09820
            CI2 = TI1+TI4                                               NCA09830
            CI4 = TI1-TI4                                               NCA09840
            CH(I-1,K,2) = WA1(I-1)*CR2+WA1(I)*CI2                       NCA09850
            CH(I,K,2) = WA1(I-1)*CI2-WA1(I)*CR2                         NCA09860
            CH(I-1,K,3) = WA2(I-1)*CR3+WA2(I)*CI3                       NCA09870
            CH(I,K,3) = WA2(I-1)*CI3-WA2(I)*CR3                         NCA09880
            CH(I-1,K,4) = WA3(I-1)*CR4+WA3(I)*CI4                       NCA09890
            CH(I,K,4) = WA3(I-1)*CI4-WA3(I)*CR4                         NCA09900
  103    CONTINUE                                                       NCA09910
  104 CONTINUE                                                          NCA09920
      RETURN                                                            NCA09930
      END                                                               NCA09940
      SUBROUTINE PASSF5 (IDO,L1,CC,CH,WA1,WA2,WA3,WA4)                  NCA09950
      DIMENSION       CC(IDO,5,L1)           ,CH(IDO,L1,5)           ,  NCA09960
     1                WA1(*)     ,WA2(*)     ,WA3(*)     ,WA4(*)        NCA09970
      DATA TR11,TI11,TR12,TI12 /.309016994374947,-.951056516295154,     NCA09980
     1-.809016994374947,-.587785252292473/                              NCA09990
      IF (IDO .NE. 2) GO TO 102                                         NCA10000
      DO 101 K=1,L1                                                     NCA10010
         TI5 = CC(2,2,K)-CC(2,5,K)                                      NCA10020
         TI2 = CC(2,2,K)+CC(2,5,K)                                      NCA10030
         TI4 = CC(2,3,K)-CC(2,4,K)                                      NCA10040
         TI3 = CC(2,3,K)+CC(2,4,K)                                      NCA10050
         TR5 = CC(1,2,K)-CC(1,5,K)                                      NCA10060
         TR2 = CC(1,2,K)+CC(1,5,K)                                      NCA10070
         TR4 = CC(1,3,K)-CC(1,4,K)                                      NCA10080
         TR3 = CC(1,3,K)+CC(1,4,K)                                      NCA10090
         CH(1,K,1) = CC(1,1,K)+TR2+TR3                                  NCA10100
         CH(2,K,1) = CC(2,1,K)+TI2+TI3                                  NCA10110
         CR2 = CC(1,1,K)+TR11*TR2+TR12*TR3                              NCA10120
         CI2 = CC(2,1,K)+TR11*TI2+TR12*TI3                              NCA10130
         CR3 = CC(1,1,K)+TR12*TR2+TR11*TR3                              NCA10140
         CI3 = CC(2,1,K)+TR12*TI2+TR11*TI3                              NCA10150
         CR5 = TI11*TR5+TI12*TR4                                        NCA10160
         CI5 = TI11*TI5+TI12*TI4                                        NCA10170
         CR4 = TI12*TR5-TI11*TR4                                        NCA10180
         CI4 = TI12*TI5-TI11*TI4                                        NCA10190
         CH(1,K,2) = CR2-CI5                                            NCA10200
         CH(1,K,5) = CR2+CI5                                            NCA10210
         CH(2,K,2) = CI2+CR5                                            NCA10220
         CH(2,K,3) = CI3+CR4                                            NCA10230
         CH(1,K,3) = CR3-CI4                                            NCA10240
         CH(1,K,4) = CR3+CI4                                            NCA10250
         CH(2,K,4) = CI3-CR4                                            NCA10260
         CH(2,K,5) = CI2-CR5                                            NCA10270
  101 CONTINUE                                                          NCA10280
      RETURN                                                            NCA10290
  102 DO 104 K=1,L1                                                     NCA10300
         DO 103 I=2,IDO,2                                               NCA10310
            TI5 = CC(I,2,K)-CC(I,5,K)                                   NCA10320
            TI2 = CC(I,2,K)+CC(I,5,K)                                   NCA10330
            TI4 = CC(I,3,K)-CC(I,4,K)                                   NCA10340
            TI3 = CC(I,3,K)+CC(I,4,K)                                   NCA10350
            TR5 = CC(I-1,2,K)-CC(I-1,5,K)                               NCA10360
            TR2 = CC(I-1,2,K)+CC(I-1,5,K)                               NCA10370
            TR4 = CC(I-1,3,K)-CC(I-1,4,K)                               NCA10380
            TR3 = CC(I-1,3,K)+CC(I-1,4,K)                               NCA10390
            CH(I-1,K,1) = CC(I-1,1,K)+TR2+TR3                           NCA10400
            CH(I,K,1) = CC(I,1,K)+TI2+TI3                               NCA10410
            CR2 = CC(I-1,1,K)+TR11*TR2+TR12*TR3                         NCA10420
            CI2 = CC(I,1,K)+TR11*TI2+TR12*TI3                           NCA10430
            CR3 = CC(I-1,1,K)+TR12*TR2+TR11*TR3                         NCA10440
            CI3 = CC(I,1,K)+TR12*TI2+TR11*TI3                           NCA10450
            CR5 = TI11*TR5+TI12*TR4                                     NCA10460
            CI5 = TI11*TI5+TI12*TI4                                     NCA10470
            CR4 = TI12*TR5-TI11*TR4                                     NCA10480
            CI4 = TI12*TI5-TI11*TI4                                     NCA10490
            DR3 = CR3-CI4                                               NCA10500
            DR4 = CR3+CI4                                               NCA10510
            DI3 = CI3+CR4                                               NCA10520
            DI4 = CI3-CR4                                               NCA10530
            DR5 = CR2+CI5                                               NCA10540
            DR2 = CR2-CI5                                               NCA10550
            DI5 = CI2-CR5                                               NCA10560
            DI2 = CI2+CR5                                               NCA10570
            CH(I-1,K,2) = WA1(I-1)*DR2+WA1(I)*DI2                       NCA10580
            CH(I,K,2) = WA1(I-1)*DI2-WA1(I)*DR2                         NCA10590
            CH(I-1,K,3) = WA2(I-1)*DR3+WA2(I)*DI3                       NCA10600
            CH(I,K,3) = WA2(I-1)*DI3-WA2(I)*DR3                         NCA10610
            CH(I-1,K,4) = WA3(I-1)*DR4+WA3(I)*DI4                       NCA10620
            CH(I,K,4) = WA3(I-1)*DI4-WA3(I)*DR4                         NCA10630
            CH(I-1,K,5) = WA4(I-1)*DR5+WA4(I)*DI5                       NCA10640
            CH(I,K,5) = WA4(I-1)*DI5-WA4(I)*DR5                         NCA10650
  103    CONTINUE                                                       NCA10660
  104 CONTINUE                                                          NCA10670
      RETURN                                                            NCA10680
      END                                                               NCA10690
      SUBROUTINE PASSF (NAC,IDO,IP,L1,IDL1,CC,C1,C2,CH,CH2,WA)          NCA10700
      DIMENSION       CH(IDO,L1,IP)          ,CC(IDO,IP,L1)          ,  NCA10710
     1                C1(IDO,L1,IP)          ,WA(*)      ,C2(IDL1,IP),  NCA10720
     2                CH2(IDL1,IP)                                      NCA10730
      IDOT = IDO/2                                                      NCA10740
      NT = IP*IDL1                                                      NCA10750
      IPP2 = IP+2                                                       NCA10760
      IPPH = (IP+1)/2                                                   NCA10770
      IDP = IP*IDO                                                      NCA10780
C                                                                       NCA10790
      IF (IDO .LT. L1) GO TO 106                                        NCA10800
      DO 103 J=2,IPPH                                                   NCA10810
         JC = IPP2-J                                                    NCA10820
         DO 102 K=1,L1                                                  NCA10830
            DO 101 I=1,IDO                                              NCA10840
               CH(I,K,J) = CC(I,J,K)+CC(I,JC,K)                         NCA10850
               CH(I,K,JC) = CC(I,J,K)-CC(I,JC,K)                        NCA10860
  101       CONTINUE                                                    NCA10870
  102    CONTINUE                                                       NCA10880
  103 CONTINUE                                                          NCA10890
      DO 105 K=1,L1                                                     NCA10900
         DO 104 I=1,IDO                                                 NCA10910
            CH(I,K,1) = CC(I,1,K)                                       NCA10920
  104    CONTINUE                                                       NCA10930
  105 CONTINUE                                                          NCA10940
      GO TO 112                                                         NCA10950
  106 DO 109 J=2,IPPH                                                   NCA10960
         JC = IPP2-J                                                    NCA10970
         DO 108 I=1,IDO                                                 NCA10980
            DO 107 K=1,L1                                               NCA10990
               CH(I,K,J) = CC(I,J,K)+CC(I,JC,K)                         NCA11000
               CH(I,K,JC) = CC(I,J,K)-CC(I,JC,K)                        NCA11010
  107       CONTINUE                                                    NCA11020
  108    CONTINUE                                                       NCA11030
  109 CONTINUE                                                          NCA11040
      DO 111 I=1,IDO                                                    NCA11050
         DO 110 K=1,L1                                                  NCA11060
            CH(I,K,1) = CC(I,1,K)                                       NCA11070
  110    CONTINUE                                                       NCA11080
  111 CONTINUE                                                          NCA11090
  112 IDL = 2-IDO                                                       NCA11100
      INC = 0                                                           NCA11110
      DO 116 L=2,IPPH                                                   NCA11120
         LC = IPP2-L                                                    NCA11130
         IDL = IDL+IDO                                                  NCA11140
         DO 113 IK=1,IDL1                                               NCA11150
            C2(IK,L) = CH2(IK,1)+WA(IDL-1)*CH2(IK,2)                    NCA11160
            C2(IK,LC) = -WA(IDL)*CH2(IK,IP)                             NCA11170
  113    CONTINUE                                                       NCA11180
         IDLJ = IDL                                                     NCA11190
         INC = INC+IDO                                                  NCA11200
         DO 115 J=3,IPPH                                                NCA11210
            JC = IPP2-J                                                 NCA11220
            IDLJ = IDLJ+INC                                             NCA11230
            IF (IDLJ .GT. IDP) IDLJ = IDLJ-IDP                          NCA11240
            WAR = WA(IDLJ-1)                                            NCA11250
            WAI = WA(IDLJ)                                              NCA11260
            DO 114 IK=1,IDL1                                            NCA11270
               C2(IK,L) = C2(IK,L)+WAR*CH2(IK,J)                        NCA11280
               C2(IK,LC) = C2(IK,LC)-WAI*CH2(IK,JC)                     NCA11290
  114       CONTINUE                                                    NCA11300
  115    CONTINUE                                                       NCA11310
  116 CONTINUE                                                          NCA11320
      DO 118 J=2,IPPH                                                   NCA11330
         DO 117 IK=1,IDL1                                               NCA11340
            CH2(IK,1) = CH2(IK,1)+CH2(IK,J)                             NCA11350
  117    CONTINUE                                                       NCA11360
  118 CONTINUE                                                          NCA11370
      DO 120 J=2,IPPH                                                   NCA11380
         JC = IPP2-J                                                    NCA11390
         DO 119 IK=2,IDL1,2                                             NCA11400
            CH2(IK-1,J) = C2(IK-1,J)-C2(IK,JC)                          NCA11410
            CH2(IK-1,JC) = C2(IK-1,J)+C2(IK,JC)                         NCA11420
            CH2(IK,J) = C2(IK,J)+C2(IK-1,JC)                            NCA11430
            CH2(IK,JC) = C2(IK,J)-C2(IK-1,JC)                           NCA11440
  119    CONTINUE                                                       NCA11450
  120 CONTINUE                                                          NCA11460
      NAC = 1                                                           NCA11470
      IF (IDO .EQ. 2) RETURN                                            NCA11480
      NAC = 0                                                           NCA11490
      DO 121 IK=1,IDL1                                                  NCA11500
         C2(IK,1) = CH2(IK,1)                                           NCA11510
  121 CONTINUE                                                          NCA11520
      DO 123 J=2,IP                                                     NCA11530
         DO 122 K=1,L1                                                  NCA11540
            C1(1,K,J) = CH(1,K,J)                                       NCA11550
            C1(2,K,J) = CH(2,K,J)                                       NCA11560
  122    CONTINUE                                                       NCA11570
  123 CONTINUE                                                          NCA11580
      IF (IDOT .GT. L1) GO TO 127                                       NCA11590
      IDIJ = 0                                                          NCA11600
      DO 126 J=2,IP                                                     NCA11610
         IDIJ = IDIJ+2                                                  NCA11620
         DO 125 I=4,IDO,2                                               NCA11630
            IDIJ = IDIJ+2                                               NCA11640
            DO 124 K=1,L1                                               NCA11650
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)+WA(IDIJ)*CH(I,K,J)  NCA11660
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)-WA(IDIJ)*CH(I-1,K,J)    NCA11670
  124       CONTINUE                                                    NCA11680
  125    CONTINUE                                                       NCA11690
  126 CONTINUE                                                          NCA11700
      RETURN                                                            NCA11710
  127 IDJ = 2-IDO                                                       NCA11720
      DO 130 J=2,IP                                                     NCA11730
         IDJ = IDJ+IDO                                                  NCA11740
         DO 129 K=1,L1                                                  NCA11750
            IDIJ = IDJ                                                  NCA11760
            DO 128 I=4,IDO,2                                            NCA11770
               IDIJ = IDIJ+2                                            NCA11780
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)+WA(IDIJ)*CH(I,K,J)  NCA11790
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)-WA(IDIJ)*CH(I-1,K,J)    NCA11800
  128       CONTINUE                                                    NCA11810
  129    CONTINUE                                                       NCA11820
  130 CONTINUE                                                          NCA11830
      RETURN                                                            NCA11840
      END                                                               NCA11850
      SUBROUTINE RFFTI (N,WSAVE)                                        NCA11860
      DIMENSION       WSAVE(*)                                          NCA11870
      IF (N .EQ. 1) RETURN                                              NCA11880
      CALL RFFTI1 (N,WSAVE(N+1),WSAVE(2*N+1))                           NCA11890
      RETURN                                                            NCA11900
      END                                                               NCA11910
      SUBROUTINE RFFTI1 (N,WA,IFAC)                                     NCA11920
      DIMENSION       WA(*)      ,IFAC(*)    ,NTRYH(4)                  NCA11930
      DATA NTRYH(1),NTRYH(2),NTRYH(3),NTRYH(4)/4,2,3,5/                 NCA11940
      NL = N                                                            NCA11950
      NF = 0                                                            NCA11960
      J = 0                                                             NCA11970
  101 J = J+1                                                           NCA11980
      IF (J-4) 102,102,103                                              NCA11990
  102 NTRY = NTRYH(J)                                                   NCA12000
      GO TO 104                                                         NCA12010
  103 NTRY = NTRY+2                                                     NCA12020
  104 NQ = NL/NTRY                                                      NCA12030
      NR = NL-NTRY*NQ                                                   NCA12040
      IF (NR) 101,105,101                                               NCA12050
  105 NF = NF+1                                                         NCA12060
      IFAC(NF+2) = NTRY                                                 NCA12070
      NL = NQ                                                           NCA12080
      IF (NTRY .NE. 2) GO TO 107                                        NCA12090
      IF (NF .EQ. 1) GO TO 107                                          NCA12100
      DO 106 I=2,NF                                                     NCA12110
         IB = NF-I+2                                                    NCA12120
         IFAC(IB+2) = IFAC(IB+1)                                        NCA12130
  106 CONTINUE                                                          NCA12140
      IFAC(3) = 2                                                       NCA12150
  107 IF (NL .NE. 1) GO TO 104                                          NCA12160
      IFAC(1) = N                                                       NCA12170
      IFAC(2) = NF                                                      NCA12180
      TPI = 6.28318530717959                                            NCA12190
      ARGH = TPI/FLOAT(N)                                               NCA12200
      IS = 0                                                            NCA12210
      NFM1 = NF-1                                                       NCA12220
      L1 = 1                                                            NCA12230
      IF (NFM1 .EQ. 0) RETURN                                           NCA12240
      DO 110 K1=1,NFM1                                                  NCA12250
         IP = IFAC(K1+2)                                                NCA12260
         LD = 0                                                         NCA12270
         L2 = L1*IP                                                     NCA12280
         IDO = N/L2                                                     NCA12290
         IPM = IP-1                                                     NCA12300
         DO 109 J=1,IPM                                                 NCA12310
            LD = LD+L1                                                  NCA12320
            I = IS                                                      NCA12330
            ARGLD = FLOAT(LD)*ARGH                                      NCA12340
            FI = 0.                                                     NCA12350
            DO 108 II=3,IDO,2                                           NCA12360
               I = I+2                                                  NCA12370
               FI = FI+1.                                               NCA12380
               ARG = FI*ARGLD                                           NCA12390
               WA(I-1) = COS(ARG)                                       NCA12400
               WA(I) = SIN(ARG)                                         NCA12410
  108       CONTINUE                                                    NCA12420
            IS = IS+IDO                                                 NCA12430
  109    CONTINUE                                                       NCA12440
         L1 = L2                                                        NCA12450
  110 CONTINUE                                                          NCA12460
      RETURN                                                            NCA12470
      END                                                               NCA12480
      SUBROUTINE RFFTB (N,R,WSAVE)                                      NCA12490
      DIMENSION       R(*)       ,WSAVE(*)                              NCA12500
      IF (N .EQ. 1) RETURN                                              NCA12510
      CALL RFFTB1 (N,R,WSAVE,WSAVE(N+1),WSAVE(2*N+1))                   NCA12520
      RETURN                                                            NCA12530
      END                                                               NCA12540
      SUBROUTINE RFFTB1 (N,C,CH,WA,IFAC)                                NCA12550
      DIMENSION       CH(*)      ,C(*)       ,WA(*)      ,IFAC(*)       NCA12560
      NF = IFAC(2)                                                      NCA12570
      NA = 0                                                            NCA12580
      L1 = 1                                                            NCA12590
      IW = 1                                                            NCA12600
      DO 116 K1=1,NF                                                    NCA12610
         IP = IFAC(K1+2)                                                NCA12620
         L2 = IP*L1                                                     NCA12630
         IDO = N/L2                                                     NCA12640
         IDL1 = IDO*L1                                                  NCA12650
         IF (IP .NE. 4) GO TO 103                                       NCA12660
         IX2 = IW+IDO                                                   NCA12670
         IX3 = IX2+IDO                                                  NCA12680
         IF (NA .NE. 0) GO TO 101                                       NCA12690
         CALL RADB4 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3))                NCA12700
         GO TO 102                                                      NCA12710
  101    CALL RADB4 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3))                NCA12720
  102    NA = 1-NA                                                      NCA12730
         GO TO 115                                                      NCA12740
  103    IF (IP .NE. 2) GO TO 106                                       NCA12750
         IF (NA .NE. 0) GO TO 104                                       NCA12760
         CALL RADB2 (IDO,L1,C,CH,WA(IW))                                NCA12770
         GO TO 105                                                      NCA12780
  104    CALL RADB2 (IDO,L1,CH,C,WA(IW))                                NCA12790
  105    NA = 1-NA                                                      NCA12800
         GO TO 115                                                      NCA12810
  106    IF (IP .NE. 3) GO TO 109                                       NCA12820
         IX2 = IW+IDO                                                   NCA12830
         IF (NA .NE. 0) GO TO 107                                       NCA12840
         CALL RADB3 (IDO,L1,C,CH,WA(IW),WA(IX2))                        NCA12850
         GO TO 108                                                      NCA12860
  107    CALL RADB3 (IDO,L1,CH,C,WA(IW),WA(IX2))                        NCA12870
  108    NA = 1-NA                                                      NCA12880
         GO TO 115                                                      NCA12890
  109    IF (IP .NE. 5) GO TO 112                                       NCA12900
         IX2 = IW+IDO                                                   NCA12910
         IX3 = IX2+IDO                                                  NCA12920
         IX4 = IX3+IDO                                                  NCA12930
         IF (NA .NE. 0) GO TO 110                                       NCA12940
         CALL RADB5 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3),WA(IX4))        NCA12950
         GO TO 111                                                      NCA12960
  110    CALL RADB5 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3),WA(IX4))        NCA12970
  111    NA = 1-NA                                                      NCA12980
         GO TO 115                                                      NCA12990
  112    IF (NA .NE. 0) GO TO 113                                       NCA13000
         CALL RADBG (IDO,IP,L1,IDL1,C,C,C,CH,CH,WA(IW))                 NCA13010
         GO TO 114                                                      NCA13020
  113    CALL RADBG (IDO,IP,L1,IDL1,CH,CH,CH,C,C,WA(IW))                NCA13030
  114    IF (IDO .EQ. 1) NA = 1-NA                                      NCA13040
  115    L1 = L2                                                        NCA13050
         IW = IW+(IP-1)*IDO                                             NCA13060
  116 CONTINUE                                                          NCA13070
      IF (NA .EQ. 0) RETURN                                             NCA13080
      DO 117 I=1,N                                                      NCA13090
         C(I) = CH(I)                                                   NCA13100
  117 CONTINUE                                                          NCA13110
      RETURN                                                            NCA13120
      END                                                               NCA13130
      SUBROUTINE RADB2 (IDO,L1,CC,CH,WA1)                               NCA13140
      DIMENSION       CC(IDO,2,L1)           ,CH(IDO,L1,2)           ,  NCA13150
     1                WA1(*)                                            NCA13160
      DO 101 K=1,L1                                                     NCA13170
         CH(1,K,1) = CC(1,1,K)+CC(IDO,2,K)                              NCA13180
         CH(1,K,2) = CC(1,1,K)-CC(IDO,2,K)                              NCA13190
  101 CONTINUE                                                          NCA13200
      IF (IDO-2) 107,105,102                                            NCA13210
  102 IDP2 = IDO+2                                                      NCA13220
      DO 104 K=1,L1                                                     NCA13230
         DO 103 I=3,IDO,2                                               NCA13240
            IC = IDP2-I                                                 NCA13250
            CH(I-1,K,1) = CC(I-1,1,K)+CC(IC-1,2,K)                      NCA13260
            TR2 = CC(I-1,1,K)-CC(IC-1,2,K)                              NCA13270
            CH(I,K,1) = CC(I,1,K)-CC(IC,2,K)                            NCA13280
            TI2 = CC(I,1,K)+CC(IC,2,K)                                  NCA13290
            CH(I-1,K,2) = WA1(I-2)*TR2-WA1(I-1)*TI2                     NCA13300
            CH(I,K,2) = WA1(I-2)*TI2+WA1(I-1)*TR2                       NCA13310
  103    CONTINUE                                                       NCA13320
  104 CONTINUE                                                          NCA13330
      IF (MOD(IDO,2) .EQ. 1) RETURN                                     NCA13340
  105 DO 106 K=1,L1                                                     NCA13350
         CH(IDO,K,1) = CC(IDO,1,K)+CC(IDO,1,K)                          NCA13360
         CH(IDO,K,2) = -(CC(1,2,K)+CC(1,2,K))                           NCA13370
  106 CONTINUE                                                          NCA13380
  107 RETURN                                                            NCA13390
      END                                                               NCA13400
      SUBROUTINE RADB3 (IDO,L1,CC,CH,WA1,WA2)                           NCA13410
      DIMENSION       CC(IDO,3,L1)           ,CH(IDO,L1,3)           ,  NCA13420
     1                WA1(*)     ,WA2(*)                                NCA13430
      DATA TAUR,TAUI /-.5,.866025403784439/                             NCA13440
      DO 101 K=1,L1                                                     NCA13450
         TR2 = CC(IDO,2,K)+CC(IDO,2,K)                                  NCA13460
         CR2 = CC(1,1,K)+TAUR*TR2                                       NCA13470
         CH(1,K,1) = CC(1,1,K)+TR2                                      NCA13480
         CI3 = TAUI*(CC(1,3,K)+CC(1,3,K))                               NCA13490
         CH(1,K,2) = CR2-CI3                                            NCA13500
         CH(1,K,3) = CR2+CI3                                            NCA13510
  101 CONTINUE                                                          NCA13520
      IF (IDO .EQ. 1) RETURN                                            NCA13530
      IDP2 = IDO+2                                                      NCA13540
      DO 103 K=1,L1                                                     NCA13550
         DO 102 I=3,IDO,2                                               NCA13560
            IC = IDP2-I                                                 NCA13570
            TR2 = CC(I-1,3,K)+CC(IC-1,2,K)                              NCA13580
            CR2 = CC(I-1,1,K)+TAUR*TR2                                  NCA13590
            CH(I-1,K,1) = CC(I-1,1,K)+TR2                               NCA13600
            TI2 = CC(I,3,K)-CC(IC,2,K)                                  NCA13610
            CI2 = CC(I,1,K)+TAUR*TI2                                    NCA13620
            CH(I,K,1) = CC(I,1,K)+TI2                                   NCA13630
            CR3 = TAUI*(CC(I-1,3,K)-CC(IC-1,2,K))                       NCA13640
            CI3 = TAUI*(CC(I,3,K)+CC(IC,2,K))                           NCA13650
            DR2 = CR2-CI3                                               NCA13660
            DR3 = CR2+CI3                                               NCA13670
            DI2 = CI2+CR3                                               NCA13680
            DI3 = CI2-CR3                                               NCA13690
            CH(I-1,K,2) = WA1(I-2)*DR2-WA1(I-1)*DI2                     NCA13700
            CH(I,K,2) = WA1(I-2)*DI2+WA1(I-1)*DR2                       NCA13710
            CH(I-1,K,3) = WA2(I-2)*DR3-WA2(I-1)*DI3                     NCA13720
            CH(I,K,3) = WA2(I-2)*DI3+WA2(I-1)*DR3                       NCA13730
  102    CONTINUE                                                       NCA13740
  103 CONTINUE                                                          NCA13750
      RETURN                                                            NCA13760
      END                                                               NCA13770
      SUBROUTINE RADB4 (IDO,L1,CC,CH,WA1,WA2,WA3)                       NCA13780
      DIMENSION       CC(IDO,4,L1)           ,CH(IDO,L1,4)           ,  NCA13790
     1                WA1(*)     ,WA2(*)     ,WA3(*)                    NCA13800
      DATA SQRT2 /1.414213562373095/                                    NCA13810
      DO 101 K=1,L1                                                     NCA13820
         TR1 = CC(1,1,K)-CC(IDO,4,K)                                    NCA13830
         TR2 = CC(1,1,K)+CC(IDO,4,K)                                    NCA13840
         TR3 = CC(IDO,2,K)+CC(IDO,2,K)                                  NCA13850
         TR4 = CC(1,3,K)+CC(1,3,K)                                      NCA13860
         CH(1,K,1) = TR2+TR3                                            NCA13870
         CH(1,K,2) = TR1-TR4                                            NCA13880
         CH(1,K,3) = TR2-TR3                                            NCA13890
         CH(1,K,4) = TR1+TR4                                            NCA13900
  101 CONTINUE                                                          NCA13910
      IF (IDO-2) 107,105,102                                            NCA13920
  102 IDP2 = IDO+2                                                      NCA13930
      DO 104 K=1,L1                                                     NCA13940
         DO 103 I=3,IDO,2                                               NCA13950
            IC = IDP2-I                                                 NCA13960
            TI1 = CC(I,1,K)+CC(IC,4,K)                                  NCA13970
            TI2 = CC(I,1,K)-CC(IC,4,K)                                  NCA13980
            TI3 = CC(I,3,K)-CC(IC,2,K)                                  NCA13990
            TR4 = CC(I,3,K)+CC(IC,2,K)                                  NCA14000
            TR1 = CC(I-1,1,K)-CC(IC-1,4,K)                              NCA14010
            TR2 = CC(I-1,1,K)+CC(IC-1,4,K)                              NCA14020
            TI4 = CC(I-1,3,K)-CC(IC-1,2,K)                              NCA14030
            TR3 = CC(I-1,3,K)+CC(IC-1,2,K)                              NCA14040
            CH(I-1,K,1) = TR2+TR3                                       NCA14050
            CR3 = TR2-TR3                                               NCA14060
            CH(I,K,1) = TI2+TI3                                         NCA14070
            CI3 = TI2-TI3                                               NCA14080
            CR2 = TR1-TR4                                               NCA14090
            CR4 = TR1+TR4                                               NCA14100
            CI2 = TI1+TI4                                               NCA14110
            CI4 = TI1-TI4                                               NCA14120
            CH(I-1,K,2) = WA1(I-2)*CR2-WA1(I-1)*CI2                     NCA14130
            CH(I,K,2) = WA1(I-2)*CI2+WA1(I-1)*CR2                       NCA14140
            CH(I-1,K,3) = WA2(I-2)*CR3-WA2(I-1)*CI3                     NCA14150
            CH(I,K,3) = WA2(I-2)*CI3+WA2(I-1)*CR3                       NCA14160
            CH(I-1,K,4) = WA3(I-2)*CR4-WA3(I-1)*CI4                     NCA14170
            CH(I,K,4) = WA3(I-2)*CI4+WA3(I-1)*CR4                       NCA14180
  103    CONTINUE                                                       NCA14190
  104 CONTINUE                                                          NCA14200
      IF (MOD(IDO,2) .EQ. 1) RETURN                                     NCA14210
  105 CONTINUE                                                          NCA14220
      DO 106 K=1,L1                                                     NCA14230
         TI1 = CC(1,2,K)+CC(1,4,K)                                      NCA14240
         TI2 = CC(1,4,K)-CC(1,2,K)                                      NCA14250
         TR1 = CC(IDO,1,K)-CC(IDO,3,K)                                  NCA14260
         TR2 = CC(IDO,1,K)+CC(IDO,3,K)                                  NCA14270
         CH(IDO,K,1) = TR2+TR2                                          NCA14280
         CH(IDO,K,2) = SQRT2*(TR1-TI1)                                  NCA14290
         CH(IDO,K,3) = TI2+TI2                                          NCA14300
         CH(IDO,K,4) = -SQRT2*(TR1+TI1)                                 NCA14310
  106 CONTINUE                                                          NCA14320
  107 RETURN                                                            NCA14330
      END                                                               NCA14340
      SUBROUTINE RADB5 (IDO,L1,CC,CH,WA1,WA2,WA3,WA4)                   NCA14350
      DIMENSION       CC(IDO,5,L1)           ,CH(IDO,L1,5)           ,  NCA14360
     1                WA1(*)     ,WA2(*)     ,WA3(*)     ,WA4(*)        NCA14370
      DATA TR11,TI11,TR12,TI12 /.309016994374947,.951056516295154,      NCA14380
     1-.809016994374947,.587785252292473/                               NCA14390
      DO 101 K=1,L1                                                     NCA14400
         TI5 = CC(1,3,K)+CC(1,3,K)                                      NCA14410
         TI4 = CC(1,5,K)+CC(1,5,K)                                      NCA14420
         TR2 = CC(IDO,2,K)+CC(IDO,2,K)                                  NCA14430
         TR3 = CC(IDO,4,K)+CC(IDO,4,K)                                  NCA14440
         CH(1,K,1) = CC(1,1,K)+TR2+TR3                                  NCA14450
         CR2 = CC(1,1,K)+TR11*TR2+TR12*TR3                              NCA14460
         CR3 = CC(1,1,K)+TR12*TR2+TR11*TR3                              NCA14470
         CI5 = TI11*TI5+TI12*TI4                                        NCA14480
         CI4 = TI12*TI5-TI11*TI4                                        NCA14490
         CH(1,K,2) = CR2-CI5                                            NCA14500
         CH(1,K,3) = CR3-CI4                                            NCA14510
         CH(1,K,4) = CR3+CI4                                            NCA14520
         CH(1,K,5) = CR2+CI5                                            NCA14530
  101 CONTINUE                                                          NCA14540
      IF (IDO .EQ. 1) RETURN                                            NCA14550
      IDP2 = IDO+2                                                      NCA14560
      DO 103 K=1,L1                                                     NCA14570
         DO 102 I=3,IDO,2                                               NCA14580
            IC = IDP2-I                                                 NCA14590
            TI5 = CC(I,3,K)+CC(IC,2,K)                                  NCA14600
            TI2 = CC(I,3,K)-CC(IC,2,K)                                  NCA14610
            TI4 = CC(I,5,K)+CC(IC,4,K)                                  NCA14620
            TI3 = CC(I,5,K)-CC(IC,4,K)                                  NCA14630
            TR5 = CC(I-1,3,K)-CC(IC-1,2,K)                              NCA14640
            TR2 = CC(I-1,3,K)+CC(IC-1,2,K)                              NCA14650
            TR4 = CC(I-1,5,K)-CC(IC-1,4,K)                              NCA14660
            TR3 = CC(I-1,5,K)+CC(IC-1,4,K)                              NCA14670
            CH(I-1,K,1) = CC(I-1,1,K)+TR2+TR3                           NCA14680
            CH(I,K,1) = CC(I,1,K)+TI2+TI3                               NCA14690
            CR2 = CC(I-1,1,K)+TR11*TR2+TR12*TR3                         NCA14700
            CI2 = CC(I,1,K)+TR11*TI2+TR12*TI3                           NCA14710
            CR3 = CC(I-1,1,K)+TR12*TR2+TR11*TR3                         NCA14720
            CI3 = CC(I,1,K)+TR12*TI2+TR11*TI3                           NCA14730
            CR5 = TI11*TR5+TI12*TR4                                     NCA14740
            CI5 = TI11*TI5+TI12*TI4                                     NCA14750
            CR4 = TI12*TR5-TI11*TR4                                     NCA14760
            CI4 = TI12*TI5-TI11*TI4                                     NCA14770
            DR3 = CR3-CI4                                               NCA14780
            DR4 = CR3+CI4                                               NCA14790
            DI3 = CI3+CR4                                               NCA14800
            DI4 = CI3-CR4                                               NCA14810
            DR5 = CR2+CI5                                               NCA14820
            DR2 = CR2-CI5                                               NCA14830
            DI5 = CI2-CR5                                               NCA14840
            DI2 = CI2+CR5                                               NCA14850
            CH(I-1,K,2) = WA1(I-2)*DR2-WA1(I-1)*DI2                     NCA14860
            CH(I,K,2) = WA1(I-2)*DI2+WA1(I-1)*DR2                       NCA14870
            CH(I-1,K,3) = WA2(I-2)*DR3-WA2(I-1)*DI3                     NCA14880
            CH(I,K,3) = WA2(I-2)*DI3+WA2(I-1)*DR3                       NCA14890
            CH(I-1,K,4) = WA3(I-2)*DR4-WA3(I-1)*DI4                     NCA14900
            CH(I,K,4) = WA3(I-2)*DI4+WA3(I-1)*DR4                       NCA14910
            CH(I-1,K,5) = WA4(I-2)*DR5-WA4(I-1)*DI5                     NCA14920
            CH(I,K,5) = WA4(I-2)*DI5+WA4(I-1)*DR5                       NCA14930
  102    CONTINUE                                                       NCA14940
  103 CONTINUE                                                          NCA14950
      RETURN                                                            NCA14960
      END                                                               NCA14970
      SUBROUTINE RADBG (IDO,IP,L1,IDL1,CC,C1,C2,CH,CH2,WA)              NCA14980
      DIMENSION       CH(IDO,L1,IP)          ,CC(IDO,IP,L1)          ,  NCA14990
     1                C1(IDO,L1,IP)          ,C2(IDL1,IP),              NCA15000
     2                CH2(IDL1,IP)           ,WA(*)                     NCA15010
      DATA TPI/6.28318530717959/                                        NCA15020
      ARG = TPI/FLOAT(IP)                                               NCA15030
      DCP = COS(ARG)                                                    NCA15040
      DSP = SIN(ARG)                                                    NCA15050
      IDP2 = IDO+2                                                      NCA15060
      NBD = (IDO-1)/2                                                   NCA15070
      IPP2 = IP+2                                                       NCA15080
      IPPH = (IP+1)/2                                                   NCA15090
      IF (IDO .LT. L1) GO TO 103                                        NCA15100
      DO 102 K=1,L1                                                     NCA15110
         DO 101 I=1,IDO                                                 NCA15120
            CH(I,K,1) = CC(I,1,K)                                       NCA15130
  101    CONTINUE                                                       NCA15140
  102 CONTINUE                                                          NCA15150
      GO TO 106                                                         NCA15160
  103 DO 105 I=1,IDO                                                    NCA15170
         DO 104 K=1,L1                                                  NCA15180
            CH(I,K,1) = CC(I,1,K)                                       NCA15190
  104    CONTINUE                                                       NCA15200
  105 CONTINUE                                                          NCA15210
  106 DO 108 J=2,IPPH                                                   NCA15220
         JC = IPP2-J                                                    NCA15230
         J2 = J+J                                                       NCA15240
         DO 107 K=1,L1                                                  NCA15250
            CH(1,K,J) = CC(IDO,J2-2,K)+CC(IDO,J2-2,K)                   NCA15260
            CH(1,K,JC) = CC(1,J2-1,K)+CC(1,J2-1,K)                      NCA15270
  107    CONTINUE                                                       NCA15280
  108 CONTINUE                                                          NCA15290
      IF (IDO .EQ. 1) GO TO 116                                         NCA15300
      IF (NBD .LT. L1) GO TO 112                                        NCA15310
      DO 111 J=2,IPPH                                                   NCA15320
         JC = IPP2-J                                                    NCA15330
         DO 110 K=1,L1                                                  NCA15340
            DO 109 I=3,IDO,2                                            NCA15350
               IC = IDP2-I                                              NCA15360
               CH(I-1,K,J) = CC(I-1,2*J-1,K)+CC(IC-1,2*J-2,K)           NCA15370
               CH(I-1,K,JC) = CC(I-1,2*J-1,K)-CC(IC-1,2*J-2,K)          NCA15380
               CH(I,K,J) = CC(I,2*J-1,K)-CC(IC,2*J-2,K)                 NCA15390
               CH(I,K,JC) = CC(I,2*J-1,K)+CC(IC,2*J-2,K)                NCA15400
  109       CONTINUE                                                    NCA15410
  110    CONTINUE                                                       NCA15420
  111 CONTINUE                                                          NCA15430
      GO TO 116                                                         NCA15440
  112 DO 115 J=2,IPPH                                                   NCA15450
         JC = IPP2-J                                                    NCA15460
         DO 114 I=3,IDO,2                                               NCA15470
            IC = IDP2-I                                                 NCA15480
            DO 113 K=1,L1                                               NCA15490
               CH(I-1,K,J) = CC(I-1,2*J-1,K)+CC(IC-1,2*J-2,K)           NCA15500
               CH(I-1,K,JC) = CC(I-1,2*J-1,K)-CC(IC-1,2*J-2,K)          NCA15510
               CH(I,K,J) = CC(I,2*J-1,K)-CC(IC,2*J-2,K)                 NCA15520
               CH(I,K,JC) = CC(I,2*J-1,K)+CC(IC,2*J-2,K)                NCA15530
  113       CONTINUE                                                    NCA15540
  114    CONTINUE                                                       NCA15550
  115 CONTINUE                                                          NCA15560
  116 AR1 = 1.                                                          NCA15570
      AI1 = 0.                                                          NCA15580
      DO 120 L=2,IPPH                                                   NCA15590
         LC = IPP2-L                                                    NCA15600
         AR1H = DCP*AR1-DSP*AI1                                         NCA15610
         AI1 = DCP*AI1+DSP*AR1                                          NCA15620
         AR1 = AR1H                                                     NCA15630
         DO 117 IK=1,IDL1                                               NCA15640
            C2(IK,L) = CH2(IK,1)+AR1*CH2(IK,2)                          NCA15650
            C2(IK,LC) = AI1*CH2(IK,IP)                                  NCA15660
  117    CONTINUE                                                       NCA15670
         DC2 = AR1                                                      NCA15680
         DS2 = AI1                                                      NCA15690
         AR2 = AR1                                                      NCA15700
         AI2 = AI1                                                      NCA15710
         DO 119 J=3,IPPH                                                NCA15720
            JC = IPP2-J                                                 NCA15730
            AR2H = DC2*AR2-DS2*AI2                                      NCA15740
            AI2 = DC2*AI2+DS2*AR2                                       NCA15750
            AR2 = AR2H                                                  NCA15760
            DO 118 IK=1,IDL1                                            NCA15770
               C2(IK,L) = C2(IK,L)+AR2*CH2(IK,J)                        NCA15780
               C2(IK,LC) = C2(IK,LC)+AI2*CH2(IK,JC)                     NCA15790
  118       CONTINUE                                                    NCA15800
  119    CONTINUE                                                       NCA15810
  120 CONTINUE                                                          NCA15820
      DO 122 J=2,IPPH                                                   NCA15830
         DO 121 IK=1,IDL1                                               NCA15840
            CH2(IK,1) = CH2(IK,1)+CH2(IK,J)                             NCA15850
  121    CONTINUE                                                       NCA15860
  122 CONTINUE                                                          NCA15870
      DO 124 J=2,IPPH                                                   NCA15880
         JC = IPP2-J                                                    NCA15890
         DO 123 K=1,L1                                                  NCA15900
            CH(1,K,J) = C1(1,K,J)-C1(1,K,JC)                            NCA15910
            CH(1,K,JC) = C1(1,K,J)+C1(1,K,JC)                           NCA15920
  123    CONTINUE                                                       NCA15930
  124 CONTINUE                                                          NCA15940
      IF (IDO .EQ. 1) GO TO 132                                         NCA15950
      IF (NBD .LT. L1) GO TO 128                                        NCA15960
      DO 127 J=2,IPPH                                                   NCA15970
         JC = IPP2-J                                                    NCA15980
         DO 126 K=1,L1                                                  NCA15990
            DO 125 I=3,IDO,2                                            NCA16000
               CH(I-1,K,J) = C1(I-1,K,J)-C1(I,K,JC)                     NCA16010
               CH(I-1,K,JC) = C1(I-1,K,J)+C1(I,K,JC)                    NCA16020
               CH(I,K,J) = C1(I,K,J)+C1(I-1,K,JC)                       NCA16030
               CH(I,K,JC) = C1(I,K,J)-C1(I-1,K,JC)                      NCA16040
  125       CONTINUE                                                    NCA16050
  126    CONTINUE                                                       NCA16060
  127 CONTINUE                                                          NCA16070
      GO TO 132                                                         NCA16080
  128 DO 131 J=2,IPPH                                                   NCA16090
         JC = IPP2-J                                                    NCA16100
         DO 130 I=3,IDO,2                                               NCA16110
            DO 129 K=1,L1                                               NCA16120
               CH(I-1,K,J) = C1(I-1,K,J)-C1(I,K,JC)                     NCA16130
               CH(I-1,K,JC) = C1(I-1,K,J)+C1(I,K,JC)                    NCA16140
               CH(I,K,J) = C1(I,K,J)+C1(I-1,K,JC)                       NCA16150
               CH(I,K,JC) = C1(I,K,J)-C1(I-1,K,JC)                      NCA16160
  129       CONTINUE                                                    NCA16170
  130    CONTINUE                                                       NCA16180
  131 CONTINUE                                                          NCA16190
  132 CONTINUE                                                          NCA16200
      IF (IDO .EQ. 1) RETURN                                            NCA16210
      DO 133 IK=1,IDL1                                                  NCA16220
         C2(IK,1) = CH2(IK,1)                                           NCA16230
  133 CONTINUE                                                          NCA16240
      DO 135 J=2,IP                                                     NCA16250
         DO 134 K=1,L1                                                  NCA16260
            C1(1,K,J) = CH(1,K,J)                                       NCA16270
  134    CONTINUE                                                       NCA16280
  135 CONTINUE                                                          NCA16290
      IF (NBD .GT. L1) GO TO 139                                        NCA16300
      IS = -IDO                                                         NCA16310
      DO 138 J=2,IP                                                     NCA16320
         IS = IS+IDO                                                    NCA16330
         IDIJ = IS                                                      NCA16340
         DO 137 I=3,IDO,2                                               NCA16350
            IDIJ = IDIJ+2                                               NCA16360
            DO 136 K=1,L1                                               NCA16370
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)-WA(IDIJ)*CH(I,K,J)  NCA16380
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)+WA(IDIJ)*CH(I-1,K,J)    NCA16390
  136       CONTINUE                                                    NCA16400
  137    CONTINUE                                                       NCA16410
  138 CONTINUE                                                          NCA16420
      GO TO 143                                                         NCA16430
  139 IS = -IDO                                                         NCA16440
      DO 142 J=2,IP                                                     NCA16450
         IS = IS+IDO                                                    NCA16460
         DO 141 K=1,L1                                                  NCA16470
            IDIJ = IS                                                   NCA16480
            DO 140 I=3,IDO,2                                            NCA16490
               IDIJ = IDIJ+2                                            NCA16500
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)-WA(IDIJ)*CH(I,K,J)  NCA16510
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)+WA(IDIJ)*CH(I-1,K,J)    NCA16520
  140       CONTINUE                                                    NCA16530
  141    CONTINUE                                                       NCA16540
  142 CONTINUE                                                          NCA16550
  143 RETURN                                                            NCA16560
      END                                                               NCA16570
      SUBROUTINE RFFTF (N,R,WSAVE)                                      NCA16580
      DIMENSION       R(*)       ,WSAVE(*)                              NCA16590
      IF (N .EQ. 1) RETURN                                              NCA16600
      CALL RFFTF1 (N,R,WSAVE,WSAVE(N+1),WSAVE(2*N+1))                   NCA16610
      RETURN                                                            NCA16620
      END                                                               NCA16630
      SUBROUTINE RFFTF1 (N,C,CH,WA,IFAC)                                NCA16640
      DIMENSION       CH(*)      ,C(*)       ,WA(*)      ,IFAC(*)       NCA16650
      NF = IFAC(2)                                                      NCA16660
      NA = 1                                                            NCA16670
      L2 = N                                                            NCA16680
      IW = N                                                            NCA16690
      DO 111 K1=1,NF                                                    NCA16700
         KH = NF-K1                                                     NCA16710
         IP = IFAC(KH+3)                                                NCA16720
         L1 = L2/IP                                                     NCA16730
         IDO = N/L2                                                     NCA16740
         IDL1 = IDO*L1                                                  NCA16750
         IW = IW-(IP-1)*IDO                                             NCA16760
         NA = 1-NA                                                      NCA16770
         IF (IP .NE. 4) GO TO 102                                       NCA16780
         IX2 = IW+IDO                                                   NCA16790
         IX3 = IX2+IDO                                                  NCA16800
         IF (NA .NE. 0) GO TO 101                                       NCA16810
         CALL RADF4 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3))                NCA16820
         GO TO 110                                                      NCA16830
  101    CALL RADF4 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3))                NCA16840
         GO TO 110                                                      NCA16850
  102    IF (IP .NE. 2) GO TO 104                                       NCA16860
         IF (NA .NE. 0) GO TO 103                                       NCA16870
         CALL RADF2 (IDO,L1,C,CH,WA(IW))                                NCA16880
         GO TO 110                                                      NCA16890
  103    CALL RADF2 (IDO,L1,CH,C,WA(IW))                                NCA16900
         GO TO 110                                                      NCA16910
  104    IF (IP .NE. 3) GO TO 106                                       NCA16920
         IX2 = IW+IDO                                                   NCA16930
         IF (NA .NE. 0) GO TO 105                                       NCA16940
         CALL RADF3 (IDO,L1,C,CH,WA(IW),WA(IX2))                        NCA16950
         GO TO 110                                                      NCA16960
  105    CALL RADF3 (IDO,L1,CH,C,WA(IW),WA(IX2))                        NCA16970
         GO TO 110                                                      NCA16980
  106    IF (IP .NE. 5) GO TO 108                                       NCA16990
         IX2 = IW+IDO                                                   NCA17000
         IX3 = IX2+IDO                                                  NCA17010
         IX4 = IX3+IDO                                                  NCA17020
         IF (NA .NE. 0) GO TO 107                                       NCA17030
         CALL RADF5 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3),WA(IX4))        NCA17040
         GO TO 110                                                      NCA17050
  107    CALL RADF5 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3),WA(IX4))        NCA17060
         GO TO 110                                                      NCA17070
  108    IF (IDO .EQ. 1) NA = 1-NA                                      NCA17080
         IF (NA .NE. 0) GO TO 109                                       NCA17090
         CALL RADFG (IDO,IP,L1,IDL1,C,C,C,CH,CH,WA(IW))                 NCA17100
         NA = 1                                                         NCA17110
         GO TO 110                                                      NCA17120
  109    CALL RADFG (IDO,IP,L1,IDL1,CH,CH,CH,C,C,WA(IW))                NCA17130
         NA = 0                                                         NCA17140
  110    L2 = L1                                                        NCA17150
  111 CONTINUE                                                          NCA17160
      IF (NA .EQ. 1) RETURN                                             NCA17170
      DO 112 I=1,N                                                      NCA17180
         C(I) = CH(I)                                                   NCA17190
  112 CONTINUE                                                          NCA17200
      RETURN                                                            NCA17210
      END                                                               NCA17220
      SUBROUTINE RADF2 (IDO,L1,CC,CH,WA1)                               NCA17230
      DIMENSION       CH(IDO,2,L1)           ,CC(IDO,L1,2)           ,  NCA17240
     1                WA1(*)                                            NCA17250
      DO 101 K=1,L1                                                     NCA17260
         CH(1,1,K) = CC(1,K,1)+CC(1,K,2)                                NCA17270
         CH(IDO,2,K) = CC(1,K,1)-CC(1,K,2)                              NCA17280
  101 CONTINUE                                                          NCA17290
      IF (IDO-2) 107,105,102                                            NCA17300
  102 IDP2 = IDO+2                                                      NCA17310
      DO 104 K=1,L1                                                     NCA17320
         DO 103 I=3,IDO,2                                               NCA17330
            IC = IDP2-I                                                 NCA17340
            TR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)               NCA17350
            TI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)               NCA17360
            CH(I,1,K) = CC(I,K,1)+TI2                                   NCA17370
            CH(IC,2,K) = TI2-CC(I,K,1)                                  NCA17380
            CH(I-1,1,K) = CC(I-1,K,1)+TR2                               NCA17390
            CH(IC-1,2,K) = CC(I-1,K,1)-TR2                              NCA17400
  103    CONTINUE                                                       NCA17410
  104 CONTINUE                                                          NCA17420
      IF (MOD(IDO,2) .EQ. 1) RETURN                                     NCA17430
  105 DO 106 K=1,L1                                                     NCA17440
         CH(1,2,K) = -CC(IDO,K,2)                                       NCA17450
         CH(IDO,1,K) = CC(IDO,K,1)                                      NCA17460
  106 CONTINUE                                                          NCA17470
  107 RETURN                                                            NCA17480
      END                                                               NCA17490
      SUBROUTINE RADF3 (IDO,L1,CC,CH,WA1,WA2)                           NCA17500
      DIMENSION       CH(IDO,3,L1)           ,CC(IDO,L1,3)           ,  NCA17510
     1                WA1(*)     ,WA2(*)                                NCA17520
      DATA TAUR,TAUI /-.5,.866025403784439/                             NCA17530
      DO 101 K=1,L1                                                     NCA17540
         CR2 = CC(1,K,2)+CC(1,K,3)                                      NCA17550
         CH(1,1,K) = CC(1,K,1)+CR2                                      NCA17560
         CH(1,3,K) = TAUI*(CC(1,K,3)-CC(1,K,2))                         NCA17570
         CH(IDO,2,K) = CC(1,K,1)+TAUR*CR2                               NCA17580
  101 CONTINUE                                                          NCA17590
      IF (IDO .EQ. 1) RETURN                                            NCA17600
      IDP2 = IDO+2                                                      NCA17610
      DO 103 K=1,L1                                                     NCA17620
         DO 102 I=3,IDO,2                                               NCA17630
            IC = IDP2-I                                                 NCA17640
            DR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)               NCA17650
            DI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)               NCA17660
            DR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)               NCA17670
            DI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)               NCA17680
            CR2 = DR2+DR3                                               NCA17690
            CI2 = DI2+DI3                                               NCA17700
            CH(I-1,1,K) = CC(I-1,K,1)+CR2                               NCA17710
            CH(I,1,K) = CC(I,K,1)+CI2                                   NCA17720
            TR2 = CC(I-1,K,1)+TAUR*CR2                                  NCA17730
            TI2 = CC(I,K,1)+TAUR*CI2                                    NCA17740
            TR3 = TAUI*(DI2-DI3)                                        NCA17750
            TI3 = TAUI*(DR3-DR2)                                        NCA17760
            CH(I-1,3,K) = TR2+TR3                                       NCA17770
            CH(IC-1,2,K) = TR2-TR3                                      NCA17780
            CH(I,3,K) = TI2+TI3                                         NCA17790
            CH(IC,2,K) = TI3-TI2                                        NCA17800
  102    CONTINUE                                                       NCA17810
  103 CONTINUE                                                          NCA17820
      RETURN                                                            NCA17830
      END                                                               NCA17840
      SUBROUTINE RADF4 (IDO,L1,CC,CH,WA1,WA2,WA3)                       NCA17850
      DIMENSION       CC(IDO,L1,4)           ,CH(IDO,4,L1)           ,  NCA17860
     1                WA1(*)     ,WA2(*)     ,WA3(*)                    NCA17870
      DATA HSQT2 /.7071067811865475/                                    NCA17880
      DO 101 K=1,L1                                                     NCA17890
         TR1 = CC(1,K,2)+CC(1,K,4)                                      NCA17900
         TR2 = CC(1,K,1)+CC(1,K,3)                                      NCA17910
         CH(1,1,K) = TR1+TR2                                            NCA17920
         CH(IDO,4,K) = TR2-TR1                                          NCA17930
         CH(IDO,2,K) = CC(1,K,1)-CC(1,K,3)                              NCA17940
         CH(1,3,K) = CC(1,K,4)-CC(1,K,2)                                NCA17950
  101 CONTINUE                                                          NCA17960
      IF (IDO-2) 107,105,102                                            NCA17970
  102 IDP2 = IDO+2                                                      NCA17980
      DO 104 K=1,L1                                                     NCA17990
         DO 103 I=3,IDO,2                                               NCA18000
            IC = IDP2-I                                                 NCA18010
            CR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)               NCA18020
            CI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)               NCA18030
            CR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)               NCA18040
            CI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)               NCA18050
            CR4 = WA3(I-2)*CC(I-1,K,4)+WA3(I-1)*CC(I,K,4)               NCA18060
            CI4 = WA3(I-2)*CC(I,K,4)-WA3(I-1)*CC(I-1,K,4)               NCA18070
            TR1 = CR2+CR4                                               NCA18080
            TR4 = CR4-CR2                                               NCA18090
            TI1 = CI2+CI4                                               NCA18100
            TI4 = CI2-CI4                                               NCA18110
            TI2 = CC(I,K,1)+CI3                                         NCA18120
            TI3 = CC(I,K,1)-CI3                                         NCA18130
            TR2 = CC(I-1,K,1)+CR3                                       NCA18140
            TR3 = CC(I-1,K,1)-CR3                                       NCA18150
            CH(I-1,1,K) = TR1+TR2                                       NCA18160
            CH(IC-1,4,K) = TR2-TR1                                      NCA18170
            CH(I,1,K) = TI1+TI2                                         NCA18180
            CH(IC,4,K) = TI1-TI2                                        NCA18190
            CH(I-1,3,K) = TI4+TR3                                       NCA18200
            CH(IC-1,2,K) = TR3-TI4                                      NCA18210
            CH(I,3,K) = TR4+TI3                                         NCA18220
            CH(IC,2,K) = TR4-TI3                                        NCA18230
  103    CONTINUE                                                       NCA18240
  104 CONTINUE                                                          NCA18250
      IF (MOD(IDO,2) .EQ. 1) RETURN                                     NCA18260
  105 CONTINUE                                                          NCA18270
      DO 106 K=1,L1                                                     NCA18280
         TI1 = -HSQT2*(CC(IDO,K,2)+CC(IDO,K,4))                         NCA18290
         TR1 = HSQT2*(CC(IDO,K,2)-CC(IDO,K,4))                          NCA18300
         CH(IDO,1,K) = TR1+CC(IDO,K,1)                                  NCA18310
         CH(IDO,3,K) = CC(IDO,K,1)-TR1                                  NCA18320
         CH(1,2,K) = TI1-CC(IDO,K,3)                                    NCA18330
         CH(1,4,K) = TI1+CC(IDO,K,3)                                    NCA18340
  106 CONTINUE                                                          NCA18350
  107 RETURN                                                            NCA18360
      END                                                               NCA18370
      SUBROUTINE RADF5 (IDO,L1,CC,CH,WA1,WA2,WA3,WA4)                   NCA18380
      DIMENSION       CC(IDO,L1,5)           ,CH(IDO,5,L1)           ,  NCA18390
     1                WA1(*)     ,WA2(*)     ,WA3(*)     ,WA4(*)        NCA18400
      DATA TR11,TI11,TR12,TI12 /.309016994374947,.951056516295154,      NCA18410
     1-.809016994374947,.587785252292473/                               NCA18420
      DO 101 K=1,L1                                                     NCA18430
         CR2 = CC(1,K,5)+CC(1,K,2)                                      NCA18440
         CI5 = CC(1,K,5)-CC(1,K,2)                                      NCA18450
         CR3 = CC(1,K,4)+CC(1,K,3)                                      NCA18460
         CI4 = CC(1,K,4)-CC(1,K,3)                                      NCA18470
         CH(1,1,K) = CC(1,K,1)+CR2+CR3                                  NCA18480
         CH(IDO,2,K) = CC(1,K,1)+TR11*CR2+TR12*CR3                      NCA18490
         CH(1,3,K) = TI11*CI5+TI12*CI4                                  NCA18500
         CH(IDO,4,K) = CC(1,K,1)+TR12*CR2+TR11*CR3                      NCA18510
         CH(1,5,K) = TI12*CI5-TI11*CI4                                  NCA18520
  101 CONTINUE                                                          NCA18530
      IF (IDO .EQ. 1) RETURN                                            NCA18540
      IDP2 = IDO+2                                                      NCA18550
      DO 103 K=1,L1                                                     NCA18560
         DO 102 I=3,IDO,2                                               NCA18570
            IC = IDP2-I                                                 NCA18580
            DR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)               NCA18590
            DI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)               NCA18600
            DR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)               NCA18610
            DI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)               NCA18620
            DR4 = WA3(I-2)*CC(I-1,K,4)+WA3(I-1)*CC(I,K,4)               NCA18630
            DI4 = WA3(I-2)*CC(I,K,4)-WA3(I-1)*CC(I-1,K,4)               NCA18640
            DR5 = WA4(I-2)*CC(I-1,K,5)+WA4(I-1)*CC(I,K,5)               NCA18650
            DI5 = WA4(I-2)*CC(I,K,5)-WA4(I-1)*CC(I-1,K,5)               NCA18660
            CR2 = DR2+DR5                                               NCA18670
            CI5 = DR5-DR2                                               NCA18680
            CR5 = DI2-DI5                                               NCA18690
            CI2 = DI2+DI5                                               NCA18700
            CR3 = DR3+DR4                                               NCA18710
            CI4 = DR4-DR3                                               NCA18720
            CR4 = DI3-DI4                                               NCA18730
            CI3 = DI3+DI4                                               NCA18740
            CH(I-1,1,K) = CC(I-1,K,1)+CR2+CR3                           NCA18750
            CH(I,1,K) = CC(I,K,1)+CI2+CI3                               NCA18760
            TR2 = CC(I-1,K,1)+TR11*CR2+TR12*CR3                         NCA18770
            TI2 = CC(I,K,1)+TR11*CI2+TR12*CI3                           NCA18780
            TR3 = CC(I-1,K,1)+TR12*CR2+TR11*CR3                         NCA18790
            TI3 = CC(I,K,1)+TR12*CI2+TR11*CI3                           NCA18800
            TR5 = TI11*CR5+TI12*CR4                                     NCA18810
            TI5 = TI11*CI5+TI12*CI4                                     NCA18820
            TR4 = TI12*CR5-TI11*CR4                                     NCA18830
            TI4 = TI12*CI5-TI11*CI4                                     NCA18840
            CH(I-1,3,K) = TR2+TR5                                       NCA18850
            CH(IC-1,2,K) = TR2-TR5                                      NCA18860
            CH(I,3,K) = TI2+TI5                                         NCA18870
            CH(IC,2,K) = TI5-TI2                                        NCA18880
            CH(I-1,5,K) = TR3+TR4                                       NCA18890
            CH(IC-1,4,K) = TR3-TR4                                      NCA18900
            CH(I,5,K) = TI3+TI4                                         NCA18910
            CH(IC,4,K) = TI4-TI3                                        NCA18920
  102    CONTINUE                                                       NCA18930
  103 CONTINUE                                                          NCA18940
      RETURN                                                            NCA18950
      END                                                               NCA18960
      SUBROUTINE RADFG (IDO,IP,L1,IDL1,CC,C1,C2,CH,CH2,WA)              NCA18970
      DIMENSION       CH(IDO,L1,IP)          ,CC(IDO,IP,L1)          ,  NCA18980
     1                C1(IDO,L1,IP)          ,C2(IDL1,IP),              NCA18990
     2                CH2(IDL1,IP)           ,WA(*)                     NCA19000
      DATA TPI/6.28318530717959/                                        NCA19010
      ARG = TPI/FLOAT(IP)                                               NCA19020
      DCP = COS(ARG)                                                    NCA19030
      DSP = SIN(ARG)                                                    NCA19040
      IPPH = (IP+1)/2                                                   NCA19050
      IPP2 = IP+2                                                       NCA19060
      IDP2 = IDO+2                                                      NCA19070
      NBD = (IDO-1)/2                                                   NCA19080
      IF (IDO .EQ. 1) GO TO 119                                         NCA19090
      DO 101 IK=1,IDL1                                                  NCA19100
         CH2(IK,1) = C2(IK,1)                                           NCA19110
  101 CONTINUE                                                          NCA19120
      DO 103 J=2,IP                                                     NCA19130
         DO 102 K=1,L1                                                  NCA19140
            CH(1,K,J) = C1(1,K,J)                                       NCA19150
  102    CONTINUE                                                       NCA19160
  103 CONTINUE                                                          NCA19170
      IF (NBD .GT. L1) GO TO 107                                        NCA19180
      IS = -IDO                                                         NCA19190
      DO 106 J=2,IP                                                     NCA19200
         IS = IS+IDO                                                    NCA19210
         IDIJ = IS                                                      NCA19220
         DO 105 I=3,IDO,2                                               NCA19230
            IDIJ = IDIJ+2                                               NCA19240
            DO 104 K=1,L1                                               NCA19250
               CH(I-1,K,J) = WA(IDIJ-1)*C1(I-1,K,J)+WA(IDIJ)*C1(I,K,J)  NCA19260
               CH(I,K,J) = WA(IDIJ-1)*C1(I,K,J)-WA(IDIJ)*C1(I-1,K,J)    NCA19270
  104       CONTINUE                                                    NCA19280
  105    CONTINUE                                                       NCA19290
  106 CONTINUE                                                          NCA19300
      GO TO 111                                                         NCA19310
  107 IS = -IDO                                                         NCA19320
      DO 110 J=2,IP                                                     NCA19330
         IS = IS+IDO                                                    NCA19340
         DO 109 K=1,L1                                                  NCA19350
            IDIJ = IS                                                   NCA19360
            DO 108 I=3,IDO,2                                            NCA19370
               IDIJ = IDIJ+2                                            NCA19380
               CH(I-1,K,J) = WA(IDIJ-1)*C1(I-1,K,J)+WA(IDIJ)*C1(I,K,J)  NCA19390
               CH(I,K,J) = WA(IDIJ-1)*C1(I,K,J)-WA(IDIJ)*C1(I-1,K,J)    NCA19400
  108       CONTINUE                                                    NCA19410
  109    CONTINUE                                                       NCA19420
  110 CONTINUE                                                          NCA19430
  111 IF (NBD .LT. L1) GO TO 115                                        NCA19440
      DO 114 J=2,IPPH                                                   NCA19450
         JC = IPP2-J                                                    NCA19460
         DO 113 K=1,L1                                                  NCA19470
            DO 112 I=3,IDO,2                                            NCA19480
               C1(I-1,K,J) = CH(I-1,K,J)+CH(I-1,K,JC)                   NCA19490
               C1(I-1,K,JC) = CH(I,K,J)-CH(I,K,JC)                      NCA19500
               C1(I,K,J) = CH(I,K,J)+CH(I,K,JC)                         NCA19510
               C1(I,K,JC) = CH(I-1,K,JC)-CH(I-1,K,J)                    NCA19520
  112       CONTINUE                                                    NCA19530
  113    CONTINUE                                                       NCA19540
  114 CONTINUE                                                          NCA19550
      GO TO 121                                                         NCA19560
  115 DO 118 J=2,IPPH                                                   NCA19570
         JC = IPP2-J                                                    NCA19580
         DO 117 I=3,IDO,2                                               NCA19590
            DO 116 K=1,L1                                               NCA19600
               C1(I-1,K,J) = CH(I-1,K,J)+CH(I-1,K,JC)                   NCA19610
               C1(I-1,K,JC) = CH(I,K,J)-CH(I,K,JC)                      NCA19620
               C1(I,K,J) = CH(I,K,J)+CH(I,K,JC)                         NCA19630
               C1(I,K,JC) = CH(I-1,K,JC)-CH(I-1,K,J)                    NCA19640
  116       CONTINUE                                                    NCA19650
  117    CONTINUE                                                       NCA19660
  118 CONTINUE                                                          NCA19670
      GO TO 121                                                         NCA19680
  119 DO 120 IK=1,IDL1                                                  NCA19690
         C2(IK,1) = CH2(IK,1)                                           NCA19700
  120 CONTINUE                                                          NCA19710
  121 DO 123 J=2,IPPH                                                   NCA19720
         JC = IPP2-J                                                    NCA19730
         DO 122 K=1,L1                                                  NCA19740
            C1(1,K,J) = CH(1,K,J)+CH(1,K,JC)                            NCA19750
            C1(1,K,JC) = CH(1,K,JC)-CH(1,K,J)                           NCA19760
  122    CONTINUE                                                       NCA19770
  123 CONTINUE                                                          NCA19780
C                                                                       NCA19790
      AR1 = 1.                                                          NCA19800
      AI1 = 0.                                                          NCA19810
      DO 127 L=2,IPPH                                                   NCA19820
         LC = IPP2-L                                                    NCA19830
         AR1H = DCP*AR1-DSP*AI1                                         NCA19840
         AI1 = DCP*AI1+DSP*AR1                                          NCA19850
         AR1 = AR1H                                                     NCA19860
         DO 124 IK=1,IDL1                                               NCA19870
            CH2(IK,L) = C2(IK,1)+AR1*C2(IK,2)                           NCA19880
            CH2(IK,LC) = AI1*C2(IK,IP)                                  NCA19890
  124    CONTINUE                                                       NCA19900
         DC2 = AR1                                                      NCA19910
         DS2 = AI1                                                      NCA19920
         AR2 = AR1                                                      NCA19930
         AI2 = AI1                                                      NCA19940
         DO 126 J=3,IPPH                                                NCA19950
            JC = IPP2-J                                                 NCA19960
            AR2H = DC2*AR2-DS2*AI2                                      NCA19970
            AI2 = DC2*AI2+DS2*AR2                                       NCA19980
            AR2 = AR2H                                                  NCA19990
            DO 125 IK=1,IDL1                                            NCA20000
               CH2(IK,L) = CH2(IK,L)+AR2*C2(IK,J)                       NCA20010
               CH2(IK,LC) = CH2(IK,LC)+AI2*C2(IK,JC)                    NCA20020
  125       CONTINUE                                                    NCA20030
  126    CONTINUE                                                       NCA20040
  127 CONTINUE                                                          NCA20050
      DO 129 J=2,IPPH                                                   NCA20060
         DO 128 IK=1,IDL1                                               NCA20070
            CH2(IK,1) = CH2(IK,1)+C2(IK,J)                              NCA20080
  128    CONTINUE                                                       NCA20090
  129 CONTINUE                                                          NCA20100
C                                                                       NCA20110
      IF (IDO .LT. L1) GO TO 132                                        NCA20120
      DO 131 K=1,L1                                                     NCA20130
         DO 130 I=1,IDO                                                 NCA20140
            CC(I,1,K) = CH(I,K,1)                                       NCA20150
  130    CONTINUE                                                       NCA20160
  131 CONTINUE                                                          NCA20170
      GO TO 135                                                         NCA20180
  132 DO 134 I=1,IDO                                                    NCA20190
         DO 133 K=1,L1                                                  NCA20200
            CC(I,1,K) = CH(I,K,1)                                       NCA20210
  133    CONTINUE                                                       NCA20220
  134 CONTINUE                                                          NCA20230
  135 DO 137 J=2,IPPH                                                   NCA20240
         JC = IPP2-J                                                    NCA20250
         J2 = J+J                                                       NCA20260
         DO 136 K=1,L1                                                  NCA20270
            CC(IDO,J2-2,K) = CH(1,K,J)                                  NCA20280
            CC(1,J2-1,K) = CH(1,K,JC)                                   NCA20290
  136    CONTINUE                                                       NCA20300
  137 CONTINUE                                                          NCA20310
      IF (IDO .EQ. 1) RETURN                                            NCA20320
      IF (NBD .LT. L1) GO TO 141                                        NCA20330
      DO 140 J=2,IPPH                                                   NCA20340
         JC = IPP2-J                                                    NCA20350
         J2 = J+J                                                       NCA20360
         DO 139 K=1,L1                                                  NCA20370
            DO 138 I=3,IDO,2                                            NCA20380
               IC = IDP2-I                                              NCA20390
               CC(I-1,J2-1,K) = CH(I-1,K,J)+CH(I-1,K,JC)                NCA20400
               CC(IC-1,J2-2,K) = CH(I-1,K,J)-CH(I-1,K,JC)               NCA20410
               CC(I,J2-1,K) = CH(I,K,J)+CH(I,K,JC)                      NCA20420
               CC(IC,J2-2,K) = CH(I,K,JC)-CH(I,K,J)                     NCA20430
  138       CONTINUE                                                    NCA20440
  139    CONTINUE                                                       NCA20450
  140 CONTINUE                                                          NCA20460
      RETURN                                                            NCA20470
  141 DO 144 J=2,IPPH                                                   NCA20480
         JC = IPP2-J                                                    NCA20490
         J2 = J+J                                                       NCA20500
         DO 143 I=3,IDO,2                                               NCA20510
            IC = IDP2-I                                                 NCA20520
            DO 142 K=1,L1                                               NCA20530
               CC(I-1,J2-1,K) = CH(I-1,K,J)+CH(I-1,K,JC)                NCA20540
               CC(IC-1,J2-2,K) = CH(I-1,K,J)-CH(I-1,K,JC)               NCA20550
               CC(I,J2-1,K) = CH(I,K,J)+CH(I,K,JC)                      NCA20560
               CC(IC,J2-2,K) = CH(I,K,JC)-CH(I,K,J)                     NCA20570
  142       CONTINUE                                                    NCA20580
  143    CONTINUE                                                       NCA20590
  144 CONTINUE                                                          NCA20600
      RETURN                                                            NCA20610
      END                                                               NCA20620
C                                                                       NCA20630
C                                                                       NCA20640
