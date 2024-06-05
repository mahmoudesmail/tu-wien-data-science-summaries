if ! [[ "$OSTYPE" == "darwin"* ]]; then echo "This script is only for macOS"; exit 1; fi

green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}installing dependencies...${reset}"
rscript -e "install.packages('rmarkdown', repos='https://cloud.r-project.org')"

for RMD_PATH in $(find . -name '*.Rmd'); do
    echo "${green}rendering ${RMD_PATH}...${reset}"
    rscript -e "rmarkdown::render('${RMD_PATH}')"
done
