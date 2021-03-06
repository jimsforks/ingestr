#' Ingest Campbell Scientific Logger data
#'
#' \code{ingest_campbell} ingests data from Campbell Scientific dataloggers that
#' are stored in the TAO5 file format with a .dat extension \strong{All
#' ingest functions use the source file's base name as an identifying column to track
#' provenance and relate data and metadata read from files.}
#'
#' The TIMESTAMP column will be returned as an POSIXct column.
#'
#' @param input.source Character indicating the .dat Campbell Scientific File.
#' @param add.units Logical indicating if add.units specified in the data file should be
#'   appended to the end of the variable names specified in the data file,
#'   defaults to TRUE.
#' @param add.measurements Logical indicating if add.measurements type (Avg, Smp,
#'   etc) specified in the data file should be appended to the start of the
#'   variable names specified in the data file, defaults to TRUE.
#' @param export.header A logical indicating if header information is written to a
#'   temporary file that can be restored using ingest_header(input.source).
#'
#' @return A dataframe. If export.header = TRUE a temporary file is created for
#'   the header data. See \code{\link{ingest_header}} for more information.
#'
#' @export
#'
#' @examples
#' \dontrun{ 
#' campbell_file <- system.file("example_data", "campbell_scientific_tao5.dat", package = "ingestr")
#' cs_data <- ingest_campbell(input.source = campbell_file)
#' }

ingest_campbell <-
  function(input.source,
           export.header = TRUE,
           add.units = TRUE,
           add.measurements = TRUE){

    all_logical(add.units,
                add.measurements,
                export.header)

    all_character(input.source)

    input_source <-
      normalizePath(input.source)

    column.names <-
        as.data.frame(
          t(
            utils::read.csv(input_source,
                            skip = 1,
                            nrows = 3,
                            header = F,
                            check.names = FALSE,
                            na.strings = "",
                            stringsAsFactors = F)
          ),
          stringsAsFactors = F
        )

    names(column.names) <-
        c("variable", "units", "measurements")

    column.names$names <-
      column.names$variable

    if(add.units){
      column.names$names <-
        ifelse(is.na(column.names$units),
               column.names$names,
               paste(column.names$names,
                     column.names$units,
                     sep = "_"))
    }

    if(add.measurements){
      column.names$names <-
        ifelse(is.na(column.names$measurements),
               column.names$names,
               paste(column.names$measurements,
                     column.names$names,
                     sep = "_"))
    }

      data <- utils::read.csv(input_source,
                       skip = 4,
                       header = F,
                       stringsAsFactors = F,
                       na.strings = -9999,
                       col.names = column.names$names)

      data$input_source <-
        input.source

      data$TIMESTAMP_TS <-
        as.POSIXct(data$TIMESTAMP_TS,
                   format = "%Y-%m-%d %H:%M:%S")

      names(data) <-
        gsub("TIMESTAMP_TS",
             "TIMESTAMP",
             names(data))

      names(data) <-
        gsub("RECORD_RN",
             "RECORD",
             names(data))

      if(export.header){
        header_info <-
          utils::read.csv(input_source,
                          nrow = 1,
                          header = FALSE,
                          stringsAsFactors = FALSE,
                          col.names = c("file_type",
                                        "logger_name",
                                        "logger_model",
                                        "logger_serial_number",
                                        "logger_os_version",
                                        "logger_program_name",
                                        "logger_program_signature",
                                        "logger_table_name"))

        export_header(header_info,
                      input.source)

     }

      return(data)
    }
