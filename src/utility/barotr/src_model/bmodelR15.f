      PROGRAM   WAVY 
      PARAMETER (IR=15, IX=64, IY=40, IY2=IY/2)                         ZON00020
      PARAMETER (IRS=(IR+1)*(IR+1)-1 )                                  ZON00030
      PARAMETER (IRS2=2*IRS)                                            ZON00030
C     ----------------------------------------------------------------- ZON00040
C                                                                       ZON00070
      REAL  A1 (IX,IY),  A2 (IX,IY),  A3 (IX,IY),A4 (IX,IY),VOR (IX,IY) ZON00080
      REAL  A1C(IX,IY),  A2C(IX,IY),  A3C(IX,IY),A4C(IX,IY),VORC(IX,IY) ZON00090
      REAL DIVC(IX,IY),UCHIC(IX,IY),VCHIC(IX,IY)                        ZON00100
      REAL FRC1(IX,IY),FRC2(IX,IY),FRC3(IX,IY)                          ZON00100
      REAL DIV (IX,IY),UCHI (IX,IY),VCHI (IX,IY),AUG(IX,IY)             ZON00110
C                                                                       ZON00120
      REAL     FORBLK(IX,IY),FORTRA(IX,IY)                              ZON00130
      REAL     BTPG(101), AX(101),BX(101),CX(101),XX(101)               ZON00140
      COMMON/GAUSS/RADG(IY),GWGT(IY)
      COMMON/POLY1/PLEG(IR+1,IR+1,IY),DPLEG(IR+1,IR+1,IY)
      real*8    COLRAD(IY2),WGT(IY2),WGTCS(IY2),RCS2(IY2)
      REAL   GLAT(IY),CGTH(IY),EPSML(IR+2,IR+1),EPSML1(IR+2,IR+1)       ZON00160
      REAL  ARCTH2(IY),FCOR(IY)
      REAL  FORBLK2(IX,IY),WVSC1(IX,IY),WVSC2(IX,IY)                    ZON00180
      REAL  WVSC3(IX,IY)                                                ZON00180
      REAL  FORBLK3(IX,IY),FORBLK4(IX,IY),FORBLK5(IX,IY)                ZON00180
      REAL  FORBLK6(IX,IY),FORBLK7(IX,IY),FORBLK8(IX,IY)                ZON00180
      REAL  FORBLK9(IX,IY),FORBLK10(IX,IY)                              ZON00180
      REAL  ABSVOR(IX,IY)                                               ZON00340
      REAL  XFS(IX,IY), YFS(IX,IY)                                      ZON00340
C                                                                       ZON00190
      REAL  CDIVG(IX,IY),CPSIG(IX,IY)                                   ZON00180
      REAL  ADIVG(IX,IY),APSIG(IX,IY)                                   ZON00180
      REAL  EDIVG(IX,IY),EPSIG(IX,IY)                                   ZON00180
C
      COMPLEX    CONS                                                   ZON00200
      COMPLEX    CFR(IRS),CROW(IRS)                                     ZON00210
C                                                                       ZON00240
      COMPLEX CSTRMF3(IR+2,IR+1,1), CDIV3(IR+2,IR+1,1)                  ZON00340
      COMPLEX CSTRMF4(IR+2,IR+1,1), CDIV4(IR+2,IR+1,1)                  ZON00340
      COMPLEX CSTRMF5(IR+2,IR+1,1), CDIV5(IR+2,IR+1,1)                  ZON00340
C
      REAL     RFOR4(IRS2)                                              ZON00250
C
      REAL     MTR2(IRS2,IRS2), RFOR2(IRS2), RSOL(IRS2)                 ZON00260
      DIMENSION INDX(IRS2)                                              ZON00260
C                                                                       ZON00270
      COMPLEX     ST(IR+1,IR+1,3),    DUM(IR+2,IR+1,1)                  ZON00280
      COMPLEX CSPFOR (IR+2,IR+1,1),     C(IR+2,IR+1,1)                  ZON00290
      COMPLEX ASPFOR (IR+2,IR+1,1)                                      ZON00290
      COMPLEX     UU(IR+2,IR+1,1),     VV(IR+2,IR+1,1)                  ZON00300
      COMPLEX ZTLMDA(IR+2,IR+1,1), CZTTHT(IR+2,IR+1,1)                  ZON00310
      COMPLEX CSTRMF(IR+2,IR+1,1), ASTRMF(IR+2,IR+1,1)                  ZON00320
      COMPLEX   CDIV(IR+2,IR+1,1),   ADIV(IR+2,IR+1,1)                  ZON00330
      COMPLEX CTRANS(IR+2,IR+1,1), ATRANS(IR+2,IR+1,1)                  ZON00340
      COMPLEX    UUU(IR+2,IR+1,1),    VVV(IR+2,IR+1,1)                  ZON00350
      COMPLEX     VP(IR+2,IR+1,1)                                       ZON00360
      COMPLEX   DUM4(IR+2,IR+1,1)                                       ZON00360
C                                                                       ZON00370
      COMPLEX CZTLMD(IR+2,IR+1)                                         ZON00380
      COMPLEX    CVV(IR+2,IR+1),     CDUM(IR+2,IR+1)                    ZON00390
      COMPLEX CCZT1 (IR+2,IR+1),    CUU1 (IR+2,IR+1)                    ZON00400
      COMPLEX CCZT2A(IR+2,IR+1),    CUU2A(IR+2,IR+1)                    ZON00410
      COMPLEX CCZT2B(IR+2,IR+1),    CUU2B(IR+2,IR+1)                    ZON00420
      COMPLEX CCZT3 (IR+2,IR+1),    CUU3 (IR+2,IR+1)                    ZON00430
      REAL    CRF(IR+2,IR+1)   ,    CDUM4(IR+2,IR+1)                    ZON00440
C-----------------------------------------------------
      open(unit=20,form='unformatted',access='direct',recl=4*ix*iy)
      open(unit=21,form='unformatted',access='direct',recl=4*ix*iy)
      open(unit=80,form='unformatted',access='direct',recl=4*ix*iy)
      open(unit=30,form='unformatted',access='direct',recl=4*ix*iy)
      open(unit=34,form='unformatted',recl=4*IRS2*IRS2)
         XNU  = 0.5
C  XNU=1 means beda=2E16, also check subroutine TTFORCE
      NDAY=3.5
      RF  = 1./(NDAY*86400.)                 
