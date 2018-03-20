#' @title Read TRA data
#'
#' @description Read TRA data from CSV files.
#'
#' @details
#' This function reads TRA data from CSV files for use in downstream analyses.
#'
#' @export
#' @rdname read_tra_data
#' @param file The input CSV file (character).
#' @param skip_rows The number of rows to skip (integer).
#' @return A dataframe with the read TRA data.
#'
#' @examples
#' # Get input file path
#' file_path <- system.file("extdata", "example_data_1.csv",
#'                          package = "ATRADA")
#'
#' # Read TRA data from file
#' data <- read_tra_data(file_path)
#' data <- read_tra_data(file_path, skip_rows = 5)
read_tra_data <- function(file,
                          skip_rows = 0) {

    # Read TRA data from CSV file
    data <- utils::read.table(file,
                              skip             = skip_rows,
                              sep              = ",",
                              header           = TRUE,
                              fill             = TRUE,
                              stringsAsFactors = FALSE)

    # Return data
    return(data)
}
