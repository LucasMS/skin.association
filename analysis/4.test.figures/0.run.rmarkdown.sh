DIROUT='/home/lsilva/IKMB/projects/skin.associations/results/analysis/4.test.figures'
mkdir "$DIROUT"

for FILENAME in kora.pop.host.traits kora.host.traits kora.env pop.host.traits pop.physio

do
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"
done
