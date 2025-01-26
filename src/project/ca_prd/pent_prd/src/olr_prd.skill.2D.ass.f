      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(nrunalpha=0)! 0: read in ; 1: run alpha
      parameter(iseason=0)! 0: winter; 1: summer;
      parameter(ngrd=imp*jmp)
      parameter(ims=1,ime=imp)   ! grid to have skill
      parameter(npp=nps-5)       ! max pentads to be predicted
      parameter(ntt=nseason*nps,nhs=(nseason-1)*(npp))
      dimension ts1(npp*nseason),ts2(npp*nseason),ts3(npp*nseason)
      dimension ts4(ntt),ts5(ntt)
      dimension tsout(npp),tsout2(5)
      dimension ac1d(6,nseason,npp),ac1d2(6,nseason,npp)
      dimension rms1d(6,nseason,npp),rms1d2(6,nseason,npp)
      dimension rms_pc(6,modemax),corr_pc(6,modemax)
      dimension fldin(imin,jmin),fldin2(imin,jmin)
      dimension fldful(imax,jmax)
      dimension xlat(jmp),fldp(imp,jmp)
      dimension alpha(nhs),corr(imp,jmp)
      dimension alpha3d(nhs,npp,nseason)
      dimension obs(imp,jmp),obs2(imp,jmp),prd(imp,jmp)
      dimension wk2d(imp,jmp),wk2d2(imp,jmp)
      dimension fld2d(imp,jmp),fld4d(imp,jmp,nps,nseason)
      dimension fld4d2(imp,jmp,nps,nseason)
      dimension fld4d3(imp,jmp,nps,nseason)
      dimension tgt4d(imp,jmp,npp,nseason)
      dimension clim(imp,jmp,nps),aaa(ngrd,ntt)
      dimension efld3d(modemax,nps,nseason)
      dimension efld3d2(modemax,nps,nseason)
      dimension etgt3d(modemax,npp,nseason)
      dimension    WK(ntt,ngrd)
      dimension    ana(modemax,nhs+1),anac(modemax)
      dimension    eval(ntt),evec(ngrd,ntt),pc(ntt,ntt)
      dimension    eof(modemax,imp,jmp),cosl(jmp)
C
C
      open(unit=11,form='unformatted',access='direct',recl=4*imin*jmin) !input raw olr
c
      open(unit=60,form='unformatted',access='direct',recl=4*imp*jmp) !CA_data
      open(unit=61,form='unformatted',access='direct',recl=4*imp*jmp) !ld1_prd
      open(unit=62,form='unformatted',access='direct',recl=4*imp*jmp) !ld2_prd
      open(unit=63,form='unformatted',access='direct',recl=4*imp*jmp) !ld3_prd
      open(unit=64,form='unformatted',access='direct',recl=4*imp*jmp) !ld4_prd
      open(unit=65,form='unformatted',access='direct',recl=4*imp*jmp) !ld5_prd
c     open(unit=66,form='unformatted',access='direct',recl=4*imp*jmp) !ld6_prd
c
      open(unit=70,form='unformatted',access='direct',recl=4*imp*jmp) !unified EOFs for proj use
      open(unit=75,form='unformatted',access='direct',recl=4*nhs)  !alpha
      open(unit=76,form='unformatted',access='direct',recl=4*npp)  !1D_skill
      open(unit=77,form='unformatted',access='direct',recl=4*5)!PC ac & rms
      open(unit=80,form='unformatted',access='direct',recl=4*imp*jmp) !2D_skill
c*************************************************
c*************************************************
c*
      do j=1,jmp
      xlat(j)=-30+(j-1)*5
      enddo
c
      PI=4.*atan(1.)
      CONV=PI/180.
      DO j=1,jmp
        COSL(j)=COS(xlat(j)*CONV)
      END DO
      fak=1.
      ridge=0.05
c 
C*********************************************
c* read in data and save the tropics
      iu=11
      iu2=12
      ndkp=36  !increment
      if (iseason.eq.0) then   ! for winter season
      kps=61  
      else                     ! for summer season
      kps=24  
      end if
      irec=0
      DO is=1,nseason          ! number of seasons used to for CA
        np=0
        do it=kps+1,kps+ndkp  
        irec=irec+1
        np=np+1
          read(iu,rec=it) fldin
