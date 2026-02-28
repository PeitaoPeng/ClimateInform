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
C     IF (M-N) 50,50,40
      LMN=M-N
      IF (LMN.lt.0) go to 50
      IF (LMN.eq.0) go to 50
      IF (LMN.gt.0) go to 40
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
      parameter(eps=0.00001, delta=0.00001, norm=0)
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
C     IF (M-N) 50,50,40                                                 
      LMN=M-N
      IF (LMN.lt.0) go to 50                                                 
      IF (LMN.eq.0) go to 50                                                 
      IF (LMN.gt.0) go to 40                                                 
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
C     IF (ID) 20,10,10                                                  
      IF (ID.lt.0) go to 20                                                 
      IF (ID.eq.0) go to 10                                                 
      IF (ID.gt.0) go to 10                                                 
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
c     IF (M-N) 30,30,40                                                 
      LMN=M-N
      IF (LMN.lt.0) go to 30                                                 
      IF (LMN.eq.0) go to 30                                                 
      IF (LMN.gt.0) go to 40                                                 
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
 107      R(I,J)=R(I,J)+A(K,I)*A(K,J)/float(M)                                   
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
c     do 24 i=1,50
      do 24 i=1,50
        sm=0.
        do 15 ip=1,n-1
          do 14 iq=ip+1,n
            sm=sm+abs(a(ip,iq))
14        continue
15      continue
        if(sm.eq.0.)return
c       if(sm.lt.1.0E-22) return
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
c     write(6,*) 'sm=',sm
24    continue
c     pause 'too many iterations in jacobi'
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

c
c
************************************************************************
c     **
**
c     **  subroutines related to eigrv
**
c     **
**
c     **  please do not change items below
**
c     **
**
c
************************************************************************
c
C   IMSL ROUTINE NAME   - EHOBKS
C
C-----------------------------------------------------------------------
C
C   COMPUTER            - ELXSI/SINGLE
C
C   LATEST REVISION     - JUNE 1, 1982
C
C   PURPOSE             - NUCLEUS CALLED ONLY BY IMSL ROUTINE EIGRS
C
C   PRECISION/HARDWARE  - SINGLE AND DOUBLE/H32
C                       - SINGLE/H36,H48,H60
C
C   REQD. IMSL ROUTINES - NONE REQUIRED
C
C   NOTATION            - INFORMATION ON SPECIAL NOTATION AND
C                           CONVENTIONS IS AVAILABLE IN THE MANUAL
C                           INTRODUCTION OR THROUGH IMSL ROUTINE UHELP
C
C   COPYRIGHT           - 1982 BY IMSL, INC. ALL RIGHTS RESERVED.
C
C   WARRANTY            - IMSL WARRANTS ONLY THAT IMSL TESTING HAS BEEN
C                           APPLIED TO THIS CODE. NO OTHER WARRANTY,
C                           EXPRESSED OR IMPLIED, IS APPLICABLE.
C
C-----------------------------------------------------------------------
C
      SUBROUTINE EHOBKS (A,N,M1,M2,Z,IZ)
C
      DIMENSION          A(1),Z(IZ,1)
C                                  FIRST EXECUTABLE STATEMENT
      IF (N .EQ. 1) GO TO 30
      DO 25 I=2,N
         L = I-1
         IA = (I*L)/2
         H = A(IA+I)
         IF (H.EQ.0.) GO TO 25
C                                  DERIVES EIGENVECTORS M1 TO M2 OF
C                                  THE ORIGINAL MATRIX FROM EIGENVECTORS
C                                  M1 TO M2 OF THE SYMMETRIC
C                                  TRIDIAGONAL MATRIX
         DO 20 J = M1,M2
            S = 0.0
            DO 10 K = 1,L
               S = S+A(IA+K)*Z(K,J)
   10       CONTINUE
            S = S/H
            DO 15 K=1,L
               Z(K,J) = Z(K,J)-S*A(IA+K)
   15       CONTINUE
   20    CONTINUE
   25 CONTINUE
   30 RETURN
      END
C   IMSL ROUTINE NAME   - EHOUSS
C
C-----------------------------------------------------------------------
C
C   COMPUTER            - ELXSI/SINGLE
C
C   LATEST REVISION     - NOVEMBER 1, 1984
C
C   PURPOSE             - NUCLEUS CALLED ONLY BY IMSL ROUTINE EIGRS
C
C   PRECISION/HARDWARE  - SINGLE AND DOUBLE/H32
C                       - SINGLE/H36,H48,H60
C
C   REQD. IMSL ROUTINES - NONE REQUIRED
C
C   NOTATION            - INFORMATION ON SPECIAL NOTATION AND
C                           CONVENTIONS IS AVAILABLE IN THE MANUAL
C                           INTRODUCTION OR THROUGH IMSL ROUTINE UHELP
C
C   COPYRIGHT           - 1982 BY IMSL, INC. ALL RIGHTS RESERVED.
C
C   WARRANTY            - IMSL WARRANTS ONLY THAT IMSL TESTING HAS BEEN
C                           APPLIED TO THIS CODE. NO OTHER WARRANTY,
C                           EXPRESSED OR IMPLIED, IS APPLICABLE.
C
C-----------------------------------------------------------------------
C
      SUBROUTINE EHOUSS (A,N,D,E,E2)
