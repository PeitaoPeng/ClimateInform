CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC XIN00010
C  SUPPORT ROUTINES FOR INTERPOLATION                                   XIN00020
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC XIN00030
      SUBROUTINE SETLON(BEGLON,LONS,RADLON)                             XIN00040
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                               XIN00050
       REAL        RADLON,BEGLON                                        XIN00060
      DIMENSION RADLON(LONS)                                            XIN00070
      PI = 4.0D+00 * DATAN(1.0D+00)                                     XIN00080
      DRAD = 2.0D+00 * PI / FLOAT(LONS)                                 XIN00090
      RAD = BEGLON                                                      XIN00100
      DO 1000 K=1,LONS                                                  XIN00110
      RADLON(K)=RAD                                                     XIN00120
      RAD=RAD+DRAD                                                      XIN00130
1000  CONTINUE                                                          XIN00140
      RETURN                                                            XIN00150
      END                                                               XIN00160
      SUBROUTINE SETLAT(BEGLAT,LATS,RADLAT)                             XIN00170
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                               XIN00180
       REAL        RADLAT,BEGLAT                                        XIN00190
      DIMENSION RADLAT(LATS)                                            XIN00200
      DRAD = -2.0D+00 * BEGLAT / FLOAT(LATS - 1)                        XIN00210
      RAD = BEGLAT                                                      XIN00220
      DO 1000 K=1,LATS                                                  XIN00230
      RADLAT(K)=RAD                                                     XIN00240
      RAD=RAD+DRAD                                                      XIN00250
1000  CONTINUE                                                          XIN00260
      RETURN                                                            XIN00270
      END                                                               XIN00280
C                                                                       XIN00290
C   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                   XIN00300
C                                                                       XIN00310
      SUBROUTINE GLTTS(KFULL,COLRAD)                                    XIN00320
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                               XIN00330
       REAL        COLRAD                                               XIN00340
      DIMENSION COLRAD(KFULL)                                           XIN00350
      KHALF = KFULL / 2                                                 XIN00360
      EPS=1.0D-12                                                       XIN00370
C     PRINT 101                                                         XIN00380
C101  FORMAT ('0 I   COLAT   COLRAD',                                   XIN00390
C    1 10X, 'ITER  RES')                                                XIN00400
      SI = 1.0D+00                                                      XIN00410
      K2=2*KHALF                                                        XIN00420
      RK2=K2                                                            XIN00430
      SCALE = 2.0D+00/(RK2**2)                                          XIN00440
      K1=K2-1                                                           XIN00450
      PI = DATAN(SI)*4.0D+00                                            XIN00460
      DRADZ = PI / 360.0D+00                                            XIN00470
      RAD = 0.0D+00                                                     XIN00480
      DO 1000 K=1,KHALF                                                 XIN00490
      ITER=0                                                            XIN00500
      DRAD=DRADZ                                                        XIN00510
1     CALL POLE(K2,RAD,P2)                                              XIN00520
2     P1 =P2                                                            XIN00530
      ITER=ITER+1                                                       XIN00540
      RAD=RAD+DRAD                                                      XIN00550
      CALL POLE(K2,RAD,P2)                                              XIN00560
      IF(DSIGN(SI,P1).EQ.DSIGN(SI,P2)) GO TO 2                          XIN00570
      IF(DRAD.LT.EPS)GO TO 3                                            XIN00580
      RAD=RAD-DRAD                                                      XIN00590
      DRAD = DRAD * 0.25D+00                                            XIN00600
      GO TO 1                                                           XIN00610
3     CONTINUE                                                          XIN00620
      COLRAD(K)=0.5D+00 * PI - RAD                                      XIN00630
      COLRAD(KFULL-K+1)=RAD - 0.5 * PI                                  XIN00640
      PHI = RAD * 180D+00 / PI                                          XIN00650
      CALL POLE(K1,RAD,P1)                                              XIN00660
      X = DCOS(RAD)                                                     XIN00670
      CALL POLE(K2,RAD,P1)                                              XIN00680
