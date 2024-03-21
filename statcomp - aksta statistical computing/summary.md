## basics

_about R lang_

- mostly used for statistical analysis and data visualization.
- cran (comprehensive r archive network) as package repository.
- docs: https://www.rdocumentation.org/
- syntax: https://learnxinyminutes.com/docs/r/
- books:
     - https://r4ds.had.co.nz/
     - https://rstudio-education.github.io/hopr/
     - https://adv-r.hadley.nz/
- visualization:
     - https://r-graph-gallery.com/
     - https://shiny.posit.co/r/gallery/

_how to use_

```bash
# install
brew install --cask r

# run code
rscript file.R
rscript -e "print('hello world')"

# interactive mode (REPL)
r

# man pages (in interactive mode)
> help("query")
> ?"query"
> help.search("query")
> ??"query"

# search for docs and examples
> apropos("query")
> example("query")
> demo("query")
```

## reproducability

_definition_

- scientific method: "systematic observation, measurement, and experiment, and the formulation, testing, and modification of hypotheses"
- reproducability: two independent researchers should be able to replicate an experiment and yield results with a high agreement.
- reproducability crisis: many scientific studies are not reproducible. especially in psychology and medicine.

_solution_

- publishing: data, code, environment details, methods, results.
     - use `sessionInfo()` to share environment data.
- publishing: raw measured data, processing code, analytic data, analytic code, computational results, presentation code, standard means of distribution.
- literate programming: combine code and documentation.

_r-markdown_

- official rmarkdown: https://rmarkdown.rstudio.com/
- tutorial: https://bookdown.org/yihui/rmarkdown/
     - header config: https://bookdown.org/yihui/rmarkdown/html-document.html
     - code block config: https://bookdown.org/yihui/rmarkdown/r-code.html

```bash
rscript -e "install.packages('rmarkdown')"
rscript -e "rmarkdown::render('file.rmd')"
```

## performance

_readable code_

- visual space: modular, consistent, formatted and linted code
- non-repeating
- inline documentation: interface/api with documentation
- comments
- meaningful naming

_efficient code_

- vectorized functions that respect row-/column-based memory order
- low memory consumption
- using c/c++ interopt
- caching, memoization
- parallelization

_benchmarking and profiling in R_

- memory profiling: use `tracemem()`/`untracemem()`
- benchmarking: use `bench` library
- profiling (graphical visualization of consumption): use `profviz` library

_debugging_

- top down debugging: you jump deeper and deeper and try to solve the problem in a divide-and-conquer manner
- small start strategy: sort of like ttd (test driven development)
- antibugging: using assert statements called `stopifnot()`
- debugging functions in R: `browser`, `debug`/`undebug`, `debugger`, `dump.frames`, `recover`, `trace`/`untrace`

## data wrangling

_tidy data_

- a dataset consists of:
     - quantitative values = numbers
     - qualitative values = strings
- values are either:
     - variables = the subject we are measuring
     - observations = the measured attributes of the specific subject
- tidyverse definition of tidy data:
     - variables are columns
     - observations are rows
     - observation types are tables
     - it’s permitted to have empty entries (null) if the values weren’t measured
     - i.e. table person, each person has a different row, each column has a different attribute

_reasoning_

- r is a vector based language
- matrices are stored row-first, so each variable is a seperate vector
- tidy data works best in the "tidyverse"