C
      DIMENSION          A(1),D(N),E(N),E2(N)
      REAL               A,D,E,E2,ZERO,H,SCALE,F,G,HH
      DATA               ZERO/0.0/
C                                  FIRST EXECUTABLE STATEMENT
      NP1 = N+1
      NN = (N*NP1)/2-1
      NBEG = NN+1-N
      DO 70 II = 1,N
         I = NP1-II
         L = I-1
         H = ZERO
         SCALE = ZERO
         IF (L .LT. 1) GO TO 10
C                                  SCALE ROW (ALGOL TOL THEN NOT NEEDED)
         NK = NN
         DO 5 K = 1,L
            SCALE = SCALE+ABS(A(NK))
            NK = NK-1
    5    CONTINUE
         IF (SCALE .NE. ZERO) GO TO 15
   10    E(I) = ZERO
         E2(I) = ZERO
         GO TO 65
   15    NK = NN
         DO 20 K = 1,L
            A(NK) = A(NK)/SCALE
            H = H+A(NK)*A(NK)
            NK = NK-1
   20    CONTINUE
         E2(I) = SCALE*SCALE*H
         F = A(NN)
         G = -SIGN(SQRT(H),F)
         E(I) = SCALE*G
         H = H-F*G
         A(NN) = F-G
         IF (L .EQ. 1) GO TO 55
         F = ZERO
         JK1 = 1
         DO 40 J = 1,L
            G = ZERO
            IK = NBEG+1
            JK = JK1
C                                  FORM ELEMENT OF A*U
            DO 25 K = 1,J
               G = G+A(JK)*A(IK)
               JK = JK+1
               IK = IK+1
   25       CONTINUE
            JP1 = J+1
            IF (L .LT. JP1) GO TO 35
            JK = JK+J-1
            DO 30 K = JP1,L
               G = G+A(JK)*A(IK)
               JK = JK+K
               IK = IK+1
   30       CONTINUE
C                                  FORM ELEMENT OF P
   35       E(J) = G/H
            F = F+E(J)*A(NBEG+J)
            JK1 = JK1+J
   40    CONTINUE
         HH = F/(H+H)
C                                  FORM REDUCED A
         JK = 1
         DO 50 J = 1,L
            F = A(NBEG+J)
            G = E(J)-HH*F
            E(J) = G
            DO 45 K = 1,J
               A(JK) = A(JK)-F*E(K)-G*A(NBEG+K)
               JK = JK+1
   45       CONTINUE
   50    CONTINUE
   55    DO 60 K = 1,L
            A(NBEG+K) = SCALE*A(NBEG+K)
   60    CONTINUE
   65    D(I) = A(NBEG+I)
         A(NBEG+I) = H*SCALE*SCALE
         NBEG = NBEG-I+1
         NN = NN-I
   70 CONTINUE
      RETURN
      END