C     PRINT 102,K,PHI,COLRAD(K),ITER,P1                                 XIN00690
C102  FORMAT(1H ,I2,2X,F6.2,2X,F10.7,2X,I4,2X,D13.7)                    XIN00700
1000  CONTINUE                                                          XIN00710
      IF(MOD(KFULL,2) .EQ. 1) COLRAD(1+KFULL/2)=0.0                     XIN00720
      PRINT 100,KHALF                                                   XIN00730
100   FORMAT(1H ,'SHALOM FROM 0.0 S 0 GLTTS FOR ',I3)                   XIN00740
      RETURN                                                            XIN00750
      END                                                               XIN00760
C                                                                       XIN00770
C   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                XIN00780
C                                                                       XIN00790
      SUBROUTINE POLE(N,RAD,P)                                          XIN00800
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                               XIN00810
      X = DCOS(RAD)                                                     XIN00820
      Y1 = 1.0D+00                                                      XIN00830
      Y2=X                                                              XIN00840
      DO 1 I=2,N                                                        XIN00850
      G=X*Y2                                                            XIN00860
      Y3=G-Y1+G-(G-Y1)/DFLOAT(I)                                        XIN00870
      Y1=Y2                                                             XIN00880
      Y2=Y3                                                             XIN00890
1     CONTINUE                                                          XIN00900
      P=Y3                                                              XIN00910
      RETURN                                                            XIN00920
      END                                                               XIN00930
      SUBROUTINE POLAVG(FIELD,LONS,LATS)                                XIN00940
      DIMENSION FIELD(LONS,LATS)                                        XIN00950
      TOT1 = 0.0                                                        XIN00960
      TOT2 = 0.0                                                        XIN00970
      DO 1000 I = 1 , LONS                                              XIN00980
      TOT1 = TOT1 + FIELD(I,1)                                          XIN00990
      TOT2 = TOT2 + FIELD(I,LATS)                                       XIN01000
 1000 CONTINUE                                                          XIN01010
      TOT1 = TOT1 / FLOAT(LONS)                                         XIN01020
      TOT2 = TOT2 / FLOAT(LONS)                                         XIN01030
      DO 2000 I = 1 , LONS                                              XIN01040
      FIELD(I,1) = TOT1                                                 XIN01050
      FIELD(I,LATS) = TOT2                                              XIN01060
 2000 CONTINUE                                                          XIN01070
      RETURN                                                            XIN01080
      END                                                               XIN01090
