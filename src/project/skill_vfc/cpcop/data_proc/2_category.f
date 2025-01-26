      parameter(ltime=150,imx=36,jmx=19)
      DIMENSION mask(imx,jmx),wk(imx,jmx)
      OPEN(10,file='cca_sfcT.95-07.gr',
     1access='direct',recl=36*19*4)
      OPEN(11,file='mask_2x2.data',
     1access='direct',recl=36*19*4)
      OPEN(21,file='cca_sfcT.95-07.ctg.gr',
     1access='direct',recl=36*19*4)
C
C= read in mask
      read(11,rec=1) wk
      call real_2_itg(wk,mask,imx,jmx)
c
      a=0.43
      b=-0.43
      DO 150 it=1,ltime
        read(10,rec=it) wk
      do i=1,imx
      do j=1,jmx
      if(mask(i,j).eq.1) then
      IF (wk(i,j).le.b) wk(i,j)=1
      IF (wk(i,j).ge.a) wk(i,j)=3
      IF (wk(i,j).lt.a.and.wk(i,j).gt.b) wk(i,j)=2
      else
      wk(i,j)=-999.0
      end if
      enddo
      enddo
      write(21,rec=it) wk
      
  150 CONTINUE
      PRINT 151
151   FORMAT('program complete')
      STOP
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  real 2 integer
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine real_2_itg(wk,mw,m,n)
      dimension wk(m,n),mw(m,n)
c
      do i=1,m
      do j=1,n
      mw(i,j)=wk(i,j)
      end do
      end do
c
      return
      end

