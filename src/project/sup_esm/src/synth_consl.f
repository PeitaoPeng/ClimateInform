      program MME_test
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. test the impact of some parameters to the performance of 
C  the regress based multi-model ensemble by using synthesized time series.
C. eps: eps*100 % ridging
C. irhs: =1 means yes for adding sum(b/a) to rhs
C. idelmdl: =1 means yes for delting models which gives -ve skill
C===========================================================
      PARAMETER (eps=0.0,irhs=0,idelmdl=0)
      PARAMETER (nytot=1000,nyprd=100, nfcst=nmodel+2)
      PARAMETER (nmodel=3)
      real mdldat(nytot,nmodel)
      real wk1(nytot),wk2(nyprd)
      real obs(nytot),vfy(nyprd)
      real prd1(nyprd),prd2(nyprd)
      real beta(nmodel)
      real acsk(nmodel+2),rmsk(nmodel+2)
      real gmgm(nmodel,nmodel),obgm(nmodel)
      integer indx(nmodel)
      real   gm(nmodel)
c
      open(unit=10,form='unformatted',access='direct',recl=4*nytot)
      open(unit=11,form='unformatted',access='direct',recl=4*nytot)
      open(unit=12,form='unformatted',access='direct',recl=4*nytot)
      open(unit=13,form='unformatted',access='direct',recl=4*nytot)
      open(unit=14,form='unformatted',access='direct',recl=4*nytot)
      open(unit=15,form='unformatted',access='direct',recl=4*nytot)
      open(unit=16,form='unformatted',access='direct',recl=4*nytot)
      open(unit=17,form='unformatted',access='direct',recl=4*nytot)
      open(unit=18,form='unformatted',access='direct',recl=4*nytot)
      open(unit=19,form='unformatted',access='direct',recl=4*nytot)
c
      open(unit=50,form='formatted')

C=== have obs and model data
      read(10) obs
      do im=1,nmodel 
        read(10+im) wk1
      do iy=1,nytot
        mdldat(iy,im)=wk1(iy)
      enddo
      enddo
C
C== normalize data
      call norm_data(obs,nytot)
      do im=1,nmodel
        do iy=1,nytot
          wk1(iy)=mdldat(iy,im)
        enddo
c
        call norm_data(wk1,nytot)
c
        do iy=1,nytot
          mdldat(iy,im)=wk1(iy)
        enddo
      enddo

C===  determine weights for various length of training data

      DO 1000 nytrn=20,nytot-nyprd,20  !loop for various length of training data

C=== construct matrix
      call setzero_2d(gmgm,nmodel,nmodel)
      call setzero_1d(obgm,nmodel)
c
      do im=1,nmodel
      do jm=1,nmodel
      do k=1,nytrn
         gmgm(im,jm)=gmgm(im,jm)+
     &   mdldat(im,k)*mdldat(jm,k)/float(nytrn)
      end do
      end do
      end do

      do im=1,nmodel
      do k=1,nytrn
         obgm(im)=obgm(im)+obs(k)*mdldat(im,k)/float(nytrn)
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
        
         call ludcmp(gmgm,nmodel,nmodel,indx,dex)
         call lubksb(gmgm,nmodel,nmodel,indx,obgm)
c
      do im=1,nmodel
        beta(im)=obgm(im)
      end do
c
C=== make prediction and verify against obs
c
      
      ip=0
      DO 2000 iy=nytot-nyprd+1,nytot
c
C... prediction with multi_regression
      ip=ip+1
      prd1(ip)=0.
      prd2(ip)=0.
      do im=1,nmodel
        prd1(ip)=prd1(ip)+beta(im)*mdldat(im+1,iy)
        prd2(ip)=prd1(ip)+mdldat(im,iy)/float(nmodel)
      end do
 2000 continue

C... verify against obs

      it=0
      do iy=nytot-nyprd+1,nytot
         it=it+1
         vfy(it)=obs(iy)
      end do
      call acc_in_t(prd1,vfy,acsk(1),nyprd)
      call acc_in_t(prd2,vfy,acsk(2),nyprd)
c
      do im=1,nmodel
        it=0
        do iy=nytot-nyprd+1,nytot
        it=it+1
        wk2(it)=mdldat(im,iy)
        end do
        call acc_in_t(wk2,vfy,acsk(im+2),nyprd)
      enddo

      write(6,*) "length of training data=",nytrn
      write(6,888)acsk
      
888   format(10f7.2)

C
 1000 continue

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

      SUBROUTINE norm_beta(wk1d,nmodel)
      dimension wk1d(nmodel)

        clim=0.
        do im=1,nmodel
        clim=clim+wk1d(im)
        end do

        do im=1,nmodel
        if (clim.gt.0.1) then
c         wk1d(im)=wk1d(im)/clim
        else 
          wk1d(im)=0
        end if
        end do
c
      return
      end

      SUBROUTINE norm_data(wk,ltime)
      dimension wk(ltime)

        clim=0.
        do it=1,ltime
        clim=clim+wk(it)/float(ltime)
        end do

        do it=1,ltime
        wk(it)=wk(it)-clim
        end do

        std=0.
        do it=1,ltime
        std=std+wk(it)*wk(it)/float(ltime)
        end do
        std=sqrt(std)

        do it=1,ltime
        wk(it)=wk(it)/std
        end do
c
      return
      end


      SUBROUTINE acc_in_t(fld1,fld2,corr,ltime)
      real fld1(ltime),fld2(ltime)
c
         sd1=0.
         sd2=0.
         corr=0.
      do it=1,ltime
         sd1=sd1+fld1(it)*fld1(it)/float(ltime)
         sd2=sd2+fld2(it)*fld2(it)/float(ltime)
         corr=corr+fld1(it)*fld2(it)/float(ltime)
      enddo
         corr=corr/(sqrt(sd1*sd2))
      enddo

      return
      end

      SUBROUTINE rms_in_t(fld1,fld2,rms,ltime)
      real fld1(ltime),fld2(ltime)
c
c
      rms=0.
      do 100 it=1,ltime
          rr=fld1(it)-fld2(it)
          rms=rms+rr*rr/float(ltime)
        enddo
 100  continue

         rms=rms**0.5
c
      return
      end

      SUBROUTINE cd_avg(fld,n,avg)
      DIMENSION fld(n)
      avg=0.
      do i=1,n
         avg=avg+fld(i)/float(n)
      enddo
      return
      end

      SUBROUTINE setzero_2d(fld,n)
      DIMENSION fld(n,n)
      do i=1,n
      do j=1,n
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

      SUBROUTINE timeanom(fld,ltime,clim)
      dimension fld(ltime)
        clim=0.
      do  k=1,ltime
        clim=clim+fld(k)/float(ltime)
      end do

      do  k=1,ltime
        fld(k)=fld(k)-clim
      end do
      return
      end

