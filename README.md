dadosbc: Pacote R para consultar o Sistema Gerenciador de Séries de tempo do
Banco Central do Brasil
==========================================================================

Este pacote visa simplificar a comunicação entre o software estatístico R e o
Sistema Gerenciador de Séries Temporais do Banco Central do Brasil (SGS-BCB). O
sistema do Banco Central do Brasil disponibiliza diversas séries de tempo
atualizadas com dados brasileiros, pacote, ao se comunicar diretamente com o Web
Service desse sistema, disponibiliza os mesmos dados no R.

Para mais informações sobre o SGS-BCB ver 
[no site do sistema](http://www4.bcb.gov.br/pec/series/port/aviso.asp).

dadosbc - Instalação
--------------------------------------------------------------------------

É possível instalar a versão estável do pacote pelo CRAN, utilizando o comando:

```R
install.packages("dadosbc")
```

Também é possível instalar a versão a versão de denselvolvimento,
utilizando os seguintes comandos:

```R
install.packages("devtools")
library(devtools)
install_github("Figuera/dadosbc")
```

Como realizar a consulta
--------------------------------------------------------------------------

Para realizar a consulta é preciso utilizar a função `obter_bc`, 
disponibilizada neste pacote, e definir 3 argumentos:

- Código da série: É o código da série de tempo desejada dentro do SGS. É
  possível verificar a lista de séries de tempo
  [aqui](https://www3.bcb.gov.br/sgspub/localizarseries/localizarSeries.do?method=prepararTelaLocalizarSeries)
- Data inicial: A data inicial do período de consulta desejado. Caso não seja
  informado será utilizado como padrão o dia 01/01/1995, período em que as
  séries monetárias brasileiras se tornam mais confiáveis. Note que caso data
  inicial requisitada for mais antiga que as disponíveis a consulta falhará.
- Data final: A data final do período de consulta desejado. Caso não seja
  informado será utilizado como padrão o dia da consulta.

Como exemplo podemos consultar a série de nível de emprego com carteira, ou seja
a série de número *25239* do SGS. Para consultar a série de 1995 até hoje basta
executar o seguinte comando no R:

```{r}
emprego <- obter_bc(codigo = 25239, inicio = 2002, fim = 2010)
```

Sendo agora simples visualizar a informações através de gráficos por meio das
funções básicas do R, como:

```{r}
ts.plot(emprego)
```

Ou utilizando o popular pacote de criação de imagens, o ggplot2:

```{r}
library(ggplot2)
autoplot(emprego)
```

Consultas rápidas
--------------------------------------------------------------------------

Além da função genérica de consulta `obter_bc` o pacote disponiliza algumas
funções especializadas para a consulta de séries importantes, são elas: o PIB, o
IPCA, o Salário Mínimo e a taxa de câmbio. Estas funções especializadas
dispensam que seja conhecido o número da série do SGS, além de automatizar 
modificações eventualmente necessárias na série, como a mudança de frequência
(entre diário, mensal e anual por exemplo) e a mudança de unidade (entre real e
nominal, no caso do salário mínimo).

Para consultar esses séries basta executar o seguinte comando:

```{r}
ipca  <- obter_ipca(inicio = 2015, fim = 2017)
sm    <- obter_sm(inicio = 2015, fim = 2017, frequencia = "mensal")
dolar <- obter_dolar(inicio = 2015, fim = 2017, frequencia = "mensal")
```

Para mais informações sobre estas funções consulte `help(obter_ipca)`, 
`help(obter_sm)` e `help(obter_dolar)`. Note também que as datas
iniciais e finais não precisam estar no formato completo, um ano ("YYYY") ou um
mes/ano ("mm/YYYY") são o suficiente.

 Consulta PIB
--------------------------------------------------------------------------

Como dito na seção anterior, o PIB também pode ser consultado por função
específica, mas diferentemente dos exemplos anteriores exitem seis funções
diferentes para se consultar seis variantes diferentes do PIB, são elas:

- `obter_pibencad` - Consulta o PIB em formato de número índice.
- `obter_pibencaddess` - Consulta o PIB Dessazonalizado em formato de número índice.
- `obter_pibcorrente` - Consulta o PIB anual em valores correntes.
- `obter_pibpercapita` - Consulta o PIB anual per capita.
- `obter_pibmensal` - Consulta o PIB mensal, como calculado pelo BCB.
- `obter_pibmensalacum` - Consulta o PIB mensal acumulado em 12 meses, como calculado pelo BCB.

Alternativamente é possível usar o função genérica `obter_pib` e definir o
parâmetro `tipo` para obter o mesmo resultado. Exemplos:

```{r}
pibencad     <- obter_pib(inicio = 2010, tipo = "encad") #O mesmo que obter_pibencad(inicio = 2010)
pibcorrente  <- obter_pib(inicio = 2010, tipo = "corrente") #O mesmo que obter_pibcorrente(inicio = 2010)
pibpercapita <- obter_pib(inicio = 2010, tipo = "percapita") #O mesmo que obter_pibpercapita(inicio = 2010)
```

A lista completa de tipos é: "encad", "mensal", "mensalacum", "corrente",
"mensalacum" e "percapita".

Problemas ou pedidos
--------------------------------------------------------------------------

Este é um pacote em desenvolvimento, caso seja encontrado algum problema em seu
funcionamento, ou ainda, caso houver sugestões de como melhorá-lo, não existe 
em abrir um novo [*Issue*](https://github.com/Figuera/dadosbc/issues) ou um novo
[*Pull Request*](https://github.com/Figuera/dadosbc/pulls).
