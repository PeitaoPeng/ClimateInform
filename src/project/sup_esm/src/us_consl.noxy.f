      program regression
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. regression between obs and fcst by cca, CFS and SMLR
C. ncv=0: no cross validation; ncv > 0: there is cross validation.
C. eps: eps*100 % ridging
C. irhs: =1 means yes for adding sum(b/a) to rhs
C. idelmdl: =1 means yes for delting models which gives -ve skill
C===========================================================
      PARAMETER (ncv=3,eps=0.1,irhs=0,idelmdl=0)
      PARAMETER (mdvs=102,nyr=25,nmodel=3,nyin=nyr-ncv, nfcst=nmodel+2)
      real fld1(mdvs),fld2(mdvs)
      real totdata(mdvs,nyr,nmodel+1)
      real wk3d(mdvs,nyr)
      real obs3d(mdvs,nyin)
      real cca3d(mdvs,nyin),cfs3d(mdvs,nyin)
      real smlr3d(mdvs,nyin),eca3d(mdvs,nyin)
      real cps3d(mdvs,nyin)
      real obs2d(mdvs)
      real cca2d(mdvs),cfs2d(mdvs)
      real smlr2d(mdvs),eca2d(mdvs)
      real cps2d(mdvs)
      real obs(nyin,mdvs),gcm(nmodel,nyin,mdvs),beta(nmodel)
      real wk1(mdvs),wk2(mdvs)
      real wk3(mdvs),wk4(mdvs)
      real wk5(mdvs)
      real accus(nyr,nfcst)
      real rmsus(nyr,nfcst)
      real accm(nfcst)
      real rmsm(nfcst)
      real clim1(mdvs),clim2(mdvs)
      real clim3(mdvs),clim4(mdvs)
      real clim5(mdvs)
      real gmgm(nmodel,nmodel),obgm(nmodel)
      real gmgminv(nmodel,nmodel)
      integer indx(nmodel)
      real   gm(nmodel)
      real betaout(nyr,nmodel)
      real mlrprd(mdvs,nyr),ewmprd(mdvs,nyr)
      real ccaprd(mdvs,nyr),cfsprd(mdvs,nyr)
      real smlprd(mdvs,nyr)
      real verify(mdvs,nyr)
      real tfd(nyr)
c
      open(unit=10,form='formatted')
      open(unit=20,form='formatted')
      open(unit=30,form='formatted')
      open(unit=40,form='formatted')
      open(unit=50,form='unformatted',access='direct',recl=4*mdvs)
      open(unit=60,form='formatted')
      open(unit=70,form='formatted')
c     open(unit=60,form='unformatted',access='direct',recl=4*mdvs)

      mean=0  ! mean=1: acc take off area mean; 
              ! =0: not take off area mean
      ianom=1 ! =1: remove time & space mean; =0: not remove time mean
 
      icca=1  ! =0 means not include it
      icfs=1  ! =0 means not include it
      ismlr=1 ! =0 means not include it

C=== read in obs and model data
      DO iy=1,nyr
        read(10,444) wk1  !obs
        read(20,444) wk2  !cca
        read(30,444) wk3  !CFS
        read(40,444) wk4  !smlr
        do i=1,mdvs
          totdata(i,iy,1)=wk1(i)
          totdata(i,iy,2)=wk2(i)
          totdata(i,iy,3)=wk3(i)
          totdata(i,iy,4)=wk4(i)
        end do
      ENDDO
 444  format(10f6.1)
C
C== normalize data
      do im=1,nmodel+1
        do id=1,mdvs
        do iy=1,nyr
          wk3d(id,iy)=totdata(id,iy,im)
        enddo
        enddo
c
        call norm_data(wk3d,mdvs,nyr)
c
        do id=1,mdvs
        do iy=1,nyr
          totdata(id,iy,im)=wk3d(id,iy)
        enddo
        enddo
      enddo

