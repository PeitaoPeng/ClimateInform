C==========================================================
C  OCN obtained with dependent data
C==========================================================
      include "parm.h"
      real obs(imax),out(imax)
      real fld2d(imax,nmon)
      real fld2d2(imax,nmon)
      real clm(imax,12)
c
      open(unit=10,form='formatted')
      open(unit=60,form='unformatted',access='direct',recl=4*imax)

c== read in 102CD data (1931-cur)
      do it=1,nmon
        read(10,888) obs
 888  format(10f7.1)
        do i=1,imax
          fld2d(i,it)=obs(i)
        enddo
      enddo
c have climate
      do i=1,imax
      do itc=1,12
      clm(i,itc)=0.
      do it=itc,nmon-5,12
        clm(i,itc)=clm(i,itc)+fld2d(i,it)/float(nyr)
      enddo
      enddo
      enddo
c have anom
      do i=1,imax
      do itc=1,12
      do it=itc,nmon,12
        fld2d2(i,it)=fld2d(i,it)-clm(i,itc)
      write(6,*)'it=',it
      enddo
      enddo
      enddo
c
c== have runing mean
c
      iw=0
      do it=2,nmon-1
c
      do im=1,imax
        out(im)=(fld2d2(im,it-1)+fld2d2(im,it)+fld2d2(im,it+1))/3.
      enddo
c
      iw=iw+1
      write(60,rec=iw) out
      write(6,*)'iw=',iw

      enddo
      
      stop
      end
        
