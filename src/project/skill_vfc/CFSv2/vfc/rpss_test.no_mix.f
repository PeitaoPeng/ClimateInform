CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  Monte Carlo RPSS significance test for each model separately
C  or say, on mixing of two models
C==========================================================
      include "parm.h"
      parameter(lb=5,nblk=36)  !bl=lock length; nblk=total block #
c     parameter(bl=6,nblk=nss/bl)  !bl=lock length; nblk=total block #
      dimension mask(imx,jmx)
      dimension prd_a(imx,jmx,nss),prd_b(imx,jmx,nss)
      dimension prd_n(imx,jmx,nss) !nss: # of seasons
      dimension prd_a2(imx,jmx,nss),prd_b2(imx,jmx,nss)
      dimension prd_n2(imx,jmx,nss) !nss: # of seasons
      dimension vfc_a(imx,jmx,nss),vfc_b(imx,jmx,nss)
      dimension vfc_n(imx,jmx,nss)
      dimension kvfc(imx,jmx,nss)
      dimension rpss1(imx,jmx),rpss2(imx,jmx)
      dimension wk1(imx,jmx),wk2(imx,jmx),wk3(imx,jmx),wk4(imx,jmx)
      dimension w1d1(nsp),w1d2(nsp),w1d3(nsp),w1d4(nsp)
      dimension w1d5(nsp),w1d6(nsp),w1d7(nsp),w1d8(nsp)
      dimension xlat(jmx),coslat(jmx)
c
      dimension w3d1(imx,jmx,nss),w3d2(imx,jmx,nss)
      dimension w3d3(imx,jmx,nss),w3d4(imx,jmx,nss)
c
      dimension skt1(imx,jmx,nsp),skt2(imx,jmx,nsp)
      dimension avgskt1(nsp),avgskt2(nsp)
      real nsig1(imx,jmx),nsig2(imx,jmx),ndf12(imx,jmx)
      dimension df12(imx,jmx),dfmc(imx,jmx,nsp)
      dimension ran(nblk),idx(nblk),rdx(nblk)
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx) !mask
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx) !fcst B
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx) !fcst A
      open(unit=22,form='unformatted',access='direct',recl=4*imx*jmx) !fcst B
      open(unit=23,form='unformatted',access='direct',recl=4*imx*jmx) !fcst A
      open(unit=14,form='unformatted',access='direct',recl=4*imx*jmx) !obs
      open(unit=51,form='unformatted',access='direct',recl=4*imx*jmx) !spa patt of rpss
c
cc have coslat
      dl=2.
      do j=1,jmx
        xlat(j)=dl*(j-1)+20.
        coslat(j)=COS(3.14159*xlat(j)/180)
c       coslat(j)=1.
      enddo
c     write(6,*) 'xlat=',xlat
c     write(6,*) 'coslat=',coslat

C= read in mask
      read(11,rec=1) wk1
      call real_2_itg(wk1,mask,imx,jmx)
c
c= read in prd data
      do it=1,nss
        read(12,rec=it) wk1
        read(22,rec=it) wk3
c       write(6,*) 'prd_b=',wk1
        do i=1,imx
        do j=1,jmx
          prd_b(i,j,it)=wk1(i,j)/100.
          prd_b2(i,j,it)=wk3(i,j)/100.
        enddo
        enddo
        read(13,rec=it) wk2
        read(23,rec=it) wk4
c       write(6,*) 'prd_a=',wk2
        do i=1,imx
        do j=1,jmx
          prd_a(i,j,it)=wk2(i,j)/100.
          prd_a2(i,j,it)=wk4(i,j)/100.
        enddo
        enddo
        do i=1,imx
        do j=1,jmx
          prd_n(i,j,it)=(100.-wk1(i,j)-wk2(i,j))/100.
          prd_n2(i,j,it)=(100.-wk3(i,j)-wk4(i,j))/100.
        enddo
        enddo
      enddo
c
c= read in verification data
      do it=1,nss 
        read(14,rec=it) wk1
        do i=1,imx
        do j=1,jmx
          kvfc(i,j,it)=wk1(i,j)
        enddo
        enddo
      enddo