C   IMSL ROUTINE NAME   - EIGRS
C
C-----------------------------------------------------------------------
C
C   COMPUTER            - ELXSI/SINGLE
C
C   LATEST REVISION     - JUNE 1, 1980
C
C   PURPOSE             - EIGENVALUES AND (OPTIONALLY) EIGENVECTORS OF
C                           A REAL SYMMETRIC MATRIX
C
C   USAGE               - CALL EIGRS (A,N,JOBN,D,Z,IZ,WK,IER)
C
C   ARGUMENTS    A      - INPUT REAL SYMMETRIC MATRIX OF ORDER N,
C                           WHOSE EIGENVALUES AND EIGENVECTORS
C                           ARE TO BE COMPUTED. INPUT A IS
C                           DESTROYED IF IJOB IS EQUAL TO 0 OR 1.
C                N      - INPUT ORDER OF THE MATRIX A.
C                JOBN   - INPUT OPTION PARAMETER.  IF JOBN.GE.10
C                         A IS ASSUMED TO BE IN FULL STORAGE MODE
C                         (IN THIS CASE, A MUST BE DIMENSIONED EXACTLY
C                         N BY N IN THE CALLING PROGRAM).
C                         IF JOBN.LT.10 THEN A IS ASSUMED TO BE IN
C                         SYMMETRIC STORAGE MODE.  DEFINE
C                         IJOB=MOD(JOBN,10).  THEN WHEN
C                           IJOB = 0, COMPUTE EIGENVALUES ONLY
C                           IJOB = 1, COMPUTE EIGENVALUES AND EIGEN-
C                             VECTORS.
C                           IJOB = 2, COMPUTE EIGENVALUES, EIGENVECTORS
C                             AND PERFORMANCE INDEX.
C                           IJOB = 3, COMPUTE PERFORMANCE INDEX ONLY.
C                           IF THE PERFORMANCE INDEX IS COMPUTED, IT IS
C                           RETURNED IN WK(1). THE ROUTINES HAVE
C                           PERFORMED (WELL, SATISFACTORILY, POORLY) IF
C                           WK(1) IS (LESS THAN 1, BETWEEN 1 AND 100,
C                           GREATER THAN 100).
C                D      - OUTPUT VECTOR OF LENGTH N,
C                           CONTAINING THE EIGENVALUES OF A.
C                Z      - OUTPUT N BY N MATRIX CONTAINING
C                           THE EIGENVECTORS OF A.
C                           THE EIGENVECTOR IN COLUMN J OF Z CORRES-
C                           PONDS TO THE EIGENVALUE D(J).
C                           IF IJOB = 0, Z IS NOT USED.
C                IZ     - INPUT ROW DIMENSION OF MATRIX Z EXACTLY AS
C                           SPECIFIED IN THE DIMENSION STATEMENT IN THE
C                           CALLING PROGRAM.
C                WK     - WORK AREA, THE LENGTH OF WK DEPENDS
C                           ON THE VALUE OF IJOB, WHEN
C                           IJOB = 0, THE LENGTH OF WK IS AT LEAST N.
C                           IJOB = 1, THE LENGTH OF WK IS AT LEAST N.
C                           IJOB = 2, THE LENGTH OF WK IS AT LEAST
C                             N(N+1)/2+N.
C                           IJOB = 3, THE LENGTH OF WK IS AT LEAST 1.
C                IER    - ERROR PARAMETER (OUTPUT)
C                         TERMINAL ERROR
C                           IER = 128+J, INDICATES THAT EQRT2S FAILED
C                             TO CONVERGE ON EIGENVALUE J. EIGENVALUES
C                             AND EIGENVECTORS 1,...,J-1 HAVE BEEN
C                             COMPUTED CORRECTLY, BUT THE EIGENVALUES
C                             ARE UNORDERED. THE PERFORMANCE INDEX
C                             IS SET TO 1000.0
C                         WARNING ERROR (WITH FIX)
C                           IN THE FOLLOWING, IJOB = MOD(JOBN,10).
C                           IER = 66, INDICATES IJOB IS LESS THAN 0 OR
C                             IJOB IS GREATER THAN 3. IJOB SET TO 1.
C                           IER = 67, INDICATES IJOB IS NOT EQUAL TO
C                             ZERO, AND IZ IS LESS THAN THE ORDER OF
C                             MATRIX A. IJOB IS SET TO ZERO.
C
C   PRECISION/HARDWARE  - SINGLE AND DOUBLE/H32
C                       - SINGLE/H36,H48,H60
C
C   REQD. IMSL ROUTINES - EHOBKS,EHOUSS,EQRT2S,UERTST,UGETIO
C
C   NOTATION            - INFORMATION ON SPECIAL NOTATION AND
C                           CONVENTIONS IS AVAILABLE IN THE MANUAL
C                           INTRODUCTION OR THROUGH IMSL ROUTINE UHELP
C
C   COPYRIGHT           - 1980 BY IMSL, INC. ALL RIGHTS RESERVED.
C
C   WARRANTY            - IMSL WARRANTS ONLY THAT IMSL TESTING HAS BEEN
C                           APPLIED TO THIS CODE. NO OTHER WARRANTY,
C                           EXPRESSED OR IMPLIED, IS APPLICABLE.
C
C-----------------------------------------------------------------------
C
      SUBROUTINE EIGRS  (A,N,JOBN,D,Z,IZ,WK,IER)
C                                  SPECIFICATIONS FOR ARGUMENTS
      INTEGER            N,JOBN,IZ,IER
      REAL               A(1),D(1),WK(1),Z(IZ,1)
C                                  SPECIFICATIONS FOR LOCAL VARIABLES
      INTEGER            IJOB,IR,JR,IJ,JI,NP1
      INTEGER            JER,NA,ND,IIZ,IBEG,IL,KK,LK,I,J,K,L
      REAL               ANORM,ASUM,PI,SUMZ,SUMR,AN,S,TEN,RDELP,ZERO,
     1                   ONE,THOUS
      DATA               RDELP/1.192093E-07/
      DATA               ZERO,ONE/0.0,1.0/,TEN/10.0/,THOUS/1000.0/
C                                  INITIALIZE ERROR PARAMETERS
C                                  FIRST EXECUTABLE STATEMENT
      IER = 0
      JER = 0
      IF (JOBN.LT.10) GO TO 15
C                                  CONVERT TO SYMMETRIC STORAGE MODE
      K = 1
      JI = N-1
      IJ = 1
      DO 10 J=1,N
         DO 5 I=1,J
            A(K) = A(IJ)
            IJ = IJ+1
            K = K+1
    5    CONTINUE
         IJ = IJ + JI
         JI = JI - 1
   10 CONTINUE
   15 IJOB = MOD(JOBN,10)
      IF (IJOB.GE.0.AND.IJOB.LE.3) GO TO 20
