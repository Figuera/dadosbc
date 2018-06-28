#' Obter arquivo resposta para consulta on web service do Banco Central
#'
#' Função que se encarrega de fazer a comunicação com o Web Service do Banco
#' Central
#'
#' @param metodo método a ser realizado na consulta
#' @param serie código da série no Sistemas Gerenciador de Séries Temporais
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @return texto XML com resposta a consulta
#' @seealso
#' \code{\link{obter_bc}}
#' \code{\link{getValoresSeriesXML}}
#' \code{\link{getUltimoValorXML}}
#' \code{\link{getValor}}
#' \code{\link{getValorEspecial}}
#' @keywords internal
#' @examples
#' \dontrun{serie <- obter_bcws("getValoresSeriesXML", 1, "01/01/2015", "31/01/2015")}
obter_bcws <- function(
               metodo=c("getValoresSeriesXML", "getUltimoValorXML", "getValor", "getValorEspecial"),
               serie,
               inicio="01/01/1995",
               fim=Sys.Date()) {
  # Testes de conformidade
  metodo <- match.arg(metodo)
  if(length(serie) > 1 & metodo != "getValoresSeriesXML")
    stop("N\u00E3o \u00E9 poss\u00EDvel consultar mais de uma s\u00E9rie ao mesmo tempo pelo m\u00E9todo: ", metodo)
  inicio <- formatar_data(inicio, "inicio")
  fim    <- formatar_data(fim, "fim")

  soap.request <- soap_request_xml(metodo, serie, inicio, fim)
	soap.action  <- paste0("http://publico.ws.casosdeuso.sgs.pec.bcb.gov.br#", metodo)
  h <- curl::new_handle()
  curl::handle_setheaders(h,
                    "Content-Type" = "text/xml; charset=ISO-8859-1",
                    "Cuntent-Language" = "pt-BR",
                    "SOAPAction" = soap.action)
  curl::handle_setopt(h,
                      copypostfields = soap.request,
                      ssl_verifypeer = FALSE)

  base.url <- "https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS"
  req <- curl::curl_fetch_memory(base.url, handle=h)
  xml <- xml2::read_xml(rawToChar(req$content))
  if(metodo == "getValor") {
    res <- xml2::xml_text(xml2::xml_find_first(xml, paste0("//multiRef")))
  } else {
    res <- xml2::xml_text(xml2::xml_find_first(xml, paste0("//", metodo, "Return")))
  }
  warn <- xml2::xml_find_first(xml, "//soapenv:Fault")

  if(length(warn) > 0)
    warning(xml2::xml_text(warn))

  if(is.na(res))
    stop("Pedido inv\u00E1lido, cheque mensagens de aviso")

  res
}
