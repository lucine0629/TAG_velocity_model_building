#!/bin/csh -f
# do_inv.sh

if ($#argv != 2) then
    echo "needs two arg";
    exit;
endif

set id = $1
set weight = $2
set X=8.78 Z=6.5
# set data = p13_obstt_all_fn.dat
set data = p13_obstt_allnodc_fn.dat
set init_mesh = v2d_50msm.dat
set vcorr = vcorr.dat
set dcorr = dcorr.dat
set N = -N4/4/4/8/1e-2/1e-3

set Lht=0.45 Lhb=0.45 Lvt=0.24 Lvb=0.24 LhR=3
cat > $vcorr <<EOF
2 2 
0.0 8.78
3.7 3.0
0.0 6.5
$Lht $Lhb
$Lht $Lhb
$Lvt $Lvb
$Lvt $Lvb
EOF

cat > $dcorr <<EOF
0.0 $LhR
6  $LhR
EOF


# rm -r out.w$2.$1

set dir = out.w$2.$1
if (! -e $dir) then
    mkdir $dir
endif

tt_inverse -M$init_mesh -G$data $N \
           -L$dir/log.all.$id -O$dir/out.$id -V1 -W$weight -Q1e-3 \
           -I1 -SV28 -SD8 -K$dir/dws.$id -CV$vcorr -CD$dcorr 