      SUBROUTINE PTOS(LATCO,PMAND,ALNP)                                 
      PARAMETER (NWS=41,KMAX=10,KMXI=17,MAND=17,
     *LONG=144,LATG=73,
     *KMXP=KMAX+1,KMXM=KMAX-1)
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
      PIO2=3.141592653589793238/2.0                                     
      CALL PTOSIG(PSFC,LATCO,SI,ZSTAR,PMAND,ALNP,                       
     1 Z,T,U,V,US,VS,TS,SL)                                       
      DO 63 I=1,LONG                                                    
      PS(I)=PSFC(I,LATCO)/10.                                           
63    CONTINUE                                                          
C*** PS NOW IN Centi Bar.                             
      DO 67 I=1,LONG                                                    
      PS(I)=ALOG(PS(I))                                                 
67    CONTINUE                                                          
      RETURN                                                            
      END                                                               
C
      SUBROUTINE SETSIG(CI, SI, DEL, SL, CL, RPI)                       
      PARAMETER (NWS=41,NWV=42,KMAX=10,KMXI=17,MAND=17,
     *LONG=144,LATG=73,
     *LATH=LATG/2,KMXP=KMAX+1,KMXM=KMAX-1,
     *NTS=NWS*NWS*2,NTV=NWS*NWV*2,
     *NRS=NWS*NWS,NRV=NWS*NWV)
      DIMENSION CI(KMXP), SI(KMXP),                                     
     1 DEL(KMAX), SL(KMAX), CL(KMAX), RPI(KMXM)                         
      DIMENSION DELSIG(KMAX)                                            
      SAVE DELSIG
C                                                                       
      DATA DELSIG/ KMAX*0.1/              
c     DATA DELSIG/ .01,.040,0.08,0.100,0.15,
c    * 0.096,0.096,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05/              
C                                                                       
      PRINT 98                                                          
98    FORMAT (1H0, 'BEGIN SETSIG')                                      
      DO 9889 K=1,KMAX                                                  
9889  DEL(K)=DELSIG(K)                                                  
      CI(1) = 0. E0                                                     
      SUMDEL=0. E0                                                      
      DO 54 K=1,KMAX                                                    
      SUMDEL=SUMDEL+DEL(K)                                              
      CI(K+1)=CI(K)+DEL(K)                                              
54    CONTINUE                                                          
      CI(KMXP)=1. E0                                                    
      RK =  287.05E0  /  1005.E0                                        
      RK1 = RK + 1. E0                                                  
      LEVS= KMAX                                                        
      DO 1 LI=1,KMXP                                                    
1     SI(LI) = 1. E0 - CI(LI)                                           
      DO 3 LE=1,KMAX                                                    
C     DIF = SI(LE)**RK1 - SI(LE+1)**RK1                                 
      SIRK=RK1*ALOG(SI(LE))                                             
      SIRK=EXP(SIRK)                                                    
       IF(LE.LT.KMAX) THEN                                                
      SI1RK=RK1*ALOG(SI(LE+1))                                          
      SI1RK=EXP(SI1RK)                                                  
       ELSE                                                             
      SI1RK=0.                                                          
       END IF                                                           
      DIF = SIRK  - SI1RK                                               
      DIF = DIF / (RK1*(SI(LE)-SI(LE+1)))                               
C     SL(LE) = DIF**(1. E0/RK)                                          
      SLLE=(1. E0/RK)*ALOG(DIF)                                         
      SL(LE)= EXP(SLLE)                                                 
      CL(LE) = 1. E0 - SL(LE)                                           
3     CONTINUE                                                          
C     COMPUTE PI RATIOS FOR TEMP. MATRIX.                               
      DO 4 LE=1,KMXM                                                    
C4     RPI(LE) = (SL(LE+1)/SL(LE))**RK                                  
      RPILE=RK*ALOG(SL(LE+1)/SL(LE))                                    
4     RPI(LE)=EXP(RPILE)                                                
      DO 5 LE=1,KMXP                                                    
      PRINT 100, LE, CI(LE), SI(LE)                                     
