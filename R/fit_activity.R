#' @title Fit activity data
#'
#' @description Fit activity data to a sigmoidal curve.
#'
#' @details This are functions for fitting a sigmoidal curve to each TRA well
#' using the time-series data therein, yielding the activitity for a given
#' endolysine and concentration.
#'
#' @export
#' @rdname fit_activity
#' @param data The TRA data (dataframe).
#' @param well_output File path for the per-well output figure (character).
#' @param activity_output File path for the activity output figure (character).
#' @param normalise Wether to normalise the data or not (boolean).
#' @return A dataframe containing the calculated activities.
#'
#' @examples
#' # Get input file path
#' file_path <- system.file("extdata", "example_data_1.csv",
#'                          package = "ATRADA")
#'
#' # Read example data
#' data <- read_tra_data(file_path)
#'
#' # Get the activity for each well
#' activity <- fit_activity(data, "wells.png")
fit_activity <- function(data,
                         well_output,
                         activity_output,
                         normalise = FALSE) {

    # Get maximum OD600
    max_od600 <- max(data[6:ncol(data)])

    # Calculate slopes and plot individual wells
    message("Calculating per-well activities ...")
    results <- apply(data[names(data)[6:ncol(data)]],
                     MARGIN    = 1,
                     FUN       = fit_sigmoid,
                     max_od600 = max_od600)

    # Separate slopes and plots into individual lists
    plot_list <- list()
    slope_list <- list()
    for (element in results) {
        slope_list[[length(slope_list) + 1]] <- element[[1]]
        plot_list[[length(plot_list) + 1]] <- element[[2]]
    }
    
    # Arrange plots in a 96-well plate-like grid and save
    message("Saving per-well activity figure to file ...")
    all_plots <- gridExtra::grid.arrange(grobs = plot_list,
                                         nrow  = 8,
                                         ncol  = 12)
    ggplot2::ggsave(plot_output, all_plots, width = 20, height = 18)
}

# Function for fitting a sigmoid from time-series data
fit_sigmoid <- function(OD600, max_od600) {

    # Convert column names to time
    time <- as.numeric(gsub("X", "", gsub("\\.min", "", names(OD600))))

    # Create dataframe with well data
    well <- data.frame(time, OD600, row.names = NULL)

    # Fit to sigmoid
    fit <- nls(OD600 ~ a + ((b - a) / (1 + exp(-c * (time - d)))),
               data      = well,
               algorithm = "port",
               control   = list(warnOnly = TRUE),
               start     = list(a = min(OD600),
                                b = max(OD600),
                                c = 1,
                                d = median(time)))

    # Get fitted sigmoidal line for plotting
    fit_line <- data.frame(time = time, OD600 = predict(fit, time))

    # Calculate maximum slope of fitted sigmoidal line
    kk <- min(diff(fit_line$OD600))
    mm = max(OD600)

    # Plot points, fitted sigmoid and maximum slope
    gg <- ggplot2::ggplot(data = well, ggplot2::aes(x     = time,
                                                    y     = OD600,
                                                    group = 1)) +
        ggplot2::theme_bw() +
        ggplot2::ylim(0, max_od600) +
        ggplot2::geom_point(size   = 1,
                            colour = "#666666") +
        ggplot2::geom_line(data   = fit_line,
                           colour = "#e4bf4e",
                           size   = 1,
                           alpha  = 0.75,
                           na.rm  = TRUE) +
        ggplot2::stat_function(fun    = function(x) kk * x + mm,
                               colour = "#4e8ce4",
                               size   = 1,
                               alpha  = 0.90,
                               linetype = "dashed",
                               na.rm  = TRUE) +
        ggplot2::labs(x = NULL, y = NULL) +
        ggplot2::annotate("text",
                          x      = max(time),
                          y      = max_od600,
                          hjust  = 1,
                          colour = "#4e8ce4",
                          label  = paste("Activity:", round(kk, 3)))

    # Return slope and graphical object
    return(list(kk, gg))
}
