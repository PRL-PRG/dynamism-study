library(dynamismtracer)
library(dynalyzer)
library(fs)
library(stringr)
library(tibble)

indent <- function(lines, spaces = 4) {
    indentation <- paste0(rep(" ", spaces), collapse = "")
    ifelse(lines == "",
           "",
           paste0(indentation, lines))
}


wrap_script <- function(settings, script_dirname, script_filename) {

    script_dirpath <- path(settings$corpus_dirpath,
                           settings$package,
                           script_dirname)

    script_filepath <- path(script_dirpath, script_filename)

    wrapped_script_filepath <- path(script_dirpath,
                                    str_c("__wrapped__",
                                          script_filename))

    script_code <- str_c(indent(readLines(script_filepath), 4),
                         collapse = "\n")


    raw_output_dirpath <- path(settings$raw_analysis_dirpath,
                               settings$package,
                               script_dirname,
                               path_ext_remove(script_filename))


    dir_create(raw_output_dirpath)

    wrapped_code <- str_glue(
        "setwd('{script_dirpath}')",
        "library(dynamismtracer)",
        "gc()",
        "dyntrace_dynamism({{",
        "{script_code}",
        "}}",
        ", '{raw_output_dirpath}'",
        ", verbose = {settings$verbose}",
        ", truncate = {settings$truncate}",
        ", binary = {settings$binary}",
        ", compression_level = {settings$compression_level})",
        .sep = "\n")

    writeLines(wrapped_code, con = wrapped_script_filepath)

    tibble(filepath = wrapped_script_filepath,
           raw_analysis_dirpath = raw_output_dirpath)
}


main <- function() {

    settings <- parse_trace_settings()

    print(settings)

    ## copy scripts
    vignette_dirname <- copy_vignettes(settings)
    example_dirname <- copy_examples(settings)
    test_dirname <- copy_tests(settings)

    ## wrap scripts
    wrapped_vignettes <- wrap_scripts(settings, wrap_script, vignette_dirname)
    wrapped_examples <- wrap_scripts(settings, wrap_script, example_dirname)
    wrapped_tests <- wrap_scripts(settings, wrap_script, test_dirname)

    ## run scripts
    run_scripts(settings, wrapped_vignettes$filepath)
    run_scripts(settings, wrapped_examples$filepath)
    run_scripts(settings, wrapped_tests$filepath)

}

main()
