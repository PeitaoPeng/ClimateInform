      subroutine msf(m,y,yh,yl,ph,pm,pl,fhl,dt) 
#include "parm.s.h"
c... call msf(1000.,y,yh,yl,30.,45.,60.,0.90,1.)
C-----------------------------------------------------------------C  
c.. set n=m in following parameter statment ............
      parameter(n=ltime,n3=n+3)
      real y(m),yh(m),yl(m)
      real X(n),Y1(n),W(n),A(n3),B(n3),C(n3),V(n),H(n,7),d(n3)
c     print *,' msf ',y(1),y(500)
c     write(6,777) y
 777  format(10f7.3)
      m3=m+3
      do 1 i=1,m                                               
    1 x(i)=float(i)*dt                                             
      DO 75 I=1,m                                                     
   75 W(I)=1.0           
c... starting high pass and low pass filtering ........
   85 P1=ph   !  P1 = TRUNCATED PERIOD OF HIGH FREQUENCY BAND      
      P2=pl   !  P2 = TRUNCATED PERIOD OF LOW FREQUENCY BAND        
      P3=pm   !  P3 = ANOTHER PERIOD AND  P1 < P3 < P2      
      PF=fhl  !  PF = PASSED AMOUNT OF P1 OR P2                      
      RF=1.0-PF      
      CALL FV1(P1,P2,DT,RF,PF,M,M3,W,X,Y,yh,A,B,C,D,H,yl,V,Y1,P3)  
c     CALL FV1(P1,P2,DT,RF,PF,N,N3,W,X,Y,yh,A,B,C,D,H,yl,V,Y1,P3)  
c     print *,'period-h=',ph,' period-m=',pm,' period-l=',pl
c     print *,'high pass filter:'
c     print *,'freq.resp',p1,' freq.resp',p3,' freq.resp',p2
      f1=1.0-P1                   
      f2=1.0-P2                  
      f3=1.0-P3                 
c     print *,'low pass filter:'
c      print *,'freq.resp',f1,' freq.resp',f3,' freq.resp',f2
c....... save high-pass series ...........      
c     WRITE(11,'(12f6.2)') yh     
c....... save low-pass series ...........      
c     WRITE(12,'(12f6.1)') yl   
c      print *,'--- The filtering calculation has been finished ---' 
      return
      END                                                          
C....................                                             
      SUBROUTINE FV1(P1,P2,DT,RF,PF,N,M,W,X,Y,Z,A,B,C,D,H,U,V,
     /              Y1,PE0) 
C---------------------------------------------------------------------C
C     This subroutine performs high and low pass filtering            C
C     using multi-stage filter.                                       C
C---------------------------------------------------------------------C
C     P1 = INPUT: PERIOD OF HIGH FREQUENCY COMPONENT                  C
C         OUTPUT: FREQUENCY RESPONSE OF THE WAVE                      C
C     P2 = INPUT: PERIOD OF LOW FREQUENCY COMPONENT                   C
C         OUTPUT: FREQUENCY RESPONSE OF THE WAVE                      C
C     DT = INTERVAL OF DATA SERIES                                    C
C     RF = REMAINS OF LOW FREQUENCY COMPONENT                         C
C     PF = PASSES AMOUNT OF HIGH FREQUENCY COMPONENT                  C
C     N  = NUMBER OF SAMPLES                                          C
C     Y(N) = ARRAY OF ORIGINAL DATA SERIES                            C
C     X(N) = ARRAY OF EPOCH VALUES FOR DATA SERIES                    C
C     W(N) = ARRAY OF WEIGHT FUNCTIONS FOR DATA SERIES                C
C     Z(N) = ARRAY OF HIGH-PASS RESULTS (OUTPUT)                      C
C     U(N) = ARRAY OF LOW-PASS RESULTS (OUTPUT)                       C
C     PE0  = INPUT: PERIOD OF ANOTHER HARMONIC WAVE                   C
C           OUTPUT: FREQUENCY RESPONSE OF THE WAVE                    C
C     E = SMOOTHING FACTOR OF THE PERFORMED FILTERING                 C
C         print out from FV1 subroutine directly, no longer parameter C
C     A(M),B(M),C(M),D(M),V(N),Y1(N),H(N)=AUXILIARY ARRAIES (M=N+3)   C
C---------------------------------------------------------------------C
C                                                                      
      real W(N),X(N),Y(N),U(N),V(N),Z(N),A(M),B(M),C(M),D(M),Y1(N),    
     /    H(N,7)                                                      