C                                  WARNING ERROR - IJOB IS NOT IN THE
C                                    RANGE
      IER = 66
      IJOB = 1
      GO TO 25
   20 IF (IJOB.EQ.0) GO TO 35
   25 IF (IZ.GE.N) GO TO 30
C                                  WARNING ERROR - IZ IS LESS THAN N
C                                    EIGENVECTORS CAN NOT BE COMPUTED,
C                                    IJOB SET TO ZERO
      IER = 67
      IJOB = 0
   30 IF (IJOB.EQ.3) GO TO 75
   35 NA = (N*(N+1))/2
      IF (IJOB.NE.2) GO TO 45
      DO 40 I=1,NA
         WK(I) = A(I)
   40 CONTINUE
C                                  SAVE INPUT A IF IJOB = 2
   45 ND = 1
      IF (IJOB.EQ.2) ND = NA+1
C                                  REDUCE A TO SYMMETRIC TRIDIAGONAL
C                                    FORM
      CALL EHOUSS (A,N,D,WK(ND),WK(ND))
      IIZ = 1
      IF (IJOB.EQ.0) GO TO 60
      IIZ = IZ
C                                  SET Z TO THE IDENTITY MATRIX
      DO 55 I=1,N
         DO 50 J=1,N
            Z(I,J) = ZERO
   50    CONTINUE
         Z(I,I) = ONE
   55 CONTINUE
C                                  COMPUTE EIGENVALUES AND EIGENVECTORS
   60 CALL EQRT2S (D,WK(ND),N,Z,IIZ,JER)
      IF (IJOB.EQ.0) GO TO 9000
      IF (JER.GT.128) GO TO 65
C                                  BACK TRANSFORM EIGENVECTORS
      CALL EHOBKS (A,N,1,N,Z,IZ)
   65 IF (IJOB.LE.1) GO TO 9000
C                                  MOVE INPUT MATRIX BACK TO A
      DO 70 I=1,NA
         A(I) = WK(I)
   70 CONTINUE
      WK(1) = THOUS
      IF (JER.NE.0) GO TO 9000
C                                  COMPUTE 1 - NORM OF A
   75 ANORM = ZERO
      IBEG = 1
      DO 85 I=1,N
         ASUM = ZERO
         IL = IBEG
         KK = 1
         DO 80 L=1,N
            ASUM = ASUM+ABS(A(IL))
            IF (L.GE.I) KK = L
            IL = IL+KK
   80    CONTINUE
         ANORM = AMAX1(ANORM,ASUM)
         IBEG = IBEG+I
   85 CONTINUE
      IF (ANORM.EQ.ZERO) ANORM = ONE
C                                  COMPUTE PERFORMANCE INDEX
      PI = ZERO
      DO 100 I=1,N
         IBEG = 1
         S = ZERO
         SUMZ = ZERO
         DO 95 L=1,N
            LK = IBEG
            KK = 1
            SUMZ = SUMZ+ABS(Z(L,I))
            SUMR = -D(I)*Z(L,I)
            DO 90 K=1,N
               SUMR = SUMR+A(LK)*Z(K,I)
               IF (K.GE.L) KK = K
               LK = LK+KK
   90       CONTINUE
            S = S+ABS(SUMR)
            IBEG = IBEG+L
   95    CONTINUE
         IF (SUMZ.EQ.ZERO) GO TO 100
         PI = AMAX1(PI,S/SUMZ)
  100 CONTINUE
      AN = N
      PI = PI/(ANORM*TEN*AN*RDELP)
      WK(1) = PI
      IF (JOBN.LT.10) GO TO 9000
C                                  CONVERT BACK TO FULL STORAGE MODE
      NP1 = N+1
      IJ = (N-1)*NP1 + 2
      K = (N*(NP1))/2
      DO 110 JR=1,N
         J = NP1-JR
         DO 105 IR=1,J
            IJ = IJ-1
            A(IJ) = A(K)
            K = K-1
  105    CONTINUE
         IJ = IJ-JR
  110 CONTINUE
      JI = 0
      K = N-1
      DO 120 I=1,N
         IJ = I-N
         DO 115 J=1,I
            IJ = IJ+N
            JI = JI+1
            A(IJ) = A(JI)
  115    CONTINUE
         JI = JI + K
         K = K-1
  120 CONTINUE
 9000 CONTINUE
      IF (IER.NE.0) CALL UERTST (IER,'EIGRS ')
      IF (JER.EQ.0) GO TO 9005
      IER = JER
      CALL UERTST (IER,'EIGRS ')
 9005 RETURN
      END
