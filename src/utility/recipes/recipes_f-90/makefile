.SUFFIXES:
.SUFFIXES: .reslt .res .out .o .f90 .for .f
# Numerical Recipes makefile for Fortran 90
NRROOT=/recipes/recipes_f-90
# Edit this to be correct on your system
NRF90DIR=$(NRROOT)/recipes
NRXF90DIR=$(NRROOT)/demo/src
NRRESPDIR=$(NRROOT)/demo/responses
VPATH=$(NRF90DIR):$(NRXF90DIR):$(NRRESPDIR)
NRDAT=$(NRROOT)/demo/data
F90=f90
#F90OPTS=-check bounds -check format -check nounderflow -warn declarations -warn argument_checking
#F90OPTS=""
# DEC options used - edit to suit


all : dat objects \
xairy.reslt xamebsa.reslt xamoeba.reslt xanneal.reslt xarcode.reslt \
xavevar.reslt xbalanc.reslt xbandec.reslt xbanmul.reslt xbcucof.reslt \
xbcuint.reslt xbeschb.reslt xbessik.reslt xbnldev.reslt xbrent.reslt \
xbroydn.reslt xbsstep.reslt xcaldat.reslt xchder.reslt xchebev.reslt \
xchebft.reslt xchebpc.reslt xchint.reslt xcholsl.reslt xchsone.reslt \
xchstwo.reslt xcisi.reslt xcntab1.reslt xcntab2.reslt xconvlv.reslt \
xcorrel.reslt xcosft1.reslt xcosft2.reslt xcovsrt.reslt xcyclic.reslt \
xdbrent.reslt xddpoly.reslt xdecchk.reslt xdf1dim.reslt xdfpmin.reslt \
xdfridr.reslt xdftint.reslt xeclass.reslt xeclazz.reslt xeigsrt.reslt \
xelmhes.reslt xeulsum.reslt xevlmem.reslt xexpdev.reslt xf1dim.reslt \
xfasper.reslt xfgauss.reslt xfit.reslt xfitexy.reslt xfixrts.reslt \
xfleg.reslt xflmoon.reslt xfour1.reslt xfpoly.reslt xfred2.reslt \
xfredin.reslt xfrenel.reslt xfrprmn.reslt xftest.reslt xgamdev.reslt \
xgasdev.reslt xgaucof.reslt xgauher.reslt xgaujac.reslt xgaulag.reslt \
xgauleg.reslt xgaussj.reslt xgolden.reslt xhqr.reslt xhuffman.reslt \
xhunt.reslt xhypgeo.reslt xicrc.reslt xigray.reslt xirbit1.reslt \
xirbit2.reslt xjacobi.reslt xjulday.reslt xkendl1.reslt xkendl2.reslt \
xks2d1s.reslt xks2d2s.reslt xksone.reslt xkstwo.reslt xlaguer.reslt \
xlfit.reslt xlinbcg.reslt xlinmin.reslt xlocate.reslt xlubksb.reslt \
xludcmp.reslt xmachar.reslt xmedfit.reslt xmemcof.reslt xmgfas.reslt \
xmglin.reslt xmidpnt.reslt xmiser.reslt xmmid.reslt xmnbrak.reslt \
xmnewt.reslt xmoment.reslt xmppi.reslt xmprove.reslt xmrqmin.reslt \
xnewt.reslt xodeint.reslt xorthog.reslt xpade.reslt xpccheb.reslt \
xpcshft.reslt xpearsn.reslt xperiod.reslt xpoidev.reslt xpolcoe.reslt \
xpolcof.reslt xpoldiv.reslt xpolin2.reslt xpolint.reslt xpowell.reslt \
xpredic.reslt xprobks.reslt xpsdes.reslt xpzextr.reslt xqrdcmp.reslt \
xqromo.reslt xqroot.reslt xqrsolv.reslt xqrupdt.reslt xquad3d.reslt \
xran.reslt xrank.reslt xratint.reslt xrealft.reslt xrk4.reslt \
xrkdumb.reslt xrkqs.reslt xrlft3.reslt xrzextr.reslt xsavgol.reslt \
xscrsho.reslt xsimpr.reslt xsinft.reslt xsncndn.reslt xsobseq.reslt \
xsor.reslt xsort2.reslt xsort3.reslt xspctrm.reslt xspear.reslt \
xsphfpt.reslt xsplie2.reslt xsplin2.reslt xspline.reslt xsplint.reslt \
xstifbs.reslt xstiff.reslt xstoerm.reslt xsvbksb.reslt xsvdcmp.reslt \
xsvdfit.reslt xsvdvar.reslt xtoeplz.reslt xtptest.reslt xtqli.reslt \
xtrapzd.reslt xtred2.reslt xtridag.reslt xttest.reslt xtutest.reslt \
xtwofft.reslt xvander.reslt xvegas.reslt xvoltra.reslt xwt1.reslt \
xwtn.reslt xzbrac.reslt xzbrak.reslt xzrhqr.reslt xzroots.reslt


# Dependencies for recipes object files
airy.o: nrtype.o nr.o $(NRF90DIR)/airy.f90
amebsa.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/amebsa.f90
amoeba.o: nrtype.o nrutil.o $(NRF90DIR)/amoeba.f90
anneal.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/anneal.f90
arcmak.o: nrtype.o nrutil.o $(NRF90DIR)/arcmak.f90
arcode.o: nrtype.o nrutil.o arcmak.o $(NRF90DIR)/arcode.f90
asolve.o: nrtype.o nrutil.o nr.o xlinbcg.o $(NRF90DIR)/asolve.f90
atimes.o: nrtype.o nrutil.o nr.o xlinbcg.o $(NRF90DIR)/atimes.f90
avevar.o: nrtype.o $(NRF90DIR)/avevar.f90
badluk.o: nrtype.o nr.o $(NRF90DIR)/badluk.f90
balanc.o: nrtype.o nrutil.o $(NRF90DIR)/balanc.f90
banbks.o: nrtype.o nrutil.o $(NRF90DIR)/banbks.f90
bandec.o: nrtype.o nrutil.o $(NRF90DIR)/bandec.f90
banmul.o: nrtype.o nrutil.o $(NRF90DIR)/banmul.f90
bcucof.o: nrtype.o $(NRF90DIR)/bcucof.f90
bcuint.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bcuint.f90
beschb.o: nrtype.o nr.o $(NRF90DIR)/beschb.f90
bessi.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bessi.f90
bessi0.o: nrtype.o nrutil.o $(NRF90DIR)/bessi0.f90
bessi1.o: nrtype.o nrutil.o $(NRF90DIR)/bessi1.f90
bessik.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bessik.f90
bessj.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bessj.f90
bessj0.o: nrtype.o nrutil.o $(NRF90DIR)/bessj0.f90
bessj1.o: nrtype.o nrutil.o $(NRF90DIR)/bessj1.f90
bessjy.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bessjy.f90
bessk.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bessk.f90
bessk0.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bessk0.f90
bessk1.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bessk1.f90
bessy.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bessy.f90
bessy0.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bessy0.f90
bessy1.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bessy1.f90
beta.o: nrtype.o nr.o nrutil.o $(NRF90DIR)/beta.f90
betacf.o: nrtype.o nrutil.o $(NRF90DIR)/betacf.f90
betai.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/betai.f90
bico.o: nrtype.o nr.o nrutil.o $(NRF90DIR)/bico.f90
bnldev.o: nrtype.o nr.o $(NRF90DIR)/bnldev.f90
brent.o: nrtype.o nrutil.o $(NRF90DIR)/brent.f90
broydn.o: nrtype.o nrutil.o nr.o fmin.o $(NRF90DIR)/broydn.f90
bsstep.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/bsstep.f90
caldat.o: nrtype.o $(NRF90DIR)/caldat.f90
chder.o: nrtype.o nrutil.o $(NRF90DIR)/chder.f90
chebev.o: nrtype.o nrutil.o $(NRF90DIR)/chebev.f90
chebft.o: nrtype.o nrutil.o $(NRF90DIR)/chebft.f90
chebpc.o: nrtype.o $(NRF90DIR)/chebpc.f90
chint.o: nrtype.o nrutil.o $(NRF90DIR)/chint.f90
chixy.o: nrtype.o nrutil.o $(NRF90DIR)/chixy.f90
choldc.o: nrtype.o nrutil.o $(NRF90DIR)/choldc.f90
cholsl.o: nrtype.o nrutil.o $(NRF90DIR)/cholsl.f90
chsone.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/chsone.f90
chstwo.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/chstwo.f90
cisi.o: nrtype.o nrutil.o $(NRF90DIR)/cisi.f90
cntab1.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/cntab1.f90
cntab2.o: nrtype.o $(NRF90DIR)/cntab2.f90
convlv.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/convlv.f90
correl.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/correl.f90
cosft1.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/cosft1.f90
cosft2.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/cosft2.f90
covsrt.o: nrtype.o nrutil.o $(NRF90DIR)/covsrt.f90
cyclic.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/cyclic.f90
daub4.o: nrtype.o $(NRF90DIR)/daub4.f90
dawson.o: nrtype.o nrutil.o $(NRF90DIR)/dawson.f90
dbrent.o: nrtype.o nrutil.o $(NRF90DIR)/dbrent.f90
ddpoly.o: nrtype.o nrutil.o $(NRF90DIR)/ddpoly.f90
decchk.o: nrtype.o nrutil.o $(NRF90DIR)/decchk.f90
dfpmin.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/dfpmin.f90
dfridr.o: nrtype.o nrutil.o $(NRF90DIR)/dfridr.f90
dftcor.o: nrtype.o nrutil.o $(NRF90DIR)/dftcor.f90
dftint.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/dftint.f90
difeq.o: nrtype.o sfroid.o $(NRF90DIR)/difeq.f90
dlinmin.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/dlinmin.f90
eclass.o: nrtype.o nrutil.o $(NRF90DIR)/eclass.f90
eclazz.o: nrtype.o nrutil.o $(NRF90DIR)/eclazz.f90
ei.o: nrtype.o nrutil.o $(NRF90DIR)/ei.f90
eigsrt.o: nrtype.o nrutil.o $(NRF90DIR)/eigsrt.f90
elle.o: nrtype.o nr.o nrutil.o $(NRF90DIR)/elle.f90
ellf.o: nrtype.o nr.o nrutil.o $(NRF90DIR)/ellf.f90
ellpi.o: nrtype.o nr.o $(NRF90DIR)/ellpi.f90
elmhes.o: nrtype.o nrutil.o $(NRF90DIR)/elmhes.f90
erf.o: nrtype.o nr.o $(NRF90DIR)/erf.f90
erfc.o: nrtype.o nr.o $(NRF90DIR)/erfc.f90
erfcc.o: nrtype.o nrutil.o $(NRF90DIR)/erfcc.f90
eulsum.o: nrtype.o nrutil.o $(NRF90DIR)/eulsum.f90
evlmem.o: nrtype.o nrutil.o $(NRF90DIR)/evlmem.f90
expdev.o: nrtype.o nr.o $(NRF90DIR)/expdev.f90
expint.o: nrtype.o nrutil.o $(NRF90DIR)/expint.f90
factln.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/factln.f90
factrl.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/factrl.f90
fasper.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/fasper.f90
fdjac.o: nrtype.o nrutil.o $(NRF90DIR)/fdjac.f90
fgauss.o: nrtype.o nrutil.o $(NRF90DIR)/fgauss.f90
fit.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/fit.f90
fitexy.o: nrtype.o nrutil.o nr.o chixy.o $(NRF90DIR)/fitexy.f90
fixrts.o: nrtype.o nr.o $(NRF90DIR)/fixrts.f90
fleg.o: nrtype.o $(NRF90DIR)/fleg.f90
flmoon.o: nrtype.o nrutil.o $(NRF90DIR)/flmoon.f90
fmin.o: nrtype.o nrutil.o $(NRF90DIR)/fmin.f90
four1.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/four1.f90
four1_alt.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/four1_alt.f90
four1_gather.o: nrtype.o nrutil.o $(NRF90DIR)/four1_gather.f90
four2.o: nrtype.o nr.o $(NRF90DIR)/four2.f90
four2_alt.o: nrtype.o nr.o $(NRF90DIR)/four2_alt.f90
four3.o: nrtype.o nr.o $(NRF90DIR)/four3.f90
four3_alt.o: nrtype.o nr.o $(NRF90DIR)/four3_alt.f90
fourcol.o: nrtype.o nrutil.o $(NRF90DIR)/fourcol.f90
fourcol_3d.o: nrtype.o nrutil.o $(NRF90DIR)/fourcol_3d.f90
fourn_gather.o: nrtype.o nrutil.o $(NRF90DIR)/fourn_gather.f90
fourrow.o: nrtype.o nrutil.o $(NRF90DIR)/fourrow.f90
fourrow_3d.o: nrtype.o nrutil.o $(NRF90DIR)/fourrow_3d.f90
fpoly.o: nrtype.o nrutil.o $(NRF90DIR)/fpoly.f90
fred2.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/fred2.f90
fredex.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/fredex.f90
fredin.o: nrtype.o nrutil.o $(NRF90DIR)/fredin.f90
frenel.o: nrtype.o nrutil.o $(NRF90DIR)/frenel.f90
frprmn.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/frprmn.f90
ftest.o: nrtype.o nr.o $(NRF90DIR)/ftest.f90
gamdev.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/gamdev.f90
gammln.o: nrtype.o nrutil.o $(NRF90DIR)/gammln.f90
gammp.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/gammp.f90
gammq.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/gammq.f90
gasdev.o: nrtype.o nr.o nrutil.o $(NRF90DIR)/gasdev.f90
gaucof.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/gaucof.f90
gauher.o: nrtype.o nrutil.o $(NRF90DIR)/gauher.f90
gaujac.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/gaujac.f90
gaulag.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/gaulag.f90
gauleg.o: nrtype.o nrutil.o $(NRF90DIR)/gauleg.f90
gaussj.o: nrtype.o nrutil.o $(NRF90DIR)/gaussj.f90
gcf.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/gcf.f90
golden.o: nrtype.o $(NRF90DIR)/golden.f90
gser.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/gser.f90
hqr.o: nrtype.o nrutil.o $(NRF90DIR)/hqr.f90
hufdec.o: nrtype.o hufmak.o $(NRF90DIR)/hufdec.f90
hufenc.o: nrtype.o nrutil.o hufmak.o $(NRF90DIR)/hufenc.f90
hufmak.o: nrtype.o nrutil.o $(NRF90DIR)/hufmak.f90
hunt.o: nrtype.o $(NRF90DIR)/hunt.f90
hypdrv.o: nrtype.o hypgeo.o $(NRF90DIR)/hypdrv.f90
hypgeo.o: nrtype.o nr.o $(NRF90DIR)/hypgeo.f90
hypser.o: nrtype.o nrutil.o $(NRF90DIR)/hypser.f90
icrc.o: nrtype.o $(NRF90DIR)/icrc.f90
igray.o: nrtype.o $(NRF90DIR)/igray.f90
index_bypack.o: nrtype.o nrutil.o $(NRF90DIR)/index_bypack.f90
indexx.o: nrtype.o nrutil.o $(NRF90DIR)/indexx.f90
interp.o: nrtype.o nrutil.o $(NRF90DIR)/interp.f90
irbit1.o: nrtype.o $(NRF90DIR)/irbit1.f90
irbit2.o: nrtype.o $(NRF90DIR)/irbit2.f90
jacobi.o: nrtype.o nrutil.o $(NRF90DIR)/jacobi.f90
jacobn.o: nrtype.o $(NRF90DIR)/jacobn.f90
julday.o: nrtype.o nrutil.o $(NRF90DIR)/julday.f90
kendl1.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/kendl1.f90
kendl2.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/kendl2.f90
kermom.o: nrtype.o $(NRF90DIR)/kermom.f90
ks2d1s.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/ks2d1s.f90
ks2d2s.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/ks2d2s.f90
ksone.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/ksone.f90
kstwo.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/kstwo.f90
laguer.o: nrtype.o nrutil.o $(NRF90DIR)/laguer.f90
lfit.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/lfit.f90
linbcg.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/linbcg.f90
linmin.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/linmin.f90
lnsrch.o: nrtype.o nrutil.o $(NRF90DIR)/lnsrch.f90
locate.o: nrtype.o $(NRF90DIR)/locate.f90
lop.o: nrtype.o nrutil.o $(NRF90DIR)/lop.f90
lubksb.o: nrtype.o nrutil.o $(NRF90DIR)/lubksb.f90
ludcmp.o: nrtype.o nrutil.o $(NRF90DIR)/ludcmp.f90
machar.o: nrtype.o $(NRF90DIR)/machar.f90
medfit.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/medfit.f90
memcof.o: nrtype.o nrutil.o $(NRF90DIR)/memcof.f90
mgfas.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/mgfas.f90
mglin.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/mglin.f90
midexp.o: nrtype.o nrutil.o $(NRF90DIR)/midexp.f90
midinf.o: nrtype.o nrutil.o $(NRF90DIR)/midinf.f90
midpnt.o: nrtype.o nrutil.o $(NRF90DIR)/midpnt.f90
midsql.o: nrtype.o nrutil.o $(NRF90DIR)/midsql.f90
midsqu.o: nrtype.o nrutil.o $(NRF90DIR)/midsqu.f90
miser.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/miser.f90
mmid.o: nrtype.o nrutil.o $(NRF90DIR)/mmid.f90
mnbrak.o: nrtype.o nrutil.o $(NRF90DIR)/mnbrak.f90
mnewt.o: nrtype.o nr.o $(NRF90DIR)/mnewt.f90
moment.o: nrtype.o nrutil.o $(NRF90DIR)/moment.f90
mp2dfr.o: nrtype.o mpops.o $(NRF90DIR)/mp2dfr.f90
mpdiv.o: nr.o nrtype.o nrutil.o mpops.o $(NRF90DIR)/mpdiv.f90
mpinv.o: nr.o nrtype.o nrutil.o mpops.o $(NRF90DIR)/mpinv.f90
mpmul.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/mpmul.f90
mpops.o: nrtype.o nrutil.o $(NRF90DIR)/mpops.f90
mppi.o: nr.o nrtype.o mpops.o $(NRF90DIR)/mppi.f90
mprove.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/mprove.f90
mpsqrt.o: nr.o nrtype.o nrutil.o mpops.o $(NRF90DIR)/mpsqrt.f90
mrqmin.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/mrqmin.f90
newt.o: nrtype.o nrutil.o nr.o fmin.o $(NRF90DIR)/newt.f90
nr.o: nrtype.o $(NRF90DIR)/nr.f90
nrtype.o: $(NRF90DIR)/nrtype.f90
nrutil.o: nrtype.o $(NRF90DIR)/nrutil.f90
odeint.o: nrtype.o nrutil.o $(NRF90DIR)/odeint.f90
orthog.o: nrtype.o nrutil.o $(NRF90DIR)/orthog.f90
pade.o: nrtype.o nr.o $(NRF90DIR)/pade.f90
pccheb.o: nrtype.o nrutil.o $(NRF90DIR)/pccheb.f90
pcshft.o: nrtype.o nrutil.o $(NRF90DIR)/pcshft.f90
pearsn.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/pearsn.f90
period.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/period.f90
plgndr.o: nrtype.o nrutil.o $(NRF90DIR)/plgndr.f90
poidev.o: nrtype.o nr.o $(NRF90DIR)/poidev.f90
polcoe.o: nrtype.o nrutil.o $(NRF90DIR)/polcoe.f90
polcof.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/polcof.f90
poldiv.o: nrtype.o nrutil.o $(NRF90DIR)/poldiv.f90
polin2.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/polin2.f90
polint.o: nrtype.o nrutil.o $(NRF90DIR)/polint.f90
powell.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/powell.f90
predic.o: nrtype.o $(NRF90DIR)/predic.f90
probks.o: nrtype.o $(NRF90DIR)/probks.f90
psdes.o: nrtype.o nrutil.o $(NRF90DIR)/psdes.f90
pwt.o: nrtype.o nrutil.o pwtset.o $(NRF90DIR)/pwt.f90
pwtset.o: nrtype.o nrutil.o $(NRF90DIR)/pwtset.f90
pythag.o: nrtype.o $(NRF90DIR)/pythag.f90
pzextr.o: nrtype.o nrutil.o $(NRF90DIR)/pzextr.f90
qrdcmp.o: nrtype.o nrutil.o $(NRF90DIR)/qrdcmp.f90
qromb.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/qromb.f90
qromo.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/qromo.f90
qroot.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/qroot.f90
qrsolv.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/qrsolv.f90
qrupdt.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/qrupdt.f90
qsimp.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/qsimp.f90
qtrap.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/qtrap.f90
quad3d.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/quad3d.f90
quadct.o: nrtype.o nrutil.o $(NRF90DIR)/quadct.f90
quadmx.o: nrtype.o nrutil.o nr.o kermom.o $(NRF90DIR)/quadmx.f90
quadvl.o: nrtype.o $(NRF90DIR)/quadvl.f90
ran.o: $(NRF90DIR)/ran.f90
ran0.o: nrtype.o ran_state.o $(NRF90DIR)/ran0.f90
ran1.o: nrtype.o ran_state.o $(NRF90DIR)/ran1.f90
ran2.o: nrtype.o ran_state.o $(NRF90DIR)/ran2.f90
ran3.o: nrtype.o ran_state.o $(NRF90DIR)/ran3.f90
ran_state.o: nrtype.o nrutil.o $(NRF90DIR)/ran_state.f90
rank.o: nrtype.o nrutil.o $(NRF90DIR)/rank.f90
ratint.o: nrtype.o nrutil.o $(NRF90DIR)/ratint.f90
ratlsq.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/ratlsq.f90
ratval.o: nrtype.o nrutil.o $(NRF90DIR)/ratval.f90
rc.o: nrtype.o nrutil.o $(NRF90DIR)/rc.f90
rd.o: nrtype.o nrutil.o $(NRF90DIR)/rd.f90
realft.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/realft.f90
recur1.o: nrtype.o nrutil.o $(NRF90DIR)/recur1.f90
recur2.o: nrtype.o nrutil.o $(NRF90DIR)/recur2.f90
relax.o: nrtype.o nrutil.o $(NRF90DIR)/relax.f90
relax2.o: nrtype.o nrutil.o $(NRF90DIR)/relax2.f90
resid.o: nrtype.o nrutil.o $(NRF90DIR)/resid.f90
rf.o: nrtype.o nrutil.o $(NRF90DIR)/rf.f90
rj.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/rj.f90
rk4.o: nrtype.o nrutil.o $(NRF90DIR)/rk4.f90
rkck.o: nrtype.o nrutil.o $(NRF90DIR)/rkck.f90
rkdumb.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/rkdumb.f90
rkqs.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/rkqs.f90
rlft2.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/rlft2.f90
rlft3.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/rlft3.f90
rotate.o: nrtype.o nrutil.o $(NRF90DIR)/rotate.f90
rsolv.o: nrtype.o nrutil.o $(NRF90DIR)/rsolv.f90
rstrct.o: nrtype.o nrutil.o $(NRF90DIR)/rstrct.f90
rtbis.o: nrtype.o nrutil.o $(NRF90DIR)/rtbis.f90
rtflsp.o: nrtype.o nrutil.o $(NRF90DIR)/rtflsp.f90
rtnewt.o: nrtype.o nrutil.o $(NRF90DIR)/rtnewt.f90
rtsafe.o: nrtype.o nrutil.o $(NRF90DIR)/rtsafe.f90
rtsec.o: nrtype.o nrutil.o $(NRF90DIR)/rtsec.f90
rzextr.o: nrtype.o nrutil.o $(NRF90DIR)/rzextr.f90
savgol.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/savgol.f90
scrsho.o: nrtype.o $(NRF90DIR)/scrsho.f90
select.o: nrtype.o nrutil.o $(NRF90DIR)/select.f90
select_bypack.o: nrtype.o nrutil.o $(NRF90DIR)/select_bypack.f90
select_heap.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/select_heap.f90
select_inplace.o: nrtype.o nr.o $(NRF90DIR)/select_inplace.f90
sfroid.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/sfroid.f90
shoot.o: nrtype.o nr.o sphoot.o $(NRF90DIR)/shoot.f90
shootf.o: nrtype.o nr.o sphfpt.o $(NRF90DIR)/shootf.f90
simplx.o: nrtype.o nrutil.o $(NRF90DIR)/simplx.f90
simpr.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/simpr.f90
sinft.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/sinft.f90
slvsm2.o: nrtype.o $(NRF90DIR)/slvsm2.f90
slvsml.o: nrtype.o $(NRF90DIR)/slvsml.f90
sncndn.o: nrtype.o nrutil.o $(NRF90DIR)/sncndn.f90
snrm.o: nrtype.o $(NRF90DIR)/snrm.f90
sobseq.o: nrtype.o nrutil.o $(NRF90DIR)/sobseq.f90
solvde.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/solvde.f90
sor.o: nrtype.o nrutil.o $(NRF90DIR)/sor.f90
sort.o: nrtype.o nrutil.o $(NRF90DIR)/sort.f90
sort2.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/sort2.f90
sort3.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/sort3.f90
sort_bypack.o: nrtype.o nrutil.o $(NRF90DIR)/sort_bypack.f90
sort_byreshape.o: nrtype.o nrutil.o $(NRF90DIR)/sort_byreshape.f90
sort_heap.o: nrtype.o $(NRF90DIR)/sort_heap.f90
sort_pick.o: nrtype.o $(NRF90DIR)/sort_pick.f90
sort_radix.o: nrtype.o nrutil.o $(NRF90DIR)/sort_radix.f90
sort_shell.o: nrtype.o $(NRF90DIR)/sort_shell.f90
spctrm.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/spctrm.f90
spear.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/spear.f90
sphbes.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/sphbes.f90
sphfpt.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/sphfpt.f90
sphoot.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/sphoot.f90
splie2.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/splie2.f90
splin2.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/splin2.f90
spline.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/spline.f90
splint.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/splint.f90
sprsax.o: nrtype.o nrutil.o $(NRF90DIR)/sprsax.f90
sprsdiag.o: nrtype.o nrutil.o $(NRF90DIR)/sprsdiag.f90
sprsin.o: nrtype.o nrutil.o $(NRF90DIR)/sprsin.f90
sprstp.o: nrtype.o $(NRF90DIR)/sprstp.f90
sprstx.o: nrtype.o nrutil.o $(NRF90DIR)/sprstx.f90
stifbs.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/stifbs.f90
stiff.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/stiff.f90
stoerm.o: nrtype.o nrutil.o $(NRF90DIR)/stoerm.f90
svbksb.o: nrtype.o nrutil.o $(NRF90DIR)/svbksb.f90
svdcmp.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/svdcmp.f90
svdfit.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/svdfit.f90
svdvar.o: nrtype.o nrutil.o $(NRF90DIR)/svdvar.f90
toeplz.o: nrtype.o nrutil.o $(NRF90DIR)/toeplz.f90
tptest.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/tptest.f90
tqli.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/tqli.f90
trapzd.o: nrtype.o nrutil.o $(NRF90DIR)/trapzd.f90
tred2.o: nrtype.o nrutil.o $(NRF90DIR)/tred2.f90
tridag.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/tridag.f90
ttest.o: nrtype.o nr.o $(NRF90DIR)/ttest.f90
tutest.o: nrtype.o nr.o $(NRF90DIR)/tutest.f90
twofft.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/twofft.f90
vander.o: nrtype.o nrutil.o $(NRF90DIR)/vander.f90
vegas.o: nrtype.o nr.o $(NRF90DIR)/vegas.f90
voltra.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/voltra.f90
wt1.o: nrtype.o $(NRF90DIR)/wt1.f90
wtn.o: nrtype.o nrutil.o $(NRF90DIR)/wtn.f90
wwghts.o: nrtype.o nrutil.o $(NRF90DIR)/wwghts.f90
zbrac.o: nrtype.o nrutil.o $(NRF90DIR)/zbrac.f90
zbrak.o: nrtype.o nrutil.o $(NRF90DIR)/zbrak.f90
zbrent.o: nrtype.o nrutil.o $(NRF90DIR)/zbrent.f90
zrhqr.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/zrhqr.f90
zriddr.o: nrtype.o nrutil.o $(NRF90DIR)/zriddr.f90
zroots.o: nrtype.o nrutil.o nr.o $(NRF90DIR)/zroots.f90