C                                                                       XIN01100
C  *****************************************************                XIN01110
C                                                                       XIN01120
      SUBROUTINE TERPLT(FIELDA,LONA,LATA,UNDEF,FIELDB,LONB,LATB,        XIN01130
     A                  TRPLON,LONTRP,NLNTRP,TRPLAT,LATTRP,NLTTRP)      XIN01140
      DIMENSION FIELDA(LONA,LATA),FIELDB(LONB,LATB),                    XIN01150
     A          TRPLON((LONA-1)/LONB+3,LONB),                           XIN01160
     B          TRPLAT((LATA-1)/LATB+3,LATB),                           XIN01170
     C          LONTRP((LONA-1)/LONB+3,LONB),NLNTRP(LONB),              XIN01180
     D          LATTRP((LATA-1)/LATB+3,LATB),NLTTRP(LATB)               XIN01190
      DO 1000 J = 1 , LATB                                              XIN01200
      DO 1000 I = 1 , LONB                                              XIN01210
      TOT = 0.0                                                         XIN01220
      WTTOT = 1.0                                                       XIN01230
      DO 500 JT = 1 , NLTTRP(J)                                         XIN01240
      DO 500 IT = 1 , NLNTRP(I)                                         XIN01250
      IA=LONTRP(IT,I)                                                   XIN01260
      JA=LATTRP(JT,J)                                                   XIN01270
      UNDEF=999.
      IF(IA.GT.LONA.OR.IA.LT.1.OR.JA.GT.LATA.OR.JA.LT.1)GO TO 2000      XIN01280
      IF(FIELDA(LONTRP(IT,I),LATTRP(JT,J)) .EQ. UNDEF) GO TO 250        XIN01290
      TOT = TOT + TRPLON(IT,I) * TRPLAT(JT,J) *                         XIN01300
     A            FIELDA(LONTRP(IT,I),LATTRP(JT,J))                     XIN01310
      GO TO 500                                                         XIN01320
  250 WTTOT = WTTOT - TRPLON(IT,I) * TRPLAT(JT,J)                       XIN01330
  500 CONTINUE                                                          XIN01340
      IF(WTTOT.LT.1.0E-4)THEN                                           XIN01350
      FIELDB(I,J)=UNDEF                                                 XIN01360
      ELSE                                                              XIN01370
      FIELDB(I,J) = TOT / WTTOT                                         XIN01380
      END IF                                                            XIN01390
 1000 CONTINUE                                                          XIN01400
      RETURN                                                            XIN01410
 2000 WRITE(3,3000)I,J,IT,JT,IA,JA                                      XIN01420
 3000 FORMAT(' OUT OF BOUND SUBSCRIPT AT I=',I4,' J=',I4,' IT=',I4,     XIN01430
     *' JT=',I4,' IA=',I4,' JA=',I4)                                    XIN01440
      STOP 2000                                                         XIN01450
      END                                                               XIN01460
