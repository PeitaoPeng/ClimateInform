      subroutine pls_fcst(ntot,nt,im,jm,is,ie,js,je,mode,
     &f1d,f3d,f2d,pco,pt1,pt2,var,cosl,undef,ID)
C======================================================
C PLS-regression  for dependent variable array f1d(t) and independent
C                 variable matrix f3d(lon,lat,t)
C is,ie,js,je: boundary of area for analysis
C mode: # of predictors to have
C pc: predictors (or latent vectors or pls components)
C pt1: regr pattern from residules 
C pt2: regr pattern from standardized raw data
C cosl: cos(lat)
C undef: undefined value
C var: explained variance by each mode
C id: =1 to standardiz input; =0 not to standardize input
C=====================================================
      dimension f1d(ntot),f2d(im,jm),f3d(im,jm,ntot)
      dimension pc(nt,mode),pt1(im,jm,mode),pt2(im,jm,mode),var(mode)
      dimension pco(mode)
      dimension w1d(nt),w1d2(nt),w1d3(nt),w1d4(nt)
      dimension w2d(im,jm),w2d2(im,jm),w2d3(im,jm)
      dimension w3d(im,jm,nt),w3d2(im,jm,nt)
      dimension cosl(jm)
c
c pass input data to working arrays
      do it=1,nt
        w1d(it)=f1d(it)
        do i=1,im
        do j=1,jm
        w3d(i,j,it)=f3d(i,j,it)
        enddo
        enddo
      enddo
c
c standardize time series
      if(ID.eq.1) then
      call normal(w1d,nt,std)
c     write(6,*) 'w1d=',w1d
      do i=1,im
      do j=1,jm
        if(abs(f3d(i,j,1)).lt.999) then
          do it=1,nt
          w1d2(it)=w3d(i,j,it)
          enddo
          call normal(w1d2,nt,sd)
          do it=1,nt
          w3d(i,j,it)=w1d2(it)
          w3d2(i,j,it)=w1d2(it) !kept for later reg 
          enddo
          w2d3(i,j)=f2d(i,j)/sd !standardize IC
        endif
      enddo
      enddo
      endif
c
c starting the pls loop
      DO m=1,mode

c have correlation pattern
        do i=1,im
        do j=1,jm
        if(abs(f3d(i,j,1)).lt.999) then
          do it=1,nt
            w1d2(it)=w3d(i,j,it)
          enddo
          call cor_reg(nt,w1d,w1d2,cor,reg)
          w2d(i,j)=cor
        else
          w2d(i,j)=undef
        endif
        enddo
        enddo
c     write(6,*) 'w2d=',w2d
c project 2-d pattern to the 3-d data to have time series
        do it=1,nt
          do i=1,im
          do j=1,jm
            w2d2(i,j)=w3d(i,j,it)
          enddo
          enddo
          call sp_proj(w2d,w2d2,im,jm,is,ie,js,je,cosl,pj)
          w1d2(it)=pj
        enddo
c projection to sstic
          call sp_proj(w2d,w2d3,im,jm,is,ie,js,je,cosl,pj)
          pcp=pj
c
c have reg pattern with standardized predictor
        call normal(w1d2,nt,sd)
c
        pcp=pcp/sd
c
        do i=1,im
        do j=1,jm
        if(abs(f3d(i,j,1)).lt.999) then
          do it=1,nt
            w1d3(it)=w3d(i,j,it)  !residule
            w1d4(it)=w3d2(i,j,it) !standardized tot
          enddo
          call cor_reg(nt,w1d2,w1d3,cor,reg)
          call cor_reg(nt,w1d2,w1d4,cor2,reg2)
          w2d(i,j)=reg
          w2d2(i,j)=reg2
        else
          w2d(i,j)=undef
          w2d2(i,j)=undef
        endif
        pt1(i,j,m)=w2d(i,j)
        pt2(i,j,m)=w2d2(i,j)
        enddo
        enddo
c regress out z from Y and X
        call cor_reg(nt,w1d2,w1d,cor,reg)
        do it=1,nt
          w1d(it)=w1d(it)-w1d2(it)*reg
        enddo
c
        do i=1,im
        do j=1,jm
        if(abs(f3d(i,j,1)).lt.999) then
          do it=1,nt
            w3d(i,j,it)=w3d(i,j,it)-w1d2(it)*w2d(i,j)
          enddo
            w2d3(i,j)=w2d3(i,j)-pcp*w2d(i,j)
        else
          do it=1,nt
            w3d(i,j,it)=undef
          enddo
            w2d3(i,j)=undef
        endif
        enddo
        enddo
c explained variance by mode m
        do it=1,nt
          w1d3(it)=f1d(it)
        enddo
        call cor_reg(nt,w1d2,w1d3,cor,reg)
        var(m)=cor*cor
        do it=1,nt
          pc(it,m)=w1d2(it)*reg
        enddo
          pco(m)=pcp*reg
c
      ENDDO ! mode loop
c
c re-order modes according to var
c
c sort array var from highest to lowest
      do 300 m=1,mode
      k=m
      p=var(m)
      ip1=m+1
      if(ip1.gt.mode) go to 260
      do 250 j=ip1,mode
      if(var(j).le.p) go to 250
      k=j
      p=var(j)
 250  continue
 260  if(k.eq.m) go to 300
c re-order var
      var(k)=var(m)
      var(m)=p
c re-order pco
      c0=pco(m)
      pco(m)=pco(k)
      pco(k)=c0
c re-order pc
      do 275 j=1,nt
      c1=pc(j,m)
      pc(j,m)=pc(j,k)
      pc(j,k)=c1
 275  continue
      do 280 i=1,im
      do 280 j=1,jm
      p=pt1(i,j,m)
      pt1(i,j,m)=pt1(i,j,k)
      pt1(i,j,k)=p
 280  continue
      do 285 i=1,im
      do 285 j=1,jm
      p=pt2(i,j,m)
      pt2(i,j,m)=pt2(i,j,k)
      pt2(i,j,k)=p
 285  continue
 300  continue
c
      return
      end

      subroutine normal(ts,nt,x)
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
      subroutine cor_reg(n,ts1,ts2,cor,reg)
      dimension ts1(n),ts2(n)
      x=0.
      y=0.
      xy=0.
      do it=1,n
      x=x+ts1(it)*ts1(it)
      y=y+ts2(it)*ts2(it)
      xy=xy+ts1(it)*ts2(it)
      enddo
c
      x=x/float(n)
      y=y/float(n)
      xy=xy/float(n)
c
      cor=xy/(sqrt(x)*sqrt(y))
      reg=xy/(sqrt(x))
      return
      end

      subroutine sp_proj(f1,f2,im,jm,ims,ime,jms,jme,cosl,pj)
      dimension f1(im,jm),f2(im,jm)
      dimension cosl(jm)
      z=0.
      w=0.
      do i=ims,ime
      do j=jms,jme
      cosw=cosl(j)
      if(abs(f1(i,j)).gt.999.or.abs(f2(i,j)).gt.999) go to 123
      w=w+cosw
      z=z+f1(i,j)*f2(i,j)*cosw
  123 continue
      enddo
      enddo
      pj=z/w
      return
      end
