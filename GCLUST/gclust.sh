#!/bin/bash

# MVL 07/07/2020
# This bash script will do the entire GCLUST pipeline in one go but this is specific to grabbing where specific files are located for the UK Biobank dataset. If we want to run it on another dataset, it needs to be modified to look for the relevant files for another dataset.
#

codedir=/home/ml437/code
cd $codedir

# load relevant modules for doing stuff with Freesurfer and MATLAB
module load freesurfer/6.0.0
module load matlab/r2019b

# directory where fsaverage is located
fsavgdir=$FREESURFER_HOME/subjects/fsaverage

# set the rootdir where all the UK Biobank Imaging data will be kept
rootdir=/rds/project/rb643/rds-rb643-ukbiobank2/Data_Imaging

# get a list of subjects to loop over
cd $rootdir
sublist=`ls -d UKB100*`
cd $codedir

# set the output directory where data will be stored after all this is finished running
rootoutdir=/rds/user/ml437/hpc-work/ukbiobank/GCLUST
export SUBJECTS_DIR=$rootoutdir
mkdir $rootoutdir
outdir=$rootoutdir
ln -s $fsavgdir $outdir
matlabdir=$outdir/matlab
cp -Rf $codedir/GCLUST/GCLUST/matlab $matlabdir
roidir=$codedir/GCLUST/GCLUST/clusters
datadir=$outdir/surfdata
mkdir $datadir

# set some variables
nsmooth=705
area="white"
meas="thickness"
volume="volume"
target="fsaverage"

fname_subjlist=$datadir/subjlist.txt
# make subjlist.txt and symbolic links
for sub in $sublist
do

    # print progress to screen
    echo Working on $sub
    
    # make subjlist.txt 
    echo $sub >> $datadir/subjlist.txt

    # make directories 
    subindir=$outdir/$sub
    mkdir $subindir

    # make a symbolic link to raw data
    rawdatadir=$rootdir/$sub/surfaces/$sub
    ln -s $rawdatadir/* $subindir

done

# left hemisphere ---------------------------------------------------------
hemi="lh"

# resample thickness to common space and concatenate 
out=${datadir}/${hemi}.${meas}
mris_preproc --out ${out}.mgh --target ${target} --f $fname_subjlist --hemi $hemi --meas ${meas}

# smooth thickness
mri_surf2surf --s $target --sval ${out}.mgh --cortex --nsmooth-out $nsmooth --tval ${out}.n${nsmooth}.mgh --hemi $hemi

# resample surface area to common space and concatenate 
out=${datadir}/${hemi}.${area}
mris_preproc --out ${out}.mgh --target ${target} --f $fname_subjlist --hemi $hemi --area $area

# smooth surface
mri_surf2surf --s $target --sval ${out}.mgh --cortex --nsmooth-out $nsmooth --tval ${out}.n${nsmooth}.mgh --hemi $hemi


# right hemisphere ---------------------------------------------------------
hemi="rh"

# resample thickness to common space and concatenate 
out=${datadir}/${hemi}.${meas}
mris_preproc --out ${out}.mgh --target ${target} --f $fname_subjlist --hemi $hemi --meas ${meas}

# smooth thickness
mri_surf2surf --s $target --sval ${out}.mgh --cortex --nsmooth-out $nsmooth --tval ${out}.n${nsmooth}.mgh --hemi $hemi

# resample surface area to common space and concatenate 
out=${datadir}/${hemi}.${area}
mris_preproc --out ${out}.mgh --target ${target} --f $fname_subjlist --hemi $hemi --area $area

# smooth surface
mri_surf2surf --s $target --sval ${out}.mgh --cortex --nsmooth-out $nsmooth --tval ${out}.n${nsmooth}.mgh --hemi $hemi

cd $codedir/GCLUST/GCLUST

# extract weighted averages for area and thickness for each cluster
cmd="gclust('"$datadir"','"$roidir"','"$matlabdir"','"$outdir"')"
matlab -nosplash -nojvm -r "try, $cmd; exit; catch e, fprintf('ERROR in matlab: %s\n',e.message); exit; end;"

cd $codedir
