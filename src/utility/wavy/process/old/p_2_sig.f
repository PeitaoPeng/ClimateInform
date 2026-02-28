CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC            
C   input :  topog and z, div, vor on p-sfc
C   output:  lnp, div, vor, t on sig-sfc
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PARAMETER (KMAX=18,KMXI=14 ,MAND=14,
     *LONG=128,LATG=102,
     *KMXP=KMAX+1,KMXM=KMAX-1)
CX
      DIMENSION TOPOG(LONG,LATG),FIELD(LONG,LATG)
      DIMENSION GEOPP(LONG,LATG,KMXI),GEOPS(LONG,LATG,KMAX)
      DIMENSION UWINDP(LONG,LATG,KMXI),UWINDS(LONG,LATG,KMAX)
      DIMENSION VWINDP(LONG,LATG,KMXI),VWINDS(LONG,LATG,KMAX)
      DIMENSION TMPP(LONG,LATG,KMXI),TMPS(LONG,LATG,KMAX)
      DIMENSION TMPP2(LONG,LATG,KMXI),TMPS2(LONG,LATG,KMAX)
      DIMENSION PMAND(MAND), ALNP(MAND)                                   
      COMMON ZC(KMXI),TC(KMXI),                                         
     3 CI(KMXP),SI(KMXP),DEL(KMAX),SL(KMAX),CL(KMAX),                   
     4 RPI(KMXM),PS(LONG ),                                             
     5 US(LONG ,KMAX),VS(LONG ,KMAX),                                    
     6 TS(LONG ,KMAX),                  
     7 WORKP(LONG ,KMXI),WORKS(LONG ,KMAX),PCOF(LONG ,KMAX)             
C     A=HEIGHT B=U,C=V                                                  
      COMMON PSFC(LONG ,LATG ),              
     2 U(LONG ,KMXI),V(LONG ,KMXI),ZSTAR(LONG ),                        
     3 T(LONG ,KMXI),Z(LONG ,KMXI)                       