# Targets for convenience
nrtype: nrtype.o ;
nrutil: nrutil.o ;
nr: nr.o ;

# Dependencies for driver object files
xairy.o: nrtype.o nr.o $(NRXF90DIR)/xairy.f90
xamebsa.o: nrtype.o nrutil.o nr.o ran_state.o $(NRXF90DIR)/xamebsa.f90
xamoeba.o: nrtype.o nr.o $(NRXF90DIR)/xamoeba.f90
xanneal.o: nrtype.o nrutil.o nr.o ran_state.o $(NRXF90DIR)/xanneal.f90
xarcode.o: nrtype.o nrutil.o nr.o arcmak.o $(NRXF90DIR)/xarcode.f90
xavevar.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xavevar.f90
xbalanc.o: nrtype.o nr.o $(NRXF90DIR)/xbalanc.f90
xbandec.o: nrtype.o nr.o $(NRXF90DIR)/xbandec.f90
xbanmul.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xbanmul.f90
xbcucof.o: nrtype.o nr.o $(NRXF90DIR)/xbcucof.f90
xbcuint.o: nrtype.o nr.o $(NRXF90DIR)/xbcuint.f90
xbeschb.o: nrtype.o nr.o $(NRXF90DIR)/xbeschb.f90
xbessik.o: nrtype.o nr.o $(NRXF90DIR)/xbessik.f90
xbnldev.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xbnldev.f90
xbrent.o: nrtype.o nr.o $(NRXF90DIR)/xbrent.f90
xbroydn.o: nrtype.o nr.o $(NRXF90DIR)/xbroydn.f90
xbsstep.o: nrtype.o nr.o odeint.o $(NRXF90DIR)/xbsstep.f90
xcaldat.o: nrtype.o nr.o $(NRXF90DIR)/xcaldat.f90
xchder.o: nrtype.o nr.o $(NRXF90DIR)/xchder.f90
xchebev.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xchebev.f90
xchebft.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xchebft.f90
xchebpc.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xchebpc.f90
xchint.o: nrtype.o nr.o $(NRXF90DIR)/xchint.f90
xcholsl.o: nrtype.o nr.o $(NRXF90DIR)/xcholsl.f90
xchsone.o: nrtype.o nrutil.o nr.o ran_state.o $(NRXF90DIR)/xchsone.f90
xchstwo.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xchstwo.f90
xcisi.o: nrtype.o nr.o $(NRXF90DIR)/xcisi.f90
xcntab1.o: nrtype.o nr.o $(NRXF90DIR)/xcntab1.f90
xcntab2.o: nrtype.o nr.o $(NRXF90DIR)/xcntab2.f90
xconvlv.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xconvlv.f90
xcorrel.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xcorrel.f90
xcosft1.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xcosft1.f90
xcosft2.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xcosft2.f90
xcovsrt.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xcovsrt.f90
xcyclic.o: nrtype.o nr.o $(NRXF90DIR)/xcyclic.f90
xdbrent.o: nrtype.o nr.o $(NRXF90DIR)/xdbrent.f90
xddpoly.o: nrtype.o nr.o $(NRXF90DIR)/xddpoly.f90
xdecchk.o: nrtype.o nr.o $(NRXF90DIR)/xdecchk.f90
xdf1dim.o: nrtype.o nrutil.o nr.o dlinmin.o $(NRXF90DIR)/xdf1dim.f90
xdfpmin.o: nrtype.o nr.o $(NRXF90DIR)/xdfpmin.f90
xdfridr.o: nrtype.o nr.o $(NRXF90DIR)/xdfridr.f90
xdftint.o: nrtype.o nr.o $(NRXF90DIR)/xdftint.f90
xeclass.o: nrtype.o nr.o $(NRXF90DIR)/xeclass.f90
xeclazz.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xeclazz.f90
xeigsrt.o: nrtype.o nr.o $(NRXF90DIR)/xeigsrt.f90
xelmhes.o: nrtype.o nr.o $(NRXF90DIR)/xelmhes.f90
xeulsum.o: nrtype.o nr.o $(NRXF90DIR)/xeulsum.f90
xevlmem.o: nrtype.o nr.o $(NRXF90DIR)/xevlmem.f90
xexpdev.o: nrtype.o nrutil.o nr.o ran_state.o $(NRXF90DIR)/xexpdev.f90
xf1dim.o: nrtype.o nr.o linmin.o $(NRXF90DIR)/xf1dim.f90
xfasper.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xfasper.f90
xfgauss.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xfgauss.f90
xfit.o: nrtype.o nrutil.o nr.o ran_state.o $(NRXF90DIR)/xfit.f90
xfitexy.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xfitexy.f90
xfixrts.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xfixrts.f90
xfleg.o: nrtype.o nr.o $(NRXF90DIR)/xfleg.f90
xflmoon.o: nrtype.o nr.o $(NRXF90DIR)/xflmoon.f90
xfour1.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xfour1.f90
xfpoly.o: nrtype.o nr.o $(NRXF90DIR)/xfpoly.f90
xfred2.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xfred2.f90
xfredin.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xfredin.f90
xfrenel.o: nrtype.o nr.o $(NRXF90DIR)/xfrenel.f90
xfrprmn.o: nrtype.o nr.o $(NRXF90DIR)/xfrprmn.f90
xftest.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xftest.f90
xgamdev.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xgamdev.f90
xgasdev.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xgasdev.f90
xgaucof.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xgaucof.f90
xgauher.o: nrtype.o nr.o $(NRXF90DIR)/xgauher.f90
xgaujac.o: nrtype.o nr.o $(NRXF90DIR)/xgaujac.f90
xgaulag.o: nrtype.o nr.o $(NRXF90DIR)/xgaulag.f90
xgauleg.o: nrtype.o nr.o $(NRXF90DIR)/xgauleg.f90
xgaussj.o: nrtype.o nr.o $(NRXF90DIR)/xgaussj.f90
xgolden.o: nrtype.o nr.o $(NRXF90DIR)/xgolden.f90
xhqr.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xhqr.f90
xhuffman.o: nrtype.o nrutil.o nr.o hufmak.o $(NRXF90DIR)/xhuffman.f90
xhunt.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xhunt.f90
xhypgeo.o: nrtype.o nr.o $(NRXF90DIR)/xhypgeo.f90
xicrc.o: nrtype.o nr.o $(NRXF90DIR)/xicrc.f90
xigray.o: nrtype.o nr.o $(NRXF90DIR)/xigray.f90
xirbit1.o: nrtype.o nr.o $(NRXF90DIR)/xirbit1.f90
xirbit2.o: nrtype.o nr.o $(NRXF90DIR)/xirbit2.f90
xjacobi.o: nrtype.o nr.o $(NRXF90DIR)/xjacobi.f90
xjulday.o: nrtype.o nr.o $(NRXF90DIR)/xjulday.f90
xkendl1.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xkendl1.f90
xkendl2.o: nrtype.o nr.o $(NRXF90DIR)/xkendl2.f90
xks2d1s.o: nrtype.o nr.o $(NRXF90DIR)/xks2d1s.f90
xks2d2s.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xks2d2s.f90
xksone.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xksone.f90
xkstwo.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xkstwo.f90
xlaguer.o: nrtype.o nr.o $(NRXF90DIR)/xlaguer.f90
xlfit.o: nrtype.o nrutil.o nr.o ran_state.o $(NRXF90DIR)/xlfit.f90
xlinbcg.o: nrtype.o nr.o $(NRXF90DIR)/xlinbcg.f90
xlinmin.o: nrtype.o nr.o linmin.o $(NRXF90DIR)/xlinmin.f90
xlocate.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xlocate.f90
xlubksb.o: nrtype.o nr.o $(NRXF90DIR)/xlubksb.f90
xludcmp.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xludcmp.f90
xmachar.o: nrtype.o nr.o $(NRXF90DIR)/xmachar.f90
xmedfit.o: nrtype.o nrutil.o nr.o ran_state.o $(NRXF90DIR)/xmedfit.f90
xmemcof.o: nrtype.o nr.o $(NRXF90DIR)/xmemcof.f90
xmgfas.o: nrtype.o nr.o $(NRXF90DIR)/xmgfas.f90
xmglin.o: nrtype.o nr.o $(NRXF90DIR)/xmglin.f90
xmidpnt.o: nrtype.o nr.o $(NRXF90DIR)/xmidpnt.f90
xmiser.o: nrtype.o nr.o $(NRXF90DIR)/xmiser.f90
xmmid.o: nrtype.o nr.o $(NRXF90DIR)/xmmid.f90
xmnbrak.o: nrtype.o nr.o $(NRXF90DIR)/xmnbrak.f90
xmnewt.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xmnewt.f90
xmoment.o: nrtype.o nr.o $(NRXF90DIR)/xmoment.f90
xmppi.o: nr.o nrtype.o mpops.o $(NRXF90DIR)/xmppi.f90
xmprove.o: nrtype.o nr.o $(NRXF90DIR)/xmprove.f90
xmrqmin.o: nrtype.o nrutil.o nr.o ran_state.o $(NRXF90DIR)/xmrqmin.f90
xnewt.o: nrtype.o nr.o $(NRXF90DIR)/xnewt.f90
xodeint.o: nrtype.o nr.o odeint.o $(NRXF90DIR)/xodeint.f90
xorthog.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xorthog.f90
xpade.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xpade.f90
xpccheb.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xpccheb.f90
xpcshft.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xpcshft.f90
xpearsn.o: nrtype.o nr.o $(NRXF90DIR)/xpearsn.f90
xperiod.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xperiod.f90
xpoidev.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xpoidev.f90
xpolcoe.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xpolcoe.f90
xpolcof.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xpolcof.f90
xpoldiv.o: nrtype.o nr.o $(NRXF90DIR)/xpoldiv.f90
xpolin2.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xpolin2.f90
xpolint.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xpolint.f90
xpowell.o: nrtype.o nr.o $(NRXF90DIR)/xpowell.f90
xpredic.o: nrtype.o nr.o $(NRXF90DIR)/xpredic.f90
xprobks.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xprobks.f90
xpsdes.o: nrtype.o nr.o $(NRXF90DIR)/xpsdes.f90
xpzextr.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xpzextr.f90
xqrdcmp.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xqrdcmp.f90
xqromo.o: nrtype.o nr.o $(NRXF90DIR)/xqromo.f90
xqroot.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xqroot.f90
xqrsolv.o: nrtype.o nr.o $(NRXF90DIR)/xqrsolv.f90
xqrupdt.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xqrupdt.f90
xquad3d.o: nrtype.o quad3d.o $(NRXF90DIR)/xquad3d.f90
xran.o: nrtype.o nr.o $(NRXF90DIR)/xran.f90
xrank.o: nrtype.o nr.o $(NRXF90DIR)/xrank.f90
xratint.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xratint.f90
xrealft.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xrealft.f90
xrk4.o: nrtype.o nr.o $(NRXF90DIR)/xrk4.f90
xrkdumb.o: nrtype.o nr.o rkdumb.o $(NRXF90DIR)/xrkdumb.f90
xrkqs.o: nrtype.o nr.o $(NRXF90DIR)/xrkqs.f90
xrlft3.o: nrtype.o nrutil.o nr.o ran_state.o $(NRXF90DIR)/xrlft3.f90
xrzextr.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xrzextr.f90
xsavgol.o: nrtype.o nr.o $(NRXF90DIR)/xsavgol.f90
xscrsho.o: nrtype.o nr.o $(NRXF90DIR)/xscrsho.f90
xsimpr.o: nrtype.o nr.o $(NRXF90DIR)/xsimpr.f90
xsinft.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xsinft.f90
xsncndn.o: nrtype.o nr.o $(NRXF90DIR)/xsncndn.f90
xsobseq.o: nrtype.o nr.o $(NRXF90DIR)/xsobseq.f90
xsor.o: nrtype.o nr.o $(NRXF90DIR)/xsor.f90
xsort2.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xsort2.f90
xsort3.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xsort3.f90
xspctrm.o: nrtype.o nr.o $(NRXF90DIR)/xspctrm.f90
xspear.o: nrtype.o nr.o $(NRXF90DIR)/xspear.f90
xsphfpt.o: nrtype.o sphfpt.o $(NRXF90DIR)/xsphfpt.f90
xsplie2.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xsplie2.f90
xsplin2.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xsplin2.f90
xspline.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xspline.f90
xsplint.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xsplint.f90
xstifbs.o: nrtype.o nr.o odeint.o $(NRXF90DIR)/xstifbs.f90
xstiff.o: nrtype.o nr.o odeint.o $(NRXF90DIR)/xstiff.f90
xstoerm.o: nrtype.o nr.o $(NRXF90DIR)/xstoerm.f90
xsvbksb.o: nrtype.o nr.o $(NRXF90DIR)/xsvbksb.f90
xsvdcmp.o: nrtype.o nr.o $(NRXF90DIR)/xsvdcmp.f90
xsvdfit.o: nrtype.o nrutil.o nr.o ran_state.o $(NRXF90DIR)/xsvdfit.f90
xsvdvar.o: nrtype.o nr.o $(NRXF90DIR)/xsvdvar.f90
xtoeplz.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xtoeplz.f90
xtptest.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xtptest.f90
xtqli.o: nrtype.o nr.o $(NRXF90DIR)/xtqli.f90
xtrapzd.o: nrtype.o nr.o $(NRXF90DIR)/xtrapzd.f90
xtred2.o: nrtype.o nr.o $(NRXF90DIR)/xtred2.f90
xtridag.o: nrtype.o nr.o $(NRXF90DIR)/xtridag.f90
xttest.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xttest.f90
xtutest.o: nrtype.o nr.o ran_state.o $(NRXF90DIR)/xtutest.f90
xtwofft.o: nrtype.o nrutil.o nr.o $(NRXF90DIR)/xtwofft.f90
xvander.o: nrtype.o nr.o $(NRXF90DIR)/xvander.f90
xvegas.o: nrtype.o nr.o $(NRXF90DIR)/xvegas.f90
xvoltra.o: nrtype.o nr.o $(NRXF90DIR)/xvoltra.f90
xwt1.o: nrtype.o nr.o $(NRXF90DIR)/xwt1.f90
xwtn.o: nrtype.o nr.o $(NRXF90DIR)/xwtn.f90
xzbrac.o: nrtype.o nr.o $(NRXF90DIR)/xzbrac.f90
xzbrak.o: nrtype.o nr.o $(NRXF90DIR)/xzbrak.f90
xzrhqr.o: nrtype.o nr.o $(NRXF90DIR)/xzrhqr.f90
xzroots.o: nrtype.o nr.o $(NRXF90DIR)/xzroots.f90


# Driver compilation
xairy.out : nrtype.o nrutil.o nr.o xairy.o airy.o bessik.o bessjy.o beschb.o chebev.o
	$(F90) $(F90OPTS) -o xairy.out nrtype.o nrutil.o nr.o xairy.o airy.o bessik.o bessjy.o beschb.o chebev.o
xamebsa.out : nrtype.o nrutil.o nr.o ran_state.o xamebsa.o amebsa.o ran1.o
	$(F90) $(F90OPTS) -o xamebsa.out nrtype.o nrutil.o nr.o ran_state.o xamebsa.o amebsa.o ran1.o
xamoeba.out : nrtype.o nrutil.o nr.o xamoeba.o amoeba.o bessj0.o
	$(F90) $(F90OPTS) -o xamoeba.out nrtype.o nrutil.o nr.o xamoeba.o amoeba.o bessj0.o
xanneal.out : nrtype.o nrutil.o nr.o ran_state.o xanneal.o anneal.o ran1.o
	$(F90) $(F90OPTS) -o xanneal.out nrtype.o nrutil.o nr.o ran_state.o xanneal.o anneal.o ran1.o
