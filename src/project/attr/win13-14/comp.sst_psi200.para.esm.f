      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C comp based on similar psi200
C===========================================================
      real xlat(jmx),coslat(jmx),cosr(jmx)
      dimension cry(nyr)
      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx2,jmx2),w2d4(imx2,jmx2)
      real z4d(imx,jmx,5,nyr),t4d(imx2,jmx2,5,nyr)
      real z3d(imx,jmx,nyr),t3d(imx2,jmx2,nyr)
      real cr1d(500)
C
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(12,form='unformatted',access='direct',recl=4*imx2*jmx2) 
c
      open(50,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(60,form='unformatted',access='direct',recl=4*imx2*jmx2) 
      open(70,form='unformatted',access='direct',recl=4) 
C
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-87.864+(j-1)*2.78933
        coslat(j)=cos(xlat(j)*3.14159/180)
      enddo
c
c read in ndjfm psi200 data
      ir=0
      do iy=1,nyr
        do im=1,nmon
        ir=ir+1
        read(11,rec=ir) w2d 
        do i=1,imx
        do j=1,jmx
          z4d(i,j,im,iy)=w2d(i,j)
        enddo
        enddo
       enddo !im loop
      enddo ! iy loop
c read in nmon-month sst data
      ir=0
      do iy=1,nyr
        do im=1,nmon
        ir=ir+1
        read(12,rec=ir) w2d3 
        do i=1,imx2
        do j=1,jmx2
          t4d(i,j,im,iy)=w2d3(i,j)
        enddo
        enddo
       enddo !im loop
      enddo ! iy loop
c average djfm data for both psi200 and sst
      do iy=1,nyr

      call setzero(w2d,imx,jmx)
      call setzero(w2d3,imx2,jmx2)

        do i=1,imx
        do j=1,jmx
          do im=2,5
          w2d(i,j)=w2d(i,j)+z4d(i,j,im,iy)/4.
          enddo
          z3d(i,j,iy)=w2d(i,j)
        enddo
        enddo

        do i=1,imx2
        do j=1,jmx2
          do im=2,5
          w2d3(i,j)=w2d3(i,j)+t4d(i,j,im,iy)/4.
          enddo
          t3d(i,j,iy)=w2d3(i,j)
        enddo
        enddo
      enddo !iy loop

c pattern cor of 2013/14 to past winter data
c take 2013/14 field
      do i=1,imx
      do j=1,jmx
        w2d(i,j)=z3d(i,j,nyr)
      enddo
      enddo
      
      iyear=1949
      do iy=1,nyr-1
c take second field
        do i=1,imx
        do j=1,jmx
          w2d2(i,j)=z3d(i,j,iy)
        enddo
        enddo

c pattern corr
      call ptcor(w2d,w2d2,imx,jmx,lons,lone,lats,late,coslat,cry(iy))
 
      write(6,*) 'iy=',iyear,'cr=',cry(iy)

      iyear=iyear+1
      enddo ! iy loop
c composite for Z200 and SST
      call setzero(w2d,imx,jmx)
      call setzero(w2d2,imx,jmx)
      call setzero(w2d3,imx2,jmx2)
      call setzero(w2d4,imx2,jmx2)
      crt=0.6 !criterion of cor
      crtn=-1*crt
      npc=0
      nnc=0
      do iy=1,nyr-1
      if(cry(iy).gt.crt) then
      npc=npc+1
      do i=1,imx
      do j=1,jmx
      w2d(i,j)=w2d(i,j)+z3d(i,j,iy)
      enddo
      enddo
      do i=1,imx2
      do j=1,jmx2
      w2d3(i,j)=w2d3(i,j)+t3d(i,j,iy)
      enddo
      enddo
      endif
c
      if(cry(iy).lt.crtn) then
      nnc=nnc+1
      do i=1,imx
      do j=1,jmx
      w2d2(i,j)=w2d2(i,j)+z3d(i,j,iy)
      enddo
      enddo
      do i=1,imx2
      do j=1,jmx2
      w2d4(i,j)=w2d4(i,j)+t3d(i,j,iy)
      enddo
      enddo
      endif
      enddo !iy loop

      write(6,*)'size of positive=',npc,'size of negative=',nnc

      do i=1,imx
      do j=1,jmx
      w2d(i,j)=w2d(i,j)/float(npc)
      w2d2(i,j)=w2d2(i,j)/float(nnc)
      enddo
      enddo
      do i=1,imx2
      do j=1,jmx2
      w2d3(i,j)=w2d3(i,j)/float(npc)
      w2d4(i,j)=w2d4(i,j)/float(nnc)
      enddo
      enddo
c redefine the land-seamask
      do i=1,imx2
      do j=1,jmx2
      if(t3d(i,j,1).lt.-100) then
      w2d3(i,j)=-999
      w2d4(i,j)=-999
      endif
      enddo
      enddo
      write(50,rec=1) w2d
      write(50,rec=2) w2d2
      write(60,rec=1) w2d3
      write(60,rec=2) w2d4
c add 2013/14 data
      do i=1,imx
      do j=1,jmx
      w2d(i,j)=z3d(i,j,nyr)
      enddo
      enddo
      do i=1,imx2
      do j=1,jmx2
      if(t3d(i,j,1).lt.-1000) then
      w2d3(i,j)=-999
      else
      w2d3(i,j)=t3d(i,j,nyr)
      endif
      enddo
      enddo
      write(50,rec=3) w2d
      write(60,rec=3) w2d3

      do iy=1,nyr-1
      write(70,rec=iy) cry(iy)
      enddo

      stop
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  count the # of persistency for each array of corr
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ptcount(cr,ct,n,ip)
      dimension cr(n,n),ip(n)
c
      do i=1,n
        ip(i)=0
      enddo

      do i=1,n
      if(cr(1,i).ge.ct.and.cr(2,i).ge.ct.and.cr(3,i).ge.ct.and.
     &cr(4,i).ge.ct) then
      ip(4)=ip(4)+1
      else if(cr(1,i).ge.ct.and.cr(2,i).ge.ct.and.cr(3,i).ge.ct) then
      ip(3)=ip(3)+1
      else if(cr(2,i).ge.ct.and.cr(3,i).ge.ct.and.cr(4,i).ge.ct) then
      ip(3)=ip(3)+1

      else if(cr(1,i).ge.ct.and.cr(2,i).ge.ct) then
      ip(2)=ip(2)+1
      else if(cr(2,i).ge.ct.and.cr(3,i).ge.ct) then
      ip(2)=ip(2)+1
      else if(cr(3,i).ge.ct.and.cr(4,i).ge.ct) then
      ip(2)=ip(2)+1
      
      else if(cr(1,i).ge.ct) then
      ip(1)=ip(1)+1
      else if(cr(2,i).ge.ct) then
      ip(1)=ip(1)+1
      else if(cr(3,i).ge.ct) then
      ip(1)=ip(1)+1
      else if(cr(4,i).ge.ct) then
      ip(1)=ip(1)+1

      endif
      enddo
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  find the maxmum in a array
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine xmaxm(na,n,mx,kout)
      dimension na(n)
c
      nx=na(1)
      kk=1
      do i=2,n
      if (nx.lt.na(i)) then
        nx=na(i)
        kk=i
      endif
      enddo
      mx=nx !nx+1 months are similar
      kout=kk
c
      return
      end

C pattern corr of two fields
      SUBROUTINE ptcor(reg,fld,imx,jmx,lons,lone,lats,late,coslat,pj)
      DIMENSION reg(imx,jmx),fld(imx,jmx),coslat(jmx)
      pj=0.
      v1=0.
      v2=0.
      do i=lons,lone
      do j=lats,late
      pj=pj+reg(i,j)*fld(i,j)*coslat(j)
      v1=v1+reg(i,j)*reg(i,j)*coslat(j)
      v2=v2+fld(i,j)*fld(i,j)*coslat(j)
      enddo
      enddo
      pj=pj/sqrt(v1*v2)
      return
      end
        
      
      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end

      SUBROUTINE anom(rot,nyr)
      DIMENSION rot(nyr)
      avg=0.
      do i=1,nyr
         avg=avg+rot(i)/float(nyr)
      enddo
      do i=1,nyr
        rot(i)=rot(i)-avg
      enddo
c
      return
      end

      SUBROUTINE normal(rot,rot2,nyr)
      DIMENSION rot(nyr),rot2(nyr)
      avg=0.
      do i=1,nyr
         avg=avg+rot(i)/float(nyr)
      enddo
      do i=1,nyr
        rot2(i)=rot(i)-avg
      enddo
c
      sd=0.
      do i=1,nyr
        sd=sd+rot2(i)*rot2(i)/float(nyr)
      enddo
        sd=sqrt(sd)
      do i=1,nyr
        rot2(i)=rot2(i)/sd
      enddo
      return
      end


      SUBROUTINE mean_std(f,m,n,avg,std)
      real f(m)
      avg=0.
      do i=1,n
        avg=avg+f(i)/float(n)
      enddo
      std=0.
      do i=1,n
      std=std+(f(i)-avg)*(f(i)-avg)/float(n)
      enddo
      std=sqrt(std)
      return
      end

