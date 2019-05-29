################################################################################
## R-Dyntrace
################################################################################
R_DYNTRACE_DIRPATH := ../R-dyntrace
R_DYNTRACE := $(R_DYNTRACE_DIRPATH)/bin/R
R_DYNTRACE_FLAGS := --slave --no-restore --no-save

################################################################################
## tee
################################################################################
TEE := tee
TEE_FLAGS := --ignore-interrupts

################################################################################
## xvfb
################################################################################
XVFB_RUN := xvfb-run

################################################################################
## time
################################################################################
TIME := time --portability

################################################################################
## unbuffer
################################################################################
UNBUFFER := unbuffer

################################################################################
## tracer output directory paths
################################################################################
TRACE_DIRPATH := $(shell date +'%Y-%m-%d-%H-%M-%S')
LATEST_TRACE_DIRPATH := $(shell readlink -f latest)
TRACE_ANALYSIS_DIRPATH := $(TRACE_DIRPATH)/analysis
TRACE_ANALYSIS_RAW_DIRPATH := $(TRACE_ANALYSIS_DIRPATH)/raw
TRACE_ANALYSIS_PRESCANNED_DIRPATH := $(TRACE_ANALYSIS_DIRPATH)/prescanned
TRACE_ANALYSIS_REDUCED_DIRPATH := $(TRACE_ANALYSIS_DIRPATH)/reduced
TRACE_ANALYSIS_SCANNED_DIRPATH := $(TRACE_ANALYSIS_DIRPATH)/scanned
TRACE_ANALYSIS_COMBINED_DIRPATH := $(TRACE_ANALYSIS_DIRPATH)/combined
TRACE_ANALYSIS_MERGED_DIRPATH := $(TRACE_ANALYSIS_DIRPATH)/merged
TRACE_ANALYSIS_SUMMARIZED_DIRPATH := $(TRACE_ANALYSIS_DIRPATH)/summarized
TRACE_ANALYSIS_VISUALIZED_DIRPATH := $(TRACE_ANALYSIS_DIRPATH)/visualized
TRACE_ANALYSIS_LATEX_DIRPATH := $(TRACE_ANALYSIS_DIRPATH)/latex
TRACE_ANALYSIS_LATEX_FILEPATH := $(TRACE_ANALYSIS_LATEX_DIRPATH)/macros.tex
TRACE_ANALYSIS_REPORT_DIRPATH := $(TRACE_ANALYSIS_DIRPATH)/report
TRACE_ANALYSIS_REPORT_FILEPATH := $(TRACE_ANALYSIS_REPORT_DIRPATH)/report.html
TRACE_CORPUS_DIRPATH := $(TRACE_DIRPATH)/corpus
TRACE_LOGS_DIRPATH := $(TRACE_DIRPATH)/logs
TRACE_LOGS_RAW_DIRPATH := $(TRACE_LOGS_DIRPATH)/raw
TRACE_LOGS_PRESCANNED_DIRPATH := $(TRACE_LOGS_DIRPATH)/prescanned
TRACE_LOGS_REDUCED_DIRPATH := $(TRACE_LOGS_DIRPATH)/reduced
TRACE_LOGS_SCANNED_DIRPATH := $(TRACE_LOGS_DIRPATH)/scanned
TRACE_LOGS_COMBINED_DIRPATH := $(TRACE_LOGS_DIRPATH)/combined
TRACE_LOGS_MERGED_DIRPATH := $(TRACE_LOGS_DIRPATH)/merged
TRACE_LOGS_SUMMARIZED_DIRPATH := $(TRACE_LOGS_DIRPATH)/summarized
TRACE_LOGS_REPORT_DIRPATH := $(TRACE_LOGS_DIRPATH)/report
TRACE_LOGS_CORPUS_DIRPATH := $(TRACE_LOGS_DIRPATH)/corpus
TRACE_LOGS_SUMMARY_DIRPATH := $(TRACE_LOGS_DIRPATH)/summary
TRACE_LOGS_SUMMARY_RAW_DIRPATH := $(TRACE_LOGS_SUMMARY_DIRPATH)/raw
TRACE_LOGS_SUMMARY_REDUCED_DIRPATH := $(TRACE_LOGS_SUMMARY_DIRPATH)/reduced
TRACE_LOGS_SUMMARY_COMBINED_FILEPATH := $(TRACE_LOGS_SUMMARY_DIRPATH)/combined
TRACE_LOGS_SUMMARY_SUMMARIZED_FILEPATH := $(TRACE_LOGS_SUMMARY_DIRPATH)/summarized

