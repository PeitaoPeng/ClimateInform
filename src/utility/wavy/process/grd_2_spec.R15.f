      program transform
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC C
C     transfer data from spctral form to grid form and vice versa              C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PARAMETER(NW=15)
      PARAMETER(NLEG=NW+1)
      PARAMETER(NM=NW)
      PARAMETER(NMP=NW+1)
      PARAMETER(NLONG=64)
      PARAMETER(NLATG=40)
c
      PARAMETER(NXIN=144)
      PARAMETER(NYIN=73)
CC
      PARAMETER(NLONGP=NLONG+1,IMAXT=3*NLONG/2)
      PARAMETER(KHALF=(NLATG+1)/2)
      PARAMETER(EA=6.371E+06,GRAV=9.8)
      COMMON/GAUSS/RADG(NLATG),GWGT(NLATG)
      COMMON/POLY1/PLEG(NLEG,NMP,NLATG),DPLEG(NLEG,NMP,NLATG)
      COMMON/FFTAR1/TRIGS(IMAXT),IFAX(10)
      COMMON/FFTAR2/ARRAY(NLONGP,NLATG),WORK(NLONGP,NLATG)
      DIMENSION FIELDG(NLONG,NLATG),out(NLONG,NLATG)
      real      FLDSPC(2,NLEG,NMP)
      real      FLDSIN(2,NLEG,NMP)
      real*8    COLRAD(KHALF),WGT(KHALF),WGTCS(KHALF),RCS2(KHALF)
C
      real yy(NYIN),yy2(NLATG),ygr15(NLATG),xx(NXIN),xx2(NLONG)
      real grd0(NXIN,NYIN)
      real grd1(NXIN,NYIN),grd2(NLONG,NLATG)

      data ygr15/     -86.598,-82.191,-77.758,-73.319,-68.878,-64.435,
     &-59.992,-55.549,-51.106,-46.662,-42.218,-37.774,-33.330,-28.886,
     &-24.442,-19.998,-15.554,-11.110, -6.666,-2.222,
     & 2.222,6.666,11.110,15.554,19.998,24.442,28.886,33.330,37.774,
     & 42.218,46.662,51.106,55.549,59.992,64.435,68.878,73.319,
     & 77.758,82.191,86.598/
c
      open(unit=10,form='unformatted',access='direct',
     *recl=4*NXIN*NYIN)
      open(unit=20,form='unformatted',access='direct',
     *recl=4*NLONG*NLATG)
      open(unit=60,form='unformatted',access='direct',
     *recl=2*4*NLEG*NMP)
c
      DXX =360.0/float(NXIN)
      DXX2=360.0/float(NLONG)
      DYY =180.0/(NYIN-1)
      CALL SETXY(XX, NXIN, YY ,NYIN, 0.0, DXX, -90., DYY)
      CALL SETXY(XX2,NLONG,yy2,NLATG,0.0,DXX2,0.0,0.0)

      LENSPC=2*NLEG*NMP
      LENGRD=NLONG*NLATG
      UNDEF=-9999    
      PI=ACOS(-1.0)
      CALL GLATS(KHALF,COLRAD,WGT,WGTCS,RCS2)
      DO 30 K=1,KHALF
      RADG(K)=PI/2.0 - real(COLRAD(K))
      RADG(NLATG-K+1)=-RADG(K)
      GWGT(K)=real(WGT(K))
      GWGT(NLATG-K+1)=+GWGT(K)
   30 CONTINUE
      DO 40 JG=1,NLATG
      CALL GENPNME15(RADG(JG),PLEG(1,1,JG),DPLEG(1,1,JG))
   40 CONTINUE
c
      do 1000 II=1,nfld
      read(10,rec=II) grd0
      call norsou(grd0,grd1,NXIN,NYIN)
      call intp2d(grd1,NXIN,NYIN,xx,yy,grd2,NLONG,NLATG,xx2,ygr15,0)
      write(20,rec=II) grd2      
      call TRNSFM15(grd2,FLDSPC)
      write(60,rec=II) FLDSPC       
      write(6,*) 'II=',II
 1000 CONTINUE
      STOP
      END
 
 
      SUBROUTINE SETZEROSP(FLD,NLEG,NMP)
      DIMENSION FLD(2,NLEG,NMP)
        do j=1,NLEG
        do k=1,NMP 
        FLD(1,j,k)=0.
        FLD(2,j,k)=0.
        ENDDO
        ENDDO
      RETURN
      END
      SUBROUTINE SETZEROGD(FLD,NX,NY)
      DIMENSION FLD(NX,NY)
        do j=1,NX
        do k=1,NY 
        FLD(j,k)=0.
        ENDDO
        ENDDO
      RETURN
      END

