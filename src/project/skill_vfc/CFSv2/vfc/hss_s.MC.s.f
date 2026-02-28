      subroutine hss_s_MC(mask,prd,vfc,coslat,imx,jmx,nsp,hss1,hss2)
CC============================================================
CC In space domain, calculate hss1 and hss2 with randomly re-ordered data
CC ob->obs; pr->prd; nmc->test#; nda->length of data; hsm->mean skill score;
CC sdv->stdv of skill,nsp->sample size;
CC============================================================
      parameter(nar=500)
      dimension ran(nar)
      integer   mask(imx,jmx),vfc(imx,jmx),prd(imx,jmx)
      integer   wk1(nar),wk2(nar),wk3(nar)
      integer   idx(nar)
      real      rdx(nar)
      real      coslat(jmx),hss1(nsp),hss2(nsp)

C have 1-d data set for prd and vfc
      nda=0.
      do i=1,imx
      do j=1,jmx
      IF(mask(i,j).eq.1) then
        nda=nda+1
        wk1(nda)=prd(i,j)
        wk2(nda)=vfc(i,j)
      END IF
      enddo
      enddo

c     print*, 'nda=',nda

      DO is=1,nsp
c have random #
      nds=(is-1)*nda+1
      nde=is*nda
      ira=0
      do i=nds,nde   !seeds# = nda
c        print*, i
         ira=ira+1
         ran(ira)=ran1(i)
         rdx(ira)=ira
c        print*, 'rdx=',rdx(ira),'ran=',ran(ira)
      end do
      call hpsort(nar,nda,ran,rdx)
         do i=1,nda
c        print*, 'rdx=',rdx(i),'ran=',ran(i)
         enddo
      do i=1,nda
        idx(i)=rdx(i)
      enddo
      do i=1,nda
        wk3(i)=wk2(idx(i))
      enddo
      call heidke1_t(wk1,wk3,hs1,tot1,nar,nda)
      call heidke2_t(wk1,wk3,hs2,tot2,nar,nda)
      hss1(is)=hs1
      hss2(is)=hs2
c     print*, 'hss1=',hs1,'    hss2=',hs2

      END DO           !loop nsp
      
      return
      end