c         read(iu2,rec=it) fldin3
            do j=1,jmp
            do i=1,imp
              fld4d(i,j,np,is)=fldin(i,j+12)   !+12 for trop(30S-30N) data
              fld4d2(i,j,np,is)=fldin(i,j+12)
              if(abs(fldin(i,j+12)).gt.999) then
                write(6,*) 'undef in is=',is,'np=',np,'i,j=',i,j
                fld4d(i,j,np,is)=0.
                fld4d2(i,j,np,is)=0.
              endif
            enddo
            enddo
        enddo
      kps=kps+73
      write(6,*) 'it=',kps
c
      write(6,*) 'time length of data =',irec
      ENDDO
c     go to 888
c
      IF (nruneof.eq.1) THEN
c* input data for EOF analysis
      it=0
      do is=1,nseason
      do ip=1,nps
      it=it+1
        id=0
        do j=1,jmp
        do i=1,imp
          id=id+1
          aaa(id,it)=fld4d(i,j,ip,is)*sqrt(COSL(j))
        end do
        end do
      enddo
      enddo
      write(6,*) 'length of input data to EOF calculation=',it
c       
c     call eofs_4_ca(aaa,ngrd,ntt,ntt,eval,evec,pc,wk,0)
      call eofs_4_ca(aaa,ngrd,ntt,ngrd,eval,evec,pc,wk,0)
c
      write(6,*)'eval='
      write(6,400) eval
 400  format(6f8.4)
c     go to 888
c
c* have 2D EOF 
c
        do nm=1,modemax
        ng=0
        do j=1,jmp
        do i=1,imp
          ng=ng+1
          eof(nm,i,j)=evec(ng,nm)
        end do
        end do
        end do
c
c* standardize spatial patterns to unity****
c
        do m1=1,modemax

        call inprod1(imp,jmp,modemax,eof,cosl,m1,m1,anorm)
c       write(6,*)m1,anorm
        do i=1,imp
        do j=1,jmp
          eof(m1,i,j)=eof(m1,i,j)/sqrt(anorm)
        end do
        end do

        do i=1,imp
        do j=1,jmp
c         fld2d(i,j)=eof(m1,i,jmp-j+1) !"yrev" for use by other purpose
          fld2d(i,j)=eof(m1,i,j) !"yrev" for use by other purpose
        end do
        end do
        write(70,rec=m1) fld2d ! write out EOFs
        enddo  !loop for m1

        ELSE
        do m1=1,modemax
        read(70,rec=m1) fld2d
          do i=1,imp
          do j=1,jmp
            eof(m1,i,j)=fld2d(i,j)
          end do
          end do
        enddo
      ENDIF
c       go to 888
c
C* project grid data onto EOFs*******
c
        do is=1,nseason
        do ip=1,nps
        call f4d_2_f2d(imp,jmp,nps,nseason,ip,is,fld2d,fld4d)
        do nmode=1,modemax
          call inprod4(eof,fld2d,imp,jmp,cosl,nmode,modemax,anorm)
          efld3d(nmode,ip,is)=anorm
        enddo
        enddo
        enddo 
c
        do is=1,nseason
        do ip=1,nps
        call f4d_2_f2d(imp,jmp,nps,nseason,ip,is,fld2d,fld4d2)
        do nmode=1,modemax
          call inprod4(eof,fld2d,imp,jmp,cosl,nmode,modemax,anorm)
          efld3d2(nmode,ip,is)=anorm
        enddo
        enddo
        enddo 
  
C* olr resolved by EOFs
c
      it=0
      do is=1,nseason
      do ip=1,nps
        it=it+1
        do j=1,jmp
        do i=1,imp
          fld2d(i,j)=0.0
c         do im=1,modemax
          do im=1,mm_sk
            fld2d(i,j)=fld2d(i,j)+eof(im,i,j)*efld3d(im,ip,is)
          end do
          fld4d3(i,j,ip,is)=fld2d(i,j)
        end do
        end do
      end do
      end do
