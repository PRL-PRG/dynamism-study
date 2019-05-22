library(dynamismtracer)
library(dynalyzer)

main <- function() {
    settings <- parse_scan_settings()

    print(settings)

    scan(get_analysis_group(), settings)

    invisible(NULL)
}


main()