c convert vfc to probabilistic form
      do it=1,nss
        do i=1,imx
        do j=1,jmx
          vfc_a(i,j,it)=-9999.
          vfc_b(i,j,it)=-9999.
          vfc_n(i,j,it)=-9999.
        IF(mask(i,j).eq.1) then
          vfc_a(i,j,it)=0.
          vfc_b(i,j,it)=0.
          vfc_n(i,j,it)=0.
          if(kvfc(i,j,it).eq.1) vfc_a(i,j,it)=1
          if(kvfc(i,j,it).eq.-1) vfc_b(i,j,it)=1
          if(kvfc(i,j,it).eq.0) vfc_n(i,j,it)=1
        END IF
        enddo
        enddo
      enddo

c calculate rpss_t and the diff

      call get_rpss_t(prd_b,prd_n,vfc_b,vfc_n,mask,rpss1,imx,jmx,nss)
      write(51,rec=1) rpss1
      call get_rpss_t(prd_b2,prd_n2,vfc_b,vfc_n,mask,rpss2,imx,jmx,
     &nss)
      write(51,rec=2) rpss2
c
      call diff_2d(rpss1,rpss2,mask,df12,imx,jmx)
      write(51,rec=3) df12
c have 2d avg of skill
      call avg_2d(rpss1,mask,coslat,imx,jmx,sk1m)
      call avg_2d(rpss2,mask,coslat,imx,jmx,sk2m)
      sk12df=sk1m-sk2m !area averaged diff (v2-v1)
      write(6,*) 'avg skill of v1 & v2=',sk2m,sk1m,'v2-v1=',sk12df
c
c Randomly sampling for significant test
      DO is=1,nsp
c have random #
      ii=is
      do ib=1,nblk
         ran(ib)=ran1(ii)
         rdx(ib)=ib
c        print*, 'rdx=',rdx(ira),'ran=',ran(ira)
      end do
      call hpsort(nblk,nblk,ran,rdx)
         do ib=1,nblk
c        print*, 'rdx=',rdx(ib),'ran=',ran(ib)
         enddo
      do ib=1,nblk
        idx(ib)=rdx(ib)
c       print*, 'idx=',idx(ib),'ran=',ran(ib)
      enddo
c re-arrange data
      
      do i=1,imx
      do j=1,jmx
        it=0
        do ib=1,nblk
        its=(idx(ib)-1)*lb+1
        ite=idx(ib)*lb
c       print*,'its=',its,'ite=',ite
        do itb=its,ite
        it=it+1
        w3d1(i,j,it)=prd_b(i,j,itb)
        w3d2(i,j,it)=prd_n(i,j,itb)
        w3d3(i,j,it)=prd_b2(i,j,itb)
        w3d4(i,j,it)=prd_n2(i,j,itb)
        enddo
        enddo
      enddo
      enddo

      call get_rpss_t(w3d1,w3d2,vfc_b,vfc_n,mask,wk1,imx,jmx,nss)
      call get_rpss_t(w3d3,w3d4,vfc_b,vfc_n,mask,wk2,imx,jmx,nss)
      call diff_2d(wk1,wk2,mask,wk3,imx,jmx)
c
      do i=1,imx
      do j=1,jmx
        skt1(i,j,is)=wk1(i,j)
        skt2(i,j,is)=wk2(i,j)
        dfmc(i,j,is)=wk3(i,j)
      enddo
      enddo

      call avg_2d(wk1,mask,coslat,imx,jmx,avgskt1(is))
      call avg_2d(wk2,mask,coslat,imx,jmx,avgskt2(is))

      END DO           !loop nsp

c make skt1, skt2 and dfmc in order for each grid
      npass1=0
      npass2=0
      npass3=0
      ntotal=0
      do i=1,imx
      do j=1,jmx

        wk1(i,j)=-9999.0
        wk2(i,j)=-9999.0
        wk3(i,j)=-9999.0
        nsig1(i,j)=-99.0
        nsig2(i,j)=-99.0
        ndf12(i,j)=-99.0

        IF(mask(i,j).eq.1) then

        ntotal=ntotal+1

        do is=1,nsp
          w1d1(is)=skt1(i,j,is)
          w1d2(is)=is
          w1d3(is)=skt2(i,j,is)
          w1d4(is)=is
          w1d5(is)=dfmc(i,j,is)
          w1d6(is)=is
        end do
