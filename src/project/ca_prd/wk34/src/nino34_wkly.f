      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(imts=77,imte=97)  ! 190E-240E
      parameter(jmts=35,jmte=39)   ! 5S-5N
c
      parameter(npp=nps-4)       ! max weeks to be predicted
      dimension tsout(npp)
      dimension xsst(6,nseason,npp)
      dimension fldin(imt,jmt)
      dimension fld4d(imt,jmt,nps,nseason)
C
      dimension    xlat(jmt),cosl(jmt)
      dimension    obs(imt,jmt)
C
C
      open(unit=11,form='unformatted',access='direct',recl=4*imt*jmt) !input sst
c
      open(unit=81,form='unformatted',access='direct',recl=4*npp)  !nino34
c*************************************************
c
      PI=4.*atan(1.)
      CONV=PI/180.

      do j=1,jmt
      xlat(j)=-90+(j-1)*2.5
      enddo
      DO j=1,jmt
        cosl(j)=COS(xlat(j)*CONV)
      END DO
c
C*********************************************
c* read in data
      iu=11
c
      if (iseason.eq.1) then  ! for spring, ICs in mid-Feb to end-May
      kps=8
      endif
      if(iseason.eq.2) then  ! for summe, ICs in mid-May to end-Aug
      kps=20
      end if
      if(iseason.eq.3) then  ! for fall, ICs in mid-Aug to end-Nov
      kps=33
      end if
      if(iseason.eq.4) then  !for winter, ICs in mid-Nov to end-Feb
      kps=46
      end if
c
      irec=0
      DO is=1,nseason          ! number of seasons used to for CA
        np=0
        do it=kps,kps+nps-1  
        irec=irec+1
        np=np+1
          read(iu,rec=it) fldin
            do j=1,jmt
            do i=1,imt
              fld4d(i,j,np,is)=fldin(i,j)  
            enddo
            enddo
        enddo
      write(6,*) 'it=',kps
      kps=kps+52
c
      write(6,*) 'time length of data =',irec
      ENDDO
c
      DO ldpen=1,6  !1:IC; 2:0 wk1; 3: wk2; 4: wk3; 5: wk4; 6: wk34

       np=0
       DO is=1,nseason
       DO ip=1,npp
       np=np+1
         do i=1,imt
         do j=1,jmt
           obs(i,j)=fld4d(i,j,ip+ldpen-1,is)
           if(ldpen.eq.6) then
           obs(i,j)=0.5*(fld4d(i,j,ip+ldpen-2,is)+
     &fld4d(i,j,ip+ldpen-1,is))
           endif
         enddo
         enddo
c
      call ave_2d(obs,imt,jmt,imts,imte,jmts,jmte,xsst(ldpen,is,ip))
c
       ENDDO
       ENDDO
       write(6,*) 'ldwk=',ldpen,'  number of prd write out=',np
c
      ENDDO  !loop for ldpen
c
c write out nino34
c
       iwo=0
       do is=1,nseason
         do ldpen=1,6
           do ip=1,npp
           tsout(ip)=xsst(ldpen,is,ip)
           end do
           iwo=iwo+1
           write(81,rec=iwo) tsout
           write(6,*) 'tsout=',tsout
         end do
       end do
       write(6,*) 'iwo=',iwo
C*********************************************
100    format(9f7.2/9f7.2)
110    format(A2,I2,A6,6f8.2)
      write(6,*) 'end of excution'
 888  continue
      STOP
      END
c*
      subroutine ave_2d(wk,im,jm,is,ie,js,je,out)
      dimension wk(im,jm)
      out=0.
      xn=float((ie-is+1)*(je-js+1))
      do i=is,ie
      do j=js,je
      out=out+wk(i,j)/xn
      enddo
      enddo
      return
      end
