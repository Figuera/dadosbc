#' Realiza consulta de série de tempo do IPCA
#'
#' Função consulta a série de IPCA no webservice do BC. 
#'
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @param tipo tipo de variavel ("indice", "var")
#' @param frequencia frequencia da variavel ("mensal", "anual")
#' @param base ano base do número indice. Somente útil quando tipo = "indice". Padrão = 1993.
#' @return Série de inflação medida pelo IPCA.
#' @seealso
#' \code{\link{obter_bcws}}
#' \code{\link{getValoresSeriesXML}}
#' @importFrom stats time
#' @export
#' @examples
#' # Obter série de ipca, em número índice, a partir de 01/01/1995
#' dolar <- obter_ipca()
#' # Obter série de ipca, em variação percentual, a partir de 01/01/1995
#' dolar <- obter_ipca(tipo = "var")
#' # Obter série anual de ipca entre 2010 e 2017
#' dolar <- obter_ipca(inicio = 2010, fim = 2017, frequencia = "anual")
obter_ipca <- function(inicio="01/01/1995",
                      fim = Sys.Date(),
                      tipo=c("indice", "var"), 
                      frequencia = c("mensal", "anual"),
                      base = 1993){
  tipo <- match.arg(tipo)
  frequencia <- match.arg(frequencia)
  if(tipo=="var"){
    ipca <- obter_bc(433, inicio, fim)/100
    if(frequencia=="anual")
      warning("Varia\u00E7\u00E3o de IPCA Anual ainda n\u00E3o foi implementada. Fica a dica")
  } else if (tipo=="indice") {
    serie  <- obter_bc(433, "01/01/1994", fim)
    ipca   <- cumprod(c(100, serie/100 + 1))[-1]
    ipca   <- zoo::zoo(ipca, order.by=stats::time(serie))
    inicio <- formatar_data(inicio)
    ipca   <- stats::window(ipca, start=zoo::as.yearmon(inicio, "%d/%m/%Y"))
    if(base > 1993){
      base  <- mean(subset(ipca, format(time(ipca), "%Y") == base))
      ipca  <- ipca*100/base
    }
    if(frequencia == "anual")
      ipca <- stats::aggregate(ipca, by=format(time(ipca), "%Y"), mean)
  }
  ipca
}
