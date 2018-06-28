#' Obter valores série de tempo especial
#'
#' Função obtém valores da série de tempo especial requisitada, utilizando método
#' getValorEspecial do web service do Banco Central.
#'
#' @param serie código da série no Sistema Gerenciador de Séries Temporais
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @return valor da série especial requisitada
#' @seealso
#' \code{\link{obter_bcws}}
#' \code{\link{obter_bc}}
#' @export
getValorEspecial <- function(serie,
                                inicio="01/01/1995",
                                fim=Sys.Date()) {
  obter_bcws("getValorEspecial", serie, inicio, fim)
}
