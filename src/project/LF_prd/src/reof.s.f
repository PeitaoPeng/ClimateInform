CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC       
      SUBROUTINE EOFS (A,M,N,MN,EVAL,EVCT,PC,WK,ID)                     
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
C                                                                       
      RETURN                                                            
      END                                                               
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC       
      SUBROUTINE REOFS  (A,M,N,MN,WK,ID,EVAL,EVCT,PC       
     &                 ,NMOD,REVAL,REVCT,RPC,T,RWORK,RWORK2)                         
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC       
C**  SUBROUTINE FOR COMPUTE THE S-MODE ROTATIONAL EOF                   
C**  BY CALLING EVCSF IN IMSL        ---  NOV. 1990                     
C   INPUT:                                                              
C   -- A(M,N): INPUT DATA WITH SPACE DIM. OF M; TIME DIM. OF N.         
C   --   ID: INDEX TO COMPUTE THE DISPERSION MATRIX                     
C         < 0  CROSS-PRODUCT                                            
C         = 0  COVARIANCE MATRIX                                        
C         > 0  CORRELATION MATRIX                                       
C   --   MN:THE MIN (M,N)                                               
C   --   NMOD: THE NO. TO  ROTATE                                       
C   OUTPUT:                                                             
C   -- EVAL(MN): % OF EIGENVALUES IN DECREASING ORDER                   
C   -- EVCT(M,MN): EOFS, JTH COLUMN CORRESPONDING TO EVAL(J)            
C   -- PC(MN,N): PRINCIPAL COMPONENT, ITH ROW CORRESPONDING TO ITH EOF  
C   -- REVAL(NMOD): % OF ROTATED EIGENVAL IN DECREASING ORDER           
C   -- REVCT(M,NMOD): ROTATE EOFS, JTH COLUMN CORRESPONDING TO REVAL(J) 
C   -- RPC(NMOD,N): ROTATE PC, ITH ROW CORRESPONDING TO ITH EOF         
C                                                                       
      DIMENSION A(M,N),EVAL(MN),EVCT(M,MN),PC(MN,N),WK(MN,M )           
     &    ,REVAL(NMOD),REVCT(M,NMOD),T(NMOD,NMOD),VAR(1),RPC(NMOD,N)    
     &    ,RWORK(M),RWORK2(M,NMOD)
C                                                                       
C..  COMPUTE  THE COVARIANCE  (IN WK)                                   
      CALL COVAR (A,WK,M,N,ID,MN)                                       
C                                                                       
C..  COMPUTE THE EIGENVALUES AND EIGENVECTORS                           
      CALL jacobi(WK,MN,M,EVAL,EVCT,NROT)                                 
      CALL eigsrt(EVAL,EVCT,MN,M)
C     write(6,*)'eval=',EVAL
C                                                                       
      IF (M-N) 50,50,40                                                 
C                                                                       
C..  IF M>N  COMPUTE THE SPACE-COEEFICIENTS                             
 40   CONTINUE                                                          
      DO 110 I=1,MN                                                     
        DO 110 J=1,N                                                    
 110    PC(I,J)=EVCT(J,I)                                               
      CALL SCOEF (PC,A,EVCT,M,N,MN)                                     
 50   CONTINUE                                                          
      CALL STANDA (EVCT,M,M,MN,1)                                       
      CALL TCOEF (EVCT,A,PC,MN,M,N,MN)                                  
C                                                                       
C...  ROTATE THE EIGENVEVTORS  BEGIN  ......                            
      DO 208 I=1,M                                                      
      DO 208 J=1,NMOD                                                   
c       EVCT(I,J)= EVCT(I,J)*SQRT(EVAL(J))                              
        RWORK2(I,J)= EVCT(I,J)*SQRT(EVAL(J))                              
 208  CONTINUE                                                          
C                                                                       
      PRINT *, '......... CALL OFROTA BEGIN'               
C
      parameter(eps=0.00001, delta=0.00001, norm=0)
C
      CALL ofrota(RWORK2,M,M,NMOD,norm,0,60,1.0,eps,delta,
     &            REVCT,M,T,NMOD,REVAL,RWORK,ier,NMOD,vvv)
c
c     to calculate the % of var explained by eofs
c
      power = 0.0
      do 6001 km = 1, N
      do 6001 ks = 1, M
        power = power + A(ks,km)*A(ks,km)
 6001 continue
c
      do 6002 km = 1, nmod
        reval(km) = reval(km) / power
        eval(km) = eval(km) / power
        write  (6,*)  'km=',km,' eval=',eval(km),' reval=',reval(km)
 6002 continue
C
C..   NORMALIZE THE EVCT and ROTATED EVCT
      CALL STANDA (REVCT,M,M,NMOD,1)
      CALL STANDA (EVCT,M,M,MN,1)                                       
