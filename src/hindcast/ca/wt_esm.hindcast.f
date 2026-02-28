      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C write out nino34 index of CA SST forecast
CCCCCCCCCCCdimension f2d(imx,jmx),f2d2(imx,jmx)
      dimension f2d(imx,jmx),f2d2(imx,jmx)
      dimension w4do(nld,nyr,imx,jmx)
      dimension w5d(nld,nyr,nesm,imx,jmx)

      real ac(imx,jmx,nyr,nld,nesm)
      real wtd(imx,jmx,nyr,nld),wts(imx,jmx,nyr,nld,nesm)
      real wtfcst(imx,jmx,nyr,nld)
      real ts0(nyr),ts1(nyr),ts2(nyr)

      real xlat(jmx),coslat(jmx),cosr(jmx)
      real w2d(imx,jmx),w2d2(imx,jmx)
      real avgo(imx,jmx,nld),avgf(imx,jmx,nld)
      real stdo(imx,jmx,nld),stdf(imx,jmx,nld)
      real cor(imx,jmx),rms(imx,jmx)
C
      do iu=ius1,iue1
      open(unit=iu,form='unformatted',access='direct',recl=4*imx*jmx) 
      enddo
c
      open(unit=91,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=92,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=93,form='unformatted',access='direct',recl=4*imx*jmx)
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

C CV AC skill
c==temporal ac skill for hcst of ld and members
      do m=1,nesm

      DO ld=1,nld ! lead of weighted fcst

      do itgt=1,nyr

      DO i=1,imx
      DO j=1,jmx
c

      IF(f2d(i,j).gt.-900.) then

        ir=0
        do iy=1,nyr

          if(iy.eq.itgt) go to 777

          ir=ir+1
            ts1(ir)=w4do(ld,iy,i,j)
            ts2(ir)=w5d(ld,iy,m,i,j)
  777   continue
        enddo

        call cor_rms(ts1,ts2,nyr,ir,ac(i,j,itgt,ld,m),xrms)

      ELSE
        ac(i,j,itgt,ld,m)=undef
      ENDIF

      ENDDO
      ENDDO

c     write(6,*) 'm=',m,'ld=',ld,'itgt=',itgt
      enddo  ! itgt loop

      ENDDO ! ld loop

      ENDDO ! m loop

C== have denominator of the weights
      DO ld=1,nld
      DO it=1,nyr

      do i=1,imx
      do j=1,jmx

        if(f2d(i,j).gt.-900) then
          wtd(i,j,it,ld)=0
          do m=1,nesm
            wtd(i,j,it,ld)=wtd(i,j,it,ld)+ac(i,j,it,ld,m)**2
          enddo
        else
        wtd(i,j,it,ld)=undef
        endif

        if(abs(wtd(i,j,it,ld)).lt.0.01) then
          wtd(i,j,it,ld)=0.01
        endif

      enddo
      enddo

c     write(6,*) 'ld=',ld,'it=',it
      enddo ! lt loop
      enddo ! ld loop
C
C== have weights for each lead
      write(6,*) 'start calculate wts'
c     go to 666
      DO m=1,nesm
      DO it=1,nyr
        do ld=1,nld
c       write(6,*) 'm=',m,'it=',it,'ld=',ld

        do i=1,imx
        do j=1,jmx
        IF(f2d(i,j).gt.-900) then
            if(ac(i,j,it,ld,m).gt.0.) then
              wts(i,j,it,ld,m)=ac(i,j,it,ld,m)**2/wtd(i,j,it,ld)
            else
c             wts(i,j,it,ld,m)=-ac(i,j,it,ld,m)**2/wtd(i,j,it,ld)
              wts(i,j,it,ld,m)=0.
            endif
        ELSE
              wts(i,j,it,ld,m)=undef
        ENDIF
        enddo
        enddo

        enddo ! ld  loopo
      ENDDO ! it loopo
      ENDDO ! m loopo
 666  continue