################################################################################
## prescan variables
################################################################################
TRACED_SCRIPTS_FILEPATH := traced_scripts.csv

################################################################################
## combine variables
################################################################################
COMBINE_COUNT := 1000
COMBINED_FILENAME_PREFIX = $(shell hostname)-part

################################################################################
## scan variables
################################################################################
ALL_SCRIPTS_FILEPATH := all_scripts.csv
VALID_SCRIPTS_FILEPATH := valid_scripts.csv
INVALID_SCRIPTS_FILEPATH := invalid_scripts.csv

################################################################################
## report directory paths
################################################################################
REPORT_TEMPLATE_DIRPATH := report
REPORT_UTILITIES_SCRIPTPATH := report/utilities.R

################################################################################
## latex variables
################################################################################
LATEX_FILENAME := variables.tex
APPEND := --append

################################################################################
## package setup options
################################################################################
CRAN_MIRROR_URL := "https://cran.r-project.org"
PACKAGE_SETUP_REPOSITORIES := --setup-cran --setup-bioc
PACKAGE_SETUP_NCPUS := 8
PACKAGE_SETUP_DIRPATH := ~/r-dyntrace-packages
PACKAGE_LIB_DIRPATH := $(PACKAGE_SETUP_DIRPATH)/lib
PACKAGE_CONTRIB_DIRPATH := $(PACKAGE_SETUP_DIRPATH)/contrib
PACKAGE_SRC_DIRPATH := $(PACKAGE_SETUP_DIRPATH)/src
PACKAGE_TEST_DIRPATH := $(PACKAGE_SETUP_DIRPATH)/tests
PACKAGE_EXAMPLE_DIRPATH := $(PACKAGE_SETUP_DIRPATH)/examples
PACKAGE_VIGNETTE_DIRPATH := $(PACKAGE_SETUP_DIRPATH)/doc
PACKAGE_LOG_DIRPATH := $(PACKAGE_SETUP_DIRPATH)/log

################################################################################
## GNU Parallel arguments
################################################################################
PARALLEL_JOB_COUNT := 1
PARALLEL_JOB_COUNT_FILEPATH := scripts/procfile
TRACE_TRACING_SCRIPT_FILEPATH := scripts/trace.R
CORPUS_FILEPATH := corpus/test.txt
DEPENDENCIES_FILEPATH := scripts/dependencies.txt

################################################################################
## tracer arguments
################################################################################
BINARY := --binary
COMPRESSION_LEVEL := 0
TRUNCATE := --truncate
## timeout value in seconds
TRACING_TIMEOUT := 3600
## to enable verbose mode, use the flag: --verbose
VERBOSE :=

TRACE_ANALYSIS_SCRIPT_TYPE := --vignettes --examples --tests
################################################################################
## analysis arguments
################################################################################
ANALYSIS := dynamic_calls

################################################################################
## data table viewer arguments
################################################################################
DATA_TABLE_VIEWER_SCRIPT := scripts/view-data-table.R
DATA_TABLE_VIEWER_FILEPATH :=
DATA_TABLE_VIEWER_ARGS :=

################################################################################
## lint arguments
################################################################################
LINT_FILEPATH := scripts/create-corpus-with-matching-patterns.R


FUNCTION_DEFINITIONS_FILENAME := function_definitions_with_script

export R_KEEP_PKG_SOURCE=1
export R_ENABLE_JIT=0
export R_COMPILE_PKGS=0
export R_DISABLE_BYTECODE=1
export OMP_NUM_THREADS=2
export R_LIBS=$(PACKAGE_LIB_DIRPATH)

