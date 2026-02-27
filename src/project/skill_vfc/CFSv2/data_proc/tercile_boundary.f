      program haveanom
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C To have anom with respect to 81-04 clim and determine the border for anb
C===========================================================)
      real fld4d(imx,jmx,nesm,ltime),fld4d2(imx,jmx,mmx,ltime)
      real fld1(imx,jmx),fld2(imx,jmx)
      real fld3(imx,jmx),fld4(imx,jmx)
      real clim(imx,jmx,12,nesm)
      real abov(imx,jmx,12)
      real bord(imx,jmx,12,2)
      real anom(imx,jmx,mmx,12,nyr)
      real f1d1(nyr*mmx),f1d2(nyr*mmx)
      real rdx(nyr*mmx)
c
      open(10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(21,form='unformatted',access='direct',recl=4*imx*jmx)
      open(22,form='unformatted',access='direct',recl=4*imx*jmx)
      open(23,form='unformatted',access='direct',recl=4*imx*jmx)
c
c== read in esm mean data for having clim
      ir=0
      do im=1,ltime
      do ig=1,nesm
      ir=ir+1
        read(10,rec=ir) fld1
        do i=1,imx
        do j=1,jmx
        fld4d(i,j,ig,im)=fld1(i,j)
        enddo
        enddo
      enddo
      enddo
c- calculate clim
      do i=1,imx
      do j=1,jmx
c
      do ig=1,nesm
      do im=1,12
        clim(i,j,im,ig)=0.
        do it=im,ltime,12
          clim(i,j,im,ig)=clim(i,j,im,ig)+fld4d(i,j,ig,it)/float(nyr)
        enddo
      enddo
      enddo
c
      enddo
      enddo
c
c== read in in data and have anom for them
c
c read in ind data
      ir=0
      DO iy=1,nyr 
      DO im=1,12

      do ie=1,4  !group 1
      ir=ir+1
        read(11,rec=ir) fld1
        do i=1,imx
        do j=1,jmx
          anom(i,j,ie,im,iy)=fld1(i,j)-clim(i,j,im,1)
        enddo
        enddo
      enddo

      do ie=5,8  !group 2
      ir=ir+1
        read(11,rec=ir) fld1
        do i=1,imx
        do j=1,jmx
          anom(i,j,ie,im,iy)=fld1(i,j)-clim(i,j,im,2)
        enddo
        enddo
      enddo

      do ie=9,12  !group 3
      ir=ir+1
        read(11,rec=ir) fld1
        do i=1,imx
        do j=1,jmx
          anom(i,j,ie,im,iy)=fld1(i,j)-clim(i,j,im,3)
        enddo
        enddo
      enddo

      do ie=13,16  !group 4
      ir=ir+1
        read(11,rec=ir) fld1
        do i=1,imx
        do j=1,jmx
          anom(i,j,ie,im,iy)=fld1(i,j)-clim(i,j,im,3)
        enddo
        enddo
      enddo

      do ie=17,20  !group 5
      ir=ir+1
        read(11,rec=ir) fld1
        do i=1,imx
        do j=1,jmx
          anom(i,j,ie,im,iy)=fld1(i,j)-clim(i,j,im,3)
        enddo
        enddo
      enddo

      ENDDO
      ENDDO
C
c= write out clim
c
      ir=0
      DO im=1,12
      DO ie=1,nesm !nesm=5
      ir=ir+1
        do i=1,imx
        do j=1,jmx
          fld3(i,j)=clim(i,j,im,ie)
        enddo
        enddo
        write(20,rec=ir) fld3
      ENDDO
      ENDDO
C
c= write out anom from jfm1982-dec2009
c
      ir=0
      DO iy=1,nyr !82-09: 28 yrs
      DO im=1,12
      DO ie=1,mmx !mmx=20 ensemble member number
      ir=ir+1
        do i=1,imx
        do j=1,jmx
          fld3(i,j)=anom(i,j,ie,im,iy)
        enddo
        enddo
        write(21,rec=ir) fld3
      ENDDO
      ENDDO
      ENDDO
C
c= write out anom from jfm1995-dec2009
c
      ir=0
      iys=13+1  
      DO iy=iys,nyr !95-09: 15 yrs
      DO im=1,12
      DO ie=1,mmx !mmx=20 ensemble member number
      ir=ir+1
        do i=1,imx
        do j=1,jmx
          fld3(i,j)=anom(i,j,ie,im,iy)
        enddo
        enddo
        write(22,rec=ir) fld3
      ENDDO
      ENDDO
      ENDDO
c
c rank seasonal data and find out the borders of normal
c
      do i=1,imx
      do j=1,jmx
      do im=1,12 
        ir=0
        do iy=1,nyr
        do ie=1,mmx
        ir=ir+1
        rdx(ir)=ir
        f1d1(ir)=anom(i,j,ie,im,iy)
        enddo
        enddo
C
        nye=nyr*mmx
        call hpsort(nye,nye,f1d1,rdx)
c
        if(i.eq.100.and.j.eq.47) then
        write(6,444) f1d1
        end if
  444 format(10f7.2)
c
        bord(i,j,im,1)=f1d1(373)   !total 20*28=560
        bord(i,j,im,2)=f1d1(187)
      enddo
      enddo
      enddo
c write out border
      iw=0
      do im=1,12
        do i=1,imx
        do j=1,jmx
          fld1(i,j)=bord(i,j,im,1)
          fld2(i,j)=bord(i,j,im,2)
        enddo
        enddo
          iw=iw+1
          write(23,rec=iw) fld1
          iw=iw+1
          write(23,rec=iw) fld2
      enddo

      stop
      END

      SUBROUTINE hpsort(n,n2,ra,rb)
      INTEGER n,n2
      REAL ra(n),rb(n)
      INTEGER i,ir,j,l
      REAL rra
      if (n2.lt.2) return
      l=n2/2+1
      ir=n2
10    continue
        if(l.gt.1)then
          l=l-1
          rra=ra(l)
          rrb=rb(l)
        else
          rra=ra(ir)
          rrb=rb(ir)
          ra(ir)=ra(1)
          rb(ir)=rb(1)
          ir=ir-1
          if(ir.eq.1)then
            ra(1)=rra
            rb(1)=rrb
            return
          endif
        endif
        i=l
        j=l+l
20      if(j.le.ir)then
          if(j.lt.ir)then
            if(ra(j).lt.ra(j+1))j=j+1
          endif
          if(rra.lt.ra(j))then
            ra(i)=ra(j)
            rb(i)=rb(j)
            i=j
            j=j+j
          else
            j=ir+1
          endif
        goto 20
        endif
        ra(i)=rra
        rb(i)=rrb
      goto 10
      END