c     RF  = 1./(10*86400.)                 
C                                                                       ZON00610
C     ---------------------------------------------------------------   ZON00620
C     MODEL OPTIONS SETTINGS                                            ZON00630
C                                                                       ZON00660
C                                                                       ZON00700
C     MATGEN=1  CALCULATE THE ZONALLY ASYMMETRIC SOLUTION MATRIX        ZON00740
C           =2  DO NOT DO THE ABOVE                                     ZON00750
C                                                                       ZON00760
C     IBASIC=1  use readin  basic state                                 ZON00740
C           =2  use zonal mean basic state                              ZON00750
C                                                                       ZON00760
C     IEDD  =1  CALCULATE THE EDDY ANOMALOUS SOLUTION                   ZON00770
C           =2  CALCULATE THE (EDDY + ZONALMEAN) ANOMALOUS SOLUTION     ZON00780
C                                                                       ZON00790
C     JBEG  =   THE FIRST GAUSSIAN GRIDPNT AT WHICH ANOM DIV IS NONZERO ZON00800
C     JEND  =   THE LAST  GAUSSIAN GRIDPNT AT WHICH ANOM DIV IS NONZERO ZON00810
C     JNOR  =   THE GAUSSIAN GRIDPNT north of it ANOM DIV IS NONZERO    ZON00810
C     NS1   =1  have stretching forcing
C           =0  no above
C     NS2   =1  have vor advection forcing
C           =0  no above
C     NS3   =1  have transient forcing
C           =0  no above
C     NS4   =1  have nondivgent forcing
C           =0  no above
C     NDIV  =1  divergent anomaly model
C           =0  non-divergent anomaly model
C     INTRS =1  use read in transient frc
C           =0  retrieved trs
C     ---------------------------------------------------------------   ZON00820
      MATGEN=1                                                          ZON00860
      IBASIC=1                                                          ZON00860
      IEDD  =1                                                          ZON00870
      JBEG  =17                                                         ZON00880
      JEND  =24                                                         ZON00890
c     JBEG  =19 !1 is most north and 40 is most south                   ZON00880
c     JEND  =22                                                         ZON00890
c     JBEG  =1                                                          ZON00880
c     JEND  =40                                                         ZON00890
c     IBEG  =1                                                          ZON00880
c     IEND  =64                                                         ZON00890
      IBEG  =15                                                         ZON00880
      IEND  =26                                                         ZON00890
      JNOR  =1                                                          ZON00890
      NS1   =1
      NS2   =1
      NS3   =0
      NS4   =1
      NDIV  =1
      INTRS =0
c
      irec=0
C                                                                       ZON00910
C     -------------------------------------------------------------     ZON01240
      PI=ACOS(-1.0)
      OMG =7.272E-5                                                     ZON00510
      AR  =6.37E6                                                       ZON00520
      AR2 =AR*AR                                                        ZON00530
      AR4 =AR2*AR2                                                      ZON00540
      TWOMGR=2.*OMG/AR                                                  ZON00550
      CONS=(0.,1.)                                                      ZON00560
C     -----------------------------------------------------
      CALL GLATS(IY2,COLRAD,WGT,WGTCS,RCS2)
      DO K=1,IY2 
      RADG(K)=PI/2.0 - real(COLRAD(K))
      RADG(IY-K+1)=-RADG(K)
      GWGT(K)=real(WGT(K))
      GWGT(IY-K+1)=+GWGT(K)
      END DO 
      DO JG=1,IY
      CALL GENPNME15(RADG(JG),PLEG(1,1,JG),DPLEG(1,1,JG))
      END DO
C     ------------------------------------------------------            ZON01460
      DO 10 J=1,IY2                                                     ZON01490
      GLAT(J)=RADG(J)                                                   ZON01500
      JA=IY2*2-J+1                                                      ZON01510
10    GLAT(JA)=-GLAT(J)                                                 ZON01520
      DO 20 J=1,IY2*2                                                   ZON01530
      CGTH(J)= COS(GLAT(J))                                             ZON01540
      ARCTH2(J)= 1./(AR*CGTH(J)*CGTH(J))                                ZON01550
      FCOR(J)= 2.*OMG*SIN(GLAT(J))                                      ZON01560
      CGLAT=GLAT(J)*180./PI                                             ZON01570
      WRITE (*,100) CGLAT, GLAT(J), CGTH(J), FCOR(J), J                 ZON01580
20    CONTINUE                                                          ZON01600
100   FORMAT (4F12.5, I20)                                              ZON01610
C                                                                       ZON01620
C     --------------------------------------------------------------    ZON01630
C     CALCULATING EPSML'S USED IN THE RECURSSION RELATIONS FOR PLM'S    ZON01640
      DO 3700 M1=1,IR+1                                                 ZON01650
       M=M1-1                                                           ZON01660
      DO 3750 L1=1,IR+2                                                 ZON01670
       L=M+L1-1                                                         ZON01680
       EPSML(L1,M1)= SQRT( ( L*L       -M*M)*1./(4.* L*L       -1.) )   ZON01690
3750  EPSML1(L1,M1)= SQRT( ((L+1)*(L+1)-M*M)*1./(4.*(L+1)*(L+1)-1.) )   ZON01700
3700  continue
C     ------------------------------------------------------------------ZON01730
C     read in clim and anomaly (clim+anom) psi and div
C     ------------------------------------------------------------------
      irec=irec+1
      read(20,rec=irec)FORBLK
      CALL norsou(FORBLK,CPSIG,IX,IY)
      irec=irec+1
      read(20,rec=irec)FORBLK
      CALL norsou(FORBLK,CDIVG,IX,IY)
      irec=irec+1
      read(20,rec=irec)FORBLK
      CALL norsou(FORBLK,EPSIG,IX,IY)  ! EPSIG: anomaly year total field
      irec=irec+1
      read(20,rec=irec)FORBLK
      CALL norsou(FORBLK,EDIVG,IX,IY)  ! EDIVG: anomaly year total field
c     read(21,rec=1)FORBLK
c     CALL norsou(FORBLK,EDIVG,IX,IY)  ! EDIVG: anomaly year total field
C----------------------------------------------
C.....have input clim psi and div
C----------------------------------------------
      CALL TRANSFORM ( 1, CPSIG ,CSTRMF)                                ZON02720
      CALL TRANSFORM ( 1, CDIVG ,CDIV)                                  ZON02720
C================================================================
C.....have anom psi and div
C================================================================
      do j =1,IY
      do i =1,IX
      APSIG(i,j)=EPSIG(i,j)-CPSIG(i,j)
      ADIVG(i,j)=EDIVG(i,j)-CDIVG(i,j)
c     if(EDIVG(i,j).gt.0) then
c     ADIVG(i,j)=EDIVG(i,j)*0.000001
c     else
c     ADIVG(i,j)=0.
c     endif
c     ADIVG(i,j)=EDIVG(i,j)              !goga-toga div
      end do
      end do
C --------------------------------
C   if need to prescibe idealized div
C --------------------------------
c     CALL IDEAFRC(FORBLK2,34,20,2.,1.,-2.)
c     CALL IDEAFRC(FORBLK3,20,21,2.,1.,3.)
c simulate dec2013
c     CALL IDEAFRC(FORBLK2,30,21,4.,2.,5.)
c     CALL IDEAFRC(FORBLK3,34,20,6.,1.,-2.)
c     CALL IDEAFRC(FORBLK3,38,20,6.,1.,-2.)
c     CALL IDEAFRC(FORBLK4,12,22,3.,2.,3.)
      do j =1,IY
      do i =1,IX