C                                                                       
c     OPEN(10 ,FILE='ztopr15sm.grads',
c    ' FORM='UNFORMATTED',ACCESS='DIRECT',recl=LONG*LATG)
      OPEN(20 ,FILE='/data/tmp/peng/zdivvor.ec9293djf',
     ' FORM='UNFORMATTED',ACCESS='DIRECT',recl=LONG*LATG)
      OPEN(60,FILE='/data/gcmprd/peng/obs/sghgrd.ec9293djf',
     ' FORM='UNFORMATTED',ACCESS='DIRECT',recl=LONG*LATG)
C                                                                       
      DATA PMAND  /1000.,  850., 700., 500., 400., 300., 250.,          
     1              200., 150., 100.,  70.,  50., 30., 10./   
C***  FACTOR 1/10 CONVERTS TO CB.                                       
      DO 5 K=1,MAND                                                     
5     ALNP(K) = ALOG(PMAND(K))                                          
      CALL SETSIG(CI,SI,DEL,SL,CL,RPI)                                  
C.....READ IN TOPOGRAPH 
      irec=0
      irec=irec+1
      READ(20,rec=1) TOPOG                                                  
      do 11 j=1,latg
      do 11 i=1,long
        TOPOG(i,j)=TOPOG(i,j)/9.8
   11 CONTINUE
C
CX....READ GEOPOTENTIAL HEIGHT
      DO K=1,KMXI
      irec=irec+1
      READ(20,rec=irec) FIELD        
      DO 376 I=1,LONG                                                 
      DO 376 J=1,LATG                                                 
      GEOPP(I,J,K)=FIELD(I,J)/9.8                                          
 376  CONTINUE                                                          
      END DO
C.....READ DIV
      DO K=1,KMXI
      irec=irec+1
      READ(20,rec=irec) FIELD        
      DO 370 I=1,LONG                                                 
      DO 370 J=1,LATG                                                 
      UWINDP(I,J,K)=FIELD(I,J)                                              
 370  CONTINUE                                                          
      END DO
C.....READ VOR
      DO K=1,KMXI
      irec=irec+1
      READ(20,rec=irec) FIELD        
      DO 374 I=1,LONG                                                 
      DO 374 J=1,LATG                                                 
      VWINDP(I,J,K)=FIELD(I,J)                                              
 374  CONTINUE                                                          
      END DO
C.....READ TMP
      DO K=1,KMXI
      irec=irec+1
      READ(20,rec=irec) FIELD        
      DO 375 I=1,LONG                                                 
      DO 375 J=1,LATG                                                 
      TMPP2(I,J,K)=FIELD(I,J)                                              
 375  CONTINUE                                                          
      END DO
      write(6,*) 'have read top,z,div and vor'
C======================================================                 
      DO 1000 LAT=1, LATG                                               
C                                                                       
      write(6,*) 'before call lowtmp'
      DO 50 LO=1,LONG                                                   
         DO 30 K=1,KMXI                                                 
30       ZC(K)=GEOPP(LO,LAT,K)                                                  
      CALL LOWTMP(ZC,TC)                                                
         DO 40 K=1,KMXI                                                 
40       TMPP(LO,LAT,K)=TC(K)                           
C40       TMPP(LO,LAT,K)=TMPP2(LO,LAT,K)                                                  
50    CONTINUE                                                          
      write(6,*) 'before call getps'
         DO 32 LO=1,LONG
           ZSTAR(LO)=TOPOG(LO,LAT)
         DO 32 K =1,KMXI
           Z(LO,K)=GEOPP(LO,LAT,K)
           T(LO,K)=TMPP (LO,LAT,K)
32       CONTINUE
      CALL GETPS(Z,ZSTAR,ALNP,T,PSFC,LAT)                             
      DO 51 LO=1,LONG                                                   
        PSFC(LO,LAT) = EXP(PSFC(LO,LAT))                            
51    CONTINUE                                                          
C                                                                       
      write(6,*) 'before call ptos'
      DO 82 K =1,KMXI
      DO 82 LO=1,LONG
        U(LO,K)=UWINDP(LO,LAT,K)
        V(LO,K)=VWINDP(LO,LAT,K)
  82  CONTINUE
      CALL PTOS(LAT,PMAND,ALNP)                                       
C                                                                       
      DO 80 K =1,KMAX
      DO 80 LO=1,LONG
        UWINDS(LO,LAT,K)=US(LO,K)
        VWINDS(LO,LAT,K)=VS(LO,K)
        TMPS(LO,LAT,K)=TS(LO,K)
        PSFC(LO,LAT)=PS(LO)
  80  CONTINUE
1000  CONTINUE                                                          
C===============================================
      iwrit=0
C.....WRITE out TOPOGRAPHY                                            
      iwrit=iwrit+1
      WRITE(60,rec=iwrit) TOPOG                                                 
C.....WRITE out ln(Ps)                                                
      iwrit=iwrit+1
      WRITE(60,rec=iwrit) PSFC                                                 
C..... write out DIV
      DO 64 K=1,KMAX                                                    
      DO 364 I=1,LONG                                                 
      DO 364 J=1,LATG                                                 
      FIELD(I,J)=UWINDS(I,J,K)                                              
 364  CONTINUE                                                          
      iwrit=iwrit+1
      WRITE(60,rec=iwrit) FIELD                                                 
64    CONTINUE                                                          
C..... write out VOR
      DO 65 K=1,KMAX                                                    
      DO 365 I=1,LONG                                                 
      DO 365 J=1,LATG                                                 
      FIELD(I,J)=VWINDS(I,J,K)                                              
 365  CONTINUE                                                          
      iwrit=iwrit+1
      WRITE(60,rec=iwrit) FIELD                                                 
65    CONTINUE                                                          
C..... write out diagnostic TMP
      DO 66 K=1,KMAX                                                    
      DO 366 I=1,LONG                                                 
      DO 366 J=1,LATG                                                 
      FIELD(I,J)=TMPS(I,J,K)                                 
 366  CONTINUE                                                          
      iwrit=iwrit+1
      WRITE(60,rec=iwrit) FIELD                                                 
66    CONTINUE                                                          
                                                      
C================================================
C
      PRINT 100                                                   
100   FORMAT(1H0,'END PRESS. TO SIGMA')                   
C
      STOP                                                              
      END                                                               