c
c* cross validated CA prd begins
c
      iout=0
      DO ldpen=1,6  !1:IC; 2:0 pent lead; 3: 1pent lead; ...

      DO ntgts=1,nseason      !loop over target season
      DO ntgtp=1,npp          !loop over target pentad
        it=0
        do is=1,nseason       !loop for the non-target winter
        if(is.eq.ntgts) go to 555
          do ip=1,npp
            it=it+1
            do nmode=1,modemax
              ana(nmode,it)=efld3d(nmode,ip+ldpen-1,is)
            enddo
          enddo
 555    continue
        enddo             !loop for the non-target winter

        IF(ldpen.gt.1) go to 222

        do nmode=1,modemax
        ana(nmode,nhs+1)=efld3d2(nmode,ntgtp,ntgts)
        enddo

        call getalpha(ana,alpha,modemax,nhs,fak,ridge)

        do k=1,nhs
        alpha3d(k,ntgtp,ntgts)=alpha(k)
        enddo
 
        alpha2=0
        do k=1,nhs
        alpha2=alpha2+alpha(k)*alpha(k)
        enddo
        write(6,*) 'alpha2=',alpha2

 222    continue

        do nmode=1,modemax
        etgt3d(nmode,ntgtp,ntgts)=0.
        enddo
     
        do nmode=1,modemax
        do ntime=1,nhs
        etgt3d(nmode,ntgtp,ntgts)=etgt3d(nmode,ntgtp,ntgts)+
     &           ana(nmode,ntime)*alpha3d(ntime,ntgtp,ntgts)
        enddo
        enddo

      ENDDO  !loop over target pentad
      ENDDO  !loop over target season

c
c* PC to grid for constructed data
c
      DO is=1,nseason      
      DO ip=1,npp  

        do i=1,imp
        do j=1,jmp
          tgt4d(i,j,ip,is)=0.
        do nmode=1,modemax
          tgt4d(i,j,ip,is)=tgt4d(i,j,ip,is)+
     &          etgt3d(nmode,ip,is)*eof(nmode,i,j)
        enddo
        enddo
        enddo

       ENDDO
       ENDDO

c* spatial corr
       np=0
       DO is=1,nseason
       DO ip=1,npp
       np=np+1
         do i=1,imp
         do j=1,jmp
           obs(i,j)=fld4d(i,j,ip+ldpen-1,is)
           obs2(i,j)=fld4d3(i,j,ipldpen-1,is) !EOF resolved olr
           prd(i,j)=tgt4d(i,j,ip,is)
         enddo
         enddo
c* write out prd
         write(59+ldpen,rec=np) prd
c
      call rmsd1(obs,prd,imp,jmp,ims,ime,cosl,
     &rms1d(ldpen,is,ip),ac1d(ldpen,is,ip))
      call rmsd1(obs2,prd,imp,jmp,ims,ime,cosl,
     &rms1d2(ldpen,is,ip),ac1d2(ldpen,is,ip))
c
       ENDDO
       ENDDO
       write(6,*) 'ldpen=',ldpen,'  number of prd write out=',np
c
c* temporal corr for grids
c
      do i=1,imp
      do j=1,jmp
        it=1
        do is=1,nseason
        do ip=1,npp
          ts1(it)=fld4d(i,j,ip+ldpen-1,is)
          ts2(it)=tgt4d(i,j,ip,is)
          ts3(it)=fld4d3(i,j,ip+ldpen-1,is)  !olr resolved by EOFs
        it=it+1
        enddo
        enddo
        call corr_1d(nseason*npp,ts1,ts2,fld2d(i,j))
        call corr_1d(nseason*npp,ts3,ts2,obs2(i,j))
        call rms_1d(nseason*npp,ts1,ts2,wk2d(i,j))
        call rms_1d(nseason*npp,ts3,ts2,wk2d2(i,j))
      enddo
      enddo
      iout=iout+1
      write(80,rec=iout) fld2d
      iout=iout+1
      write(80,rec=iout) obs2
      iout=iout+1
      write(80,rec=iout) wk2d
      iout=iout+1
      write(80,rec=iout) wk2d2
c
c* temporal corr & rms for PC1 and PC2
c
      do nm=1,modemax
        it=0
        do is=1,nseason
        do ip=1,npp
        it=it+1
          ts1(it)=efld3d(nm,ip+ldpen-1,is)
          ts2(it)=etgt3d(nm,ip,is)
        enddo
        enddo
        call corr_1d(nseason*npp,ts1,ts2,corr_pc(ldpen,nm))
        call rms_1d(nseason*npp,ts1,ts2,rms_pc(ldpen,nm))
