% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ingest_pacific_decadal_oscillation.R
\name{ingest_PDO}
\alias{ingest_PDO}
\title{Ingest Pacific Decadal Oscillation data}
\usage{
ingest_PDO(
  input.source = "http://jisao.washington.edu/pdo/PDO.latest",
  end.year = NULL,
  export.header = TRUE
)
}
\arguments{
\item{input.source}{Character indicating the URI to the HTML representation of the data.}

\item{end.year}{Four digit integer indicating the last year of data wanted.}

\item{export.header}{A logical indicating if header information is written to a
separate data frame.}
}
\value{
A data frame.  If export.header = TRUE a temporary file is created for
  the header data. See \code{\link{ingest_header}} for more information.
}
\description{
\code{ingest_PDO} ingests data from the updated standardized values for the
PDO index, derived as the leading PC of monthly SST anomalies in the North
Pacific Ocean, poleward of 20N. The monthly mean global average SST anomalies
are removed to separate this pattern of variability from any "global warming"
signal that may be present in the data.  If you have any questions about this
time series, contact Nathan Mantua at: nate.mantua\@noaa.gov \strong{All
ingest functions use the source file name as an identifying column to track
provenance and relate data and metadata read from files.}
}
\examples{
\dontrun{
df_pdo <- ingest_PDO()  # reads in all the data from start date to present
df_pdo1 <- ingest_PDO(end.year=2000)  # reads in the data from start date to the year 2000
}

}