C===  verify against each case
      
      write(6,788)'year','CCA','CFS','SML','CON','ENS',
     &'CCA','CFS','SML'
      do 1000 icase=1,nyr

         iy=0
      do 2000 iyear=1,nyr
        if (iyear.eq.icase) then
         do i=1,mdvs
            obs2d(i)=totdata(i,iyear,1)
            cca2d(i)=totdata(i,iyear,2)
            cfs2d(i)=totdata(i,iyear,3)
            smlr2d(i)=totdata(i,iyear,4)
            verify(i,icase)=totdata(i,iyear,1)
         end do
        end if

        IF (ncv.eq.0) then  ! that is, not cross validation
         iy=iy+1
         do i=1,mdvs
            obs3d(i,iy)=totdata(i,iyear,1)
            cca3d(i,iy)=totdata(i,iyear,2)
            cfs3d(i,iy)=totdata(i,iyear,3)
            smlr3d(i,iy)=totdata(i,iyear,4)
         end do
        END IF
c
        IF (ncv.eq.1) then  !
          if(iyear.ne.icase) then
          iy=iy+1
          do i=1,mdvs
            obs3d(i,iy)=totdata(i,iyear,1)
            cca3d(i,iy)=totdata(i,iyear,2)
            cfs3d(i,iy)=totdata(i,iyear,3)
            smlr3d(i,iy)=totdata(i,iyear,4)
          end do
          end if
        END IF
c
        IF (ncv.eq.3) then 
          icasep=icase+1
          icasem=icase-1
          if(iyear.lt.icasem.or.iyear.gt.icasep) then
          iy=iy+1
          if(iy.gt.nyin) go to 2500
          do i=1,mdvs
            obs3d(i,iy)=totdata(i,iyear,1)
            cca3d(i,iy)=totdata(i,iyear,2)
            cfs3d(i,iy)=totdata(i,iyear,3)
            smlr3d(i,iy)=totdata(i,iyear,4)
          end do
          end if
        END IF

 2000 continue
 2500 continue

C===  remove time mean
      call setzero(clim1,mdvs)
      call setzero(clim2,mdvs)
      call setzero(clim3,mdvs)
      call setzero(clim4,mdvs)
      if(ianom.eq.1) then
      call timeanom(obs3d,mdvs,nyin,clim1)
      call timeanom(cca3d,mdvs,nyin,clim2)
      call timeanom(cfs3d,mdvs,nyin,clim3)
      call timeanom(smlr3d,mdvs,nyin,clim4)

c     call timespaceanom(obs3d,mdvs,nyin,stclim1)
c     call timespaceanom(cca3d,mdvs,nyin,stclim2)
c     call timespaceanom(cfs3d,mdvs,nyin,stclim3)
c     call timespaceanom(smlr3d,mdvs,nyin,stclim4)
      end if

C===  correct anom for target year data
       do i=1,mdvs
         obs2d(i)=obs2d(i)-clim1(i)
         cca2d(i)=cca2d(i)-clim2(i)
         cfs2d(i)=cfs2d(i)-clim3(i)
         smlr2d(i)=smlr2d(i)-clim4(i)
       end do
c
      do k=1,nyin
      do i=1,mdvs
        obs(  k,i)=obs3d(i,k)
        gcm(1,k,i)=icca*cca3d(i,k)
        gcm(2,k,i)=icfs*cfs3d(i,k)
        gcm(3,k,i)=ismlr*smlr3d(i,k)
      end do
      end do
c
C=== construct matrix
      call setzero_2d_dd(gmgm,nmodel,nmodel)
      call setzero_1d_dd(obgm,nmodel)
c
      do im=1,nmodel
      do jm=1,nmodel
         do k=1,nyin
         do i=1,mdvs
           gmgm(im,jm)=gmgm(im,jm)+gcm(im,k,i)*gcm(jm,k,i)
         end do
         end do
      end do
      end do

      do im=1,nmodel
      do jm=1,nmodel
         gmgm(im,jm)=gmgm(im,jm)/(mdvs*nyin)
      end do
      end do

      do im=1,nmodel
         do k=1,nyin
         do i=1,mdvs
         obgm(im)=obgm(im)+obs(k,i)*gcm(im,k,i)/float(mdvs*nyin)
         end do
         end do
      end do