xarcode.out : nrtype.o nrutil.o nr.o arcmak.o xarcode.o arcode.o 
	$(F90) $(F90OPTS) -o xarcode.out nrtype.o nrutil.o nr.o arcmak.o xarcode.o arcode.o 
xavevar.out : nrtype.o nrutil.o nr.o ran_state.o xavevar.o avevar.o gasdev.o ran1.o 
	$(F90) $(F90OPTS) -o xavevar.out nrtype.o nrutil.o nr.o ran_state.o xavevar.o avevar.o gasdev.o ran1.o 
xbalanc.out : nrtype.o nrutil.o nr.o xbalanc.o balanc.o
	$(F90) $(F90OPTS) -o xbalanc.out nrtype.o nrutil.o nr.o xbalanc.o balanc.o
xbandec.out : nrtype.o nrutil.o nr.o xbandec.o banbks.o bandec.o banmul.o ran.o
	$(F90) $(F90OPTS) -o xbandec.out nrtype.o nrutil.o nr.o xbandec.o banbks.o bandec.o banmul.o ran.o
xbanmul.out : nrtype.o nrutil.o nr.o xbanmul.o banmul.o
	$(F90) $(F90OPTS) -o xbanmul.out nrtype.o nrutil.o nr.o xbanmul.o banmul.o
xbcucof.out : nrtype.o nrutil.o nr.o xbcucof.o bcucof.o
	$(F90) $(F90OPTS) -o xbcucof.out nrtype.o nrutil.o nr.o xbcucof.o bcucof.o
xbcuint.out : nrtype.o nrutil.o nr.o xbcuint.o bcuint.o bcucof.o
	$(F90) $(F90OPTS) -o xbcuint.out nrtype.o nrutil.o nr.o xbcuint.o bcuint.o bcucof.o
xbeschb.out : nrtype.o nrutil.o nr.o xbeschb.o beschb.o chebev.o gammln.o
	$(F90) $(F90OPTS) -o xbeschb.out nrtype.o nrutil.o nr.o xbeschb.o beschb.o chebev.o gammln.o
xbessik.out : nrtype.o nrutil.o nr.o xbessik.o bessik.o beschb.o chebev.o
	$(F90) $(F90OPTS) -o xbessik.out nrtype.o nrutil.o nr.o xbessik.o bessik.o beschb.o chebev.o
xbnldev.out : nrtype.o nrutil.o nr.o ran_state.o xbnldev.o bnldev.o ran1.o gammln.o
	$(F90) $(F90OPTS) -o xbnldev.out nrtype.o nrutil.o nr.o ran_state.o xbnldev.o bnldev.o ran1.o gammln.o
xbrent.out : nrtype.o nrutil.o nr.o xbrent.o brent.o mnbrak.o bessj0.o bessj1.o
	$(F90) $(F90OPTS) -o xbrent.out nrtype.o nrutil.o nr.o xbrent.o brent.o mnbrak.o bessj0.o bessj1.o
xbroydn.out : nrtype.o nrutil.o nr.o xbroydn.o fmin.o broydn.o lnsrch.o qrdcmp.o qrupdt.o rotate.o rsolv.o fdjac.o pythag.o
	$(F90) $(F90OPTS) -o xbroydn.out nrtype.o nrutil.o nr.o xbroydn.o fmin.o broydn.o lnsrch.o qrdcmp.o qrupdt.o rotate.o rsolv.o fdjac.o pythag.o
xbsstep.out : nrtype.o nrutil.o nr.o odeint.o xbsstep.o bsstep.o mmid.o pzextr.o bessj0.o bessj1.o bessj.o
	$(F90) $(F90OPTS) -o xbsstep.out nrtype.o nrutil.o nr.o odeint.o xbsstep.o bsstep.o mmid.o pzextr.o bessj0.o bessj1.o bessj.o
xcaldat.out : nrtype.o nrutil.o nr.o xcaldat.o caldat.o julday.o
	$(F90) $(F90OPTS) -o xcaldat.out nrtype.o nrutil.o nr.o xcaldat.o caldat.o julday.o
xchder.out : nrtype.o nrutil.o nr.o xchder.o chder.o chebft.o chebev.o
	$(F90) $(F90OPTS) -o xchder.out nrtype.o nrutil.o nr.o xchder.o chder.o chebft.o chebev.o
xchebev.out : nrtype.o nrutil.o nr.o xchebev.o chebev.o chebft.o
	$(F90) $(F90OPTS) -o xchebev.out nrtype.o nrutil.o nr.o xchebev.o chebev.o chebft.o
xchebft.out : nrtype.o nrutil.o nr.o xchebft.o chebft.o
	$(F90) $(F90OPTS) -o xchebft.out nrtype.o nrutil.o nr.o xchebft.o chebft.o
xchebpc.out : nrtype.o nrutil.o nr.o xchebpc.o chebpc.o chebft.o
	$(F90) $(F90OPTS) -o xchebpc.out nrtype.o nrutil.o nr.o xchebpc.o chebpc.o chebft.o
xchint.out : nrtype.o nrutil.o nr.o xchint.o chint.o chebft.o chebev.o
	$(F90) $(F90OPTS) -o xchint.out nrtype.o nrutil.o nr.o xchint.o chint.o chebft.o chebev.o
xcholsl.out : nrtype.o nrutil.o nr.o xcholsl.o choldc.o cholsl.o
	$(F90) $(F90OPTS) -o xcholsl.out nrtype.o nrutil.o nr.o xcholsl.o choldc.o cholsl.o
xchsone.out : nrtype.o nrutil.o nr.o ran_state.o xchsone.o chsone.o gammq.o gcf.o gser.o expdev.o ran1.o gammln.o
	$(F90) $(F90OPTS) -o xchsone.out nrtype.o nrutil.o nr.o ran_state.o xchsone.o chsone.o gammq.o gcf.o gser.o expdev.o ran1.o gammln.o
xchstwo.out : nrtype.o nrutil.o nr.o ran_state.o xchstwo.o chstwo.o gammq.o gcf.o gser.o expdev.o ran1.o gammln.o
	$(F90) $(F90OPTS) -o xchstwo.out nrtype.o nrutil.o nr.o ran_state.o xchstwo.o chstwo.o gammq.o gcf.o gser.o expdev.o ran1.o gammln.o
xcisi.out : nrtype.o nrutil.o nr.o xcisi.o cisi.o
	$(F90) $(F90OPTS) -o xcisi.out nrtype.o nrutil.o nr.o xcisi.o cisi.o
xcntab1.out : nrtype.o nrutil.o nr.o xcntab1.o cntab1.o gammq.o gcf.o gser.o gammln.o
	$(F90) $(F90OPTS) -o xcntab1.out nrtype.o nrutil.o nr.o xcntab1.o cntab1.o gammq.o gcf.o gser.o gammln.o
xcntab2.out : nrtype.o nrutil.o nr.o xcntab2.o cntab2.o
	$(F90) $(F90OPTS) -o xcntab2.out nrtype.o nrutil.o nr.o xcntab2.o cntab2.o
xconvlv.out : nrtype.o nrutil.o nr.o xconvlv.o convlv.o realft.o four1.o fourrow.o
	$(F90) $(F90OPTS) -o xconvlv.out nrtype.o nrutil.o nr.o xconvlv.o convlv.o realft.o four1.o fourrow.o
xcorrel.out : nrtype.o nrutil.o nr.o xcorrel.o correl.o realft.o four1.o fourrow.o
	$(F90) $(F90OPTS) -o xcorrel.out nrtype.o nrutil.o nr.o xcorrel.o correl.o realft.o four1.o fourrow.o
xcosft1.out : nrtype.o nrutil.o nr.o xcosft1.o cosft1.o realft.o four1.o fourrow.o
	$(F90) $(F90OPTS) -o xcosft1.out nrtype.o nrutil.o nr.o xcosft1.o cosft1.o realft.o four1.o fourrow.o
xcosft2.out : nrtype.o nrutil.o nr.o xcosft2.o cosft2.o realft.o four1.o fourrow.o
	$(F90) $(F90OPTS) -o xcosft2.out nrtype.o nrutil.o nr.o xcosft2.o cosft2.o realft.o four1.o fourrow.o
xcovsrt.out : nrtype.o nrutil.o nr.o xcovsrt.o covsrt.o
	$(F90) $(F90OPTS) -o xcovsrt.out nrtype.o nrutil.o nr.o xcovsrt.o covsrt.o
xcyclic.out : nrtype.o nrutil.o nr.o xcyclic.o cyclic.o tridag.o lubksb.o ludcmp.o ran.o
	$(F90) $(F90OPTS) -o xcyclic.out nrtype.o nrutil.o nr.o xcyclic.o cyclic.o tridag.o lubksb.o ludcmp.o ran.o
xdbrent.out : nrtype.o nrutil.o nr.o xdbrent.o dbrent.o mnbrak.o bessj0.o bessj1.o
	$(F90) $(F90OPTS) -o xdbrent.out nrtype.o nrutil.o nr.o xdbrent.o dbrent.o mnbrak.o bessj0.o bessj1.o
xddpoly.out : nrtype.o nrutil.o nr.o xddpoly.o ddpoly.o factrl.o gammln.o
	$(F90) $(F90OPTS) -o xddpoly.out nrtype.o nrutil.o nr.o xddpoly.o ddpoly.o factrl.o gammln.o
xdecchk.out : nrtype.o nrutil.o nr.o xdecchk.o decchk.o
	$(F90) $(F90OPTS) -o xdecchk.out nrtype.o nrutil.o nr.o xdecchk.o decchk.o
xdf1dim.out : nrtype.o nrutil.o nr.o dlinmin.o xdf1dim.o mnbrak.o dbrent.o scrsho.o
	$(F90) $(F90OPTS) -o xdf1dim.out nrtype.o nrutil.o nr.o dlinmin.o xdf1dim.o mnbrak.o dbrent.o scrsho.o
xdfpmin.out : nrtype.o nrutil.o nr.o xdfpmin.o dfpmin.o lnsrch.o
	$(F90) $(F90OPTS) -o xdfpmin.out nrtype.o nrutil.o nr.o xdfpmin.o dfpmin.o lnsrch.o
xdfridr.out : nrtype.o nrutil.o nr.o xdfridr.o dfridr.o
	$(F90) $(F90OPTS) -o xdfridr.out nrtype.o nrutil.o nr.o xdfridr.o dfridr.o
xdftint.out : nrtype.o nrutil.o nr.o xdftint.o dftint.o dftcor.o polint.o realft.o four1.o fourrow.o
	$(F90) $(F90OPTS) -o xdftint.out nrtype.o nrutil.o nr.o xdftint.o dftint.o dftcor.o polint.o realft.o four1.o fourrow.o
xeclass.out : nrtype.o nrutil.o nr.o xeclass.o eclass.o
	$(F90) $(F90OPTS) -o xeclass.out nrtype.o nrutil.o nr.o xeclass.o eclass.o
xeclazz.out : nrtype.o nrutil.o nr.o xeclazz.o eclazz.o
	$(F90) $(F90OPTS) -o xeclazz.out nrtype.o nrutil.o nr.o xeclazz.o eclazz.o
xeigsrt.out : nrtype.o nrutil.o nr.o xeigsrt.o eigsrt.o jacobi.o
	$(F90) $(F90OPTS) -o xeigsrt.out nrtype.o nrutil.o nr.o xeigsrt.o eigsrt.o jacobi.o
xelmhes.out : nrtype.o nrutil.o nr.o xelmhes.o elmhes.o balanc.o
	$(F90) $(F90OPTS) -o xelmhes.out nrtype.o nrutil.o nr.o xelmhes.o elmhes.o balanc.o
xeulsum.out : nrtype.o nrutil.o nr.o xeulsum.o eulsum.o
	$(F90) $(F90OPTS) -o xeulsum.out nrtype.o nrutil.o nr.o xeulsum.o eulsum.o
xevlmem.out : nrtype.o nrutil.o nr.o xevlmem.o evlmem.o memcof.o
	$(F90) $(F90OPTS) -o xevlmem.out nrtype.o nrutil.o nr.o xevlmem.o evlmem.o memcof.o
xexpdev.out : nrtype.o nrutil.o nr.o ran_state.o xexpdev.o expdev.o ran1.o
	$(F90) $(F90OPTS) -o xexpdev.out nrtype.o nrutil.o nr.o ran_state.o xexpdev.o expdev.o ran1.o
xf1dim.out : nrtype.o nrutil.o nr.o linmin.o xf1dim.o mnbrak.o brent.o scrsho.o
	$(F90) $(F90OPTS) -o xf1dim.out nrtype.o nrutil.o nr.o linmin.o xf1dim.o mnbrak.o brent.o scrsho.o
xfasper.out : nrtype.o nrutil.o nr.o ran_state.o xfasper.o fasper.o realft.o four1.o fourrow.o avevar.o gasdev.o ran1.o
	$(F90) $(F90OPTS) -o xfasper.out nrtype.o nrutil.o nr.o ran_state.o xfasper.o fasper.o realft.o four1.o fourrow.o avevar.o gasdev.o ran1.o
xfgauss.out : nrtype.o nrutil.o nr.o xfgauss.o fgauss.o
	$(F90) $(F90OPTS) -o xfgauss.out nrtype.o nrutil.o nr.o xfgauss.o fgauss.o
xfit.out : nrtype.o nrutil.o nr.o ran_state.o xfit.o fit.o gammq.o gammln.o gcf.o gser.o gasdev.o ran1.o
	$(F90) $(F90OPTS) -o xfit.out nrtype.o nrutil.o nr.o ran_state.o xfit.o fit.o gammq.o gammln.o gcf.o gser.o gasdev.o ran1.o
xfitexy.out : nrtype.o nrutil.o nr.o ran_state.o xfitexy.o chixy.o fitexy.o fit.o brent.o zbrent.o gammq.o gammln.o gcf.o gser.o mnbrak.o avevar.o gasdev.o ran1.o
	$(F90) $(F90OPTS) -o xfitexy.out nrtype.o nrutil.o nr.o ran_state.o xfitexy.o chixy.o fitexy.o fit.o brent.o zbrent.o gammq.o gammln.o gcf.o gser.o mnbrak.o avevar.o gasdev.o ran1.o
xfixrts.out : nrtype.o nrutil.o nr.o xfixrts.o fixrts.o zroots.o laguer.o indexx.o
	$(F90) $(F90OPTS) -o xfixrts.out nrtype.o nrutil.o nr.o xfixrts.o fixrts.o zroots.o laguer.o indexx.o
xfleg.out : nrtype.o nrutil.o nr.o xfleg.o fleg.o plgndr.o
	$(F90) $(F90OPTS) -o xfleg.out nrtype.o nrutil.o nr.o xfleg.o fleg.o plgndr.o
xflmoon.out : nrtype.o nrutil.o nr.o xflmoon.o flmoon.o caldat.o julday.o
	$(F90) $(F90OPTS) -o xflmoon.out nrtype.o nrutil.o nr.o xflmoon.o flmoon.o caldat.o julday.o
xfour1.out : nrtype.o nrutil.o nr.o xfour1.o four1.o fourrow.o
	$(F90) $(F90OPTS) -o xfour1.out nrtype.o nrutil.o nr.o xfour1.o four1.o fourrow.o
xfpoly.out : nrtype.o nrutil.o nr.o xfpoly.o fpoly.o
	$(F90) $(F90OPTS) -o xfpoly.out nrtype.o nrutil.o nr.o xfpoly.o fpoly.o
xfred2.out : nrtype.o nrutil.o nr.o xfred2.o fred2.o gauleg.o lubksb.o ludcmp.o
	$(F90) $(F90OPTS) -o xfred2.out nrtype.o nrutil.o nr.o xfred2.o fred2.o gauleg.o lubksb.o ludcmp.o
xfredin.out : nrtype.o nrutil.o nr.o xfredin.o fredin.o fred2.o gauleg.o lubksb.o ludcmp.o
	$(F90) $(F90OPTS) -o xfredin.out nrtype.o nrutil.o nr.o xfredin.o fredin.o fred2.o gauleg.o lubksb.o ludcmp.o
xfrenel.out : nrtype.o nrutil.o nr.o xfrenel.o frenel.o
	$(F90) $(F90OPTS) -o xfrenel.out nrtype.o nrutil.o nr.o xfrenel.o frenel.o
xfrprmn.out : nrtype.o nrutil.o nr.o xfrprmn.o linmin.o frprmn.o mnbrak.o brent.o bessj0.o bessj1.o
	$(F90) $(F90OPTS) -o xfrprmn.out nrtype.o nrutil.o nr.o xfrprmn.o linmin.o frprmn.o mnbrak.o brent.o bessj0.o bessj1.o
xftest.out : nrtype.o nrutil.o nr.o ran_state.o xftest.o ftest.o avevar.o betai.o gasdev.o betacf.o gammln.o ran1.o
	$(F90) $(F90OPTS) -o xftest.out nrtype.o nrutil.o nr.o ran_state.o xftest.o ftest.o avevar.o betai.o gasdev.o betacf.o gammln.o ran1.o
xgamdev.out : nrtype.o nrutil.o nr.o ran_state.o xgamdev.o gamdev.o ran1.o
	$(F90) $(F90OPTS) -o xgamdev.out nrtype.o nrutil.o nr.o ran_state.o xgamdev.o gamdev.o ran1.o
xgasdev.out : nrtype.o nrutil.o nr.o ran_state.o xgasdev.o gasdev.o ran1.o
	$(F90) $(F90OPTS) -o xgasdev.out nrtype.o nrutil.o nr.o ran_state.o xgasdev.o gasdev.o ran1.o
xgaucof.out : nrtype.o nrutil.o nr.o xgaucof.o gaucof.o tqli.o pythag.o eigsrt.o
	$(F90) $(F90OPTS) -o xgaucof.out nrtype.o nrutil.o nr.o xgaucof.o gaucof.o tqli.o pythag.o eigsrt.o
xgauher.out : nrtype.o nrutil.o nr.o xgauher.o gauher.o
	$(F90) $(F90OPTS) -o xgauher.out nrtype.o nrutil.o nr.o xgauher.o gauher.o
xgaujac.out : nrtype.o nrutil.o nr.o xgaujac.o gaujac.o gammln.o ellf.o rf.o
	$(F90) $(F90OPTS) -o xgaujac.out nrtype.o nrutil.o nr.o xgaujac.o gaujac.o gammln.o ellf.o rf.o
xgaulag.out : nrtype.o nrutil.o nr.o xgaulag.o gaulag.o gammln.o bessj0.o
	$(F90) $(F90OPTS) -o xgaulag.out nrtype.o nrutil.o nr.o xgaulag.o gaulag.o gammln.o bessj0.o
xgauleg.out : nrtype.o nrutil.o nr.o xgauleg.o gauleg.o
	$(F90) $(F90OPTS) -o xgauleg.out nrtype.o nrutil.o nr.o xgauleg.o gauleg.o
xgaussj.out : nrtype.o nrutil.o nr.o xgaussj.o gaussj.o
	$(F90) $(F90OPTS) -o xgaussj.out nrtype.o nrutil.o nr.o xgaussj.o gaussj.o
xgolden.out : nrtype.o nrutil.o nr.o xgolden.o golden.o mnbrak.o bessj0.o bessj1.o
	$(F90) $(F90OPTS) -o xgolden.out nrtype.o nrutil.o nr.o xgolden.o golden.o mnbrak.o bessj0.o bessj1.o
xhqr.out : nrtype.o nrutil.o nr.o xhqr.o hqr.o elmhes.o balanc.o indexx.o
	$(F90) $(F90OPTS) -o xhqr.out nrtype.o nrutil.o nr.o xhqr.o hqr.o elmhes.o balanc.o indexx.o
xhuffman.out : nrtype.o nrutil.o nr.o hufmak.o xhuffman.o hufenc.o hufdec.o
	$(F90) $(F90OPTS) -o xhuffman.out nrtype.o nrutil.o nr.o hufmak.o xhuffman.o hufenc.o hufdec.o
xhunt.out : nrtype.o nrutil.o nr.o xhunt.o hunt.o
	$(F90) $(F90OPTS) -o xhunt.out nrtype.o nrutil.o nr.o xhunt.o hunt.o
xhypgeo.out : nrtype.o nrutil.o nr.o odeint.o xhypgeo.o hypgeo.o hypdrv.o hypser.o bsstep.o mmid.o pzextr.o
	$(F90) $(F90OPTS) -o xhypgeo.out nrtype.o nrutil.o nr.o odeint.o xhypgeo.o hypgeo.o hypdrv.o hypser.o bsstep.o mmid.o pzextr.o
xicrc.out : nrtype.o nrutil.o nr.o xicrc.o icrc.o 
	$(F90) $(F90OPTS) -o xicrc.out nrtype.o nrutil.o nr.o xicrc.o icrc.o 
xigray.out : nrtype.o nrutil.o nr.o xigray.o igray.o
	$(F90) $(F90OPTS) -o xigray.out nrtype.o nrutil.o nr.o xigray.o igray.o
xirbit1.out : nrtype.o nrutil.o nr.o xirbit1.o irbit1.o
	$(F90) $(F90OPTS) -o xirbit1.out nrtype.o nrutil.o nr.o xirbit1.o irbit1.o
xirbit2.out : nrtype.o nrutil.o nr.o xirbit2.o irbit2.o
	$(F90) $(F90OPTS) -o xirbit2.out nrtype.o nrutil.o nr.o xirbit2.o irbit2.o
xjacobi.out : nrtype.o nrutil.o nr.o xjacobi.o jacobi.o
	$(F90) $(F90OPTS) -o xjacobi.out nrtype.o nrutil.o nr.o xjacobi.o jacobi.o
xjulday.out : nrtype.o nrutil.o nr.o xjulday.o julday.o
	$(F90) $(F90OPTS) -o xjulday.out nrtype.o nrutil.o nr.o xjulday.o julday.o