C   IMSL ROUTINE NAME   - EQRT2S
C
C-----------------------------------------------------------------------
C
C   COMPUTER            - ELXSI/SINGLE
C
C   LATEST REVISION     - NOVEMBER 1, 1984
C
C   PURPOSE             - EIGENVALUES AND (OPTIONALLY) EIGENVECTORS OF
C                           A SYMMETRIC TRIDIAGONAL MATRIX USING THE
C                           QL METHOD.
C
C   USAGE               - CALL EQRT2S (D,E,N,Z,IZ,IER)
C
C   ARGUMENTS    D      - ON INPUT, THE VECTOR D OF LENGTH N CONTAINS
C                           THE DIAGONAL ELEMENTS OF THE SYMMETRIC
C                           TRIDIAGONAL MATRIX T.
C                           ON OUTPUT, D CONTAINS THE EIGENVALUES OF
C                           T IN ASCENDING ORDER.
C                E      - ON INPUT, THE VECTOR E OF LENGTH N CONTAINS
C                           THE SUB-DIAGONAL ELEMENTS OF T IN POSITION
C                           2,...,N. ON OUTPUT, E IS DESTROYED.
C                N      - ORDER OF TRIDIAGONAL MATRIX T.(INPUT)
C                Z      - ON INPUT, Z CONTAINS THE IDENTITY MATRIX OF
C                           ORDER N.
C                           ON OUTPUT, Z CONTAINS THE EIGENVECTORS
C                           OF T. THE EIGENVECTOR IN COLUMN J OF Z
C                           CORRESPONDS TO THE EIGENVALUE D(J).
C                IZ     - INPUT ROW DIMENSION OF MATRIX Z EXACTLY AS
C                           SPECIFIED IN THE DIMENSION STATEMENT IN THE
C                           CALLING PROGRAM. IF IZ IS LESS THAN N, THE
C                           EIGENVECTORS ARE NOT COMPUTED. IN THIS CASE
C                           Z IS NOT USED.
C                IER    - ERROR PARAMETER
C                         TERMINAL ERROR
C                           IER = 128+J, INDICATES THAT EQRT2S FAILED
C                             TO CONVERGE ON EIGENVALUE J. EIGENVALUES
C                             AND EIGENVECTORS 1,...,J-1 HAVE BEEN
C                             COMPUTED CORRECTLY, BUT THE EIGENVALUES
C                             ARE UNORDERED.
C
C   PRECISION/HARDWARE  - SINGLE AND DOUBLE/H32
C                       - SINGLE/H36,H48,H60
C
C   REQD. IMSL ROUTINES - UERTST,UGETIO
C
C   NOTATION            - INFORMATION ON SPECIAL NOTATION AND
C                           CONVENTIONS IS AVAILABLE IN THE MANUAL
C                           INTRODUCTION OR THROUGH IMSL ROUTINE UHELP
C
C   COPYRIGHT           - 1978 BY IMSL, INC. ALL RIGHTS RESERVED.
C
C   WARRANTY            - IMSL WARRANTS ONLY THAT IMSL TESTING HAS BEEN
C                           APPLIED TO THIS CODE. NO OTHER WARRANTY,
C                           EXPRESSED OR IMPLIED, IS APPLICABLE.
C
C-----------------------------------------------------------------------
C
      SUBROUTINE EQRT2S (D,E,N,Z,IZ,IER)
C
      DIMENSION          D(1),E(1),Z(IZ,1)
      DATA               RDELP/1.192093E-07/
      DATA               ZERO,ONE/0.0,1.0/
C                                  MOVE THE LAST N-1 ELEMENTS
C                                  OF E INTO THE FIRST N-1 LOCATIONS
C                                  FIRST EXECUTABLE STATEMENT
      IER  = 0
      IF (N .EQ. 1) GO TO 9005
      DO 5  I=2,N
         E(I-1) = E(I)
    5 CONTINUE
      E(N) = ZERO
      B = ZERO
      F = ZERO
      DO  60  L=1,N
         J = 0
         H = RDELP*(ABS(D(L))+ABS(E(L)))
         IF (B.LT.H) B = H
C                                  LOOK FOR SMALL SUB-DIAGONAL ELEMENT
         DO 10  M=L,N
            K=M
            IF (ABS(E(K)) .LE. B) GO TO 15
   10    CONTINUE
   15    M = K
         IF (M.EQ.L) GO TO 55
   20    IF (J .EQ. 30) GO TO 85
         J = J+1
         L1 = L+1
         G = D(L)
         P = (D(L1)-G)/(E(L)+E(L))
         R = ABS(P)
         IF (RDELP*ABS(P) .LT. 1.0) R = SQRT(P*P+ONE)
         D(L) = E(L)/(P+SIGN(R,P))
         H = G-D(L)
         DO 25 I = L1,N
            D(I) = D(I)-H
   25    CONTINUE
         F = F+H
C                                  QL TRANSFORMATION
         P = D(M)
         C = ONE
         S = ZERO
         MM1 = M-1
         MM1PL = MM1+L
         IF (L.GT.MM1) GO TO 50
         DO 45 II=L,MM1
            I = MM1PL-II
            G = C*E(I)
            H = C*P
            IF (ABS(P).LT.ABS(E(I))) GO TO 30
            C = E(I)/P
            R = SQRT(C*C+ONE)
            E(I+1) = S*P*R
            S = C/R
            C = ONE/R
            GO TO 35
   30       C = P/E(I)
            R = SQRT(C*C+ONE)
            E(I+1) = S*E(I)*R
            S = ONE/R
            C = C*S
   35       P = C*D(I)-S*G
            D(I+1) = H+S*(C*G+S*D(I))
            IF (IZ .LT. N) GO TO 45
