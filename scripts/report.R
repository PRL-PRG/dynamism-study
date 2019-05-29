library(dynalyzer)
library(dynamismtracer)

main <- function() {
    settings <- parse_report_settings(args = commandArgs(trailingOnly = TRUE))

    print(settings)

    report(get_report_template(), settings)

    invisible(NULL)
}


main()