define tracer =
$(TIME) $(R_DYNTRACE) --slave                                                     \
                      --no-restore                                                \
                      --file=$(TRACE_TRACING_SCRIPT_FILEPATH)                     \
                      --args --tracing-timeout=$(TRACING_TIMEOUT)                 \
	                           --r-dyntrace=$(R_DYNTRACE)                           \
                             --corpus-dirpath=$(TRACE_CORPUS_DIRPATH)             \
                             --raw-analysis-dirpath=$(TRACE_ANALYSIS_RAW_DIRPATH) \
                             $(VERBOSE)                                           \
                             $(TRUNCATE)                                          \
                             $(BINARY)                                            \
                             --compression-level=$(COMPRESSION_LEVEL)
endef


define parallel =
	parallel --jobs $(PARALLEL_JOB_COUNT_FILEPATH)             \
	                --files                                    \
	                --bar                                      \
	                --results $(TRACE_LOGS_RAW_DIRPATH)/{1}/   \
	                --joblog $(TRACE_LOGS_SUMMARY_RAW_DIRPATH) \
	                $(tracer)                                  \
	                {1}
endef


define trace =
	@echo "R_ENABLE_JIT=${R_ENABLE_JIT}"
	@echo "R_COMPILE_PKGS=${R_COMPILE_PKGS}"
	@echo "PARALLEL JOB COUNT=${PARALLEL_JOB_COUNT}"
	@echo $(PARALLEL_JOB_COUNT) > $(PARALLEL_JOB_COUNT_FILEPATH)
	@mkdir -p $(TRACE_LOGS_DIRPATH)
	@mkdir -p $(TRACE_LOGS_RAW_DIRPATH)
	@mkdir -p $(TRACE_LOGS_SUMMARY_DIRPATH)

	@if [ -e $(LATEST_TRACE_DIRPATH) ]; then \
		unlink latest; \
	fi
	@ln -fs $(TRACE_DIRPATH) latest
	$(XVFB_RUN) `$(parallel) :::: $(CORPUS_FILEPATH) > /dev/null`
endef


trace-jit: R_ENABLE_JIT=3
trace-jit: R_COMPILE_PKGS=1
trace-jit: R_DISABLE_BYTECODE=0
trace-jit: R_KEEP_PKG_SOURCE=1
trace-jit:
	$(trace)


trace-ast: R_ENABLE_JIT=0
trace-ast: R_COMPILE_PKGS=0
trace-ast: R_DISABLE_BYTECODE=1
trace-ast: R_KEEP_PKG_SOURCE=1
trace-ast:
	$(trace)


prescan-analysis:
	@mkdir -p $(TRACE_LOGS_PRESCANNED_DIRPATH)
	@mkdir -p $(TRACE_ANALYSIS_PRESCANNED_DIRPATH)

	@find $(TRACE_ANALYSIS_RAW_DIRPATH)                                     \
	      -mindepth 3                                                       \
	      -maxdepth 3                                                       \
	      -printf "%P\n"                                                    \
	      -type d                                                           \
	      > $(TRACE_ANALYSIS_PRESCANNED_DIRPATH)/$(TRACED_SCRIPTS_FILEPATH) \
	      2> $(TRACE_LOGS_PRESCANNED_DIRPATH)/log


