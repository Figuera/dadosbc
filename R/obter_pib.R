#' Realiza consulta de série de tempo do PIB
#'
#' Função consulta as séries de tempo do PIB no web service do BC
#'
#' @param tipo tipo de variavel
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @return Série de tempo desejada.
#' @seealso
#' \code{\link{obter_bcws}}
#' \code{\link{getValoresSeriesXML}}
#' @export
obter_pib <- function(inicio="01/01/1995",
                      fim=Sys.Date(),
                      tipo=c("encad","encaddess","mensal","mensalacum",
                           "corrente","percapita","IBGE")) {
  tipo   <- match.arg(tipo)
  codigo <- switch(tipo,
                   encad      = 22099,
                   encaddess  = 22109,
                   mensal     = 4380,
                   mensalacum = 4382,
                   corrente   = 1207,
                   percapita  = 1209,
                   IBGE         = FALSE)
  if(codigo){
    pib <- obter_bc(codigo, inicio=inicio, fim=fim)
  } else {
    temp <- tempfile()
    curl::curl_download("ftp://ftp.ibge.gov.br/Contas_Nacionais/Contas_Nacionais_Trimestrais/Tabelas_Completas/Tab_Compl_CNT.zip", temp)
    xls <- utils::unzip(temp)
    pib <- readxl::read_excel(xls)
    pib <- readxl::read_excel(xls, range=paste0("R5:R", nrow(pib)+1), col_names="PIB")
    pib <- zoo::zoo(pib, order.by=zoo::yearqtr(seq(from=1995, length.out=nrow(pib), by=1/4)))
    pib <- stats::window(pib, start=zoo::as.yearqtr(inicio, "%d/%m/%Y"),
                  end=zoo::as.yearqtr(fim, "%d/%m/%Y"))
    unlink(temp)
  }
  return(pib)
}

#' Realiza consulta de série de tempo do PIB em preços correntes
#'
#' Função é um cápsula em torno de \code{obter_pib}, que consulta a série de
#' PIB corrente anual.
#'
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @return Série de tempo do PIB corrente
#' @seealso
#' \code{\link{obter_pib}}
#' @export
obter_pibcorrente <- function(inicio = "01/01/1995",
                            fim    = Sys.Date()) {
  obter_pib(inicio, fim, "corrente")
}

#' Realiza consulta de série de tempo do PIB mensal
#'
#' Função é um cápsula em torno de \code{obter_pib}, que consulta a série de
#' PIB mensal gerado pelo BC.
#'
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @return Série de tempo do PIB mensal
#' @seealso
#' \code{\link{obter_pib}}
#' @export
obter_pibmensal <- function(inicio = "01/01/1995",
                            fim    = Sys.Date()) {
  obter_pib(inicio, fim, "mensal")
}

#' Realiza consulta de série de tempo do PIB mensal acumulado em 12 meses
#'
#' Função é um cápsula em torno de \code{obter_pib}, que consulta a série de
#' PIB mensal acumulado em 12 meses.
#'
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @return Série de tempo do PIB mensal acumulado em 12 meses
#' @seealso
#' \code{\link{obter_pib}}
#' @export
obter_pibmensalacum <- function(inicio = "01/01/1995",
                            fim    = Sys.Date()) {
  obter_pib(inicio, fim, "mensalacum")
}

#' Realiza consulta de série de tempo do PIB encadeado
#'
#' Função é um cápsula em torno de \code{obter_pib}, que consulta a série de
#' PIB em número índice.
#'
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @return Série de tempo do PIB encadeado.
#' @seealso
#' \code{\link{obter_pib}}
#' @export
obter_pibencad <- function(inicio = "01/01/1995",
                            fim    = Sys.Date()) {
  obter_pib(inicio, fim, "encad")
}

#' Realiza consulta de série de tempo do PIB encadeado dessazonalizado
#'
#' Função é um cápsula em torno de \code{obter_pib}, que consulta a série de
#' PIB encadeado dessazonalizado.
#'
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @return Série de tempo do PIB encadeado dessazonalizado
#' @seealso
#' \code{\link{obter_pib}}
#' @export
obter_pibencaddess <- function(inicio = "01/01/1995",
                            fim    = Sys.Date()) {
  obter_pib(inicio, fim, "encaddess")
}

#' Realiza consulta de série de tempo do PIB per capita
#'
#' Função é um cápsula em torno de \code{obter_pib}, que consulta a série de
#' PIB per capita.
#'
#' @param inicio data de inicío da consulta
#' @param fim data final da consulta
#' @return Série de tempo do PIB per capita
#' @seealso
#' \code{\link{obter_pib}}
#' @export
obter_pibpercapita <- function(inicio = "01/01/1995",
                            fim    = Sys.Date()) {
  obter_pib(inicio, fim, "percapita")
}
