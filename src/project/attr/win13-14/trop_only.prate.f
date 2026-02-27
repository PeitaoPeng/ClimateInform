      program REG2GAU
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from reg to gausian grid 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      include "parm.h"
      PARAMETER (imx=144,jmx=72,imx2=64,jmx2=40)
      real ygr15(jmx2)
      real grd1(imx,jmx),grd2(imx2,jmx2)
      real grd3(imx,jmx),grd4(imx2,jmx2)

      data ygr15/     -86.598,-82.191,-77.758,-73.319,-68.878,-64.435,
     &-59.992,-55.549,-51.106,-46.662,-42.218,-37.774,-33.330,-28.886,
     &-24.442,-19.998,-15.554,-11.110, -6.666,-2.222,
     & 2.222,6.666,11.110,15.554,19.998,24.442,28.886,33.330,37.774,
     & 42.218,46.662,51.106,55.549,59.992,64.435,68.878,73.319,
     & 77.758,82.191,86.598/
C
      open(unit=11,form='unformatted',access='direct',
     *recl=4*imx*jmx)
      open(unit=12,form='unformatted',access='direct',
     *recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',
     *recl=4*imx2*jmx2)
      open(unit=22,form='unformatted',access='direct',
     *recl=4*imx2*jmx2)
c
c for 144x72 data
      do 1000 kk=1,ltime

      read(11,rec=kk)  grd1
      do i=1,imx
      do j=1,jmx
        if(j.lt.28.or.j.gt.45) then
        grd3(i,j)=-999.0
        else
        grd3(i,j)=grd1(i,j)
        endif
      enddo
      enddo
      write(12,rec=kk) grd3
c for R15 data
      read(21,rec=kk)  grd2
      do i=1,imx2
      do j=1,jmx2
        if(j.lt.16.or.j.gt.25) then
        grd4(i,j)=-999.0
        else
        grd4(i,j)=grd2(i,j)
        endif
      enddo
      enddo
      write(22,rec=kk) grd4

 1000 continue

      stop
      END
