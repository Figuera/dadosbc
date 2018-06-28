#' Obter valor de série de tempo
#'
#' Função obtém valor da série de tempo no período requisitado, utilizando método
#' getValor do web service do Banco Central.
#'
#' @param serie código da série no Sistema Gerenciador de Séries Temporais
#' @param inicio data de inicío da consulta
#' @return valor da séria requisitada
#' @seealso
#' \code{\link{obter_bcws}}
#' \code{\link{obter_bc}}
#' @export
#' @examples
#' \dontrun{dolar <- getValor(1, "01/03/2012")}
getValor <- function(serie,
                         inicio="01/01/1995"){
  obter_bcws("getValor", serie, inicio)
}
