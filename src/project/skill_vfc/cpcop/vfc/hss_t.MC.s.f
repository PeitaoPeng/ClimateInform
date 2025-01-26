      subroutine hss_t_MC(prd,vfc,nda,nda2,nsp,hss1,hss2)
CC============================================================
CC In time domain, calculate hss1 and hss2 with randomly re-ordered data
CC ob->obs; pr->prd; nmc->test#; nda->length of data; hsm->mean skill score;
CC sdv->stdv of skill,nsp->sample size;
CC============================================================
      dimension ran(nda)
      integer   vfc(nda),prd(nda),wk(nda)
      integer   idx(nda)
      real      rdx(nda)
      real      hss1(nsp),hss2(nsp)
C
C randolmly re-order data
C
      DO is=1,nsp

c     print*, 'is=',is
c have random #
      nds=(is-1)*nda+1
      nde=is*nda
      ira=0
      ii=is
      do i=nds,nde   !seeds# = nda
c        print*, i
         ira=ira+1
         ran(ira)=ran1(ii)
         rdx(ira)=ira
c        print*, 'rdx=',rdx(ira),'ran=',ran(ira)
      end do
c        print*,'ran=',ran
      call hpsort(nda,nda2,ran,rdx)
         do i=1,nda
c        print*, 'rdx=',rdx(i),'ran=',ran(i)
         enddo
      do i=1,nda
        idx(i)=rdx(i)
      enddo
      do i=1,nda
        wk(i)=vfc(idx(i))
      enddo
      call heidke1_t(prd,wk,hs1,tot1,nda,nda2)
      call heidke2_t(prd,wk,hs2,tot2,nda,nda2)
      hss1(is)=hs1
      hss2(is)=hs2
c     print*, 'hss1=',hs1,'    hss2=',hs2

      END DO           !loop nsp
      
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

      SUBROUTINE ini_ind(n,ind)
      INTEGER n,ind(n)
      do i=1,n
        ind(i)=i
      end do
      return
      end

      subroutine esmavg(fld,fld2,nx,ny,ns)
      real fld(nx,ny,ns),fld2(nx,ny)
      val=0.
      call giving(fld2,val)
      do j=1,nlat
      do i=1,nlon
      do k=1,ns
        fld2(i,j)=fld2(i,j)+fld(i,j,k)/float(ns)
      end do
      end do
      end do
      return
      end

      subroutine giving(fld,val)
      parameter(nlon=48,nlat=40)
      real fld(nlon,nlat)
      do j=1,nlat
      do i=1,nlon
        fld(i,j)=val
      end do
      end do
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
