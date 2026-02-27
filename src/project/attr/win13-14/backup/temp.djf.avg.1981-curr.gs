'open /cpc/home/ebecker/ghcn_cams/ghcn_cams_0.5_grb.ctl'
'set gxout fwrite'
'set fwrite t2m.djf.1981-curr.gr'
'set x 1 720'
'set y 1 360'
'set t 1 12'
'define tc=ave(tmp2m,t+396,t=756,1yr)'
'modify tc seasonal'
'set t 1'
k=395
while(k<=795)
ks=k+1
ke=k+3
'd ave(tmp2m-tc,t='ks',t='ke')'
k=k+12
endwhile