xkendl1.out : nrtype.o nrutil.o nr.o ran_state.o xkendl1.o kendl1.o erfcc.o ran0.o ran1.o ran2.o ran.o ran3.o
	$(F90) $(F90OPTS) -o xkendl1.out nrtype.o nrutil.o nr.o ran_state.o xkendl1.o kendl1.o erfcc.o ran0.o ran1.o ran2.o ran.o ran3.o
xkendl2.out : nrtype.o nrutil.o nr.o xkendl2.o kendl2.o irbit1.o irbit2.o erfcc.o
	$(F90) $(F90OPTS) -o xkendl2.out nrtype.o nrutil.o nr.o xkendl2.o kendl2.o irbit1.o irbit2.o erfcc.o
xks2d1s.out : nrtype.o nrutil.o nr.o xks2d1s.o ks2d1s.o quadct.o quadvl.o pearsn.o probks.o betai.o betacf.o gammln.o ran.o
	$(F90) $(F90OPTS) -o xks2d1s.out nrtype.o nrutil.o nr.o xks2d1s.o ks2d1s.o quadct.o quadvl.o pearsn.o probks.o betai.o betacf.o gammln.o ran.o
xks2d2s.out : nrtype.o nrutil.o nr.o ran_state.o xks2d2s.o ks2d2s.o quadct.o pearsn.o probks.o betai.o betacf.o gammln.o gasdev.o ran1.o
	$(F90) $(F90OPTS) -o xks2d2s.out nrtype.o nrutil.o nr.o ran_state.o xks2d2s.o ks2d2s.o quadct.o pearsn.o probks.o betai.o betacf.o gammln.o gasdev.o ran1.o
xksone.out : nrtype.o nrutil.o nr.o ran_state.o xksone.o ksone.o gasdev.o ran1.o probks.o sort.o erf.o erfcc.o gcf.o gammln.o gser.o gammp.o
	$(F90) $(F90OPTS) -o xksone.out nrtype.o nrutil.o nr.o ran_state.o xksone.o ksone.o gasdev.o ran1.o probks.o sort.o erf.o erfcc.o gcf.o gammln.o gser.o gammp.o
xkstwo.out : nrtype.o nrutil.o nr.o ran_state.o xkstwo.o kstwo.o gasdev.o probks.o sort2.o indexx.o ran1.o
	$(F90) $(F90OPTS) -o xkstwo.out nrtype.o nrutil.o nr.o ran_state.o xkstwo.o kstwo.o gasdev.o probks.o sort2.o indexx.o ran1.o
xlaguer.out : nrtype.o nrutil.o nr.o xlaguer.o laguer.o
	$(F90) $(F90OPTS) -o xlaguer.out nrtype.o nrutil.o nr.o xlaguer.o laguer.o
xlfit.out : nrtype.o nrutil.o nr.o ran_state.o xlfit.o lfit.o covsrt.o gaussj.o gasdev.o ran1.o
	$(F90) $(F90OPTS) -o xlfit.out nrtype.o nrutil.o nr.o ran_state.o xlfit.o lfit.o covsrt.o gaussj.o gasdev.o ran1.o
xlinbcg.out : nrtype.o nrutil.o nr.o xlinbcg.o linbcg.o snrm.o atimes.o asolve.o sprstx.o sprsax.o sprsin.o sprsdiag.o
	$(F90) $(F90OPTS) -o xlinbcg.out nrtype.o nrutil.o nr.o xlinbcg.o linbcg.o snrm.o atimes.o asolve.o sprstx.o sprsax.o sprsin.o sprsdiag.o
xlinmin.out : nrtype.o nrutil.o nr.o linmin.o xlinmin.o brent.o mnbrak.o
	$(F90) $(F90OPTS) -o xlinmin.out nrtype.o nrutil.o nr.o linmin.o xlinmin.o brent.o mnbrak.o
xlocate.out : nrtype.o nrutil.o nr.o xlocate.o locate.o
	$(F90) $(F90OPTS) -o xlocate.out nrtype.o nrutil.o nr.o xlocate.o locate.o
xlubksb.out : nrtype.o nrutil.o nr.o xlubksb.o lubksb.o ludcmp.o
	$(F90) $(F90OPTS) -o xlubksb.out nrtype.o nrutil.o nr.o xlubksb.o lubksb.o ludcmp.o
xludcmp.out : nrtype.o nrutil.o nr.o xludcmp.o ludcmp.o
	$(F90) $(F90OPTS) -o xludcmp.out nrtype.o nrutil.o nr.o xludcmp.o ludcmp.o
xmachar.out : nrtype.o nrutil.o nr.o xmachar.o machar.o
	$(F90) $(F90OPTS) -o xmachar.out nrtype.o nrutil.o nr.o xmachar.o machar.o
xmedfit.out : nrtype.o nrutil.o nr.o ran_state.o xmedfit.o medfit.o fit.o select.o gammq.o gammln.o gcf.o gser.o gasdev.o ran1.o
	$(F90) $(F90OPTS) -o xmedfit.out nrtype.o nrutil.o nr.o ran_state.o xmedfit.o medfit.o fit.o select.o gammq.o gammln.o gcf.o gser.o gasdev.o ran1.o
xmemcof.out : nrtype.o nrutil.o nr.o xmemcof.o memcof.o
	$(F90) $(F90OPTS) -o xmemcof.out nrtype.o nrutil.o nr.o xmemcof.o memcof.o
xmgfas.out : nrtype.o nrutil.o nr.o xmgfas.o mgfas.o slvsm2.o relax2.o lop.o rstrct.o interp.o 
	$(F90) $(F90OPTS) -o xmgfas.out nrtype.o nrutil.o nr.o xmgfas.o mgfas.o slvsm2.o relax2.o lop.o rstrct.o interp.o 
xmglin.out : nrtype.o nrutil.o nr.o xmglin.o mglin.o slvsml.o relax.o resid.o rstrct.o interp.o 
	$(F90) $(F90OPTS) -o xmglin.out nrtype.o nrutil.o nr.o xmglin.o mglin.o slvsml.o relax.o resid.o rstrct.o interp.o 
xmidpnt.out : nrtype.o nrutil.o nr.o xmidpnt.o midpnt.o
	$(F90) $(F90OPTS) -o xmidpnt.out nrtype.o nrutil.o nr.o xmidpnt.o midpnt.o
xmiser.out : nrtype.o nrutil.o nr.o ran_state.o miser.o xmiser.o ran1.o
	$(F90) $(F90OPTS) -o xmiser.out nrtype.o nrutil.o nr.o ran_state.o miser.o xmiser.o ran1.o
xmmid.out : nrtype.o nrutil.o nr.o xmmid.o mmid.o bessj0.o bessj1.o bessj.o
	$(F90) $(F90OPTS) -o xmmid.out nrtype.o nrutil.o nr.o xmmid.o mmid.o bessj0.o bessj1.o bessj.o
xmnbrak.out : nrtype.o nrutil.o nr.o xmnbrak.o mnbrak.o bessj0.o
	$(F90) $(F90OPTS) -o xmnbrak.out nrtype.o nrutil.o nr.o xmnbrak.o mnbrak.o bessj0.o
xmnewt.out : nrtype.o nrutil.o nr.o xmnewt.o mnewt.o ludcmp.o lubksb.o
	$(F90) $(F90OPTS) -o xmnewt.out nrtype.o nrutil.o nr.o xmnewt.o mnewt.o ludcmp.o lubksb.o
xmoment.out : nrtype.o nrutil.o nr.o xmoment.o moment.o
	$(F90) $(F90OPTS) -o xmoment.out nrtype.o nrutil.o nr.o xmoment.o moment.o
xmppi.out : nrtype.o nrutil.o nr.o mpops.o xmppi.o mppi.o mpsqrt.o mp2dfr.o mpinv.o mpdiv.o mpmul.o realft.o four1.o fourrow.o
	$(F90) $(F90OPTS) -o xmppi.out nrtype.o nrutil.o nr.o mpops.o xmppi.o mppi.o mpsqrt.o mp2dfr.o mpinv.o mpdiv.o mpmul.o realft.o four1.o fourrow.o
xmprove.out : nrtype.o nrutil.o nr.o xmprove.o lubksb.o ludcmp.o mprove.o ran.o
	$(F90) $(F90OPTS) -o xmprove.out nrtype.o nrutil.o nr.o xmprove.o lubksb.o ludcmp.o mprove.o ran.o
xmrqmin.out : nrtype.o nrutil.o nr.o ran_state.o xmrqmin.o mrqmin.o covsrt.o fgauss.o gaussj.o gasdev.o ran1.o
	$(F90) $(F90OPTS) -o xmrqmin.out nrtype.o nrutil.o nr.o ran_state.o xmrqmin.o mrqmin.o covsrt.o fgauss.o gaussj.o gasdev.o ran1.o
xnewt.out : nrtype.o nrutil.o nr.o xnewt.o fmin.o newt.o fdjac.o lnsrch.o ludcmp.o lubksb.o
	$(F90) $(F90OPTS) -o xnewt.out nrtype.o nrutil.o nr.o xnewt.o fmin.o newt.o fdjac.o lnsrch.o ludcmp.o lubksb.o
xodeint.out : nrtype.o nrutil.o nr.o odeint.o xodeint.o rkqs.o rkck.o bessj0.o bessj1.o bessj.o
	$(F90) $(F90OPTS) -o xodeint.out nrtype.o nrutil.o nr.o odeint.o xodeint.o rkqs.o rkck.o bessj0.o bessj1.o bessj.o
xorthog.out : nrtype.o nrutil.o nr.o xorthog.o orthog.o gaucof.o tqli.o pythag.o eigsrt.o
	$(F90) $(F90OPTS) -o xorthog.out nrtype.o nrutil.o nr.o xorthog.o orthog.o gaucof.o tqli.o pythag.o eigsrt.o
xpade.out : nrtype.o nrutil.o nr.o xpade.o pade.o ratval.o ludcmp.o lubksb.o mprove.o
	$(F90) $(F90OPTS) -o xpade.out nrtype.o nrutil.o nr.o xpade.o pade.o ratval.o ludcmp.o lubksb.o mprove.o
xpccheb.out : nrtype.o nrutil.o nr.o xpccheb.o pccheb.o pcshft.o chebpc.o
	$(F90) $(F90OPTS) -o xpccheb.out nrtype.o nrutil.o nr.o xpccheb.o pccheb.o pcshft.o chebpc.o
xpcshft.out : nrtype.o nrutil.o nr.o xpcshft.o pcshft.o chebft.o chebpc.o
	$(F90) $(F90OPTS) -o xpcshft.out nrtype.o nrutil.o nr.o xpcshft.o pcshft.o chebft.o chebpc.o
xpearsn.out : nrtype.o nrutil.o nr.o xpearsn.o pearsn.o betai.o betacf.o gammln.o
	$(F90) $(F90OPTS) -o xpearsn.out nrtype.o nrutil.o nr.o xpearsn.o pearsn.o betai.o betacf.o gammln.o
xperiod.out : nrtype.o nrutil.o nr.o ran_state.o xperiod.o period.o avevar.o gasdev.o ran1.o
	$(F90) $(F90OPTS) -o xperiod.out nrtype.o nrutil.o nr.o ran_state.o xperiod.o period.o avevar.o gasdev.o ran1.o
xpoidev.out : nrtype.o nrutil.o nr.o ran_state.o xpoidev.o poidev.o ran1.o gammln.o
	$(F90) $(F90OPTS) -o xpoidev.out nrtype.o nrutil.o nr.o ran_state.o xpoidev.o poidev.o ran1.o gammln.o
xpolcoe.out : nrtype.o nrutil.o nr.o xpolcoe.o polcoe.o
	$(F90) $(F90OPTS) -o xpolcoe.out nrtype.o nrutil.o nr.o xpolcoe.o polcoe.o
xpolcof.out : nrtype.o nrutil.o nr.o xpolcof.o polcof.o polint.o
	$(F90) $(F90OPTS) -o xpolcof.out nrtype.o nrutil.o nr.o xpolcof.o polcof.o polint.o
xpoldiv.out : nrtype.o nrutil.o nr.o xpoldiv.o poldiv.o
	$(F90) $(F90OPTS) -o xpoldiv.out nrtype.o nrutil.o nr.o xpoldiv.o poldiv.o
xpolin2.out : nrtype.o nrutil.o nr.o xpolin2.o polin2.o polint.o
	$(F90) $(F90OPTS) -o xpolin2.out nrtype.o nrutil.o nr.o xpolin2.o polin2.o polint.o
xpolint.out : nrtype.o nrutil.o nr.o xpolint.o polint.o
	$(F90) $(F90OPTS) -o xpolint.out nrtype.o nrutil.o nr.o xpolint.o polint.o
xpowell.out : nrtype.o nrutil.o nr.o xpowell.o linmin.o powell.o bessj0.o brent.o mnbrak.o
	$(F90) $(F90OPTS) -o xpowell.out nrtype.o nrutil.o nr.o xpowell.o linmin.o powell.o bessj0.o brent.o mnbrak.o
xpredic.out : nrtype.o nrutil.o nr.o xpredic.o predic.o fixrts.o memcof.o zroots.o laguer.o indexx.o
	$(F90) $(F90OPTS) -o xpredic.out nrtype.o nrutil.o nr.o xpredic.o predic.o fixrts.o memcof.o zroots.o laguer.o indexx.o
xprobks.out : nrtype.o nrutil.o nr.o xprobks.o probks.o
	$(F90) $(F90OPTS) -o xprobks.out nrtype.o nrutil.o nr.o xprobks.o probks.o
xpsdes.out : nrtype.o nrutil.o nr.o xpsdes.o psdes.o
	$(F90) $(F90OPTS) -o xpsdes.out nrtype.o nrutil.o nr.o xpsdes.o psdes.o
xpzextr.out : nrtype.o nrutil.o nr.o xpzextr.o pzextr.o
	$(F90) $(F90OPTS) -o xpzextr.out nrtype.o nrutil.o nr.o xpzextr.o pzextr.o
xqrdcmp.out : nrtype.o nrutil.o nr.o xqrdcmp.o qrdcmp.o
	$(F90) $(F90OPTS) -o xqrdcmp.out nrtype.o nrutil.o nr.o xqrdcmp.o qrdcmp.o
xqromo.out : nrtype.o nrutil.o nr.o xqromo.o qromo.o midinf.o midsql.o midsqu.o midexp.o polint.o
	$(F90) $(F90OPTS) -o xqromo.out nrtype.o nrutil.o nr.o xqromo.o qromo.o midinf.o midsql.o midsqu.o midexp.o polint.o
xqroot.out : nrtype.o nrutil.o nr.o xqroot.o qroot.o poldiv.o
	$(F90) $(F90OPTS) -o xqroot.out nrtype.o nrutil.o nr.o xqroot.o qroot.o poldiv.o
xqrsolv.out : nrtype.o nrutil.o nr.o xqrsolv.o qrsolv.o qrdcmp.o rsolv.o
	$(F90) $(F90OPTS) -o xqrsolv.out nrtype.o nrutil.o nr.o xqrsolv.o qrsolv.o qrdcmp.o rsolv.o
xqrupdt.out : nrtype.o nrutil.o nr.o xqrupdt.o qrupdt.o qrdcmp.o rotate.o pythag.o
	$(F90) $(F90OPTS) -o xqrupdt.out nrtype.o nrutil.o nr.o xqrupdt.o qrupdt.o qrdcmp.o rotate.o pythag.o
xquad3d.out : nrtype.o nrutil.o nr.o quad3d.o xquad3d.o polint.o
	$(F90) $(F90OPTS) -o xquad3d.out nrtype.o nrutil.o nr.o quad3d.o xquad3d.o polint.o
xran.out : nrtype.o nrutil.o nr.o ran_state.o xran.o ran0.o ran1.o ran2.o ran3.o ran.o
	$(F90) $(F90OPTS) -o xran.out nrtype.o nrutil.o nr.o ran_state.o xran.o ran0.o ran1.o ran2.o ran3.o ran.o
xrank.out : nrtype.o nrutil.o nr.o xrank.o rank.o indexx.o
	$(F90) $(F90OPTS) -o xrank.out nrtype.o nrutil.o nr.o xrank.o rank.o indexx.o
xratint.out : nrtype.o nrutil.o nr.o xratint.o ratint.o
	$(F90) $(F90OPTS) -o xratint.out nrtype.o nrutil.o nr.o xratint.o ratint.o
xrealft.out : nrtype.o nrutil.o nr.o xrealft.o realft.o four1.o fourrow.o
	$(F90) $(F90OPTS) -o xrealft.out nrtype.o nrutil.o nr.o xrealft.o realft.o four1.o fourrow.o
xrk4.out : nrtype.o nrutil.o nr.o xrk4.o rk4.o bessj0.o bessj1.o bessj.o
	$(F90) $(F90OPTS) -o xrk4.out nrtype.o nrutil.o nr.o xrk4.o rk4.o bessj0.o bessj1.o bessj.o
xrkdumb.out : nrtype.o nrutil.o nr.o rkdumb.o xrkdumb.o rk4.o bessj0.o bessj1.o bessj.o
	$(F90) $(F90OPTS) -o xrkdumb.out nrtype.o nrutil.o nr.o rkdumb.o xrkdumb.o rk4.o bessj0.o bessj1.o bessj.o
xrkqs.out : nrtype.o nrutil.o nr.o xrkqs.o rkqs.o rkck.o bessj0.o bessj1.o bessj.o
	$(F90) $(F90OPTS) -o xrkqs.out nrtype.o nrutil.o nr.o xrkqs.o rkqs.o rkck.o bessj0.o bessj1.o bessj.o
xrlft3.out : nrtype.o nrutil.o nr.o ran_state.o xrlft3.o rlft3.o four3.o fourrow_3d.o ran1.o
	$(F90) $(F90OPTS) -o xrlft3.out nrtype.o nrutil.o nr.o ran_state.o xrlft3.o rlft3.o four3.o fourrow_3d.o ran1.o
xrzextr.out : nrtype.o nrutil.o nr.o xrzextr.o rzextr.o
	$(F90) $(F90OPTS) -o xrzextr.out nrtype.o nrutil.o nr.o xrzextr.o rzextr.o
xsavgol.out : nrtype.o nrutil.o nr.o xsavgol.o savgol.o ludcmp.o lubksb.o
	$(F90) $(F90OPTS) -o xsavgol.out nrtype.o nrutil.o nr.o xsavgol.o savgol.o ludcmp.o lubksb.o
xscrsho.out : nrtype.o nrutil.o nr.o xscrsho.o scrsho.o bessj0.o
	$(F90) $(F90OPTS) -o xscrsho.out nrtype.o nrutil.o nr.o xscrsho.o scrsho.o bessj0.o
xsimpr.out : nrtype.o nrutil.o nr.o xsimpr.o simpr.o jacobn.o lubksb.o ludcmp.o
	$(F90) $(F90OPTS) -o xsimpr.out nrtype.o nrutil.o nr.o xsimpr.o simpr.o jacobn.o lubksb.o ludcmp.o
xsinft.out : nrtype.o nrutil.o nr.o xsinft.o sinft.o realft.o four1.o fourrow.o
	$(F90) $(F90OPTS) -o xsinft.out nrtype.o nrutil.o nr.o xsinft.o sinft.o realft.o four1.o fourrow.o
xsncndn.out : nrtype.o nrutil.o nr.o xsncndn.o sncndn.o
	$(F90) $(F90OPTS) -o xsncndn.out nrtype.o nrutil.o nr.o xsncndn.o sncndn.o
xsobseq.out : nrtype.o nrutil.o nr.o xsobseq.o sobseq.o
	$(F90) $(F90OPTS) -o xsobseq.out nrtype.o nrutil.o nr.o xsobseq.o sobseq.o
xsor.out : nrtype.o nrutil.o nr.o xsor.o sor.o
	$(F90) $(F90OPTS) -o xsor.out nrtype.o nrutil.o nr.o xsor.o sor.o
xsort2.out : nrtype.o nrutil.o nr.o xsort2.o sort2.o indexx.o
	$(F90) $(F90OPTS) -o xsort2.out nrtype.o nrutil.o nr.o xsort2.o sort2.o indexx.o
xsort3.out : nrtype.o nrutil.o nr.o xsort3.o sort3.o indexx.o
	$(F90) $(F90OPTS) -o xsort3.out nrtype.o nrutil.o nr.o xsort3.o sort3.o indexx.o
xspctrm.out : nrtype.o nrutil.o nr.o xspctrm.o spctrm.o four1.o fourrow.o
	$(F90) $(F90OPTS) -o xspctrm.out nrtype.o nrutil.o nr.o xspctrm.o spctrm.o four1.o fourrow.o
xspear.out : nrtype.o nrutil.o nr.o xspear.o spear.o betai.o betacf.o erfcc.o sort2.o indexx.o gammln.o
	$(F90) $(F90OPTS) -o xspear.out nrtype.o nrutil.o nr.o xspear.o spear.o betai.o betacf.o erfcc.o sort2.o indexx.o gammln.o
xsphfpt.out : nrtype.o nrutil.o nr.o odeint.o sphfpt.o xsphfpt.o shootf.o rkqs.o rkck.o fmin.o newt.o fdjac.o lnsrch.o lubksb.o ludcmp.o
	$(F90) $(F90OPTS) -o xsphfpt.out nrtype.o nrutil.o nr.o odeint.o sphfpt.o xsphfpt.o shootf.o rkqs.o rkck.o fmin.o newt.o fdjac.o lnsrch.o lubksb.o ludcmp.o
xsplie2.out : nrtype.o nrutil.o nr.o xsplie2.o splie2.o spline.o tridag.o
	$(F90) $(F90OPTS) -o xsplie2.out nrtype.o nrutil.o nr.o xsplie2.o splie2.o spline.o tridag.o
xsplin2.out : nrtype.o nrutil.o nr.o xsplin2.o splie2.o splin2.o spline.o splint.o locate.o tridag.o
	$(F90) $(F90OPTS) -o xsplin2.out nrtype.o nrutil.o nr.o xsplin2.o splie2.o splin2.o spline.o splint.o locate.o tridag.o
