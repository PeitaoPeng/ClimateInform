      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C write out nino34 index of CA SST forecast
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
      dimension f2d(imx,jmx),f2d2(imx,jmx)
      dimension w4do(nld,nyr,imx,jmx)
      dimension ac4d(nld,nesm,imx,jmx)
      dimension w5d(nld,nyr,nesm,imx,jmx)
      real wtd(imx,jmx,nld,3),wts(imx,jmx,nld,nesm,3)
      real ts0(nyr),ts1(nyr),ts2(nyr)
      real ts3(nyr),ts4(nyr),ts5(nyr)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      real w2d4(imx,jmx),w2d5(imx,jmx),w2d6(imx,jmx)
      real vfld(imx,jmx,nyr)
      real wtfcst(imx,jmx,nyr,4,nld)
      real avgo(imx,jmx,nld),avgf(imx,jmx,4,nld)
      real stdo(imx,jmx,nld),stdf(imx,jmx,4,nld)
      real aaveo(nld),aavef(4,nld)
      real cor(imx,jmx),rms(imx,jmx)
      real cor2(imx,jmx),rms2(imx,jmx)
      real cor3(imx,jmx),rms3(imx,jmx)
      real cor4(imx,jmx),rms4(imx,jmx)
C
      do iu=ius1,iue1
      open(unit=iu,form='unformatted',access='direct',recl=4*imx*jmx) 
      enddo
      do iu=ius2,iue2
      open(unit=iu,form='unformatted',access='direct',recl=4*imx*jmx) 
      enddo
c
      open(unit=91,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=92,form='unformatted',access='direct',recl=4*imx*jmx)
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
      im=0
      do iu=ius1,iue1
      im=im+1
c
      do iy=1,nyr
      do ld=1,nld
c
c== read fcst
      irec=(iy-1)*2*nld+ld*2
      read(iu,rec=irec) f2d
      do i=1,imx
      do j=1,jmx
        w5d(ld,iy,im,i,j)=f2d(i,j)
      enddo
      enddo
c== read obs
      irec2=irec-1
      read(iu,rec=irec2) f2d2
      do i=1,imx
      do j=1,jmx
        w4do(ld,iy,i,j)=f2d2(i,j)
      enddo
      enddo
c
      enddo  ! ld
      enddo  ! iy
      enddo  ! iu
c
cc read in ac
      im=0
      do iu=ius2,iue2
      im=im+1
c
      do ld=1,nld

      irec=(ld-1)*4+3
      read(iu,rec=irec) f2d
      do i=1,imx
      do j=1,jmx
        ac4d(ld,im,i,j)=f2d(i,j)
      enddo
      enddo
c
      enddo  ! ld
      enddo  ! iu
c
C for weighted fcst
      do ld=1,nld ! lead of weighted fcst
C== have denominator of the weights

      do i=1,imx
      do j=1,jmx
        if(f2d(i,j).gt.-900) then
          wtd(i,j,ld,1)=0
          wtd(i,j,ld,2)=0
          wtd(i,j,ld,3)=0
          do m=1,nesm
            if(ac4d(ld,m,i,j).gt.0.) then
              wtd(i,j,ld,1)=wtd(i,j,ld,1)+ac4d(ld,m,i,j)
              wtd(i,j,ld,3)=wtd(i,j,ld,3)+ac4d(ld,m,i,j)**2
            else
              wtd(i,j,ld,1)=wtd(i,j,ld,1)+0.
              wtd(i,j,ld,3)=wtd(i,j,ld,3)+0.
            endif
              wtd(i,j,ld,2)=wtd(i,j,ld,2)+ac4d(ld,m,i,j)**2
          enddo
        else
        wtd(i,j,ld,1)=undef
        wtd(i,j,ld,2)=undef
        wtd(i,j,ld,3)=undef
        endif
      enddo
      enddo
      C
