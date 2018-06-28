#' Realiza consulta de série de tempo do Salário Mínimo
#'
#' Função consulta a série de tempo se salário mínimo no web service do BC.
#'
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @param unidade define se valores reais ou nominais
#' @param frequencia frequencia da variavel
#' @param base ano base para valores reais
#' @return Série de tempo de salário mínimo
#' @seealso
#' \code{\link{obter_bcws}}
#' \code{\link{getValoresSeriesXML}}
#' @importFrom stats time
#' @export
obter_sm <- function(inicio="01/01/1995",
                     fim=Sys.Date(),
                     unidade=c("nominal", "real"),
                     frequencia=c("mensal", "anual"), 
                     base = 1995) {
  frequencia <- match.arg(frequencia)
  unidade    <- match.arg(unidade)

  sm <- obter_bc(1619, inicio=inicio, fim=fim)

  if(frequencia == "anual")
    sm <- stats::aggregate(sm, by=format(time(sm), "%Y"), mean)

  if(unidade == "real"){
    ipca <- obter_ipca(inicio=inicio, fim=fim, base=base, frequencia=frequencia)
    sm <- sm*100/ipca
  }
  sm
}
