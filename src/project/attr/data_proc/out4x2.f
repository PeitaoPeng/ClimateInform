      program rewrite
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. shift had sst to normal start/end longitudes
C===========================================================
      PARAMETER (imx=180,jmx=89)
      PARAMETER (imx2=90,jmx2=89)
      real fld1(imx,jmx)
      real out(imx2,jmx2)
c
      open(10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(80,form='unformatted',access='direct',recl=4*imx2*jmx2)
c
      iu=10
c
c read in data
c
        read(iu,rec=1) fld1
c
      do i=1,imx2
      do j=1,jmx2
      ii=1+2*(i-1)
      jj=j
      if(abs(fld1(ii,jj)).gt.99) out(i,j)=-999.
      if(abs(fld1(ii,jj)).lt.99) out(i,j)=fld1(ii,jj)
c     out(i,j)=fld1(ii,jj)
      enddo
      enddo
      write(80,rec=1) out
      
      stop
      end