100   FORMAT (1H , 'LEVEL=', I2, 2X, 'CI=', F6.3, 2X, 'SI=', F6.3)      
5     CONTINUE                                                          
      PRINT 97                                                          
97    FORMAT (1H0)                                                      
      DO 6 LE=1,KMAX                                                    
      PRINT 101, LE, CL(LE), SL(LE), DEL(LE)                            
101   FORMAT (1H , 'LAYER=', I2, 2X, 'CL=', F6.3, 2X, 'SL=', F6.3, 2X,  
     1 'DEL=', F6.3)                                                    
6     CONTINUE                                                          
      PRINT 102, (RPI(LE), LE=1,KMXM)                                   
102   FORMAT (1H0, 'RPI=', (18(1X,F6.3)) )                              
      PRINT 99,KMAX,SUMDEL                                                   
99    FORMAT (1H0,'SHALOM FROM MRF',I3,' LEVEL GDAS SUMDEL=',E13.4)        
      RETURN                                                            
      END                                                               
      SUBROUTINE PRMFLD(NUM)                                            
      DIMENSION NUM(28)                                                 
      NUM(1) = 10                                                       
      NUM(2) = 20                                                       
      NUM(3) = 60                                                       
      RETURN                                                            
      END                                                               
      SUBROUTINE XSTORE(A,X,N)                                          
C***   FAKE 360/195 BYTE MOVING ROUTINE                                 
      DIMENSION A(*)                                                    
      DO 1 I=1,N                                                        
1     A(I)=X                                                            
      RETURN                                                            
      END                                                               
      SUBROUTINE PTOSIG (PSFC, LATCO, SI, ZSTAR, PMAND, ALNP,           
     1 ZP, TP, UP, VP, US, VS, TS , SL )                        
      PARAMETER (NWS=41,KMAX=10,KMXI=17,MAND= 17,
     *LONG=144,LATG=73,
     *KMXP=KMAX+1,KMXM=KMAX-1)
      DIMENSION SL(KMAX)                                                
      DIMENSION PSFC(LONG ,LATG ), SI(KMXP), PI(KMXP),                  
     1 P(KMXP), ZS(KMXP), ZSTAR(LONG ),                                 
     2 PMAND(MAND), ALNP(MAND), ZP(LONG,MAND), TP(LONG,MAND),                 
     3 PBS(KMXP), UP(LONG,MAND), VP(LONG,MAND),                           
     4 US(LONG ,KMAX), VS(LONG ,KMAX),                                  
     5 TS(LONG ,KMAX)                      
      SAVE R,G                                          
      DATA R/2.8705E2/, G/9.8/                                          
      KPMAX = KMXI                                                      
      ROG = R/G                                                         
      JJ = LATCO                                                        
C                                                                       
      DO 1270 I=1,LONG                                                  
C                                                                       
C  DEFINE INTERFACE PRESSURES,P FROM P* AND SI                          
C                                                                       
      DO 400 K = 1,KMXP                                                 
        P(K) = PSFC(I,JJ) * SI(K)                                       
        IF(P(K).LE.0.0) P(K) = 1.0                                      
  400 CONTINUE                                                          
C                                                                       
C     HERE FIND HEIGHTS OF SIGMA SURFACES BY SAME HYDROSTATIC FORMULA   
C                                                                       
C     AND FIND WINDS IN THE D SIGMA LAYERS BY INTERPOLATION FROM        
C     MANDITORY LEVELS  -  INTERPOLATION SAYS WIND COMPONENTS ARE       
C     LINEAR WITH LN(PRESSURE) TO CENTERS OF SIGMA LAYERS.              
C     LATTER DEFINED AS AT LN(PBAR SIG)                                 
C                                                                       
C                                                                       
      P2 = P(1)                                                         
      ZS(1) = ZSTAR(I)                                                  
           DO 190 KS = 1,KMAX                                           
C                                                                       
C     BYPASS FINDING Z FOR SIGMA LEVEL 1                                
C                                                                       
      P1=P(KS+1)                                                        
      IF(KS.EQ.1)  GO TO 160                                            
