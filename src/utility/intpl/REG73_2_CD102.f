      program REG73toCD102
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from gausian grid to regular grid or vice versa
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      include "parm.h"
      PARAMETER (imax=144,jmax=73,nst=102)
      real yy(jmax),xx(imax)
      real grd(imax,jmax),wkcd(nst),
     %     cdout(nst)
      dimension in(nst),istid(nst),xc(nst),yc(nst),wt(nst)
C
      data bad/-999.00/

      open(unit=10,form='formatted')
      open(unit=11,form='unformatted',access='direct',recl=4*imax*jmax)
      open(unit=61,form='formatted')
C
      DYY =180.0/(jmax-1)
      DXX =360.0/float(imax)
      CALL SETXY(XX, imax, yy ,jmax, 0.,DXX, -90.,DYY)
C
      do i=1,nst
       read(10,777) yc(i),xc(i)
       xc(i)=360+xc(i)
       write(6,777) yc(i),xc(i)
      enddo
  777 format(f6.2,1x,f7.2)
  888 format(10f6.1)

      iu=11
      iuo=61
C
      ir=0
      do 1000 kk=2003,2006
      do ld=1,7
      ir=ir+1
      ldd=ld-1
      write(iuo,*) 'yr=',kk,'   Lead=',ldd
      read(iu,rec=ir) grd
      write(6,*)'grd(20,20)=',grd(20,20)
      call intp1d(grd,imax,jmax,xx,yy,wkcd,nst,xc,yc,bad)
      write(iuo,888) wkcd
      write(6,*)'it=',kk,'wkcd(20)=',wkcd(20)
      enddo
 1000 continue
      write(6,*)'yy=',yy
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

