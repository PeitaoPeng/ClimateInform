CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  relative vort  over Gausssian grids
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE RLVORT(xin,yin,out)
      parameter(nlong=128,nlatg=102) 
      parameter(nlongw=nlong+2,nlatgw=nlatg+2) 
      COMMON/GAUSS/RADG(nlatg),GWGT(nlatg)
      dimension xin(nlong,nlatg),yin(nlong,nlatg)
      dimension out(nlong,nlatg)
      dimension workx(nlongw,nlatg)
      dimension worky(nlong,nlatgw)
      dimension coslat(nlatg)
      dimension wcos(nlatgw),wlat(nlatgw)
      r=6.37e+06
      pi=acos(-1.0)
      dlat=2*pi/nlong
         do 200 j=1,nlatg
         do 200 i=1,nlong
         workx(i+1,j)=yin(i,j)
         worky(i,j+1)=xin(i,j)
  200 continue
      do 300 j=1,nlatg 
         coslat(j)=cos(RADG(j))
         workx(1,j)=yin(nlong,j)
         workx(nlongw,j)=yin(1,j)
  300 continue
      do 400 i=1,nlong 
         worky(i,1)=0.
         worky(i,nlatgw)=0.
  400 continue
      do 450 j=1,nlatg
         wcos(j+1)=coslat(j)
         wlat(j+1)=RADG(j)   
  450 continue
         wcos(1)=0.
         wcos(nlatgw)=0.
         wlat(1)=pi/2.
         wlat(nlatgw)=-pi/2.
      do 520 j=1,nlatg
      do 520 i=1,nlong
         dx=(workx(i+2,j)-workx(i,j))/
     1      (r*coslat(j)*2*dlat)
         dy=(wcos(j+2)*worky(i,j+2)-wcos(j)*worky(i,j))
     1      /(r*wcos(j+1)*(wlat(j+2)-wlat(j)))
         out(i,j)=dx-dy
  520 continue
      return
      end

