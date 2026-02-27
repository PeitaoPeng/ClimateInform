#!/bin/sh
set -xe
#
#  Postprocessing for CPC seasonal forecast
#

yyyy=$1 ;# starting year                --- labled as the year of the 1st target month
mm=$2   ;# starting month (two-digits)  --- labled as the 1st target month

#yyyy=2004        ;# starting year
#mm=08            ;# starting month (two-digits)

postdir=/gpfsuser/g03/wx52ww/CFSfcst/Realtime/CPC        ;# post processing directory

cd $postdir
if [ $? -ne 0 ] ; then
 echo "$postdir does not exist."
 exit 1
fi 

yyyymm=${yyyy}_${mm}

cat <<fEOF1> CPCfcst.f
C
C interpolate to get forecasts for individul stations
C        prcp (mm/month)
C        temp (kelvin)
C################################################
C  imons   : number of target months         file
C  iseas   : number of seasons in anomaly    file
C  nvars:    number of vairiables in anomaly file
C  nvarskls: number of vairiables in skill   file
C################################################
C
      parameter (imax=192,imax1=imax+1,imax2=imax+2,jmax=94,nst=349)
      parameter (imaxz=144,jmaxz=73)
      parameter (im=145,jm=37)
      parameter (nvars=21,nvarskls=10,imons=9,iseas=7)
      parameter (iyr=$yyyy,imo=$mm,MF=6)

C constant for T62 grid
      dimension yy(jmax),xx(imax2)
C constant for stations
      dimension in(nst),istid(nst),xc(nst),yc(nst),wt(nst)
C constant for stations
      dimension yg(jm),xg(im)

C forecat for stations
      dimension ts(imax,jmax),pr(imax,jmax)
      dimension wrkt(imax2,jmax),wrkp(imax2,jmax)
      dimension tempin(imax2,jmax),prcpin(imax2,jmax)
      dimension tempstd0(imax2,jmax),prcpstd0(imax2,jmax)
      dimension tempstd(imax2,jmax),prcpstd(imax2,jmax)
      dimension wrkz(imaxz,jmaxz)
      dimension z700std0(imaxz,jmaxz)
      dimension z700in(imaxz,jmaxz),z700std(imaxz,jmaxz)
      dimension tempout(nst),prcpout(nst)

C skill
      dimension stemp(imax2,jmax),sprcp(imax2,jmax)
      dimension skltemp(nst,12),sklprcp(nst,12)

C forecat for regular grid
      dimension tempgrd(im,jm),prcpgrd(im,jm),z700grd(im,jm)
