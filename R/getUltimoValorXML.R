#' Obter último valor de série de tempo em formato XML
#'
#' Função obtém o último valor da série de tempo requisitada, utilizando método
#' getUltimoValorXML do web service do Banco Central. Para resultados mais
#' compreensíveis utilize a função \code{obter_bc}.
#'
#' @param serie código da série no Sistema Gerenciador de Séries Temporais
#' @return texto XML com resposta à consulta
#' @seealso
#' \code{\link{obter_bcws}}
#' \code{\link{obter_bc}}
#' @export
#' @examples
#' dolar <- getUltimoValorXML(1) # Obtém último valor da série de câmbio
getUltimoValorXML <- function(serie) {
  obter_bcws("getUltimoValorXML", serie)
}