C                                  FORM VECTOR
            DO 40 K=1,N
               H = Z(K,I+1)
               Z(K,I+1) = S*Z(K,I)+C*H
               Z(K,I) = C*Z(K,I)-S*H
   40       CONTINUE
   45    CONTINUE
   50    E(L) = S*P
         D(L) = C*P
         IF ( ABS(E(L)) .GT.B) GO TO 20
   55    D(L) = D(L) + F
   60 CONTINUE
C                                  ORDER EIGENVALUES AND EIGENVECTORS
      DO  80  I=1,N
         K = I
         P = D(I)
         IP1 = I+1
         IF (IP1.GT.N) GO TO 70
         DO 65  J=IP1,N
            IF (D(J) .GE. P) GO TO 65
            K = J
            P = D(J)
   65    CONTINUE
   70    IF (K.EQ.I) GO TO 80
         D(K) = D(I)
         D(I) = P
         IF (IZ .LT. N) GO TO 80
         DO 75 J = 1,N
            P = Z(J,I)
            Z(J,I) = Z(J,K)
            Z(J,K) = P
   75    CONTINUE
   80 CONTINUE
      GO TO 9005
   85 IER = 128+L
 9000 CONTINUE
      CALL UERTST(IER,'EQRT2S')
 9005 RETURN
      END
C   IMSL ROUTINE NAME   - UERTST

C-----------------------------------------------------------------------
C
C   COMPUTER            - ELXSI/SINGLE
C
C   LATEST REVISION     - JUNE 1, 1982
C
C   PURPOSE             - PRINT A MESSAGE REFLECTING AN ERROR CONDITION
C
C   USAGE               - CALL UERTST (IER,NAME)
C
C   ARGUMENTS    IER    - ERROR PARAMETER. (INPUT)
C                           IER = I+J WHERE
C                             I = 128 IMPLIES TERMINAL ERROR MESSAGE,
C                             I =  64 IMPLIES WARNING WITH FIX MESSAGE,
C                             I =  32 IMPLIES WARNING MESSAGE.
C                             J = ERROR CODE RELEVANT TO CALLING
C                                 ROUTINE.
C                NAME   - A CHARACTER STRING OF LENGTH SIX PROVIDING
C                           THE NAME OF THE CALLING ROUTINE. (INPUT)
C
C   PRECISION/HARDWARE  - SINGLE/ALL
C
C   REQD. IMSL ROUTINES - UGETIO,USPKD
C
C   NOTATION            - INFORMATION ON SPECIAL NOTATION AND
C                           CONVENTIONS IS AVAILABLE IN THE MANUAL
C                           INTRODUCTION OR THROUGH IMSL ROUTINE UHELP
C
C   REMARKS      THE ERROR MESSAGE PRODUCED BY UERTST IS WRITTEN
C                TO THE STANDARD OUTPUT UNIT. THE OUTPUT UNIT
C                NUMBER CAN BE DETERMINED BY CALLING UGETIO AS
C                FOLLOWS..   CALL UGETIO(1,NIN,NOUT).
C                THE OUTPUT UNIT NUMBER CAN BE CHANGED BY CALLING
C                UGETIO AS FOLLOWS..
C                                NIN = 0
C                                NOUT = NEW OUTPUT UNIT NUMBER
C                                CALL UGETIO(3,NIN,NOUT)
C                SEE THE UGETIO DOCUMENT FOR MORE DETAILS.
C
C   COPYRIGHT           - 1982 BY IMSL, INC. ALL RIGHTS RESERVED.
C
C   WARRANTY            - IMSL WARRANTS ONLY THAT IMSL TESTING HAS BEEN
C                           APPLIED TO THIS CODE. NO OTHER WARRANTY,
C                           EXPRESSED OR IMPLIED, IS APPLICABLE.
C
C-----------------------------------------------------------------------
C
      SUBROUTINE UERTST (IER,NAME)
C                                  SPECIFICATIONS FOR ARGUMENTS
      INTEGER            IER
      CHARACTER          NAME*(*)
C                                  SPECIFICATIONS FOR LOCAL VARIABLES
      INTEGER            I,IEQDF,IOUNIT,LEVEL,LEVOLD,NIN,NMTB
      CHARACTER          IEQ,NAMEQ(6),NAMSET(6),NAMUPK(6)
      DATA               NAMSET/'U','E','R','S','E','T'/
      DATA               NAMEQ/6*' '/
      DATA               LEVEL/4/,IEQDF/0/,IEQ/'='/