C* have stdv of PC1&2
      nsp=nseason*npp
      std1=0.
      std2=0.
      do it=1,nsp
      std1=std1+ts1(it)*ts1(it)
      std2=std2+ts2(it)*ts2(it)
      enddo
      std1=sqrt(std1/float(nsp))
      std2=sqrt(std2/float(nsp))
c
        llead=ldpen-1
        write(6,*) 'PC',nm,'std1=',std1,'std2=',std2
      enddo  !loop for mode
      ENDDO  !loop for ldpen
c
c write out ac1d and rms1d
c
       iwo=0
       do is=1,nseason
         do ldpen=1,6
           do ip=1,npp
           tsout(ip)=ac1d(ldpen,is,ip)
           end do
           iwo=iwo+1
           write(76,rec=iwo) tsout
         end do
         do ldpen=1,6
           do ip=1,npp
           tsout(ip)=ac1d2(ldpen,is,ip)
           end do
           iwo=iwo+1
           write(76,rec=iwo) tsout
         end do
         do ldpen=1,6
           do ip=1,npp
           tsout(ip)=rms1d(ldpen,is,ip)
           end do
           iwo=iwo+1
           write(76,rec=iwo) tsout
         end do
         do ldpen=1,6
           do ip=1,npp
           tsout(ip)=rms1d2(ldpen,is,ip)
           end do
           iwo=iwo+1
           write(76,rec=iwo) tsout
         end do
       end do
c
c* write out corr and rms for PCs
       iwo=0
       do nm=1,modemax
         do ldpen=1,5
           tsout2(ldpen)=corr_pc(ldpen+1,nm)
         end do
         iwo=iwo+1
         write(77,rec=iwo) tsout2
         write(6,110)'PC',nm,'COR=',tsout2
         do ldpen=1,5
           tsout2(ldpen)=rms_pc(ldpen+1,nm)
         end do
         iwo=iwo+1
         write(77,rec=iwo) tsout2
         write(6,110)'PC',nm,'  RMS=',tsout2
       end do
c
C*********************************************
100    format(9f7.2/9f7.2)
110    format(A2,I2,A6,5f8.2)
      write(6,*) 'end of excution'
 888  continue
      STOP
      END
c*
      subroutine ca_prd_grd(iu,ntt,ntgt,nhs,im,jm,alpha,obs,prd)
      dimension wk(im,jm),fld3d(im,jm,nhs)
      dimension obs(im,jm),prd(im,jm),alpha(nhs)
      id=0
      do nt=1,ntt !have historical given month data for constructing prd
          read(iu,rec=nt) wk
          if(nt.eq.ntgt) go to 666
          if(nt.eq.ntgt-1) go to 666
          if(nt.eq.ntgt+1) go to 666
          id=id+1
          do i=1,im
          do j=1,jm
            fld3d(i,j,id)=wk(i,j)
          enddo
          enddo
 666      continue
      enddo
        call anom_clim(im,jm,nhs,nhs,fld3d,wk)
        read(iu,rec=ntgt) obs
        do i=1,im
        do j=1,jm
          obs(i,j)=obs(i,j)-wk(i,j)
        enddo
        enddo
c
        do i=1,im
        do j=1,jm
          prd(i,j)=0.0 
        enddo
        enddo
      do nt=1,nhs
        do i=1,im
        do j=1,jm
          prd(i,j)=prd(i,j)+fld3d(i,j,nt)*alpha(nt)
        enddo
        enddo
      enddo
      return
      end
c*
c
      subroutine normal_1d(nt,ts)
      dimension ts(nt)
        x=0
        do i=1,nt
          x=x+ts(i)*ts(i)
        end do
        x=sqrt(x/float(nt))
        do i=1,nt
          ts(i)=ts(i)/x
        end do

      return
      end
c
      subroutine fill_mis(im,jm,fld1,fld2,undf)
      dimension fld1(im,jm),fld2(im,jm)
        do i=1,im
        do j=1,jm
          if(abs(fld1(i,j)).gt.undf) then
          fld2(i,j)=0.
          else
          fld2(i,j)=fld1(i,j)
          endif
        enddo
        enddo
      return
      end
c*
      subroutine f3d_2_f2d(im,jm,ntt,ntgt,fld2d,fld3d)
      dimension fld3d(im,jm,ntt),fld2d(im,jm)
        do i=1,im
        do j=1,jm
          fld2d(i,j)=fld3d(i,j,ntgt)
        enddo
        enddo
      return
      end
