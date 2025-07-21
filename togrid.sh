#!/bin/csh -f
# togrid.sh

set xyz=$1 Xmin=$2 Xmax=$3 Zmin=$4 Zmax=$5 dx=$6 dz=$7 grd=$8

set R = -R$Xmin/$Xmax/$Zmin/$Zmax
set I = -I$dx/$dz
gmt blockmean $xyz $R $I -V  > tmp.bmean
gmt surface tmp.bmean -G$grd $I $R -V 
