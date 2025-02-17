      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C write out nino34 index of CA SST forecast
CCCCCCCCCCCdimension f2d(imx,jmx),f2d2(imx,jmx)
      dimension f2d(imx,jmx),f2d2(imx,jmx)
      dimension w4do(nld,nyr,imx,jmx)
      dimension w5d(nld,nyr,nesm,imx,jmx)

      real fcst1(imx,jmx,nyr,nld,nmod)
      real fcst2(imx,jmx,nyr,nld,nics)
      real fcst3(imx,jmx,nyr,nld)
      real ts0(nyr),ts1(nyr),ts2(nyr)

      real xlat(jmx),coslat(jmx),cosr(jmx)
      real w2d(imx,jmx),w2d2(imx,jmx)
      real cor(imx,jmx),rms(imx,jmx)
C
      do iu=ius1,iue1
      open(unit=iu,form='unformatted',access='direct',recl=4*imx*jmx) 
      enddo
c
      open(unit=91,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=92,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=93,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=94,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=95,form='unformatted',access='direct',recl=4*imx*jmx)
c************************************************
c
C== have coslat
C
      do j=1,jmx
        xlat(j)=-89.5+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))
      enddo
c
cc read in fcst
c
      m=0
      do iu=ius1,iue1
      m=m+1
c
      do iy=1,nyr
      do ld=1,nldin
c
c== read fcst
      irec=(iy-1)*2*nldin+ld*2
      read(iu,rec=irec) f2d
c== read obs
      irec2=irec-1
      read(iu,rec=irec2) f2d2

      if(ld.le.4.or.ld.gt.11) go to 555

      do i=1,imx
      do j=1,jmx
        w5d(ld-4,iy,m,i,j)=f2d(i,j)
      enddo
      enddo
c
      do i=1,imx
      do j=1,jmx
        w4do(ld-4,iy,i,j)=f2d2(i,j)
      enddo
      enddo

 555  continue
      write(6,*) 'm=',m,'iy=',iy,'ld=',ld
      enddo  ! ld
      enddo  ! iy

      enddo  ! iu

C
C== have ensemble hcst for each nmod
      do n=1,nmod
      do it=1,nyr
      do ld=1,nld
c     write(6,*) 'it=',it,'ld=',ld

        do i=1,imx
        do j=1,jmx
        IF(f2d(i,j).gt.-900) then
            w2d(i,j)=0.
            do m=n,nesm,nmod
              w2d(i,j)=w2d(i,j)+w5d(ld,it,m,i,j)/float(nics)
            enddo
        ELSE
            w2d(i,j)=undef
        ENDIF
          fcst1(i,j,it,ld,n)=w2d(i,j)
        enddo
        enddo

      enddo ! ld loop
      enddo ! it loop
      enddo ! ics loop
C
C== have ensemble hcst for different ics
      n=0
      do ic=1,nesm,nmod
      mend=ic+nmod-1
      n=n+1
      do it=1,nyr
      do ld=1,nld

        do i=1,imx
        do j=1,jmx
        IF(f2d(i,j).gt.-900) then
            w2d(i,j)=0.
            do m=ic,mend
              w2d(i,j)=w2d(i,j)+w5d(ld,it,m,i,j)/float(nmod)
            enddo
        ELSE
            w2d(i,j)=undef
        ENDIF
          fcst2(i,j,it,ld,n)=w2d(i,j)
        enddo
        enddo

      enddo ! ld loop
      enddo ! it loop
      enddo ! ics loop

C== have ensemble hcst for ALL members
      do it=1,nyr
      do ld=1,nld

        do i=1,imx
        do j=1,jmx
        IF(f2d(i,j).gt.-900) then
            w2d(i,j)=0.
            do m=1,nesm
              w2d(i,j)=w2d(i,j)+w5d(ld,it,m,i,j)/float(nesm)
            enddo
        ELSE
            w2d(i,j)=undef
        ENDIF
          fcst3(i,j,it,ld)=w2d(i,j)
        enddo
        enddo

      enddo ! ld loop
      enddo ! it loop
