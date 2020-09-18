DIROUT='/home/lsilva/IKMB/projects/skin.associations/results/popgen/3.physio.set/4.test.asv'

FILENAME='test.diff'
###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT"
for i in {1..4}
do
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}', index = '${i}'))"
done
