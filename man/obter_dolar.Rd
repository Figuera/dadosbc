% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/obter_dolar.R
\name{obter_dolar}
\alias{obter_dolar}
\title{Realiza consulta de série de tempo do dolár}
\usage{
obter_dolar(inicio = "01/01/1995", fim = Sys.Date(), tipo = c("compra",
  "venda"), frequencia = c("diario", "mensal", "anual"))
}
\arguments{
\item{inicio}{data de inicío da consulta}

\item{fim}{data final da consulta}

\item{tipo}{tipo de taxa de câmbio ("compra" ou "venda")}

\item{frequencia}{frequencia da variavel ("diario", "mensal", "anual")}
}
\value{
Série de tempo das taxas de câmbio
}
\description{
Função consulta a série de taxas de câmbio no web service do BC.
}
\examples{
# Obter série de câmbio a partir de 01/01/1995
dolar <- obter_dolar()
# Obter série de venda de dolár a partir de 01/01/1995
dolar <- obter_dolar(tipo = "venda")
# Obter série mensal de câmbio durante o ano de 2010
dolar <- obter_dolar(inicio = 2010, fim = 2010, frequencia = "mensal")
}
\seealso{
\code{\link{obter_bcws}}
\code{\link{getValoresSeriesXML}}
}
