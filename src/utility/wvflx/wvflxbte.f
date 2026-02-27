CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C    PROGRAM TO compute 2-d Plumb transient eddy activity flux using   C
C    PRESSURE HISTORY FIELDS.                                          C
C                                                                      C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C   Needed Subroutings Are in Source Files:
C           fftgcm.f  genpnme.f   glats.f
C
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1)
      PARAMETER(NM=NW)
      PARAMETER(NMP=NW+1)
      PARAMETER(NLONG=128)
      PARAMETER(NLATG=102)
      PARAMETER(NLEGP=NLEG+1)
      PARAMETER(NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      PARAMETER(KHALF=(NLATG+1)/2)
      COMMON/GAUSS/RADG(NLATG),GWGT(NLATG)
      COMMON/POLY1/PLEG(NLEG,NMP,NLATG),DPLEG(NLEG,NMP,NLATG)
      COMMON/FFTAR1/TRIGS(IMAXT),IFAX(10)
      COMMON/FFTAR2/ARRAY(NLONGP,NLATG),WORK(NLONGP,NLATG)
      COMMON/EPSLON/EPS(NLEG,NMP),XXN(NLEG,NMP),XXM(NMP)
      COMMON/CORCOS/CORIOLIS(NLATG),PLEVEL(NMAND)  
      COMMON/PTV/AVSPRV(2,NLEG,NMP,NMAND),AVGDRV(NLONG,NLATG,NMAND),
     1           AVGSPS(2,NLEG,NMP,NMAND),AVDPTT(NLONG,NLATG,NMAND),
     2           AVGPTV(NLONG,NLATG,MAND),PTVT3(NLONG,NLATG,MAND),
     3           AVGPTT(NLONG,NLATG,NMAND),GLBAVT(NMAND)
      DIMENSION AVGGDT(NLONG,NLATG,NMAND),AVGGDH(NLONG,NLATG,NMAND)
      REAL*8    COLRAD(KHALF),WGT(KHALF),WGTCS(KHALF),RCS2(KHALF)
      DIMENSION AVGGDU(NLONG,NLATG,NMAND),AVGGDV(NLONG,NLATG,NMAND)
      DIMENSION AVGDU2(NLONG,NLATG,NMAND),AVGDV2(NLONG,NLATG,NMAND)
      DIMENSION AVGSPU(2,NLEG,NMP,NMAND),AVGSPV(2,NLEG,NMP,NMAND)
      DIMENSION SGRPVX(2,NLEG,NMP,MAND),SGRPVY(2,NLEG,NMP,MAND)
      DIMENSION GGRPVX(NLONG,NLATG,MAND),GGRPVY(NLONG,NLATG,MAND)
      DIMENSION AVSPTV(2,NLEG,NMP,MAND)
      DIMENSION AVEDUU(NLONG,NLATG,MAND),AVEDVV(NLONG,NLATG,MAND)
      DIMENSION AVEDUV(NLONG,NLATG,MAND),AVEDUT(NLONG,NLATG,MAND)
      DIMENSION AVEDVT(NLONG,NLATG,MAND),AVEDTT(NLONG,NLATG,MAND)
      DIMENSION AVEDES(NLONG,NLATG,MAND)                          
      DIMENSION AVGDHX(NLONG,NLATG,MAND),AVGDHY(NLONG,NLATG,MAND) 
      DIMENSION AVGDHZ(NLONG,NLATG,MAND),DIVH(NLONG,NLATG,3)
      DIMENSION AVEDUQ(NLONG,NLATG,MAND),AVEDVQ(NLONG,NLATG,MAND)
      DIMENSION EDYPTV(NLONG,NLATG,MAND),EDYGRV(NLONG,NLATG,MAND)
      DIMENSION EDYGDU(NLONG,NLATG,MAND),EDYGDV(NLONG,NLATG,MAND)
      DIMENSION XMR(NLONG,NLATG,MAND),YMR(NLONG,NLATG,MAND)
      DIMENSION ZMR(NLONG,NLATG,MAND),XMT(NLONG,NLATG,MAND)
      DIMENSION YMT(NLONG,NLATG,MAND),ZMT(NLONG,NLATG,MAND)
      DIMENSION DIVMT(NLONG,NLATG,3), DIVMR(NLONG,NLATG,3)
      DIMENSION COMPMT(NLONG,NLATG,3),COMPMR(NLONG,NLATG,3)
      DIMENSION COSLAT(NLATG),SINLAT(NLATG),POOVRP(NMAND)
      DIMENSION XMM(NLONG,NLATG,MAND),GLBAVH(NMAND)
      DIMENSION AVGGDS(NLONG,NLATG,NMAND)
      DIMENSION EDYGDS(NLONG,NLATG,MAND)
      DIMENSION WORKSP(2,NLEG,NMP,MAND),UGRGRQ(NLONG,NLATG,3)
      DIMENSION SGRESX(2,NLEG,NMP,MAND),SGRESY(2,NLEG,NMP,MAND)
      DIMENSION GRDESX(NLONG,NLATG,MAND),GRDESY(NLONG,NLATG,MAND)
      DIMENSION EVCTRX(NLONG,NLATG,MAND),EVCTRY(NLONG,NLATG,MAND)
      DIMENSION GRMGQX(NLONG,NLATG,MAND),GRMGQY(NLONG,NLATG,MAND)
      DIMENSION SRMGQX(2,NLEG,NMP,MAND),SRMGQY(2,NLEG,NMP,MAND)
      DIMENSION XGGRPV(NLONG,NLATG,MAND),SGGRPV(2,NLEG,NMP,MAND)
      OPEN(10,FILE='~/ppt/gcm/gtwv87qg.hp',FORM='UNFORMATTED',
     +RECORDTYPE='STREAM',CONVERT='BIG_ENDIAN')
      OPEN(60,FILE='/data/pool/peng/pbhpwv87qg',FORM='UNFORMATTED')
C     OPEN(61,FILE='avgptt.dat',FORM='FORMATTED')
      DATA PLEVEL/100000.,85000.,70000.,50000.,30000.,20000.,10000./
      PI=ACOS(-1.0)
      LENS1=2*NLEG*NMP
      LENS2=2*NLEG*NMP*NMAND
      LENG1=NLONG*NLATG
      LENG2=NLONG*NLATG*NMAND
      LENG3=NLONG*NLATG*MAND
      LENG4=NLONG*NLATG*3
      R=6.371E+06
      RR=R**2
      GRAVITY=9.8
      UNDEF=-9.99E+33
      CALL GLATS(KHALF,COLRAD,WGT,WGTCS,RCS2)
      DO 30 K=1,KHALF
      RADG(K)=PI/2.0 - REAL(COLRAD(K))
      RADG(NLATG-K+1)=-RADG(K)
      GWGT(K)=REAL(WGT(K))
      GWGT(NLATG-K+1)=+GWGT(K)
   30 CONTINUE
      DO 40 JG=1,NLATG
      CALL GENPNME(RADG(JG),PLEG(1,1,JG),DPLEG(1,1,JG))
   40 CONTINUE
      PRINT 101
  101 FORMAT(' finished call genpnme')
C.....Compute the Coriolis Parameter
      OMEGA=2*PI/(24.*3600.)
      DO 35 K=1,NLATG
         CORIOLIS(K)=2*OMEGA*SIN(RADG(K))
         CORIOLISO=2*OMEGA*SIN(PI/4.)
         COSLAT(K)=COS(RADG(K))
         SINLAT(K)=SIN(RADG(K))
   35 CONTINUE
C.....modify coriolis to avoid zero at equator
      DO 25 K=47,NLATG
C        CORIOLIS(K)=2*OMEGA*SIN(RADG(46))
   25 CONTINUE
C.....Compute the (po/p)**xkapa        
      GASCON=287.
      CP=1004.
      XKAPA=287./1004.       
      DO 45 K=1,NMAND
         POOVRP(K)=(PLEVEL(1)/PLEVEL(K))**XKAPA
   45 CONTINUE
      PRINT 103
  103 FORMAT(' befor reading data   ')
C
CC====read the data from cray                           
C
      IUNIT=10
      READ(IUNIT) AVGGDH
      READ(IUNIT) AVGGDT
      READ(IUNIT) AVEDUU
      READ(IUNIT) AVEDVV
      READ(IUNIT) AVEDUV
      READ(IUNIT) AVEDUT
      READ(IUNIT) AVEDVT
      READ(IUNIT) AVEDTT
      READ(IUNIT) AVEDES
      READ(IUNIT) EDYPTV
      READ(IUNIT) EDYGRV
      READ(IUNIT) EDYGDU
      READ(IUNIT) EDYGDV
      READ(IUNIT) AVEDUQ
      READ(IUNIT) AVEDVQ
      READ(IUNIT) EDYGDS
C.....compute globaly averaged geoht
      DO 195 L=1,NMAND
      CALL AVERAGE(AVGGDH(1,1,L),GLBAVH(L))
  195 CONTINUE
C.....transform avg geoht into avg strmfct
      DO 200 L=1,NMAND
      DO 200 J=1,NLATG
      DO 200 I=1,NLONG
      AVGGDS(I,J,L)=GRAVITY*(AVGGDH(I,J,L)-GLBAVH(L))/CORIOLISO
  200 CONTINUE
C.....trsfm to spc space
      DO 250 L=1,NMAND
         CALL TRNSFM(AVGGDS(1,1,L),AVGSPS(1,1,1,L))
  250 CONTINUE
C
C===Compute avg U & V from avg Q.G. stream function.                
C    
C.....compute  spectral average U & V
      DO 700 L=1,NMAND
      CALL VELOSP(AVGSPS(1,1,1,L),AVGSPU(1,1,1,L),AVGSPV(1,1,1,L))
  700 CONTINUE
CC....transform average u & v to Gaussian grid    
      DO 705 L=1,NMAND
         CALL EVLSCA(AVGSPU(1,1,1,L),AVGGDU(1,1,L))
         CALL EVLSCA(AVGSPV(1,1,1,L),AVGGDV(1,1,L))
      DO 710 J=1,NLATG
      DO 710 I=1,NLONG
         AVGGDU(I,J,L)=AVGGDU(I,J,L)/COSLAT(J)      
         AVGGDV(I,J,L)=AVGGDV(I,J,L)/COSLAT(J)
  710 CONTINUE
  705 CONTINUE
C.....transform avg T into potential T        
      DO 260 K=1,NMAND
      DO 260 J=1,NLATG
      DO 260 I=1,NLONG
         AVGPTT(I,J,K)=AVGGDT(I,J,K)*POOVRP(K)   
  260 CONTINUE
C.....compute globally averaged potential temperature
      DO 265 K=1,NMAND
      CALL AVERAGE(AVGPTT(1,1,K),GLBAVT(K))
  265 CONTINUE
C.....compute depature of avg pt from the global average
      DO 270 K=1,NMAND
      DO 270 J=1,NLATG
      DO 270 I=1,NLONG
         AVDPTT(I,J,K)=AVGPTT(I,J,K)-GLBAVT(K)   
  270 CONTINUE
      PRINT 104
  104 FORMAT(' befor call UVPTV')
C
CC====compute the gradient of average PTV            
C
C.....compute PTV
      CALL QGPTV
      PRINT 105
  105 FORMAT(' befor computing gradient of avg PTV')
C.....compute gradient
      DO 730 L=1,MAND
         CALL TRNSFM(AVGPTV(1,1,L),AVSPTV(1,1,1,L))
  730 CONTINUE
C.....spatially smooth the avg PTV
      DO 733 L=1,MAND
      DO 733 K=6,NMP
      DO 733 J=1,NLEG
      DO 733 I=1,2
C        AVSPTV(I,J,K,L)=0.
  733 CONTINUE
      DO 734 L=1,MAND
      DO 734 K=1,NMP
      DO 734 J=11,NLEG
      DO 734 I=1,2
C        AVSPTV(I,J,K,L)=0.
  734 CONTINUE
C.....transform spectral avg PTV to gaussian grid
      DO 732 L=1,MAND
      CALL EVLSCA(AVSPTV(1,1,1,L),AVGPTV(1,1,L))
  732 CONTINUE
      DO 735 L=1,MAND
      CALL GRADSP(AVSPTV(1,1,1,L),SGRPVX(1,1,1,L),SGRPVY(1,1,1,L))
  735 CONTINUE
      PRINT 106
  106 FORMAT(' befor transf grad of avg PTV to Gaussian')
CC....transform gradient of average PTV to Gaussian grid    
      DO 750 L=1,MAND
         CALL EVLSCA(SGRPVX(1,1,1,L),GGRPVX(1,1,L))
         CALL EVLSCA(SGRPVY(1,1,1,L),GGRPVY(1,1,L))
      DO 750 J=1,NLATG
      DO 750 I=1,NLONG
         GGRPVX(I,J,L)=GGRPVX(I,J,L)/COSLAT(J)      
         GGRPVY(I,J,L)=GGRPVY(I,J,L)/COSLAT(J)      
         XGGRPV(I,J,L)=(GGRPVX(I,J,L)**2+GGRPVY(I,J,L)**2)**0.5
  750 CONTINUE
C.....compute gradient of mag of ptv gradient
      DO 736 L=1,MAND
         CALL TRNSFM(XGGRPV(1,1,L),SGGRPV(1,1,1,L))
  736 CONTINUE
      DO 755 K=1,MAND
      CALL GRADSP(SGGRPV(1,1,1,K),SRMGQX(1,1,1,K),SRMGQY(1,1,1,K))
  755 CONTINUE
      DO 756 L=1,MAND
         CALL EVLSCA(SRMGQX(1,1,1,L),GRMGQX(1,1,L))
         CALL EVLSCA(SRMGQY(1,1,1,L),GRMGQY(1,1,L))
      DO 756 J=1,NLATG
      DO 756 I=1,NLONG
         GRMGQX(I,J,L)=GRMGQX(I,J,L)/COSLAT(J)
         GRMGQY(I,J,L)=GRMGQY(I,J,L)/COSLAT(J)
  756 CONTINUE
      PRINT 107
  107 FORMAT(' befor computing MR & MT')
C
CC====compute 3d vector MR and MT(the amplifying factor is 500 for             
C     the z component.)
CC....MR
      HSCALE=8000.
      DO 790 L=1,MAND
      DO 790 J=1,NLATG
      DO 790 I=1,NLONG
         WVE=0.5*(AVEDUU(I,J,L)+AVEDVV(I,J,L)+
     1       GASCON*AVEDTT(I,J,L)*
     2       (PLEVEL(L)-PLEVEL(L+2))/(POOVRP(L+1)*
     3       PLEVEL(L+1)*(AVGPTT(I,J,L+2)-AVGPTT(I,J,L))))
         FT1=(PLEVEL(L+1)/PLEVEL(1))*COSLAT(J)/
     1       (AVGGDU(I,J,L+1)**2+AVGGDV(I,J,L+1)**2)**0.5
         XMR(I,J,L)=FT1*(AVGGDU(I,J,L+1)*                 
     1       (AVEDVV(I,J,L)-WVE)-AVGGDV(I,J,L+1)*
     2       AVEDUV(I,J,L))
         YMR(I,J,L)=FT1*(AVGGDV(I,J,L+1)*                 
     1       (AVEDUU(I,J,L)-WVE)-AVGGDU(I,J,L+1)*
     2       AVEDUV(I,J,L))
         FT2=CORIOLIS(J)*HSCALE*(PLEVEL(L)-PLEVEL(L+2))/(
     1       (AVGPTT(I,J,L+2)-AVGPTT(I,J,L))*PLEVEL(L+1))
         ZMR(I,J,L)=FT1*FT2*(AVGGDU(I,J,L+1)*AVEDVT(I,J,L)-
     1              AVGGDV(I,J,L+1)*AVEDUT(I,J,L))
CC....MT
      XM=(PLEVEL(L+1)/PLEVEL(1))*AVEDES(I,J,L)*COSLAT(J)/(
     1   GGRPVX(I,J,L)**2+GGRPVY(I,J,L)**2)**0.5
C.....for writing out XM
      XMM(I,J,L)=XM
      XMT(I,J,L)=XMR(I,J,L)+AVGGDU(I,J,L+1)*XM
      YMT(I,J,L)=YMR(I,J,L)+AVGGDV(I,J,L+1)*XM
      ZMT(I,J,L)=ZMR(I,J,L)
  790 CONTINUE
C
CC====quantites for evaluting the validity of the approximation
C
      PRINT 108
  108 FORMAT(' befor computing DMR & DMT')
      CALL DIVERGSP(XMR,YMR,ZMR,DIVMR)
C     CALL DIVERGSP(XMT,YMT,ZMT,DIVMT)
C.....compute the gradient of avg enstrophy
      DO 794 K=1,MAND
         CALL TRNSFM(AVEDES(1,1,K),WORKSP(1,1,1,K))
  794 CONTINUE
      DO 795 K=1,MAND
         CALL GRADSP(WORKSP(1,1,1,K),SGRESX(1,1,1,K),SGRESY(1,1,1,K))
  795 CONTINUE
      DO 796 K=1,MAND
         CALL EVLSCA(SGRESX(1,1,1,K),GRDESX(1,1,K))
         CALL EVLSCA(SGRESY(1,1,1,K),GRDESY(1,1,K))
      DO 796 J=1,NLATG
      DO 796 I=1,NLONG
         GRDESX(I,J,K)=GRDESX(I,J,K)/COSLAT(J)      
         GRDESY(I,J,K)=GRDESY(I,J,K)/COSLAT(J)      
  796 CONTINUE
      DO 800 K=1,3
      DO 800 J=1,NLATG
      DO 800 I=1,NLONG
         PCOS=(PLEVEL(K+2)/PLEVEL(1))*COSLAT(J)
         GRDQMOD=(GGRPVX(I,J,K+1)**2+GGRPVY(I,J,K+1)**2)**0.5
         UQN=(AVEDUQ(I,J,K+1)*GGRPVX(I,J,K+1)+
     1        AVEDVQ(I,J,K+1)*GGRPVY(I,J,K+1))/GRDQMOD
         COMPMR(I,J,K)=UQN
         UGRDE=AVGGDU(I,J,K+2)*GRDESX(I,J,K+1)+
     1         AVGGDV(I,J,K+2)*GRDESY(I,J,K+1)
         COMPMT(I,J,K)=UQN+UGRDE/GRDQMOD
         UGRGRQ(I,J,K)=AVEDES(I,J,K+1)*(AVGGDU(I,J,K+2)*GRMGQX(I,J,K+1)+
     1                AVGGDV(I,J,K+2)*GRMGQY(I,J,K+1))/
     2                (GGRPVX(I,J,K+1)**2+GGRPVY(I,J,K+1)**2)+
     3                AVGGDV(I,J,K+2)*AVEDES(I,J,K+1)*SINLAT(J)/
     4                (COSLAT(J)*GRDQMOD*R)
         DIVMR(I,J,K)=DIVMR(I,J,K)/PCOS
         DIVMT(I,J,K)=DIVMR(I,J,K)+UGRDE/GRDQMOD-UGRGRQ(I,J,K)
  800 CONTINUE
      PRINT 109
  109 FORMAT(' befor computing Hoskins E')
C
C=====Hoskins E vector
C
      DO 850 K=1,MAND
      DO 850 J=1,NLATG
      DO 850 I=1,NLONG
         EVCTRX(I,J,K)=0.5*(AVEDVV(I,J,K)-AVEDUU(I,J,K))
         EVCTRY(I,J,K)=-AVEDUV(I,J,K)
  850 CONTINUE
C
CC====write out more selected quantities
C
      JUNIT=60
C.....avg U & V
      CALL XWRITE(AVGGDU,JUNIT,LENG2)
      CALL XWRITE(AVGGDV,JUNIT,LENG2)
C.....avg T
      CALL XWRITE(AVGPTT,JUNIT,LENG2)
C.....avg relative vorticity 
      CALL XWRITE(AVGDRV,JUNIT,LENG2)
C.....eddy U  at last time step
      CALL XWRITE(EDYGDU,JUNIT,LENG3)
C.....eddy V  at last time step
      CALL XWRITE(EDYGDV,JUNIT,LENG3)
C.....eddy ptv at last time step
      CALL XWRITE(EDYPTV,JUNIT,LENG3)
C.....eddy rv  at last time step
      CALL XWRITE(EDYGRV,JUNIT,LENG3)
C.....XMM               
      CALL XWRITE(XMM,JUNIT,LENG3)
C.....term3 of avg PTV 
      CALL XWRITE(PTVT3,JUNIT,LENG3)
C.....avg eddy enstrophy
      CALL XWRITE(AVEDES,JUNIT,LENG3)
C.....average PTV
      CALL XWRITE(AVGPTV,JUNIT,LENG3)
C.....E vector
      CALL XWRITE(EVCTRX,JUNIT,LENG3)
      CALL XWRITE(EVCTRY,JUNIT,LENG3)
C.....vector MR  
      CALL XWRITE(XMR,JUNIT,LENG3)
      CALL XWRITE(YMR,JUNIT,LENG3)
      CALL XWRITE(ZMR,JUNIT,LENG3)
C.....vector MT  
      CALL XWRITE(XMT,JUNIT,LENG3)
      CALL XWRITE(YMT,JUNIT,LENG3)
      CALL XWRITE(ZMT,JUNIT,LENG3)
C.....average eddy uq & vq
      CALL XWRITE(AVEDUQ,JUNIT,LENG3)
      CALL XWRITE(AVEDVQ,JUNIT,LENG3)
C.....gradient of PTV       
      CALL XWRITE(GGRPVX,JUNIT,LENG3)
      CALL XWRITE(GGRPVY,JUNIT,LENG3)
C.....gradient of avg ens   
      CALL XWRITE(GRDESX,JUNIT,LENG3)
      CALL XWRITE(GRDESY,JUNIT,LENG3)
C.....gradient of mod of q gradient 
      CALL XWRITE(GRMGQX,JUNIT,LENG3)
      CALL XWRITE(GRMGQY,JUNIT,LENG3)
C.....div of MR & MT
      CALL XWRITE(DIVMR,JUNIT,LENG4)
      CALL XWRITE(DIVMT,JUNIT,LENG4)
C.....validity quantities
      CALL XWRITE(COMPMR,JUNIT,LENG4)
      CALL XWRITE(COMPMT,JUNIT,LENG4)
      CALL XWRITE(UGRGRQ,JUNIT,LENG4)
      STOP
      END
 
      SUBROUTINE XWRITE(ARRAY,JUNIT,N)
      DIMENSION ARRAY(N)
      WRITE(JUNIT) ARRAY
      RETURN
      END

      SUBROUTINE TRNSFM(FIELDG,FLDSPC)
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1)
      PARAMETER(NM=NW)
      PARAMETER(NMP=NW+1)
      PARAMETER(NLONG=128)
      PARAMETER(NLATG=102)
      PARAMETER(NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      PARAMETER(KHALF=(NLATG+1)/2)
      COMMON/GAUSS/RADG(NLATG),GWGT(NLATG)
      COMMON/POLY1/PLEG(NLEG,NMP,NLATG),DPLEG(NLEG,NMP,NLATG)
      COMMON/FFTAR1/TRIGS(IMAXT),IFAX(10)
      COMMON/FFTAR2/ARRAY(NLONGP,NLATG),WORK(NLONGP,NLATG)
      DIMENSION FIELDG(NLONG,NLATG)
      DIMENSION FLDSPC(2,NLEG,NMP)
      DO 20 IM=1,NMP
      DO 20 IN=1,NLEG
      DO 20 IC=1,2
      FLDSPC(IC,IN,IM)=0.0
   20 CONTINUE
      DO 60 JG=1,NLATG
      DO 40 IG=1,NLONG
      ARRAY(IG,JG)=FIELDG(IG,JG)
   40 CONTINUE
      ARRAY(NLONGP,JG)=0.0
   60 CONTINUE
      ISIGN=-1
      INC=1
      JUMP=NLONGP
      LOT=NLATG
      CALL FFT991(ARRAY,WORK,TRIGS,IFAX,INC,JUMP,NLONG,LOT,ISIGN)
      DO 200 JG=1,NLATG
      DO 180 IM=1,NMP
      DO 180 IN=1,NLEG
      FLDSPC(1,IN,IM)=FLDSPC(1,IN,IM)+ARRAY(2*IM-1,JG)*PLEG(IN,IM,JG)*
     1 GWGT(JG)
      FLDSPC(2,IN,IM)=FLDSPC(2,IN,IM)+ARRAY(2*IM  ,JG)*PLEG(IN,IM,JG)*
     1 GWGT(JG)
  180 CONTINUE
  200 CONTINUE
      RETURN
      END


 
      SUBROUTINE XUPDTG(FIELD,AVE,NLON,NLAT)
      DIMENSION FIELD(NLON,NLAT),AVE(NLON,NLAT)
      DO 100 J=1,NLAT
      DO 100 I=1,NLON
      AVE(I,J)=AVE(I,J)+FIELD(I,J)
  100 CONTINUE
      RETURN
      END
 
      SUBROUTINE FORWRT(FLDSPC,N,JUNIT)
      DIMENSION FLDSPC(N)
      WRITE(JUNIT,7000) FLDSPC
 7000 FORMAT(5(E16.8))
      RETURN
      END
 
 

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  transform from spctral to Gaussian grid                        C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE EVLSCA(ARRS,ARRP)
      PARAMETER(NW=40)
      PARAMETER(MNWV2=2*(NW+1)*(NW+1))
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
 

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  2-D gradient in spectral space
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE GRADSP(FILDIN,OUTX,OUTY)
      PARAMETER(NW=40,NLEG=NW+1,NMP=NW+1)
      COMMON/EPSLON/EPS(NLEG,NMP),XXN(NLEG,NMP),XXM(NMP)
      DIMENSION FILDIN(2,NLEG,NMP)                   
      DIMENSION OUTX(2,NLEG,NMP),OUTY(2,NLEG,NMP)
      R=6.371E+06
CC....x component of the gradient
      DO 100 K=1,NMP
      DO 100 J=1,NLEG 
         OUTX(1,J,K)=-XXM(K)*FILDIN(2,J,K)/R
         OUTX(2,J,K)=XXM(K)*FILDIN(1,J,K)/R
  100 CONTINUE
CC....y component of the gradient
      DO 200 I=1,2
      DO 200 K=1,NMP
         DO 300 J=2,NW  
      OUTY(I,J,K)=-((XXN(J,K)-1)*EPS(J,K)*FILDIN(I,J-1,K)-
     1(XXN(J,K)+2)*EPS(J+1,K)*FILDIN(I,J+1,K))/R
  300 CONTINUE
      OUTY(I,1,K)=+(XXN(1,K)+2)*EPS(2,K)*FILDIN(I,2,K)
     1/R
      OUTY(I,NLEG,K)=-(XXN(NLEG,K)-1)*EPS(NLEG,K)*
     1FILDIN(I,NW,K)/R
  200 CONTINUE
      RETURN
      END

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  compute velocity UCOS(LAT) & VCOS(LAT) in spectral space
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE VELOSP(FILDIN,FILDUU,FILDVV)
      PARAMETER(NW=40,NLEG=NW+1,NMP=NW+1)
      COMMON/EPSLON/EPS(NLEG,NMP),XXN(NLEG,NMP),XXM(NMP)
      DIMENSION FILDIN(2,NLEG,NMP)                   
      DIMENSION FILDUU(2,NLEG,NMP),FILDVV(2,NLEG,NMP)
      R=6.371E+06
CC....compute  spectral U  
      DO 100 I=1,2
      DO 100 K=1,NMP
         DO 200 J=2,NW  
      FILDUU(I,J,K)=((XXN(J,K)-1)*EPS(J,K)*FILDIN(I,J-1,K)-
     1(XXN(J,K)+2)*EPS(J+1,K)*FILDIN(I,J+1,K))/R
  200 CONTINUE
         FILDUU(I,1,K)=-(XXN(1,K)+2)*EPS(2,K)*FILDIN(I,2,K)
     1/R
         FILDUU(I,NLEG,K)=(XXN(NLEG,K)-1)*EPS(NLEG,K)*
     1FILDIN(I,NW,K)/R
  100 CONTINUE
CC....compute  spectral V  
      DO 300 K=1,NMP
      DO 300 J=1,NLEG 
         FILDVV(1,J,K)=-XXM(K)*FILDIN(2,J,K)/R
         FILDVV(2,J,K)=XXM(K)*FILDIN(1,J,K)/R
  300 CONTINUE
      RETURN
      END


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  3-D divergence over Gausssian grids
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE DIVERG(xin,yin,zin,out)
      parameter(nlong=128,nlatg=102,lin=5,lout=lin-2) 
      parameter(nlongw=nlong+2,nlatgw=nlatg+2) 
      COMMON/GAUSS/RADG(nlatg),GWGT(nlatg)
      dimension xin(nlong,nlatg,lin),yin(nlong,nlatg,lin)
      dimension zin(nlong,nlatg,lin)
      dimension out(nlong,nlatg,lout)
      dimension workx(nlongw,nlatg,lin)
      dimension worky(nlong,nlatgw,lin)
      dimension coslat(nlatg),plevel(5)
      dimension wcos(nlatgw),wlat(nlatgw)
      data plevel/85000.,70000.,50000.,30000.,20000./
      hscale=8000.
      r=6.37e+06
      pi=acos(-1.0)
      dlat=2*pi/nlong
      do 100 k=1,lin
         do 200 j=1,nlatg
         do 200 i=1,nlong
         workx(i+1,j,k)=xin(i,j,k)
         worky(i,j+1,k)=yin(i,j,k)
  200 continue
      do 300 j=1,nlatg 
         coslat(j)=cos(RADG(j))
         workx(1,j,k)=xin(nlong,j,k)
         workx(nlongw,j,k)=xin(1,j,k)
  300 continue
      do 400 i=1,nlong 
         worky(i,1,k)=0.
         worky(i,nlatgw,k)=0.
  400 continue
  100 continue
      do 450 j=1,nlatg
         wcos(j+1)=coslat(j)
         wlat(j+1)=RADG(j)   
  450 continue
         wcos(1)=0.
         wcos(nlatgw)=0.
         wlat(1)=pi/2.
         wlat(nlatgw)=-pi/2.
      do 520 k=2,lout+1
      do 520 j=1,nlatg
      do 520 i=1,nlong
         dx=(workx(i+2,j,k)-workx(i,j,k))/
     1      (r*coslat(j)*2*dlat)
         dy=(wcos(j+2)*worky(i,j+2,k)-wcos(j)*worky(i,j,k))
     1      /(r*wcos(j+1)*(wlat(j+2)-wlat(j)))
         dz=plevel(k)*(zin(i,j,k+1)-zin(i,j,k-1))/
     1      (hscale*(plevel(k-1)-plevel(k+1)))
         out(i,j,k-1)=dx+dy+dz
  520 continue
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  2-D gradient over Gausssian grids
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine GRADIENT(xin,xot,yot)
      parameter(nlong=128,nlatg=102)
      parameter(nlongw=nlong+2)
      COMMON/GAUSS/RADG(nlatg),GWGT(nlatg)
      dimension xin(nlong,nlatg)
      dimension xot(nlong,nlatg),yot(nlong,nlatg)
      dimension work(nlongw,nlatg)
      dimension coslat(nlatg)
      r=6.37e+06
      pi=acos(-1.0)
      dlat=2*pi/128.
      do 200 j=1,nlatg
      do 200 i=1,nlong
         work(i+1,j)=xin(i,j)
         yot(i,1)=0.
         yot(i,nlatg)=0.
  200 continue
      do 300 j=1,nlatg 
         coslat(j)=cos(RADG(j))
         work(1,j)=xin(nlong,j)
         work(nlongw,j)=xin(1,j)
  300 continue
      do 400 j=1,nlatg
      do 400 i=1,nlong
         xot(i,j)=(work(i+2,j)-work(i,j))/
     1            (r*coslat(j)*2*dlat)
  400 continue
      do 500 j=2,nlatg-1
      do 500 i=1,nlong
         yot(i,j)=(work(i,j+1)-work(i,j-1))/
     1            (r*(RADG(j+1)-RADG(j-1)))
  500 continue
      return
      end
      
                   
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     compute Q.G. potential vorticity               
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE QGPTV
      PARAMETER(NW=40,NLEG=NW+1,NMP=NW+1)
      PARAMETER(NLATG=102,NLONG=128,NMAND=7,MAND=NMAND-2)
      COMMON/EPSLON/EPS(NLEG,NMP),XXN(NLEG,NMP),XXM(NMP)
      COMMON/CORCOS/CORIOLIS(NLATG),PLEVEL(NMAND)  
      COMMON/PTV/AVSPRV(2,NLEG,NMP,NMAND),AVGDRV(NLONG,NLATG,NMAND),
     1           AVGSPS(2,NLEG,NMP,NMAND),AVDPTT(NLONG,NLATG,NMAND),
     2           AVGPTV(NLONG,NLATG,MAND),PTVT3(NLONG,NLATG,MAND),
     3           AVGPTT(NLONG,NLATG,NMAND),GLBAVT(NMAND)
      GASCON=287.
      XKAPA=287./1004.       
      R=6.371E+06
      RR=R*R
      DO 715 L=1,NMAND
      DO 715 K=1,NMP
      DO 715 J=1,NLEG 
      DO 715 I=1,2 
      AVSPRV(I,J,K,L)=-(XXN(J,K)+1)*XXN(J,K)*AVGSPS(I,J,K,L)
     1/RR
  715 CONTINUE
      DO 720 L=1,NMAND
         CALL EVLSCA(AVSPRV(1,1,1,L),AVGDRV(1,1,L))
  720 CONTINUE
      DO 725 K=1,MAND
      DO 725 J=1,NLATG
      DO 725 I=1,NLONG
      FT1=CORIOLIS(J)/(PLEVEL(K)-PLEVEL(K+2))
      FT2=(AVDPTT(I,J,K+2)+AVDPTT(I,J,K+1))* 
     1    (PLEVEL(K+1)-PLEVEL(K+2))/
     2    (GLBAVT(K+2)-GLBAVT(K+1))
      FT3=(AVDPTT(I,J,K+1)+AVDPTT(I,J,K))* 
     1    (PLEVEL(K)-PLEVEL(K+1))/
     2    (GLBAVT(K+1)-GLBAVT(K))
      TERM3=FT1*(FT2-FT3)
      PTVT3(I,J,K)=TERM3
      AVGPTV(I,J,K)=CORIOLIS(J)+AVGDRV(I,J,K+1)+TERM3
  725 CONTINUE
      RETURN
      END



CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  2-D global average over Gausssian grids
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine AVERAGE(fin,out)
      parameter(nlong=128,nlatg=102)
      parameter(nlatgw=nlatg+2)
      COMMON/GAUSS/RADG(nlatg),GWGT(nlatg)
      dimension fin(nlong,nlatg)
      dimension xlat(nlatgw)
      pi=acos(-1.0)
      dlon=2*pi/128.
      fpi=4.*pi
      do 100 j=1,nlatg
         xlat(j+1)=RADG(j)
  100 continue
         xlat(1)=pi/2.
         xlat(nlatgw)=-pi/2.
      out=0.
      do 200 j=1,nlatg+1
      rad=0.5*(xlat(j)+xlat(j+1))
      dlat=xlat(j)-xlat(j+1)
      do 200 i=1,nlong
         fild=0.5*(fin(i,j)+fin(i,j+1))
         out=out+fild*cos(rad)*dlon*dlat/fpi
  200 continue
      return
      end
 

 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  3-D divergence with horizontal in spectral space
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE DIVERGSP(xin,yin,zin,out)
      parameter(nlong=128,nlatg=102,lin=5,lout=lin-2) 
      parameter(nlongw=nlong+2,nlatgw=nlatg+2) 
      COMMON/GAUSS/RADG(nlatg),GWGT(nlatg)
      dimension xin(nlong,nlatg,lin),yin(nlong,nlatg,lin)
      dimension zin(nlong,nlatg,lin),hdiv(nlong,nlatg)
      dimension out(nlong,nlatg,lout)
      dimension plevel(5)
      data plevel/85000.,70000.,50000.,30000.,20000./
      hscale=8000.
      do 100 k=2,lout+1
      call DIV2DSP(xin(1,1,k),yin(1,1,k),hdiv)
      do 100 j=1,nlatg
      do 100 i=1,nlong
         dz=plevel(k)*(zin(i,j,k+1)-zin(i,j,k-1))/
     1      (hscale*(plevel(k-1)-plevel(k+1)))
         out(i,j,k-1)=hdiv(i,j)+dz
C        out(i,j,k-1)=hdiv(i,j)
  100 continue
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from U & V wind component compute
C       vorticity
C  The required subroutines are in rvdvvpst.f
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE DIV2DSP(UWND,VWND,DIVGD)
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1,NM=NW,NMP=NM+1)
      PARAMETER(NLATG=102,NLONG=128)
      DIMENSION UWND(NLONG,NLATG),VWND(NLONG,NLATG)
      DIMENSION DIVS(2,NLEG,NMP),VORS(2,NLEG,NMP)
      DIMENSION DIVGD(NLONG,NLATG)
