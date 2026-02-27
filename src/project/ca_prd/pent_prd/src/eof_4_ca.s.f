CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC       
      SUBROUTINE EOFS_4_CA (A,M,N,MN,EVAL,EVCT,PC,WK,ID)                   
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC       
C**  SUBROUTINE FOR COMPUTE THE S-MODE EOF   --- NOV. 1990              
C**  BY CALLING  EVCSF IN IMSL LIB                                      
C   INPUT:                                                              
C   -- A(M,N): INPUT DATA WITH SPACE DIM. OF M; TIME DIM. OF N.         
C   --   ID: INDEX TO COMPUTE THE DISPERSION MATRIX                     
C         < 0  CROSS-PRODUCT                                            
C         = 0  COVARIANCE MATRIX                                        
C         > 0  CORRELATION MATRIX                                       
C   --   MN:THE MIN (M,N)                                               
C   OUTPUT:                                                             
C   -- EVAL(MN): % OF EIGENVALUES IN DECREASING ORDER                   
C   -- EVCT(M,MN): EOFS, JTH COLUMN CORRESPONDING TO EVAL(J)            
C   -- PC(MN,N): PRINCIPAL COMPONENT, ITH ROW CORRESPONDING TO ITH EOF  
C                                                                       
      DIMENSION A(M,N),EVAL(MN),EVCT(M,MN),PC(MN,N),WK(MN,M)            
C                                                                       
C..  COMPUTE  THE COVARIANCE  (IN WK)                                   
      CALL COVAR (A,WK,M,N,ID,MN)                                       
C                                                                       
C..  COMPUTE THE EIGENVALUES AND EIGENVECTORS                           
      CALL jacobi(WK,MN,M,EVAL,EVCT,NROT)                                 
      CALL eigsrt(EVAL,EVCT,MN,M)
C                                                                       
      IF (M-N) 50,50,40                                                 
C.. IF M>N  COMPUTE THE SPACE-COEFFICIENTS                              
 40   DO 110 I=1,MN                                                     
        DO 110 J=1,N                                                    
 110    PC(I,J)=EVCT(J,I)                                               
      CALL SCOEF (PC,A,EVCT,M,N,MN)                                     
      CALL RATE(EVAL,MN)                                                
C.. in order to have dimensional EVCT
      return                                                            
C                                                                       
C.. IF M<= N  COMPUTE THE TIME-COEFFICIENTS                             
 50   CALL STANDA (EVCT,M,M,MN,1)                                       
      CALL TCOEF (EVCT,A,PC,MN,M,N,MN)                                  
C.. compute the percentage explained by each PCs
      CALL RATE(EVAL,MN)                                                
c     write(6,*) EVAL
C                                                                       
      RETURN                                                            
      END                                                               
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC         
      SUBROUTINE RATE(EVAL,M)                                           
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC         
C..  COMPUTE THE VARIANCE OF EOFS                                       
      DIMENSION EVAL(M)                                                 
      SV=0.                                                             
      DO 101 I=1,M                                                      
 101  SV=SV+ABS(EVAL(I))                                                
      DO 102 I=1,M                                                      
 102  EVAL(I)=EVAL(I)/SV                                                
      RETURN                                                            
      END                                                               
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC         
      SUBROUTINE RATE2(EVAL,M,REVAL,NMOD)                               
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC         
C..  COMPUTE THE VARIANCE OF EOFS                                       
      DIMENSION EVAL(M),REVAL(NMOD)                                     
      SEV=0.                                                            
      DO 100 I=1,NMOD                                                   
 100  SEV=SEV+EVAL(I)                                                   
C                                                                       
      SV=0.                                                             
      DO 101 I=1,NMOD                                                   
 101  SV=SV+ABS(REVAL(I))                                               
      DO 102 I=1,NMOD                                                   
 102  REVAL(I)=SEV*REVAL(I)/SV                                          
      RETURN                                                            
      END                                                               
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC         
      SUBROUTINE STANDA (A,LDA,M,N,IROW)                                
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC         
C.. NORMALIZE THE EIGENVECTORS (TO STANDARD DEVIATION =1)               
C -- IROW = 1 FOR COLOMN                                                
C           2     ROW                                                   
C                                                                       
      DIMENSION A(LDA,N)                                                
      GOTO (10,20) IROW                                                 
