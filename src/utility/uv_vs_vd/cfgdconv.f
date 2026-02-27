      SUBROUTINE GRDCOF(A,AR,P,WK,IFAX,TRIGS,IMAX,JMAX,KMAX,MMAX,    
     +                MP,ITR,GUSW,LROMB)                                    
      COMPLEX A(KMAX)                                                
      REAL   GUSW(JMAX)                                             
      DIMENSION AR(IMAX,JMAX),P(JMAX,KMAX)                         
      DIMENSION WK(IMAX,JMAX)                                     
      DIMENSION IFAX(10),TRIGS(*)                                
c 
      CALL FFT991(AR,WK,TRIGS,IFAX,1,IMAX,IMAX,JMAX,0,-1)       
c
      DO 26 K=1,KMAX                                                    
      A(K)=CMPLX(0.00,0.00)                                            
   26 CONTINUE                                                        
      K=0                                                            
      DO 20 M=1,MP                                                  
      I1=2*M-1                                                     
      I2=2*M                                                      
      LMP=(M-1)*LROMB      !! RHOMBOIDAL
      DO 20 N=M,MP+LMP                                           
      K=K+1                                                     
      TR=0.00                                                  
      TI=0.00                                                 
      DO 22 J=1,JMAX                                         
      TR=TR+AR(I1,J)*(P(J,K)*GUSW(J))                       
      TI=TI+AR(I2,J)*(P(J,K)*GUSW(J))                      
   22 CONTINUE                                            
      A(K)=CMPLX(TR,TI)                                  
   20 CONTINUE                                          
      RETURN                                           
      END                                             
C                                                    
C---------------------------------------------------------------------
      SUBROUTINE COFGRD(A,AP,P,WK,IFAX,TRIGS,IMAX,JMAX,KMAX,MMAX,  
     +                MP,ITR,LROMB)                                    
c
      COMPLEX A(KMAX),AP(MMAX,JMAX)                                    
      DIMENSION P(JMAX,KMAX),WK(IMAX,JMAX)                            
      DIMENSION IFAX(10),TRIGS(*)                                      
      DO 10 M=1,MMAX                                                  
      DO 10 J=1,JMAX                                                 
      AP(M,J)=CMPLX(0.00,0.00)                                      
   10 CONTINUE                                                     
      K=0                                                         
      DO 20 M=1,MP                                               
      LMP=(M-1)*LROMB      !! RHOMBOIDAL
      DO 20 N=M,MP+LMP                                          
      K=K+1                                                    
      DO 20 J=1,JMAX                                          
      AP(M,J)=AP(M,J)+A(K)*CMPLX(P(J,K),0.00)                
   20 CONTINUE                                             
      CALL FFT991(AP,WK,TRIGS,IFAX,1,IMAX,IMAX,JMAX,0,1)  
      RETURN                                             
      END                                               
