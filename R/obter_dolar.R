#' Realiza consulta de série de tempo do dolár
#'
#' Função consulta a série de taxas de câmbio no web service do BC.
#'
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @param tipo tipo de taxa de câmbio ("compra" ou "venda")
#' @param frequencia frequencia da variavel ("diario", "mensal", "anual")
#' @return Série de tempo das taxas de câmbio
#' @seealso
#' \code{\link{obter_bcws}}
#' \code{\link{getValoresSeriesXML}}
#' @export
#' @examples
#' # Obter série de câmbio a partir de 01/01/1995
#' dolar <- obter_dolar()
#' # Obter série de venda de dolár a partir de 01/01/1995
#' dolar <- obter_dolar(tipo = "venda")
#' # Obter série mensal de câmbio durante o ano de 2010
#' dolar <- obter_dolar(inicio = 2010, fim = 2010, frequencia = "mensal")
obter_dolar <- function(inicio="01/01/1995",
                        fim = Sys.Date(),
                        tipo=c("compra", "venda"), 
                        frequencia=c("diario", "mensal", "anual")){
  tipo   <- match.arg(tipo)
  codigo <- switch(tipo,
                   compra = 1,
                   venda = 10813)
  dolar <- obter_bc(codigo, inicio=inicio, fim=fim)

  frequencia <- match.arg(frequencia)
  if(frequencia == "diario"){
    return(dolar)
  } else if(frequencia == "mensal") {
    return(stats::aggregate(dolar, by=zoo::as.yearmon(stats::time(dolar)), mean))
  } else if(frequencia == "anual") {
    return(stats::aggregate(dolar, by=format(dolar, "%Y"), mean))
  }
}

