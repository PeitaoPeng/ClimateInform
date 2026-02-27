      program uv2spidiv
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C 144x73 to R15 and uv to psi and div
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      include "parm.h"
      PARAMETER (imx=144,jmx=73,imx2=64,jmx2=40)
      real yy(jmx),yy2(jmx2),ygr15(jmx2),xx(imx),xx2(imx2)
      real u1(imx,jmx),u2(imx2,jmx2)
      real v1(imx,jmx),v2(imx2,jmx2)
      real so1(imx,jmx),so2(imx2,jmx2)
      real s1(imx,jmx),s2(imx2,jmx2)
      real sf(imx2,jmx2),div(imx2,jmx2)
      real ur(imx2,jmx2),vr(imx2,jmx2)
      real ud(imx2,jmx2),vd(imx2,jmx2)
      real wk1(imx2,jmx2),wk2(imx2,jmx2)

      data ygr15/     -86.598,-82.191,-77.758,-73.319,-68.878,-64.435,
     &-59.992,-55.549,-51.106,-46.662,-42.218,-37.774,-33.330,-28.886,
     &-24.442,-19.998,-15.554,-11.110, -6.666,-2.222,
     & 2.222,6.666,11.110,15.554,19.998,24.442,28.886,33.330,37.774,
     & 42.218,46.662,51.106,55.549,59.992,64.435,68.878,73.319,
     & 77.758,82.191,86.598/
C
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=50,form='unformatted',access='direct',recl=4*imx2*jmx2)

      DXX =360.0/float(imx)
      DXX2=360.0/float(imx2)
      DYY =180.0/(jmx-1)
      CALL SETXY(XX, imx, YY ,jmx, 0.0, DXX, -90., DYY) 
      CALL SETXY(XX2,imx2,yy2,jmx2,0.0,DXX2,0.0,0.0)
C
      ir=1
      iw=1
      DO it=1,ltime

      read(10,rec=ir) so1
      ir=ir+1

      call intp2d(so1,imx,jmx,xx,yy,so2,imx2,jmx2,xx2,ygr15,0)

c     write(50,rec=iw) so2
c     iw=iw+1

      read(10,rec=ir) u1
      ir=ir+1

      call intp2d(u1,imx,jmx,xx,yy,u2,imx2,jmx2,xx2,ygr15,0)

      read(10,rec=ir) v1
      ir=ir+1

      call intp2d(v1,imx,jmx,xx,yy,v2,imx2,jmx2,xx2,ygr15,0)

      call norsou(u2,wk1,imx2,jmx2)
      call norsou(v2,wk2,imx2,jmx2)

      call RVDVVPST15(wk1,wk2,ur,vr,ud,vd,sf,div)

      call norsou(sf,wk1,imx2,jmx2)
      call norsou(div,wk2,imx2,jmx2)

      write(50,rec=iw) wk1
      iw=iw+1
      write(50,rec=iw) wk2
      iw=iw+1

      write(6,*)'it=',it, ud(20,20), vd(20,20)

      ENDDO

      stop
      END
