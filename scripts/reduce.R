library(dynalyzer)
library(dynamismtracer)

main <- function() {

    settings <- parse_reduce_settings(args = commandArgs(trailingOnly = TRUE))

    print(settings)

    reduce(get_analysis_group(), settings)
}


main()
