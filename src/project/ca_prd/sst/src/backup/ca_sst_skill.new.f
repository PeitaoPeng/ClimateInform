      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c range for sst pat cor (ac_1d)
      parameter(imss=150,imse=280)   ! 150->280
      parameter(jmss=66,jmse=116)    ! 25S->25N
c     parameter(imss=96,imse=121)   ! 190->240
c     parameter(jmss=42,jmse=48)    ! 6S->6N
c
      dimension ts1(nseason),ts2(nseason)
      dimension ts3(nseason),ts4(nseason)
      dimension fld(ims,jms)
      dimension xlat(jms),cosl(jms)
C
      dimension o6d(ims,jms,nld,nseason,neof,nic)
      dimension o5d(ims,jms,nld,nseason,nic)
      dimension o4d(ims,jms,nld,nseason)
c
      dimension p6d(ims,jms,nld,nseason,neof,nic)
      dimension p5d(ims,jms,nld,nseason,nic)
      dimension p4d(ims,jms,nld,nseason)
C    
      dimension ac5d(ims,jms,nld,neof,nic)
      dimension ac4d(ims,jms,nld,nic)
      dimension ac3d(ims,jms,nld)
C 
      dimension avgac3d(nld,neof,nic)
      dimension avgac2d(nld,nic)
      dimension avgac1d(nld)

      dimension f2d(neof,nic),f1d(nld)