xspline.out : nrtype.o nrutil.o nr.o xspline.o spline.o tridag.o
	$(F90) $(F90OPTS) -o xspline.out nrtype.o nrutil.o nr.o xspline.o spline.o tridag.o
xsplint.out : nrtype.o nrutil.o nr.o xsplint.o spline.o splint.o locate.o tridag.o
	$(F90) $(F90OPTS) -o xsplint.out nrtype.o nrutil.o nr.o xsplint.o spline.o splint.o locate.o tridag.o
xstifbs.out : nrtype.o nrutil.o nr.o odeint.o xstifbs.o stifbs.o simpr.o pzextr.o jacobn.o lubksb.o ludcmp.o
	$(F90) $(F90OPTS) -o xstifbs.out nrtype.o nrutil.o nr.o odeint.o xstifbs.o stifbs.o simpr.o pzextr.o jacobn.o lubksb.o ludcmp.o
xstiff.out : nrtype.o nrutil.o nr.o odeint.o xstiff.o stiff.o jacobn.o lubksb.o ludcmp.o
	$(F90) $(F90OPTS) -o xstiff.out nrtype.o nrutil.o nr.o odeint.o xstiff.o stiff.o jacobn.o lubksb.o ludcmp.o
xstoerm.out : nrtype.o nrutil.o nr.o xstoerm.o stoerm.o
	$(F90) $(F90OPTS) -o xstoerm.out nrtype.o nrutil.o nr.o xstoerm.o stoerm.o
xsvbksb.out : nrtype.o nrutil.o nr.o xsvbksb.o svbksb.o svdcmp.o pythag.o
	$(F90) $(F90OPTS) -o xsvbksb.out nrtype.o nrutil.o nr.o xsvbksb.o svbksb.o svdcmp.o pythag.o
xsvdcmp.out : nrtype.o nrutil.o nr.o xsvdcmp.o svdcmp.o pythag.o
	$(F90) $(F90OPTS) -o xsvdcmp.out nrtype.o nrutil.o nr.o xsvdcmp.o svdcmp.o pythag.o
xsvdfit.out : nrtype.o nrutil.o nr.o ran_state.o xsvdfit.o svdfit.o svdvar.o fpoly.o fleg.o svdcmp.o pythag.o svbksb.o gasdev.o ran1.o
	$(F90) $(F90OPTS) -o xsvdfit.out nrtype.o nrutil.o nr.o ran_state.o xsvdfit.o svdfit.o svdvar.o fpoly.o fleg.o svdcmp.o pythag.o svbksb.o gasdev.o ran1.o
xsvdvar.out : nrtype.o nrutil.o nr.o xsvdvar.o svdvar.o
	$(F90) $(F90OPTS) -o xsvdvar.out nrtype.o nrutil.o nr.o xsvdvar.o svdvar.o
xtoeplz.out : nrtype.o nrutil.o nr.o xtoeplz.o toeplz.o
	$(F90) $(F90OPTS) -o xtoeplz.out nrtype.o nrutil.o nr.o xtoeplz.o toeplz.o
xtptest.out : nrtype.o nrutil.o nr.o ran_state.o xtptest.o tptest.o avevar.o betai.o gasdev.o betacf.o gammln.o ran1.o
	$(F90) $(F90OPTS) -o xtptest.out nrtype.o nrutil.o nr.o ran_state.o xtptest.o tptest.o avevar.o betai.o gasdev.o betacf.o gammln.o ran1.o
xtqli.out : nrtype.o nrutil.o nr.o xtqli.o tqli.o pythag.o tred2.o
	$(F90) $(F90OPTS) -o xtqli.out nrtype.o nrutil.o nr.o xtqli.o tqli.o pythag.o tred2.o
xtrapzd.out : nrtype.o nrutil.o nr.o xtrapzd.o trapzd.o
	$(F90) $(F90OPTS) -o xtrapzd.out nrtype.o nrutil.o nr.o xtrapzd.o trapzd.o
xtred2.out : nrtype.o nrutil.o nr.o xtred2.o tred2.o
	$(F90) $(F90OPTS) -o xtred2.out nrtype.o nrutil.o nr.o xtred2.o tred2.o
xtridag.out : nrtype.o nrutil.o nr.o xtridag.o tridag.o
	$(F90) $(F90OPTS) -o xtridag.out nrtype.o nrutil.o nr.o xtridag.o tridag.o
xttest.out : nrtype.o nrutil.o nr.o ran_state.o xttest.o ttest.o avevar.o betai.o gasdev.o betacf.o gammln.o ran1.o
	$(F90) $(F90OPTS) -o xttest.out nrtype.o nrutil.o nr.o ran_state.o xttest.o ttest.o avevar.o betai.o gasdev.o betacf.o gammln.o ran1.o
xtutest.out : nrtype.o nrutil.o nr.o ran_state.o xtutest.o tutest.o avevar.o betai.o gasdev.o betacf.o gammln.o ran1.o
	$(F90) $(F90OPTS) -o xtutest.out nrtype.o nrutil.o nr.o ran_state.o xtutest.o tutest.o avevar.o betai.o gasdev.o betacf.o gammln.o ran1.o
xtwofft.out : nrtype.o nrutil.o nr.o xtwofft.o twofft.o four1.o fourrow.o
	$(F90) $(F90OPTS) -o xtwofft.out nrtype.o nrutil.o nr.o xtwofft.o twofft.o four1.o fourrow.o
xvander.out : nrtype.o nrutil.o nr.o xvander.o vander.o
	$(F90) $(F90OPTS) -o xvander.out nrtype.o nrutil.o nr.o xvander.o vander.o
xvegas.out : nrtype.o nrutil.o nr.o ran_state.o xvegas.o vegas.o ran1.o
	$(F90) $(F90OPTS) -o xvegas.out nrtype.o nrutil.o nr.o ran_state.o xvegas.o vegas.o ran1.o
xvoltra.out : nrtype.o nrutil.o nr.o xvoltra.o voltra.o lubksb.o ludcmp.o
	$(F90) $(F90OPTS) -o xvoltra.out nrtype.o nrutil.o nr.o xvoltra.o voltra.o lubksb.o ludcmp.o
xwt1.out : nrtype.o nrutil.o nr.o pwtset.o xwt1.o wt1.o pwt.o daub4.o select.o
	$(F90) $(F90OPTS) -o xwt1.out nrtype.o nrutil.o nr.o pwtset.o xwt1.o wt1.o pwt.o daub4.o select.o
xwtn.out : nrtype.o nrutil.o nr.o pwtset.o xwtn.o wtn.o pwt.o
	$(F90) $(F90OPTS) -o xwtn.out nrtype.o nrutil.o nr.o pwtset.o xwtn.o wtn.o pwt.o
xzbrac.out : nrtype.o nrutil.o nr.o xzbrac.o zbrac.o bessj0.o
	$(F90) $(F90OPTS) -o xzbrac.out nrtype.o nrutil.o nr.o xzbrac.o zbrac.o bessj0.o
xzbrak.out : nrtype.o nrutil.o nr.o xzbrak.o zbrak.o bessj0.o
	$(F90) $(F90OPTS) -o xzbrak.out nrtype.o nrutil.o nr.o xzbrak.o zbrak.o bessj0.o
xzrhqr.out : nrtype.o nrutil.o nr.o xzrhqr.o zrhqr.o balanc.o hqr.o indexx.o
	$(F90) $(F90OPTS) -o xzrhqr.out nrtype.o nrutil.o nr.o xzrhqr.o zrhqr.o balanc.o hqr.o indexx.o
xzroots.out : nrtype.o nrutil.o nr.o xzroots.o zroots.o laguer.o indexx.o
	$(F90) $(F90OPTS) -o xzroots.out nrtype.o nrutil.o nr.o xzroots.o zroots.o laguer.o indexx.o
badluk.out : nrtype.o nrutil.o nr.o badluk.o flmoon.o julday.o
fredex.out : nrtype.o nrutil.o nr.o fredex.o kermom.o quadmx.o wwghts.o lubksb.o ludcmp.o
sfroid.out : nrtype.o nrutil.o nr.o sfroid.o solvde.o plgndr.o difeq.o 
sphoot.out : nrtype.o nrutil.o nr.o odeint.o sphoot.o shoot.o rkqs.o rkck.o fmin.o newt.o fdjac.o lnsrch.o lubksb.o ludcmp.o

xairy.reslt: xairy.out
	xairy.out > xairy.reslt ; $(RM) xairy.out xairy.o

xamebsa.reslt: $(NRRESPDIR)/xamebsa.resp xamebsa.out
	xamebsa.out < $(NRRESPDIR)/xamebsa.resp > xamebsa.reslt ; $(RM) xamebsa.out xamebsa.o

xamoeba.reslt: xamoeba.out
	xamoeba.out > xamoeba.reslt ; $(RM) xamoeba.out xamoeba.o

xanneal.reslt: xanneal.out
	xanneal.out > xanneal.reslt ; $(RM) xanneal.out xanneal.o

xarcode.reslt: $(NRRESPDIR)/xarcode.resp xarcode.out
	xarcode.out < $(NRRESPDIR)/xarcode.resp > xarcode.reslt ; $(RM) xarcode.out xarcode.o

xavevar.reslt: xavevar.out
	xavevar.out > xavevar.reslt ; $(RM) xavevar.out xavevar.o

xbalanc.reslt: xbalanc.out
	xbalanc.out > xbalanc.reslt ; $(RM) xbalanc.out xbalanc.o

xbandec.reslt: xbandec.out
	xbandec.out > xbandec.reslt ; $(RM) xbandec.out xbandec.o

xbanmul.reslt: xbanmul.out
	xbanmul.out > xbanmul.reslt ; $(RM) xbanmul.out xbanmul.o

xbcucof.reslt: xbcucof.out
	xbcucof.out > xbcucof.reslt ; $(RM) xbcucof.out xbcucof.o

xbcuint.reslt: xbcuint.out
	xbcuint.out > xbcuint.reslt ; $(RM) xbcuint.out xbcuint.o

xbeschb.reslt: $(NRRESPDIR)/xbeschb.resp xbeschb.out
	xbeschb.out < $(NRRESPDIR)/xbeschb.resp > xbeschb.reslt ; $(RM) xbeschb.out xbeschb.o

xbessik.reslt: xbessik.out
	xbessik.out > xbessik.reslt ; $(RM) xbessik.out xbessik.o

xbnldev.reslt: $(NRRESPDIR)/xbnldev.resp xbnldev.out
	xbnldev.out < $(NRRESPDIR)/xbnldev.resp > xbnldev.reslt ; $(RM) xbnldev.out xbnldev.o

xbrent.reslt: xbrent.out
	xbrent.out > xbrent.reslt ; $(RM) xbrent.out xbrent.o

xbroydn.reslt: xbroydn.out
	xbroydn.out > xbroydn.reslt ; $(RM) xbroydn.out xbroydn.o

xbsstep.reslt: xbsstep.out
	xbsstep.out > xbsstep.reslt ; $(RM) xbsstep.out xbsstep.o

xcaldat.reslt: xcaldat.out
	xcaldat.out > xcaldat.reslt ; $(RM) xcaldat.out xcaldat.o

xchder.reslt: $(NRRESPDIR)/xchder.resp xchder.out
	xchder.out < $(NRRESPDIR)/xchder.resp > xchder.reslt ; $(RM) xchder.out xchder.o

xchebev.reslt: $(NRRESPDIR)/xchebev.resp xchebev.out
	xchebev.out < $(NRRESPDIR)/xchebev.resp > xchebev.reslt ; $(RM) xchebev.out xchebev.o

xchebft.reslt: $(NRRESPDIR)/xchebft.resp xchebft.out
	xchebft.out < $(NRRESPDIR)/xchebft.resp > xchebft.reslt ; $(RM) xchebft.out xchebft.o

xchebpc.reslt: $(NRRESPDIR)/xchebpc.resp xchebpc.out
	xchebpc.out < $(NRRESPDIR)/xchebpc.resp > xchebpc.reslt ; $(RM) xchebpc.out xchebpc.o

xchint.reslt: $(NRRESPDIR)/xchint.resp xchint.out
	xchint.out < $(NRRESPDIR)/xchint.resp > xchint.reslt ; $(RM) xchint.out xchint.o

xcholsl.reslt: xcholsl.out
	xcholsl.out > xcholsl.reslt ; $(RM) xcholsl.out xcholsl.o

xchsone.reslt: xchsone.out
	xchsone.out > xchsone.reslt ; $(RM) xchsone.out xchsone.o

xchstwo.reslt: xchstwo.out
	xchstwo.out > xchstwo.reslt ; $(RM) xchstwo.out xchstwo.o

xcisi.reslt: xcisi.out
	xcisi.out > xcisi.reslt ; $(RM) xcisi.out xcisi.o

xcntab1.reslt: xcntab1.out
	xcntab1.out > xcntab1.reslt ; $(RM) xcntab1.out xcntab1.o

xcntab2.reslt: xcntab2.out
	xcntab2.out > xcntab2.reslt ; $(RM) xcntab2.out xcntab2.o

xconvlv.reslt: xconvlv.out
	xconvlv.out > xconvlv.reslt ; $(RM) xconvlv.out xconvlv.o

xcorrel.reslt: xcorrel.out
	xcorrel.out > xcorrel.reslt ; $(RM) xcorrel.out xcorrel.o

xcosft1.reslt: $(NRRESPDIR)/xcosft1.resp xcosft1.out
	xcosft1.out < $(NRRESPDIR)/xcosft1.resp > xcosft1.reslt ; $(RM) xcosft1.out xcosft1.o

xcosft2.reslt: $(NRRESPDIR)/xcosft2.resp xcosft2.out
	xcosft2.out < $(NRRESPDIR)/xcosft2.resp > xcosft2.reslt ; $(RM) xcosft2.out xcosft2.o

xcovsrt.reslt: $(NRRESPDIR)/xcovsrt.resp xcovsrt.out
	xcovsrt.out < $(NRRESPDIR)/xcovsrt.resp > xcovsrt.reslt ; $(RM) xcovsrt.out xcovsrt.o

xcyclic.reslt: xcyclic.out
	xcyclic.out > xcyclic.reslt ; $(RM) xcyclic.out xcyclic.o

xdbrent.reslt: xdbrent.out
	xdbrent.out > xdbrent.reslt ; $(RM) xdbrent.out xdbrent.o

xddpoly.reslt: $(NRRESPDIR)/xddpoly.resp xddpoly.out
	xddpoly.out < $(NRRESPDIR)/xddpoly.resp > xddpoly.reslt ; $(RM) xddpoly.out xddpoly.o

xdecchk.reslt: $(NRRESPDIR)/xdecchk.resp xdecchk.out
	xdecchk.out < $(NRRESPDIR)/xdecchk.resp > xdecchk.reslt ; $(RM) xdecchk.out xdecchk.o

xdf1dim.reslt: $(NRRESPDIR)/xdf1dim.resp xdf1dim.out
	xdf1dim.out < $(NRRESPDIR)/xdf1dim.resp > xdf1dim.reslt ; $(RM) xdf1dim.out xdf1dim.o

xdfpmin.reslt: xdfpmin.out
	xdfpmin.out > xdfpmin.reslt ; $(RM) xdfpmin.out xdfpmin.o

xdfridr.reslt: $(NRRESPDIR)/xdfridr.resp xdfridr.out
	xdfridr.out < $(NRRESPDIR)/xdfridr.resp > xdfridr.reslt ; $(RM) xdfridr.out xdfridr.o

xdftint.reslt: $(NRRESPDIR)/xdftint.resp xdftint.out
	xdftint.out < $(NRRESPDIR)/xdftint.resp > xdftint.reslt ; $(RM) xdftint.out xdftint.o

xeclass.reslt: xeclass.out
	xeclass.out > xeclass.reslt ; $(RM) xeclass.out xeclass.o

xeclazz.reslt: xeclazz.out
	xeclazz.out > xeclazz.reslt ; $(RM) xeclazz.out xeclazz.o

xeigsrt.reslt: xeigsrt.out
	xeigsrt.out > xeigsrt.reslt ; $(RM) xeigsrt.out xeigsrt.o

xelmhes.reslt: xelmhes.out
	xelmhes.out > xelmhes.reslt ; $(RM) xelmhes.out xelmhes.o

xeulsum.reslt: $(NRRESPDIR)/xeulsum.resp xeulsum.out
	xeulsum.out < $(NRRESPDIR)/xeulsum.resp > xeulsum.reslt ; $(RM) xeulsum.out xeulsum.o

xevlmem.reslt: xevlmem.out
	xevlmem.out > xevlmem.reslt ; $(RM) xevlmem.out xevlmem.o

xexpdev.reslt: xexpdev.out
	xexpdev.out > xexpdev.reslt ; $(RM) xexpdev.out xexpdev.o

xf1dim.reslt: $(NRRESPDIR)/xf1dim.resp xf1dim.out
	xf1dim.out < $(NRRESPDIR)/xf1dim.resp > xf1dim.reslt ; $(RM) xf1dim.out xf1dim.o

xfasper.reslt: xfasper.out
	xfasper.out > xfasper.reslt ; $(RM) xfasper.out xfasper.o

xfgauss.reslt: xfgauss.out
	xfgauss.out > xfgauss.reslt ; $(RM) xfgauss.out xfgauss.o

xfit.reslt: xfit.out
	xfit.out > xfit.reslt ; $(RM) xfit.out xfit.o

xfitexy.reslt: xfitexy.out
	xfitexy.out > xfitexy.reslt ; $(RM) xfitexy.out xfitexy.o

xfixrts.reslt: xfixrts.out
	xfixrts.out > xfixrts.reslt ; $(RM) xfixrts.out xfixrts.o

xfleg.reslt: xfleg.out
	xfleg.out > xfleg.reslt ; $(RM) xfleg.out xfleg.o

xflmoon.reslt: $(NRRESPDIR)/xflmoon.resp xflmoon.out
	xflmoon.out < $(NRRESPDIR)/xflmoon.resp > xflmoon.reslt ; $(RM) xflmoon.out xflmoon.o

xfour1.reslt: $(NRRESPDIR)/xfour1.resp xfour1.out
	xfour1.out < $(NRRESPDIR)/xfour1.resp > xfour1.reslt ; $(RM) xfour1.out xfour1.o

xfpoly.reslt: xfpoly.out
	xfpoly.out > xfpoly.reslt ; $(RM) xfpoly.out xfpoly.o

xfred2.reslt: xfred2.out
	xfred2.out > xfred2.reslt ; $(RM) xfred2.out xfred2.o

xfredin.reslt: $(NRRESPDIR)/xfredin.resp xfredin.out
	xfredin.out < $(NRRESPDIR)/xfredin.resp > xfredin.reslt ; $(RM) xfredin.out xfredin.o

xfrenel.reslt: xfrenel.out
	xfrenel.out > xfrenel.reslt ; $(RM) xfrenel.out xfrenel.o

xfrprmn.reslt: xfrprmn.out
	xfrprmn.out > xfrprmn.reslt ; $(RM) xfrprmn.out xfrprmn.o

xftest.reslt: xftest.out
	xftest.out > xftest.reslt ; $(RM) xftest.out xftest.o

xgamdev.reslt: $(NRRESPDIR)/xgamdev.resp xgamdev.out
	xgamdev.out < $(NRRESPDIR)/xgamdev.resp > xgamdev.reslt ; $(RM) xgamdev.out xgamdev.o

xgasdev.reslt: xgasdev.out
	xgasdev.out > xgasdev.reslt ; $(RM) xgasdev.out xgasdev.o

xgaucof.reslt: $(NRRESPDIR)/xgaucof.resp xgaucof.out
	xgaucof.out < $(NRRESPDIR)/xgaucof.resp > xgaucof.reslt ; $(RM) xgaucof.out xgaucof.o

xgauher.reslt: $(NRRESPDIR)/xgauher.resp xgauher.out
	xgauher.out < $(NRRESPDIR)/xgauher.resp > xgauher.reslt ; $(RM) xgauher.out xgauher.o

xgaujac.reslt: $(NRRESPDIR)/xgaujac.resp xgaujac.out
	xgaujac.out < $(NRRESPDIR)/xgaujac.resp > xgaujac.reslt ; $(RM) xgaujac.out xgaujac.o

xgaulag.reslt: $(NRRESPDIR)/xgaulag.resp xgaulag.out
	xgaulag.out < $(NRRESPDIR)/xgaulag.resp > xgaulag.reslt ; $(RM) xgaulag.out xgaulag.o

xgauleg.reslt: xgauleg.out
	xgauleg.out > xgauleg.reslt ; $(RM) xgauleg.out xgauleg.o

xgaussj.reslt: $(NRRESPDIR)/xgaussj.resp xgaussj.out
	xgaussj.out < $(NRRESPDIR)/xgaussj.resp > xgaussj.reslt ; $(RM) xgaussj.out xgaussj.o

xgolden.reslt: xgolden.out
	xgolden.out > xgolden.reslt ; $(RM) xgolden.out xgolden.o

xhqr.reslt: xhqr.out
	xhqr.out > xhqr.reslt ; $(RM) xhqr.out xhqr.o

xhuffman.reslt: $(NRRESPDIR)/xhuffman.resp xhuffman.out
	xhuffman.out < $(NRRESPDIR)/xhuffman.resp > xhuffman.reslt ; $(RM) xhuffman.out xhuffman.o

xhunt.reslt: xhunt.out
	xhunt.out > xhunt.reslt ; $(RM) xhunt.out xhunt.o

xhypgeo.reslt: $(NRRESPDIR)/xhypgeo.resp xhypgeo.out
	xhypgeo.out < $(NRRESPDIR)/xhypgeo.resp > xhypgeo.reslt ; $(RM) xhypgeo.out xhypgeo.o

xicrc.reslt: $(NRRESPDIR)/xicrc.resp xicrc.out
	xicrc.out < $(NRRESPDIR)/xicrc.resp > xicrc.reslt ; $(RM) xicrc.out xicrc.o