C------------------------------------------
C ridging
C------------------------------------------
      tot=0.
      rfc=0.
      do im=1,nmodel
        tot=tot+gmgm(im,im)/float(nmodel)
        rfc=rfc+obgm(im)/gmgm(im,im)
      enddo
      do im=1,nmodel
         gmgm(im,im)=gmgm(im,im)+tot*eps
         obgm(im)=obgm(im)+irhs*tot*eps*obgm(im)/(gmgm(im,im)*rfc)
      enddo
c
      if(idelmdl.eq.1) then
      do im=1,nmodel
        if(obgm(im).lt.0) then
        call delmdl(gmgm,obgm,nmodel,im)
        end if
      end do
      end if
        
c        write(6,*)'matrix=',gmgm
         call ludcmp(gmgm,nmodel,nmodel,indx,dex)
         call lubksb(gmgm,nmodel,nmodel,indx,obgm)
C== have xmean
      do im=1,nmodel
        gm(im)=0
        do k=1,nyin
        do i=1,mdvs
          gm(im)=gm(im)+gcm(im,k,i)/float(mdvs*nyin)
        end do
        end do
      end do
      do im=1,nmodel
        beta(im)=obgm(im)
      end do
c
        om=0
        do k=1,nyin
        do i=1,mdvs
            om=om+obs(k,i)
        end do
        end do
        om=om/(mdvs*nyin)
        
        af=0.
        do im=1,nmodel
          af=sf+beta(im)*gm(im)
        end do
    
        xmean=om-af
c       write(6,*) 'xmean=',xmean
C=== write beta into a array
        do i=1,nmodel
          betaout(icase,i)=beta(i)
        end do

C=== make prediction and verify against obs for case i
C... prediction with multi_regression
      do i=1,mdvs
         wk1(i)=xmean+beta(1)*cca2d(i)+
     &            beta(2)*cfs2d(i)+
     &            beta(3)*smlr2d(i)
        mlrprd(i,icase)=wk1(i)
      end do
C... prediction with simple ensemble
      do i=1,mdvs
         wk2(i)=(cca2d(i)+
     &            cfs2d(i)+
     &            smlr2d(i))/float(nmodel)
         ewmprd(i,icase)=wk2(i)
      end do
C... verify against obs2d
c... have 1-D acc 

        call acc(obs2d,wk1,mdvs,accus(icase,1))
        call acc(obs2d,wk2,mdvs,accus(icase,2))
        call acc(obs2d,cca2d,mdvs,accus(icase,3))
        call acc(obs2d,cfs2d,mdvs,accus(icase,4))
        call acc(obs2d,smlr2d,mdvs,accus(icase,5))

        call rmss(obs2d,wk1,mdvs,rmsus(icase,1))
        call rmss(obs2d,wk2,mdvs,rmsus(icase,2))
        call rmss(obs2d,cca2d,mdvs,rmsus(icase,3))
        call rmss(obs2d,cfs2d,mdvs,rmsus(icase,4))
        call rmss(obs2d,smrl2d,mdvs,rmsus(icase,5))

      write(60,*) 'OBS'
      write(60,444) obs2d
      write(60,*) 'CONSL'
      write(60,444) wk1
      write(60,*) 'SIMPLE ENSEMBLE'
      write(60,444) wk2
      write(60,*) 'CCA'
      write(60,444) cca2d
      write(60,*) 'CFS'
      write(60,444) cfs2d
      write(60,*) 'SMLR'
      write(60,444) smlr2d
 1000 continue