C                                                                       
C     FIND PRESSURE LEVELS WHICH BRACKET KS SIG LEVEL                   
C                                                                       
      DO 140 K=2,KPMAX                                                  
      KP = K                                                            
      IF(PMAND(K).LE.P2)  GO TO 150                                     
  140 CONTINUE                                                          
150   CONTINUE                                                          
C     HEIGHTS  -  HYDROSTATIC INTERPOLATION                             
C                                                                       
      DH = ALNP(KP-1) - ALNP(KP)                                        
      A = - (ZP(I,KP-1) - ZP(I,KP))/DH                                  
      B = ROG * (TP(I,KP-1) - TP(I,KP))/DH                              
      Z3 = 0.5 * (ZP(I,KP-1) + ZP(I,KP)) + 0.125 * B * (DH**2)          
      HMH3 = ALOG(P2) - 0.5 * (ALNP(KP-1) + ALNP(KP))                   
      ZS(KS) = Z3 - (A + 0.5 * B * HMH3) * HMH3                         
C                                                                       
C     WINDS LINEAR WITH LN(P) INTERPOLATINN                             
C     FIND PRESSURE CENTRAL TO SIGMA LAYER                              
C     ALSO RELATIVE HUMIDITY BUT CAUTION  -                             
C     1)  REL HUM ONLY WANTED FOR 5 LOWEST SIGMA LAYERS                 
C     2)    REL HUM AVAILABLE ONLY ON LOWEST 6 MAND PRESSURE LEVELS     
C      SO WATCH OUT                                                     
C                                                                       
160   PBS(1)=SL(KS)*PSFC(I,JJ)                                          
C                                                                       
C     SEARCH (AGAIN ) FOR BRACKETINF MANDITORY LEVELS                   
C                                                                       
      DO 170 K=2,KPMAX                                                  
      KP = K                                                            
      IF(PMAND(K).LE.PBS(1))  GO TO 180                                
  170 CONTINUE                                                          
C***  IF FALL THRU EQUATE TO 50 MB VALUES                               
      US(I,KS)=UP(I,KMXI)                                               
      VS(I,KS)=VP(I,KMXI)                                               
      GO TO 189                                                         
C                                                                       
C     WINDS  -  LINEAR INTERP TO LN(PBS)                                
C                                                                       
  180 U3 = (UP(I,KP-1) + UP(I,KP)) * 0.5                                
      V3 = (VP(I,KP-1) + VP(I,KP)) * 0.5                                
      DH = ALNP(KP-1) - ALNP(KP)                                        
      AU = (UP(I,KP-1) - UP(I,KP))/DH                                   
      AV = (VP(I,KP-1) - VP(I,KP))/DH                                   
      H3MHX = 0.5*(ALNP(KP -1) + ALNP(KP )) - ALOG(PBS(1))              
      US(I,KS) = U3 - AU*H3MHX                                          
      VS(I,KS) = V3 - AV*H3MHX                                          
C                                                                       
  189 P2 = P1                                                           
  190 CONTINUE                                                          
C                                                                       
C     HERE FIND TEMPERATURES IN LAYERS                                  
C                                                                       
             DO 230 KS=1,KMAX                                           
      IF(P(KS+1) .GE. PMAND(KPMAX)) GO TO 229                           
      TS(I,KS)=TP(I,KMXI)                                               
      GO TO 230                                                         
229   CONTINUE                                                          
      TS(I,KS) = -1./ROG * (ZS(KS) - ZS(KS+1))/ ALOG(P(KS)/P(KS+1))     
  230 CONTINUE                                                          
C..FIX BY J.GERRITY..........                                           
C                                                                       
C     CORRECTION TO SIGMA LAYER TEMP AND WIND                           
C     WHEN SIGMA LAYER PRESSURE LESS THAN 50 MB.                        
C                                                                       
C     SET ISOTHERMAL TEMPERATURE TO                                     
C     THICKNESS TEMP IMPLIED BY Z AT 50 AND 70 MBS.                     
C     SET WIND SHEAR USING 70 AND 50 MB WINDS                           
C                                                                       
CP    DH = ALNP(12) - ALNP(11)                                          
      DH = ALNP(7) - ALNP(6)                                          