C                                                                       XIN01470
C  ******************************************************               XIN01480
C                                                                       XIN01490
      SUBROUTINE TERPWT(ALONP,ALATP,LONA,LATA,ALONE,ALATE,              XIN01500
     A                  BLONP,BLATP,LONB,LATB,BLONE,BLATE,              XIN01510
     B                  TRPLON,LONTRP,NLNTRP,TRPLAT,LATTRP,NLTTRP)      XIN01520
      DIMENSION ALONP(LONA),ALATP(LATA),                                XIN01530
     A          ALONE(LONA+1),ALATE(LATA+1),                            XIN01540
     B          BLONP(LONB),BLATP(LATB),                                XIN01550
     C          BLONE(LONB+1),BLATE(LATB+1),                            XIN01560
     D          TRPLON((LONA-1)/LONB+3,LONB),                           XIN01570
     E          TRPLAT((LATA-1)/LATB+3,LATB),                           XIN01580
     F          LONTRP((LONA-1)/LONB+3,LONB),NLNTRP(LONB),              XIN01590
     G          LATTRP((LATA-1)/LATB+3,LATB),NLTTRP(LATB)               XIN01600
      PI = 4.0 * ATAN(1.0)                                              XIN01610
      ALONE(1) = 0.5 * (ALONP(1) + ALONP(LONA))                         XIN01620
     A                                - SIGN(PI,ALONP(LONA) - ALONP(1)) XIN01630
      DO 10 LON = 2 , LONA                                              XIN01640
      ALONE(LON) = 0.5 * (ALONP(LON-1) + ALONP(LON))                    XIN01650
   10 CONTINUE                                                          XIN01660
      ALONE(LONA+1) = ALONE(1) + 2.0 * SIGN(PI,ALONP(LONA) - ALONP(1))  XIN01670
      BLONE(1) = 0.5 * (BLONP(1) + BLONP(LONB))                         XIN01680
     A                                - SIGN(PI,BLONP(LONB) - BLONP(1)) XIN01690
      DO 20 LON = 2 , LONB                                              XIN01700
      BLONE(LON) = 0.5 * (BLONP(LON-1) + BLONP(LON))                    XIN01710
   20 CONTINUE                                                          XIN01720
      BLONE(LONB+1) = BLONE(1) + 2.0 * SIGN(PI,BLONP(LONB) - BLONP(1))  XIN01730
      ALATE(1) = SIGN(0.5 * PI,ALATP(1))                                XIN01740
      DO 30 LAT = 2 , LATA                                              XIN01750
      ALATE(LAT) = 0.5 * (ALATP(LAT-1) + ALATP(LAT))                    XIN01760
   30 CONTINUE                                                          XIN01770
      ALATE(LATA+1) = SIGN(0.5 * PI,ALATP(LATA))                        XIN01780
      BLATE(1) = SIGN(0.5 * PI,BLATP(1))                                XIN01790
      DO 40 LAT = 2 , LATB                                              XIN01800
      BLATE(LAT) = 0.5 * (BLATP(LAT-1) + BLATP(LAT))                    XIN01810
   40 CONTINUE                                                          XIN01820
      BLATE(LATB+1) = SIGN(0.5 * PI,BLATP(LATB))                        XIN01830
      IF(ALATP(1) .LT. ALATP(LATA)) GO TO 50                            XIN01840
      LATAIN = -1                                                       XIN01850
      LATABG = LATA + 1                                                 XIN01860
      LATAEN = 2                                                        XIN01870
      GO TO 60                                                          XIN01880
   50 LATAIN = 1                                                        XIN01890
      LATABG = 1                                                        XIN01900
      LATAEN = LATA                                                     XIN01910
   60 IF(BLATP(1) .LT. BLATP(LATB)) GO TO 70                            XIN01920
      LATBIN = -1                                                       XIN01930
      LATBBG = LATB + 1                                                 XIN01940
      LATBEN = 2                                                        XIN01950
      GO TO 80                                                          XIN01960
   70 LATBIN = 1                                                        XIN01970
      LATBBG = 1                                                        XIN01980
      LATBEN = LATB                                                     XIN01990
   80 IF(ALONP(1) .LT. ALONP(LONA)) GO TO 90                            XIN02000
      LONAIN = -1                                                       XIN02010
      LONABG = LONA + 1                                                 XIN02020
      LONAEN = 2                                                        XIN02030
      GO TO 100                                                         XIN02040
   90 LONAIN = 1                                                        XIN02050
      LONABG = 1                                                        XIN02060
      LONAEN = LONA                                                     XIN02070
  100 IF(BLONP(1) .LT. BLONP(LONB)) GO TO 110                           XIN02080
      LONBIN = -1                                                       XIN02090
      LONBBG = LONB + 1                                                 XIN02100
      LONBEN = 2                                                        XIN02110
      GO TO 120                                                         XIN02120
  110 LONBIN = 1                                                        XIN02130
      LONBBG = 1                                                        XIN02140
      LONBEN = LONB                                                     XIN02150
  120 LAT1 = LATABG                                                     XIN02160
      DO 200 LAT2 = LATBBG , LATBEN , LATBIN                            XIN02170
      IC = 0                                                            XIN02180
      WIDLAT = SIN(BLATE(LAT2+LATBIN)) - SIN(BLATE(LAT2))               XIN02190
  125 IF(ALATE(LAT1) .LE. BLATE(LAT2) .AND.                             XIN02200
     A ALATE(LAT1+LATAIN) .GE. BLATE(LAT2+LATBIN)) GO TO 150            XIN02210
      IF(ALATE(LAT1+LATAIN) .GT. BLATE(LAT2) .AND.                      XIN02220
     A ALATE(LAT1+LATAIN) .LE. BLATE(LAT2+LATBIN)) GO TO 140            XIN02230
      IF(ALATE(LAT1) .LT. BLATE(LAT2+LATBIN) .AND.                      XIN02240
     A ALATE(LAT1) .GE. BLATE(LAT2)) GO TO 130                          XIN02250
      GO TO 180                                                         XIN02260
  130 XLAT1 = AMIN1(ALATE(LAT1+LATAIN),BLATE(LAT2+LATBIN))              XIN02270
      XLAT2 = ALATE(LAT1)                                               XIN02280
      GO TO 160                                                         XIN02290
  140 XLAT1 = ALATE(LAT1+LATAIN)                                        XIN02300
      XLAT2 = AMAX1(ALATE(LAT1),BLATE(LAT2))                            XIN02310
      GO TO 160                                                         XIN02320
  150 XLAT1 = BLATE(LAT2+LATBIN)                                        XIN02330
      XLAT2 = BLATE(LAT2)                                               XIN02340
  160 IC = IC + 1                                                       XIN02350
      LATTB2 = LAT2                                                     XIN02360
      IF(LATBIN .EQ. -1) LATTB2 = LAT2 - 1                              XIN02370
      TRPLAT(IC,LATTB2) = (SIN(XLAT1) - SIN(XLAT2)) / WIDLAT            XIN02380
      LATTB1 = LAT1                                                     XIN02390
      IF(LATAIN .EQ. -1) LATTB1 = LAT1 - 1                              XIN02400
      LATTRP(IC,LATTB2) = LATTB1                                        XIN02410
      IF(XLAT1 .EQ. BLATE(LAT2+LATBIN)) GO TO 190                       XIN02420
  180 LAT1 = LAT1 + LATAIN                                              XIN02430
      GO TO 125                                                         XIN02440
  190 NLTTRP(LATTB2) = IC                                               XIN02450
  200 CONTINUE                                                          XIN02460
      LON1 = LONABG                                                     XIN02470
      DO 300 LON2 = LONBBG , LONBEN , LONBIN                            XIN02480
      IC = 0                                                            XIN02490
      WIDLON = BLONE(LON2+LONBIN) - BLONE(LON2)                         XIN02500
  225 IF(ALONE(LON1) .LE. BLONE(LON2) .AND.                             XIN02510
     A ALONE(LON1+LONAIN) .GE. BLONE(LON2+LONBIN)) GO TO 250            XIN02520
      IF(ALONE(LON1) + 2.0 * PI .LE. BLONE(LON2) .AND.                  XIN02530
     A ALONE(LON1+LONAIN) + 2.0 * PI .GE. BLONE(LON2+LONBIN)) GO TO 250 XIN02540
      IF(ALONE(LON1) - 2.0 * PI .LE. BLONE(LON2) .AND.                  XIN02550
     A ALONE(LON1+LONAIN) - 2.0 * PI .GE. BLONE(LON2+LONBIN)) GO TO 250 XIN02560
      IF(ALONE(LON1+LONAIN) .GT. BLONE(LON2) .AND.                      XIN02570
     A ALONE(LON1+LONAIN) .LE. BLONE(LON2+LONBIN)) GO TO 240            XIN02580
      IF(ALONE(LON1+LONAIN) + 2.0 * PI .GT. BLONE(LON2) .AND.           XIN02590
     A ALONE(LON1+LONAIN) + 2.0 * PI .LE. BLONE(LON2+LONBIN)) GO TO 243 XIN02600
      IF(ALONE(LON1+LONAIN) - 2.0 * PI .GT. BLONE(LON2) .AND.           XIN02610
     A ALONE(LON1+LONAIN) - 2.0 * PI .LE. BLONE(LON2+LONBIN)) GO TO 247 XIN02620
      IF(IC .EQ. 0) GO TO 280                                           XIN02630
      IF(ALONE(LON1) .LT. BLONE(LON2+LONBIN) .AND.                      XIN02640
     A ALONE(LON1) .GE. BLONE(LON2)) GO TO 230                          XIN02650
      IF(ALONE(LON1) + 2.0 * PI .LT. BLONE(LON2+LONBIN) .AND.           XIN02660
     A ALONE(LON1) + 2.0 * PI .GE. BLONE(LON2)) GO TO 233               XIN02670
      IF(ALONE(LON1) - 2.0 * PI .LT. BLONE(LON2+LONBIN) .AND.           XIN02680
     A ALONE(LON1) - 2.0 * PI .GE. BLONE(LON2)) GO TO 237               XIN02690
      GO TO 280                                                         XIN02700
  230 XLON1 = AMIN1(ALONE(LON1+LONAIN),BLONE(LON2+LONBIN))              XIN02710
      XLON2 = ALONE(LON1)                                               XIN02720
      GO TO 260                                                         XIN02730
  233 XLON1 = AMIN1(ALONE(LON1+LONAIN) + 2.0 * PI,BLONE(LON2+LONBIN))   XIN02740
      XLON2 = ALONE(LON1) + 2.0 * PI                                    XIN02750
      GO TO 260                                                         XIN02760
  237 XLON1 = AMIN1(ALONE(LON1+LONAIN) - 2.0 * PI,BLONE(LON2+LONBIN))   XIN02770
      XLON2 = ALONE(LON1) - 2.0 * PI                                    XIN02780
      GO TO 260                                                         XIN02790
  240 IF(IC .EQ. 0 .AND. ALONE(LON1) .LT. BLONE(LON2+LONBIN)            XIN02800
     A .AND. ALONE(LON1) .GT. BLONE(LON2)) GO TO 280                    XIN02810
      XLON1 = ALONE(LON1+LONAIN)                                        XIN02820
      XLON2 = AMAX1(ALONE(LON1),BLONE(LON2))                            XIN02830
      GO TO 260                                                         XIN02840
  243 IF(IC .EQ. 0 .AND. ALONE(LON1) + 2.0 * PI .LT. BLONE(LON2+LONBIN) XIN02850
     A .AND. ALONE(LON1) + 2.0 * PI .GT. BLONE(LON2)) GO TO 280         XIN02860
      XLON1 = ALONE(LON1+LONAIN) + 2.0 * PI                             XIN02870
      XLON2 = AMAX1(ALONE(LON1) + 2.0 * PI,BLONE(LON2))                 XIN02880
      GO TO 260                                                         XIN02890
  247 IF(IC .EQ. 0 .AND. ALONE(LON1) - 2.0 * PI .LT. BLONE(LON2+LONBIN) XIN02900
     A .AND. ALONE(LON1) - 2.0 * PI .GT. BLONE(LON2)) GO TO 280         XIN02910
      XLON1 = ALONE(LON1+LONAIN) - 2.0 * PI                             XIN02920
      XLON2 = AMAX1(ALONE(LON1) - 2.0 * PI,BLONE(LON2))                 XIN02930
      GO TO 260                                                         XIN02940
  250 XLON1 = BLONE(LON2+LONBIN)                                        XIN02950
      XLON2 = BLONE(LON2)                                               XIN02960
  260 IC = IC + 1                                                       XIN02970
      LONTB2 = LON2                                                     XIN02980
      IF(LONBIN .EQ. -1) LONTB2 = LON2 - 1                              XIN02990
      TRPLON(IC,LONTB2) = (XLON1 - XLON2) / WIDLON                      XIN03000
      LONTB1 = LON1                                                     XIN03010
      IF(LONAIN .EQ. -1) LONTB1 = LON1 - 1                              XIN03020
      LONTRP(IC,LONTB2) = LONTB1                                        XIN03030
      IF(XLON1 .EQ. BLONE(LON2+LONBIN)) GO TO 290                       XIN03040
  280 LON1 = LON1 + LONAIN                                              XIN03050
      IF(LONAIN .EQ. -1 .AND. LON1 .LT. LONAEN) LON1 = LONABG           XIN03060
      IF(LONAIN .EQ. 1 .AND. LON1 .GT. LONAEN) LON1 = LONABG            XIN03070
      GO TO 225                                                         XIN03080
  290 NLNTRP(LONTB2) = IC                                               XIN03090
  300 CONTINUE                                                          XIN03100
      RETURN                                                            XIN03110
      END                                                               XIN03120