xigray.reslt: $(NRRESPDIR)/xigray.resp xigray.out
	xigray.out < $(NRRESPDIR)/xigray.resp > xigray.reslt ; $(RM) xigray.out xigray.o

xirbit1.reslt: xirbit1.out
	xirbit1.out > xirbit1.reslt ; $(RM) xirbit1.out xirbit1.o

xirbit2.reslt: xirbit2.out
	xirbit2.out > xirbit2.reslt ; $(RM) xirbit2.out xirbit2.o

xjacobi.reslt: $(NRRESPDIR)/xjacobi.resp xjacobi.out
	xjacobi.out < $(NRRESPDIR)/xjacobi.resp > xjacobi.reslt ; $(RM) xjacobi.out xjacobi.o

xjulday.reslt: $(NRRESPDIR)/xjulday.resp xjulday.out
	xjulday.out < $(NRRESPDIR)/xjulday.resp > xjulday.reslt ; $(RM) xjulday.out xjulday.o

xkendl1.reslt: xkendl1.out
	xkendl1.out > xkendl1.reslt ; $(RM) xkendl1.out xkendl1.o

xkendl2.reslt: $(NRRESPDIR)/xkendl2.resp xkendl2.out
	xkendl2.out < $(NRRESPDIR)/xkendl2.resp > xkendl2.reslt ; $(RM) xkendl2.out xkendl2.o

xks2d1s.reslt: $(NRRESPDIR)/xks2d1s.resp xks2d1s.out
	xks2d1s.out < $(NRRESPDIR)/xks2d1s.resp > xks2d1s.reslt ; $(RM) xks2d1s.out xks2d1s.o

xks2d2s.reslt: $(NRRESPDIR)/xks2d2s.resp xks2d2s.out
	xks2d2s.out < $(NRRESPDIR)/xks2d2s.resp > xks2d2s.reslt ; $(RM) xks2d2s.out xks2d2s.o

xksone.reslt: xksone.out
	xksone.out > xksone.reslt ; $(RM) xksone.out xksone.o

xkstwo.reslt: xkstwo.out
	xkstwo.out > xkstwo.reslt ; $(RM) xkstwo.out xkstwo.o

xlaguer.reslt: xlaguer.out
	xlaguer.out > xlaguer.reslt ; $(RM) xlaguer.out xlaguer.o

xlfit.reslt: $(NRRESPDIR)/xlfit.resp xlfit.out
	xlfit.out < $(NRRESPDIR)/xlfit.resp > xlfit.reslt ; $(RM) xlfit.out xlfit.o

xlinbcg.reslt: $(NRRESPDIR)/xlinbcg.resp xlinbcg.out
	xlinbcg.out < $(NRRESPDIR)/xlinbcg.resp > xlinbcg.reslt ; $(RM) xlinbcg.out xlinbcg.o

xlinmin.reslt: xlinmin.out
	xlinmin.out > xlinmin.reslt ; $(RM) xlinmin.out xlinmin.o

xlocate.reslt: xlocate.out
	xlocate.out > xlocate.reslt ; $(RM) xlocate.out xlocate.o

xlubksb.reslt: $(NRRESPDIR)/xlubksb.resp xlubksb.out
	xlubksb.out < $(NRRESPDIR)/xlubksb.resp > xlubksb.reslt ; $(RM) xlubksb.out xlubksb.o

xludcmp.reslt: $(NRRESPDIR)/xludcmp.resp xludcmp.out
	xludcmp.out < $(NRRESPDIR)/xludcmp.resp > xludcmp.reslt ; $(RM) xludcmp.out xludcmp.o

xmachar.reslt: xmachar.out
	xmachar.out > xmachar.reslt ; $(RM) xmachar.out xmachar.o

xmedfit.reslt: xmedfit.out
	xmedfit.out > xmedfit.reslt ; $(RM) xmedfit.out xmedfit.o

xmemcof.reslt: xmemcof.out
	xmemcof.out > xmemcof.reslt ; $(RM) xmemcof.out xmemcof.o

xmgfas.reslt: xmgfas.out
	xmgfas.out > xmgfas.reslt ; $(RM) xmgfas.out xmgfas.o

xmglin.reslt: xmglin.out
	xmglin.out > xmglin.reslt ; $(RM) xmglin.out xmglin.o

xmidpnt.reslt: xmidpnt.out
	xmidpnt.out > xmidpnt.reslt ; $(RM) xmidpnt.out xmidpnt.o

xmiser.reslt: $(NRRESPDIR)/xmiser.resp xmiser.out
	xmiser.out < $(NRRESPDIR)/xmiser.resp > xmiser.reslt ; $(RM) xmiser.out xmiser.o

xmmid.reslt: $(NRRESPDIR)/xmmid.resp xmmid.out
	xmmid.out < $(NRRESPDIR)/xmmid.resp > xmmid.reslt ; $(RM) xmmid.out xmmid.o

xmnbrak.reslt: xmnbrak.out
	xmnbrak.out > xmnbrak.reslt ; $(RM) xmnbrak.out xmnbrak.o

xmnewt.reslt: $(NRRESPDIR)/xmnewt.resp xmnewt.out
	xmnewt.out < $(NRRESPDIR)/xmnewt.resp > xmnewt.reslt ; $(RM) xmnewt.out xmnewt.o

xmoment.reslt: xmoment.out
	xmoment.out > xmoment.reslt ; $(RM) xmoment.out xmoment.o

xmppi.reslt: $(NRRESPDIR)/xmppi.resp xmppi.out
	xmppi.out < $(NRRESPDIR)/xmppi.resp > xmppi.reslt ; $(RM) xmppi.out xmppi.o

xmprove.reslt: xmprove.out
	xmprove.out > xmprove.reslt ; $(RM) xmprove.out xmprove.o

xmrqmin.reslt: $(NRRESPDIR)/xmrqmin.resp xmrqmin.out
	xmrqmin.out < $(NRRESPDIR)/xmrqmin.resp > xmrqmin.reslt ; $(RM) xmrqmin.out xmrqmin.o

xnewt.reslt: xnewt.out
	xnewt.out > xnewt.reslt ; $(RM) xnewt.out xnewt.o

xodeint.reslt: xodeint.out
	xodeint.out > xodeint.reslt ; $(RM) xodeint.out xodeint.o

xorthog.reslt: $(NRRESPDIR)/xorthog.resp xorthog.out
	xorthog.out < $(NRRESPDIR)/xorthog.resp > xorthog.reslt ; $(RM) xorthog.out xorthog.o

xpade.reslt: $(NRRESPDIR)/xpade.resp xpade.out
	xpade.out < $(NRRESPDIR)/xpade.resp > xpade.reslt ; $(RM) xpade.out xpade.o

xpccheb.reslt: xpccheb.out
	xpccheb.out > xpccheb.reslt ; $(RM) xpccheb.out xpccheb.o

xpcshft.reslt: $(NRRESPDIR)/xpcshft.resp xpcshft.out
	xpcshft.out < $(NRRESPDIR)/xpcshft.resp > xpcshft.reslt ; $(RM) xpcshft.out xpcshft.o

xpearsn.reslt: xpearsn.out
	xpearsn.out > xpearsn.reslt ; $(RM) xpearsn.out xpearsn.o

xperiod.reslt: xperiod.out
	xperiod.out > xperiod.reslt ; $(RM) xperiod.out xperiod.o

xpoidev.reslt: $(NRRESPDIR)/xpoidev.resp xpoidev.out
	xpoidev.out < $(NRRESPDIR)/xpoidev.resp > xpoidev.reslt ; $(RM) xpoidev.out xpoidev.o

xpolcoe.reslt: $(NRRESPDIR)/xpolcoe.resp xpolcoe.out
	xpolcoe.out < $(NRRESPDIR)/xpolcoe.resp > xpolcoe.reslt ; $(RM) xpolcoe.out xpolcoe.o

xpolcof.reslt: $(NRRESPDIR)/xpolcof.resp xpolcof.out
	xpolcof.out < $(NRRESPDIR)/xpolcof.resp > xpolcof.reslt ; $(RM) xpolcof.out xpolcof.o

xpoldiv.reslt: xpoldiv.out
	xpoldiv.out > xpoldiv.reslt ; $(RM) xpoldiv.out xpoldiv.o

xpolin2.reslt: xpolin2.out
	xpolin2.out > xpolin2.reslt ; $(RM) xpolin2.out xpolin2.o

xpolint.reslt: $(NRRESPDIR)/xpolint.resp xpolint.out
	xpolint.out < $(NRRESPDIR)/xpolint.resp > xpolint.reslt ; $(RM) xpolint.out xpolint.o

xpowell.reslt: xpowell.out
	xpowell.out > xpowell.reslt ; $(RM) xpowell.out xpowell.o

xpredic.reslt: xpredic.out
	xpredic.out > xpredic.reslt ; $(RM) xpredic.out xpredic.o

xprobks.reslt: xprobks.out
	xprobks.out > xprobks.reslt ; $(RM) xprobks.out xprobks.o

xpsdes.reslt: xpsdes.out
	xpsdes.out > xpsdes.reslt ; $(RM) xpsdes.out xpsdes.o

xpzextr.reslt: xpzextr.out
	xpzextr.out > xpzextr.reslt ; $(RM) xpzextr.out xpzextr.o

xqrdcmp.reslt: $(NRRESPDIR)/xqrdcmp.resp xqrdcmp.out
	xqrdcmp.out < $(NRRESPDIR)/xqrdcmp.resp > xqrdcmp.reslt ; $(RM) xqrdcmp.out xqrdcmp.o

xqromo.reslt: xqromo.out
	xqromo.out > xqromo.reslt ; $(RM) xqromo.out xqromo.o

xqroot.reslt: xqroot.out
	xqroot.out > xqroot.reslt ; $(RM) xqroot.out xqroot.o

xqrsolv.reslt: $(NRRESPDIR)/xqrsolv.resp xqrsolv.out
	xqrsolv.out < $(NRRESPDIR)/xqrsolv.resp > xqrsolv.reslt ; $(RM) xqrsolv.out xqrsolv.o

xqrupdt.reslt: $(NRRESPDIR)/xqrupdt.resp xqrupdt.out
	xqrupdt.out < $(NRRESPDIR)/xqrupdt.resp > xqrupdt.reslt ; $(RM) xqrupdt.out xqrupdt.o

xquad3d.reslt: xquad3d.out
	xquad3d.out > xquad3d.reslt ; $(RM) xquad3d.out xquad3d.o

xran.reslt: xran.out
	xran.out > xran.reslt ; $(RM) xran.out xran.o

xrank.reslt: $(NRRESPDIR)/xrank.resp xrank.out
	xrank.out < $(NRRESPDIR)/xrank.resp > xrank.reslt ; $(RM) xrank.out xrank.o

xratint.reslt: xratint.out
	xratint.out > xratint.reslt ; $(RM) xratint.out xratint.o

xrealft.reslt: $(NRRESPDIR)/xrealft.resp xrealft.out
	xrealft.out < $(NRRESPDIR)/xrealft.resp > xrealft.reslt ; $(RM) xrealft.out xrealft.o

xrk4.reslt: xrk4.out
	xrk4.out > xrk4.reslt ; $(RM) xrk4.out xrk4.o

xrkdumb.reslt: xrkdumb.out
	xrkdumb.out > xrkdumb.reslt ; $(RM) xrkdumb.out xrkdumb.o

xrkqs.reslt: xrkqs.out
	xrkqs.out > xrkqs.reslt ; $(RM) xrkqs.out xrkqs.o

xrlft3.reslt: xrlft3.out
	xrlft3.out > xrlft3.reslt ; $(RM) xrlft3.out xrlft3.o

xrzextr.reslt: xrzextr.out
	xrzextr.out > xrzextr.reslt ; $(RM) xrzextr.out xrzextr.o

xsavgol.reslt: xsavgol.out
	xsavgol.out > xsavgol.reslt ; $(RM) xsavgol.out xsavgol.o

xscrsho.reslt: $(NRRESPDIR)/xscrsho.resp xscrsho.out
	xscrsho.out < $(NRRESPDIR)/xscrsho.resp > xscrsho.reslt ; $(RM) xscrsho.out xscrsho.o

xsimpr.reslt: xsimpr.out
	xsimpr.out > xsimpr.reslt ; $(RM) xsimpr.out xsimpr.o

xsinft.reslt: $(NRRESPDIR)/xsinft.resp xsinft.out
	xsinft.out < $(NRRESPDIR)/xsinft.resp > xsinft.reslt ; $(RM) xsinft.out xsinft.o

xsncndn.reslt: xsncndn.out
	xsncndn.out > xsncndn.reslt ; $(RM) xsncndn.out xsncndn.o

xsobseq.reslt: xsobseq.out
	xsobseq.out > xsobseq.reslt ; $(RM) xsobseq.out xsobseq.o

xsor.reslt: xsor.out
	xsor.out > xsor.reslt ; $(RM) xsor.out xsor.o

xsort2.reslt: $(NRRESPDIR)/xsort2.resp xsort2.out
	xsort2.out < $(NRRESPDIR)/xsort2.resp > xsort2.reslt ; $(RM) xsort2.out xsort2.o

xsort3.reslt: xsort3.out
	xsort3.out > xsort3.reslt ; $(RM) xsort3.out xsort3.o

xspctrm.reslt: xspctrm.out
	xspctrm.out > xspctrm.reslt ; $(RM) xspctrm.out xspctrm.o

xspear.reslt: xspear.out
	xspear.out > xspear.reslt ; $(RM) xspear.out xspear.o

xsphfpt.reslt: $(NRRESPDIR)/xsphfpt.resp xsphfpt.out
	xsphfpt.out < $(NRRESPDIR)/xsphfpt.resp > xsphfpt.reslt ; $(RM) xsphfpt.out xsphfpt.o

xsplie2.reslt: xsplie2.out
	xsplie2.out > xsplie2.reslt ; $(RM) xsplie2.out xsplie2.o

xsplin2.reslt: xsplin2.out
	xsplin2.out > xsplin2.reslt ; $(RM) xsplin2.out xsplin2.o

xspline.reslt: xspline.out
	xspline.out > xspline.reslt ; $(RM) xspline.out xspline.o

xsplint.reslt: $(NRRESPDIR)/xsplint.resp xsplint.out
	xsplint.out < $(NRRESPDIR)/xsplint.resp > xsplint.reslt ; $(RM) xsplint.out xsplint.o

xstifbs.reslt: $(NRRESPDIR)/xstifbs.resp xstifbs.out
	xstifbs.out < $(NRRESPDIR)/xstifbs.resp > xstifbs.reslt ; $(RM) xstifbs.out xstifbs.o

xstiff.reslt: $(NRRESPDIR)/xstiff.resp xstiff.out
	xstiff.out < $(NRRESPDIR)/xstiff.resp > xstiff.reslt ; $(RM) xstiff.out xstiff.o

xstoerm.reslt: xstoerm.out
	xstoerm.out > xstoerm.reslt ; $(RM) xstoerm.out xstoerm.o

xsvbksb.reslt: $(NRRESPDIR)/xsvbksb.resp xsvbksb.out
	xsvbksb.out < $(NRRESPDIR)/xsvbksb.resp > xsvbksb.reslt ; $(RM) xsvbksb.out xsvbksb.o

xsvdcmp.reslt: $(NRRESPDIR)/xsvdcmp.resp xsvdcmp.out
	xsvdcmp.out < $(NRRESPDIR)/xsvdcmp.resp > xsvdcmp.reslt ; $(RM) xsvdcmp.out xsvdcmp.o

xsvdfit.reslt: xsvdfit.out
	xsvdfit.out > xsvdfit.reslt ; $(RM) xsvdfit.out xsvdfit.o

xsvdvar.reslt: xsvdvar.out
	xsvdvar.out > xsvdvar.reslt ; $(RM) xsvdvar.out xsvdvar.o

xtoeplz.reslt: xtoeplz.out
	xtoeplz.out > xtoeplz.reslt ; $(RM) xtoeplz.out xtoeplz.o

xtptest.reslt: xtptest.out
	xtptest.out > xtptest.reslt ; $(RM) xtptest.out xtptest.o

xtqli.reslt: $(NRRESPDIR)/xtqli.resp xtqli.out
	xtqli.out < $(NRRESPDIR)/xtqli.resp > xtqli.reslt ; $(RM) xtqli.out xtqli.o

xtrapzd.reslt: xtrapzd.out
	xtrapzd.out > xtrapzd.reslt ; $(RM) xtrapzd.out xtrapzd.o

xtred2.reslt: xtred2.out
	xtred2.out > xtred2.reslt ; $(RM) xtred2.out xtred2.o

xtridag.reslt: $(NRRESPDIR)/xtridag.resp xtridag.out
	xtridag.out < $(NRRESPDIR)/xtridag.resp > xtridag.reslt ; $(RM) xtridag.out xtridag.o

xttest.reslt: xttest.out
	xttest.out > xttest.reslt ; $(RM) xttest.out xttest.o

xtutest.reslt: xtutest.out
	xtutest.out > xtutest.reslt ; $(RM) xtutest.out xtutest.o

xtwofft.reslt: $(NRRESPDIR)/xtwofft.resp xtwofft.out
	xtwofft.out < $(NRRESPDIR)/xtwofft.resp > xtwofft.reslt ; $(RM) xtwofft.out xtwofft.o

xvander.reslt: xvander.out
	xvander.out > xvander.reslt ; $(RM) xvander.out xvander.o

xvegas.reslt: $(NRRESPDIR)/xvegas.resp xvegas.out
	xvegas.out < $(NRRESPDIR)/xvegas.resp > xvegas.reslt ; $(RM) xvegas.out xvegas.o

xvoltra.reslt: xvoltra.out
	xvoltra.out > xvoltra.reslt ; $(RM) xvoltra.out xvoltra.o

xwt1.reslt: $(NRRESPDIR)/xwt1.resp xwt1.out
	xwt1.out < $(NRRESPDIR)/xwt1.resp > xwt1.reslt ; $(RM) xwt1.out xwt1.o

xwtn.reslt: xwtn.out
	xwtn.out > xwtn.reslt ; $(RM) xwtn.out xwtn.o

xzbrac.reslt: xzbrac.out
	xzbrac.out > xzbrac.reslt ; $(RM) xzbrac.out xzbrac.o

xzbrak.reslt: xzbrak.out
	xzbrak.out > xzbrak.reslt ; $(RM) xzbrak.out xzbrak.o

xzrhqr.reslt: xzrhqr.out
	xzrhqr.out > xzrhqr.reslt ; $(RM) xzrhqr.out xzrhqr.o

xzroots.reslt: xzroots.out
	xzroots.out > xzroots.reslt ; $(RM) xzroots.out xzroots.o

badluk.reslt: badluk.out
	badluk.out > badluk.reslt ; $(RM) badluk.out badluk.o

fredex.reslt: fredex.out
	fredex.out > fredex.reslt ; $(RM) fredex.out fredex.o

sfroid.reslt: $(NRRESPDIR)/sfroid.resp sfroid.out
	sfroid.out < $(NRRESPDIR)/sfroid.resp > sfroid.reslt ; $(RM) sfroid.out sfroid.o

sphoot.reslt: $(NRRESPDIR)/sphoot.resp sphoot.out
	sphoot.out < $(NRRESPDIR)/sphoot.resp > sphoot.reslt ; $(RM) sphoot.out sphoot.o


DATES.DAT:
	/bin/cp $(NRDAT)/DATES.DAT .

FNCVAL.DAT:
	/bin/cp $(NRDAT)/FNCVAL.DAT .

MATRX1.DAT:
	/bin/cp $(NRDAT)/MATRX1.DAT .

MATRX2.DAT:
	/bin/cp $(NRDAT)/MATRX2.DAT .

MATRX3.DAT:
	/bin/cp $(NRDAT)/MATRX3.DAT .

SPCTRL.DAT:
	/bin/cp $(NRDAT)/SPCTRL.DAT .

TABLE.DAT:
	/bin/cp $(NRDAT)/TABLE.DAT .

TABLE2.DAT:
	/bin/cp $(NRDAT)/TABLE2.DAT .

TARRAY.DAT:
	/bin/cp $(NRDAT)/TARRAY.DAT .

TEXT.DAT:
	/bin/cp $(NRDAT)/TEXT.DAT .


dat: DATES.DAT FNCVAL.DAT MATRX1.DAT MATRX2.DAT MATRX3.DAT SPCTRL.DAT TABLE.DAT TABLE2.DAT TARRAY.DAT TEXT.DAT


clean:
	/bin/rm *.o *.mod