reduce-analysis:
	@mkdir -p $(TRACE_LOGS_SUMMARY_REDUCED_DIRPATH)
	@mkdir -p $(TRACE_LOGS_REDUCED_DIRPATH)/$(ANALYSIS)
	@mkdir -p $(TRACE_ANALYSIS_REDUCED_DIRPATH)/$(ANALYSIS)

	-@$(TIME) parallel --jobs $(PARALLEL_JOB_COUNT)                                                     \
	                   --files                                                                          \
	                   --bar                                                                            \
	                   --results $(TRACE_LOGS_REDUCED_DIRPATH)/$(ANALYSIS)/{1}                          \
	                   --joblog $(TRACE_LOGS_SUMMARY_REDUCED_DIRPATH)/$(ANALYSIS)                       \
	                   $(R_DYNTRACE) $(R_DYNTRACE_FLAGS)                                                \
	                                 --file=scripts/reduce.R                                            \
	                                 --args $(TRACE_ANALYSIS_RAW_DIRPATH)/{1}                           \
	                                        $(TRACE_ANALYSIS_REDUCED_DIRPATH)/$(ANALYSIS)/{1}           \
	                                        $(ANALYSIS)                                                 \
	                                        $(TRACE_ANALYSIS_SCRIPT_TYPE)                               \
	                                        $(BINARY)                                                   \
	                                        --compression-level=$(COMPRESSION_LEVEL)                    \
	                   "2>&1"                                                                           \
	                   :::: $(TRACE_ANALYSIS_PRESCANNED_DIRPATH)/$(TRACED_SCRIPTS_FILEPATH) > /dev/null


scan-analyses:
	@mkdir -p $(TRACE_LOGS_SCANNED_DIRPATH)
	@mkdir -p $(TRACE_ANALYSIS_SCANNED_DIRPATH)

	@$(UNBUFFER) $(TIME) $(R_DYNTRACE) $(R_DYNTRACE_FLAGS)                                                  \
	                                   --file=scripts/scan.R                                                \
	                                   --args $(TRACE_ANALYSIS_REDUCED_DIRPATH)                             \
	                                          $(TRACE_ANALYSIS_SCANNED_DIRPATH)/$(ALL_SCRIPTS_FILEPATH)     \
	                                          $(TRACE_ANALYSIS_SCANNED_DIRPATH)/$(VALID_SCRIPTS_FILEPATH)   \
	                                          $(TRACE_ANALYSIS_SCANNED_DIRPATH)/$(INVALID_SCRIPTS_FILEPATH) \
	                                          $(TRACE_ANALYSIS_SCRIPT_TYPE)                                 \
	                                          2>&1 | $(TEE) $(TEE_FLAGS)                                    \
	                                                 $(TRACE_LOGS_SCANNED_DIRPATH)/log


combine-analysis:
	@mkdir -p $(TRACE_LOGS_SUMMARY_DIRPATH)
	@mkdir -p $(TRACE_LOGS_COMBINED_DIRPATH)

	@$(UNBUFFER) $(TIME) $(R_DYNTRACE) $(R_DYNTRACE_FLAGS)                                                  \
	                                   --file=scripts/combine.R                                             \
	                                   --args $(TRACE_ANALYSIS_REDUCED_DIRPATH)                             \
	                                          $(TRACE_ANALYSIS_COMBINED_DIRPATH)                            \
	                                          $(TRACE_ANALYSIS_SCANNED_DIRPATH)/$(VALID_SCRIPTS_FILEPATH)   \
	                                          $(ANALYSIS)                                                   \
	                                          $(COMBINE_COUNT)                                              \
	                                          $(TRACE_ANALYSIS_SCRIPT_TYPE)                                 \
	                                          $(BINARY)                                                     \
	                                          --compression-level=$(COMPRESSION_LEVEL)                      \
	                                          --combined-filename-prefix=$(COMBINED_FILENAME_PREFIX)        \
	                                          2>&1 | $(TEE) $(TEE_FLAGS)                                    \
	                                                 $(TRACE_LOGS_COMBINED_DIRPATH)/$(ANALYSIS)


merge-analysis:
	@mkdir -p $(TRACE_LOGS_SUMMARY_DIRPATH)
	@mkdir -p $(TRACE_LOGS_MERGED_DIRPATH)

	@$(UNBUFFER) $(TIME) $(R_DYNTRACE) $(R_DYNTRACE_FLAGS)                                           \
	                                   --file=scripts/merge.R                                        \
	                                   --args $(TRACE_ANALYSIS_COMBINED_DIRPATH)                     \
	                                          $(TRACE_ANALYSIS_MERGED_DIRPATH)                       \
	                                          $(ANALYSIS)                                            \
	                                          $(BINARY)                                              \
	                                          --compression-level=$(COMPRESSION_LEVEL)               \
	                                          2>&1 | $(TEE) $(TEE_FLAGS)                             \
	                                                 $(TRACE_LOGS_MERGED_DIRPATH)/$(ANALYSIS)