C
      open(unit=11,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=12,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=13,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=14,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=15,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=16,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=17,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=18,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=19,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=20,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=21,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=22,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=23,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=24,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=25,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=26,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=27,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=28,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=29,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=30,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=31,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=32,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=33,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
      open(unit=34,form='unformatted',access='direct',recl=4*ims*jms) !obs$prd
c
      open(unit=85,form='unformatted',access='direct',recl=4*ims*jms) !2dskill
      open(unit=86,form='unformatted',access='direct',recl=4*neof*nic) !2dskill
      open(unit=87,form='unformatted',access='direct',recl=4*nld) !1dskill
c************************************************
c
      PI=4.*atan(1.)
      CONV=PI/180.
      undef1=-9.99E+8
      undef2=-9.99E+33

      do j=1,jms
      xlat(j)=-89.5+(j-1)*1.0
      enddo
      DO j=1,jms
        cosl(j)=COS(xlat(j)*CONV)
      END DO
c
cc read in all historical sst
c
      write(6,*) 'start reading data'
      iu=10
      Do ic=1,nic
      Do ie=1,neof
      iu=iu+1
      it=0
      Do is=1,nseason
      Do ld=1,nld
      it=it+1
      read(iu,rec=it) fld
      call f2d_2_6d(fld,o6d,ims,jms,nld,nseason,neof,nic,ld,is,ie,ic)
      it=it+1
      read(iu,rec=it) fld
      call f2d_2_6d(fld,p6d,ims,jms,nld,nseason,neof,nic,ld,is,ie,ic)
      Enddo
      Enddo
      Enddo
      Enddo
      write(6,*) 'finished reading data'
c
c have ensemble means over eofs
c
      Do ic=1,nic
      Do is=1,nseason
      Do ld=1,nld
      Do i=1,ims
      Do j=1,jms
       o5d(i,j,ld,is,ic)=0.
       p5d(i,j,ld,is,ic)=0.
       do ie=1,neof  !for eof cutoffs of 15 20 25 30 35 40
       o5d(i,j,ld,is,ic)=o5d(i,j,ld,is,ic)+o6d(i,j,ld,is,ie,ic)
     &/float(neof)
       p5d(i,j,ld,is,ic)=p5d(i,j,ld,is,ic)+p6d(i,j,ld,is,ie,ic)
     &/float(neof)
       enddo
      Enddo
      Enddo
      Enddo
      Enddo
      Enddo
c have ensemble means over both eofs and ics

      Do is=1,nseason
      Do ld=1,nld
      Do i=1,ims
      Do j=1,jms
       o4d(i,j,ld,is)=0.
       p4d(i,j,ld,is)=0.
       do ic=1,nic
c      do ie=5,neof  !for eof cutoffs of 35 40 45 50 55 60
       do ie=1,neof  !for eof cutoffs of 15 20 25 30 35 40
       o4d(i,j,ld,is)=o4d(i,j,ld,is)+o6d(i,j,ld,is,ie,ic)
     &/float(neof*nic)
       p4d(i,j,ld,is)=p4d(i,j,ld,is)+p6d(i,j,ld,is,ie,ic)
     &/float(neof*nic)
       enddo
       enddo
      Enddo
      Enddo
      Enddo
      Enddo
c
c temporal corr for predictor grids
c
c for ac5d
      Do ic=1,nic
      Do ie=1,neof
      Do ld=1,nld
      do i=1,ims
      do j=1,jms
      if(abs(o6d(i,j,ld,1,ie,ic)).lt.999) then
        do is=1,nseason
          ts1(is)=o6d(i,j,ld,is,ie,ic)
          ts2(is)=p6d(i,j,ld,is,ie,ic)
        enddo
        call corr_1d(nseason,ts1,ts2,ac5d(i,j,ld,ie,ic))
      else
        ac5d(i,j,ld,ie,ic)=undef1
      endif
      enddo
      enddo
      enddo
      enddo
      enddo
c for ac4d
      Do ic=1,nic
      Do ld=1,nld
      do i=1,ims
      do j=1,jms
      if(abs(o5d(i,j,ld,1,ic)).lt.999) then
        do is=1,nseason
          ts1(is)=o5d(i,j,ld,is,ic)
          ts2(is)=p5d(i,j,ld,is,ic)
        enddo
        call corr_1d(nseason,ts1,ts2,ac4d(i,j,ld,ic))
      else
        ac4d(i,j,ld,ic)=undef1
      endif
      enddo
      enddo
      enddo
      enddo
c for ac3d
      Do ld=1,nld
      do i=1,ims
      do j=1,jms
      if(abs(o4d(i,j,ld,1)).lt.999) then
        do is=1,nseason
          ts1(is)=o4d(i,j,ld,is)
          ts2(is)=p4d(i,j,ld,is)
        enddo
        call corr_1d(nseason,ts1,ts2,ac3d(i,j,ld))
      else
        ac3d(i,j,ld)=undef1
      endif
      enddo
      enddo
      enddo
c
c calculated area avg ac
c
c for ac5d
      DO ic=1,nic
      DO ie=1,neof
      DO ld=1,nld

      do i=1,ims
      do j=1,jms
        fld(i,j)=ac5d(i,j,ld,ie,ic)
      enddo
      enddo
      
      call ac2davg(fld,avgac3d(ld,ie,ic),ims,jms,imss,imse,
     &jmss,jmse,cosl)

      ENDDO
      ENDDO
      ENDDO
c for ac4d
      DO ic=1,nic
      DO ld=1,nld

      do i=1,ims
      do j=1,jms
        fld(i,j)=ac4d(i,j,ld,ic)
      enddo
      enddo
      
      call ac2davg(fld,avgac2d(ld,ic),ims,jms,imss,imse,
     &jmss,jmse,cosl)

      ENDDO
      ENDDO
c for ac3d
      DO ld=1,nld

      do i=1,ims
      do j=1,jms
        fld(i,j)=ac3d(i,j,ld)
      enddo
      enddo
      
      call ac2davg(fld,avgac1d(ld),ims,jms,imss,imse,
     &jmss,jmse,cosl)

      ENDDO
c write out skill
c for ac of all ensemble mean
      iwr=0
      DO ld=1,nld
      do i=1,ims
      do j=1,jms
      fld(i,j)=ac3d(i,j,ld)
      enddo
      enddo
      iwr=iwr+1
      write(85,rec=iwr) fld
      ENDDO
c for avgac3d
      iwr=0
      DO ld=1,nld
        do ie=1,neof
        do ic=1,nic
          f2d(ie,ic)=avgac3d(ld,ie,ic)
        enddo
        enddo
      iwr=iwr+1
      write(86,rec=iwr) f2d
      ENDDO
c for avgac1d
      iwr=0
      DO ic=1,nic
      do ld=1,nld
      f1d(ld)=avgac2d(ld,ic)
      enddo
      iwr=iwr+1
      write(87,rec=iwr) f1d
      ENDDO
c
      iwr=iwr+1
      write(87,rec=iwr) avgac1d
c
      write(6,*) 'avgac1d=',avgac1d
c
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
      subroutine changeundef(f1,f2,udf1,udf2,imx,jmx)
      dimension f1(imx,jmx),f2(imx,jmx)
        do i=1,imx
        do j=1,jmx
          f2(i,j)=f1(i,j)
        if(f1(i,j).eq.udf1) then
          f2(i,j)=udef2
        endif
        end do
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
      x=x+ts1(it)*ts1(it)
      y=y+ts2(it)*ts2(it)
      xy=xy+ts1(it)*ts2(it)
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
      if(abs(e(m1,i,j)).lt.999) then
      x=x+e(m1,i,j)*e(m2,i,j)*cosl(j)
      endif
      enddo
      enddo
      anorm=x
      return
      end
c
      subroutine f2d_2_6d(wk1,wk2,n1,n2,n3,n4,n5,n6,k,l,m,n)
      dimension wk1(n1,n2),wk2(n1,n2,n3,n4,n5,n6)
      do j=1,n2
      do i=1,n1
      wk2(i,j,k,l,m,n)=wk1(i,j)
      enddo
      enddo
      return
      end
c
      subroutine zero_4d(wk,n1,n2,n3,n4)
      dimension wk(n1,n2,n3,n4)
      do l=1,n4
      do k=1,n3
      do j=1,n2
      do i=1,n1
      wk(i,j,k,l)=0.
      enddo
      enddo
      enddo
      enddo
      return
      end
c
      subroutine zero_5d(wk,n1,n2,n3,n4,n5)
      dimension wk(n1,n2,n3,n4,n5)
      do m=1,n5
      do l=1,n4
      do k=1,n3
      do j=1,n2
      do i=1,n1
      wk(i,j,k,l,m)=0.
      enddo
      enddo
      enddo
      enddo
      enddo
      return
      end

      subroutine pass_4d(wk1,wk2,n1,n2,n3,n4)
      dimension wk1(n1,n2,n3,n4),wk2(n1,n2,n3,n4)
      do l=1,n4
      do k=1,n3
      do j=1,n2
      do i=1,n1
      wk2(i,j,k,l)=wk1(i,j,k,l)
      enddo
      enddo
      enddo
      enddo
      return
      end

      subroutine pass_2d(wk1,wk2,n1,n2)
      dimension wk1(n1,n2),wk2(n1,n2)
      do j=1,n2
      do i=1,n1
      wk2(i,j)=wk1(i,j)
      enddo
      enddo
      return
      end

      subroutine pass_2d_2_4d(w2d,w4d,n1,n2,n3,n4,ip,is)
      dimension w2d(n1,n2),w4d(n1,n2,n3,n4)
      do j=1,n2
      do i=1,n1
      w4d(i,j,ip,is)=w2d(i,j)
      enddo
      enddo
      return
      end

      subroutine ac2davg(wk,ot,n1,n2,is,ie,js,je,cosl)
      dimension cosl(n2),wk(n1,n2)
      ot=0.
      ar=0.
      do i=is,ie
      do j=js,je

      if(abs(wk(i,j)).lt.999) then
      ot=ot+wk(i,j)
      ar=ar+cosl(j)
      endif

      enddo
      enddo
      ot=ot/ar
      return
      end

      subroutine avg_2d(wk1,wk2,n1,n2)
      dimension wk1(n1,n2),wk2(n1,n2)
      do j=1,n2
      do i=1,n1
      wk2(i,j)=0.5*(wk1(i,j)+wk2(i,j))
      enddo
      enddo
      return
      end

      subroutine inprod4(e,academic,im,jm,cosl,m1,modemax,anorm)
c* inner product in space among one eof and an academic anomaly
      dimension e(modemax,im,jm),academic(im,jm)
      dimension cosl(jm)
      x=0.
      y=0.
      do i=1,im
      do j=1,jm
      cosw=cosl(j)
      if(abs(academic(i,j)).lt.999) then
      x=x+e(m1,i,j)*academic(i,j)*cosw
      y=y+e(m1,i,j)*e(m1,i,j)*cosw
      endif
      enddo
      enddo
c     write(6,100)m1,x/y
      anorm=x/y
100   format(1h ,'ip4= ',i5,3f10.6)
      return
      end
c
      subroutine rmsd1(anom,anomp,im,jm,ims,ime,jms,jme,cosl,z1,zc)
      dimension anomp(im,jm),anom(im,jm)
      dimension cosl(jm)
      x=0.
      y=0.
      z=0.
      zc=0.
      w=0.
      do i=ims,ime
      do j=jms,jme
      cosw=cosl(j)
      if(abs(anom(i,j)).gt.999.or.abs(anomp(i,j)).gt.999) go to 123
      w=w+cosw
      x=x+anom(i,j)*anom(i,j)*cosw
      y=y+anomp(i,j)*anomp(i,j)*cosw
      z=z+(anomp(i,j)-anom(i,j))*(anomp(i,j)-anom(i,j))*cosw
      zc=zc+anomp(i,j)*anom(i,j)*cosw
  123 continue
      enddo
      enddo
      x1=sqrt(x/w)
      y1=sqrt(y/w)
      z1=sqrt(z/w)
      zc=zc/w/(x1*y1)
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

      FUNCTION ran1(idum)
      INTEGER idum,IA,IM,IQ,IR,NTAB,NDIV
      REAL ran1,AM,EPS,RNMX
      PARAMETER (IA=16807,IM=2147483647,AM=1./IM,IQ=127773,IR=2836,
     *NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
      INTEGER j,k,iv(NTAB),iy
      SAVE iv,iy
      DATA iv /NTAB*0/, iy /0/
      if (idum.le.0.or.iy.eq.0) then
        idum=max(-idum,1)
        do 11 j=NTAB+8,1,-1
          k=idum/IQ
          idum=IA*(idum-k*IQ)-IR*k
          if (idum.lt.0) idum=idum+IM
          if (j.le.NTAB) iv(j)=idum
11      continue
        iy=iv(1)
      endif
      k=idum/IQ
      idum=IA*(idum-k*IQ)-IR*k
      if (idum.lt.0) idum=idum+IM
      j=1+iy/NDIV
      iy=iv(j)
      iv(j)=idum
      ran1=min(AM*iy,RNMX)
      return
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  calculate normal distribution PDF from -5 to 5 (unit=std)
C  have it as a table for later integration
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine pdf_tab(xx,yy,xde,n)
      real xx(n),yy(n)
      pi=3.14159
      coef=1./sqrt(2*pi)
      xde=0.1
      xx(1)=-5+xde/2
      do i=2,n
      xx(i)= xx(i-1)+xde
      enddo
      do i=1,n
      yy(i)=coef*exp(-xx(i)*xx(i)/2)
      enddo
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  Have prob by integratinge PDF
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine prob(x1,n,xx,xde,yy,pp,pn)
      real xx(n),yy(n)
      if(x1.gt.0) then
      x2=0-x1
      else
      x2=abs(x1)
      endif
      pn=0
      do i=1,n
      if(xx(i).gt.x2) go to 111
      pn=pn+xde*yy(i)
      enddo
  111 continue
      pp=1-pn
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to have y=a+bx
C  here xin=3-mon avg, xin2=weekly data
C  out=detrended xin2, out2=trend
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ltrend_1d(xin,out,nt,its,ite,a,b)
      dimension xin(nt),out(nt)
      real lxx, lxy
c
      xb=0
      yb=0
      do it=its,ite
        xb=xb+float(it)/float(ite-its+1)
        yb=yb+xin(it)/float(ite-its+1)
      enddo
c
      lxx=0.
      lxy=0.
      do it=its,ite
      lxx=lxx+(it-xb)*(it-xb)
      lxy=lxy+(it-xb)*(xin(it)-yb)
      enddo
      b=lxy/lxx
      a=yb-b*xb
c
      do it=1,nt
        out(it)=b*float(it)+a !trend
      enddo
c
      return
      end
      subroutine hss2c(mask,mw1,mw2,coslat,hs,ntot,m,n)
      dimension mask(m,n),mw1(m,n),mw2(m,n),coslat(n)

      h=0.
      tot=0.
      ntot=0
      do i=1,m
      do j=1,n
      IF(mask(i,j).eq.1) then
c     IF(abs(mw2(i,j)).ne.9999) then
      tot=tot+coslat(j)
      ntot=ntot+1
      if (mw1(i,j).ne.9) then
      if (mw1(i,j).eq.mw2(i,j)) h=h+coslat(j)
      else
        h=h+coslat(j)/3.
      end if
      END IF
      enddo
      enddo
      hs=(h-tot/3.)/(tot-tot/3.)*100.
c     write(6,*) 'h=',h,'tot=',tot,'hs=',hs
      return
      end

      subroutine hss2c_t(mw1,mw2,hs,its,ite,n)
      dimension mw1(n),mw2(n)

      h=0.
      tot=0.
      do i=its,ite
      tot=tot+1
      if (mw1(i).eq.mw2(i)) h=h+1
      enddo
      hs=(h-tot/2.)/(tot-tot/2.)*100.
      return
      end
c
      subroutine have_std(fld,n,std)
      dimension fld(n)

      ave=0.
      do i=1,n
      ave=ave+fld(i)
      enddo
      ave=ave/float(n)
c
      std=0.
      do i=1,n
      std=std+(fld(i)-ave)*(fld(i)-ave)
      enddo
      std=sqrt(std/float(n))
      
      return
      end

      subroutine anom_wmo(fldin,fldout,ncd,nt,ntprd,ndec)
      real fldin(ncd,nt),clm(ndec,ncd)
      real fldout(ncd,ntprd)
c have wmo clim
      do id=1,ndec
      do i=1,ncd
      clm(id,i)=0.
      do k=1,30
        clm(id,i)=clm(id,i)+fldin(i,k+(id-1)*10)/30.
      enddo
      enddo
      enddo
c anom w.r.t wmo clim
      do id=1,ndec-1
      do i=1,ncd
      do k=1,10
        kt=k+30+(id-1)*10
        fldout(i,kt-30)=fldin(i,kt)-clm(id,i)
      enddo
      enddo
      enddo
c
      ks=30+(ndec-1)*10+1
      if(ks.gt.nt) go to 111
      do i=1,ncd
      do k=ks,nt !2011-cur (at most 2020)
        fldout(i,k-30)=fldin(i,k)-clm(ndec,i)
      enddo
      enddo

 111  return
      end

      subroutine ocn_prd(kocn,fin,ntot,prd,vfy,ntprd,clm,ndec)
      real fin(ntot),prd(ntprd),vfy(ntprd),clm(ndec)
c== WMO clim for the whole data length
      do id=1,ndec
      clm(id)=0.
      do k=1,30
        clm(id)=clm(id)+fin(k+(id-1)*10)/30.
      enddo
      enddo
c== verification wrt wmo clim
      it=0
      do id=1,ndec-1  !for 1981->(1980+(ndec-1)*10)
      do k=1,10
      it=it+1
        kt=30+k+(id-1)*10
        vfy(it)=fin(kt)-clm(id)
      enddo
      enddo
c
      ks=30+(ndec-1)*10+1
      do k=ks,ntot ! for (1980+(ndec-1)*10+1)->current year
      it=it+1
        vfy(it)=fin(k)-clm(ndec)
      enddo
c
C== ocn prd wrt wmo clim
      kt=0
      do jt=31,ntot !31=1981
      kt=kt+1
         avg=0
        do k=jt-kocn,jt-1
         avg=avg+fin(k)/float(kocn)
        end do
         prd(kt)=avg
      enddo
c
      return
      end
c
      subroutine wmo_anom(fin,ntot,vfy,ntprd,clm,ndec)
      real fin(ntot),prd(ntprd),vfy(ntprd),clm(ndec)
c== WMO clim for the whole data length
      do id=1,ndec
      clm(id)=0.
      do k=1,30
        clm(id)=clm(id)+fin(k+(id-1)*10)/30.
      enddo
      enddo
c== verification wrt wmo clim
      it=0
      do id=1,ndec-1  !for 1981->(1980+(ndec-1)*10)
      do k=1,10
      it=it+1
        kt=30+k+(id-1)*10
        vfy(it)=fin(kt)-clm(id)
      enddo
      enddo
c
      ks=30+(ndec-1)*10+1
      do k=ks,ntot ! for (1980+(ndec-1)*10+1)->current year
      it=it+1
        vfy(it)=fin(k)-clm(ndec)
      enddo
c
      return
      end