c*
      subroutine f4d_2_f2d(im,jm,nps,nseason,ip,iw,fld2d,fld4d)
      dimension fld4d(im,jm,nps,nseason),fld2d(im,jm)
        do i=1,im
        do j=1,jm
          fld2d(i,j)=fld4d(i,j,ip,iw)
        enddo
        enddo
      return
      end
c*
      subroutine f2d_2_f3d(im,jm,ntt,ntgt,fld2d,fld3d)
      dimension fld3d(im,jm,ntt),fld2d(im,jm)
        do i=1,im
        do j=1,jm
          fld3d(i,j,ntgt)=fld2d(i,j)
        enddo
        enddo
      return
      end
c*
      subroutine anom_clim(im,jm,ntt,nys,fld3d,fld2d)
      dimension fld3d(im,jm,ntt),fld2d(im,jm)
        do i=1,im
        do j=1,jm
          fld2d(i,j)=0.
        enddo
        enddo
        do it=1,nys
        do i=1,im
        do j=1,jm
        fld2d(i,j)=fld2d(i,j)+fld3d(i,j,it)/float(nys)
        enddo
        enddo
        enddo
        do it=1,nys
        do i=1,im
        do j=1,jm
        fld3d(i,j,it)=fld3d(i,j,it)-fld2d(i,j)
        enddo
        enddo
        enddo
      return
      end
c*
      function cov(ana,nisb,n,ib1,ib2,fak)
      dimension ana(nisb,n+1)
      z=0.
      do is=1,nisb
      ax=ana(is,ib1)/fak
      ay=ana(is,ib2)/fak
      z=z+(ay*ax)
      enddo
c     cov=z/float(nisb)
      cov=z
101   format(1h ,3f7.2,3i4)
      return
      end
c*
      subroutine rms_1d(n,ts1,ts2,rms)
      dimension ts1(n),ts2(n)
      x=0.
      do it=1,n
      x=x+(ts1(it)-ts2(it))*(ts1(it)-ts2(it))
      enddo
      rms=sqrt(x/float(n))
      return
      end
c*
      subroutine corr_1d(n,ts1,ts2,corr)
      dimension ts1(n),ts2(n)
      x=0.
      y=0.
      xy=0.
      do it=1,n
      x=x+ts1(it)*ts1(it)/float(n)
      y=y+ts2(it)*ts2(it)/float(n)
      xy=xy+ts1(it)*ts2(it)/float(n)
      enddo
      corr=xy/(sqrt(x)*sqrt(y))
      return
      end
c*
      subroutine regr_1d(n,ts1,ts2,corr)
      dimension ts1(n),ts2(n)
      x=0.
      y=0.
      xy=0.
      do it=1,n
      x=x+ts1(it)*ts1(it)/float(n)
      y=y+ts2(it)*ts2(it)/float(n)
      xy=xy+ts1(it)*ts2(it)/float(n)
      enddo
      corr=xy/sqrt(x)
      return
      end
c
      subroutine corr_2d(im,jm,n,obs,prd,corr)
      dimension obs(im,jm,n),prd(im,jm,n)
      dimension corr(im,jm)
      do i=1,im
      do j=1,jm
      x=0.
      y=0.
      xy=0.
      do it=1,n
      x=x+obs(i,j,it)*obs(i,j,it)/float(n)
      y=y+prd(i,j,it)*prd(i,j,it)/float(n)
      xy=xy+obs(i,j,it)*prd(i,j,it)/float(n)
      enddo
      corr(i,j)=xy/(sqrt(x)*sqrt(y))
      enddo
      enddo
c     write(6,101) corr
101   format(1h ,10f7.2)
      return
      end
*
      subroutine inprod1(im,jm,modemax,e,cosl,m1,m2,anorm)
c* inner product in space among eofs of length n
      dimension e(modemax,im,jm)
      dimension cosl(jm)
      x=0.
      do i=1,im
      do j=1,jm
      x=x+e(m1,i,j)*e(m2,i,j)*cosl(j)
      enddo
      enddo
      anorm=x
      return
      end
c
      subroutine inprod4(e,academic,im,jm,cosl,m1,modemax,anorm)