c       write(6,*) 'rdx=',rdx
c       write(6,*) 'w1d1=',w1d1
        call hpsort(nsp,nsp,w1d1,w1d2)
        call hpsort(nsp,nsp,w1d3,w1d4)
        call hpsort(nsp,nsp,w1d5,w1d6)
        do is=1,nsp
c       print*, 'rdx=',w1d2(is),'w1d1=',w1d1(is)
        enddo
        wk1(i,j)=w1d1(nbnd)
        wk2(i,j)=w1d3(nbnd)
        wk3(i,j)=w1d5(nbnd)

        if(rpss1(i,j).gt.w1d1(nbnd)) then
        nsig1(i,j)=1
        npass1=npass1+1
        end if

        if(rpss2(i,j).gt.w1d3(nbnd)) then
        nsig2(i,j)=1
        npass2=npass2+1
        end if

        if(df12(i,j).gt.w1d5(nbnd)) then
        ndf12(i,j)=1
        npass3=npass3+1
        end if

        END IF

      enddo
      enddo

      print*, 'passed grids and total=',npass2,npass1,npass3,ntotal
c
c make 1-D avgskt1 and avgskt2 in order
      do is=1,nsp
        w1d1(is)=avgskt1(is)
        w1d2(is)=is
        w1d3(is)=avgskt2(is)
        w1d4(is)=is
        w1d5(is)=avgskt1(is)-avgskt2(is)
        w1d6(is)=is
      enddo

      call hpsort(nsp,nsp,w1d1,w1d2)
      call hpsort(nsp,nsp,w1d3,w1d4)
      call hpsort(nsp,nsp,w1d5,w1d6)

      print*, 'upbnd rpss v12&df:',w1d3(nbnd),w1d1(nbnd),w1d5(nbnd)

      print*, 'Highest RPSS in all=',w1d3(nsp),w1d1(nsp),w1d5(nsp)

      call stat_1d(nsp,w1d1,avg1,std1)
      call stat_1d(nsp,w1d3,avg2,std2)
      call stat_1d(nsp,w1d5,avg3,std3)
      print*,'ensav1&2&df=',avg2,avg1,avg3,'std1&2&df=',std2,std1,std3

      call locator_1d(nsp,sk1m,w1d1,nrank1)
      call locator_1d(nsp,sk2m,w1d3,nrank2)
      call locator_1d(nsp,sk12df,w1d5,nrank3)
      print*, 'ranking of v1&2&df=',nrank2,nrank1,nrank3

      write(51,rec=4) wk1   !upper bnd of 95% for v2
      write(51,rec=5) wk2   !upper bnd of 95% for v1
      write(51,rec=6) wk3   !upper bnd of 95% for v2-v1
      write(51,rec=7) nsig1 !significant mask for v2
      write(51,rec=8) nsig2 !significant mask for v1
      write(51,rec=9) ndf12 !significant mask for v2-v1

      stop
      end
        
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  real 2 integer
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine real_2_itg(wk,mw,m,n)
      dimension wk(m,n),mw(m,n)
c
      do i=1,m
      do j=1,n
      mw(i,j)=wk(i,j)
      end do
      end do
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  avg over conus
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine avg_2d(fin,mask,coslat,m,n,ot)
      dimension fin(m,n),mask(m,n),coslat(n)
      ot=0.
      area=0.
      do i=1,m
      do j=1,n
        if(mask(i,j).eq.1) then
        ot=ot+fin(i,j)*coslat(j)
        area=area+coslat(j)
        end if
      enddo
      enddo
      ot=ot/area
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  locate a data in a 1d array
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine locator_1d(n,xx,f,mot)
      dimension f(n)
c
      nmet=0
      do i=1,n-1
      if(xx.gt.f(i).and.xx.lt.f(i+1)) then
      nmet=nmet+1
      mot=i
      end if
      enddo
      if(nmet.eq.0) then
        write(6,*) 'the data is beyond the range of the array'
        mot=n+1
      end if
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  avg and stadv of 1d data fin
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine stat_1d(n,fin,avg,std)
      dimension fin(n)
