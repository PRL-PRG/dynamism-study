library(dynalyzer)
library(dynamismtracer)

main <- function() {

    settings <- parse_summarize_settings(args = commandArgs(trailingOnly = TRUE))

    print(settings)

    dynalyzer::summarize(get_analysis_group(), settings)

    invisible(NULL)
}


main()