CP    TISO = (ZP(I,11) - ZP(I,12)) / (ROG*DH)                           
      TISO = (ZP(I,6) - ZP(I,7)) / (ROG*DH)                           
      PBARLN = ALOG(59.801166)                                          
CP    UBAR = 0.5 * (UP(I,11) + UP(I,12))                                
      UBAR = 0.5 * (UP(I,6) + UP(I,7))                                
CP    VBAR = 0.5 * (VP(I,11) + VP(I,12))                                
      VBAR = 0.5 * (VP(I,6) + VP(I,7))                                
CP    DUDLNP = (UP(I,12) - UP(I,11)) / DH                               
      DUDLNP = (UP(I,7) - UP(I,6)) / DH                               
CP    DVDLNP = (VP(I,12) - VP(I,11)) / DH                               
      DVDLNP = (VP(I,7) - VP(I,6)) / DH                               
C                                                                       
      DO 300 KS=1,KMAX                                                  
      PBARS = SL(KS) * PSFC(I,JJ)                                       
CP    IF (PBARS.GE.50.)  GO TO 300                                      
      GO TO 300                                      
      TS(I,KS) = TISO                                                   
      PBRSLN = ALOG(PBARS)                                              
      DHP = PBRSLN - PBARLN                                             
      SHRU = DUDLNP * DHP                                               
      SHRV = DVDLNP * DHP                                               
      US(I,KS) = UBAR + SHRU                                            
      VS(I,KS) = VBAR + SHRV                                            
C                                                                       
C     BOUND EXTRAPOLATION                                               
C                                                                       
      IF (US(I,KS).GE.+50.)  US(I,KS)= 50.                              
      IF (US(I,KS).LE.-50.)  US(I,KS)=-50.                              
      IF (VS(I,KS).GE.+50.)  VS(I,KS)= 50.                              
      IF (VS(I,KS).LE.-50.)  VS(I,KS)=-50.                              
300   CONTINUE                                                          
C                                                                       
C     END CORRECTION                                                    
 1270 CONTINUE                                                          
C              ENDS THE ROW                                             
      RETURN                                                            
      END                                                               
      SUBROUTINE GETPS (ZP, ZSTAR, ALNP, TP, PSFC, JJ)                  
      PARAMETER (NWS=41,KMAX=10,KMXI=17,MAND=17,
     *LONG=144,LATG=73,
     *KMXP=KMAX+1,KMXM=KMAX-1)
      DIMENSION ZP(LONG,MAND), ZSTAR(LONG ),                             
     1 ALNP(MAND), TP(LONG,MAND), PSFC(LONG ,LATG )                        
      SAVE G,R
      DATA G/9.8/, R/2.8705E2/                                          
      DO 270 I=1,LONG                                                   
C                                                                       
C     FIRST COMPUTE SURFACE PRESSURE P* (PSTAR)                         
C     START BY FINDING MANDITORY LEVELS WHICH BRACKET THE GROUND (Z*)   
C                                                                       
      DO 100 K=2,KMXI                                                   
      KP = K                                                            
      IF(ZP(I,K).GE.ZSTAR(I))  GO TO 110                                
  100 CONTINUE                                                          
C                                                                       
C     NEXT THE SURFACE PRESSURE I VIA THE HYDROSTATIC FORMALA           
C                                                                       
CX
CX   WRITE(6,7010) I,KP
C7010 FORMAT(' IN SUBOURINTE GETPS  I= ',I3,' KP = ',I3)
  110 DH = ALNP(KP-1) - ALNP(KP)                                        
      DPHI = G * (ZP(I,KP-1) - ZP(I,KP))                                
      A = -DPHI/DH                                                      
      B = R*(TP(I,KP-1) - TP(I,KP))/DH                                  
      PHI3 = 0.5 * G * (ZP(I,KP-1) + ZP(I,KP)) + 0.125 *B*(DH**2)       
      SQ = A**2 - 2.*B * (G*ZSTAR(I) - PHI3)                            
      IF(SQ.GE.0.)  GO TO 130                                           
      PRINT 120                                                         
  120 FORMAT('1 DISASTER - NEG SQRT IN PSTAR.')                         
