#' Formatar datas para envio
#'
#' Função formata datas incompletas para serem lidas pelo web service do BC
#'
#' @param data data incompleta
#' @return data completa
#' @keywords internal
formatar_data <- function(data, modo = c("inicio", "fim")) {
  modo <- match.arg(modo)

  if(methods::is(data, "Date")) {
    data <- format(data, "%d/%m/%Y")
  } else {
    data <- as.character(data)
    if(grepl("^\\d{4}$", data)) {
      if(modo == "inicio") {
        data <- paste0("01/01/", data)
      } else if (modo == "fim") {
        data <- paste0("31/12/", data)
      }
    } else if(grepl("^\\d{2}(/|-)\\d{4}$", data)) {
      if(modo == "inicio") {
        data <- paste0("01/", data)
      } else if(modo == "fim") {
        # Coseguindo último dia do mês, gambiarra
        data <- paste0("01/", data)
        data <- zoo::as.yearmon(data, format = "%d/%m/%Y")
        data <- format(as.Date(data, frac = 1), "%d/%m/%Y")
      }
    }
  }
  data
}
