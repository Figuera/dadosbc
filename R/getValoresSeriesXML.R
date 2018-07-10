#' Obter série de tempo em formato XML
#'
#' Função obtém valores da série de tempo requisitada, utilizando método
#' getValoresSeriesXML do web service do Banco Central. Para resultados mais
#' compreensíveis utilize a função \code{obter_bc}.
#'
#' @param serie código da série no Sistema Gerenciador de Séries Temporais
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @return texto XML com resposta à consulta
#' @seealso
#' \code{\link{obter_bcws}}
#' \code{\link{obter_bc}}
#' @export
#' @examples
#' # Obtém toda a série de tempo de câmbio, a partir de 1995, em formato XML
#' dolar <- getValoresSeriesXML(1) 
#' # Obter a série de tempo de câmbio, a partir de 1995, em formato XML
#' dolar <- getValoresSeriesXML(1, inicio="01/01/1995", fim = "31/01/1995")
getValoresSeriesXML <- function(serie,
                                inicio="01/01/1995",
                                fim=Sys.Date()) {
  obter_bcws("getValoresSeriesXML", serie, inicio, fim)
}
