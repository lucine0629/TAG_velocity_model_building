#!/bin/bash
## this script adds gaussian noise to the traveltime picks

noise=13_Gaussian_noise.txt
tt=tt_"$1".dat

oritt=p13_obstt_all_fn.dat
tmpfile=noise.txt
outfile=chk_obs_tt_"$1".dat

rm $tmpfile $outfile




paste $tt $oritt $noise > $tmpfile

awk '{
if ($1=="r")
	print $1,$2,$3,$4,$5+($13/1000),$12;
else if ($1=="s")
	print $1,$2,$3,$4;
else
	print $1
}' $tmpfile > $outfile
