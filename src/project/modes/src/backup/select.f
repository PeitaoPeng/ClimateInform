      program select_reof
      include "parm.h"
      dimension f2d(imx,jmx),f2d2(imx,jmx)
C
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=14,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=15,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=16,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=17,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=18,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=19,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=22,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(unit=50,form='unformatted',access='direct',recl=4*imx*jmx)
c*************************************************
C
C mon from Jan to Apr
      iw=0
      do mon=1,4
      iu=10+mon
      do ir=1,10
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      enddo
      enddo
C mon=May
      mon=5
      iu=10+mon
      do ir=1,13
      if(ir.ne.1.and.ir.ne.9.and.ir.ne.13) then
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      endif
      enddo
C mon=Jun
      mon=6
      iu=10+mon
      do ir=1,13
      if(ir.ne.1.and.ir.ne.6.and.ir.ne.13) then
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      endif
      enddo
C mon=Jul
      mon=7
      iu=10+mon
      do ir=1,13
      if(ir.ne.1.and.ir.ne.2.and.ir.ne.13) then
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      endif
      enddo
C mon=Aug
      mon=8
      iu=10+mon
      do ir=1,11
      if(ir.ne.1) then
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      endif
      enddo
C mon from Sep to Dec
      do mon=9,12
      iu=10+mon
      do ir=1,10
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      enddo
      enddo

      stop
      end
