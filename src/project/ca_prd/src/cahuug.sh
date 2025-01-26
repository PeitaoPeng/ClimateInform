set -euax

ffile=capp

#tmpdir=/ptmp/wx51hd/test/6190/2000
#tmpdir=/ptmp/wx51hd/test/apr
tmpdir=/ptmp/wx51hd/test
if [ ! -d $tmpdir ] ; then
  mkdir -p $tmpdir
fi
cd $tmpdir

cp /nfsuser/g03/wx51hd/wind/1953/$ffile.f .
#xlf $ffile.f \
#  /nwprod/w3lib90/w3lib_4_604 \
#   -o $ffile.x 
xlf -lessl -o $ffile.x $ffile.f

$tmpdir/$ffile.x > $ffile.out  &
