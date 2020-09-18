FILENAME='prepare'
DIROUT='/home/lsilva/IKMB/projects/skin.associations/results/analysis/1.combine.microbiome/2.predictors'

###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT" -p
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"

# Transfer files

rsync -avh ./* $DIROUT

cd $DIROUT

mkdir log

rsync -avh ./ sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/temp/predict