c
      avg=0.
      do j=1,n
      avg=avg+fin(j)
      end do
      avg=avg/float(n)
c
      std=0.
      do j=1,n
      std=std+(fin(j)-avg)*(fin(j)-avg)
      end do
      std=sqrt(std/float(n))
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  chang num of verification to -1,0,+1,9
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine change_numb(mw,m,n)
      dimension mw(m,n)
c
      do i=1,m
      do j=1,n
      if(mw(i,j).eq.0) mw(i,j)=9
      if(mw(i,j).eq.1) mw(i,j)=-1
      if(mw(i,j).eq.2) mw(i,j)=0
      if(mw(i,j).eq.3) mw(i,j)=1
      end do
      end do
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero2(a,m,n)
      real a(m,n)
c
      do i=1,m
      do j=1,n
        a(i,j)=0.
      end do
      end do
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero(a,n)
      real a(n)
      do 5 i=1,n
      a(i)=0.
  5   continue
      return
      end

      SUBROUTINE terc102(t,a,b,it3) 
c* transforms 102 temperatures into 102 terciled values 
      DIMENSION t(102),it3(102) 
      DO 11 i=1,102 
      icd=i 
      IF (t(icd).le.b)it3(i)=-1 
      IF (t(icd).ge.a)it3(i)=1 
      IF (t(icd).lt.a.and.t(icd).gt.b)it3(i)=0 
11    CONTINUE 
      RETURN 
      END 
c
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  have rpss in time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE get_rpss_t(prdb,prdn,vfcb,vfcn,mask,rpsst,imx,jmx,nss)
      DIMENSION prdb(imx,jmx,nss),prdn(imx,jmx,nss)
      DIMENSION vfcb(imx,jmx,nss),vfcn(imx,jmx,nss)
      DIMENSION rps(imx,jmx,nss),rpsc(imx,jmx,nss),rpsst(imx,jmx)
      DIMENSION exp_rpst(imx,jmx),exp_rpsct(imx,jmx)
      DIMENSION mask(imx,jmx)
c have rps
      do it=1,nss
        do i=1,imx
        do j=1,jmx
          rps(i,j,it)=-9999.
        IF(mask(i,j).eq.1) then
          y1=prdb(i,j,it)
          y2=prdb(i,j,it)+prdn(i,j,it)
          y3=1.
          o1=vfcb(i,j,it)
          o2=vfcb(i,j,it)+vfcn(i,j,it)
          o3=1.
          rps(i,j,it)=(y1-o1)**2
     &+(y2-o2)**2   !rps
          rpsc(i,j,it)=(1./3.-o1)**2
     &+(2./3.-o2)**2   !rpsc
        END IF
        enddo
        enddo
      enddo
c have spatial pattern of temporally averaged rps
      do i=1,imx
      do j=1,jmx
        exp_rpst(i,j)=-9999.
        exp_rpsct(i,j)=-9999.
        IF(mask(i,j).eq.1) then
        exp=0.
        expc=0.
        grd=0
        do it=1,nss
            exp=exp+rps(i,j,it)
            expc=expc+rpsc(i,j,it)
            grd=grd+1
        enddo
        exp_rpst(i,j)=exp/grd
        exp_rpsct(i,j)=expc/grd
      END IF
      enddo
      enddo
c have rpss
      do i=1,imx
      do j=1,jmx
        rpsst(i,j)=-9999.
        IF(mask(i,j).eq.1) then
        rpsst(i,j)=1.-exp_rpst(i,j)/exp_rpsct(i,j)
        END IF
      enddo
      enddo
c
      return 
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  diff between two 2d arrays with mask
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine diff_2d(w1,w2,mask,df,imx,jmx)
      dimension w1(imx,jmx),w2(imx,jmx)
      dimension mask(imx,jmx),df(imx,jmx)

      do i=1,imx
      do j=1,jmx

      df(i,j)=-9999.
      IF(mask(i,j).eq.1) then
      df(i,j)=w1(i,j)-w2(i,j)
      END IF

      enddo
      enddo
c
      return
      end

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
