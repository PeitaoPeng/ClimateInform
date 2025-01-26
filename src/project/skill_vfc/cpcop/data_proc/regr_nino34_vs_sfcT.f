      parameter(ltime=690,imx=36,jmx=19)
      DIMENSION mask(imx,jmx),wk(imx,jmx)
      DIMENSION ts(ltime),rg(imx,jmx),f3d(ltime,imx,jmx)
      OPEN(10,file='nino34_3mon.jfm50-jja07.gr',
     1access='direct',recl=4)
      OPEN(11,file='ussfcT.3mon_mean.jfm50-jas07.gr',
     1access='direct',recl=4*imx*jmx)
      OPEN(12,file='mask_2x2.data',
     1access='direct',recl=36*19*4)
c     OPEN(21,file='sfcT_regr_2_nino34.95-07.gr',
      OPEN(21,file='sfcT_regr_2_nino34.50-07.gr',
     1access='direct',recl=36*19*4)
      OPEN(22,file='sfcT_constructed.95-07.gr',
     1access='direct',recl=36*19*4)
C
C= read in mask
      read(12,rec=1) wk
      call real_2_itg(wk,mask,imx,jmx)
c= read in nino34
      do it=1,ltime
        read(10,rec=it) ts(it)
      enddo
c= read in T
      do it=1,ltime
        read(11,rec=it) wk
        do i=1,imx
        do j=1,jmx
          f3d(it,i,j)=wk(i,j)
        enddo
        enddo
      enddo
c= regression
      do i=1,imx
      do j=1,jmx
      if(mask(i,j).eq.1) then
      xx=0
      yy=0
      xy=0
      do it=1,ltime
        xx=xx+ts(it)*ts(it)/float(ltime)
        yy=yy+f3d(it,i,j)*f3d(it,i,j)/float(ltime)
        xy=xy+ts(it)*f3d(it,i,j)/float(ltime)
      enddo
c
      sdx=sqrt(xx)
      sdy=sqrt(yy)
      rg(i,j)=xy/(sdx)

      else
        rg(i,j)=-999.0
      endif

      enddo
      enddo

      write(21,rec=1) rg
      
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