C== have weights for each lead and member
      do m=1,nesm
        do i=1,imx
        do j=1,jmx
          if(f2d(i,j).gt.-900) then
            if(ac4d(ld,m,i,j).gt.0.) then
              wts(i,j,ld,m,1)=ac4d(ld,m,i,j)/wtd(i,j,ld,1)
              wts(i,j,ld,m,2)=ac4d(ld,m,i,j)**2/wtd(i,j,ld,2)
              wts(i,j,ld,m,3)=ac4d(ld,m,i,j)**2/wtd(i,j,ld,3)
            else
              wts(i,j,ld,m,1)=0.
              wts(i,j,ld,m,2)=-ac4d(ld,m,i,j)**2/wtd(i,j,ld,2)
              wts(i,j,ld,m,3)=0.
            endif
          else
            wts(i,j,ld,m,1)=undef
            wts(i,j,ld,m,2)=undef
            wts(i,j,ld,m,3)=undef
          endif
        enddo
        enddo
      enddo
C
C== have ensemble forecast
      do it=1,nyr
        do i=1,imx
        do j=1,jmx
          if(f2d(i,j).gt.-900) then
            w2d(i,j)=0.
            w2d2(i,j)=0.
            w2d3(i,j)=0.
            w2d4(i,j)=0.
            w2d5(i,j)=w4do(ld,it,i,j)
            do m=1,nesm
            w2d(i,j)=w2d(i,j)+w5d(ld,it,m,i,j)/float(nesm)
            w2d2(i,j)=w2d2(i,j)+wts(i,j,ilead,1)*w5d(ld,it,m,i,j)
            w2d3(i,j)=w2d3(i,j)+wts(i,j,ilead,2)*w5d(ld,it,m,i,j)
            w2d4(i,j)=w2d4(i,j)+wts(i,j,ilead,3)*w5d(ld,it,m,i,j)
            enddo
          else
            w2d(i,j)=undef
            w2d2(i,j)=undef
            w2d3(i,j)=undef
            w2d4(i,j)=undef
            w2d5(i,j)=undef
          endif
          wtfcst(i,j,it,1,ld)=w2d(i,j)
          wtfcst(i,j,it,2,ld)=w2d2(i,j)
          wtfcst(i,j,it,3,ld)=w2d3(i,j)
          wtfcst(i,j,it,4,ld)=w2d4(i,j)
      enddo ! it loop

      enddo ! ld loop

      c
c amplitude adjustment for obs
c
c std of obs
      do ld=1,nld

        do i=1,imx
        do j=1,jmx
          if (w4do(1,1,i,j).gt.-900) then
            avgo(i,j,ld)=0.
            do it=1,nyr
            avgo(i,j,ld)=avgo(i,j,ld)+w4do(ld,it,i,j)
            enddo
          else
            avgo(i,j,ld)=undef
          endif
        enddo
        enddo

        do i=1,imx
        do j=1,jmx
          if (w4do(1,1,i,j).gt.-900.) then
            stdo(i,j,ld)=0.
            do it=1,nyr
            stdo(i,j,ld)=stdo(i,j,ld)+
     &      (w4do(ld,it,i,j)-avgo(i,j,ld))**2
            enddo
            stdo(i,j,ld)=sqrt(stdo(i,j,ld)/float(nyr))
          else
            stdo(i,j,ld)=undef
          endif
        enddo
        enddo
      enddo ! loop ld

c std of wtfcst
        do i=1,imx
        do j=1,jmx
        do iv=1,4
        do ld=1,nld
          if (wtfcst(i,j,1,1,1).gt.-900.) then
            avgf(i,j,iv,ld)=0.
            do it=1,nyr
            avgf(i,j,iv,ld)=avgf(i,j,iv,ld)+wtfcst(i,j,it,iv,ld)
            enddo
          else
            avgf(i,j,iv,ld)=undef
          endif
        enddo
        enddo
        enddo
        enddo

        do i=1,imx
        do j=1,jmx
        do iv=1,4
        do ld=1,nld
          if (wtfcst(i,j,1,1,1).gt.-900.) then
            stdf(i,j,iv,ld)=0.
            do it=1,nyr
            stdf(i,j,iv,ld)=stdf(i,j,iv,ld)+
     &      (wtfcst(i,j,it,iv,ld)-avgf(i,j,iv,ld))**2
            enddo
            stdf(i,j,iv,ld)=sqrt(stdf(i,j,iv,ld)/float(nyr))
          else
            stdf(i,j,iv,ld)=undef
          endif
        enddo
        enddo
        enddo
        enddo
