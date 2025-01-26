'open /cpc/analysis/cdas/bulletin/cams_opi_v0208/data/t.ctl'
'set gxout fwrite'
'set fwrite prate.djfm.1981-curr.gr'
'set x 1 144'
'set y 1 72'
'set t 1 12'
'define pc=ave(opi,t+24,t=384,1yr)'
'modify pc seasonal'
'set t 1'
k=23
while(k<=423)
ks=k+1
ke=k+4
'd ave(opi-pc,t='ks',t='ke')'
k=k+12
endwhile