CX
      STOP
  130 ALNPS = 0.5 * (ALNP(KP-1) + ALNP(KP)) - 2. * (G*ZSTAR(I) - PHI3)/ 
     1                                            (A + SQRT(SQ))        
      PSFC(I,JJ) = ALNPS                                                
  270 CONTINUE                                                          
      RETURN                                                            
      END                                                               
      SUBROUTINE  LOWTMP(ZSV,TSV)                                       
      PARAMETER (NWS=41,KMAX=10,KMXI=17,MAND=17,
     *LONG=144,LATG=73,
     *KMXP=KMAX+1,KMXM=KMAX-1)
      PARAMETER (NAT=2*KMXI,NWRK=MAND+4)
       REAL  ZSV,TSV,PRESS                                              
      DIMENSION PRESS(MAND),AINV(MAND,MAND),AUNK(MAND)
      DIMENSION  AT(MAND,NAT), ATA(MAND,MAND)
      DIMENSION  DELTZ(MAND),RPL(MAND),DLG(MAND)                          
      DIMENSION  UNK(NAT), Q(MAND,NWRK), AC(MAND),BC(MAND)
      DIMENSION  TBAR(MAND),ZSV(MAND),TSV(MAND)                                
      SAVE PRESS,ISWTCH,SCLT,MLVL,RPL,DLG,NLVLM,AC,BC,NLVLP,NLVLPP,
     *AT,ATA,Q,AINV,NLVLPX
      DATA PRESS/1000.,925.,850.,700.,600.,500.,400.,300.,250.,
     1              200.,150.,100., 70., 50., 30., 20., 10./
      DATA ISWTCH/0/                                                    
      IF(ISWTCH.NE.0) GO TO 90                                          
      SCLT=-9.8   /287.0                                                
      MLVL= KMXI                                                        
      DO 10  I=1,MAND                                                   
      XX=PRESS(I)                                                       
      RPL(I)= LOG (XX)                                                  
 10   CONTINUE                                                          
      DO 20  I=2,MAND                                                   
      DLG(I)=RPL(I)-RPL(I-1)                                            
      DLG(I)=1.0   /DLG(I)                                              
 20   CONTINUE                                                          
      NLVLM=MLVL-1                                                      
      AC(1)=0.0                                                         
      BC(1)=AC(1)                                                       
      AC(MLVL)=AC(1)                                                    
      BC(MLVL)=AC(1)                                                    
      DO 30  K=2,NLVLM                                                  
      AC(K)=(RPL(K+1)-RPL(K))/(RPL(K+1)-RPL(K-1))                       
       BC(K)=(RPL(K)-RPL(K-1))/(RPL(K+1)-RPL(K-1))                      
 30   CONTINUE                                                          
      NLVLP=NLVLM+MLVL-1                                                
      NLVLPP=NLVLP+1                                                    
      DO 40  I=1,NAT                                                    
      DO 40  J=1,MAND                                                   
      AT(J,I)=0.0                                                       
 40   CONTINUE                                                          
      DO 50  I=1,NLVLM                                                  
      AT(I,I)=0.5                                                       
      AT(I+1,I)=AT(I,I)                                                 
 50   CONTINUE                                                          
      DO 60  I=1,MLVL                                                   
      AT(I,I+NLVLM)=1.0                                                 
 60   CONTINUE                                                          
      DO 80  I=1,MLVL                                                   
      DO 80  J=1,MLVL                                                   
      ATA(I,J)=0.0                                                      
      DO 70  K=1,NLVLPP                                                 
      ATA(I,J)=ATA(I,J)+AT(I,K)*AT(J,K)                                 
 70   CONTINUE                                                          
 80   CONTINUE                                                          
      CALL ERWINA(MLVL,ATA(1,1),AINV(1,1),Q(1,1),MAND)                  
      NLVLPX=NLVLP-1                                                    
  90  CONTINUE                                                          
      ISWTCH=1                                                          
      DO 100  I=2,MLVL                                                  