C=== have s&t avg AC and RMS
      do iy=1,nyr
      do i=1,mdvs
        ccaprd(i,iy)=totdata(i,iy,2)
        cfsprd(i,iy)=totdata(i,iy,3)
        smlprd(i,iy)=totdata(i,iy,4)
      end do
      end do
      call acc_in_st(verify,mlrprd,accm(1),mdvs,nyr)
      call acc_in_st(verify,ewmprd,accm(2),mdvs,nyr)
      call acc_in_st(verify,ccaprd,accm(3),mdvs,nyr)
      call acc_in_st(verify,cfsprd,accm(4),mdvs,nyr)
      call acc_in_st(verify,smlprd,accm(5),mdvs,nyr)
c
      call rms_in_st(verify,mlrprd,rmsm(1),mdvs,nyr)
      call rms_in_st(verify,ewmprd,rmsm(2),mdvs,nyr)
      call rms_in_st(verify,ccaprd,rmsm(3),mdvs,nyr)
      call rms_in_st(verify,cfsprd,rmsm(4),mdvs,nyr)
      call rms_in_st(verify,smlprd,rmsm(5),mdvs,nyr)

      write(6,888)'MEAN ACC=',accm(1),accm(2),accm(3),accm(4),accm(5)
      write(6,888)'MEAN RMS=',rmsm(1),rmsm(2),rmsm(3),rmsm(4),rmsm(5)
      write(6,*)
      write(6,766)'eps=',eps
      write(6,*)'         CV= ',ncv
      write(6,*)'        rhs= ',irhs
      write(6,*)'     delmdl= ',idelmdl

c     write out weights and skill for each case

      do iy=1,nyr
      iiy=1982+iy-1
      write(6,777)iiy,'wgts=',betaout(iy,1),betaout(iy,2),betaout(iy,3),
     &'acc=',accus(iy,1),accus(iy,2),
     &accus(iy,3),accus(iy,4),accus(iy,5)
      enddo
      write(6,*)
      do iy=1,nyr
      iiy=1982+iy-1
      write(6,777)iiy,'wgts=',betaout(iy,1),betaout(iy,2),betaout(iy,3),
     &'rms=',rmsus(iy,1),rmsus(iy,2),
     &rmsus(iy,3),rmsus(iy,4),rmsus(iy,5)
      enddo
      write(6,*)
c== std and mean of beta
      do m=1,nmodel
        do it=1,nyr
        tfd(it)=betaout(it,m)
        enddo
        call mean_std(tfd,xm,std,nyr)
        ratio=std/xm
      write(6,*) 'mean and std for model',m,' are',xm,std,ratio
      enddo
c
c
555   format(A10,3(2x,A5,f7.2))
888   format(A15,10x,5f6.2)
777   format(I5,2x,A5,1x,3f7.2,1x,A5,5f6.2)
788   format(A5,7x,3A7,6x,5A6)
766   format(A13,5f7.2)
666   format(1x,A50)
999   format(2x,I2,2x,6(f7.2,2x))
988   format(10f6.2)

C
CC== acc & rms in time domain
      write(6,*)
      write(6,*) 'Temporal AC SKILL'
      call acc_in_t(mlrprd,verify,wk1,mdvs,nyr)
      write(6,*) 'consolidated'
      write(6,988) wk1
      write(50) wk1
      call avg_skill(wk1,mdvs,accm(1))
      call acc_in_t(ewmprd,verify,wk1,mdvs,nyr)
      write(6,*) 'simple ensemble avg'
      write(6,988) wk1
      write(50) wk1
      call avg_skill(wk1,mdvs,accm(2))
      call acc_in_t(ccaprd,verify,wk1,mdvs,nyr)
      write(6,*) 'CCA'
      write(6,988) wk1
      write(50) wk1
      call avg_skill(wk1,mdvs,accm(3))
      call acc_in_t(cfsprd,verify,wk1,mdvs,nyr)
      write(6,*) 'CFS'
      write(6,988) wk1
      write(50) wk1
      call avg_skill(wk1,mdvs,accm(4))
      call acc_in_t(smlprd,verify,wk1,mdvs,nyr)
      write(6,*) 'SMLR'
      write(6,988) wk1
      write(50) wk1
      call avg_skill(wk1,mdvs,accm(5))
