      subroutine hss_s_MC(mask,prd,vfc,coslat,imx,jmx,nsp,hss1,hss2)
CC============================================================
CC In space domain, calculate hss1 and hss2 with randomly re-ordered data
CC ob->obs; pr->prd; nmc->test#; nda->length of data; hsm->mean skill score;
CC sdv->stdv of skill,nsp->sample size;
CC============================================================
      parameter(nar=75000)
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
c     print*, 'nsp=',nsp

      DO js=1,nsp
c     print*, 'js=',js
c have random #
      nds=(js-1)*nda+1
      nde=js*nda
c     print*, 'nds=',nds, '  nde=',nde
      ira=0
      ii=js
      do i=nds,nde 
c     print*, 'nds=',nds, '  nde=',nde
c        print*, 'i=',i
         ira=ira+1
         ran(ira)=ran1(ii)
         rdx(ira)=ira
c        print*, 'rdx=',rdx(ira),'ran=',ran(ira)
      end do
c
      call hpsort(nar,nda,ran,rdx)
c
      do i=1,nda
        idx(i)=rdx(i)
      enddo
c
      do i=1,nda
        wk3(i)=wk2(idx(i))
      enddo
c
      call heidke1_t(wk1,wk3,hs1,tot1,nar,nda)
      call heidke2_t(wk1,wk3,hs2,tot2,nar,nda)
      hss1(js)=hs1
      hss2(js)=hs2
c     print*, 'hss1=',hs1,'    hss2=',hs2

      ENDDO           !loop js
      
      return
      end


