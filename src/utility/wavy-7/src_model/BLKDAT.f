      BLOCK DATA BLKDAT
C
      save
      include "comctl"
      include "comphc"
      include "comtim"
      include "commnt"
      include "comcon"
      include "comnum"
C
      include "pkmax"
C
      COMMON/COMCTQ/ CT(KMAX),CQ(KMAX)
C.................................................................
C..THE VALUE BELOW IS FOR 18-LAYER MRF86 VERTICAL SPACING
C.................................................................
C     DATA
C    S CT /38.1 E0,38.2 E0,38.7 E0,39.3 E0,40.5 E0,42.5 E0,
C    1     44.8 E0,46.8 E0,47.1 E0,47.9 E0,47.6 E0,43.2 E0,
C    2     37.2 E0,29.9 E0,23.3 E0,09.7 E0,2*0.0 E0/
C     DATA
C    S CQ /0.0270 E0,0.0290 E0,0.0290 E0,0.0270 E0,0.0190 E0,0.0110 E0,
C    1     0.0079 E0,0.0057 E0,0.0038 E0,0.0024 E0,0.0014 E0,0.0010 E0,
C    2   6*0.00   E0/
C
C.................................................................
      include "comsig"
      include "sigdef"
C
       DATA ZERO  ,ONE   ,TWO   ,THREE ,FOUR  ,FIVE  ,EIGHT, TEN
     1     /0.0 E0,1.0 E0,2.0 E0,3.0 E0,4.0 E0,5.0 E0,8.0 E0,10. E0/
       DATA EIGTEN,THOUSD,HALF  ,FOURTH ,F7    ,ONEHAF,F360
     1     /1.8 E1,1.0 E3,0.5 E0,2.5 E-1,0.7 E0,1.5 E0,3.6 E2/
       DATA F180  ,F09   ,F10M6 ,FLIM   ,F999  ,FE40  ,F3600
     1     /1.8 E2,0.9 E0,1.0E-6,1.0E-20,9.99E2,1.0E35,3.6 E3/
       DATA PAI   ,TBAR  ,CNVFAC        ,F02   ,OZFAC  ,PSTND
     1/3.1415926E0,3.0 E2,14.3353E-04   ,0.2 E0,1.0E-04,1.013 E3/
       DATA TENTH ,F10M3, DELQ   ,QMIN   ,F24   ,F07   ,HUNDRD
     1     /0.1 E0,1.0E-3,0.608E0,1.0 E-5,24.0 E0,0.07 E 0, 1. E 2/
      DATA F10M2 ,FIFTY
     1     /1.0 E-2, 50. E 0 /
C
      DATA IRAD  ,ICCON ,ILCON ,IDCON ,IQADJ ,IPBL  ,IEVAP ,ISENS ,
     1     IDRAG ,IQDIF ,IFFT  ,ISCON
     2    /'YES ','YES ','YES ','NO  ','NO  ','YES ','YES ','YES ',
     3     'YES ','YES ','JMA ','YES '/
C
C...CP     SPECIFIC HEAT OF AIR           (J/KG/K)
C...HL     HEAT OF EVAPORATION OF WATER   (J/KG)
C...GASR   GAS CONSTANT OF DRY AIR        (J/KG/K)
C...ER     EARTH S RADIUS                 (M)
C...GRAV   GRAVITY CONSTANT               (M/S**2)
C...SOLCON SOLAR CONSTANT                 (W/M**2)
      DATA CP        ,HL      ,GASR      ,ER       ,GRAV   ,STEFAN   ,
     2     SOLCON    ,TWOMG   ,RMWMD     ,RMWMDI   ,E0C,
     3     T000      ,P000
     4    /1004.6 E 0,2.52 E 6,287.05 E 0,6370. E 3,9.8 E 0,5.67 E -8,
     5     1368.3 E 0,1.458492 E -4, .622 E 0, 1.61 E 0, 6.11 E 0,
     6     299.   E 0,1013.    E 0 /
C
      DATA          NFIN0 ,NFIN1 ,NFOUT0,NFOUT1,NFOUT2
     S             /    18,    19,    20,    21,     0/
      DATA          NFCLM0,NFCLM1,NFTGZ0,NFTGZ1,NFSIBT
     S             /    10,    11,    01,    02,    99/
      DATA          NFSIBD,NFSIBI,NFSIBO,NFNMI ,NFDBH
     S             /    88,    77,    66,   80 ,   75/
      DATA          NFDRCT,NFDIAG,  NF3D,  NF2D
     S             /    25,    26,    27,    28/
      DATA          INITLZ,NSTEP ,INTSYN
     S             /     2,     1,    24/
      DATA          MAXSTP,ISTEPS, HDIFD, HDIFT,NFILES,IFIN
     S             /    06,    01,1.0E17,1.0E17,     1,     1/
      DATA          FILTA ,DELT   ,SHOUR  ,MODS  ,NITER,PERCUT
     S             /0.92E0,  1. E0,0.0  E0,     4,    2,27502. E0/
      DATA          NFSST ,NFSNW ,NFALB ,NFSLM
     S             /    50,    51,    52,    53/
      DATA          IFSST ,IFSNW ,IFALB ,IFSLM
     S             /     2,     3,     2,     3/
      DATA          HDIFD2,HDIFT2
     S             /    2.5E6, 2.5E6/
C
      DATA MKUO ,MLRG ,MDRY ,MGRD ,MTIM ,
     1     TBASE,UBASE,VBASE,RBASE,DBASE,PBASE,
     2     TFACT,UFACT,VFACT,RFACT,DFACT,PFACT,
     3     IS   ,IE   ,JS   ,JE   ,II   ,JI   ,JMOD ,JREM
     4     /   0,    0,    0,    0,    0,
     5      273.15 E00,  4*0.0 E00,    1.0 E03,
     6      3*10.0 E00,  2*1.0 E07,   10.0 E00,
     7         1,  128,    1,  102,    1,    1,   34,   0/
C     RETURN
      END