c
c write out obs and fcst1
        iw=0
        do n=1,nmod
        do it=1,nyr
        do ld=1,nld

           do i=1,imx
           do j=1,jmx
             w2d(i,j)=w4do(ld,it,i,j)
           enddo
           enddo
           iw=iw+1
           write(91,rec=iw) w2d
c
           do i=1,imx
           do j=1,jmx
            w2d(i,j)=fcst1(i,j,it,ld,n)
           enddo
           enddo
           iw=iw+1
           write(91,rec=iw) w2d

      enddo ! ld ldop
      enddo ! it loop
      enddo ! ics ldop
c
c write out obs and fcst2
        iw=0
        do ic=1,nics
        do it=1,nyr
        do ld=1,nld

           do i=1,imx
           do j=1,jmx
             w2d(i,j)=w4do(ld,it,i,j)
           enddo
           enddo
           iw=iw+1
           write(92,rec=iw) w2d
c
           do i=1,imx
           do j=1,jmx
            w2d(i,j)=fcst2(i,j,it,ld,ic)
           enddo
           enddo
           iw=iw+1
           write(92,rec=iw) w2d

      enddo ! ld ldop
      enddo ! it loop
      enddo ! ics ldop
c
c== skill calculation for fcst1
      iw2=0
      DO ld=1,nld
      do n=1,nmod

      DO i=1,imx
      DO j=1,jmx
c
      if(f2d(i,j).gt.-900.) then
        do it=1,nyr
          ts0(it)=w4do(ld,it,i,j)
          ts1(it)=fcst1(i,j,it,ld,n)
        enddo
        call cor_rms(ts0,ts1,nyr,nyr,cor(i,j),rms(i,j))
      else
        cor(i,j)=undef
        rms(i,j)=undef
      endif

      enddo
      enddo

      iw2=iw2+1
      write(93,rec=iw2) cor

      enddo ! ics loop
      enddo ! ld loop
c
c== skill calculation for fcst2
      iw2=0
      DO ld=1,nld
      do ic=1,nics

      DO i=1,imx
      DO j=1,jmx
c
      if(f2d(i,j).gt.-900.) then
        do it=1,nyr
          ts0(it)=w4do(ld,it,i,j)
          ts1(it)=fcst2(i,j,it,ld,ic)
        enddo
        call cor_rms(ts0,ts1,nyr,nyr,cor(i,j),rms(i,j))
      else
        cor(i,j)=undef
        rms(i,j)=undef
      endif

      enddo
      enddo

      iw2=iw2+1
      write(94,rec=iw2) cor

      enddo ! ics loop
      enddo ! ld loop
c
c== skill calculation for fcst3
      iw2=0
      DO ld=1,nld

      DO i=1,imx
      DO j=1,jmx
c
      if(f2d(i,j).gt.-900.) then
        do it=1,nyr
          ts0(it)=w4do(ld,it,i,j)
          ts1(it)=fcst3(i,j,it,ld)
        enddo
        call cor_rms(ts0,ts1,nyr,nyr,cor(i,j),rms(i,j))
      else
        cor(i,j)=undef
        rms(i,j)=undef
      endif

      enddo
      enddo

      iw2=iw2+1
      write(95,rec=iw2) cor

      enddo ! ld loop

      STOP
      END

      SUBROUTINE cor_rms(f1,f2,nt,ltime,cor,rms)

      real f1(nt),f2(nt)

      av1=0.
      av2=0.
      do it=1,ltime
c        av1=av1+f1(it)/float(ltime)
c        av2=av2+f2(it)/float(ltime)
      enddo

      cor=0.
      sd1=0.
      sd2=0.
      rms=0.

      do it=1,ltime
         cor=cor+(f1(it)-av1)*(f2(it)-av2)/float(ltime)
         sd1=sd1+(f1(it)-av1)**2/float(ltime)
         sd2=sd2+(f2(it)-av2)**2/float(ltime)
         rms=rms+(f1(it)-f2(it))**2/float(ltime)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)
      rms=sqrt(rms)

      return
      end

