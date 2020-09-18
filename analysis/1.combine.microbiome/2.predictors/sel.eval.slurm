#!/usr/bin/env bash
#SBATCH -c 1
#SBATCH --mem=2gb
#SBATCH --output=/work_ifs/sukmb447/temp/predict/log/%A_%a.out

cd $SLURM_SUBMIT_DIR
module load miniconda2
source activate /work_ifs/sukmb447/apps/conda.envs/r

# Get global parameters
outputfolder=${SLURM_SUBMIT_DIR}"/variable.selection"

mkdir $output

# run R
Rscript select.and.evaluate.R $SLURM_ARRAY_TASK_ID $outputfolder

# sbatch --array=1-4 run.analyse.slurm