CCC---CALCULATE SPECTRAL DIVERGENCE AND VORTICITY
      CALL GCMCRC(UWND,VWND,DIVS,VORS)
C-----transform divergence to GRID
      CALL EVLSCA(DIVS,DIVGD)
      RETURN
      END

 
      SUBROUTINE FTRANS(GRID,WAVE)
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1,NM=NW,NMP=NM+1)
      PARAMETER(NLATG=102 ,NLONG=128 ,NLONGP=NLONG+1,IMAXT=3*NLONG/2)
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
 

 
 
      SUBROUTINE GCMCRC(UVEC,VVEC,DIV,VOR)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C   PROGRAM TO TAKE THE (U,V) COMPONENTS OF THE WIND ON THE G. GRID    C
C   AND COMPUTE SPECTRAL DIVERGENCE (DIV) AND VORTICITY (VOR)          C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PARAMETER(NW=40)
      PARAMETER(NLEG=NW+1,NM=NW,NMP=NM+1)
      PARAMETER(NLATG=102,NLONG=128,NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      PARAMETER(EA=6.371E+06)
      COMMON/POLY1/PLEG(NLEG,NMP,NLATG),DPLEG(NLEG,NMP,NLATG)
      COMMON/GAUSS/RADG(NLATG),GWGT(NLATG)
      DIMENSION UVEC(NLONG,NLATG),VVEC(NLONG,NLATG)
      DIMENSION DIV(2,NLEG,NMP),VOR(2,NLEG,NMP)
      DIMENSION USPEC(2,NMP,NLATG),VSPEC(2,NMP,NLATG)
      DIMENSION UM(NLONGP),VM(NLONGP)
      CALL FTRANS(UVEC,USPEC)
      CALL FTRANS(VVEC,VSPEC)
      IM1=2*NMP+1
      IM2=NLONGP
      CALL FILLSP(DIV,0.0,NLEG,NMP)
      CALL FILLSP(VOR,0.0,NLEG,NMP)
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
      DRE=(-XM*UIMAG*PLEG(N,IM,J)-VREAL*DPLEG(N,IM,J))/(COSR*COSR)
      DIM=(+XM*UREAL*PLEG(N,IM,J)-VIMAG*DPLEG(N,IM,J))/(COSR*COSR)
      DIV(1,N,IM)=DIV(1,N,IM)+DRE*GWGT(J)
      DIV(2,N,IM)=DIV(2,N,IM)+DIM*GWGT(J)
  180 CONTINUE
      DO 190 N=1,NLEG
      VRE=(-XM*VIMAG*PLEG(N,IM,J)+UREAL*DPLEG(N,IM,J))/(COSR*COSR)
      VIM=(+XM*VREAL*PLEG(N,IM,J)+UIMAG*DPLEG(N,IM,J))/(COSR*COSR)
      VOR(1,N,IM)=VOR(1,N,IM)+VRE*GWGT(J)
      VOR(2,N,IM)=VOR(2,N,IM)+VIM*GWGT(J)
  190 CONTINUE
  200 CONTINUE
  300 CONTINUE
      DO 310 IM=1,NMP
      DO 310 N=1,NLEG
      DO 310 IC=1,2
      DIV(IC,N,IM)=DIV(IC,N,IM)/EA
  310 CONTINUE
      DO 320 IM=1,NMP
      DO 320 N=1,NLEG
      DO 320 IC=1,2
      VOR(IC,N,IM)=VOR(IC,N,IM)/EA
  320 CONTINUE
      RETURN
      END
 
      SUBROUTINE FILLSP(ARRAYS,VALUE,NLEG,NMP)
      DIMENSION ARRAYS(2,NLEG,NMP)
      DO 20 IM=1,NMP
      DO 20 N=1,NLEG
      ARRAYS(1,N,IM)=VALUE
      ARRAYS(2,N,IM)=VALUE
   20 CONTINUE
      RETURN
      END
 