C.. ROTATE PC                                                           
      PRINT *, '.........  ROTATE PC'               
      DO 207 I=1,NMOD                                                   
      DO 207 J=1,N                                                      
 207     PC(I,J)=PC(I,J)/SQRT(EVAL(I))                                  
      DO 206 I=1,NMOD                                                   
      DO 206 J=1,N                                                      
         RPC(I,J)=0.                                                    
         DO 206 K=1,NMOD                                                
 206     RPC(I,J)=RPC(I,J)+T(K,I)*PC(K,J)                               
      PRINT *, '...... OK ROTATION'                                     
C
C.. NORMALIZE THE EVAL AND REVAL                                        
      CALL RATE(EVAL,MN)                                                
C     CALL RATE2(EVAL,MN,REVAL,NMOD)                                    
      RETURN                                                            
      END                                                               
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
c     ************************************************************************
c     **                                                                    **
c     **  subroutines related to eof rotation                               ** 
c     **                                                                    ** 
c     **  please do not change items below                                  ** 
c     **                                                                    ** 
c     ************************************************************************
c 
c
c Complex version of ofrota (by John Horel) - see IMSL documentation
c for varimax w=1., quartimax w=0.
c ********* typical parameter values *********
c         norm=1 (=1, Row normalization option; =0 no normalization performed)
c         w=1   (=0.0 quartimax; =1 varimax;)
c         ii=0
c         maxit=60
c         eps=0.00001
c         delta=0.00001
c         a is input array of size nv by nf
c         a values should be (complex) correlations between the original
c         data and the principal components
c         nv is the number of variables
c         nf is the number of axes to be rotated
c         b is the output array of size ib by nf
c         f is the percent of variance explained by each rcpc
c         t is the transformation matrix - it contains the correlations
c         between the unrotated and rotated principal components
c         wk is a work array of size ia
c         ier returns an error message
c         vvv contains an iteration parameter
      subroutine ofrota(a,ia,nv,nf,norm,ii,maxit,w,eps,delta,b,ib,t,it,
     $                  f,wk,ier,iwrt,vvv)
      integer ia,nv,nf,norm,ii,maxit,ib,it,ier
      dimension a(ia,iwrt),b(ib,nf),f(nf),t(it,nf),wk(ia)
      real w,eps,delta
      integer nff,i,j,mv,nc,ncount,nfm1,jp1,k
      real as,bb,bs,cosp,eps4,fourth,one,hold,phi,sinp,tt,tvv,two,u,v,
     $vv,vvv,wsnv,zero
      real temp,ss,dd,save,dnv
c-$-  complex a,b,b1,
      data zero,one,two,fourth,phi/0.0,1.0,2.0,0.25,0.0/
c* dont let a(,) be equal exactly zero anywhere.
      do j=1,nf
       do i=1,nv
        if(a(i,j).eq.0.00000)a(i,j)=1.0e-5
       end do
      end do
      if(nf.le.nv.and.ia.ge.nv.and.ib.ge.nv.and.it.ge.nf) go to 5
      ier=129
      go to 9000
   5  ier=0
      dnv=nv*nv
      nff=((nf-1)*nf)/2
      eps4=eps*fourth
      wsnv=w/nv
c initialize transformation matrix as the identity matrix
      do 15 i=1,nf
      do 10 j=1,nf
      t(i,j)=zero
  10  continue
      t(i,i)=one
  15  continue
      if(norm.eq.0) go to 35
c perform row normalization
c normalization weights each gridpoint equally in the rotation - with
c no normalization gridpoints with smaller common variance (in common
c with all other gridpoints) would have less influence
      do 30 i=1,nv
      temp=0.0
      do 20 j=1,nf
      temp=temp+(a(i,j))*(a(i,j))
  20  continue
      hold=sqrt(temp)
      wk(i)=hold
      hold=one/hold
c initialize rcpc matrix (b) as row normalized version of cpc matrix (a)
      do 25 j=1,nf
      b(i,j)=a(i,j)*hold
  25  continue
  30  continue
      go to 50
c initialize rcpc matrix (b) as cpc matrix (a) if row normalization
c was not done
  35  do 45 i=1,nv
      do 40 j=1,nf
      b(i,j)=0.0
      chk=abs(a(i,j))
      if(chk.lt.1.e9)b(i,j)=a(i,j)
c      b(i,j)=a(i,j)
  40  continue
  45  continue
c counters : vv = variance in previous iteration; vvv = variance in
c            current iteration; nc = number of times variance
c            increase is less than critical value
  50  mv=1
      nc=0
      ncount=0
      vvv=zero
c perform iterations (mv = iteration number)
  55  mv=mv+1
      vv=vvv
      temp=0.
c compute variance of squared magnitudes of loadings over all variables
c and rcpc's. this (temp) is the quantity to be maximized
      do 65 j=1,nf
      ss=0.0
      dd=0.0
      do 60 i=1,nv
      save=(b(i,j))*(b(i,j))
      dd=dd+save
      ss=ss+save*save
  60  continue
      temp=temp+((nv*ss)-(w*dd*dd))/dnv
  65  continue
      vvv=temp
      if(nf.le.1) go to 115
      if(mv.le.maxit) go to 70
      ier=66
      go to 115
  70  tvv=vvv-vv
      dvv=delta*vv