summarize-analysis:
	@mkdir -p $(TRACE_LOGS_SUMMARY_DIRPATH)
	@mkdir -p $(TRACE_LOGS_SUMMARIZED_DIRPATH)

	@$(UNBUFFER) $(TIME) $(R_DYNTRACE) $(R_DYNTRACE_FLAGS)                                           \
	                                   --file=scripts/summarize.R                                    \
	                                   --args $(TRACE_ANALYSIS_MERGED_DIRPATH)                       \
	                                          $(TRACE_ANALYSIS_SUMMARIZED_DIRPATH)                   \
	                                          $(ANALYSIS)                                            \
	                                          $(BINARY)                                              \
	                                          --compression-level=$(COMPRESSION_LEVEL)               \
	                                   2>&1 | $(TEE) $(TEE_FLAGS)                                    \
	                                                 $(TRACE_LOGS_SUMMARIZED_DIRPATH)/$(ANALYSIS)

report-analyses:
	@mkdir -p $(TRACE_ANALYSIS_VISUALIZED_DIRPATH)
	@mkdir -p $(TRACE_ANALYSIS_LATEX_DIRPATH)
	@mkdir -p $(TRACE_LOGS_SUMMARY_DIRPATH)
	@mkdir -p $(TRACE_LOGS_REPORT_DIRPATH)

	@$(UNBUFFER) $(TIME) $(XVFB_RUN) $(R_DYNTRACE) $(R_DYNTRACE_FLAGS)                                          \
	                                               --file=scripts/report.R                                      \
	                                               --args $(TRACE_ANALYSIS_REPORT_FILEPATH)                     \
	                                                      $(TRACE_ANALYSIS_SUMMARIZED_DIRPATH)                  \
	                                                      $(TRACE_ANALYSIS_VISUALIZED_DIRPATH)                  \
	                                                      $(TRACE_ANALYSIS_LATEX_FILEPATH)                      \
	                                                      $(BINARY)                                             \
	                                                      --compression-level=$(COMPRESSION_LEVEL)              \
	                                               2>&1 | $(TEE) $(TEE_FLAGS)                                   \
	                                                             $(TRACE_LOGS_REPORT_DIRPATH)/$(ANALYSIS)

reduce-analyses:
	$(MAKE) reduce-analysis TRACE_DIRPATH=$(TRACE_DIRPATH) PARALLEL_JOB_COUNT=$(PARALLEL_JOB_COUNT) BINARY=$(BINARY) COMPRESSION_LEVEL=$(COMPRESSION_LEVEL) ANALYSIS=function_definitions


combine-analyses:
	$(MAKE) combine-analysis TRACE_DIRPATH=$(TRACE_DIRPATH) BINARY=$(BINARY) COMPRESSION_LEVEL=$(COMPRESSION_LEVEL) COMBINE_COUNT=$(COMBINE_COUNT) ANALYSIS=function_definitions


merge-analyses:
	$(MAKE) merge-analysis TRACE_DIRPATH=$(TRACE_DIRPATH) BINARY=$(BINARY) COMPRESSION_LEVEL=$(COMPRESSION_LEVEL) ANALYSIS=function_definitions


summarize-analyses:
	$(MAKE) summarize-analysis TRACE_DIRPATH=$(TRACE_DIRPATH) BINARY=$(BINARY) COMPRESSION_LEVEL=$(COMPRESSION_LEVEL) ANALYSIS=function_definitions


.PHONY: trace                           \
        view-data-table                 \
        report                          \
        prescan-analysis                \
        reduce-analysis                 \
        combine-analysis                \
        merge-analysis                  \
        summarize-analysis              \
        reduce-analyses                 \
        scan-analyses                   \
        combine-analyses                \
        merge-analyses                  \
        summarize-analyses              \
        report-analyses
