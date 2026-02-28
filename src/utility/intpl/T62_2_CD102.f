      program T62toCD349
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from gausian grid to regular grid or vice versa
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
#include "parm.h"
      PARAMETER (imax=192,jmax=94,nst=102)
      real ygt62(jmax),yy(jmax),xx(imax)
      real grd(imax,jmax),wkcd(nst),
     %     cdout(nst)
      dimension in(nst),istid(nst),xc(nst),yc(nst),wt(nst)

      data ygt62/
     &-88.542,-86.653,-84.753,-82.851,-80.947,-79.043,-77.139,-75.235,
     &-73.331,-71.426,-69.522,-67.617,-65.713,-63.808,-61.903,-59.999,
     &-58.094,-56.189,-54.285,-52.380,-50.475,-48.571,-46.666,-44.761,
     &-42.856,-40.952,-39.047,-37.142,-35.238,-33.333,-31.428,-29.523,
     &-27.619,-25.714,-23.809,-21.904,-20.000,-18.095,-16.190,-14.286,
     &-12.381,-10.476, -8.571, -6.667, -4.762, -2.857, -0.952,  0.952,
     &  2.857,  4.762,  6.667,  8.571, 10.476, 12.381, 14.286, 16.190,
     & 18.095, 20.000, 21.904, 23.809, 25.714, 27.619, 29.523, 31.428, 
     & 33.333, 35.238, 37.142, 39.047, 40.952, 42.856, 44.761, 46.666,
     & 48.571, 50.475, 52.380, 54.285, 56.189, 58.094, 59.999, 61.903,
     & 63.808, 65.713, 67.617, 69.522, 71.426, 73.331, 75.235, 77.139,
     & 79.043, 80.947, 82.851, 84.753, 86.653, 88.542/
C
      data bad/-999.00/

      open(unit=10,form='formatted')
      open(unit=11,form='unformated',access='direct',recl=imax*jmax)
      open(unit=61,form='unformated',access='direct',recl=nst)
C
      DXX =360.0/float(imax)
      CALL SETXY(XX, imax, yy ,jmax, 0.0,DXX, 0.0,0.0)
C
      do i=1,nst
       read(10,777) yc(i),xc(i)
       xc(i)=360+xc(i)
c      write(6,777) yc(i),xc(i)
      enddo
  777 format(f6.2,1x,f7.2)

      iu=11
      iuo=61
C
      IF(iskip.lt.1) go to 666
      do is=1,iskip
        read(iu) grd1
      end do
  666 continue

      do 1000 kk=1,ltime
      read(iu)  grd
      write(6,*)'grd(20,20)=',grd(20,20)
      call intp1d(grd,imax,jmax,xx,ygt62,wkcd,nst,xc,yc,bad)
      write(iuo) wkcd
      write(6,*)'it=',kk,'wkcd(20)=',wkcd(20)
 1000 continue
      write(6,*)'ygt62=',ygt62
      write(6,*)'xx=',xx    
      write(6,*)'xx2=',xx2   

 2000 continue
      stop
      END

      SUBROUTINE norsou(fldin,fldot,lon,lat)
      dimension fldin(lon,lat),fldot(lon,lat)
      do 100 j=1,lat
      do 100 i=1,lon
      fldot(i,j)=fldin(i,lat+1-j)
  100 continue
      return
      end

      SUBROUTINE INTP1D(A,IMX,IMY,XA,YA,B,nst,XB,YB,BAD)
      PARAMETER(MAX=1000,MAXP=361*181)
      COMMON /COMASK/ DEFLT,MASK(maxp)
      COMMON /COMWRK/ IERR,JERR,DXP(MAX),DYP(MAX),DXM(MAX),DYM(MAX),
     1                IPTR(MAX),JPTR(MAX)
      DIMENSION A(IMX,*),B(*),XA(*),YA(*),XB(*),YB(*)
      CALL SETPTR(XA,IMX,XB,nst,IPTR,DXP,DXM,IERR)
      CALL SETPTR(YA,IMY,YB,nst,JPTR,DYP,DYM,JERR)
c
      do k=1,nst
       B(k)=bad
      enddo
      DO 20 K = 1,nst
        JM = JPTR(K)
        IF (JM.LT.0) GOTO 20
        JP = JM + 1
        IM = IPTR(K)
        IF (IM.LT.0) GOTO 20
        IP = IM + 1
        D1 = DXM(K)*DYM(K)
        D2 = DXM(K)*DYP(K)
        D3 = DXP(K)*DYM(K)
        D4 = DXP(K)*DYP(K)
        DD = D1 + D2 +D3 + D4
        IF (DD.EQ.0.0) GOTO 20
        B(K) = (D4*A(IM,JM)+D3*A(IM,JP)+D2*A(IP,JM)+D1*A(IP,JP))/DD
   20 CONTINUE
      RETURN
      END

      SUBROUTINE SETPTR(X,M,Y,N,IPTR,DP,DM,IERR)
      DIMENSION X(*),Y(*),IPTR(*),DP(*),DM(*)
      IERR = 0
      DO 10 J = 1,N
        YL = Y(J)
        IF (YL.LT.X(1)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 10
        ELSEIF (YL.GT.X(M)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 10
        ENDIF
        DO 20 I = 1,M-1
          IF (YL.GT.X(I+1)) GOTO 20
          DM(J) = YL-X(I)
          DP(J) = X(I+1)-YL
          IPTR(J) = I
          GOTO 10
  20    CONTINUE
  10  CONTINUE
      RETURN
      END

