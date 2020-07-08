#!/bin/bash

# run gclust_sub.sh over subjects

# load relevant modules for doing stuff with Freesurfer and MATLAB
module load freesurfer/6.0.0
module load matlab/r2019b

# directory where fsaverage is located
fsavgdir=$FREESURFER_HOME/subjects/fsaverage

# directories - may need to change based on where your files are...
codedir=/home/ml437/code
cd $codedir

# set the rootdir where all the UK Biobank Imaging data will be kept
rootdir=/rds/project/rb643/rds-rb643-ukbiobank2/Data_Imaging

# set the output directory where data will be stored after all this is finished running
rootoutdir=/rds/user/ml437/hpc-work/ukbiobank/GCLUST

# make SUBJECTS_DIR
export SUBJECTS_DIR=$rootoutdir
mkdir $rootoutdir
outdir=$rootoutdir

# symbolic link fsaverage
ln -s $fsavgdir $outdir

# copy matlab directory from GCLUST GitHub repo into $outdir
matlabdir=$outdir/matlab
cp -Rf $codedir/GCLUST/GCLUST/matlab $matlabdir

# make some directories to store final *.csv files
final_out_sa_dir=$rootoutdir/surface_area
mkdir $final_out_sa_dir
final_out_ct_dir=$rootoutdir/cortical_thickness
mkdir $final_out_ct_dir

# get a list of subjects to loop over
cd $rootdir
sublist=`ls -d UKB*`

# run the loop
for sub in $sublist
do
	# run gclust_sub over sbatch
	sbatch --account=BETHLEHEM-SL2-CPU \
		--partition=skylake-himem \
		--output=${outdir}/logs/${sub}_fslog.log \
		--nodes=1 --ntasks=1 --cpus-per-task=1 --time=20:00:00 --mem=12000 \
		$codedir/gclust_sub.sh ${sub}
done # for sub in $sublist