c      write(6,401) mv,tvv,dvv,vvv,phi,eps4
 401  format(1x,'iteration n0.',i3,5e12.4)
c continue if variance increases more than critical amount (tvv is
c increase in variance from last iteration; dvv is critical amount)
      if(tvv.gt.dvv) go to 75
      nc=nc+1
c stop iterating after 2nd time variance fails to increase enough
      if(nc.ge.2) go to 115
  75  nfm1=nf-1
c for each iteration rotate each possible pair of rcpc's (j,k)
      do 110 j=1,nfm1
      jp1=j+1
      do 105 k=jp1,nf
      as=zero
      bs=zer0
      tt=zero
      bb=zero
      do 80 i=1,nv
      u=b(i,j)*(b(i,j))-b(i,k)*(b(i,k))
      v=b(i,j)*(b(i,k))+b(i,k)*(b(i,j))
      as=as+u
      bs=bs+v
      bb=bb+(u+v)*(u-v)
      tt=tt+u*v
  80  continue
      tt=tt+tt
      tt=tt-two*as*bs*wsnv
      bb=bb-(as+bs)*(as-bs)*wsnv
      if(abs(tt)+abs(bb).gt.eps) go to 90
c if angle for a particular pair of rcpc's is too small increment ncount
  85  ncount=ncount+1
      if(ncount.lt.nff) go to 105
c exit rotation loop if all possible pairs of rcpc's are sufficiently
c similar (i.e., rotation angle is lt eps/4)
      go to 115
c compute rotation angle
  90  phi=fourth*atan2(tt,bb)
c if angle is too small increment ncount
      if(abs(phi).lt.eps4) go to 85
      cosp=cos(phi)
      sinp=sin(phi)
      ncount=0
c rotate rcpc's j and k through an angle phi
      do 95 i=1,nv
      b1=b(i,j)*cosp+b(i,k)*sinp
      b(i,k)=-1.0*b(i,j)*sinp+b(i,k)*cosp
      b(i,j)=b1
  95  continue
c construct transformation matrix t by rotating through an angle phi
      do 100 i=1,nf
      save=t(i,j)*cosp+t(i,k)*sinp
      t(i,k)=-1.0*t(i,j)*sinp+t(i,k)*cosp
      t(i,j)=save
 100  continue
 105  continue
 110  continue
      go to 55
c bottom of iteration loop - you get here if variance fails to increase
c enough or if you reach maximum number of iterations
 115  if(norm.eq.0) go to 130
c un-normalize rcpc's if they were originally normalized
      do 125 i=1,nv
      hold=wk(i)
      do 120 j=1,nf
      b(i,j)=b(i,j)*hold
 120  continue
 125  continue
c computes sums of squared loadings for each rcpc and stores in array f
 130  do 140 i=1,nf
      temp=0.0
      do 135 k=1,nv
      temp=temp+(b(k,i))*(b(k,i))
 135  continue
      f(i)=temp
 140  continue
c sort array f from highest to lowest
      do 300 i=1,nf
      k=i
      p=f(i)
      ip1=i+1
      if(ip1.gt.nf) go to 260
      do 250 j=ip1,nf
      if(f(j).le.p) go to 250
      k=j
      p=f(j)
 250  continue
 260  if(k.eq.i) go to 300
c re-order f (eigenvalues)
      f(k)=f(i)
      f(i)=p
c re-order b (rcpc's)
      do 275 j=1,nv
      b1=b(j,i)
      b(j,i)=b(j,k)
      b(j,k)=b1
 275  continue
c re-order t (transformation matrix)
      do 280 j=1,nf
      p=t(j,i)
      t(j,i)=t(j,k)
      t(j,k)=p
 280  continue
 300  continue
9000  continue
      write(6,399) ier
 399  format(1x,'ier=',i5)
      vvv=100.*vvv*float(nf)/float(nf-1)
c write out diagnoistic quantity (vvv) which estimates the effectiveness
c of the rotation (rule of thumb: good for gt 60, poor for lt 40). note:
c this index ranges from zero to 100
       write(6,66) vvv
       write(6,*) 'vvv=',vvv
       write(6,*) 'nf= ',nf
  66  format(1x,'rotation effectiveness=',f9.2)
      return
      end
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
      PARAMETER (NMAX=1000)
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
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c  arange rotated eval,evec and coef in decreasing order
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine order(m,n,mod,reval,revec,rcoef)
      dimension reval(mod),revec(m,mod),rcoef(mod,n)
      do 20 i=1,mod-1
      do 20 j=i+1,mod
      if(reval(i).lt.reval(j)) then
      xx=reval(i)
      reval(i)=reval(j)
      reval(j)=xx
      do 30 k=1,m
         xx=revec(k,i)
         revec(k,i)=revec(k,j)
         revec(k,j)=xx
30    continue
      do 40 k=1,n
         xx=rcoef(i,k)
         rcoef(i,k)=rcoef(j,k)
         rcoef(j,k)=xx            
40    continue
      endif
20    continue
      return
      end