LIBOB = airy.o amebsa.o amoeba.o anneal.o arcmak.o arcode.o asolve.o atimes.o \
avevar.o balanc.o banbks.o bandec.o banmul.o bcucof.o bcuint.o beschb.o \
bessi.o bessi0.o bessi1.o bessik.o bessj.o bessj0.o bessj1.o bessjy.o \
bessk.o bessk0.o bessk1.o bessy.o bessy0.o bessy1.o beta.o betacf.o \
betai.o bico.o bnldev.o brent.o broydn.o bsstep.o caldat.o chder.o \
chebev.o chebft.o chebpc.o chint.o chixy.o choldc.o cholsl.o chsone.o \
chstwo.o cisi.o cntab1.o cntab2.o convlv.o correl.o cosft1.o cosft2.o \
covsrt.o cyclic.o daub4.o dawson.o dbrent.o ddpoly.o decchk.o dfpmin.o \
dfridr.o dftcor.o dftint.o difeq.o dlinmin.o eclass.o eclazz.o ei.o \
eigsrt.o elle.o ellf.o ellpi.o elmhes.o erf.o erfc.o erfcc.o eulsum.o \
evlmem.o expdev.o expint.o factln.o factrl.o fasper.o fdjac.o fgauss.o \
fit.o fitexy.o fixrts.o fleg.o flmoon.o fmin.o four1.o four1_alt.o \
four1_gather.o four2.o four2_alt.o four3.o four3_alt.o fourcol.o \
fourcol_3d.o fourn_gather.o fourrow.o fourrow_3d.o  fpoly.o \
fred2.o fredin.o frenel.o frprmn.o ftest.o gamdev.o gammln.o gammp.o \
gammq.o gasdev.o gaucof.o gauher.o gaujac.o gaulag.o gauleg.o gaussj.o \
gcf.o golden.o gser.o hqr.o hufdec.o hufenc.o hufmak.o hunt.o hypdrv.o \
hypgeo.o hypser.o icrc.o igray.o index_bypack.o indexx.o interp.o \
irbit1.o irbit2.o jacobi.o jacobn.o julday.o kendl1.o kendl2.o kermom.o \
ks2d1s.o ks2d2s.o ksone.o kstwo.o laguer.o lfit.o linbcg.o linmin.o \
lnsrch.o locate.o lop.o lubksb.o ludcmp.o machar.o medfit.o memcof.o \
mgfas.o mglin.o midexp.o midinf.o midpnt.o midsql.o midsqu.o miser.o \
mmid.o mnbrak.o mnewt.o moment.o mp2dfr.o mpdiv.o mpinv.o mpmul.o \
mpops.o mppi.o mprove.o mpsqrt.o mrqmin.o newt.o nr.o  nrtype.o \
nrutil.o odeint.o orthog.o pade.o pccheb.o pcshft.o pearsn.o period.o \
plgndr.o poidev.o polcoe.o polcof.o poldiv.o polin2.o polint.o powell.o \
predic.o probks.o psdes.o pwt.o pwtset.o pythag.o pzextr.o qrdcmp.o \
qromb.o qromo.o qroot.o qrsolv.o qrupdt.o qsimp.o qtrap.o quad3d.o \
quadct.o quadmx.o quadvl.o ran.o ran0.o ran1.o ran2.o ran3.o ran_state.o \
rank.o ratint.o ratlsq.o ratval.o rc.o rd.o realft.o recur1.o recur2.o \
relax.o relax2.o resid.o rf.o rj.o rk4.o rkck.o rkdumb.o rkqs.o rlft2.o \
rlft3.o rotate.o rsolv.o rstrct.o rtbis.o rtflsp.o rtnewt.o rtsafe.o \
rtsec.o rzextr.o savgol.o scrsho.o select.o select_bypack.o \
select_heap.o select_inplace.o simplx.o simpr.o sinft.o slvsm2.o \
slvsml.o sncndn.o snrm.o sobseq.o solvde.o sor.o sort.o sort2.o sort3.o \
sort_bypack.o sort_byreshape.o sort_heap.o sort_pick.o sort_radix.o \
sort_shell.o  spctrm.o spear.o sphbes.o splie2.o splin2.o \
spline.o splint.o sprsax.o sprsdiag.o sprsin.o sprstp.o sprstx.o \
stifbs.o stiff.o stoerm.o svbksb.o svdcmp.o svdfit.o svdvar.o toeplz.o \
tptest.o tqli.o trapzd.o tred2.o tridag.o ttest.o tutest.o twofft.o \
vander.o vegas.o voltra.o wt1.o wtn.o wwghts.o zbrac.o zbrak.o zbrent.o \
zrhqr.o zriddr.o zroots.o

lib: $(LIBOB)
	ar r librecipes_f90.a $(LIBOB)

objects: $(LIBOB) badluk.o fredex.o shoot.o sphoot.o
	echo "Object files made"


airy.o : $(NRF90DIR)/airy.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/airy.f90
amebsa.o : $(NRF90DIR)/amebsa.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/amebsa.f90
amoeba.o : $(NRF90DIR)/amoeba.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/amoeba.f90
anneal.o : $(NRF90DIR)/anneal.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/anneal.f90
arcmak.o : $(NRF90DIR)/arcmak.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/arcmak.f90
arcode.o : $(NRF90DIR)/arcode.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/arcode.f90
asolve.o : $(NRF90DIR)/asolve.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/asolve.f90
atimes.o : $(NRF90DIR)/atimes.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/atimes.f90
avevar.o : $(NRF90DIR)/avevar.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/avevar.f90
badluk.o : $(NRF90DIR)/badluk.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/badluk.f90
balanc.o : $(NRF90DIR)/balanc.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/balanc.f90
banbks.o : $(NRF90DIR)/banbks.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/banbks.f90
bandec.o : $(NRF90DIR)/bandec.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bandec.f90
banmul.o : $(NRF90DIR)/banmul.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/banmul.f90
bcucof.o : $(NRF90DIR)/bcucof.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bcucof.f90
bcuint.o : $(NRF90DIR)/bcuint.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bcuint.f90
beschb.o : $(NRF90DIR)/beschb.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/beschb.f90
bessi.o : $(NRF90DIR)/bessi.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessi.f90
bessi0.o : $(NRF90DIR)/bessi0.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessi0.f90
bessi1.o : $(NRF90DIR)/bessi1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessi1.f90
bessik.o : $(NRF90DIR)/bessik.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessik.f90
bessj.o : $(NRF90DIR)/bessj.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessj.f90
bessj0.o : $(NRF90DIR)/bessj0.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessj0.f90
bessj1.o : $(NRF90DIR)/bessj1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessj1.f90
bessjy.o : $(NRF90DIR)/bessjy.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessjy.f90
bessk.o : $(NRF90DIR)/bessk.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessk.f90
bessk0.o : $(NRF90DIR)/bessk0.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessk0.f90
bessk1.o : $(NRF90DIR)/bessk1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessk1.f90
bessy.o : $(NRF90DIR)/bessy.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessy.f90
bessy0.o : $(NRF90DIR)/bessy0.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessy0.f90
bessy1.o : $(NRF90DIR)/bessy1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bessy1.f90
beta.o : $(NRF90DIR)/beta.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/beta.f90
betacf.o : $(NRF90DIR)/betacf.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/betacf.f90
betai.o : $(NRF90DIR)/betai.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/betai.f90
bico.o : $(NRF90DIR)/bico.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bico.f90
bnldev.o : $(NRF90DIR)/bnldev.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bnldev.f90
brent.o : $(NRF90DIR)/brent.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/brent.f90
broydn.o : $(NRF90DIR)/broydn.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/broydn.f90
bsstep.o : $(NRF90DIR)/bsstep.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/bsstep.f90
caldat.o : $(NRF90DIR)/caldat.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/caldat.f90
chder.o : $(NRF90DIR)/chder.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/chder.f90
chebev.o : $(NRF90DIR)/chebev.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/chebev.f90
chebft.o : $(NRF90DIR)/chebft.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/chebft.f90
chebpc.o : $(NRF90DIR)/chebpc.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/chebpc.f90
chint.o : $(NRF90DIR)/chint.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/chint.f90
chixy.o : $(NRF90DIR)/chixy.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/chixy.f90
choldc.o : $(NRF90DIR)/choldc.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/choldc.f90
cholsl.o : $(NRF90DIR)/cholsl.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/cholsl.f90
chsone.o : $(NRF90DIR)/chsone.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/chsone.f90
chstwo.o : $(NRF90DIR)/chstwo.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/chstwo.f90
cisi.o : $(NRF90DIR)/cisi.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/cisi.f90
cntab1.o : $(NRF90DIR)/cntab1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/cntab1.f90
cntab2.o : $(NRF90DIR)/cntab2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/cntab2.f90
convlv.o : $(NRF90DIR)/convlv.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/convlv.f90
correl.o : $(NRF90DIR)/correl.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/correl.f90
cosft1.o : $(NRF90DIR)/cosft1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/cosft1.f90
cosft2.o : $(NRF90DIR)/cosft2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/cosft2.f90
covsrt.o : $(NRF90DIR)/covsrt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/covsrt.f90
cyclic.o : $(NRF90DIR)/cyclic.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/cyclic.f90
daub4.o : $(NRF90DIR)/daub4.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/daub4.f90
dawson.o : $(NRF90DIR)/dawson.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/dawson.f90
dbrent.o : $(NRF90DIR)/dbrent.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/dbrent.f90
ddpoly.o : $(NRF90DIR)/ddpoly.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ddpoly.f90
decchk.o : $(NRF90DIR)/decchk.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/decchk.f90
dfpmin.o : $(NRF90DIR)/dfpmin.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/dfpmin.f90
dfridr.o : $(NRF90DIR)/dfridr.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/dfridr.f90
dftcor.o : $(NRF90DIR)/dftcor.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/dftcor.f90
dftint.o : $(NRF90DIR)/dftint.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/dftint.f90
difeq.o : $(NRF90DIR)/difeq.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/difeq.f90
dlinmin.o : $(NRF90DIR)/dlinmin.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/dlinmin.f90
eclass.o : $(NRF90DIR)/eclass.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/eclass.f90
eclazz.o : $(NRF90DIR)/eclazz.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/eclazz.f90
ei.o : $(NRF90DIR)/ei.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ei.f90
eigsrt.o : $(NRF90DIR)/eigsrt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/eigsrt.f90
elle.o : $(NRF90DIR)/elle.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/elle.f90
ellf.o : $(NRF90DIR)/ellf.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ellf.f90
ellpi.o : $(NRF90DIR)/ellpi.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ellpi.f90
elmhes.o : $(NRF90DIR)/elmhes.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/elmhes.f90
erf.o : $(NRF90DIR)/erf.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/erf.f90
erfc.o : $(NRF90DIR)/erfc.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/erfc.f90
erfcc.o : $(NRF90DIR)/erfcc.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/erfcc.f90
eulsum.o : $(NRF90DIR)/eulsum.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/eulsum.f90
evlmem.o : $(NRF90DIR)/evlmem.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/evlmem.f90
expdev.o : $(NRF90DIR)/expdev.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/expdev.f90
expint.o : $(NRF90DIR)/expint.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/expint.f90
factln.o : $(NRF90DIR)/factln.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/factln.f90
factrl.o : $(NRF90DIR)/factrl.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/factrl.f90
fasper.o : $(NRF90DIR)/fasper.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fasper.f90
fdjac.o : $(NRF90DIR)/fdjac.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fdjac.f90
fgauss.o : $(NRF90DIR)/fgauss.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fgauss.f90
fit.o : $(NRF90DIR)/fit.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fit.f90
fitexy.o : $(NRF90DIR)/fitexy.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fitexy.f90
fixrts.o : $(NRF90DIR)/fixrts.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fixrts.f90
fleg.o : $(NRF90DIR)/fleg.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fleg.f90
flmoon.o : $(NRF90DIR)/flmoon.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/flmoon.f90
fmin.o : $(NRF90DIR)/fmin.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fmin.f90
four1.o : $(NRF90DIR)/four1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/four1.f90
four1_alt.o : $(NRF90DIR)/four1_alt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/four1_alt.f90
four1_gather.o : $(NRF90DIR)/four1_gather.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/four1_gather.f90
four2.o : $(NRF90DIR)/four2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/four2.f90
four2_alt.o : $(NRF90DIR)/four2_alt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/four2_alt.f90
four3.o : $(NRF90DIR)/four3.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/four3.f90
four3_alt.o : $(NRF90DIR)/four3_alt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/four3_alt.f90
fourcol.o : $(NRF90DIR)/fourcol.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fourcol.f90
fourcol_3d.o : $(NRF90DIR)/fourcol_3d.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fourcol_3d.f90
fourn_gather.o : $(NRF90DIR)/fourn_gather.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fourn_gather.f90
fourrow.o : $(NRF90DIR)/fourrow.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fourrow.f90
fourrow_3d.o : $(NRF90DIR)/fourrow_3d.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fourrow_3d.f90
fpoly.o : $(NRF90DIR)/fpoly.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fpoly.f90
fred2.o : $(NRF90DIR)/fred2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fred2.f90
fredex.o : $(NRF90DIR)/fredex.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fredex.f90
fredin.o : $(NRF90DIR)/fredin.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/fredin.f90
frenel.o : $(NRF90DIR)/frenel.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/frenel.f90
frprmn.o : $(NRF90DIR)/frprmn.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/frprmn.f90
ftest.o : $(NRF90DIR)/ftest.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ftest.f90
gamdev.o : $(NRF90DIR)/gamdev.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gamdev.f90
gammln.o : $(NRF90DIR)/gammln.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gammln.f90
gammp.o : $(NRF90DIR)/gammp.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gammp.f90
gammq.o : $(NRF90DIR)/gammq.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gammq.f90
gasdev.o : $(NRF90DIR)/gasdev.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gasdev.f90
gaucof.o : $(NRF90DIR)/gaucof.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gaucof.f90
gauher.o : $(NRF90DIR)/gauher.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gauher.f90
gaujac.o : $(NRF90DIR)/gaujac.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gaujac.f90
gaulag.o : $(NRF90DIR)/gaulag.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gaulag.f90
gauleg.o : $(NRF90DIR)/gauleg.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gauleg.f90
gaussj.o : $(NRF90DIR)/gaussj.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gaussj.f90
gcf.o : $(NRF90DIR)/gcf.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gcf.f90
golden.o : $(NRF90DIR)/golden.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/golden.f90
gser.o : $(NRF90DIR)/gser.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/gser.f90
hqr.o : $(NRF90DIR)/hqr.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/hqr.f90
hufdec.o : $(NRF90DIR)/hufdec.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/hufdec.f90
hufenc.o : $(NRF90DIR)/hufenc.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/hufenc.f90
hufmak.o : $(NRF90DIR)/hufmak.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/hufmak.f90
hunt.o : $(NRF90DIR)/hunt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/hunt.f90
hypdrv.o : $(NRF90DIR)/hypdrv.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/hypdrv.f90
hypgeo.o : $(NRF90DIR)/hypgeo.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/hypgeo.f90
hypser.o : $(NRF90DIR)/hypser.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/hypser.f90
icrc.o : $(NRF90DIR)/icrc.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/icrc.f90
igray.o : $(NRF90DIR)/igray.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/igray.f90
index_bypack.o : $(NRF90DIR)/index_bypack.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/index_bypack.f90
indexx.o : $(NRF90DIR)/indexx.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/indexx.f90
interp.o : $(NRF90DIR)/interp.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/interp.f90
irbit1.o : $(NRF90DIR)/irbit1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/irbit1.f90
irbit2.o : $(NRF90DIR)/irbit2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/irbit2.f90
jacobi.o : $(NRF90DIR)/jacobi.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/jacobi.f90
jacobn.o : $(NRF90DIR)/jacobn.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/jacobn.f90
julday.o : $(NRF90DIR)/julday.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/julday.f90
kendl1.o : $(NRF90DIR)/kendl1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/kendl1.f90
kendl2.o : $(NRF90DIR)/kendl2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/kendl2.f90
kermom.o : $(NRF90DIR)/kermom.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/kermom.f90
ks2d1s.o : $(NRF90DIR)/ks2d1s.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ks2d1s.f90
ks2d2s.o : $(NRF90DIR)/ks2d2s.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ks2d2s.f90
ksone.o : $(NRF90DIR)/ksone.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ksone.f90
kstwo.o : $(NRF90DIR)/kstwo.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/kstwo.f90
laguer.o : $(NRF90DIR)/laguer.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/laguer.f90
lfit.o : $(NRF90DIR)/lfit.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/lfit.f90
linbcg.o : $(NRF90DIR)/linbcg.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/linbcg.f90
linmin.o : $(NRF90DIR)/linmin.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/linmin.f90
lnsrch.o : $(NRF90DIR)/lnsrch.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/lnsrch.f90
locate.o : $(NRF90DIR)/locate.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/locate.f90
lop.o : $(NRF90DIR)/lop.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/lop.f90
lubksb.o : $(NRF90DIR)/lubksb.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/lubksb.f90
ludcmp.o : $(NRF90DIR)/ludcmp.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ludcmp.f90
machar.o : $(NRF90DIR)/machar.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/machar.f90
medfit.o : $(NRF90DIR)/medfit.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/medfit.f90
memcof.o : $(NRF90DIR)/memcof.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/memcof.f90
mgfas.o : $(NRF90DIR)/mgfas.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mgfas.f90
mglin.o : $(NRF90DIR)/mglin.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mglin.f90
midexp.o : $(NRF90DIR)/midexp.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/midexp.f90
midinf.o : $(NRF90DIR)/midinf.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/midinf.f90
midpnt.o : $(NRF90DIR)/midpnt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/midpnt.f90
midsql.o : $(NRF90DIR)/midsql.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/midsql.f90
midsqu.o : $(NRF90DIR)/midsqu.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/midsqu.f90
miser.o : $(NRF90DIR)/miser.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/miser.f90
mmid.o : $(NRF90DIR)/mmid.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mmid.f90
mnbrak.o : $(NRF90DIR)/mnbrak.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mnbrak.f90
mnewt.o : $(NRF90DIR)/mnewt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mnewt.f90
moment.o : $(NRF90DIR)/moment.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/moment.f90
mp2dfr.o : $(NRF90DIR)/mp2dfr.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mp2dfr.f90
mpdiv.o : $(NRF90DIR)/mpdiv.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mpdiv.f90
mpinv.o : $(NRF90DIR)/mpinv.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mpinv.f90
mpmul.o : $(NRF90DIR)/mpmul.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mpmul.f90
mpops.o : $(NRF90DIR)/mpops.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mpops.f90
mppi.o : $(NRF90DIR)/mppi.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mppi.f90
mprove.o : $(NRF90DIR)/mprove.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mprove.f90
mpsqrt.o : $(NRF90DIR)/mpsqrt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mpsqrt.f90
mrqmin.o : $(NRF90DIR)/mrqmin.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/mrqmin.f90
newt.o : $(NRF90DIR)/newt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/newt.f90
nr.o : $(NRF90DIR)/nr.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/nr.f90
nrtype.o : $(NRF90DIR)/nrtype.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/nrtype.f90
nrutil.o : $(NRF90DIR)/nrutil.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/nrutil.f90
odeint.o : $(NRF90DIR)/odeint.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/odeint.f90
orthog.o : $(NRF90DIR)/orthog.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/orthog.f90
pade.o : $(NRF90DIR)/pade.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/pade.f90
pccheb.o : $(NRF90DIR)/pccheb.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/pccheb.f90
pcshft.o : $(NRF90DIR)/pcshft.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/pcshft.f90
pearsn.o : $(NRF90DIR)/pearsn.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/pearsn.f90
period.o : $(NRF90DIR)/period.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/period.f90
plgndr.o : $(NRF90DIR)/plgndr.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/plgndr.f90
poidev.o : $(NRF90DIR)/poidev.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/poidev.f90
polcoe.o : $(NRF90DIR)/polcoe.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/polcoe.f90
polcof.o : $(NRF90DIR)/polcof.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/polcof.f90
poldiv.o : $(NRF90DIR)/poldiv.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/poldiv.f90
polin2.o : $(NRF90DIR)/polin2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/polin2.f90
polint.o : $(NRF90DIR)/polint.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/polint.f90
powell.o : $(NRF90DIR)/powell.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/powell.f90
predic.o : $(NRF90DIR)/predic.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/predic.f90
probks.o : $(NRF90DIR)/probks.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/probks.f90
psdes.o : $(NRF90DIR)/psdes.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/psdes.f90
pwt.o : $(NRF90DIR)/pwt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/pwt.f90
pwtset.o : $(NRF90DIR)/pwtset.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/pwtset.f90
pythag.o : $(NRF90DIR)/pythag.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/pythag.f90
pzextr.o : $(NRF90DIR)/pzextr.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/pzextr.f90
qrdcmp.o : $(NRF90DIR)/qrdcmp.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/qrdcmp.f90
qromb.o : $(NRF90DIR)/qromb.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/qromb.f90
qromo.o : $(NRF90DIR)/qromo.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/qromo.f90
qroot.o : $(NRF90DIR)/qroot.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/qroot.f90
qrsolv.o : $(NRF90DIR)/qrsolv.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/qrsolv.f90
qrupdt.o : $(NRF90DIR)/qrupdt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/qrupdt.f90
qsimp.o : $(NRF90DIR)/qsimp.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/qsimp.f90
qtrap.o : $(NRF90DIR)/qtrap.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/qtrap.f90
quad3d.o : $(NRF90DIR)/quad3d.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/quad3d.f90
quadct.o : $(NRF90DIR)/quadct.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/quadct.f90
quadmx.o : $(NRF90DIR)/quadmx.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/quadmx.f90
quadvl.o : $(NRF90DIR)/quadvl.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/quadvl.f90
ran.o : $(NRF90DIR)/ran.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ran.f90
ran0.o : $(NRF90DIR)/ran0.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ran0.f90
ran1.o : $(NRF90DIR)/ran1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ran1.f90
ran2.o : $(NRF90DIR)/ran2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ran2.f90
ran3.o : $(NRF90DIR)/ran3.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ran3.f90
ran_state.o : $(NRF90DIR)/ran_state.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ran_state.f90
rank.o : $(NRF90DIR)/rank.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rank.f90
ratint.o : $(NRF90DIR)/ratint.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ratint.f90
ratlsq.o : $(NRF90DIR)/ratlsq.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ratlsq.f90
ratval.o : $(NRF90DIR)/ratval.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ratval.f90
rc.o : $(NRF90DIR)/rc.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rc.f90
rd.o : $(NRF90DIR)/rd.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rd.f90
realft.o : $(NRF90DIR)/realft.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/realft.f90
recur1.o : $(NRF90DIR)/recur1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/recur1.f90
recur2.o : $(NRF90DIR)/recur2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/recur2.f90
relax.o : $(NRF90DIR)/relax.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/relax.f90
relax2.o : $(NRF90DIR)/relax2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/relax2.f90
resid.o : $(NRF90DIR)/resid.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/resid.f90
rf.o : $(NRF90DIR)/rf.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rf.f90
rj.o : $(NRF90DIR)/rj.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rj.f90
rk4.o : $(NRF90DIR)/rk4.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rk4.f90
rkck.o : $(NRF90DIR)/rkck.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rkck.f90
rkdumb.o : $(NRF90DIR)/rkdumb.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rkdumb.f90
rkqs.o : $(NRF90DIR)/rkqs.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rkqs.f90
rlft2.o : $(NRF90DIR)/rlft2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rlft2.f90
rlft3.o : $(NRF90DIR)/rlft3.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rlft3.f90
rotate.o : $(NRF90DIR)/rotate.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rotate.f90
rsolv.o : $(NRF90DIR)/rsolv.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rsolv.f90
rstrct.o : $(NRF90DIR)/rstrct.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rstrct.f90
rtbis.o : $(NRF90DIR)/rtbis.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rtbis.f90
rtflsp.o : $(NRF90DIR)/rtflsp.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rtflsp.f90
rtnewt.o : $(NRF90DIR)/rtnewt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rtnewt.f90
rtsafe.o : $(NRF90DIR)/rtsafe.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rtsafe.f90
rtsec.o : $(NRF90DIR)/rtsec.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rtsec.f90
rzextr.o : $(NRF90DIR)/rzextr.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/rzextr.f90
savgol.o : $(NRF90DIR)/savgol.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/savgol.f90
scrsho.o : $(NRF90DIR)/scrsho.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/scrsho.f90
select.o : $(NRF90DIR)/select.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/select.f90
select_bypack.o : $(NRF90DIR)/select_bypack.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/select_bypack.f90
select_heap.o : $(NRF90DIR)/select_heap.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/select_heap.f90
select_inplace.o : $(NRF90DIR)/select_inplace.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/select_inplace.f90
sfroid.o : $(NRF90DIR)/sfroid.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sfroid.f90
shoot.o : $(NRF90DIR)/shoot.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/shoot.f90
shootf.o : $(NRF90DIR)/shootf.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/shootf.f90
simplx.o : $(NRF90DIR)/simplx.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/simplx.f90
simpr.o : $(NRF90DIR)/simpr.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/simpr.f90
sinft.o : $(NRF90DIR)/sinft.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sinft.f90
slvsm2.o : $(NRF90DIR)/slvsm2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/slvsm2.f90
slvsml.o : $(NRF90DIR)/slvsml.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/slvsml.f90
sncndn.o : $(NRF90DIR)/sncndn.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sncndn.f90
snrm.o : $(NRF90DIR)/snrm.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/snrm.f90
sobseq.o : $(NRF90DIR)/sobseq.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sobseq.f90
solvde.o : $(NRF90DIR)/solvde.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/solvde.f90
sor.o : $(NRF90DIR)/sor.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sor.f90
sort.o : $(NRF90DIR)/sort.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sort.f90
sort2.o : $(NRF90DIR)/sort2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sort2.f90
sort3.o : $(NRF90DIR)/sort3.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sort3.f90
sort_bypack.o : $(NRF90DIR)/sort_bypack.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sort_bypack.f90
sort_byreshape.o : $(NRF90DIR)/sort_byreshape.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sort_byreshape.f90
sort_heap.o : $(NRF90DIR)/sort_heap.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sort_heap.f90
sort_pick.o : $(NRF90DIR)/sort_pick.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sort_pick.f90
sort_radix.o : $(NRF90DIR)/sort_radix.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sort_radix.f90
sort_shell.o : $(NRF90DIR)/sort_shell.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sort_shell.f90
spctrm.o : $(NRF90DIR)/spctrm.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/spctrm.f90
spear.o : $(NRF90DIR)/spear.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/spear.f90
sphbes.o : $(NRF90DIR)/sphbes.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sphbes.f90
sphfpt.o : $(NRF90DIR)/sphfpt.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sphfpt.f90
sphoot.o : $(NRF90DIR)/sphoot.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sphoot.f90
splie2.o : $(NRF90DIR)/splie2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/splie2.f90
splin2.o : $(NRF90DIR)/splin2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/splin2.f90
spline.o : $(NRF90DIR)/spline.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/spline.f90
splint.o : $(NRF90DIR)/splint.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/splint.f90
sprsax.o : $(NRF90DIR)/sprsax.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sprsax.f90
sprsdiag.o : $(NRF90DIR)/sprsdiag.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sprsdiag.f90
sprsin.o : $(NRF90DIR)/sprsin.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sprsin.f90
sprstp.o : $(NRF90DIR)/sprstp.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sprstp.f90
sprstx.o : $(NRF90DIR)/sprstx.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/sprstx.f90
stifbs.o : $(NRF90DIR)/stifbs.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/stifbs.f90
stiff.o : $(NRF90DIR)/stiff.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/stiff.f90
stoerm.o : $(NRF90DIR)/stoerm.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/stoerm.f90
svbksb.o : $(NRF90DIR)/svbksb.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/svbksb.f90
svdcmp.o : $(NRF90DIR)/svdcmp.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/svdcmp.f90
svdfit.o : $(NRF90DIR)/svdfit.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/svdfit.f90
svdvar.o : $(NRF90DIR)/svdvar.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/svdvar.f90
toeplz.o : $(NRF90DIR)/toeplz.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/toeplz.f90
tptest.o : $(NRF90DIR)/tptest.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/tptest.f90
tqli.o : $(NRF90DIR)/tqli.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/tqli.f90
trapzd.o : $(NRF90DIR)/trapzd.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/trapzd.f90
tred2.o : $(NRF90DIR)/tred2.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/tred2.f90
tridag.o : $(NRF90DIR)/tridag.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/tridag.f90
ttest.o : $(NRF90DIR)/ttest.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/ttest.f90
tutest.o : $(NRF90DIR)/tutest.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/tutest.f90
twofft.o : $(NRF90DIR)/twofft.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/twofft.f90
vander.o : $(NRF90DIR)/vander.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/vander.f90
vegas.o : $(NRF90DIR)/vegas.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/vegas.f90
voltra.o : $(NRF90DIR)/voltra.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/voltra.f90
wt1.o : $(NRF90DIR)/wt1.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/wt1.f90
wtn.o : $(NRF90DIR)/wtn.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/wtn.f90
wwghts.o : $(NRF90DIR)/wwghts.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/wwghts.f90
zbrac.o : $(NRF90DIR)/zbrac.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/zbrac.f90
zbrak.o : $(NRF90DIR)/zbrak.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/zbrak.f90
zbrent.o : $(NRF90DIR)/zbrent.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/zbrent.f90
zrhqr.o : $(NRF90DIR)/zrhqr.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/zrhqr.f90
zriddr.o : $(NRF90DIR)/zriddr.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/zriddr.f90
zroots.o : $(NRF90DIR)/zroots.f90
	$(F90) $(F90OPTS) -c $(NRF90DIR)/zroots.f90


