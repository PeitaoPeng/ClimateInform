      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for t2m,. prec, hgt
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
      parameter(ntt=nseason)
c
      dimension fldin(ims,jms)
      dimension xlat(jms)
      dimension cosl(jms)
      dimension alpha2(ntt)
C
      dimension alltpz(ims,jms,12+26,nyear)
      dimension tpz4d(ims,jms,nps,nseason)
      dimension tpz4d2(ims,jms,nps,nseason)
      dimension tpzana2(ims,jms,ntt)
      dimension tpzprd(ims,jms,mldp),tpz2d(ims,jms)
      dimension prdtpz(ims,jms)
C
      open(unit=10,form='unformatted',access='direct',recl=4*nseason)  
      open(unit=11,form='unformatted',access='direct',recl=4*ims*jms) !input pre/temp/hgt
      open(unit=85,form='unformatted',access='direct',recl=4*ims*jms) !real forecast
c*************************************************
c
      PI=4.*atan(1.)
      CONV=PI/180.
      undef1=-9.99E+8
      undef2=-9.99E+33
c
      do j=1,jms
      xlat(j)=-89.5+(j-1)*1.0
      enddo
c
      DO j=1,jms
        cosl(j)=COS(xlat(j)*CONV)
      END DO
c
      fak=1.
      ridge=0.01
c
cc read in all historical sst
c
      read(10,rec=1) alpha2

      iu1=11
c
      it=0
      DO iy=1,nyear
      Do iw=1,12
      it=it+1
      itr=it  ! take from jfm1948
        read(iu1,rec=itr) fldin
c
        do j=1,jms
        do i=1,ims
        alltpz(i,j,iw+nwextb,iy)=fldin(i,j)
        enddo
        enddo
c
      Enddo
      Enddo
c
cc fill in the extended parts of data arrays
c
      DO iy=2,nyear-2

c  for ext in the beginning
       Do iw=1,nwextb
c
        do j=1,jms
        do i=1,ims
        alltpz(i,j,iw,iy)=alltpz(i,j,12+iw,iy-1)
        enddo
        enddo

       Enddo
c
c  for ext in the end
        Do iw=1,12
c
        do j=1,jms
        do i=1,ims
        alltpz(i,j,12+nwextb+iw,iy)=alltpz(i,j,nwextb+iw,iy+1)
        enddo
        enddo
c
        Enddo
c
        next2=nwexte-12
        Do iw=1,next2
c
        do j=1,jms
        do i=1,ims
        alltpz(i,j,12+nwextb+12+iw,iy)=alltpz(i,j,nwextb+iw,iy+2)
        enddo
        enddo
c
        Enddo
       Enddo
c
      iws=itgtm 
      iwe=itgtm+nps-1

      irec=0
      is=0
      DO iy=2,nyear        ! number of years used for EOF
      is=is+1
        np=0
        do iw=iws,iwe  
        irec=irec+1
        np=np+1
c  have whole field for later CA use
          do j=1,jms
          do i=1,ims
            tpz4d2(i,j,np,is)=alltpz(i,j,nwextb+iw,iy)  
          enddo
          enddo
        enddo
c
      enddo
c     write(6,*) 'time length of data =',irec
c
c* realtime forecast
c
      DO ldpen=1,mldp  !1:IC; 2:0 mon1; 3: mon2; 4: mon3; 5: mon4; 6: mon5 ...
        it=0
        do is=1,nseason       !loop for the non-target winter
c
            it=it+1

            do i=1,ims
            do j=1,jms
              tpzana2(i,j,it)=tpz4d2(i,j,ldpen,is)
            enddo
            enddo
        enddo  
c
c     write(6,*) 'alpha2=',alpha2
 
c construct
        do i=1,ims
        do j=1,jms
        tpz2d(i,j)=0.
        enddo
        enddo
c
        do i=1,ims
        do j=1,jms
c
        if(abs(tpz4d2(i,j,1,nseason)).lt.999) then
        do ntime=1,ntt
        tpz2d(i,j)=tpz2d(i,j)+
     &           tpzana2(i,j,ntime)*alpha2(ntime)
        enddo
        else
        tpz2d(i,j)=undef1
        endif
c
        enddo
        enddo
c
         do i=1,ims
         do j=1,jms
           tpzprd(i,j,ldpen)=tpz2d(i,j)
         enddo
         enddo
c
      ENDDO  !loop for ldpen

c write out real time prd
      iwr1=0
      DO ldpen=1,mldp
      do i=1,ims
      do j=1,jms
        prdtpz(i,j)=tpzprd(i,j,ldpen)
      enddo
      enddo
      iwr1=iwr1+1
      write(85,rec=iwr1) prdtpz

      ENDDO  !loop for ldpen
c
C
C*********************************************
100    format(10f7.2)
110    format(A2,I2,A6,6f8.2)
      write(6,*) 'end of excution'
 888  continue
1000  continue
c
      STOP
      END
