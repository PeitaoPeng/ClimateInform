      PROGRAM   for wvflx 
      PARAMETER (IX=64, IY=40)                                          ZON00020
C     ----------------------------------------------------------------- ZON00040
C                                                                       ZON00120
      REAL  CPSI(IX,IY), TPSI(IX,IY), APSI(IX,IY)                       ZON00130
      REAL  CDIV(IX,IY), TDIV(IX,IY)                                    ZON00130
      REAL  XFS(IX,IY), YFS(IX,IY)                                      ZON00340
      REAL  XFS2(IX,IY), YFS2(IX,IY)                                    ZON00340
      REAL  AXFS(IX,IY), AYFS(IX,IY)                                    ZON00340
      REAL  WK(IX,IY)                                                   ZON00340
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
      APSI(i,j)=TPSI(i,j)-CPSI(i,j)
      end do
      end do
C=======================================================
      iwrt=0
C---write out psi
      iwrt=iwrt+1
      write(80,rec=iwrt) APSI
C---wvflx of anom psi
      call wvflxnd(APSI,XFS,YFS)
      iwrt=iwrt+1
      write(80,rec=iwrt) XFS
      iwrt=iwrt+1
      write(80,rec=iwrt) YFS
C---wvflx of CPSI
      call wvflxnd(CPSI,XFS,YFS)
C---wvflx of TPSI
      call wvflxnd(TPSI,XFS2,YFS2)
c
C---Differences
      do I=1,IX
      do J=1,IY
        AXFS(I,J)=XFS2(I,J)-XFS(I,J)
        AYFS(I,J)=YFS2(I,J)-YFS(I,J)
      ENDDO
      ENDDO

      iwrt=iwrt+1
      write(80,rec=iwrt) AXFS
      iwrt=iwrt+1
      write(80,rec=iwrt) AYFS
C-------------------------------------------------------------------
      STOP
      END