C                                  UNPACK NAME INTO NAMUPK
C                                  FIRST EXECUTABLE STATEMENT
      CALL USPKD (NAME,6,NAMUPK,NMTB)
C                                  GET OUTPUT UNIT NUMBER
      CALL UGETIO(1,NIN,IOUNIT)
C                                  CHECK IER
      IF (IER.GT.999) GO TO 25
      IF (IER.LT.-32) GO TO 55
      IF (IER.LE.128) GO TO 5
      IF (LEVEL.LT.1) GO TO 30
C                                  PRINT TERMINAL MESSAGE
      IF (IEQDF.EQ.1) WRITE(IOUNIT,35) IER,NAMEQ,IEQ,NAMUPK
      IF (IEQDF.EQ.0) WRITE(IOUNIT,35) IER,NAMUPK
      GO TO 30
    5 IF (IER.LE.64) GO TO 10
      IF (LEVEL.LT.2) GO TO 30
C                                  PRINT WARNING WITH FIX MESSAGE
      IF (IEQDF.EQ.1) WRITE(IOUNIT,40) IER,NAMEQ,IEQ,NAMUPK
      IF (IEQDF.EQ.0) WRITE(IOUNIT,40) IER,NAMUPK
      GO TO 30
   10 IF (IER.LE.32) GO TO 15
C                                  PRINT WARNING MESSAGE
      IF (LEVEL.LT.3) GO TO 30
      IF (IEQDF.EQ.1) WRITE(IOUNIT,45) IER,NAMEQ,IEQ,NAMUPK
      IF (IEQDF.EQ.0) WRITE(IOUNIT,45) IER,NAMUPK
      GO TO 30
   15 CONTINUE
C                                  CHECK FOR UERSET CALL
      DO 20 I=1,6
         IF (NAMUPK(I).NE.NAMSET(I)) GO TO 25
   20 CONTINUE
      LEVOLD = LEVEL
      LEVEL = IER
      IER = LEVOLD
      IF (LEVEL.LT.0) LEVEL = 4
      IF (LEVEL.GT.4) LEVEL = 4
      GO TO 30
   25 CONTINUE
      IF (LEVEL.LT.4) GO TO 30
C                                  PRINT NON-DEFINED MESSAGE
      IF (IEQDF.EQ.1) WRITE(IOUNIT,50) IER,NAMEQ,IEQ,NAMUPK
      IF (IEQDF.EQ.0) WRITE(IOUNIT,50) IER,NAMUPK
   30 IEQDF = 0
      RETURN
   35 FORMAT(19H *** TERMINAL ERROR,10X,7H(IER = ,I3,
     1       20H) FROM IMSL ROUTINE ,6A1,A1,6A1)
   40 FORMAT(27H *** WARNING WITH FIX ERROR,2X,7H(IER = ,I3,
     1       20H) FROM IMSL ROUTINE ,6A1,A1,6A1)
   45 FORMAT(18H *** WARNING ERROR,11X,7H(IER = ,I3,
     1       20H) FROM IMSL ROUTINE ,6A1,A1,6A1)
   50 FORMAT(20H *** UNDEFINED ERROR,9X,7H(IER = ,I5,
     1       20H) FROM IMSL ROUTINE ,6A1,A1,6A1)
C
C                                  SAVE P FOR P = R CASE
C                                    P IS THE PAGE NAMUPK
C                                    R IS THE ROUTINE NAMUPK
   55 IEQDF = 1
      DO 60 I=1,6
   60 NAMEQ(I) = NAMUPK(I)
   65 RETURN
      END
C   IMSL ROUTINE NAME   - UGETIO
C
C-----------------------------------------------------------------------
C
C   COMPUTER            - ELXSI/SINGLE
C
C   LATEST REVISION     - JUNE 1, 1981
C
C   PURPOSE             - TO RETRIEVE CURRENT VALUES AND TO SET NEW
C                           VALUES FOR INPUT AND OUTPUT UNIT
C                           IDENTIFIERS.
C
C   USAGE               - CALL UGETIO(IOPT,NIN,NOUT)
C
C   ARGUMENTS    IOPT   - OPTION PARAMETER. (INPUT)
C                           IF IOPT=1, THE CURRENT INPUT AND OUTPUT
C                           UNIT IDENTIFIER VALUES ARE RETURNED IN NIN
C                           AND NOUT, RESPECTIVELY.
C                           IF IOPT=2, THE INTERNAL VALUE OF NIN IS
C                           RESET FOR SUBSEQUENT USE.
C                           IF IOPT=3, THE INTERNAL VALUE OF NOUT IS
C                           RESET FOR SUBSEQUENT USE.
C                NIN    - INPUT UNIT IDENTIFIER.
C                           OUTPUT IF IOPT=1, INPUT IF IOPT=2.
C                NOUT   - OUTPUT UNIT IDENTIFIER.
C                           OUTPUT IF IOPT=1, INPUT IF IOPT=3.
C
C   PRECISION/HARDWARE  - SINGLE/ALL
C
C   REQD. IMSL ROUTINES - NONE REQUIRED
C
C   NOTATION            - INFORMATION ON SPECIAL NOTATION AND
C                           CONVENTIONS IS AVAILABLE IN THE MANUAL
C                           INTRODUCTION OR THROUGH IMSL ROUTINE UHELP
C
C   REMARKS      EACH IMSL ROUTINE THAT PERFORMS INPUT AND/OR OUTPUT
C                OPERATIONS CALLS UGETIO TO OBTAIN THE CURRENT UNIT
C                IDENTIFIER VALUES. IF UGETIO IS CALLED WITH IOPT=2 OR
C                IOPT=3, NEW UNIT IDENTIFIER VALUES ARE ESTABLISHED.
C                SUBSEQUENT INPUT/OUTPUT IS PERFORMED ON THE NEW UNITS.
C
C   COPYRIGHT           - 1978 BY IMSL, INC. ALL RIGHTS RESERVED.
C
C   WARRANTY            - IMSL WARRANTS ONLY THAT IMSL TESTING HAS BEEN
C                           APPLIED TO THIS CODE. NO OTHER WARRANTY,
C                           EXPRESSED OR IMPLIED, IS APPLICABLE.
C
C-----------------------------------------------------------------------
C
      SUBROUTINE UGETIO(IOPT,NIN,NOUT)