c     ADIVG(i,j)=FORBLK2(I,J)+FORBLK3(I,J)+0*FORBLK4(I,J)
      end do
      end do
C
      do  M1=1,IR+1
      do  L1=1,IR+2
         ASTRMF(L1,M1,1) = 0.
         ADIV(L1,M1,1) = 0.
      end do
      end do
      CALL TRANSFORM ( 1, APSIG ,ASTRMF)                                ZON02720
C-------------------------------------------------------------
C   SETTING THE ANOM. DIV=0.0 EVERYWHERE EXCEPTING SOME PLACES          ZON02710
C--------------------------------------------------------------
      DO J=1,IY                                                         ZON02730
      DO I=1,IX                                                         ZON02740
        IF ((J.LT.JBEG) .OR. (J.GT.JEND))    ADIVG(I,J)=0.0             ZON02750
        IF ((I.LT.IBEG) .OR. (I.GT.IEND))    ADIVG(I,J)=0.0             ZON02750
      END DO
      END DO
      CALL TRANSFORM ( 1, ADIVG ,ADIV)                                  ZON02720
C=============================================================
C      calculate transient forcing anomaly
C==============================================================
      do  M1=1,IR+1
      do  L1=1,IR+2
         ATRANS(L1,M1,1) =0.
      end do
      end do
      beta=1.5  ! beda=2 for echam; =1.5 for b9x;
      NNDAY=beta*NDAY
      CALL TRANSFORM(1, EPSIG,CSTRMF3)
      CALL TRANSFORM(1, EDIVG,CDIV3)
      CALL TTFORCE(CSTRMF3,CDIV3,FORBLK2,XNU,NNDAY)
      CALL TRANSFORM(1, CPSIG,CSTRMF3)
      CALL TRANSFORM(1, CDIVG,CDIV3)
      CALL TTFORCE(CSTRMF3,CDIV3,FORBLK3,XNU,NNDAY)
C=======================================================
C   read in transients explicitly calculated
C=======================================================
      IF (INTRS.eq.1) THEN
        read(30,rec=1) FORBLK2
        call norsou(FORBLK2, FORBLK4,IX,IY)
      ELSE
        do i=1,IX
        do j=1,IY
       	  FORBLK4(i,j)=FORBLK2(i,j)-FORBLK3(i,j)
        end do
        end do
      END IF
c
      CALL TRANSFORM ( 1, FORBLK4,ATRANS)
c
c     write out clim tansient forcing
      CALL TRANSFORM ( 1, FORBLK3, CSTRMF3)   
      call hsmooth(CSTRMF3,CSTRMF4,IR)
      CALL TRANSFORM (-1, FORBLK3, CSTRMF4)   
      call norsou(FORBLK3, FORBLK4,IX,IY)
      iwrt=1
      write(80,rec=iwrt) FORBLK4
C===============================================================
      do 9400 M1=1,IR+1
      do 9400 L1=1,IR+2
         UUU(L1,M1,1)=0.
         VVV(L1,M1,1)=0.
9400     VP (L1,M1,1)=0.
C-----------------------------------------------------------------
C   use other basic state
C-----------------------------------------------------------------
      go to (9411,9422) IBASIC
9422  continue   
C-----------------------------------------------------------------
C   take zonal mean as basic state              
      do M1=2,IR+1
      do L1=1,IR+2
         CSTRMF(L1,M1,1)=0.
         CDIV(L1,M1,1)=0.
      end do
      end do
C
9411  continue   
C                                                                       ZON02600
      DO 9405 M1=1,IR+1                                                 ZON02610
         L1=IR+2                                                        ZON02620
      ASTRMF(L1,M1,1)= 0.0
      ADIV  (L1,M1,1)= 0.0                                              ZON02640
      ATRANS(L1,M1,1)= 0.0                                              ZON02650
      CSTRMF(L1,M1,1)= 0.0                                              ZON02660
      CDIV  (L1,M1,1)= 0.0                                              ZON02670
9405  CTRANS(L1,M1,1)= 0.0                                              ZON02680
C                                                                       ZON02690
C -----------------------------------------------------------------     ZON02700
C   CALCULATING THE CLIM. & ANOM SPEC. DIVERGENCE OUTSIDE THE TIME LOOP ZON03160
C   AND THE GAUSSIAN GRIDPOINT DIVERGENCES TOO                          ZON03170
      DO 3300 ICT=1,2                                                   ZON03180
C                                                                       ZON03190
      DO 3010 L1=1,IR+2                                                 ZON03200
      DO 3010 M1=1,IR+1                                                 ZON03210
      IF (ICT.EQ.1) DUM(L1,M1,1)= CDIV(L1,M1,1)                         ZON03220
3010  IF (ICT.EQ.2) DUM(L1,M1,1)= ADIV(L1,M1,1)                         ZON03230
      DO 3012 M1=1,IR+1                                                 ZON03240
3012  DUM(IR+2,M1,1)=0.0                                                ZON03250
      IF (ICT.EQ.1) CALL TRANSFORM (-1, DIVC, DUM)                      ZON03260
      IF (ICT.EQ.2) CALL TRANSFORM (-1, DIV , DUM)                      ZON03270
C                                                                       ZON03280
C --------------------------------                                      ZON03290
C   CALCULATING VEL POT FROM THE SPECIFIED DIVERGENCE                   ZON03300
      DO 3015 M1=1,IR+1                                                 ZON03310
       M=M1-1                                                           ZON03320
      DO 3015 L1=1,IR+1                                                 ZON03330
       L=M+L1-1                                                         ZON03340
      VP(L1,M1,1)=0.0                                                   ZON03350
3015  IF (L .NE. 0) VP(L1,M1,1)= -DUM(L1,M1,1)*AR*AR/(L*(L+1.))         ZON03360
      DO 3016 M1=1,IR+1                                                 ZON03370
3016  VP(IR+2,M1,1)=0.0                                                 ZON03380
C                                                                       ZON03390
C --------------------------------                                      ZON03400
C   NEXT THE GENERATION OF VCHI FROM VEL POTENTIAL                      ZON03410
      DO 3020 M1=1,IR+1                                                 ZON03420
       M=M1-1                                                           ZON03430
      DO 3021 L1=1,IR+1                                                 ZON03440
       L=M+L1-1                                                         ZON03450
3021     UUU(L1,M1,1)= CONS*M*VP(L1,M1,1)/AR                            ZON03460
         UUU(IR+2,M1,1)= 0.0                                            ZON03470
C ------------                                                          ZON03480
      DO 3022 L1=1,1                                                    ZON03490
       L=M+L1-1                                                         ZON03500