c* inner product in space among one eof and an academic anomaly
      dimension e(modemax,im,jm),academic(im,jm)
      dimension cosl(jm)
      x=0.
      y=0.
      do i=1,im
      do j=1,jm
      cosw=cosl(j)
      x=x+e(m1,i,j)*academic(i,j)*cosw
      y=y+e(m1,i,j)*e(m1,i,j)*cosw
      enddo
      enddo
c     write(6,100)m1,x/y
      anorm=x/y
100   format(1h ,'ip4= ',i5,3f10.6)
      return
      end
c
      subroutine rmsd1(anom,anomp,im,jm,ims,ime,cosl,z1,zc)
      dimension anomp(im,jm),anom(im,jm)
      dimension cosl(jm)
      x=0.
      y=0.
      z=0.
      zc=0.
      w=0.
      do i=ims,ime
c     do i=1,im
      do j=1,jm
      cosw=cosl(j)
      w=w+cosw
      x=x+anom(i,j)*anom(i,j)*cosw
      y=y+anomp(i,j)*anomp(i,j)*cosw
      z=z+(anomp(i,j)-anom(i,j))*(anomp(i,j)-anom(i,j))*cosw
      zc=zc+anomp(i,j)*anom(i,j)*cosw
      enddo
      enddo
      x1=sqrt(x/w)
      y1=sqrt(y/w)
      z1=sqrt(z/w)
      zc=zc/w/(x1*y1)
c     write(6,100)x,y,z,w,ns
c* add average diffs
      x=0.
      y=0.
      z=0.
      w=0.
      do i=ims,ime
c     do i=1,im
      do j=1,jm
      cosw=cosl(j)
      w=w+cosw
      x=x+anom(i,j)*cosw
      y=y+anomp(i,j)*cosw
      z=z+(anom(i,j)-anomp(i,j))*cosw
      enddo
      enddo
      x=x/w
      y=y/w
      z=z/w
      write(6,100)x1,y1,z1,zc,x,y,z,w
100   format('stats grid rms/ave:',8f7.2,i5)
200   format(1h ,'stats grid ave:',4f7.2,i5)
      return
      end
c
      subroutine getalpha(ana,alpha,modemax,n,fak,ridge)
      dimension ana(modemax,n+1),alpha(n)
      real*8 a(n,n),b(n),aiv(n,n)
      do i=1,n
      do j=1,n
       a(i,j)=0.
       b(j)=0.
      enddo
      enddo
      ax=0.
      do ib1=1,n
      b(ib1)=cov(ana,modemax,n,ib1,n+1,fak)
      do ib2=ib1,n
      a(ib1,ib2)=cov(ana,modemax,n,ib1,ib2,fak)
      a(ib2,ib1)=a(ib1,ib2)
      enddo
      enddo
      d=0.
      do ib1=1,n
      d=d+a(ib1,ib1)/float(n)
      enddo
      do ib1=1,n
       a(ib1,ib1)=a(ib1,ib1)+d*ridge
      enddo
       call mtrx_inv(a,aiv,n,n)
       call solutn(aiv,b,alpha,n)
      return
      end
c
      SUBROUTINE solutn(ff,vf,beta,m)
      real*8 ff(m,m),vf(m)
      real beta(m)

      do i=1,m
         beta(i)=0.
      do j=1,m
         beta(i)=beta(i)+ff(i,j)*vf(j)
      end do
      end do

      return
      end
c*
c*
      subroutine weinalys(alpha,nt,sa,sasq,sabs,qeven,qodd,decadal)
      dimension alpha(nt),decadal(10)
c* analysis of nt (66) weights;
C* sa=sum of weights, sasq=sum of squares of weights, sabs=sum of abs values of weights.
C* qeven is sum of weights for even years (32,34 etc)
C* qodd is sum of weights for odd years (33,35 etc)
c* decadal(1) contains sums over 1st 10 years (32-41)
c* decadal(2) contains sums over 2nd 10 years (42-51), etc
      x=0.
      u=0.
      y=0.
      z=0.
C* sum of weights, forward and backwards
      do ntime=1,nt
      ntimer=nt-ntime+1
      x=x+alpha(ntime)
      u=u+alpha(ntimer)
      y=y+alpha(ntime)*alpha(ntime)
      z=z+abs(alpha(ntime))
