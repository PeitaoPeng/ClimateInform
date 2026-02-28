      program rewrite
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. shift had sst to normal start/end longitudes
C===========================================================
      PARAMETER (imx=360,jmx=180)
      real fld1(imx,jmx),fld2(imx,jmx)
c
      open(10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(80,form='unformatted',access='direct',recl=4*imx*jmx)
c
      iu=10
      its=iskip+1
c
c read in data
c
      do it=1,ltime
        read(iu,rec=it) fld1
        call shift(fld1,fld2,imx,jmx)
        write(80,rec=it) fld2
      enddo
c
      stop
      end


      SUBROUTINE shift(f1,f2,mx,my)
c shift hadsst from -180-180 to 0-360
      DIMENSION f1(mx,my)
      DIMENSION f2(mx,my)

      do j=1,my
      do i=1,180
      f2(i,j)=f1(i+180,j)
      f2(i+180,j)=f1(i,j)
      enddo
      enddo

      return
      end

