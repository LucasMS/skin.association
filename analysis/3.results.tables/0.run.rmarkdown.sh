DIROUT='/home/lsilva/IKMB/projects/skin.associations/results/analysis/3.results.tables'

for i in beta asv make.plot
do
 FILENAME=${i}
 INPUT=${FILENAME}'.Rmd'
 OUTPUT=${FILENAME}'.html'
 FIGPATH=${DIROUT}'/'${FILENAME}'/'
 mkdir "$DIROUT"
 R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"
done