c     print *,' fv1 ',y(1),y(500)
      PI=2.0*acos(-1.0)
      E1=PI/P1                                                       
      DD=E1*DT*0.50
      CC1=DD*DD                                                     
      CC=CC1-CC1*CC1*7.0/15.0
      DD=1.0-CC 
      PT=DD*E1**6                                                  
      MJ=0                                                        
      PF0=PF                                                     
    2 AF=0.10 
      DA=0.020   
      KKK=8000                                                        
      DO 25 I=1,30                                                   
      AF=AF+DA                                                      
      E2=AF*PT/(1.0-AF)         
      CALL VRES(DT,P2,E2,F2)                                       
      PDD=0.0                 
      DO 20 J=1,10                                                
      PDD=PDD+0.0010  
      MJ0=1                                                      
      PE10=AF                                                   
    5 PE10=PE10*AF                                             
      MJ0=MJ0+1                                               
      IF(PE10.GT.PDD) then
c     print *,'goto 5, pe10 gt pdd ',pe10,pdd
      GOTO 5                                 
      endif
      PE=1.0-F2**MJ0
      PE20=PE                                               
      MK0=1                                                
   10 IF(PE20.LE.RF) then
c     print *,'goto 15, pe20 le rf ',pe20,rf
      GOTO 15                              
      endif
      MK0=MK0+1                                          
      PE20=PE*PE20                                      
      GOTO 10                                          
   15 PE10=(1.0-PE10)**MK0      
      IF(PE10.LT.PF0) then
c     print *,'goto 20, pe10 lt pf0 ',pe10,pf0
      GOTO 20                         
      endif
      MJK=MJ0*MK0                                    
c     print *,'mj0 & mk0 & mjk & kkk ',mj0,mk0,mjk,kkk
      IF(MJK.LE.KKK) THEN                           
      KKK=MJK                                      
      MJ=MJ0                                      
      MK=MK0                                     
      PE1=PE10                                  
      PE2=PE20                                 
      E=E2                                    
c     print *,'mjk & kkk  ',mjk,kkk
      ENDIF                                  
   20 CONTINUE                              
   25 CONTINUE                             
c     print *,'E=',e,' mj=',mj,' mk=',mk 
      IF(MJ.NE.0.AND.MK*MJ.LE.800) then
c     print *,'goto 28 mj=',mj,' mk=',mk 
      GOTO 28                         
      endif
      PF0=PF0-0.020
c     print *,'did not goto 28, pf0 = ',pf0
      IF(PF0.GE.0.80)GOTO 2           
      P1=PE1                                                      
      P2=PF                                                      
      GOTO 70                                                   
   28 IF(MJ*MK.LT.2000) GOTO 30                                
c     print *,' mj=',mj,' mk=',mk,'  kkk=',kkk 
      GOTO 70                                                
   30 DO 40 I=1,N                                           
      Z(I)=Y(I)                                            
   40 Y1(I)=Y(I)                                          
      DO 60 K=1,MK                                       
      DO 50 J=1,MJ                                      
      CALL SMVON(N,M,E,W,X,Z,U,A,B,C,D,H,V,EM)       
      DO 45 I=1,N                                     
   45 Z(I)=U(I)                                      
   50 CONTINUE                                      
      DO 55 I=1,N                                  
      Z(I)=Y1(I)-U(I)                             
   55 Y1(I)=Z(I)                                 
c     print *,'mk=',MK,'  k=',K,' mj=',MJ,' e=',E  
   60 CONTINUE                                                      
      DO 65 I=1,N                                                  
   65 U(I)=Y(I)-Z(I)                                              
      P1=PE1                                                     
      P2=PE2                                                    
      IF(PE0.EQ.0.0) GOTO 70     
      CALL VRES(DT,PE0,E,F0)                                   
      PE0=(1.0-F0**MJ)**MK     
   70 RETURN                                                  
      END                                                    
C.................                                          
      SUBROUTINE SMVON(N,M,E,P,X,Y,U,A,B,C,D,H,Z,EM)                   
      real X(N),Y(N),P(N),U(N),Z(N),A(M),B(M),C(M),D(M),h(n,7)   