C...  FOR COLUMN                                                        
 10   DO 101 J=1,N                                                      
         DV=0.                                                          
         DO 102 I=1,M                                                   
 102     DV=DV+A(I,J)*A(I,J)                                            
      DV=SQRT(DV)                                                       
         DO 103 I=1,M                                                   
 103     A(I,J)=A(I,J)/DV                                               
 101  CONTINUE                                                          
      RETURN                                                            
C.. FOR ROW                                                             
 20   DO 201 I=1,M                                                      
         DV=0.                                                          
         DO 202 J=1,N                                                   
 202     DV=DV+A(I,J)*A(I,J)                                            
      DV=SQRT(DV)                                                       
         DO 203 J=1,N                                                   
 203     A(I,J)=A(I,J)/DV                                               
 201  CONTINUE                                                          
      RETURN                                                            
      END                                                               
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC         
      SUBROUTINE COVAR (A,R,M,N,ID,MN)                                  
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC         
C**  SUBROUTINE  FOR COMPUTE COVARIANCE                                 
C                                                                       
      DIMENSION A(M,N),R(MN,MN)                                         
C                                                                       
      IF (ID) 20,10,10                                                  
C.. COMPUTE THE DEPARTURE                                               
 10   DO 101 I=1,M                                                      
        AM=0.0                                                          
        DO 102 J=1,N                                                    
 102    AM=AM+A(I,J)                                                    
        AM=AM/FLOAT(N)                                                  
        DO 103 J=1,N                                                    
 103      A(I,J)=A(I,J)-AM                                              
 101  CONTINUE                                                          
      IF (ID.EQ.0) GOTO 20                                              
C.. COMPUTE THE STANDARD DEVIATION                                      
      DO 201 I=1,M                                                      
      DV=0.                                                             
      DO 202 J=1,N                                                      
 202  DV=DV+A(I,J)*A(I,J)                                               
      DV=SQRT(DV/FLOAT(N))                                              
      DO 201 J=1,N                                                      
      A(I,J)=A(I,J)/DV                                                  
 201  CONTINUE                                                          
 20   CONTINUE                                                          
C                                                                       
C.. THE DISPERSION MATRIX                                               
      IF (M-N) 30,30,40                                                 
 30   DO 105 I=1,MN                                                     
        DO 105 J=1,I                                                    
          R(I,J)=0.0                                                    
          DO 104 K=1,N                                                  
 104      R(I,J)=R(I,J)+A(I,K)*A(J,K)                                   
        R(J,I)=R(I,J)                                                   
 105  CONTINUE                                                          
      RETURN                                                            
C                                                                       
 40   DO 106 I=1,MN                                                     
        DO 106 J=1,I                                                    
          R(I,J)=0.0                                                    
          DO 107 K=1,M                                                  
 107      R(I,J)=R(I,J)+A(K,I)*A(K,J)                                   
        R(J,I)=R(I,J)                                                   
 106  CONTINUE                                                          
      RETURN                                                            
      END                                                               
C                                                                       
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC       
      SUBROUTINE TCOEF (VT,A,TC,LDTC,M,N,K)                             
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC       
C**  SUBROUTINE FOR COMPUTE THE TIME-COEFFICIENTS                       
      DIMENSION  A(M,N),VT(M,K),TC(LDTC,N)                              
C                                                                       
C..  COMPUTE THE TIME-COEFFICIENTS                                      
      DO 104 I=1,K                                                      
      DO 104 J=1,N                                                      
      TC(I,J)=0.0                                                       
      DO 105 KK=1,M                                                     
 105  TC(I,J)=TC(I,J)+VT(KK,I)*A(KK,J)                                  
 104  CONTINUE                                                          
      RETURN                                                            
      END                                                               
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC       
      SUBROUTINE SCOEF (TC,A,EVT,M,N,K)                                 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC       
C**  SUBROUTINE FOR COMPUTE THE SPACE-COEFFICIENTS                      
      DIMENSION A(M,N),EVT(M,K),TC(K,N)                                 
