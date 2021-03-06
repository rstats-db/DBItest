% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/spec-meta-column-info.R
\docType{data}
\name{spec_meta_column_info}
\alias{spec_meta_column_info}
\title{spec_meta_column_info}
\value{
\code{dbColumnInfo()}
returns a data frame
with at least two columns \code{"name"} and \code{"type"} (in that order)
(and optional columns that start with a dot).
The \code{"name"} and \code{"type"} columns contain the names and types
of the R columns of the data frame that is returned from \code{\link[=dbFetch]{dbFetch()}}.
The \code{"type"} column is of type \code{character} and only for information.
Do not compute on the \code{"type"} column, instead use \code{dbFetch(res, n = 0)}
to create a zero-row data frame initialized with the correct data types.

An attempt to query columns for a closed result set raises an error.
}
\description{
spec_meta_column_info
}
\section{Specification}{


A column named \code{row_names} is treated like any other column.

The column names are always consistent
with the data returned by \code{dbFetch()}.
If the query returns unnamed columns,
unique
non-empty and non-\code{NA} names are assigned.
In the case of a duplicate column name, the first occurrence
retains the original name, and unique names are assigned for
the other occurrences.
Column names that correspond to SQL or R keywords are left unchanged.
}

\keyword{internal}
