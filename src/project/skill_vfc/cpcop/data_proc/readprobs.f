      DIMENSION P(36,19)
      OPEN(10,file='tconsolidatedASCII')
      OPEN(21,file='tcons.prob_below.gr',
     1access='direct',recl=36*19*4)
      OPEN(22,file='tcons.prob_norm.gr',
     1access='direct',recl=36*19*4)
      OPEN(23,file='tcons.prob_above.gr',
     1access='direct',recl=36*19*4)
      rmissing=-.999
      iw=0
      DO 150 IY=1982,2007
      JMAX=12
      IF(IY .eq. 2007) JMAX=9
      DO 150 JM=1,JMAX
      iw=iw+1
      DO 150 jz=1,3  !for below,normal,above
      READ(10,91) JYR,JMN,JCAT
 91   FORMAT(50X,3I5)
      DO 100 JX=1,36
      READ(10,92)(P(JX,JY),JY=1,19)
 92   FORMAT(19F6.3)
  100 CONTINUE
      do ii=1,36
      do jj=1,19
        p(ii,jj)=100*p(ii,jj)
        if(P(ii,jj).lt.0.01) p(ii,jj)=-999.0
      enddo
      enddo
C         WRITE YOUR ARRAY HERE SO GRADS CAN READ IT
      
      if(jz.eq.1) write(21,rec=iw) P
      if(jz.eq.2) write(22,rec=iw) P
      if(jz.eq.3) write(23,rec=iw) P

      print 93, iY,jyr,jm,jmn,jz,jcat,p(24,14)
  93  FORMAT(' test print ',6I5,F10.3)
  150 CONTINUE
      PRINT 151
151    FORMAT('program complete')
      STOP
      END
