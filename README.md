# Study of Dynamism in R

This project uses [dynamismtracer](https://github.com/PRL-PRG/dynamismtracer "dynamismtracer") and [dynalyzer](https://github.com/PRL-PRG/dynalyzer "dynalyzer") to generate, analyze and report dynamism in R.

## Dependencies

The pipeline requires the following linux programs:
- xvfb-run
- time
- unbuffer
- tee
- parallel

To install these programs on Ubuntu variants, run the following command:
```shell
$ sudo apt install xvfb unbuffer parallel expect
```


## Administration

The following commands execute the corresponding stages of the analysis pipeline.
They have to be executed in order, intermediate stages read the result of their previous stage as input.

### Trace

```shell
$ make trace-ast TRACE_DIRPATH=latest CORPUS_FILEPATH=corpus/test.txt PARALLEL_JOB_COUNT=8 COMPRESSION_LEVEL=3 BINARY=--binary
```

### Prescan

```shell
$ make prescan-analysis TRACE_DIRPATH=latest
```

### Reduce

```shell
$ make reduce-analysis TRACE_DIRPATH=latest PARALLEL_JOB_COUNT=8 BINARY=--binary COMPRESSION_LEVEL=3 ANALYSIS=dynamic_calls
```

### Scan

```shell
$ make scan-analyses TRACE_DIRPATH=latest
```

### Combine

```shell
$ make combine-analysis TRACE_DIRPATH=latest PARALLEL_JOB_COUNT=8 BINARY=--binary COMPRESSION_LEVEL=3 COMBINE_COUNT=10000 ANALYSIS=dynamic_calls
```

### Merge

```shell
$ make merge-analysis TRACE_DIRPATH=latest BINARY=--binary COMPRESSION_LEVEL=3 ANALYSIS=dynamic_calls
```

### Summarize

```shell
$ make summarize-analysis TRACE_DIRPATH=latest BINARY=--binary COMPRESSION_LEVEL=3 ANALYSIS=dynamic_calls
```

### Report

```shell
$ make report-analyses TRACE_DIRPATH=latest BINARY=--binary COMPRESSION_LEVEL=3
```
