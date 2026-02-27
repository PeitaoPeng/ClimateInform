*===========================
define zm1=z-z(t=2)-ave(z-z(t=2),lon=0,lon=360,-b)
define zo1=z(t=3)-z(t=2)-ave(z(t=3)-z(t=2),lon=0,lon=360,-b)
define cor=aave(zo1*zm1,lon=150,lon=300,lat=20,lat=70)
define vo=aave(zo1*zo1,lon=150,lon=300,lat=20,lat=70)
define vm=aave(zm1*zm1,lon=150,lon=300,lat=20,lat=70)
define cor1=cor/sqrt(vo*vm)
d cor1
d vo
d vm
*