C   DELTZ IN M.                                                         
      DELTZ(I)=ZSV(I)-ZSV(I-1)                                          
 100  CONTINUE                                                          
      DO 110  K=2,MLVL                                                  
      TBAR(K)=DELTZ(K)*DLG(K)                                           
 110  CONTINUE                                                          
      DO 120  I=1,NLVLM                                                 
      UNK(I)=TBAR(I+1)                                                  
 120  CONTINUE                                                          
      I3=1                                                              
      DO 130  I=MLVL,NLVLPX                                             
      I3=I3+1                                                           
      UNK(I+1)=AC(I3)*TBAR(I3)+BC(I3)*TBAR(I3+1)                        
 130  CONTINUE                                                          
      UNK(MLVL)=-UNK(MLVL+1)+2.0   *TBAR(2)                             
      UNK(NLVLPP)=-UNK(NLVLP)+2.0   *TBAR(MLVL)                         
      DO 150  I=1,MLVL                                                  
      AUNK(I)=0.0                                                       
      DO 140  J=  1,NLVLPP                                              
      AUNK(I)=AUNK(I)+AT(I,J)*UNK(J)                                    
 140  CONTINUE                                                          
 150  CONTINUE                                                          
      DO 170  I=1,MLVL                                                  
      TSVXIX=0.0                                                        
      DO 160  J=1,MLVL                                                  
      TSVXIX=TSVXIX+AINV(I,J)*AUNK(J)                                   
 160  CONTINUE                                                          
C   TSV IN DEG CELSIUS.                                                 
      TSV(I)=TSVXIX*SCLT                                                
 170  CONTINUE                                                          
      RETURN                                                            
      END                                                               
      SUBROUTINE ERWINA (N, Q, F, A, MTXD)                              
CNP   ERWINA                                                            
C          SUBROUTINE INVERTS N BY N MATRIX (OR SUBMATRIX)              
C          DETERMINENT OF MATRIX IS CALCULATED AS D -- SUBROUTINE CAN BE
C             MODIFIED TO INCLUDE D IN CALL SEQUENCE.                   
C          ARGUMENTS (WITH DIMENSIONS) ARE                              
C             N                   -- SIZE OF (SUB)MATRIX TO BE INVERTED 
C             Q(MTXD  , MTXD  )   -- INPUT MATRIX                       
C             F(MTXD  , MTXD  )   -- RESULTANT INVERTED MATRIX          
C             A(MTXD  , MTXD  +4) -- WORK ARRAY                         
C             MTXD                -- ARRAY DIMENSIONS OF ACTUAL ARRAYS  
      DIMENSION Q(MTXD  , *), F(MTXD  , *), A(MTXD  , *)                
C          LOAD WORK ARRAY WITH INPUT VALUES                            
      DO 10 J=1,N                                                       
      DO 10 I=1,N                                                       
 10   A(I,J)=Q(I,J)                                                     
      D=1.0                                                             
        I = 1                                                           
      DO 110 J=1,N                                                      
        GO TO (60,40,20),I                                              
 20     K = J-2                                                         
      DO 30 L=1,K                                                       
      DO 30 M=J,N                                                       
 30     A(J-1,M) = A(J-1,M) - A(L,J-1)*A(L,M)                           
 40     K = J-1                                                         
      DO 50 L=1,K                                                       
 50     A(J,J) = A(J,J) - A(L,J)*A(L,J)                                 
        I = 2                                                           
 60     D = D*A(J,J)                                                    
      IF(A(J,J)) 70, 70, 80                                             
 70   GO TO 190                                                         
 80      A(J,N+3) = SQRT  (A(J,J))                                      
      DO 90 L=J,N                                                       
 90     A(J,L) = A(J,L)/A(J,N+3)                                        
      DO 100 L=1,J                                                      
 100    A(L,J) = A(L,J)/A(J,N+3)                                        
 110    I = I+1                                                         
C     INVERSION OF U                                                    
      DO 120 I=2,N                                                      
        J = I-1                                                         
      DO 120 K=1,J                                                      
 120    A(I,K) = -A(K,I)                                                
      DO 130 I=3,N                                                      
        J = I-2                                                         
      DO 130 K=1,J                                                      
        L = I-K-1                                                       
        M = I                                                           
      DO 130 IJ=1,K                                                     
        M = M-1                                                         
 130    A(I,L) = A(I,L) - A(I,M)*A(L,M)                                 
