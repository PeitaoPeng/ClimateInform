CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C    PROGRAM TO READ, AVERAGE, PACK AND WRITE OUT MONTHLY AVERAGES OF  C
C    MANY SIGMA HISTORY QUANTITIES, INCLUDING THE VERTICALLY           C
C    INTEGRATED CONVERGENCE OF MOISTURE FLUX, IN UNITS OF              C
C           KG /(M**2 * SEC)                                           C
C                                                                      C
C    LINIT =.TRUE. IF INITIAL FIELDS ARE PRESENT IN THE SIGMA HISTORY  C
C                  (UNINITIALIZED AND INITIALIZED INITIAL CONDITIONS   C
C                   ARE THEN SKIPPED)                                  C
C                                                                      C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C    INPUT UNIT NUMBERS ARE 10,11,...FOR SIGMA HISTORY FILES           C
C                       IS  8        FOR VEGETATION MASK               C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C    OUTPUT UNIT NUMBERS-                                              C
C      60  FOR CFS FILE OF SIGMA HISTORY QUANTITIES TO BE STORED       C
C          FOR PACKED FILES TO BE SENT TO COLA -                       C
C                                                                      C
C      NOTE: SURFACE PRESSURE IS CONVERTED FROM MODEL'S UNITS OF       C
C  CENTIBARS TO PASCALS WITHIN PROGRAM.                                C
C                                                                      C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      LOGICAL LINIT
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1)
      PARAMETER(NM=NW)
      PARAMETER(NMP=NW+1)
      PARAMETER(NLONG=128)
      PARAMETER(NLATG=102)
      PARAMETER(NLEV=18)
      PARAMETER(NX=72,NY=46)
CC
      PARAMETER(NPROGS=4*NLEV+1,NPROGG=8,NDIAGG=21,NDIABG=NLEV)
