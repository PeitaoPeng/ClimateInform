      PROGRAM   for wvflx 
C     PARAMETER (imx=144, jmx=73)                                       ZON00020
      PARAMETER (imx=64, jmx=40)                                        ZON00020
      PARAMETER (IX=64, IY=40)                                          ZON00020
C     ----------------------------------------------------------------- ZON00040
C                                                                       ZON00120
      REAL  CPSI(IX,IY), TPSI(IX,IY), WKGD(IX,IY)                       ZON00130
      REAL  CDIV(IX,IY), TDIV(IX,IY)                                    ZON00130
      REAL  WKin(imx,jmx)                                               ZON00340
      REAL  WK(IX,IY)                                                   ZON00340
      COMMON/STWV/AU(IX,IY),AV(IX,IY),
     1            APSI(IX,IY),
     2            XFS(IX,IY),YFS(IX,IY),
     6            CU(IX,IY),CV(IX,IY)
C                                                                       ZON00190
      real yy(jmx),yy2(IY),ygr15(IY),xx(imx),xx2(IX)
      data ygr15/     -86.598,-82.191,-77.758,-73.319,-68.878,-64.435,
     &-59.992,-55.549,-51.106,-46.662,-42.218,-37.774,-33.330,-28.886,
     &-24.442,-19.998,-15.554,-11.110, -6.666,-2.222,
     & 2.222,6.666,11.110,15.554,19.998,24.442,28.886,33.330,37.774,
     & 42.218,46.662,51.106,55.549,59.992,64.435,68.878,73.319,
     & 77.758,82.191,86.598/
C-----------------------------------------------------
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=80,form='unformatted',access='direct',recl=4*ix*iy)
C-----------------------------------------------------------------
C 144x73 to R15
C----------------------------------------
c     DXX =360.0/float(imx)
c     DXX2=360.0/float(IX)
c     DYY =180.0/(jmx-1)
c     CALL SETXY(XX, imx, YY ,jmx, 0.0, DXX, -90., DYY)
c     CALL SETXY(XX2,IX,yy2,IY,0.0,DXX2,0.0,0.0)
C 
C====read in clim and anomaly (clim+anom) psi and div
      irec=1
c     read(20,rec=irec)WKin
      read(20,rec=irec)WK
c     call INTP2D(WKin,imx,jmx,xx,yy,WK,IX,IY,xx2,ygr15,0)
      call norsou(WK,CPSI,IX,IY)
      irec=irec+1
c     read(20,rec=irec)WKin
      read(20,rec=irec)WK
c     call INTP2D(WKin,imx,jmx,xx,yy,WK,IX,IY,xx2,ygr15,0)
      call norsou(WK,WKGD,IX,IY)
C----------------------------------------------
      iwrt=0
C---write out apsi
      iwrt=iwrt+1
      write(80,rec=iwrt) WKGD
C---wvflx for apsi
      call wvflxtn(CPSI,WKGD,XFS,YFS)
      iwrt=iwrt+1
      write(80,rec=iwrt) XFS
      iwrt=iwrt+1
      write(80,rec=iwrt) YFS
      iwrt=iwrt+1
      write(80,rec=iwrt) APSI
      iwrt=iwrt+1
      write(80,rec=iwrt) AU
      iwrt=iwrt+1
      write(80,rec=iwrt) AV
      iwrt=iwrt+1
      write(80,rec=iwrt) CU
      iwrt=iwrt+1
      write(80,rec=iwrt) CV
C-------------------------------------------------------------------
      STOP
      END

