      subroutine hss_stat(hs1,hs2,hss1,hss2,nsp,
     &hsm1,hsm2,sdv1,sdv2,ct1,ct2)
CC============================================================
C calculate statistics of hss1&2
C hs1&2-> HSS of real data; hss1&2->HSS from MC;
C hsm1&2->mean MC HSS; sdv1&2->stdv of HSS1&2;
C ct1&2->percent of hss1&2 higher than hs1&2;
CC============================================================
      real hss1(nsp),hss2(nsp)
C
C randolmly re-order data
C
      hsm1=0.
      hsm2=0.
      sdv1=0.
      sdv2=0.

      DO is=1,nsp
      hsm1=hsm1+hss1(is)
      hsm2=hsm2+hss2(is)
      ENDDO
      hsm1=hsm1/float(nsp)
      hsm2=hsm2/float(nsp)

      DO is=1,nsp
      df1=hss1(is)-hsm1
      df2=hss2(is)-hsm2
      sdv1=sdv1+df1*df1
      sdv2=sdv2+df2*df2
      ENDDO
      sdv1=sqrt(sdv1/float(nsp))
      sdv2=sqrt(sdv2/float(nsp))
c
c     write(6,*) 'hms1=',hsm1,sdv1
c
c count how many MC HSS smaller than real HSS
      ct1=0.
      ct2=0.
      DO is=1,nsp

      if(hss1(is).lt.hs1) then
      ct1=ct1+1
      endif
      if(hss2(is).lt.hs2) then
      ct2=ct2+1
      endif

      ENDDO

      ct1=100*ct1/float(nsp)
      ct2=100*ct2/float(nsp)
c     write(6,*) 'count nmbh',ct1,ct2
      
      return
      end

