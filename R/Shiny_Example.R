#' Launch Shiny app to calculate doubling times interactively
#' @details
#' This app doesn't take any arguments, but launches a shiny app wherein you can interactively upload data to calculate doubling times. Please see the vignette using browseVignettes("doublr") to read through a walk-through of using the app. If no vignette is available, make sure to use devtools::install_github("gus-pendleton/doublr", build_vignettes = T) to make sure it is installed alongside the package.
#'@export
Launch<-function(){appDir<-system.file("shiny-examples","myapp",package = "doublr")
if (appDir == "") {
  stop("Could not find example directory. Try re-installing `mypackage`.", call. = FALSE)
}

shiny::runApp(appDir, display.mode = "normal")
}
