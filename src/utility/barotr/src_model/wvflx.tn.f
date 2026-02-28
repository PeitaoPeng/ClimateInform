      PROGRAM   for wvflx 
      PARAMETER (IX=64, IY=40)                                          ZON00020
C     ----------------------------------------------------------------- ZON00040
C                                                                       ZON00120
      REAL  CPSI(IX,IY), TPSI(IX,IY), WKGD(IX,IY)                       ZON00130
      REAL  CDIV(IX,IY), TDIV(IX,IY)                                    ZON00130
      REAL  WK(IX,IY)                                                   ZON00340
      COMMON/STWV/AU(IX,IY),AV(IX,IY),
     1            APSI(IX,IY),
     2            XFS(IX,IY),YFS(IX,IY),
     6            CU(IX,IY),CV(IX,IY)
C                                                                       ZON00190
C-----------------------------------------------------
      open(unit=20,form='unformatted',access='direct',recl=4*ix*iy)
      open(unit=80,form='unformatted',access='direct',recl=4*ix*iy)
C 
C====read in clim and anomaly (clim+anom) psi and div
      irec=1
      read(20,rec=irec)WK
      call norsou(WK,CPSI,IX,IY)
      irec=irec+1
      read(20,rec=irec)CDIV
      irec=irec+1
      read(20,rec=irec)WK
      call norsou(WK,TPSI,IX,IY)
      irec=irec+1
      read(20,rec=irec)TDIV
C----------------------------------------------
      do j =1,IY
      do i =1,IX
      WKGD(i,j)=TPSI(i,j)-CPSI(i,j)
      end do
      end do
C=======================================================
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
C-------------------------------------------------------------------
      STOP
      END

