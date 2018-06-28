#' Construir arquivo de requisição SOAP
#'
#' Função cria texto XML para requisição SOAP
#'
#' @param metodo Nome do metodo 
#' @param serie código da série no Sistemas Gerados de Séries Temporais
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @return texto XML para requisição SOAP
#' @seealso
#' \code{\link{obter_bcws}}
#' @keywords internal
soap_request_xml <- function(metodo, serie, inicio, fim){
  metodo <- switch(metodo,
    "getValoresSeriesXML" = paste0(
        "<getValoresSeriesXML xmlns=\"http://publico.ws.casosdeuso.sgs.pec.bcb.gov.br\">
          <in0 xsi:type=\"SOAP-ENC:Array\" SOAP-ENC:arrayType=\"NA[1]\">
            ", paste0("\n<item>", serie, "</item>", collapse=""), "
          </in0>
          <in1 xsi:type=\"xsd:string\">", inicio, "</in1>
          <in2 xsi:type=\"xsd:string\">", fim, "</in2>
        </getValoresSeriesXML>"
    ),
    "getUltimoValorXML" = paste0(
      "<getUltimoValorXML xmlns=\"http://publico.ws.casosdeuso.sgs.pec.bcb.gov.br\">
         <in0 xsi:type=\"xsd:long\">", serie, "</in0>
       </getUltimoValorXML>"
    ),
    "getValor" = paste0(
    "<getValor xmlns=\"http://publico.ws.casosdeuso.sgs.pec.bcb.gov.br\">
       <in0 xsi:type=\"xsd:long\">", serie, "</in0>
       <in1 xsi:type=\"xsd:string\">", inicio, "</in1>
     </getValor>"
    ),
    "getValorEspecial" = paste0(
    "<getValorEspecial xmlns=\"http://publico.ws.casosdeuso.sgs.pec.bcb.gov.br\">
      <in0 xsi:type=\"xsd:long\">", serie, "</in0>
      <in1 xsi:type=\"xsd:string\">02/01/2012</in1>
      <in2 xsi:type=\"xsd:string\">a</in2>
    </getValorEspecial>"
    ))
  
  paste0("<?xml version=\"1.0\"?>
    <SOAP-ENV:Envelope xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">
      <SOAP-ENV:Body>
        ", metodo, "
      </SOAP-ENV:Body>
    </SOAP-ENV:Envelope>
    ")
}