C     COMPUTATION OF U INVERSE * U INVERSE TRANSPOSE                    
      DO 150 I=1,N                                                      
      DO 150 J=I,N                                                      
        A(I,N+4) = 0.0                                                  
      DO 140 K=J,N                                                      
 140    A(I,N+4) = A(I,N+4) + A(K,I)*A(K,J)                             
 150    A(I,J) = A(I,N+4)                                               
      DO 160 I=1,N                                                      
      DO 160 J=I,N                                                      
 160    A(I,J) = A(I,J)/A(I,N+3)                                        
      DO 170 I=1,N                                                      
      DO 170 J=1,I                                                      
 170    A(J,I) = A(J,I)/A(I,N+3)                                        
      DO 180 K=1,N                                                      
      DO 180 L=K,N                                                      
 180    A(L,K) = A(K,L)                                                 
 190  CONTINUE                                                          
C          MOVE RESULTS TO OUTPUT ARRAY                                 
      DO 200 J=1,N                                                      
      DO 200 I=1,N                                                      
      F(I,J)=A(I,J)                                                     
 200  CONTINUE                                                          
      RETURN                                                            
      END                                                               
      SUBROUTINE IMINV (A,N,D,L,M)                                      
C                                                                       
C     ..................................................................
C                                                                       
C        SUBROUTINE IMINV                                               
C                                                                       
C        PURPOSE                                                        
C           INVERT A MATRIX                                             
C                                                                       
C        USAGE                                                          
C           CALL IMINV (A,N,D,L,M)                                      
C                                                                       
C        DESCRIPTION OF PARAMETERS                                      
C           A - INPUT MATRIX, DESTROYED IN COMPUTATION AND REPLACED BY  
C               RESULTANT INVERSE.                                      
C           N - ORDER OF MATRIX A                                       
C           D - RESULTANT DETERMINANT                                   
C           L - WORK VECTOR OF LENGTH N                                 
C           M - WORK VECTOR OF LENGTH N                                 
C                                                                       
C        REMARKS                                                        
C           MATRIX A MUST BE A GENERAL MATRIX                           
C                                                                       
C        SUBROUTINES AND FUNCTION SUBPROGRAMS REQUIRED                  
C           NONE                                                        
C                                                                       
C        METHOD                                                         
C           THE STANDARD GAUSS-JORDAN METHOD IS USED. THE DETERMINANT   
C           IS ALSO CALCULATED. A DETERMINANT OF ZERO INDICATES THAT    
C           THE MATRIX IS SINGULAR.                                     
C                                                                       
C     ..................................................................
C                                                                       
      DIMENSION A(*),L(*),M(*)                                          
C                                                                       
C        ...............................................................
C                                                                       
C        IF A DOUBLE PRECISION VERSION OF THIS ROUTINE IS DESIRED, THE  
C        C IN COLUMN 1 SHOULD BE REMOVED FROM THE DOUBLE PRECISION      
C        STATEMENT WHICH FOLLOWS.                                       
C                                                                       
C     DOUBLE PRECISION A, D, BIGA, HOLD                                 
C                                                                       
C        THE C MUST ALSO BE REMOVED FROM DOUBLE PRECISION STATEMENTS    
C        APPEARING IN OTHER ROUTINES USED IN CONJUNCTION WITH THIS      
C        ROUTINE.                                                       
C                                                                       
C        THE DOUBLE PRECISION VERSION OF THIS SUBROUTINE MUST ALSO      
C        CONTAIN DOUBLE PRECISION FORTRAN FUNCTIONS.  ABS IN STATEMENT  
C        10 MUST BE CHANGED TO DABS.                                    
C                                                                       
C        ...............................................................
C                                                                       
C        SEARCH FOR LARGEST ELEMENT                                     
C                                                                       
      D=1.0                                                             
      NK=-N                                                             
      DO 80 K=1,N                                                       
      NK=NK+N                                                           
      L(K)=K                                                            
      M(K)=K                                                            
      KK=NK+K                                                           
      BIGA=A(KK)                                                        
      DO 20 J=K,N                                                       
      IZ=N*(J-1)                                                        
      DO 20 I=K,N                                                       
      IJ=IZ+I                                                           
