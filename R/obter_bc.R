#' Realiza consulta de série de tempo no sistema gerador de séries temporais do BC
#'
#' Função genérica consulta a série de tempo desejada no web service do BC e a
#' retorna como uma série do tempo tradicional do R.
#'
#' @param codigos codigos das séries de tempo desejadas
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @param bloqueado.bool Boolean define se o campo "bloqueado" retornado pelo
#'   web service do BC deve ser exibido ou não, padrão é FALSE.
#' @param remove.old Boolen define se os valores sem tratamento também devem
#'   retornados, útil para testes. Padrão é FALSE.
#' @return Série de tempo desejada.
#' @seealso
#' \code{\link{obter_bcws}}
#' \code{\link{getValoresSeriesXML}}
#' @export
#' @examples
#' # Obter série de câmbio a partir de 1995
#' obter_bc(1)
#' # Obter série de câmbio entre 01/01/1995 e 31/12/1995
#' obter_bc(1, inicio = "01/01/1995", fim = "31/12/1995")
#' # Mesmo que o example anterior e mais simples
#' obter_bc(1, inicio = 1995, fim = 1995)
#' # Obter série de compra e venda de dolár ente 01/01/1995 e 31/12/1995
#' obter_bc(c(1, 10813), inicio = 1995, fim = 1995)
obter_bc <- function(codigos,
                     inicio = "01/01/1995",
                     fim = Sys.Date(),
                     bloqueado.bool = FALSE,
                     remove.old = TRUE) {
  # Acessar interface do webservice
  xmlstr <- getValoresSeriesXML(codigos, inicio, fim)

  doc <- xml2::read_xml(xmlstr)
  series <- xml2::xml_find_all(doc, "//SERIE")
  x <- lapply(series, function(serie) {
    DATA  <- xml2::xml_text(xml2::xml_find_all(serie, "//DATA"))
    VALOR <- xml2::xml_text(xml2::xml_find_all(serie, "//VALOR"))
    if(bloqueado.bool) {
      BLOQUEADO <- xml2::xml_text(xml2::xml_find_all(serie, "//BLOQUEADO"))
      df <- data.frame(DATA=DATA, VALOR=VALOR, BLOQUEADO=BLOQUEADO, stringsAsFactors=F)
    } else {
      df <- data.frame(DATA=DATA, VALOR=VALOR, stringsAsFactors=F)
    }
    df$SERIE  <- xml2::xml_attr(serie, "ID")
    df
  })
  df <- Reduce(rbind, x)

  # Contando número de barras
  barras <- length(strsplit(df$DATA[1], split="/")[[1]]) - 1
  if(barras == 2) {
    df$data <- as.Date(df$DATA, "%d/%m/%Y")
  } else if(barras == 1) {
    df$data <- zoo::as.yearmon(df$DATA, "%m/%Y")
    if(nrow(df) > 1) {
      if(diff(as.numeric(format(df$data, "%m")))[1] == 3 ||
        diff(as.numeric(format(df$data, "%m")))[2] == 3)
        df$data <- zoo::as.yearqtr(df$data)
    }
  } else {
    df$data <- as.numeric(df$DATA)
  }
  df$valor <- as.numeric(df$VALOR)
  df$serie <- factor(df$SERIE)

  if(remove.old){
    df$BLOQUEADO <- NULL
    df$SERIE <- NULL
    df$DATA <- NULL
    df$VALOR <- NULL
  }

  if(length(codigos) == 1)
    df$serie <- NULL

  zoo::zoo(df[,-1], order.by=df$data)
}