cccccccccccccccccccccccccccccccccccc
      write(6,*)
      write(6,*) 'RMS SKILL'
      call rms_in_t(mlrprd,verify,wk1,mdvs,nyr)
      write(6,*) 'consolidated'
      write(6,988) wk1
      call avg_skill(wk1,mdvs,rmsm(1))
      call rms_in_t(ewmprd,verify,wk1,mdvs,nyr)
      write(6,*) 'simple ensemble avg'
      write(6,988) wk1
      call avg_skill(wk1,mdvs,rmsm(2))
      call rms_in_t(ccaprd,verify,wk1,mdvs,nyr)
      write(6,*) 'CCA'
      write(6,988) wk1
      call avg_skill(wk1,mdvs,rmsm(3))
      call rms_in_t(cfsprd,verify,wk1,mdvs,nyr)
      write(6,*) 'CFS'
      write(6,988) wk1
      call avg_skill(wk1,mdvs,rmsm(4))
      call rms_in_t(smlprd,verify,wk1,mdvs,nyr)
      write(6,*) 'SMLR'
      write(6,988) wk1
      call avg_skill(wk1,mdvs,rmsm(5))

      write(6,888)'avg ACC in t',accm(1),accm(2),accm(3),accm(4),accm(5)
      write(6,888)'avg RMS in t',rmsm(1),rmsm(2),rmsm(3),rmsm(4),rmsm(5)
      stop
      END

      subroutine delmdl(a,b,n,k)
      dimension a(n,n),b(n)
      b(k)=0.
      do i=1,n
      if (i.ne.k)then
      a(i,k)=0.
      a(k,i)=0.
      endif
      enddo
      return
      end 

      SUBROUTINE mean_std(fld,xm,std,ltime)
      real fld(ltime)
c
      xm=0.
      do it=1,ltime
        xm=xm+fld(it)/float(ltime)
      enddo
c
      do it=1,ltime
        fld(it)=fld(it)-xm
      enddo
c
      std=0.
      do it=1,ltime
        std=std+fld(it)* fld(it)/float(ltime)
      enddo

      std=sqrt(std)
c
      return
      end

      SUBROUTINE avg_skill(fld,mdvs,ac)
      dimension fld(mdvs)
      ac=0.
      do  i=1,mdvs
        ac=ac+fld(i)/float(mdvs)
      end do
      return
      end

      SUBROUTINE timespaceanom(fld,lon,ltime,clim)
      dimension fld(lon,ltime)
      clim=0.
      do  k=1,ltime
      do  i=1,lon
        clim=clim+fld(i,k)
      end do
      end do
 
      clim=clim/(lon*ltime)

      do  k=1,ltime
      do  i=1,lon
        fld(i,k)=fld(i,k)-clim
      end do
      end do
      return
      end

      SUBROUTINE norm_beta(wk1d,nmodel)
      dimension wk1d(nmodel)

        clim=0.
        do it=1,nmodel
        clim=clim+wk1d(it)
        end do

        do it=1,nmodel
        wk1d(it)=wk1d(it)/clim
        end do
c
      return
      end

      SUBROUTINE norm_data(wk3d,mdvs,ltime)
      dimension wk3d(mdvs,ltime)

      do id=1,mdvs
        clim=0.
        do it=1,ltime
        clim=clim+wk3d(id,it)/float(ltime)
        end do

        do it=1,ltime
        wk3d(id,it)=wk3d(id,it)-clim
        end do

        std=0.
        do it=1,ltime
        std=std+wk3d(id,it)*wk3d(id,it)/float(ltime)
        end do
        std=sqrt(std)

        do it=1,ltime
        wk3d(id,it)=wk3d(id,it)/std
        end do
      enddo
c
      return
      end


      SUBROUTINE acc_in_t(fld1,fld2,corr,mdvs,ltime)
      real fld1(mdvs,ltime),fld2(mdvs,ltime)
      real corr(mdvs)
c
      call setzero(corr,mdvs)
