      program eof
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (ngrd=102)
      PARAMETER (iskip=30)
      real fld1(ngrd),stdv1(ngrd)
      real fld2(ngrd),stdv2(ngrd)
      real fld3(ngrd),stdv3(ngrd)
      real f2din1(ngrd,ltime),f2dot1(ngrd,ltime-iskip)
      real f2din2(ngrd,ltime),f2dot2(ngrd,ltime-iskip)
      real f2din3(ngrd,ltime),f2dot3(ngrd,ltime-iskip)
 
      open(unit=10,form='formated')
      open(unit=15,form='formated')
      open(unit=20,form='formated')
      open(unit=80,form='unformated',access='direct',recl=ngrd)
c
      call setzero(stdv1,ngrd)
      call setzero(stdv2,ngrd)
      call setzero(stdv3,ngrd)
c
      do it=1,ltime
        read(10,888) fld1
        read(15,888) fld2
        read(20,888) fld3
          do i=1,ngrd
            f2din1(i,it)=fld1(i)
            f2din2(i,it)=fld2(i)
            f2din3(i,it)=fld3(i)
          end do
      end do
c
      call wmoclim(f2din1,f2dot1,ngrd,ltime,ltime-iskip)
      call wmoclim(f2din2,f2dot2,ngrd,ltime,ltime-iskip)
      call wmoclim(f2din3,f2dot3,ngrd,ltime,ltime-iskip)
c
      do it=1,ltime-iskip
       do i=1,ngrd
        stdv1(i)=stdv1(i)+f2dot1(i,it)*f2dot1(i,it)/float(ltime-iskip)
        stdv2(i)=stdv2(i)+f2dot2(i,it)*f2dot2(i,it)/float(ltime-iskip)
        stdv3(i)=stdv3(i)+f2dot3(i,it)*f2dot3(i,it)/float(ltime-iskip)
       end do
      end do
c
      write(80) stdv1
      write(80) stdv2
      write(80) stdv3
c
 888  format(10f7.1)
      return
      end

      SUBROUTINE normal(rot,ltime)
      DIMENSION rot(ltime)
      sd=0.
      do i=1,ltime
        sd=sd+rot(i)*rot(i)/float(ltime)
      enddo
        sd=sqrt(sd)
      do i=1,ltime
        rot(i)=rot(i)/sd
      enddo
c
      stop
      end
c
      SUBROUTINE setzero(fld,n)
      DIMENSION fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end
c
      SUBROUTINE wmoclim(grid,wmoobs,imax,ltime,ntprd)
      DIMENSION grid(imax,ltime),wmoobs(imax,ntprd)
C== define 30yr climate fields (31-60,41-70,51-80,61-90 and 71-00)
      do i=1,imax
        c1=0.0
        c2=0.0
        c3=0.0
        c4=0.0
        c5=0.0
      do k=1,30
        c1=c1+grid(i,k)/30.
        c2=c2+grid(i,k+10)/30.
        c3=c3+grid(i,k+20)/30.
        c4=c4+grid(i,k+30)/30.
        c5=c5+grid(i,k+40)/30.
      enddo
c== have anomalies wrt WMO
      kt=0
      do it=31,40  !31=1961; 40=1970
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c1
      enddo
      do it=41,50  !41=1971; 50=1980
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c2
      enddo
      do it=51,60  !51=1981; 60=1990
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c3
      enddo
      do it=61,70  !61=1991; 70=2000
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c4
      enddo
      do it=71,71  !71=2001
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c5
      enddo
      enddo  !loop for imax
      return
      end