c     write(6,100)ntime+1931,x,ntimer+1931,u
      enddo
c     write(6,111)x,y,z
      sa=x
      sasq=y
      sabs=z
      x=0.
      u=0.
      y=0.
      z=0.
C* sum of weights, forward and backwards, for odd/even years
      do ntime=1,nt,2
      ntimer=nt-ntime+1
      x=x+alpha(ntime)
      u=u+alpha(ntimer)
      y=y+alpha(ntime)*alpha(ntime)
      z=z+abs(alpha(ntime))
c     write(6,100)ntime+1931,x,ntimer+1931,u
      enddo
      qodd=u
      qeven=sa-u
c     write(6,111)x,y,z
      x=0.
      u=0.
      y=0.
      z=0.
C* sum of weights, forward and backwards, for odd/even years
      do ntime=2,nt,2
      ntimer=nt-ntime+1
      x=x+alpha(ntime)
      u=u+alpha(ntimer)
      y=y+alpha(ntime)*alpha(ntime)
      z=z+abs(alpha(ntime))
c     write(6,100)ntime+1931,x,ntimer+1931,u
      enddo
c     write(6,111)x,y,z
      do j=1,9
      ntime=(j-1)*10+1
      x=0.
      do i=0,9
      nti=ntime+i
      if (nti.le.nt) x=x+alpha(nti)
      enddo
c     write(6,101)ntime+1931,ntime+1940,x
      decadal(j)=x
      enddo
111   format(1h ,' sum, sumsqr sumabs: ',14f7.2)
100   format(1h ,'qb',i5,f7.2,i5,f7.2)
101   format(1h ,'decadal',2i5,f7.2)
      return
      end
c
      subroutine prout(alpha,jeartarget,m,mf,ntt,iout)
      dimension alpha(ntt),decadal(10),hulp(10)
      dimension alphaprint(100)
      do i=1,100
      alphaprint(i)=-999999999999.
      enddo
      do i=1,ntt
      alphaprint(i)=alpha(i)
      enddo
      call weinalys(alpha,ntt,x,y,z,qeven,qodd,decadal)
      do i=1,10
      hulp(i)=-999999999999.
      enddo
      hulp(1)=x
      hulp(2)=y
      hulp(3)=z
      hulp(4)=qeven
      hulp(5)=qodd
      hulp(6)=qodd-qeven
       write(iout,102)m,mf,jeartarget+1930,ntt
       do ntime=1,10
       if (ntt.eq.90) then
       write(iout,112)ntime+1960, alphaprint(ntime)
     *           ,ntime+1970, alphaprint(ntime+10)
     *           ,ntime+1980, alphaprint(ntime+20)
     *           ,ntime+1960, alphaprint(ntime+30)
     *           ,ntime+1970, alphaprint(ntime+40)
     *           ,ntime+1980, alphaprint(ntime+50)
     *           ,ntime+1960, alphaprint(ntime+60)
     *           ,ntime+1970, alphaprint(ntime+70)
     *           ,ntime+1980, alphaprint(ntime+80),hulp(ntime)
       endif
c      write(iout,212)ntime+1979, alphaprint(ntime)
c    *           ,ntime+1989, alphaprint(ntime+10)
c    *           ,ntime+1979, alphaprint(ntime+20)!1980-99 choice
c    *           ,ntime+1989, alphaprint(ntime+30)
c    *           ,ntime+1979, alphaprint(ntime+40)
c    *           ,ntime+1989, alphaprint(ntime+50),hulp(ntime)
c      write(iout,212)ntime+1970, alphaprint(ntime)
c    *           ,ntime+1980, alphaprint(ntime+10)
c    *           ,ntime+1970, alphaprint(ntime+20)!1971-90 choice
c    *           ,ntime+1980, alphaprint(ntime+30)
c    *           ,ntime+1970, alphaprint(ntime+40)
c    *           ,ntime+1980, alphaprint(ntime+50),hulp(ntime)
c      write(iout,212)ntime+1950, alphaprint(ntime)
c    *           ,ntime+1960, alphaprint(ntime+10)
c    *           ,ntime+1950, alphaprint(ntime+20)!1951-70 choice
c    *           ,ntime+1960, alphaprint(ntime+30)
c    *           ,ntime+1950, alphaprint(ntime+40)
c    *           ,ntime+1960, alphaprint(ntime+50),hulp(ntime)
       enddo
