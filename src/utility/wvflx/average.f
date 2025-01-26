CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  2-D global average over Gausssian grids
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine AVERAGE(fin,out)
      parameter(nlong=128,nlatg=102)
      parameter(nlatgw=nlatg+2)
      COMMON/GAUSS/RADG(nlatg),GWGT(nlatg)
      dimension fin(nlong,nlatg)
      dimension xlat(nlatgw)
      pi=acos(-1.0)
      dlon=2*pi/128.
      fpi=4.*pi
      do 100 j=1,nlatg
         xlat(j+1)=RADG(j)
  100 continue
         xlat(1)=pi/2.
         xlat(nlatgw)=-pi/2.
      out=0.
      do 200 j=1,nlatg+1
      rad=0.5*(xlat(j)+xlat(j+1))
      dlat=xlat(j)-xlat(j+1)
      do 200 i=1,nlong
         fild=0.5*(fin(i,j)+fin(i,j+1))
         out=out+fild*cos(rad)*dlon*dlat/fpi
  200 continue
      return
      end
 