xairy.o : $(NRXF90DIR)/xairy.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xairy.f90
xamebsa.o : $(NRXF90DIR)/xamebsa.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xamebsa.f90
xamoeba.o : $(NRXF90DIR)/xamoeba.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xamoeba.f90
xanneal.o : $(NRXF90DIR)/xanneal.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xanneal.f90
xarcode.o : $(NRXF90DIR)/xarcode.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xarcode.f90
xavevar.o : $(NRXF90DIR)/xavevar.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xavevar.f90
xbalanc.o : $(NRXF90DIR)/xbalanc.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xbalanc.f90
xbandec.o : $(NRXF90DIR)/xbandec.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xbandec.f90
xbanmul.o : $(NRXF90DIR)/xbanmul.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xbanmul.f90
xbcucof.o : $(NRXF90DIR)/xbcucof.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xbcucof.f90
xbcuint.o : $(NRXF90DIR)/xbcuint.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xbcuint.f90
xbeschb.o : $(NRXF90DIR)/xbeschb.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xbeschb.f90
xbessik.o : $(NRXF90DIR)/xbessik.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xbessik.f90
xbnldev.o : $(NRXF90DIR)/xbnldev.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xbnldev.f90
xbrent.o : $(NRXF90DIR)/xbrent.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xbrent.f90
xbroydn.o : $(NRXF90DIR)/xbroydn.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xbroydn.f90
xbsstep.o : $(NRXF90DIR)/xbsstep.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xbsstep.f90
xcaldat.o : $(NRXF90DIR)/xcaldat.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xcaldat.f90
xchder.o : $(NRXF90DIR)/xchder.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xchder.f90
xchebev.o : $(NRXF90DIR)/xchebev.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xchebev.f90
xchebft.o : $(NRXF90DIR)/xchebft.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xchebft.f90
xchebpc.o : $(NRXF90DIR)/xchebpc.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xchebpc.f90
xchint.o : $(NRXF90DIR)/xchint.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xchint.f90
xcholsl.o : $(NRXF90DIR)/xcholsl.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xcholsl.f90
xchsone.o : $(NRXF90DIR)/xchsone.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xchsone.f90
xchstwo.o : $(NRXF90DIR)/xchstwo.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xchstwo.f90
xcisi.o : $(NRXF90DIR)/xcisi.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xcisi.f90
xcntab1.o : $(NRXF90DIR)/xcntab1.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xcntab1.f90
xcntab2.o : $(NRXF90DIR)/xcntab2.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xcntab2.f90
xconvlv.o : $(NRXF90DIR)/xconvlv.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xconvlv.f90
xcorrel.o : $(NRXF90DIR)/xcorrel.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xcorrel.f90
xcosft1.o : $(NRXF90DIR)/xcosft1.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xcosft1.f90
xcosft2.o : $(NRXF90DIR)/xcosft2.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xcosft2.f90
xcovsrt.o : $(NRXF90DIR)/xcovsrt.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xcovsrt.f90
xcyclic.o : $(NRXF90DIR)/xcyclic.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xcyclic.f90
xdbrent.o : $(NRXF90DIR)/xdbrent.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xdbrent.f90
xddpoly.o : $(NRXF90DIR)/xddpoly.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xddpoly.f90
xdecchk.o : $(NRXF90DIR)/xdecchk.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xdecchk.f90
xdf1dim.o : $(NRXF90DIR)/xdf1dim.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xdf1dim.f90
xdfpmin.o : $(NRXF90DIR)/xdfpmin.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xdfpmin.f90
xdfridr.o : $(NRXF90DIR)/xdfridr.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xdfridr.f90
xdftint.o : $(NRXF90DIR)/xdftint.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xdftint.f90
xeclass.o : $(NRXF90DIR)/xeclass.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xeclass.f90
xeclazz.o : $(NRXF90DIR)/xeclazz.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xeclazz.f90
xeigsrt.o : $(NRXF90DIR)/xeigsrt.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xeigsrt.f90
xelmhes.o : $(NRXF90DIR)/xelmhes.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xelmhes.f90
xeulsum.o : $(NRXF90DIR)/xeulsum.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xeulsum.f90
xevlmem.o : $(NRXF90DIR)/xevlmem.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xevlmem.f90
xexpdev.o : $(NRXF90DIR)/xexpdev.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xexpdev.f90
xf1dim.o : $(NRXF90DIR)/xf1dim.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xf1dim.f90
xfasper.o : $(NRXF90DIR)/xfasper.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfasper.f90
xfgauss.o : $(NRXF90DIR)/xfgauss.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfgauss.f90
xfit.o : $(NRXF90DIR)/xfit.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfit.f90
xfitexy.o : $(NRXF90DIR)/xfitexy.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfitexy.f90
xfixrts.o : $(NRXF90DIR)/xfixrts.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfixrts.f90
xfleg.o : $(NRXF90DIR)/xfleg.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfleg.f90
xflmoon.o : $(NRXF90DIR)/xflmoon.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xflmoon.f90
xfour1.o : $(NRXF90DIR)/xfour1.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfour1.f90
xfpoly.o : $(NRXF90DIR)/xfpoly.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfpoly.f90
xfred2.o : $(NRXF90DIR)/xfred2.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfred2.f90
xfredin.o : $(NRXF90DIR)/xfredin.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfredin.f90
xfrenel.o : $(NRXF90DIR)/xfrenel.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfrenel.f90
xfrprmn.o : $(NRXF90DIR)/xfrprmn.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xfrprmn.f90
xftest.o : $(NRXF90DIR)/xftest.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xftest.f90
xgamdev.o : $(NRXF90DIR)/xgamdev.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xgamdev.f90
xgasdev.o : $(NRXF90DIR)/xgasdev.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xgasdev.f90
xgaucof.o : $(NRXF90DIR)/xgaucof.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xgaucof.f90
xgauher.o : $(NRXF90DIR)/xgauher.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xgauher.f90
xgaujac.o : $(NRXF90DIR)/xgaujac.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xgaujac.f90
xgaulag.o : $(NRXF90DIR)/xgaulag.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xgaulag.f90
xgauleg.o : $(NRXF90DIR)/xgauleg.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xgauleg.f90
xgaussj.o : $(NRXF90DIR)/xgaussj.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xgaussj.f90
xgolden.o : $(NRXF90DIR)/xgolden.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xgolden.f90
xhqr.o : $(NRXF90DIR)/xhqr.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xhqr.f90
xhuffman.o : $(NRXF90DIR)/xhuffman.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xhuffman.f90
xhunt.o : $(NRXF90DIR)/xhunt.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xhunt.f90
xhypgeo.o : $(NRXF90DIR)/xhypgeo.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xhypgeo.f90
xicrc.o : $(NRXF90DIR)/xicrc.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xicrc.f90
xigray.o : $(NRXF90DIR)/xigray.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xigray.f90
xirbit1.o : $(NRXF90DIR)/xirbit1.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xirbit1.f90
xirbit2.o : $(NRXF90DIR)/xirbit2.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xirbit2.f90
xjacobi.o : $(NRXF90DIR)/xjacobi.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xjacobi.f90
xjulday.o : $(NRXF90DIR)/xjulday.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xjulday.f90
xkendl1.o : $(NRXF90DIR)/xkendl1.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xkendl1.f90
xkendl2.o : $(NRXF90DIR)/xkendl2.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xkendl2.f90
xks2d1s.o : $(NRXF90DIR)/xks2d1s.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xks2d1s.f90
xks2d2s.o : $(NRXF90DIR)/xks2d2s.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xks2d2s.f90
xksone.o : $(NRXF90DIR)/xksone.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xksone.f90
xkstwo.o : $(NRXF90DIR)/xkstwo.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xkstwo.f90
xlaguer.o : $(NRXF90DIR)/xlaguer.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xlaguer.f90
xlfit.o : $(NRXF90DIR)/xlfit.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xlfit.f90
xlinbcg.o : $(NRXF90DIR)/xlinbcg.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xlinbcg.f90
xlinmin.o : $(NRXF90DIR)/xlinmin.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xlinmin.f90
xlocate.o : $(NRXF90DIR)/xlocate.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xlocate.f90
xlubksb.o : $(NRXF90DIR)/xlubksb.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xlubksb.f90
xludcmp.o : $(NRXF90DIR)/xludcmp.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xludcmp.f90
xmachar.o : $(NRXF90DIR)/xmachar.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmachar.f90
xmedfit.o : $(NRXF90DIR)/xmedfit.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmedfit.f90
xmemcof.o : $(NRXF90DIR)/xmemcof.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmemcof.f90
xmgfas.o : $(NRXF90DIR)/xmgfas.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmgfas.f90
xmglin.o : $(NRXF90DIR)/xmglin.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmglin.f90
xmidpnt.o : $(NRXF90DIR)/xmidpnt.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmidpnt.f90
xmiser.o : $(NRXF90DIR)/xmiser.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmiser.f90
xmmid.o : $(NRXF90DIR)/xmmid.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmmid.f90
xmnbrak.o : $(NRXF90DIR)/xmnbrak.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmnbrak.f90
xmnewt.o : $(NRXF90DIR)/xmnewt.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmnewt.f90
xmoment.o : $(NRXF90DIR)/xmoment.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmoment.f90
xmppi.o : $(NRXF90DIR)/xmppi.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmppi.f90
xmprove.o : $(NRXF90DIR)/xmprove.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmprove.f90
xmrqmin.o : $(NRXF90DIR)/xmrqmin.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xmrqmin.f90
xnewt.o : $(NRXF90DIR)/xnewt.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xnewt.f90
xodeint.o : $(NRXF90DIR)/xodeint.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xodeint.f90
xorthog.o : $(NRXF90DIR)/xorthog.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xorthog.f90
xpade.o : $(NRXF90DIR)/xpade.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpade.f90
xpccheb.o : $(NRXF90DIR)/xpccheb.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpccheb.f90
xpcshft.o : $(NRXF90DIR)/xpcshft.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpcshft.f90
xpearsn.o : $(NRXF90DIR)/xpearsn.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpearsn.f90
xperiod.o : $(NRXF90DIR)/xperiod.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xperiod.f90
xpoidev.o : $(NRXF90DIR)/xpoidev.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpoidev.f90
xpolcoe.o : $(NRXF90DIR)/xpolcoe.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpolcoe.f90
xpolcof.o : $(NRXF90DIR)/xpolcof.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpolcof.f90
xpoldiv.o : $(NRXF90DIR)/xpoldiv.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpoldiv.f90
xpolin2.o : $(NRXF90DIR)/xpolin2.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpolin2.f90
xpolint.o : $(NRXF90DIR)/xpolint.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpolint.f90
xpowell.o : $(NRXF90DIR)/xpowell.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpowell.f90
xpredic.o : $(NRXF90DIR)/xpredic.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpredic.f90
xprobks.o : $(NRXF90DIR)/xprobks.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xprobks.f90
xpsdes.o : $(NRXF90DIR)/xpsdes.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpsdes.f90
xpzextr.o : $(NRXF90DIR)/xpzextr.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xpzextr.f90
xqrdcmp.o : $(NRXF90DIR)/xqrdcmp.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xqrdcmp.f90
xqromo.o : $(NRXF90DIR)/xqromo.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xqromo.f90
xqroot.o : $(NRXF90DIR)/xqroot.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xqroot.f90
xqrsolv.o : $(NRXF90DIR)/xqrsolv.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xqrsolv.f90
xqrupdt.o : $(NRXF90DIR)/xqrupdt.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xqrupdt.f90
xquad3d.o : $(NRXF90DIR)/xquad3d.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xquad3d.f90
xran.o : $(NRXF90DIR)/xran.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xran.f90
xrank.o : $(NRXF90DIR)/xrank.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xrank.f90
xratint.o : $(NRXF90DIR)/xratint.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xratint.f90
xrealft.o : $(NRXF90DIR)/xrealft.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xrealft.f90
xrk4.o : $(NRXF90DIR)/xrk4.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xrk4.f90
xrkdumb.o : $(NRXF90DIR)/xrkdumb.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xrkdumb.f90
xrkqs.o : $(NRXF90DIR)/xrkqs.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xrkqs.f90
xrlft3.o : $(NRXF90DIR)/xrlft3.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xrlft3.f90
xrzextr.o : $(NRXF90DIR)/xrzextr.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xrzextr.f90
xsavgol.o : $(NRXF90DIR)/xsavgol.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsavgol.f90
xscrsho.o : $(NRXF90DIR)/xscrsho.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xscrsho.f90
xsimpr.o : $(NRXF90DIR)/xsimpr.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsimpr.f90
xsinft.o : $(NRXF90DIR)/xsinft.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsinft.f90
xsncndn.o : $(NRXF90DIR)/xsncndn.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsncndn.f90
xsobseq.o : $(NRXF90DIR)/xsobseq.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsobseq.f90
xsor.o : $(NRXF90DIR)/xsor.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsor.f90
xsort2.o : $(NRXF90DIR)/xsort2.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsort2.f90
xsort3.o : $(NRXF90DIR)/xsort3.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsort3.f90
xspctrm.o : $(NRXF90DIR)/xspctrm.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xspctrm.f90
xspear.o : $(NRXF90DIR)/xspear.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xspear.f90
xsphfpt.o : $(NRXF90DIR)/xsphfpt.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsphfpt.f90
xsplie2.o : $(NRXF90DIR)/xsplie2.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsplie2.f90
xsplin2.o : $(NRXF90DIR)/xsplin2.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsplin2.f90
xspline.o : $(NRXF90DIR)/xspline.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xspline.f90
xsplint.o : $(NRXF90DIR)/xsplint.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsplint.f90
xstifbs.o : $(NRXF90DIR)/xstifbs.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xstifbs.f90
xstiff.o : $(NRXF90DIR)/xstiff.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xstiff.f90
xstoerm.o : $(NRXF90DIR)/xstoerm.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xstoerm.f90
xsvbksb.o : $(NRXF90DIR)/xsvbksb.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsvbksb.f90
xsvdcmp.o : $(NRXF90DIR)/xsvdcmp.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsvdcmp.f90
xsvdfit.o : $(NRXF90DIR)/xsvdfit.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsvdfit.f90
xsvdvar.o : $(NRXF90DIR)/xsvdvar.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xsvdvar.f90
xtoeplz.o : $(NRXF90DIR)/xtoeplz.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xtoeplz.f90
xtptest.o : $(NRXF90DIR)/xtptest.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xtptest.f90
xtqli.o : $(NRXF90DIR)/xtqli.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xtqli.f90
xtrapzd.o : $(NRXF90DIR)/xtrapzd.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xtrapzd.f90
xtred2.o : $(NRXF90DIR)/xtred2.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xtred2.f90
xtridag.o : $(NRXF90DIR)/xtridag.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xtridag.f90
xttest.o : $(NRXF90DIR)/xttest.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xttest.f90
xtutest.o : $(NRXF90DIR)/xtutest.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xtutest.f90
xtwofft.o : $(NRXF90DIR)/xtwofft.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xtwofft.f90
xvander.o : $(NRXF90DIR)/xvander.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xvander.f90
xvegas.o : $(NRXF90DIR)/xvegas.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xvegas.f90
xvoltra.o : $(NRXF90DIR)/xvoltra.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xvoltra.f90
xwt1.o : $(NRXF90DIR)/xwt1.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xwt1.f90
xwtn.o : $(NRXF90DIR)/xwtn.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xwtn.f90
xzbrac.o : $(NRXF90DIR)/xzbrac.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xzbrac.f90
xzbrak.o : $(NRXF90DIR)/xzbrak.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xzbrak.f90
xzrhqr.o : $(NRXF90DIR)/xzrhqr.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xzrhqr.f90
xzroots.o : $(NRXF90DIR)/xzroots.f90
	$(F90) $(F90OPTS) -c $(NRXF90DIR)/xzroots.f90