c
c area averaged std
      do ld=1,nld
        area=0.
        aaveo(ld)=0.
        do i=1,imx
        do j=1,jmx
          if(w4do(1,1,i,j).gt.-900.) then
          area=area+coslat(j)
          aaveo(ld)=aaveo(ld)+coslat(j)*stdo(i,j,ld)
          endif
        enddo
        enddo
        aaveo(ld)=aaveo(ld)/area
      enddo ! ld loop
c
      do iv=1,4
      do ld=1,nld
        aavef(iv,ld)=0.
        do i=1,imx
        do j=1,jmx
          if(vfld(i,j,1).gt.-900.) then
          aavef(iv,ld)=aavef(iv,ld)+coslat(j)*stdf(i,j,iv,ld)
          endif
        enddo
        enddo
          aavef(iv,ld)=aavef(iv,ld)/area
      enddo
      enddo
      write(6,*) 'aaveo std=',aaveo
      write(6,*) 'aavef std=',aavef
c
c amplitude adjstment
      do i=1,imx
      do j=1,jmx
      do iv=1,4
      do ld=1,nld
      if (wtfcst(i,j,1,1,1).gt.-900.) then
        do it=1,nyr
        wtfcst(i,j,it,iv,ld)=wtfcst(i,j,it,iv,ld)
     &*aaveo(ld)/aavef(iv,ld)
        enddo
        else
        wtfcst(i,j,it,iv,ld)=undef
        endif
      enddo
      enddo
      enddo
      enddo
      c
c write out obs and wtfcst
        iw=0
        do it=1,nyr
        do ld=1,nld

           do i=1,imx
           do j=1,jmx
             w2d(i,j)=w4do(ld,it,i,j)
           enddo
           enddo
           iw=iw+1
           write(91,rec=iw) w2d
c       do iv=1,4
c only write out iv=4
           do i=1,imx
           do j=1,jmx
             w2d(i,j)=wtfcst(i,j,it,4,ld)
           enddo
           enddo
           iw=iw+1
           write(91,rec=iw) w2d
c       enddo

      enddo ! ld ldop
      enddo ! it loop
      c
c== skill calculation
      iw4=0
      DO ld=1,nld

      DO i=1,imx
      DO j=1,jmx
c
      if(f2d(i,j).gt.-900.) then
        do it=1,nyr
          ts0(it)=w4do(ld,it,i,j)
          ts1(it)=wtfcst(i,j,it,1,ld)
          ts2(it)=wtfcst(i,j,it,2,ld)
          ts3(it)=wtfcst(i,j,it,3,ld)
          ts4(it)=wtfcst(i,j,it,4,ld)
        enddo
        call cor_rms(ts0,ts1,nyr,nyr,cor(i,j),rms(i,j))
        call cor_rms(ts0,ts2,nyr,nyr,cor2(i,j),rms2(i,j))
        call cor_rms(ts0,ts3,nyr,nyr,cor3(i,j),rms3(i,j))
        call cor_rms(ts0,ts4,nyr,nyr,cor4(i,j),rms4(i,j))
      else
        cor(i,j)=undef
        rms(i,j)=undef
        cor2(i,j)=undef
        rms2(i,j)=undef
        cor3(i,j)=undef
        rms3(i,j)=undef
        cor4(i,j)=undef
        rms4(i,j)=undef
      endif

      enddo
      enddo

      iw4=iw4+1
      write(92,rec=iw4) cor
      iw4=iw4+1
      write(92,rec=iw4) rms
      iw4=iw4+1
      write(92,rec=iw4) cor2
      iw4=iw4+1
      write(92,rec=iw4) rms2
      iw4=iw4+1
      write(92,rec=iw4) cor3
      iw4=iw4+1
      write(92,rec=iw4) rms3
      iw4=iw4+1
      write(92,rec=iw4) cor4
      iw4=iw4+1
      write(92,rec=iw4) rms4
      
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