C  10 IF (DABS(BIGA)-DABS(A(IJ))) 15,20,20                              
   10 IF(ABS(BIGA)-ABS(A(IJ))) 15,20,20                                 
   15 BIGA=A(IJ)                                                        
      L(K)=I                                                            
      M(K)=J                                                            
   20 CONTINUE                                                          
C                                                                       
C        INTERCHANGE ROWS                                               
C                                                                       
      J=L(K)                                                            
      IF(J-K) 35,35,25                                                  
   25 KI=K-N                                                            
      DO 30 I=1,N                                                       
      KI=KI+N                                                           
      HOLD=-A(KI)                                                       
      JI=KI-K+J                                                         
      A(KI)=A(JI)                                                       
   30 A(JI) =HOLD                                                       
C                                                                       
C        INTERCHANGE COLUMNS                                            
C                                                                       
   35 I=M(K)                                                            
      IF(I-K) 45,45,38                                                  
   38 JP=N*(I-1)                                                        
      DO 40 J=1,N                                                       
      JK=NK+J                                                           
      JI=JP+J                                                           
      HOLD=-A(JK)                                                       
      A(JK)=A(JI)                                                       
   40 A(JI) =HOLD                                                       
C                                                                       
C        DIVIDE COLUMN BY MINUS PIVOT (VALUE OF PIVOT ELEMENT IS        
C        CONTAINED IN BIGA)                                             
C                                                                       
   45 IF(BIGA) 48,46,48                                                 
   46 D=0.0                                                             
      RETURN                                                            
   48 DO 55 I=1,N                                                       
      IF(I-K) 50,55,50                                                  
   50 IK=NK+I                                                           
      A(IK)=A(IK)/(-BIGA)                                               
   55 CONTINUE                                                          
C                                                                       
C        REDUCE MATRIX                                                  
C                                                                       
      DO 65 I=1,N                                                       
      IK=NK+I                                                           
      IJ=I-N                                                            
      DO 65 J=1,N                                                       
      IJ=IJ+N                                                           
      IF(I-K) 60,65,60                                                  
   60 IF(J-K) 62,65,62                                                  
   62 KJ=IJ-I+K                                                         
      A(IJ)=A(IK)*A(KJ)+A(IJ)                                           
   65 CONTINUE                                                          
C                                                                       
C        DIVIDE ROW BY PIVOT                                            
C                                                                       
      KJ=K-N                                                            
      DO 75 J=1,N                                                       
      KJ=KJ+N                                                           
      IF(J-K) 70,75,70                                                  
   70 A(KJ)=A(KJ)/BIGA                                                  
   75 CONTINUE                                                          
C                                                                       
C        PRODUCT OF PIVOTS                                              
C                                                                       
      D=D*BIGA                                                          
C                                                                       
C        REPLACE PIVOT BY RECIPROCAL                                    
C                                                                       
      A(KK)=1.0/BIGA                                                    
   80 CONTINUE                                                          
C                                                                       
C        FINAL ROW AND COLUMN INTERCHANGE                               
C                                                                       
      K=N                                                               
  100 K=(K-1)                                                           
      IF(K) 150,150,105                                                 
  105 I=L(K)                                                            
      IF(I-K) 120,120,108                                               
  108 JQ=N*(K-1)                                                        
      JR=N*(I-1)                                                        
      DO 110 J=1,N                                                      
      JK=JQ+J                                                           
      HOLD=A(JK)                                                        
      JI=JR+J                                                           
      A(JK)=-A(JI)                                                      
  110 A(JI) =HOLD                                                       
  120 J=M(K)                                                            
      IF(J-K) 100,100,125                                               
  125 KI=K-N                                                            
      DO 130 I=1,N                                                      
      KI=KI+N                                                           
      HOLD=A(KI)                                                        
      JI=KI-K+J                                                         
      A(KI)=-A(JI)                                                      
  130 A(JI) =HOLD                                                       
      GO TO 100                                                         
  150 RETURN                                                            
      END                                                               