3022     VVV(L1,M1,1)=+(L+2)* EPSML1(L1,M1)*VP(L1+1,M1,1)/AR            ZON03510
C ------------                                                          ZON03520
      DO 3023 L1=2,IR                                                   ZON03530
       L=M+L1-1                                                         ZON03540
         VVV(L1,M1,1)=-( (L-1)*EPSML(L1,M1) *VP(L1-1,M1,1)              ZON03550
     *                  -(L+2)*EPSML1(L1,M1)*VP(L1+1,M1,1) )/AR         ZON03560
3023  CONTINUE                                                          ZON03570
C ------------                                                          ZON03580
      DO 3024 L1=IR+1,IR+2                                              ZON03590
       L=M+L1-1                                                         ZON03600
3024     VVV(L1,M1,1)= -(L-1)*EPSML(L1,M1) *VP(L1-1,M1,1)/AR            ZON03610
3020  CONTINUE                                                          ZON03620
C ----------------------------                                          ZON03630
      IF (ICT.EQ.1) CALL TRANSFORM (-1, UCHIC , UUU)                    ZON03640
      IF (ICT.EQ.1) CALL TRANSFORM (-1, VCHIC , VVV)                    ZON03650
      IF (ICT.EQ.2) CALL TRANSFORM (-1, UCHI  , UUU)                    ZON03660
      IF (ICT.EQ.2) CALL TRANSFORM (-1, VCHI  , VVV)                    ZON03670
