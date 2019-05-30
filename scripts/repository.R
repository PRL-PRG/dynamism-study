library(dynalyzer)


main <- function() {

    settings <- parse_repository_settings(args = commandArgs(trailingOnly = TRUE))

    print(settings)

    setup_repository(settings)

    invisible(NULL)
}


main()