C                                  SPECIFICATIONS FOR ARGUMENTS
      INTEGER            IOPT,NIN,NOUT
C                                  SPECIFICATIONS FOR LOCAL VARIABLES
      INTEGER            NIND,NOUTD
      DATA               NIND/5/,NOUTD/6/
C                                  FIRST EXECUTABLE STATEMENT
      IF (IOPT.EQ.3) GO TO 10
      IF (IOPT.EQ.2) GO TO 5
      IF (IOPT.NE.1) GO TO 9005
      NIN = NIND
      NOUT = NOUTD
      GO TO 9005
    5 NIND = NIN
      GO TO 9005
   10 NOUTD = NOUT
 9005 RETURN
      END
C   IMSL ROUTINE NAME   - USPKD
C
C-----------------------------------------------------------------------
C
C   COMPUTER            - ELXSI/SINGLE
C
C   LATEST REVISION     - JUNE 1, 1982
C
C   PURPOSE             - NUCLEUS CALLED BY IMSL ROUTINES THAT HAVE
C                           CHARACTER STRING ARGUMENTS
C
C   USAGE               - CALL USPKD  (PACKED,NCHARS,UNPAKD,NCHMTB)
C
C   ARGUMENTS    PACKED - CHARACTER STRING TO BE UNPACKED.(INPUT)
C                NCHARS - LENGTH OF PACKED. (INPUT)  SEE REMARKS.
C                UNPAKD - CHARACTER ARRAY TO RECEIVE THE UNPACKED
C                         REPRESENTATION OF THE STRING. (OUTPUT)
C                NCHMTB - NCHARS MINUS TRAILING BLANKS. (OUTPUT)
C
C   PRECISION/HARDWARE  - SINGLE/ALL
C
C   REQD. IMSL ROUTINES - NONE
C
C   REMARKS  1.  USPKD UNPACKS A CHARACTER STRING INTO A CHARACTER ARRAY
C                IN (A1) FORMAT.
C            2.  UP TO 129 CHARACTERS MAY BE USED.  ANY IN EXCESS OF
C                THAT ARE IGNORED.
C
C   COPYRIGHT           - 1982 BY IMSL, INC. ALL RIGHTS RESERVED.
C
C   WARRANTY            - IMSL WARRANTS ONLY THAT IMSL TESTING HAS BEEN
C                           APPLIED TO THIS CODE. NO OTHER WARRANTY,
C                           EXPRESSED OR IMPLIED, IS APPLICABLE.
C
C-----------------------------------------------------------------------
      SUBROUTINE USPKD  (PACKED,NCHARS,UNPAKD,NCHMTB)
C                                  SPECIFICATIONS FOR ARGUMENTS
      INTEGER            NC,NCHARS,NCHMTB
C
      CHARACTER          UNPAKD(1),IBLANK
      CHARACTER*(1)      PACKED(1)
      DATA               IBLANK /' '/
C                                  INITIALIZE NCHMTB
      NCHMTB = 0
C                                  RETURN IF NCHARS IS LE ZERO
      IF(NCHARS.LE.0) RETURN
C                                  SET NC=NUMBER OF CHARS TO BE DECODED
      NC = MIN0 (129,NCHARS)
      DO 5 I=1,NC
         UNPAKD(I) = PACKED(I)
    5 CONTINUE
  150 FORMAT (129A1)
C                                  CHECK UNPAKD ARRAY AND SET NCHMTB
C                                  BASED ON TRAILING BLANKS FOUND
      DO 200 N = 1,NC
         NN = NC - N + 1
         IF(UNPAKD(NN) .NE. IBLANK) GO TO 210
  200 CONTINUE
  210 NCHMTB = NN
      RETURN
      END