c
      do i=1,mdvs
         sd1=0.
         sd2=0.
      do it=1,ltime
         sd1=sd1+fld1(i,it)*fld1(i,it)/float(ltime)
         sd2=sd2+fld2(i,it)*fld2(i,it)/float(ltime)
         corr(i)=corr(i)+fld1(i,it)*fld2(i,it)/float(ltime)
      enddo
         corr(i)=corr(i)/(sqrt(sd1*sd2))
      enddo

      return
      end

      SUBROUTINE rms_in_t(fld1,fld2,rms,mdvs,ltime)
      real fld1(mdvs,ltime),fld2(mdvs,ltime)
      real rms(mdvs)
c
      call setzero(rms,mdvs)
c
      do 100 it=1,ltime
        do i=1,mdvs
          rr=fld1(i,it)-fld2(i,it)
          rms(i)=rms(i)+rr*rr/float(ltime)
        enddo
 100  continue

        do i=1,mdvs
         rms(i)=rms(i)**0.5
        enddo

      return
      end


      SUBROUTINE acc_in_st(fld1,fld2,corr,mdvs,ltime)
      real fld1(mdvs,ltime),fld2(mdvs,ltime)
c
      acc=0.
      std1=0.
      std2=0.
      do it=1,ltime
      do i=1,mdvs
          std1=std1+fld1(i,it)*fld1(i,it)/float(ltime*mdvs)
          std2=std2+fld2(i,it)*fld2(i,it)/float(ltime*mdvs)
          corr=corr+fld1(i,it)*fld2(i,it)/float(ltime*mdvs)
      enddo
      enddo

         std1=std1**0.5
         std2=std2**0.5
         corr=corr/(std1*std2)
      return
      end

      SUBROUTINE rms_in_st(fld1,fld2,rms,mdvs,ltime)
      real fld1(mdvs,ltime),fld2(mdvs,ltime)
c
      rms=0.
      do it=1,ltime
      do i=1,mdvs
      rm=(fld1(i,it)-fld2(i,it))
      rms=rms+rm*rm/float(ltime*mdvs)
      enddo
      enddo
      rms=sqrt(rms)
      return
      end


      SUBROUTINE setzero(fld,n)
      DIMENSION fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end

      SUBROUTINE setzero_2d_dd(fld,n,m)
      real fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end


      SUBROUTINE setzero_1d(fld,n)
      DIMENSION fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end

      SUBROUTINE setzero_1d_dd(fld,n)
      real fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end

      SUBROUTINE rmss(fld1,fld2,mdvs,rms)

      real fld1(mdvs),fld2(mdvs)

      rm=0.

      do i=1,mdvs
         df=fld1(i)-fld2(i)
         rm=rm+df*df/float(mdvs)
      enddo

      rms=sqrt(rm)

      return
      end

      SUBROUTINE acc(fld1,fld2,mdvs,cor)

      real fld1(mdvs),fld2(mdvs)

      cor=0.
      sd1=0.
      sd2=0.

      do i=1,mdvs
      cor=cor+fld1(i)*fld2(i)/float(mdvs)
      sd1=sd1+fld1(i)*fld1(i)/float(mdvs)
      sd2=sd2+fld2(i)*fld2(i)/float(mdvs)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      cor=cor/(sd1*sd2)

      return
      end


      SUBROUTINE timeanom(fld,mdvs,ltime,clim)
      dimension fld(mdvs,ltime),clim(mdvs)
      call setzero_1d(clim,mdvs)
      do  i=1,mdvs
      do  k=1,ltime
        clim(i)=clim(i)+fld(i,k)/float(ltime)
      end do
      end do

      do  i=1,mdvs
      do  k=1,ltime
        fld(i,k)=fld(i,k)-clim(i)
      end do
      end do
      return
      end


      SUBROUTINE solutn(ff,vf,beta,m)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      real ff(m,m),vf(m)
      real beta(m)

      do i=1,m
         beta(i)=0.
      do j=1,m
         beta(i)=beta(i)+ff(i,j)*vf(j)
      end do
      end do

      return
      end