CC
      PARAMETER(NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      PARAMETER(KHALF=(NLATG+1)/2)
      PARAMETER(EA=6.371E+06,GRAV=9.8)
      COMMON/GAUSS/RADG(NLATG),GWGT(NLATG)
      COMMON/POLY1/PLEG(NLEG,NMP,NLATG),DPLEG(NLEG,NMP,NLATG)
      COMMON/FFTAR1/TRIGS(IMAXT),IFAX(10)
      COMMON/FFTAR2/ARRAY(NLONGP,NLATG),WORK(NLONGP,NLATG)
      COMMON/SGTAVE/QPROGS(2,NLEG,NMP,NPROGS),
     1              QPROGG(NLONG,NLATG,NPROGG),
     2              QDIAGG(NLONG,NLATG,NDIAGG),
     3              QDIABG(NLONG,NLATG,NDIABG)
      DIMENSION STRESX(NX,NY),STRESY(NX,NY),
     1          SFCPLN(NX,NY),HEATSE(NX,NY),
     2          HEATLT(NX,NY),RADISW(NX,NY),
     3          RADILW(NX,NY)
      DIMENSION OUTPUT(NX,NY,7)    
      DIMENSION CMFSPC(2,NLEG,NMP),CMFGRD(NLONG,NLATG)
      DIMENSION FIELDG(NLONG,NLATG)
      DIMENSION FLDSPC(2,NLEG,NMP)
      DIMENSION IDATE(4),DEL(NLEV)
      DIMENSION COLRAD(KHALF),WGT(KHALF),WGTCS(KHALF),RCS2(KHALF)
      CHARACTER*8 LABEL(6)
      NAMELIST/SGNML/ HRBG,IDAYBG,MONBG,IYRBG,
     1                HREN,IDAYEN,MONEN,IYREN,LINIT
      PI=ACOS(-1.0)
      READ(5,SGNML)
      WRITE(8,SGNML)
      CALL SETDAY
      CALL FHR(HRBG,IDAYBG,MONBG,IYRBG,FHRBEG)
      CALL FHR(HREN,IDAYEN,MONEN,IYREN,FHREND)
      CALL FHR( 0.0,     1,    1,   79,  FHR0)
      FHRBEG=FHRBEG-FHR0
      FHREND=FHREND-FHR0
      WRITE(6,7408) HRBG,IDAYBG,MONBG,IYRBG,FHRBEG
 7408 FORMAT(' HRBG=',F5.1,' IDAYBG=',I3,' MONBG=',I3,' IYRBG=',I3,
     1 ' FHRBEG = ',F10.1)
      WRITE(6,7410) HREN,IDAYEN,MONEN,IYREN,FHREND
 7410 FORMAT(' HREN=',F5.1,' IDAYEN=',I3,' MONEN=',I3,' IYREN=',I3,
     1 ' FHREND = ',F10.1)
      LENSPC=2*NLEG*NMP
      LENGRD=NLONG*NLATG
      UNDEF=9.99E+55
      CALL GLATS(KHALF,COLRAD,WGT,WGTCS,RCS2)
      DO 30 K=1,KHALF
      RADG(K)=PI/2.0 - COLRAD(K)
      RADG(NLATG-K+1)=-RADG(K)
      GWGT(K)=WGT(K)
      GWGT(NLATG-K+1)=+GWGT(K)
   30 CONTINUE
      DO 40 JG=1,NLATG
      CALL GENNCR(RADG(JG),PLEG(1,1,JG),DPLEG(1,1,JG))
   40 CONTINUE
      CALL ARFILL(QPROGS,0.0,2*NLEG*NMP*NPROGS)
      CALL ARFILL(QPROGG,0.0,NLONG*NLATG*NPROGG)
      CALL ARFILL(QDIAGG,0.0,NLONG*NLATG*NDIAGG)
      CALL ARFILL(QDIABG,0.0,NLONG*NLATG*NDIABG)
      IREAD=0
      IWRITE=0
      IUNIT=21
C.....IF INITIAL CONDITIONS ARE WRITTEN IN THE MODEL HISTORY...
      IF(LINIT) THEN
C========UNINITIALIZED FIELDS ARE SKIPPED
           READ(IUNIT) FHOUR,IDATE
           DO 92 IP=1,NPROGS
           READ(IUNIT)
   92      CONTINUE
           DO 94 IP=1,NPROGG
           READ(IUNIT)
   94      CONTINUE
           WRITE(6,7012) FHOUR,IDATE
 7012      FORMAT(' FHOUR=',F10.2,' IDATE=',4I4,' IC: DATA SKIPPED')
C========INITIALIZED FIELDS ARE SKIPPED
           READ(IUNIT) FHOUR,IDATE
           DO 96 IP=1,NPROGS
           READ(IUNIT)
   96      CONTINUE
           DO 98 IP=1,NPROGG
           READ(IUNIT)
   98      CONTINUE
           WRITE(6,7012) FHOUR,IDATE
      END IF
CCC....END OF SPECIAL HANDLING OF INITIAL CONDITIONS
C===== REFERENCE POINT FROM WHICH PROGRAM READS NEW TIME RECORD =====
  123 CONTINUE
      READ(IUNIT,END=130) FHOUR,IDATE
      GO TO 132
  130 IUNIT=IUNIT+1
      GO TO 600
  132 CONTINUE
      WRITE(6,6800) FHOUR,IDATE
 6800 FORMAT(' DATA READ FHOUR, IDATE =',F10.2,4(I3))
      IREAD=IREAD+1
C.....READ AND ACCUMULATE PROGNOSTIC SPECTRAL FIELDS
      DO 200 IFLD=1,NPROGS
        CALL SGREAD(FLDSPC,IUNIT,LENSPC)
        CALL ACCMS1(FLDSPC,QPROGS(1,1,1,IFLD))
  200 CONTINUE
C.....READ AND ACCUMULATE PROGNOSTIC GRID POINT FIELDS
      DO 202 IFLD=1,NPROGG
        CALL SGREAD(FIELDG,IUNIT,LENGRD)
        CALL ACCMG1(FIELDG,QPROGG(1,1,IFLD))
  202 CONTINUE
C.....READ AND ACCUMULATE DIAGNOSTIC GRID POINT FIELDS
      DO 204 IFLD=1,NDIAGG
        CALL SGREAD(FIELDG,IUNIT,LENGRD)
        CALL ACCMG1(FIELDG,QDIAGG(1,1,IFLD))
  204 CONTINUE
C.....READ AND ACCUMULATE DIAGNOSTIC HEATING FIELDS
      DO 206 IFLD=1,NDIABG
        CALL SGREAD(FIELDG,IUNIT,LENGRD)
        CALL ACCMG1(FIELDG,QDIABG(1,1,IFLD))
  206 CONTINUE
      WRITE(6,7200) FHOUR,IREAD
 7200 FORMAT(' DATA PROCESSED FOR FHOUR',F10.1,' IREAD= ',I4)
C==== END OF ACCUMULATIONS ===================
      GO TO 123
  600 CONTINUE
C=====DIVIDE BY NUMBER OF READS AND WRITE DATA TO CFS     ======
      XREAD=IREAD
      JUNIT=60
      CALL ARRDIV(QPROGS,XREAD,2*NLEG*NMP*NPROGS)
      CALL ARRDIV(QPROGG,XREAD,NLONG*NLATG*NPROGG)
      CALL ARRDIV(QDIAGG,XREAD,NLONG*NLATG*NDIAGG)
      CALL ARRDIV(QDIABG,XREAD,NLONG*NLATG*NDIABG)
C.....get the wanted fields
      DO 320 K=1,NMP
      DO 320 J=1,NLEG
      DO 320 I=1,2
         FLDSPC(I,J,K)=QPROGS(I,J,K,1)
  320 CONTINUE
      IWRITE=IWRITE+1
      CALL EVLSCA(FLDSPC,FIELDG)
      CALL TRANSF(FIELDG,OUTPUT(1,1,1))
      CALL TRANSF(QDIAGG(1,1,7),OUTPUT(1,1,2))
      CALL TRANSF(QDIAGG(1,1,8),OUTPUT(1,1,3))
      CALL TRANSF(QDIAGG(1,1,9),OUTPUT(1,1,4))
      CALL TRANSF(QDIAGG(1,1,10),OUTPUT(1,1,5))
      CALL TRANSF(QDIAGG(1,1,20),OUTPUT(1,1,6))
      CALL TRANSF(QDIAGG(1,1,21),OUTPUT(1,1,7))
C.....write out slected fields
      CALL XWRITE(OUTPUT,JUNIT,NX*NY*7)
      IF(FHOUR-FHREND .LE. -.01) THEN
      CALL ARFILL(QPROGS,0.0,2*NLEG*NMP*NPROGS)
      CALL ARFILL(QPROGG,0.0,NLONG*NLATG*NPROGG)
      CALL ARFILL(QDIAGG,0.0,NLONG*NLATG*NDIAGG)
      CALL ARFILL(QDIABG,0.0,NLONG*NLATG*NDIABG)
          IREAD=0
          GO TO 123
      END IF
C     WRITE(60,9999) OUTPUT
 9999 FORMAT(6E12.5)
      STOP
      END
 
      SUBROUTINE ARFILL(ARRAY,VALUE,N)
      DIMENSION ARRAY(N)
      DO 100 I=1,N
      ARRAY(I)=VALUE
  100 CONTINUE
      RETURN
      END
 
      SUBROUTINE ARRDIV(ARRAY,VALUE,N)
      DIMENSION ARRAY(N)
      DO 100 I=1,N
      ARRAY(I)=ARRAY(I)/VALUE
  100 CONTINUE
      RETURN
      END
 
      SUBROUTINE ACCMG3(ARR1,ARR2,ARR3,X,ARRSUM)
      PARAMETER(NLONG=128,NLATG=102)
      DIMENSION ARR1(NLONG,NLATG),ARR2(NLONG,NLATG)
      DIMENSION ARR3(NLONG,NLATG),ARRSUM(NLONG,NLATG)
      DO 100 J=1,NLATG
      DO 100 I=1,NLONG
      ARRSUM(I,J)=ARRSUM(I,J)+X*ARR1(I,J)*ARR2(I,J)*ARR3(I,J)
  100 CONTINUE
      RETURN
      END
 
      SUBROUTINE ACCMS1(ARRS,ACCUMS)
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1)
      PARAMETER(NM=NW)
      PARAMETER(NMP=NW+1)
      DIMENSION ARRS(2,NLEG,NMP),ACCUMS(2,NLEG,NMP)
      DO 100 IM=1,NMP
      DO 100 N=1,NLEG
      DO 100 IC=1,2
      ACCUMS(IC,N,IM)=ACCUMS(IC,N,IM)+ARRS(IC,N,IM)
  100 CONTINUE
      RETURN
      END
 
      SUBROUTINE ACCMG1(ARRG,ACCGRD)
      PARAMETER(NLONG=128,NLATG=102)
      DIMENSION ARRG(NLONG,NLATG),ACCGRD(NLONG,NLATG)
      DO 100 J=1,NLATG
      DO 100 I=1,NLONG
      ACCGRD(I,J)=ACCGRD(I,J)+ARRG(I,J)
  100 CONTINUE
      RETURN
      END
 
      SUBROUTINE SGREAD(ARRY,IUNIT,N)
      CHARACTER*8 LABEL(6)
      DIMENSION ARRY(N)
      READ(IUNIT) LABEL,ARRY
      RETURN
      END
 
      SUBROUTINE XWRITE(ARRY,IUNIT,N)
      DIMENSION ARRY(N)
      WRITE(IUNIT) ARRY
      RETURN
      END
 
      SUBROUTINE EVLSCA(ARRS,ARRP)
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1,NM=NW,NMP=NM+1)
      PARAMETER(NLATG=102,NLONG=128,NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      COMMON/POLY1/PLEG(NLEG,NMP,NLATG),DPLEG(NLEG,NMP,NLATG)
      COMMON/FFTAR1/TRIGS(IMAXT),IFAX(10)
      COMMON/FFTAR2/ARRAY(NLONGP,NLATG),WORK(NLONGP,NLATG)
      DIMENSION ARRS(2,NLEG,NMP),ARRP(NLONG,NLATG)
      IM1=2*NMP+1
      IM2=NLONGP
      DO 200 J=1,NLATG
      DO 120 IM=1,NMP
      DO 120 IC=1,2
      YSUM=0.0
      DO 100 N=1,NLEG
      YSUM=YSUM+ARRS(IC,N,IM)*PLEG(N,IM,J)
  100 CONTINUE
      ARRAY((IM-1)*2+IC,J)=YSUM
  120 CONTINUE
      DO 130 IM=IM1,IM2
      ARRAY(IM,J)=0.0
  130 CONTINUE
  200 CONTINUE
      INC=1
      ISIGN=+1
      JUMP=NLONGP
      LOT=NLATG
      CALL FFT991(ARRAY,WORK,TRIGS,IFAX,INC,JUMP,NLONG,LOT,ISIGN)
      DO 240 J=1,NLATG
      DO 240 I=1,NLONG
      ARRP(I,J)=ARRAY(I,J)
  240 CONTINUE
      RETURN
      END
 
      SUBROUTINE FTRANS(GRID,WAVE)
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1,NM=NW,NMP=NM+1)
      PARAMETER(NLATG=102,NLONG=128,NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      COMMON/FFTAR1/TRIGS(IMAXT),IFAX(10)
      COMMON/FFTAR2/ARRAY(NLONGP,NLATG),WORK(NLONGP,NLATG)
      DIMENSION GRID(NLONG,NLATG),WAVE(2,NMP,NLATG)
      DO 60 JG=1,NLATG
      DO 40 IG=1,NLONG
      ARRAY(IG,JG)=GRID(IG,JG)
   40 CONTINUE
      ARRAY(NLONGP,JG)=0.0
   60 CONTINUE
      ISIGN=-1
      INC=1
      JUMP=NLONGP
      LOT=NLATG
      CALL FFT991(ARRAY,WORK,TRIGS,IFAX,INC,JUMP,NLONG,LOT,ISIGN)
      DO 200 JG=1,NLATG
      DO 200 IM=1,NMP
      WAVE(1,IM,JG)=ARRAY(2*IM-1,JG)
      WAVE(2,IM,JG)=ARRAY(2*IM  ,JG)
  200 CONTINUE
      RETURN
      END
 
      SUBROUTINE GCMCMF(UVEC,VVEC,CMF)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C   PROGRAM TO TAKE COMPONENTS OF ANY FLUX (UVEC,VVEC) ON THE GRID,    C
C   AND COMPUTE SPECTRAL CONVERGENCE (CMF).                            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1,NM=NW,NMP=NM+1)
      PARAMETER(NLATG=102,NLONG=128,NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      PARAMETER(KHALF=(NLATG+1)/2)
      PARAMETER(EA=6.371E+06,GRAV=9.8)
      COMMON/POLY1/PLEG(NLEG,NMP,NLATG),DPLEG(NLEG,NMP,NLATG)
      COMMON/GAUSS/RADG(NLATG),GWGT(NLATG)
      DIMENSION UVEC(NLONG,NLATG),VVEC(NLONG,NLATG),CMF(2,NLEG,NMP)
      DIMENSION USPEC(2,NMP,NLATG),VSPEC(2,NMP,NLATG)
      DIMENSION UM(NLONGP),VM(NLONGP)
      CALL FTRANS(UVEC,USPEC)
      CALL FTRANS(VVEC,VSPEC)
      IM1=2*NMP+1
      IM2=NLONGP
      DO 10 IM=1,NMP
      DO 10 N=1,NLEG
      DO 10 IC=1,2
      CMF(IC,N,IM)=0.0
   10 CONTINUE
      DO 300 J=1,NLATG
      COSR=COS(RADG(J))
      DO 120 IM=1,NMP
      DO 120 IC=1,2
      UM((IM-1)*2+IC)=USPEC(IC,IM,J)*COSR
      VM((IM-1)*2+IC)=VSPEC(IC,IM,J)*COSR
  120 CONTINUE
      DO 130 IM=IM1,IM2
      UM(IM)=0.0
      VM(IM)=0.0
  130 CONTINUE
      DO 200 IM=1,NMP
      XM=(IM-1)
      UREAL=UM((IM-1)*2+1)
      UIMAG=UM((IM-1)*2+2)
      VREAL=VM((IM-1)*2+1)
      VIMAG=VM((IM-1)*2+2)
      DO 180 N=1,NLEG
      CRE=(+XM*UIMAG*PLEG(N,IM,J)+VREAL*DPLEG(N,IM,J))/(COSR*COSR)
      CIM=(-XM*UREAL*PLEG(N,IM,J)+VIMAG*DPLEG(N,IM,J))/(COSR*COSR)
      CMF(1,N,IM)=CMF(1,N,IM)+CRE*GWGT(J)
      CMF(2,N,IM)=CMF(2,N,IM)+CIM*GWGT(J)
  180 CONTINUE
  200 CONTINUE
  300 CONTINUE
      DO 310 IM=1,NMP
      DO 310 N=1,NLEG
      DO 310 IC=1,2
      CMF(IC,N,IM)=CMF(IC,N,IM)/EA
  310 CONTINUE
      RETURN
      END
 
      SUBROUTINE GRDCMF(UVEC,VVEC,CMFGRD)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C   PROGRAM TO TAKE COMPONENTS OF ANY FLUX (UVEC,VVEC) ON THE GRID,    C
C   AND COMPUTE CONVERGENCE WITH FINITE-DIFFERENCES                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PARAMETER(NLATG=102,NLONG=128,NLATGM=NLATG-1)
      PARAMETER(EA=6.371E+06,GRAV=9.8)
      COMMON/GAUSS/RADG(NLATG),GWGT(NLATG)
      DIMENSION UVEC(NLONG,NLATG),VVEC(NLONG,NLATG),CMFGRD(NLONG,NLATG)
      DIMENSION XLAT(NLATG)
      DIMENSION IP1(NLONG),IM1(NLONG)
      PI=ACOS(-1.0)
      XNLONG=NLONG
      DO 10 J=1,NLATG
      XLAT(J)=SIN(RADG(J))
   10 CONTINUE
      DLON=2.0*PI/XNLONG
      DO 30 I=1,NLONG
      IP1(I)=I+1
      IM1(I)=I-1
      IF(I .EQ. NLONG) IP1(I)=1
      IF(I .EQ.     1) IM1(I)=NLONG
   30 CONTINUE
      DO 120 J=2,NLATGM
      COSP=COS(RADG(J+1))
      COSR=COS(RADG(J  ))
      COSM=COS(RADG(J-1))
      DLAT=(XLAT(J+1) - XLAT(J-1))
      DO 100 I=1,NLONG
      XDIFF=(UVEC(IP1(I),J) - UVEC(IM1(I),J))/(COSR*2.0*DLON)
      YDIFF=(VVEC(I,J+1)*COSP - VVEC(I,J-1)*COSM)/DLAT
      CMFGRD(I,J)=-(XDIFF+YDIFF)/EA
  100 CONTINUE
  120 CONTINUE
      DO 130 I=1,NLONG
      CMFGRD(I,1)=0.0
      CMFGRD(I,NLATG)=0.0
  130 CONTINUE
      RETURN
      END
 
      SUBROUTINE EVLU(VELP,STRM,UWIND)
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1,NMP=NW+1)
      PARAMETER(NLATG=102,NLONG=128,NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      PARAMETER(EA=6.371E+06,GRAV=9.8)
      COMMON/GAUSS/RADG(NLATG),GWGT(NLATG)
      COMMON/POLY1/PLEG(NLEG,NMP,NLATG),DPLEG(NLEG,NMP,NLATG)
      COMMON/FFTAR1/TRIGS(IMAXT),IFAX(10)
      COMMON/FFTAR2/ARRAY(NLONGP,NLATG),WORK(NLONGP,NLATG)
      DIMENSION VELP(2,NLEG,NMP),STRM(2,NLEG,NMP)
      DIMENSION UWIND(NLONG,NLATG)
      IM1=2*NMP+1
      IM2=NLONGP
      DO 200 J=1,NLATG
      CONST=EA*COS(RADG(J))
      DO 120 IM=1,NMP
      XM=IM-1
      YSUMR=0.0
      YSUMI=0.0
      IF(IM .GT. 1) THEN
         NLOW=1
      ELSE
         NLOW=2
      END IF
      DO 100 N=NLOW,NLEG
      XN=XM+N-1
      YSUMR=YSUMR+(-XM*VELP(2,N,IM)* PLEG(N,IM,J)
     1             -   STRM(1,N,IM)*DPLEG(N,IM,J))
      YSUMI=YSUMI+( XM*VELP(1,N,IM)* PLEG(N,IM,J)
     1             -   STRM(2,N,IM)*DPLEG(N,IM,J))
  100 CONTINUE
      ARRAY((IM-1)*2+1,J)=YSUMR/CONST
      ARRAY((IM-1)*2+2,J)=YSUMI/CONST
  120 CONTINUE
      DO 130 IM=IM1,IM2
      ARRAY(IM,J)=0.0
  130 CONTINUE
  200 CONTINUE
      INC=1
      ISIGN=+1
      JUMP=NLONGP
      LOT=NLATG
      CALL FFT991(ARRAY,WORK,TRIGS,IFAX,INC,JUMP,NLONG,LOT,ISIGN)
      DO 240 J=1,NLATG
      DO 240 I=1,NLONG
      UWIND(I,J)=ARRAY(I,J)
  240 CONTINUE
      RETURN
      END
 
      SUBROUTINE EVLV(VELP,STRM,VWIND)
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1,NMP=NW+1)
      PARAMETER(NLATG=102,NLONG=128,NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      PARAMETER(EA=6.371E+06,GRAV=9.8)
      COMMON/GAUSS/RADG(NLATG),GWGT(NLATG)
      COMMON/POLY1/PLEG(NLEG,NMP,NLATG),DPLEG(NLEG,NMP,NLATG)
      COMMON/FFTAR1/TRIGS(IMAXT),IFAX(10)
      COMMON/FFTAR2/ARRAY(NLONGP,NLATG),WORK(NLONGP,NLATG)
      DIMENSION VELP(2,NLEG,NMP),STRM(2,NLEG,NMP)
      DIMENSION VWIND(NLONG,NLATG)
      IM1=2*NMP+1
      IM2=NLONGP
      DO 200 J=1,NLATG
      CONST=EA*COS(RADG(J))
      DO 120 IM=1,NMP
      XM=IM-1
      YSUMR=0.0
      YSUMI=0.0
      IF(IM .GT. 1) THEN
         NLOW=1
      ELSE
         NLOW=2
      END IF
      DO 100 N=NLOW,NLEG
      XN=XM+N-1
      YSUMR=YSUMR+(-XM*STRM(2,N,IM)* PLEG(N,IM,J)
     1             +   VELP(1,N,IM)*DPLEG(N,IM,J))
      YSUMI=YSUMI+( XM*STRM(1,N,IM)* PLEG(N,IM,J)
     1             +   VELP(2,N,IM)*DPLEG(N,IM,J))
  100 CONTINUE
      ARRAY((IM-1)*2+1,J)=YSUMR/CONST
      ARRAY((IM-1)*2+2,J)=YSUMI/CONST
  120 CONTINUE
      DO 130 IM=IM1,IM2
      ARRAY(IM,J)=0.0
  130 CONTINUE
  200 CONTINUE
      INC=1
      ISIGN=+1
      JUMP=NLONGP
      LOT=NLATG
      CALL FFT991(ARRAY,WORK,TRIGS,IFAX,INC,JUMP,NLONG,LOT,ISIGN)
      DO 240 J=1,NLATG
      DO 240 I=1,NLONG
      VWIND(I,J)=ARRAY(I,J)
  240 CONTINUE
      RETURN
      END
 
      SUBROUTINE DL2INV(ARRIS,ARROS,EA,NLEG,NMP,NLV)
      DIMENSION ARRIS(2,NLEG,NMP,NLV),ARROS(2,NLEG,NMP,NLV)
      DO 100 K=1,NLV
C.....HANDLE ZERO ZONAL WAVENUMBER SEPARATELY
      ARROS(1,1,1,K)=0.0
      ARROS(2,1,1,K)=0.0
      DO 40 N=2,NLEG
      XN=N-1
      FACT=-EA*EA/(XN*(XN+1.0))
      ARROS(1,N,1,K)=FACT*ARRIS(1,N,1,K)
      ARROS(2,N,1,K)=FACT*ARRIS(2,N,1,K)
   40 CONTINUE
C.....NONZERO ZONAL WAVENUMBERS
      DO 80 IM=2,NMP
      DO 80 N=1,NLEG
      XN=(IM-1)+N-1
      FACT=-EA*EA/(XN*(XN+1.0))
      ARROS(1,N,IM,K)=FACT*ARRIS(1,N,IM,K)
      ARROS(2,N,IM,K)=FACT*ARRIS(2,N,IM,K)
   80 CONTINUE
  100 CONTINUE
      RETURN
      END
 
      SUBROUTINE SETDAY
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     SETS THE NUMBER OF DAYS PER YEAR (MDAYY) FROM 1960 TO 1999       C
C     SETS THE NUMBER OF DAYS PER MONTH (MDAYM) FOR EACH YEAR          C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      COMMON/XDAY/MDAYY(40),MDAYM(12,40)
      DO 100 IY=1,40
      MDAYM(1,IY)=31
      MDAYM(2,IY)=28
      IF(MOD((IY-1),4) .EQ. 0) THEN
         MDAYM(2,IY)=29
      END IF
      MDAYM(3,IY)=31
      MDAYM(4,IY)=30
      MDAYM(5,IY)=31
      MDAYM(6,IY)=30
      MDAYM(7,IY)=31
      MDAYM(8,IY)=31
      MDAYM(9,IY)=30
      MDAYM(10,IY)=31
      MDAYM(11,IY)=30
      MDAYM(12,IY)=31
  100 CONTINUE
      DO 200 IY=1,40
      KDAY=0
      DO 180 IM=1,12
      KDAY=KDAY+MDAYM(IM,IY)
  180 CONTINUE
      MDAYY(IY)=KDAY
  200 CONTINUE
      RETURN
      END
 
      SUBROUTINE FHR(HR,IDAY,MON,IYR,FHOUR)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     COMPUTES THE TIME (IN HOURS) OF THE DATE SPECIFIED BY            C
C     (HR,IDAY,IMON,IYR) RELATIVE TO 00 UTC JAN 1, 1960 (WHICH IS      C
C     CONSIDERED TO BE TIME 0.0)                                       C
C     THE SUBROUTINE IS GOOD FOR DATES FROM 1960 TO 1999               C
C     THE YEAR (IYR) IS SPECIFIED BY 2 DIGITS (E.G. 87)                C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      COMMON/XDAY/MDAYY(40),MDAYM(12,40)
C.....INDXY IS THE INDEX OF THE YEAR IN ARRAYS MDAYY,MDAYM
      INDXY=IYR-60+1
C.....NDAYPY IS THE NUMBER OF DAYS IN ALL PREVIOUS YEARS
      IF(INDXY .GT. 1) THEN
         NY=INDXY-1
         NDAYPY=0
         DO 10 IY=1,NY
         NDAYPY=NDAYPY+MDAYY(IY)
   10    CONTINUE
      ELSE
         NDAYPY=0
      END IF
C.....NDAYPM IS THE NUMBER OF DAYS IN ALL PREVIOUS MONTHS IN THE YEAR
      IF(MON .GT. 1) THEN
         NM=MON-1
         NDAYPM=0
         DO 20 IM=1,NM
         NDAYPM=NDAYPM+MDAYM(IM,INDXY)
   20    CONTINUE
      ELSE
         NDAYPM=0
      END IF
C.....NDAY IS THE NUMBER OF WHOLE DAYS
      NDAY=NDAYPY+NDAYPM+IDAY-1
      FHOUR=NDAY*24 + HR
      RETURN
      END

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCGAU00010
C REGTOGAU - PROGRAM TO INTERPOLATE FROM REGULAR TO GAUSSIAN GRID      CGAU00020
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCGAU00030
      SUBROUTINE TRANSF(ARRAYP,ARRAYG)
      PARAMETER (LATIN=102,LONIN=128,LONOUT=72,LATOUT=46,               GAU00040
     *LATINP=LATIN+1,LONINP=LONIN+1,LATOUP=LATOUT+1,LONOUP=LONOUT+1,    GAU00050
     *LNALNB=(LONIN-1)/LONOUT+3,LTALTB=(LATIN-1)/LATOUT+3)              GAU00060
      COMMON/XGRDNT/                                                    GAU00070
     1 ALONP(LONIN),ALATP(LATIN),ALONE(LONINP),ALATE(LATINP),           GAU00080
     A          BLONP(LONOUT),BLATP(LATOUT),BLONE(LONOUP),BLATE(LATOUP),GAU00090
     B          TRPLON(LNALNB,LONOUT),TRPLAT(LTALTB,LATOUT),            GAU00100
     C          LONTRP(LNALNB,LONOUT),LATTRP(LTALTB,LATOUT),            GAU00110
     D          NLNTRP(LONOUT),NLTTRP(LATOUT)                           GAU00120
      DIMENSION ARRAYP(LONIN,LATIN),ARRAYG(LONOUT,LATOUT)               GAU00130
C                                                                       GAU00180
C     UNDERFLOWS MAY HAVE TO BE SUPPRESSED                              GAU00190
C                                                                       GAU00200
C     CALL ERRSET(201,256,-1,1,0)                                       GAU00210
      CALL XSTGRD(LONIN,LATIN,LONOUT,LATOUT)                            GAU00220
      CALL XINTRP(ARRAYP,ARRAYG)                                        GAU00280
      RETURN                                                            GAU00330
      END                                                               GAU00340
                                                                        GAU00350
      SUBROUTINE XSTGRD                                                 GAU00360
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC GAU00370
C  THIS PROGRAM SETS UP INTERPOLATION ARRAYS                            GAU00380
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC GAU00390
      PARAMETER (LATIN=102,LONIN=128,LONOUT=72,LATOUT=46,               GAU00400
     *LATINP=LATIN+1,LONINP=LONIN+1,LATOUP=LATOUT+1,LONOUP=LONOUT+1,    GAU00410
     *LNALNB=(LONIN-1)/LONOUT+3,LTALTB=(LATIN-1)/LATOUT+3)              GAU00420
      COMMON/XGRDNT/                                                    GAU00430
     1 ALONP(LONIN),ALATP(LATIN),ALONE(LONINP),ALATE(LATINP),           GAU00440
     A          BLONP(LONOUT),BLATP(LATOUT),BLONE(LONOUP),BLATE(LATOUP),GAU00450
     B          TRPLON(LNALNB,LONOUT),TRPLAT(LTALTB,LATOUT),            GAU00460
     C          LONTRP(LNALNB,LONOUT),LATTRP(LTALTB,LATOUT),            GAU00470
     D          NLNTRP(LONOUT),NLTTRP(LATOUT)                           GAU00480
C   ##############################################################      GAU00490
C                                                                       GAU00500
C    GENERAL PURPOSE HORIZONTAL INTERPOLATOR                            GAU00510
C    CAN INTERPOLATE REGULAR TO REGULAR (COARSE OR FINE)                GAU00520
C                    REGULAR TO GAUSSIAN                                GAU00530
C                    GAUSSIAN TO REGULAR (SET UP THIS WAY HERE)         GAU00540
C                    GAUSSIAN TO GAUSSIAN                               GAU00550
C    WILL REORIENT REGULAR INPUT DATA AS NEEDED AND PUT DATA OUT ON     GAU00560
C    GRID ORIENTED WITH THE NORTH POLE AND GREENWICH AS THE FIRST POINT GAU00570
C    DATA CAN BE SUBSEQUENTLY MASKED FOR LAND-SEA DEPENDENCE OR         GAU00580
C    OTHER RELATIONSHIPS                                                GAU00590
C                                                                       GAU00600
C                                                                       GAU00610
C     UNDERFLOWS MAY HAVE TO BE SUPPRESSED                              GAU00620
C                                                                       GAU00630
C     CALL ERRSET(201,256,-1,1,0)                                       GAU00640
C                                                                       GAU00650
C     SET UNDEFINED VALUE FOR INPUT DATA FOUND AT LOCATIONS WHICH       GAU00660
C     ARE NOT TO BE INCLUDED IN INTERPOLATION AND WHICH WILL BE         GAU00670
C     USE ON OUTPUT DATA IF NO VALID DATA LOCATIONS ARE FOUND WITHIN    GAU00680
C     OUTPUT LOCATION                                                   GAU00690
      UNDEF=-999.0                                                      GAU00700
C                                                                       GAU00710
C     HPINEG IS FOR FIRST LATITUDE IN RADIANS                           GAU00720
C     PINEG IS FOR FIRST LONGITUDE IN RADIANS                           GAU00730
C                                                                       GAU00740
      PI=4.0*ATAN(1.0)                                                  GAU00750
      HPINEG =  PI/2.0                                                  GAU00760
      PINEG = 0.                                                        GAU00770
C                                                                       GAU00780
C     USE SETLON FOR BOTH REGULAR AND GAUSSIAN GRIDS                    GAU00790
C     USE SETLAT FOR REGULAR GRIDS AND GLTTS FOR GAUSSIAN GRIDS         GAU00800
C     USE SETLON AND SETLAT/GLTTS FOR BOTH INPUT AND OUTPUT FIELDS      GAU00810
C                                                                       GAU00820
      CALL SETLON(PINEG,LONIN,ALONP)                                    GAU00830
      CALL GLTTS(LATIN,ALATP)                                           GAU00840
C     CALL SETLAT(HPINEG,LATIN,ALATP)                                   GAU00850
      CALL SETLON(0.0,LONOUT,BLONP)                                     GAU00860
      CALL SETLAT(HPINEG,LATOUT,BLATP)                                  GAU00850
C     CALL GLTTS(LATOUT,BLATP)                                          GAU00870
C                                                                       GAU00880
C     CALL TERPWT ONCE TO SETUP WEIGHTING FACTORS AND INDICES FOR       GAU00890
C     GRID INTERPOLATION                                                GAU00900
C                                                                       GAU00910
      CALL TERPWT(ALONP,ALATP,LONIN,LATIN,ALONE,ALATE,                  GAU00920
     A            BLONP,BLATP,LONOUT,LATOUT,BLONE,BLATE,                GAU00930
     B            TRPLON,LONTRP,NLNTRP,TRPLAT,LATTRP,NLTTRP)            GAU00940
      RETURN                                                            GAU00950
      END                                                               GAU00960
                                                                        GAU00970
      SUBROUTINE XINTRP(FIELDA,FIELDB)                                  GAU00980
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC GAU00990
C  THIS PROGRAM INTERPOLATES FROM GAUSSIAN TO REGULAR GRID              GAU01000
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC GAU01010
      PARAMETER (LATIN=102,LONIN=128, LATOUT=46,LONOUT=72,              GAU01020
     *LATINP=LATIN+1,LONINP=LONIN+1,LATOUP=LATOUT+1,LONOUP=LONOUT+1,    GAU01030
     *LNALNB=(LONIN-1)/LONOUT+3,LTALTB=(LATIN-1)/LATOUT+3)              GAU01040
      COMMON/XGRDNT/                                                    GAU01050
     1 ALONP(LONIN),ALATP(LATIN),ALONE(LONINP),ALATE(LATINP),           GAU01060
     A          BLONP(LONOUT),BLATP(LATOUT),BLONE(LONOUP),BLATE(LATOUP),GAU01070
     B          TRPLON(LNALNB,LONOUT),TRPLAT(LTALTB,LATOUT),            GAU01080
     C          LONTRP(LNALNB,LONOUT),LATTRP(LTALTB,LATOUT),            GAU01090
     D          NLNTRP(LONOUT),NLTTRP(LATOUT)                           GAU01100
      DIMENSION FIELDA(LONIN,LATIN),FIELDB(LONOUT,LATOUT)               GAU01110
      CALL TERPLT(FIELDA,LONIN,LATIN,UNDEF,FIELDB,LONOUT,LATOUT,        GAU01120
     A            TRPLON,LONTRP,NLNTRP,TRPLAT,LATTRP,NLTTRP)            GAU01130
C                                                                       GAU01140
C     SET VALUES AT POLES TO THEIR ZONAL AVERAGE                        GAU01150
C                                                                       GAU01160
      CALL POLAVG(FIELDB,LONOUT,LATOUT)                                 GAU01170
C                                                                       GAU01180
      RETURN                                                            GAU01190
      END                                                               GAU01200
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