C                                                                       ZON03680
C------------------------------------------------------------
C  write out the velpotential
      CALL TRANSFORM(-1,FORBLK,VP)
      call norsou(FORBLK,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
3300  CONTINUE                                                          ZON03690
C   write out ADIVG
      call norsou(ADIVG,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
      write(6,*)'have written out the velpotential and ADIVG'
C ----------------------------------------------------------------------ZON03700
C   EVALUATING THE TIME-INDEP. PART OF THE SPECTRAL U, V AND VOR COEFF  ZON03710
      DO 6100 M1=1,IR+1                                                 ZON03720
       M=M1-1                                                           ZON03730
      DO 6120 L1=1,IR+1                                                 ZON03740
       L=M+L1-1                                                         ZON03750
          CRF(L1,M1)=-RF*        L*(L+1)/AR2                            ZON03770
          CVV(L1,M1)= CONS*M/AR                                         ZON03780
          CDUM(L1,M1)=       -L*(L+1)/AR2                               ZON03790
          CDUM4(L1,M1)=-XNU*L**3*(L+1)**3*3.E-25                        ZON03760
6120    CZTLMD(L1,M1)=-CONS*M*L*(L+1)/AR2                               ZON03800
C ------------                                                          ZON03810
      DO 6140 L1=1,1                                                    ZON03820
       L=M+L1-1                                                         ZON03830
          CUU1(L1,M1)=-(L+2)* EPSML1(L1,M1)/AR                          ZON03840
6140     CCZT1(L1,M1)=-(L+2)*(L+2)*(L+1)*EPSML1(L1,M1)/AR2              ZON03850
C ------------                                                          ZON03860
      DO 6160 L1=2,IR                                                   ZON03870
       L=M+L1-1                                                         ZON03880
         CUU2A(L1,M1)=  (L-1)* EPSML(L1,M1)/AR                          ZON03890
         CUU2B(L1,M1)= -(L+2)*EPSML1(L1,M1)/AR                          ZON03900
        CCZT2A(L1,M1)=       L*(L-1)*(L-1)*EPSML(L1,M1)/AR2             ZON03910
        CCZT2B(L1,M1)= -(L+1)*(L+2)*(L+2)*EPSML1(L1,M1)/AR2             ZON03920
6160  CONTINUE                                                          ZON03930
C ------------                                                          ZON03940
      DO 6180 L1=IR+1,IR+2                                              ZON03950
       L=M+L1-1                                                         ZON03960
          CUU3(L1,M1)= (L-1)*EPSML(L1,M1)/AR                            ZON03970
6180     CCZT3(L1,M1)=  L*(L-1)*(L-1)*EPSML(L1,M1)/AR2                  ZON03980
6100  CONTINUE                                                          ZON03990
C                                                                       ZON04000
C -----------------------------------------------------------------     ZON04010
C   EVALUATING SPECTRAL COEFF OF U & V FROM CSTRMF(*,*,1)               ZON04020
      DO 4100 M1=1,IR+1                                                 ZON04030
       M=M1-1                                                           ZON04040
      DO 4120 L1=1,IR+1                                                 ZON04050
C      L=M+L1-1                                                         ZON04060
            VV(L1,M1,1)=    CVV(L1,M1) *CSTRMF(L1,M1,1)                 ZON04070
           DUM(L1,M1,1)=   CDUM(L1,M1) *CSTRMF(L1,M1,1)                 ZON04080
4120    ZTLMDA(L1,M1,1)= CZTLMD(L1,M1) *CSTRMF(L1,M1,1)                 ZON04090
          VV(IR+2,M1,1)= 0.0                                            ZON04100
         DUM(IR+2,M1,1)= 0.0                                            ZON04110
      ZTLMDA(IR+2,M1,1)= 0.0                                            ZON04120
C ------------                                                          ZON04130
      DO 4140 L1=1,1                                                    ZON04140
C      L=M+L1-1                                                         ZON04150
            UU(L1,M1,1)=   CUU1(L1,M1) *CSTRMF(L1+1,M1,1)               ZON04160
4140    CZTTHT(L1,M1,1)=  CCZT1(L1,M1) *CSTRMF(L1+1,M1,1)               ZON04170
C ------------                                                          ZON04180
      DO 4160 L1=2,IR                                                   ZON04190
C      L=M+L1-1                                                         ZON04200
            UU(L1,M1,1)=  CUU2A(L1,M1) *CSTRMF(L1-1,M1,1)               ZON04210
     *                   +CUU2B(L1,M1) *CSTRMF(L1+1,M1,1)               ZON04220
        CZTTHT(L1,M1,1)= CCZT2A(L1,M1) *CSTRMF(L1-1,M1,1)               ZON04230
     *                  +CCZT2B(L1,M1) *CSTRMF(L1+1,M1,1)               ZON04240
4160  CONTINUE                                                          ZON04250
C ------------                                                          ZON04260
      DO 4180 L1=IR+1,IR+2                                              ZON04270
C      L=M+L1-1                                                         ZON04280
            UU(L1,M1,1)=   CUU3(L1,M1) *CSTRMF(L1-1,M1,1)               ZON04290
4180    CZTTHT(L1,M1,1)=  CCZT3(L1,M1) *CSTRMF(L1-1,M1,1)               ZON04300
4100  CONTINUE                                                          ZON04310
C                                                                       ZON04320
C ------------------------------------------------                      ZON04330
C     EVALUATING THE NONLINEAR PRODUCT C(M,L)                           ZON04340
      CALL TRANSFORM (-1, A1C   , UU   )                                ZON04350
      CALL TRANSFORM (-1, A2C   , VV   )                                ZON04360
      CALL TRANSFORM (-1, A3C   , ZTLMDA)                               ZON04370
      CALL TRANSFORM (-1, A4C   , CZTTHT)                               ZON04380
      CALL TRANSFORM (-1, VORC  , DUM  )                                ZON04390
c----------------------------------------------------------
      write(6,*) 'choose matrix'
      go to (6400,6300) MATGEN
6300  continue
      rewind 34
      read (34)  MTR2
      write(6,*) 'have read in matrix'
      go to 5090
c 
 6400  continue
C ----------------------------------------------------------
C   INITIALIZING THE STREAMFUNCTION ONE COMPONENT AT A TIME FOR MATRIX  ZON04490
C   GENERATION                                                          ZON04500
C                                                                       ZON04510
      DO 5000 MT1=1,IR+1                                                ZON04520
      DO 5000 LT1=1,IR+1                                                ZON04530
      DO 5000 NCR=1,2                                                   ZON04520
C        WRITE (*,*) NCR,MT1,LT1                                        ZON04540
C -----------------------                                               ZON04550
      DO 5003 M1=1,IR+1                                                 ZON04560
      DO 5003 L1=1,IR+1                                                 ZON04570
5003  ST(L1,M1,2)= (0.0,0.0)                                            ZON04580
      IF(NCR.EQ.1) then
      ST(LT1,MT1,2)=(1.0,0.)                                            ZON04590
      else
      ST(LT1,MT1,2)=CONS                                                ZON04590
      endif
C --------------------------------------------------                    ZON04600
C     EVALUATING SPECTRAL COEFF OF U & V FROM ST(*,*,2)                 ZON04610
      DO 5100 M1=1,IR+1                                                 ZON04620
       M=M1-1                                                           ZON04630
      DO 5120 L1=1,IR+1                                                 ZON04640
C      L=M+L1-1                                                         ZON04650
            VV(L1,M1,1)=    CVV(L1,M1) *ST(L1,M1,2)                     ZON04660
           DUM(L1,M1,1)=   CDUM(L1,M1) *ST(L1,M1,2)                     ZON04670
5120    ZTLMDA(L1,M1,1)= CZTLMD(L1,M1) *ST(L1,M1,2)                     ZON04680
          VV(IR+2,M1,1)= 0.0                                            ZON04690
         DUM(IR+2,M1,1)= 0.0                                            ZON04700
      ZTLMDA(IR+2,M1,1)= 0.0                                            ZON04710
C ----------------------------------------------------                  ZON04720
      DO 5140 L1=1,1                                                    ZON04730
C      L=M+L1-1                                                         ZON04740
            UU(L1,M1,1)=   CUU1(L1,M1) *ST(L1+1,M1,2)                   ZON04750
5140    CZTTHT(L1,M1,1)=  CCZT1(L1,M1) *ST(L1+1,M1,2)                   ZON04760
C ----------------------------------------------------                  ZON04770
      DO 5160 L1=2,IR                                                   ZON04780
C      L=M+L1-1                                                         ZON04790
            UU(L1,M1,1)=  CUU2A(L1,M1) *ST(L1-1,M1,2)                   ZON04800
     *                   +CUU2B(L1,M1) *ST(L1+1,M1,2)                   ZON04810
        CZTTHT(L1,M1,1)= CCZT2A(L1,M1) *ST(L1-1,M1,2)                   ZON04820
     *                  +CCZT2B(L1,M1) *ST(L1+1,M1,2)                   ZON04830
5160  CONTINUE                                                          ZON04840
C ------------                                                          ZON04850
      DO 5180 L1=IR+1,IR+2                                              ZON04860
C      L=M+L1-1                                                         ZON04870
            UU(L1,M1,1)=   CUU3(L1,M1) *ST(L1-1,M1,2)                   ZON04880
5180    CZTTHT(L1,M1,1)=  CCZT3(L1,M1) *ST(L1-1,M1,2)                   ZON04890
5100  CONTINUE                                                          ZON04900
C                                                                       ZON04910
C ---------------------------------------------------                   ZON04920
C     EVALUATING THE NONLINEAR PRODUCT C(M,L)                           ZON04930
      CALL TRANSFORM (-1, A1    , UU   )                                ZON04940
      CALL TRANSFORM (-1, A2    , VV   )                                ZON04950
      CALL TRANSFORM (-1, A3    , ZTLMDA)                               ZON04960
      CALL TRANSFORM (-1, A4    , CZTTHT)                               ZON04970
      CALL TRANSFORM (-1, VOR   , DUM  )                                ZON04980
C------------------------------------------------------                 ZON04990
C   COMPUTATION OF THE L.H.S. PRODUCTS FOR MATRIX GENERATION            ZON05010
C   FOR THE ANOMALY SIMULATION USING THE ZONALLY ASYMMETRIC BASIC STATE ZON05020
C ---------------------------------------------------                   ZON05030
      DO 5610 J=1,IY                                                    ZON05050
      DO 5610 I=1,IX                                                    ZON05060
      FORBLK(I,J)=+ARCTH2(J)*((NDIV*UCHIC(I,J)+A1C(I,J))*A3(I,J)        ZON05070
     *                       +(NDIV*VCHIC(I,J)+A2C(I,J))*A4(I,J)        ZON05080
     *                       +(           A1 (I,J)) *A3C(I,J)           ZON05090
     *                       +(           A2 (I,J)) *A4C(I,J))          ZON05100
     *            + A2(I,J)*TWOMGR                                      ZON05110
     *            +VOR(I,J)*NDIV*DIVC(I,J)                              ZON05120
5610  CONTINUE                                                          ZON05130
      CALL TRANSFORM (1, FORBLK, C)                                     ZON05140
C
C ---------------------------------------------------                   ZON05150
C   NEXT WE FILL UP THE MATRIX                                          ZON05160
        ICO= (MT1-1)*(IR+1)*2 +(LT1-1)*2+NCR                            ZON05170
      write(6,*) 'ICO=',ICO
C        IF (ICO.EQ.510) WRITE (6,*)   C                                ZON05180
C                                                                       ZON05190
      DO 5007 M1=1,IR+1                                                 ZON05200
      DO 5007 L1=1,IR+1                                                 ZON05210
      DO 5007 NCR2=1,2                                                  ZON05210
        IRO= (M1-1)*(IR+1)*2+(L1-1)*2+NCR2                              ZON05220
c       write(6,*)'IRO=',IRO
      IF ((ICO.GE.3) .AND. (IRO.GE.3)) THEN
	 IF(NCR2.EQ.1) THEN
	 MTR2(IRO-2,ICO-2)=REAL(C(L1,M1,1))
	 ELSE
         MTR2(IRO-2,ICO-2)=AIMAG(C(L1,M1,1))
	 ENDIF
      ENDIF
5007  CONTINUE                                                          ZON05240
C                                                                       ZON05250
5000  CONTINUE                                                          ZON05270
      write(34) MTR2
      iwrite=0
      do i=1,irs2
      iwrite=iwrite+1
C     write(6,*) 'iwrite=',iwrite,'MTR2=',MTR2(i,i-1),MTR2(i,i+1)
      end do
C                                                                       ZON05300
5090  CONTINUE                                                          ZON05310
C -----------------------------------------------------------------     ZON05320
C   NEXT THE FORCING AND THE FRICTION TERMS                             ZON05330
      CALL TRANSFORM(-1,FORTRA,ATRANS)
C                                                                       ZON05520
      DO 8620 J=1,IY                                                    ZON05490
      DO 8620 I=1,IX                                                    ZON05500
       IF ((J.LT.JBEG) .OR. (J.GT.JEND)) FORTRA(I,J)=0.0                ZON05510
c      IF ((J.LT.JBEG) .OR. (J.GT.JEND)) UCHI(I,J)=0.0                  ZON05510
c      IF ((J.LT.JBEG) .OR. (J.GT.JEND)) VCHI(I,J)=0.0                  ZON05510
c      IF ((J.LT.JBEG) .OR. (J.GT.JEND)) DIV (I,J)=0.0                  ZON05510
       IF ((I.LT.IBEG) .OR. (I.GT.IEND)) FORTRA(I,J)=0.0                ZON05510
c      IF ((I.LT.IBEG) .OR. (I.GT.IEND)) UCHI(I,J)=0.0                  ZON05510
c      IF ((I.LT.IBEG) .OR. (I.GT.IEND)) VCHI(I,J)=0.0                  ZON05510
c      IF ((I.LT.IBEG) .OR. (I.GT.IEND)) DIV (I,J)=0.0                  ZON05510
c      IF (J.LT.JNOR) UCHI(I,J)=0.0                                     ZON05510
c      IF (J.LT.JNOR) VCHI(I,J)=0.0                                     ZON05510
       IF (J.LT.JNOR) DIV (I,J)=0.0*DIV (I,J)                           ZON05510
8620  CONTINUE                                                          ZON05310
C --------------------------------------------------                    ZON04600
C     EVALUATING SPECTRAL COEFF OF U & V FROM ASTRMF                    ZON04610
C     for calculating non-divergent forcing
C
      DO 7100 M1=1,IR+1                                                 ZON04620
       M=M1-1                                                           ZON04630
      DO 7120 L1=1,IR+1                                                 ZON04640
C      L=M+L1-1                                                         ZON04650
           DUM(L1,M1,1)=   CDUM(L1,M1) *ASTRMF(L1,M1,1)                 ZON04670
7120    ZTLMDA(L1,M1,1)= CZTLMD(L1,M1) *ASTRMF(L1,M1,1)                 ZON04680
         DUM(IR+2,M1,1)= 0.0                                            ZON04700
      ZTLMDA(IR+2,M1,1)= 0.0                                            ZON04710
C ----------------------------------------------------                  ZON04720
      DO 7140 L1=1,1                                                    ZON04730
C      L=M+L1-1                                                         ZON04740
7140    CZTTHT(L1,M1,1)=  CCZT1(L1,M1) *ASTRMF(L1+1,M1,1)               ZON04760
C ----------------------------------------------------                  ZON04770
      DO 7160 L1=2,IR                                                   ZON04780
C      L=M+L1-1                                                         ZON04790
        CZTTHT(L1,M1,1)= CCZT2A(L1,M1) *ASTRMF(L1-1,M1,1)               ZON04820
     *                  +CCZT2B(L1,M1) *ASTRMF(L1+1,M1,1)               ZON04830
7160  CONTINUE                                                          ZON04840
C ------------                                                          ZON04850
      DO 7180 L1=IR+1,IR+2                                              ZON04860
C      L=M+L1-1                                                         ZON04870
7180    CZTTHT(L1,M1,1)=  CCZT3(L1,M1) *ASTRMF(L1-1,M1,1)               ZON04890
7100  CONTINUE                                                          ZON04900
C                                                                       ZON04910
C ---------------------------------------------------                   ZON04920
C     EVALUATING THE NONLINEAR PRODUCT C(M,L)                           ZON04930
      CALL TRANSFORM (-1, A3    , ZTLMDA)                               ZON04960
      CALL TRANSFORM (-1, A4    , CZTTHT)                               ZON04970
      CALL TRANSFORM (-1, VOR   , DUM  )                                ZON04980
C ----------------------------------------------------
      DO 8610 J=1,IY                                                    ZON05530
      DO 8610 I=1,IX                                                    ZON05540
      WVSC1(I,J)= -(FCOR(J)+VORC(I,J)) *DIV(I,J)
      DO JJ=1,IY                                                        ZON02730
      DO II=1,IX                                                        ZON02740
        IF ((JJ.LT.JBEG) .OR. (JJ.GT.JEND))  WVSC1(II,JJ)=0.0           ZON02750
        IF ((II.LT.IBEG) .OR. (II.GT.IEND))  WVSC1(II,JJ)=0.0           ZON02750
      END DO
      END DO
      WVSC2(I,J)= -ARCTH2(J)*( UCHI(I,J)* A3C(I,J)
     *                        +VCHI(I,J)* A4C(I,J) )                    ZON05580
     *            -VCHI(I,J)* TWOMGR                                    ZON05590
      WVSC3(I,J)= -ARCTH2(J)*( UCHIC(I,J)*A3(I,J)                       ZON05070
     *                      +  VCHIC(I,J)*A4(I,J))                      ZON05080
     *                      -  VOR(I,J)*DIVC(I,J)                       ZON05120
      FORBLK(I,J) = NS1*WVSC1(I,J)                                      ZON05550
     *             +NS2*WVSC2(I,J)                                      ZON05600
     *             +NS3*FORTRA(I,J)                                     ZON05600
     *             +(1-NDIV)*NS4*WVSC3(I,J)                             ZON05600
      ABSVOR(I,J)=FCOR(J)+VORC(I,J)
8610  CONTINUE                                                          ZON05610
      CALL TRANSFORM (1, FORBLK, C)                                     ZON05620
C------------------------------------------------------
      DO 8008 M1=1,IR+1                                                 ZON05640
      DO 8008 L1=1,IR+1                                                 ZON05650
         IRO= (M1-1)*(IR+1)+L1                                          ZON05660
c     write(6,*) 'IRO=',IRO
      IF (IRO.GE.2) THEN
	 RFOR2(2*IRO-3)= REAL(C(L1,M1,1))     
	 RFOR2(2*IRO-2)= AIMAG(C(L1,M1,1))
      ENDIF
8008  CONTINUE                                                          ZON05690
C
      write(6,*) 'before tansient forcing'
      call hsmooth(ATRANS,CTRANS5,IR)
      CALL TRANSFORM (-1, FORBLK3, CTRANS5)   
      call norsou(FORBLK3, FORBLK4,IX,IY)
      iwrt=iwrt+1
      write(6,*) 'iwrt=',iwrt
      write(80,rec=iwrt) FORBLK4
c
C -----------------------------------------------------------------     ZON05320
C   MODIFICATIONS TO MTR FOR FRICTION AND VISCOSITY COEFFICIENTS        ZON05720
C ---------------------------------------------------------------       ZON05710
C
      DO 8107 M1=1,IR+1                                                 ZON05730
      DO 8107 L1=1,IR+1                                                 ZON05740
         IRO= (M1-1)*(IR+1)+L1                                          ZON05750
      IF (IRO.GE.2) THEN
         MTR2(2*IRO-3,2*IRO-3)=  MTR2(2*IRO-3,2*IRO-3) +                ZON05760
     *        CRF(L1,M1) + CDUM4(L1,M1)
         MTR2(2*IRO-2,2*IRO-2)=  MTR2(2*IRO-2,2*IRO-2) +                ZON05760
     *        CRF(L1,M1) + CDUM4(L1,M1)
      ENDIF
8107  CONTINUE
C                                                                       ZON05790
C   MATRIX INVERSION NEXT 
C ---------------------------------------------------
      write(6,*) 'befor  LUDCMP'
      CALL  LUDCMP(MTR2, IRS2, IRS2, INDX, DOUT)                        ZON05810
      write(6,*) 'after LUDCMP, DOUT=', DOUT
      do i=1,IRS2
C     write(6,*) 'iwrite=',iwrite,'MTR2=',MTR2(i,i),MTR2(i,i+1)
      END DO
      CALL  LUBKSB(MTR2, IRS2, IRS2, INDX, RFOR2)                       ZON05810
      write(6,*) 'after  LUBKSB'
C------------------------------------------------------
c
      DO 6700 M1=1,IR+1                                                 ZON06010
      DO 6700 L1=1,IR+1                                                 ZON06020
      IRO= (M1-1)*(IR+1)+ L1                                            ZON06030
      ST(L1,M1,1)= (0.0,0.0)                                            ZON06040
      IF (IRO .GE. 2) THEN 
	 X=RFOR2(2*IRO-3)
	 Y=RFOR2(2*IRO-2)
         ST(L1,M1,1)=  CMPLX(X,Y)                                       ZON06050
      ENDIF
6700  CONTINUE                                                          ZON06050
C                                                                       ZON06060
C========================================================               ZON07270
C   writing the output and diagnostics
C========================================================
      do 6401 M1=1,IR+1
      do 6410 L1=1,IR+1
        C(L1,M1,1)=ASTRMF(L1,M1,1)
        DUM(L1,M1,1)=ST(L1,M1,1)
6410  CONTINUE
        C(IR+2,M1,1)=0.0               
6401  CONTINUE
C
C----- to focus on the eddy component alone
      GO TO (11,12) IEDD
11    CONTINUE
C
      do 6510 L1=1,IR+2
        C(L1,1,1)=0.
6510  DUM(L1,1,1)=0.
12    CONTINUE
C
C----- writing the solved anomalous stream function
      CALL TRANSFORM(-1,FORBLK,DUM)
      call norsou(FORBLK,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
c  solved ur and vr 
      CALL URVR(IR,DUM,CVV,CUU1,CUU2A,
     +                CUU2B,CUU3,UU,VV)    
      CALL TRANSFORM( -1,FORBLK2,UU)
      CALL TRANSFORM( -1,FORBLK3,VV)
      do i=1,IX
      do j=1,IY
	FORBLK2(I,J)=FORBLK2(I,J)/cos(GLAT(j))
	FORBLK3(I,J)=FORBLK3(I,J)/cos(GLAT(j))
      end do
      end do
      call norsou(FORBLK2,FORBLK4,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK4
      call norsou(FORBLK3,FORBLK4,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK4
C
C----- verifying the solution
      CALL TRANSFORM(-1,FORBLK,C )
      call norsou(FORBLK,FORBLK2,IX,IY)
      iwrt=iwrt+1
c     write(80,rec=iwrt) FORBLK2
      call norsou(APSIG,FORBLK2,IX,IY)
      write(80,rec=iwrt) FORBLK2
c  veryfying ur and vr 
      CALL URVR(IR,C,CVV,CUU1,CUU2A,
     +                CUU2B,CUU3,UU,VV)    
      CALL TRANSFORM( -1,FORBLK2,UU)
      CALL TRANSFORM( -1,FORBLK3,VV)
      do i=1,IX
      do j=1,IY
	FORBLK2(I,J)=FORBLK2(I,J)/cos(GLAT(j))
	FORBLK3(I,J)=FORBLK3(I,J)/cos(GLAT(j))
      end do
      end do
      call norsou(FORBLK2,FORBLK6,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK6
      call norsou(FORBLK3,FORBLK4,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK4
C---wvflx of linear model simulated total anom
      call TRANSFORM(-1,FORBLK,DUM)
      call wvflxtn(CPSIG,FORBLK,XFS,YFS)
      call norsou(XFS,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
      call norsou(YFS,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
C---wvflx of GCM (or OBS) anom st
      call TRANSFORM(-1, FORBLK, C)
      call wvflxtn(CPSIG,FORBLK,XFS,YFS)
      call norsou(XFS,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
      call norsou(YFS,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
c   climatological stream function
         CALL TRANSFORM ( -1, FORBLK, CSTRMF)                   
      call norsou(FORBLK,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
C-------------------------------------------------------------------
C   calculate the correct wind by dividing the cos(lat)
      do 7710 i=1,IX
      do 7710 j=1,IY
        COSIV=1./cos(GLAT(j))
        UCHIC(i,j)=UCHIC(i,j)*COSIV
        VCHIC(i,j)=VCHIC(i,j)*COSIV
        UCHI (i,j)=UCHI (i,j)*COSIV
        VCHI (i,j)=VCHI (i,j)*COSIV
        A1C  (i,j)=A1C  (i,j)*COSIV
        A2C  (i,j)=A2C  (i,j)*COSIV
7710  CONTINUE
C--------------------------------------------------------------------
C   udc & vdc
      call norsou(UCHIC,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
      call norsou(VCHIC,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
C   uda & vda
      call norsou(UCHI,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
      call norsou(VCHI,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
C  urc & vrc
      call norsou(A1C,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
      call norsou(A2C,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
C   climatal  ABSOLUTE vorticity
      call norsou(ABSVOR,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
C
Cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
C   write out totfrc and its psi tendency 
      do i=1,IX
      do j=1,IY
	 FORBLK(i,j)=WVSC1(I,J)+WVSC2(I,J)+FORTRA(i,j)
      end do
      end do
      call norsou(WVSC1,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
      CALL SOLUTN(WVSC1,FORBLK3,MTR2,INDX,IEDD)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK3
      call norsou(WVSC2,FORBLK2,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK2
      CALL SOLUTN(WVSC2,FORBLK3,MTR2,INDX,IEDD)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK3
      call TRANSFORM( 1,FORBLK,CSTRMF3)
      call DEL2IN(CSTRMF3,CSTRMF4,IR)
      call TRANSFORM( -1,FORBLK2,CSTRMF4)
      call norsou(FORBLK2,FORBLK3,IX,IY)
      iwrt=iwrt+1
      write(80,rec=iwrt) FORBLK3
Cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      STOP
      END

      SUBROUTINE FILLMAT(A,B,M,N)
      COMPLEX A(M,N),B(M,N)
      do 1 I=1,M
      do 1 J=1,N
         A(I,J)=B(I,J)
1     CONTINUE
      RETURN
      END

      SUBROUTINE DEL2IN(FLD1,FLD2,IR)
      COMPLEX FLD1(IR+2,IR+1),FLD2(IR+2,IR+1)
      AR = 6.37E6
      DO 1 M1=1,IR+1    
       M=M1-1                                                           ZON03320
      DO 1 L1=1,IR+1                                                    ZON03330
       L=M+L1-1                                                         ZON03340
      FLD2(L1,M1)=0.0                                                   ZON03350
  1   IF (L .NE. 0) FLD2(L1,M1)= -FLD1(L1,M1)*AR*AR/(L*(L+1.))          ZON03360
      DO 2 M1=1,IR+1                                                    ZON03370
  2   FLD2(IR+2,M1)=0.0                                                 ZON03380
      RETURN
      END

      SUBROUTINE SOLUTN(FLDIN,FLDOUT,MTR2,INDX,IEDD)
C
      parameter(IR=15, IX=64, IY=40)
      parameter(IRS=(IR+1)*(IR+1)-1)
      parameter(IRS2=2*IRS)
      REAL FLDIN(IX,IY),FLDOUT(IX,IY),WORK(IX,IY)     
      COMPLEX STRMF(IR+2,IR+1),STRMF2(IR+2,IR+1)        
      REAL RFOR(IRS2),MTR2(IRS2,IRS2),RSOL(IRS2)
      DIMENSION INDX(IRS2)
C
      CALL TRANSFORM(1, FLDIN,STRMF)
c     call hsmooth(STRMF,STRMF2,IR)
      DO  10  M1=1,IR+1                                                 ZON05640
      DO  10  L1=1,IR+1                                                 ZON05650
         IRO= (M1-1)*(IR+1)+ L1                                         ZON05660
      IF (IRO.GE.2) THEN
	 RFOR(2*IRO-3)= REAL(STRMF(L1,M1))     
	 RFOR(2*IRO-2)= AIMAG(STRMF(L1,M1))
      ENDIF
 10   CONTINUE                                                          ZON05700
      CALL LUBKSB(MTR2, IRS2, IRS2, INDX, RFOR)
c
      DO 30   M1=1,IR+1                                                 ZON06010
      DO 30   L1=1,IR+1                                                 ZON06020
      IRO= (M1-1)*(IR+1)+ L1                                            ZON06030
      STRMF(L1,M1)= (0.0,0.0)                                           ZON06040
      IF (IRO .GE. 2) THEN 
	 X=RFOR(2*IRO-3)
	 Y=RFOR(2*IRO-2)
         STRMF(L1,M1)=  CMPLX(X,Y)                                      ZON06050
      ENDIF
 30   CONTINUE                                                          ZON06050
C                                                                       ZON06060
C----- to focus on the eddy component alone
      GO TO (21,22) IEDD
21    CONTINUE
C
      do  40  L1=1,IR+2
 40   STRMF(L1,1)=0.
22    CONTINUE
C
      CALL TRANSFORM(-1,WORK,STRMF)
      call norsou(WORK,FLDOUT,IX,IY)
C
      return
      end
C
      SUBROUTINE RTOC(N1,A,N2,B)
      REAL      A(N1)
      COMPLEX   B(N2)
      do 10 i=1,N2
	 B(i)=CMPLX(A(2*I-1),A(2*I))
  10  continue
      return
      end
C
      SUBROUTINE CTOR(N1,A,N2,B)
      REAL      B(N2)
      COMPLEX   A(N1)
      do 10 i=1,N1
	 B(2*I-1)=REAL(A(I))
	 B(2*I  )=AIMAG(A(I))
  10  continue
      return
      end

      SUBROUTINE URVR(IR,CSTRMF,CVV,CUU1,CUU2A,
     +                CUU2B,CUU3,UU,VV)    
C   EVALUATING SPECTRAL COEFF OF U & V FROM CSTRMF(*,*,1)               ZON04020
      COMPLEX    CVV(IR+2,IR+1),    UU(IR+2,IR+1)                       ZON00390
      COMPLEX VV(IR+2,IR+1),    CUU1 (IR+2,IR+1)                        ZON00400
      COMPLEX CUU2B(IR+2,IR+1),     CUU2A(IR+2,IR+1)                    ZON00410
      COMPLEX CUU3 (IR+2,IR+1), CSTRMF(IR+2,IR+1,1)                     ZON00410
      DO 4100 M1=1,IR+1                                                 ZON04030
       M=M1-1                                                           ZON04040
      DO 4120 L1=1,IR+1                                                 ZON04050
          VV(L1,M1)=    CVV(L1,M1) *CSTRMF(L1,M1,1)                     ZON04070
4120  CONTINUE
          VV(IR+2,M1)= 0.0                                              ZON04100
C ------------                                                          ZON04130
      DO 4140 L1=1,1                                                    ZON04140
          UU(L1,M1)=    CUU1(L1,M1) *CSTRMF(L1+1,M1,1)                  ZON04160
4140  CONTINUE
C ------------                                                          ZON04180
      DO 4160 L1=2,IR                                                   ZON04190
C      L=M+L1-1                                                         ZON04200
            UU(L1,M1)=  CUU2A(L1,M1) *CSTRMF(L1-1,M1,1)                 ZON04210
     *                   +CUU2B(L1,M1) *CSTRMF(L1+1,M1,1)               ZON04220
4160  CONTINUE                                                          ZON04250
C ------------                                                          ZON04260
      DO 4180 L1=IR+1,IR+2                                              ZON04270
            UU(L1,M1)=   CUU3(L1,M1) *CSTRMF(L1-1,M1,1)                 ZON04290
4180    CONTINUE 
4100  CONTINUE                                                          ZON04310
      return
      end
C                                                                       ZON04320

      SUBROUTINE IDEAFRC(F,I0,J0,a,b,XIT)
      parameter(IX=64, IY=40)
      REAL    F(IX,IY)
      write(6,*) 'XIT= ',XIT
      do i=1,IX
      do j=1,IY
	F(i,j)=0.
      end do
      end do
c
      unitfrc=1.e-6
      do 1 I=1,IX
      do 1 J=1,IY
      X=-((I-I0)/a)**2-((J-J0)/b)**2
      F(I,J)=XIT*unitfrc*EXP(X)
1     CONTINUE
      RETURN
      END