C
C== have ensemble hcst
      write(6,*) 'start weighted ensemble mean'
      do it=1,nyr
      do ld=1,nld
c     write(6,*) 'it=',it,'ld=',ld

        do i=1,imx
        do j=1,jmx
        IF(f2d(i,j).gt.-900) then
            w2d(i,j)=0.
            do m=1,nesm
              if(iweight.eq.1) then
              w2d(i,j)=w2d(i,j)+wts(i,j,it,ld,m)*w5d(ld,it,m,i,j)
              else
              w2d(i,j)=w2d(i,j)+w5d(ld,it,m,i,j)/float(nesm)
              endif
            enddo
        ELSE
            w2d(i,j)=undef
        ENDIF
          wtfcst(i,j,it,ld)=w2d(i,j)
        enddo
        enddo

      enddo ! ld loop
      enddo ! it loop

      write(6,*) 'start amplitude adjustment for obs'
c amplitude adjustment for obs
c
c std of obs
      do ld=1,nld

        do i=1,imx
        do j=1,jmx
          if (f2d(i,j).gt.-900.) then
            avgo(i,j,ld)=0.
            do it=1,nyr
            avgo(i,j,ld)=avgo(i,j,ld)+w4do(ld,it,i,j)/float(nyr)
            enddo
          else
            avgo(i,j,ld)=undef
          endif
        enddo
        enddo

        do i=1,imx
        do j=1,jmx
          if (f2d(i,j).gt.-900.) then
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
        do ld=1,nld
        do i=1,imx
        do j=1,jmx
          if (f2d(i,j).gt.-900.) then
            avgf(i,j,ld)=0.
            do it=1,nyr
            avgf(i,j,ld)=avgf(i,j,ld)+wtfcst(i,j,it,ld)/
     &float(nyr)
            enddo
          else
            avgf(i,j,ld)=undef
          endif
        enddo
        enddo
        enddo

        do ld=1,nld
        do i=1,imx
        do j=1,jmx
          if (f2d(i,j).gt.-900.) then
            stdf(i,j,ld)=0.
            do it=1,nyr
            stdf(i,j,ld)=stdf(i,j,ld)+
     &      (wtfcst(i,j,it,ld)-avgf(i,j,ld))**2
            enddo
            stdf(i,j,ld)=sqrt(stdf(i,j,ld)/float(nyr))
          else
            stdf(i,j,ld)=undef
          endif
        enddo
        enddo
        enddo
c
c amplitude adjstment
      do i=1,imx
      do j=1,jmx
      do ld=1,nld
      if (f2d(i,j).gt.-900.) then
        do it=1,nyr
        wtfcst(i,j,it,ld)=wtfcst(i,j,it,ld)
c    &*aaveo(ld)/aavef(ld)
        enddo
        else
        wtfcst(i,j,it,ld)=undef
        endif
      enddo
      enddo
      enddo
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
c
           do i=1,imx
           do j=1,jmx
            w2d(i,j)=wtfcst(i,j,it,ld)
           enddo
           enddo
           iw=iw+1
           write(91,rec=iw) w2d

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
          ts1(it)=wtfcst(i,j,it,ld)
        enddo
        call cor_rms(ts0,ts1,nyr,nyr,cor(i,j),rms(i,j))
      else
        cor(i,j)=undef
        rms(i,j)=undef
      endif

      enddo
      enddo

      iw4=iw4+1
      write(92,rec=iw4) cor
      iw4=iw4+1
      write(92,rec=iw4) rms

      enddo ! ld loop

      iw2=0
      do n=1,nesm

      do i=1,imx
      do j=1,jmx
        f2d(i,j)= ac(i,j,40,5,n)
        f2d2(i,j)=wts(i,j,40,5,n)
      enddo
      enddo

      iw2=iw2+1
      write(93,rec=iw2) f2d
      iw2=iw2+1
      write(93,rec=iw2) f2d2

      enddo
c
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

