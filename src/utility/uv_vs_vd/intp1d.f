      SUBROUTINE INTP1D(A,IMX,IMY,XA,YA,B,JMX,JMY,XB,YB,SPVAL,NSPV,
     $  idx,idy)
C
C---- This is one dimensional intepolation program
C     do x-direction intepolation for each J first, then do y-direction
c     intepolation for each new J 
C     idx=1 intepolate,   idx=0 no intepolation 1st dimension
C     idy=1 intepolate,   idy=0 no intepolation 2nd dimension
c
      PARAMETER(MAX=721,MAXP=362*181)                 
      DIMENSION DXP(MAX),DYP(MAX),DXM(MAX),DYM(MAX),   
     1          IPTR(MAX),JPTR(MAX),WGT(2),WK(361,181)       
      DIMENSION A(IMX,*),B(JMX,*),XA(*),YA(*),XB(*),YB(*)           
C
      CALL SETINT(XA,IMX,XB,JMX,IPTR,DXP,DXM,IERR)                   
      CALL SETINT(YA,IMY,YB,JMY,JPTR,DYP,DYM,JERR)                    

C
      DO 4 J=1,JMY
      DO 4 I=1,JMX
        B(I,J)=0.0
  4   CONTINUE
      do 5 j=1,imy
      do 5 i=1,jmx
        wk(i,j)=0.0
 5    continue
C
      IF (NSPV.NE.0) THEN
      DO 6 J = 1,JMY                                         
      DO 6 I = 1,JMX                                          
  6   B(I,J) = SPVAL                                           
      do 7 j=1,imy
      do 7 i=1,jmx
       wk(i,j)=spval
  7   continue
      ENDIF
c
      if (idx.eq.0) then
        do 11 j=1,imy
        do 11 i=1,jmx
          wk(i,j)=a(i,j)
  11    continue
      endif
C                                         
      if (idx.eq.1) then
      DO 20 J = 1,IMY                    
        DO 10 I = 1,JMX                    
          IM = IPTR(I)                    
          IF (IM.LT.0) GOTO 10           
          IP = IM + 1                 
          WGT(1)=1.0                                                  
          WGT(2)=1.0                                                 
          IF(A(IP,J).EQ.SPVAL)  WGT(1)=0.0  
          IF(A(IM,J).EQ.SPVAL)  WGT(2)=0.0
          D1 = DXM(I)*WGT(1)                                
          D2 = DXP(I)*WGT(2)                               
          DD=D1+D2
          IF (DD.EQ.0.0) GOTO 10                              
          WK(I,J) = (D2*A(IM,J)+D1*A(IP,J))/DD 
 10     CONTINUE
 20   CONTINUE
       endif
c
      if (idy.eq.0) then
        do 21 j=1,jmy
        do 21 i=1,jmx
          b(i,j)=wk(i,j)
  21    continue
      endif
C                                         
      if (idy.eq.1) then
      DO 40 I = 1,JMX                
        DO 30 J = 1,JMY
          JM = JPTR(J)
          IF (JM.LT.0) GOTO 30     
          JP = JM + 1             
          WGT(1)=1.0                                                  
          WGT(2)=1.0                                                 
          IF(WK(I,JP).EQ.SPVAL)  WGT(1)=0.0  
          IF(WK(I,JM).EQ.SPVAL)  WGT(2)=0.0              
          D1 = DYM(J)*WGT(1)                                
          D2 = DYP(J)*WGT(2)                               
          DD = D1 + D2 
          IF (DD.EQ.0.0) GOTO 30                              
          B(I,J) = (D2*WK(I,JM)+D1*WK(I,JP))/DD 
   30   CONTINUE                                                       
   40 CONTINUE                                                      
      endif
      RETURN                                                       
      END                                                         
C
      SUBROUTINE SETINT(X,M,Y,N,IPTR,DP,DM,IERR)
      DIMENSION X(*),Y(*),IPTR(*),DP(*),DM(*)
      IERR = 0
      chk=x(m)-x(1)
      if(chk.lt.0.0) goto 50
      DO 10 J = 1,N
        YL = Y(J)
        IF (YL.LT.X(1)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 10
        ELSEIF (YL.GT.X(M)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 10
        ENDIF
        DO 20 I = 1,M-1
          IF (YL.GT.X(I+1)) GOTO 20
          DM(J) = YL-X(I)
          DP(J) = X(I+1)-YL
          IPTR(J) = I
          GOTO 10
  20    CONTINUE
  10    CONTINUE
      return
c
  50  continue
      DO 30 J = 1,N
        YL = Y(J)
        IF (YL.GT.X(1)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 30
        ELSEIF (YL.LT.X(M)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 30
        ENDIF
        DO 40 I = 1,M-1
          IF (YL.LT.X(I+1)) GOTO 40
          DM(J) = YL-X(I)
          DP(J) = X(I+1)-YL
          IPTR(J) = I
          GOTO 30
  40    CONTINUE
  30  CONTINUE
      RETURN
      END
