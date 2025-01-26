'set t 1 181'
'define v1=nec.4'
'define v2=hs1.4'
'set t 1'
'define xb=ave(v1,t=1,t=181)'
'define yb=ave(v2,t=1,t=181)'
'define xx=sqrt(ave((v1-xb)*(v1-xb),t=1,t=181))'
'define yy=sqrt(ave((v2-yb)*(v2-yb),t=1,t=181))'
'define xy=ave((v1-xb)*(v2-yb),t=1,t=181)'
'define cor=xy/(xx*yy)'