c      write(iout,103)
       write(iout,113)(decadal(j),j=1,9)!choice 61-90
c      write(iout,113)(decadal(j),j=1,6)!choice
c      write(iout,103)
c      write(iout,103)
c      write(iout,103)
102   format(4i6)
103   format()
112   format(9(i6,f7.2),1x,f8.2)
212   format(6(i6,f7.2),1x,f8.2)
113   format(9(6x,f7.2))
      return
      end
c*

C       ================================================================
        subroutine  mtrx_inv( x, xinv, n,max_npc)
C       ================================================================

        implicit none

C-----------------------------------------------------------------------
C                             INCLUDE FILES
C-----------------------------------------------------------------------
c
c #include  "reg_parm"
        integer max_nchan
        parameter(max_nchan = 2378) !MAXIMUM # OF ALLOWED REGRESSION CHANNELS

        integer max_nsamp
        parameter(max_nsamp = 600) ! MAXIMUM TRAINING SAMPLE SIZE OR THE MAXIMUM #
                                    ! OF OBSERVATIONS TO WHICH COEFFICENTS ARE APPLIED

        integer max_npc
c       parameter(max_npc =21) ! maximum # of principal components
c       parameter(max_npc =46) ! maximum # of principal components
c
C-----------------------------------------------------------------------
C                              ARGUMENTS
C-----------------------------------------------------------------------

        real*8    x ( max_npc, max_npc )
        real*8    xinv ( max_npc, max_npc )
        integer   n

C-----------------------------------------------------------------------
C                            LOCAL VARIABLES
C-----------------------------------------------------------------------

        integer   i
        integer   ii
        integer   im
        integer   ip
        integer   j
        integer   jm
        integer   jp
        integer   k
        integer   l
        integer   nm
        real*8    s ( max_npc, max_npc )
        real*8    a ( max_npc, max_npc )
        real*8    sum

C***********************************************************************
C***********************************************************************
C                            EXECUTABLE CODE
C***********************************************************************
C***********************************************************************

C-----------------------------------------------------------------------
C     [ Major comment blocks set off by rows of dashes. ]
C-----------------------------------------------------------------------

C
C    CONVERT 'X' TO A DOUBLE PRECISION WORK ARRAY.
      do 10 i=1,n
      do 10 j=1,n
c      a(i,j)=dble(x(i,j))
      a(i,j)=x(i,j)
   10 continue
      s(1,1)=1.0/a(1,1)
c    just inverting a scalar if n=1.
      if(n-1)20,180,30
   20 return
   30 do 40 j=2,n
      s(1,j)=a(1,j)
   40 continue
      do 70 i=2,n
      im=i-1
      do 60 j=i,n
      sum=0.0
      do 50 l=1,im
      sum=sum+s(l,i)*s(l,j)*s(l,l)
   50 continue
      s(i,j)=a(i,j)-sum
   60 continue
      s(i,i)=1.0/s(i,i)
   70 continue
      do 80 i=2,n
      im=i-1
      do 80 j=1,im
   80 s(i,j)=0.0
      nm=n-1
      do 90 ii=1,nm
      im=n-ii
      i=im+1
      do 90 j=1,im
      sum=s(j,i)*s(j,j)
      do 90 k=i,n
      s(k,j)=s(k,j)-s(k,i)*sum
   90 continue
      do 120 j=2,n
      jm=j-1
      jp=j+1
      do 120 i=1,jm
      s(i,j)=s(j,i)
      if(jp-n)100,100,120
  100 do 110 k=jp,n
      s(i,j)=s(i,j)+s(k,i)*s(k,j)/s(k,k)
  110 continue
  120 continue
      do 160 i=1,n
      ip=i+1
      sum=s(i,i)
      if(ip-n)130,130,150
  130 do 140 k=ip,n
      sum=sum+s(k,i)*s(k,i)/s(k,k)
  140 continue
  150 s(i,i)=sum
  160 continue
      do 170 i=1,n
      do 170 j=i,n
      s(j,i)=s(i,j)
  170 continue
c    retrieve output array 'xinv' from the double precession work array.
  180 do 190 i=1,n
      do 190 j=1,n
c      xinv(i,j)=sngl(s(i,j))
      xinv(i,j)=s(i,j)
  190 continue
      return
      end