C                                                                       
      DO 104 I=1,M                                                      
      DO 104 J=1,K                                                      
      EVT(I,J)=0.0                                                      
      DO 105 KK=1,N                                                     
 105  EVT(I,J)=EVT(I,J)+A(I,KK)*TC(J,KK)                                
 104  CONTINUE                                                          
      RETURN                                                            
      END                                                               
c
      SUBROUTINE eigsrt(d,v,n,np)
      INTEGER n,np
c     REAL d(np),v(np,np)
      REAL d(n),v(np,n)
      INTEGER i,j,k
      REAL p
      do 13 i=1,n-1
        k=i
        p=d(i)
        do 11 j=i+1,n
          if(d(j).ge.p)then
            k=j
            p=d(j)
          endif
11      continue
        if(k.ne.i)then
          d(k)=d(i)
          d(i)=p
          do 12 j=1,n
            p=v(j,i)
            v(j,i)=v(j,k)
            v(j,k)=p
12        continue
        endif
13    continue
      return
      END
      SUBROUTINE jacobi(a,n,np,d,v,nrot)
      INTEGER n,np,nrot,NMAX
C     REAL a(np,np),d(np),v(np,np)
      REAL a(n,np),d(n),v(np,n)
      PARAMETER (NMAX=2000)
      INTEGER i,ip,iq,j
      REAL c,g,h,s,sm,t,tau,theta,tresh,b(NMAX),z(NMAX)
      do 12 ip=1,n
        do 11 iq=1,n
          v(ip,iq)=0.
11      continue
        v(ip,ip)=1.
12    continue
      do 13 ip=1,n
        b(ip)=a(ip,ip)
        d(ip)=b(ip)
        z(ip)=0.
13    continue
      nrot=0
      do 24 i=1,50
        sm=0.
        do 15 ip=1,n-1
          do 14 iq=ip+1,n
            sm=sm+abs(a(ip,iq))
14        continue
15      continue
        if(sm.eq.0.)return
        if(i.lt.4)then
          tresh=0.2*sm/n**2
        else
          tresh=0.
        endif
        do 22 ip=1,n-1
          do 21 iq=ip+1,n
            g=100.*abs(a(ip,iq))
            if((i.gt.4).and.(abs(d(ip))+
     *g.eq.abs(d(ip))).and.(abs(d(iq))+g.eq.abs(d(iq))))then
              a(ip,iq)=0.
            else if(abs(a(ip,iq)).gt.tresh)then
              h=d(iq)-d(ip)
              if(abs(h)+g.eq.abs(h))then
                t=a(ip,iq)/h
              else
                theta=0.5*h/a(ip,iq)
                t=1./(abs(theta)+sqrt(1.+theta**2))
                if(theta.lt.0.)t=-t
              endif
              c=1./sqrt(1+t**2)
              s=t*c
              tau=s/(1.+c)
              h=t*a(ip,iq)
              z(ip)=z(ip)-h
              z(iq)=z(iq)+h
              d(ip)=d(ip)-h
              d(iq)=d(iq)+h
              a(ip,iq)=0.
              do 16 j=1,ip-1
                g=a(j,ip)
                h=a(j,iq)
                a(j,ip)=g-s*(h+g*tau)
                a(j,iq)=h+s*(g-h*tau)
16            continue
              do 17 j=ip+1,iq-1
                g=a(ip,j)
                h=a(j,iq)
                a(ip,j)=g-s*(h+g*tau)
                a(j,iq)=h+s*(g-h*tau)
17            continue
              do 18 j=iq+1,n
                g=a(ip,j)
                h=a(iq,j)
                a(ip,j)=g-s*(h+g*tau)
                a(iq,j)=h+s*(g-h*tau)
18            continue
              do 19 j=1,n
                g=v(j,ip)
                h=v(j,iq)
                v(j,ip)=g-s*(h+g*tau)
                v(j,iq)=h+s*(g-h*tau)
19            continue
              nrot=nrot+1
            endif
21        continue
22      continue
        do 23 ip=1,n
          b(ip)=b(ip)+z(ip)
          d(ip)=b(ip)
          z(ip)=0.
23      continue
24    continue
      pause 'too many iterations in jacobi'
      return
      END