c     print *,'smvon ',y(1),y(500),' y'
c     print *,'smvon ',u(1),u(500),' u'
c     print *,'smvon ',z(1),z(500),' z'
      EE=E/float(N-3)   
      SS=6.0/SQRT(X(N)-X(1))   
      DO 20 J=1,M                                                     
      IF (J.LE.3.OR.J.GE.M-2) GOTO 10                                
      S=SS*SQRT(X(J-1)-X(J-2))    
      A(J)=S/(X(J-3)-X(J-2))/(X(J-3)-X(J-1))/(X(J-3)-X(J))          
      B(J)=S/(X(J-2)-X(J-3))/(X(J-2)-X(J-1))/(X(J-2)-X(J))         
      C(J)=S/(X(J-1)-X(J-3))/(X(J-1)-X(J-2))/(X(J-1)-X(J))        
      D(J)=S/(X(J)-X(J-3))/(X(J)-X(J-2))/(X(J)-X(J-1))           
      GOTO 20                                                   
   10 A(J)=0.0  
      B(J)=0.0   
      C(J)=0.0
      D(J)=0.0  
c     print *,j,s,a(j),b(j),c(j),d(j)
   20 CONTINUE                                                 
      DO 30 I=1,N                                             
      DO 30 J=1,7                                            
   30 H(I,J)=0.0   
      DO 40 I=1,N                                           
      Z(I)=EE*P(I)*Y(I)                                    
      H(I,1)=A(I)*D(I)                                    
      H(I,2)=A(I+1)*C(I+1)+B(I)*D(I)                     
      H(I,3)=A(I+2)*B(I+2)+B(I+1)*C(I+1)+C(I)*D(I)      
      H(I,4)=EE*P(I)+A(I+3)*A(I+3)+B(I+2)*B(I+2)       
     /      +C(I+1)*C(I+1)+D(I)*D(I)                  
      H(I,5)=A(I+3)*B(I+3)+B(I+2)*C(I+2)+C(I+1)*D(I+1)             
      H(I,6)=A(I+3)*C(I+3)+B(I+2)*D(I+2)                          
   40 H(I,7)=A(I+3)*D(I+3)                                       
      DO 50 I=1,3                                               
      A(I)=0.0              
      B(I)=0.0             
      C(I)=0.0            
   50 D(I)=0.0           
      DO 60 I=1,N                                              
      S=H(I,1)*A(I)+H(I,2)                                    
      Q=S*A(I+1)+H(I,1)*B(I)+H(I,3)                          
      T=Q*A(I+2)+S*B(I+1)+H(I,1)*C(I)+H(I,4)                
      A(I+3)=-(Q*B(I+2)+S*C(I+1)+H(I,5))/T                 
      B(I+3)=-(Q*C(I+2)+H(I,6))/T                         
      C(I+3)=-H(I,7)/T                                   
   60 D(I+3)=(Z(I)-H(I,1)*D(I)-S*D(I+1)-Q*D(I+2))/T     
      U(N)=D(M)                                        
      U(N-1)=A(M-1)*U(N)+D(M-1)                       
      U(N-2)=A(M-2)*U(N-1)+B(M-2)*U(N)+D(M-2)        
      DO 70 I=4,N                                   
      J=N-I+1                                      
   70 U(J)=A(J+3)*U(J+1)+B(J+3)*U(J+2)            
     /     +C(J+3)*U(J+3)+D(J+3)                 
      EM=0.0   
      DO 80 I=1,N                               
      Z(I)=Y(I)-U(I)                           
   80 EM=EM+Z(I)*Z(I)                         
      EM=SQRT(EM/float(N-3))  
      RETURN                                 
      END                                   
C............                              
      SUBROUTINE VRES(DT,P,E,F0)          
C---------------------------------------------------------------- 
C     This subroutine calculates the frequency response          
C                                  of Vondrak filter            
C     DT= INTERVAL OF DATA SERIES                              
C     P = PERIOD OF HARMONIC WAVE                             
C     E = SMOOTHING FACTOR                                   
C     F0= FREQUENCY RESPONSE OF THE WAVE                    
C----------------------------------------------------------------  
      PI=2.0*acos(-1.0)   
      E1=PI/P            
      DD=E1*DT*0.50     
      CC1=DD*DD         
      CC=CC1-CC1*CC1*7.0/15.0    
      DD=1.0-CC                
      PT=E1**6         
      F0=E/(E+PT*DD)  
      RETURN         
      END           
