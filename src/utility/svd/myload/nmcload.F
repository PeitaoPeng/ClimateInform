      subroutine load(h,nd,iuin,iuout)
#include "parm.h"
      dimension h(nmax,nmon,nyr),b(73,29)
      integer iinc(7),istrt(7),lon1(3),lon2(3)
      data iinc/2,2,2,2,2,4,8/
      data istrt/1,2,1,2,1,3,1/ 
      data lon1/1,20,56/,lon2/72,55,19/
      print *,'loading from unit=',iuin,' . write to unit=',iuout
      read(78,'(i2,1x,i2,1x,i2,1x,i1)') mbeg,mavg,ireg,isst
      print *,'monbeg=',mbeg,'  monavg=',mavg,' iregion=',ireg,
     * ' isst=',isst

      if(ireg.gt.3) then
        print *,'problem in load....iregion=',ireg
        stop
      endif
      lonb=lon1(ireg)
      lone=lon2(ireg)
      if(lone.lt.lonb) lone=lone+72
      print *,'load data from i=',lonb,' to ',lone

      rewind iuin
c skip 1947 jan,feb,mar
      do 10 isk=1,3
          read(iuin) b
   10 continue
c winter 1948-1983
      ny=0
      do 100 iyr=1948,1983
        ny=ny+1
        do 100 im=1,5
          print *,'loading iyr,im=',iyr,im
          read(iuin) b
          icount=0
          nj=0
c j from 1 to 25, not to 29 since don't want to use pole point
          do 80 j=1,25,4
            nj=nj+1
            inc=iinc(nj)
            iis=lonb+istrt(nj)-1
            iie=lone
c           print *,'in j loop...j=',j,' nj=',nj,' inc=',inc,' iis=',iis
            do 80 ii=iis,iie,inc
              i=ii
              if(i.gt.72) i=i-72
              icount=icount+1
c             print *,'in i loop, i=',i,' icount=',icount,' b=',b(i,j)
              h(icount,im,ny)=b(i,j)
   80     continue
          write(iuout) b
  100 continue
      nd=icount
      rewind iuin
      rewind iuout
      return
      end
