FILENAME='1.filter.microbiome'
DIROUT='/home/lsilva/IKMB/projects/skin.associations/results/popgen/1.full.set/1.filter.samples.and.metadata'
mkdir $DIROUT -p
###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT"
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}'))"

FILENAME='2.filter.metadata.all'
DIROUT='/home/lsilva/IKMB/projects/skin.associations/results/popgen/1.full.set/1.filter.samples.and.metadata'
###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT"
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}'))"
