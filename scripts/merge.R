library(dynalyzer)
library(dynamismtracer)

main <- function() {
    settings <- parse_merge_settings()

    print(settings)

    merge(get_analysis_group(), settings)

    invisible(NULL)
}


main()