C tmp array
c     dimension tmpTs1(imax,jmax),tmpPr1(imax,jmax),tmpZ71(imaxz,jmaxz)
c     dimension tmpTs2(imax,jmax),tmpPr2(imax,jmax),tmpZ72(imaxz,jmaxz)
c     dimension tmpTs3(imax,jmax),tmpPr3(imax,jmax),tmpZ73(imaxz,jmaxz)

      character*5 runid
      data runid/'cfs03'/
      character*42 ftempdir
      character*43 fprcpdir
      character*43 fz700dir
      data ftempdir/'/gpfsuser/g03/wx52ww/CFSfcst/Realtime/T2m/'/
      data fprcpdir/'/gpfsuser/g03/wx52ww/CFSfcst/Realtime/Prec/'/
      data fz700dir/'/gpfsuser/g03/wx52ww/CFSfcst/Realtime/z700/'/

      character*44 skilldir
      data skilldir/'/gpfsuser/g03/wx52ww/CFSfcst/Hcst/HcstSkill/'/

      data bad/-999.00/
      data bad1/-99999.00/

      open(1,form='formatted',
     & file='/nfsuser/g03/wx52ww/CFSfcst/Realtime/CPC/yg.T62.dat')
      open(2,form='formatted',
     & file='/nfsuser/g03/wx52ww/CFSfcst/Realtime/CPC/us.cdiv.ha.dat')

      open(51,file='stus_temp_cfs_f',form='formatted')
      open(52,file='stus_prcp_cfs_f',form='formatted')

      open(61,file='temp_cfs_f',form='formatted')
      open(62,file='prcp_cfs_f',form='formatted')
      open(63,file='z700_cfs_f',form='formatted')

      open (3,form='unformatted',access='direct',recl=imax*jmax*4
     1       ,file=skilldir//'cfs03T2mSkillSea.gr')
      open (4,form='unformatted',access='direct',recl=imax*jmax*4
     1       ,file=skilldir//'cfs03PrecSkillSea.gr')
      open (7,form='unformatted',access='direct',recl=imaxz*jmaxz*4
     1       ,file=skilldir//'cfs03z700SkillSea.gr')

      open (11,form='unformatted',access='direct',recl=imax*jmax*4
     1        ,file=ftempdir//"cfs03T2m${yyyy}AnmRealtime.gr")
      open (12,form='unformatted',access='direct',recl=imax*jmax*4
     1        ,file=fprcpdir//"cfs03Prec${yyyy}AnmRealtime.gr")
      open (13,form='unformatted',access='direct',recl=imaxz*jmaxz*4
     1        ,file=fz700dir//"cfs03z700${yyyy}AnmRealtime.gr")

      dx=360.0/float(imax)
      call setxy(xx,imax2,yy,jmax,-dx,dx,0.0,0.0)
      read(1,102) yy
  102 format(94F8.3)

      dxg=360.0/float(im-1)
      dyg=90.0/float(jm-1)
      call setxy(xg,im,yg,jm,0.,dxg,0.0,dyg)

      do i=1,nst
       read(2,1100) in(i),istid(i),yc(i),xc(i),wt(i)
      enddo
 1100 format(2i8,2f10.4,1pe15.7)

C Read and interpolte skill values
C 7  overlapping target seasons available, skip the first season
c use 15-member average as forecast
c use standard deviation of individual seasons (NOT ensemble average)
c to normalize the ensemble-mean forecast anomalies
      do m=1,MF
       irecskl=(imo-1)*nvarskls*iseas+(3-1)*iseas+m+1 ! skill record
       read(3,rec=irecskl) ((stemp(i,j),i=2,imax1),j=1,jmax)
       read(4,rec=irecskl) ((sprcp(i,j),i=2,imax1),j=1,jmax)

C take care of bad values (>100 or <-100)
C           and unreasonable values (>1.0 or <-1.0)
       do j=1,jmax
       do i=2,imax1
        if (stemp(i,j).eq.bad) stemp(i,j)=0.0
        if (stemp(i,j).lt.-100.) stemp(i,j)=0.0
        if (stemp(i,j).gt.100.) stemp(i,j)=0.0
        if (stemp(i,j).lt.-1.0) stemp(i,j)=-1.0
        if (stemp(i,j).gt.1.0) stemp(i,j)=1.0
        if (sprcp(i,j).eq.bad) sprcp(i,j)=0.0
        if (sprcp(i,j).lt.-100.) sprcp(i,j)=0.0
        if (sprcp(i,j).gt.100.) sprcp(i,j)=0.0
        if (sprcp(i,j).lt.-1.0) sprcp(i,j)=-1.0
        if (sprcp(i,j).gt.1.0) sprcp(i,j)=1.0
       enddo
       enddo
       do j=1,jmax
        stemp(1,j)=stemp(imax1,j)
        sprcp(1,j)=sprcp(imax1,j)
        stemp(imax2,j)=stemp(2,j)
        sprcp(imax2,j)=sprcp(2,j)
       enddo
       call intp1d(stemp,imax2,jmax,xx,yy,skltemp(1,m),nst,xc,yc,bad)
       call intp1d(sprcp,imax2,jmax,xx,yy,sklprcp(1,m),nst,xc,yc,bad)
       do n=1,nst
        if(skltemp(n,m).lt.0.0) skltemp(n,m)=0.0
        if(sklprcp(n,m).lt.0.0) sklprcp(n,m)=0.0
       enddo
      enddo

      nfintemp=11                       ! input unit
      nfinprcp=12                       ! input unit
      nfinz700=13                       ! input unit

      nfouttemp=51                      ! output unit
      nfoutprcp=52                      ! output unit

      nfgrdtemp=61                      ! output unit
      nfgrdprcp=62                      ! output unit
      nfgrdz700=63                      ! output unit

C Read and interpolte skill values
C 7 overlapping target seasons available, skip the first season
c skill of 4 ensemble averages avalable,use the 15-member average (e15).
C e15 members in the hindcast covers roughly the same initial
c time range as 20 memmebers in real time forecast
c The skill define with e15 from hindcast may slightly under estimate
c the skill of the real-time forecast which uses 20 members.
      do m=1,MF
       irecstd=(imo-1)*nvarskls*iseas+(9-1)*iseas+m+1 ! variance record
c      print*,irecstd
       read(3,rec=irecstd) ((tempstd0(i,j),i=2,imax1),j=1,jmax)
       read(4,rec=irecstd) ((prcpstd0(i,j),i=2,imax1),j=1,jmax)
       read(7,rec=irecstd) ((z700std0(i,j),i=1,imaxz),j=1,jmaxz)
       do j=1,jmax
       do i=2,imax+1
        tempin(i,j)=0.
        prcpin(i,j)=0.
       enddo
       enddo
       do j=1,jmaxz
       do i=1,imaxz
        z700in(i,j)=0.
       enddo
       enddo
       do imem=1,20  ! use 20 members for ensemble average
        m1=m+1 ! first month/season is not used
        m2=m+3 ! first month/season is not used
        do ms=m1,m2 ! seasonal average
         irecin=(imo-1)*nvars*imons+(imem-1)*imons+ms ! raw anomaly record
         read(nfintemp,rec=irecin) ((wrkt(i,j),i=2,imax+1),j=1,jmax)
         read(nfinprcp,rec=irecin) ((wrkp(i,j),i=2,imax+1),j=1,jmax)
         read(nfinz700,rec=irecin) ((wrkz(i,j),i=1,imaxz),j=1,jmaxz)
         do j=1,jmax
         do i=2,imax+1
          tempin(i,j)=tempin(i,j)+wrkt(i,j)
          prcpin(i,j)=prcpin(i,j)+wrkp(i,j)
         enddo
         enddo
         do j=1,jmaxz
         do i=1,imaxz
          z700in(i,j)=z700in(i,j)+wrkz(i,j)
         enddo
         enddo
        enddo
       enddo
       do j=1,jmax
       do i=2,imax+1
        if(wrkt(i,j).ne.bad1) then
         tempin(i,j)=tempin(i,j)/20./3.
        else
         tempin(i,j)=bad
        endif
        if(wrkp(i,j).ne.bad1) then
         prcpin(i,j)=prcpin(i,j)/20./3.
        else
         prcpin(i,j)=bad
        endif
       enddo
       enddo
       do j=1,jmaxz
       do i=1,imaxz
        if(wrkz(i,j).ne.bad1) then
         z700in(i,j)=z700in(i,j)/20./3.
        else
         z700in(i,j)=bad
        endif
       enddo
       enddo
       
       do j=1,jmax
       do i=1,imax
        if(wrkt(i,j).ne.bad1) then
         tempstd(i+1,j)=tempin(i+1,j)/sqrt(tempstd0(i+1,j)+0.001)
        else
         tempstd(i,j)=bad
        endif
        if(wrkp(i,j).ne.bad1) then
         prcpstd(i+1,j)=prcpin(i+1,j)/sqrt(prcpstd0(i+1,j)+0.001)
        else
         prcpstd(i,j)=bad
        endif
       enddo
       enddo
       do j=1,jmax
        tempin(1,j)=tempin(imax1,j)
        tempin(imax2,j)=tempin(2,j)
        prcpin(1,j)=prcpin(imax1,j)
        prcpin(imax2,j)=prcpin(2,j)
        tempstd(1,j)=tempstd(imax1,j)
        tempstd(imax2,j)=tempstd(2,j)
        prcpstd(1,j)=prcpstd(imax1,j)
        prcpstd(imax2,j)=prcpstd(2,j)
       enddo

       call intp1d(tempstd,imax2,jmax,xx,yy,tempout,nst,xc,yc,bad)
       call intp1d(prcpstd,imax2,jmax,xx,yy,prcpout,nst,xc,yc,bad)

c      call amxmn(tempstd,imax2,jmax)

c      call intp2d(tempin,imax2,jmax,xx,yy,tempgrd,im,jm,xg,yg,bad)
c      call intp2d(prcpin,imax2,jmax,xx,yy,prcpgrd,im,jm,xg,yg,bad)
       call intp2d(tempstd,imax2,jmax,xx,yy,tempgrd,im,jm,xg,yg,bad)
       call intp2d(prcpstd,imax2,jmax,xx,yy,prcpgrd,im,jm,xg,yg,bad)

       do j=1,jm
        tempgrd(im,j)=tempgrd(1,j)
        prcpgrd(im,j)=prcpgrd(1,j)
       enddo

       do j=1,jmaxz
       do i=1,imaxz
        z700std(i,j)=z700in(i,j)/sqrt(z700std0(i,j)+0.01)
       enddo
       enddo

       do j=1,jm
       do i=1,im-1
c       z700grd(i,j)=z700in(i,j+jm-1)
        z700grd(i,j)=z700std(i,j+jm-1)
       enddo
       enddo
       do j=1,jm
        z700grd(im,j)=z700grd(1,j)
       enddo

       iyy=iyr             ! target year
       isns=imo+1+m        ! center month of target season
       if(isns.gt.12) then
        iyy=iyy+1
        isns=isns-12
       endif
       idate=iyy*100+isns
       do n=1,nst
        write(nfouttemp,1200) n,idate,tempout(n),skltemp(n,m)
     1                 ,istid(n),xc(n),yc(n),'temp',runid
        write(nfoutprcp,1200) n,idate,prcpout(n),sklprcp(n,m)
     1                 ,istid(n),xc(n),yc(n),'prcp',runid
       enddo
       write(nfgrdtemp,2001) tempgrd
       write(nfgrdtemp,2100) isns,1,iyy
       write(nfgrdprcp,2001) prcpgrd
       write(nfgrdprcp,2100) isns,1,iyy
       write(nfgrdz700,2001) z700grd
       write(nfgrdz700,2100) isns,1,iyy

      enddo

 1001 format(10f8.3)
 1200 format(i7,i8,2f8.3,i9,2f8.2,2x,a4,2x,a10)

 2001 format(10f8.3)
 2100 format(3i10)

      stop
      end
C
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

      SUBROUTINE INTP2D(A,IMX,IMY,XA,YA,B,JMX,JMY,XB,YB,BAD)
      PARAMETER(MAX=361,MAXP=361*181)
      COMMON /COMASK/ DEFLT,MASK(maxp)
      COMMON /COMWRK/ IERR,JERR,DXP(MAX),DYP(MAX),DXM(MAX),DYM(MAX),
     1                IPTR(MAX),JPTR(MAX),WGT(4)
      DIMENSION A(IMX,*),B(JMX,*),XA(*),YA(*),XB(*),YB(*)
      CALL SETPTR(XA,IMX,XB,JMX,IPTR,DXP,DXM,IERR)
      CALL SETPTR(YA,IMY,YB,JMY,JPTR,DYP,DYM,JERR)
c
      DO I = 1,4
       WGT(I) = 1.0
      enddo

      DO J = 1,JMY
      DO I = 1,JMX
       B(I,J) = bad
      enddo
      enddo

      DO 20 J = 1,JMY
        JM = JPTR(J)
        IF (JM.LT.0) GOTO 20
        JP = JM + 1
      DO 10 I = 1,JMX
        IM = IPTR(I)
        IF (IM.LT.0) GOTO 10
        IP = IM + 1
        D1 = DXM(I)*DYM(J)*WGT(1)
        D2 = DXM(I)*DYP(J)*WGT(2)
        D3 = DXP(I)*DYM(J)*WGT(3)
        D4 = DXP(I)*DYP(J)*WGT(4)
        if (a(ip,jp) .eq. deflt) d1=0.0
        if (a(ip,jm) .eq. deflt) d2=0.0
        if (a(im,jp) .eq. deflt) d3=0.0
        if (a(im,jm) .eq. deflt) d4=0.0
        DD = D1 + D2 +D3 + D4
        IF (DD.EQ.0.0) GOTO 10
        B(I,J) = (D4*A(IM,JM)+D3*A(IM,JP)+D2*A(IP,JM)+D1*A(IP,JP))/DD
   10 CONTINUE
   20 CONTINUE
C TREAMTMENT FOR THE POLES
      IF(YB(1).LT.-89.9) THEN
        IF(YA(1).LT.-85.0) THEN
          BSP=0.
          DO 30 I=1,IMX-1
   30     BSP=BSP+A(I,1)
          BSP=BSP/FLOAT(IMX-1)
          DO 40 I=1,JMX
   40     B(I,1)=BSP
        ELSE
          WRITE(6,1001)
          STOP 1
        ENDIF
      ENDIF
      IF(YB(JMY).GT.89.9) THEN
        IF(YA(IMY).GT.85.0) THEN
          BNP=0.
          DO 50 I=1,IMX-1
   50     BNP=BNP+A(I,IMY)
          BNP=BNP/FLOAT(IMX-1)
          DO 60 I=1,JMX
   60     B(I,JMY)=BNP
        ELSE
          WRITE(6,1002)
          STOP 2
        ENDIF
      ENDIF
 1001 FORMAT('Unacceptible grid distributions at south pole')
 1002 FORMAT('Unacceptible grid distributions at north pole')
      RETURN
      END
C
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

      SUBROUTINE SETXY(X,NX,Y,NY,XMN,DLX,YMN,DLY)
      DIMENSION X(NX),Y(NY)
      DO 10 I = 1,NX
   10   X(I) = XMN + DLX*FLOAT(I-1)
      IF (NY.EQ.0) RETURN
      DO 20 J = 1,NY
   20   Y(J) = YMN + DLY*FLOAT(J-1)
      RETURN
      END

      SUBROUTINE amxmn(X,im,jm)
      DIMENSION X(im,jm)
      am=-1.E20
      an=1.E20
      
      DO I = 1,im
      DO j = 1,jm
       if(am.lt.x(i,j)) am=x(i,j)
       if(an.gt.x(i,j)) an=x(i,j)
      enddo
      enddo

      print*,'am=',am,'  an=',an

      RETURN
      END
fEOF1
#
xlf_r -o CPCfcst.x CPCfcst.f
./CPCfcst.x
rm CPCfcst.x CPCfcst.f

ftp -v sgi9<<\EOF
cd /export-1/sgi101/operations/data/tmp
put stus_prcp_cfs_f
put stus_temp_cfs_f
put prcp_cfs_f
put temp_cfs_f
put z700_cfs_f
quit
EOF

#ftp -v sgi9<<\EOF
#cd /export-2/sgi106/jhoop/data/tmp/
#put stus_prcp_cfs_f
#put stus_temp_cfs_f
#put prcp_cfs_f
#put temp_cfs_f
#put z700_cfs_f
#quit
#EOF

#ftp -v sgi9<<\EOF
#cd /export-1/sgi106/cac/data/tmp
#put stus_prcp_cfs_f
#put stus_temp_cfs_f
#put prcp_cfs_f
#put temp_cfs_f
#put z700_cfs_f
#quit
#EOF
