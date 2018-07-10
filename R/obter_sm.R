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
#' @examples
#' # Obter série de salário mínimo a partir de 01/01/1995
#' sm <- obter_sm()
#' # Obter série de salário mínimo em valores resais a partir de 01/01/1995
#' sm <- obter_sm(unidade = "real")
#' # Obter série anual de salario mínimo  entre 2010 e 2014
#' sm <- obter_sm(inicio = 2010, fim = 2014, frequencia = "anual")
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
