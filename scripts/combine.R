library(dynalyzer)
library(dynamismtracer)

main <- function() {
    settings <- parse_combine_settings(args = commandArgs(trailingOnly = TRUE))

    print(settings)

    combine(get_analysis_group(), settings)

    invisible(NULL)
}


main()
