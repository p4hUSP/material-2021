# Estruturando Banco

Hoje, vamos trabalhar com um banco de dados sobre *doenças cardíacas*. O
dado está disponível [UCI - Machine Learning
Repository](https://archive.ics.uci.edu/ml/datasets/Heart+Disease) e no
[Kaggle](https://www.kaggle.com/ronitf/heart-disease-uci/downloads/heart-disease-uci.zip/1).
Os responsáveis pelo estudo foram as seguintes entidades:

1.  Hungarian Institute of Cardiology. Budapest: Andras Janosi, M.D.
2.  University Hospital, Zurich, Switzerland: William Steinbrunn, M.D.
3.  University Hospital, Basel, Switzerland: Matthias Pfisterer, M.D.
4.  V.A. Medical Center, Long Beach and Cleveland Clinic Foundation:
    Robert Detrano, M.D., Ph.D.

A diagnóstico de doença cardíaca foi feita a partir de uma angiografia.
Se houvesse estreitamento maior do que 50% para pelo menos um vaso
sanguíneo principal, o paciente foi classificado como portador de doença
cardíaca. Caso contrário, o paciente não foi diagnosticado com a doença.

<table>
<thead>
<tr class="header">
<th>Variável</th>
<th>Descrição</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>age_sex</td>
<td>Idade - Sexo</td>
</tr>
<tr class="even">
<td>cp</td>
<td>Tipo de dor no peito</td>
</tr>
<tr class="odd">
<td>trestbps</td>
<td>Pressão sanguínea (mm Hg) em descanso</td>
</tr>
<tr class="even">
<td>chol</td>
<td>Colesterol (mg/dl)</td>
</tr>
<tr class="odd">
<td>fbs</td>
<td>Açúcar no sangue em jejum maior do que 120mg/dl (1 = Sim, 0 = Não)</td>
</tr>
<tr class="even">
<td>restecg</td>
<td>Resultados eletrocardiográficos em repouso</td>
</tr>
<tr class="odd">
<td>thalach</td>
<td>Maior ritmo cardíaco atingido</td>
</tr>
<tr class="even">
<td>exang</td>
<td>Angina induzida por exercício</td>
</tr>
<tr class="odd">
<td>ca</td>
<td>Número de vasos principais coloridos por <em>flourosopy</em></td>
</tr>
<tr class="even">
<td>target</td>
<td>Diagnóstico de doença cardíaca (1 = Sim, 0 = Não)</td>
</tr>
</tbody>
</table>

Vamos começar, então?

-   [Download do
    Banco](https://github.com/p4hUSP/material-bio/raw/master/docs/data/heart_modificado.xlsx)

O banco hoje está em formato Excel. Você sabe qual função e pacote
utilizamos para abrir esse arquivo?

    library(<pacote>)

    banco <- <funcao>(<caminho_do_arquivo>)

1. tidyr
--------

O `tidyr` é o pacote utilizado para estruturar os nossos bancos de
dados. Em geral, ele pode ser utilizado para **unir** (`unite`) e
**separar** (`separate`) colunas ou para **derreter** (`gather`) e
**esticar** (`spread`) as colunas.

Esse pacote é construído com base no conceito de `tidy data`. Deixar os
seus dados `tidy` significa transformar a **estrutura** deles de tal
maneira que tenhamos observações nas linhas, variáveis nas colunas e
valores nas células. Em geral, esperamos também que um banco `tidy`
contenha apenas uma unidade de observação, granularidade, etc.

![](imgs/r_tidy_data.png)
<center>
Ilustração do Tidy Data (Fonte:
<a href="http://statseducation.com" class="uri">http://statseducation.com</a>)
</center>
!!! question " O que é unidade de observação / granularidade? "

    Trata-se da unidade contida nas linhas do seu banco. Por exemplo, se montarmos um banco de dados com 
    informações sobre __pessoas__ (altura, idade, peso, etc.) em cada linha teremos __pessoas__ como unidade de 
    observação.
    Qual a unidade de observação do nosso banco?

### 1.1 separate()

!!! warning " Instalando pacotes "

    Caso você não tenha o `tidyr` ou o `tibble`no seu computador, por favor, execute o código `install.packages(c('tidyr', 'tibble'))`.

`separate()` é uma função do pacote `tidyr` que tem como objetivo
**separar** valores contidos em uma coluna. Às vezes, mais de uma
informação é agrupado dentro da mesma variável. Repare no exemplo
abaixo.

    exemplo_separete <- tibble::tribble(
      ~ CIDADE , ~MORTALIDADE,
      'São José dos Campos - SP', 80,
      'Porto Alegre - RS', 100,
      'Brasília - DF', 81
    )

    exemplo_separete

Qual variável contém mais de uma informação? Por mais que talvez você
tenha o costume de agrupar a sua cidade à unidade federativa dela, esses
dois valores dizem respeito a qualidades diferentes da nossa obervação.
Imagine que o banco se estendesse para todas as cidades brasileiras.
Como faríamos para identificar as unidades federativas com maior média
de mortalidade?

Como aplicar a função `separate()`? Antes de tudo, tente executar o
comando `?separate`. A documentação do `tidyr` tende a ser muito boa e
normalmente teremos uma boa explicação de como a função opera e de quais
parâmetros precisamos utilizar nela.

No caso, o `separate()` recebe (1) no primeiro parâmetro o banco de
dados, (2) no segundo, a coluna que desejamos separar, (3) na terceira o
nome das colunas que desejamos criar a partir da coluna informada no
segundo parâmetro, (4) o separador, ou seja, o padrão de caracteres que
serão utilizados para separar a coluna do segundo parâmetro nas colunas
especificadas no terceiro parâmetro. Isso pode parecer complicado, mas é
bem simples.

    separate(<dataframe>, <coluna_que_desejamos_separar>, <vetor_com_as_colunas_a_serem_criadas>, <separador>)

Tente fazer sozinho.

<br/>

<br/>

-   **Reposta**:

<!-- -->

    separate(exemplo_separete, 'CIDADE', c('CIDADE', 'UF'), '-')

#### 1.1.1. Aplicando no nosso banco

Você consegue descobrir qual variável no nosso banco tem esse problema?

!!! question " Funções para explorar dataframes "

    Tente utilizar funções para explorar o seu dataframe. Por exemplo, com `head()` conseguimos obter facilmente
    as primeiras linhas do nosso banco.

Você percebeu alguma coisa de estranho na variável `age_sex`? O que?

`age_sex` contém dois tipos de informações diferentes. De um lado, temos
a idade da pessoa. Do outro, temos o sexo dessa pessoa. Novamente,
precisamos separar essas **duas** informações em **duas** variáveis para
que possamos prosseguir com a nossa análise.

Vamos lá? Agora é a sua vez. Como precisamos fazer para separar as duas
variáveis? 💪

PS: Não se preocupe com o `remove = FALSE`. Utilizamos esse parâmetro
apenas para manter a variável antiga e sermos capazes de validar o nosso
resultado.

    separate(<banco>, <variavel>, <vetor>, <sep>, remove = FALSE)

Que tal dar um `View()` no seu banco agora?

    View(banco)

!!! warning " Salvando alterações "

    Nunca se esqueça de que o R não sabe que você deseja sobrescrever uma variável. Ao contrário do Stata, por exemplo, as alterações devem ser escritas sobre uma variável com `<-`. Caso contrário, o R irá apenas imprimir no console o resultado.

<br/>

Agora, podemos utilizar o `View()` ou o `head()` para verificar se deu
tudo certo.

### 1.2. `unite`

A função `unite()` tem o comportamento inverso `separate()`. Nós a
utilizamos para unir valores que fazem mais sentido juntos do que
separados. Repare no exemplo abaixo. O que você faria para obter em uma
única variável uma informação mais precisa?

    exemplo_unite <- tibble::tribble(
      ~ID,~DIA, ~MES, ~ANO, ~DOSE_REMEDIO, ~RESULTADO,
      1, 14, 8, 2018, 1, 0,
      1, 15, 8, 2018, 2, 0,
      2, 9, 7, 2018, 1 ,0,
      2, 10, 7, 2018, 2, 0,
      2, 11, 7, 2018, 3, 1
    )

    exemplo_unite

Após executar o código acima, vamos prosseguir com a função `unite()`.
Ela recebe (1) no primeiro parâmetro o banco de dados e (2) no segundo o
nome da **nova** variável. Em seguida, (3) adicionamos todas as colunas
que queremos concatenar (4) e, por fim, podemos escolher o separador
entre as colunas.

    unite(<banco>, <nome_da_nova_variavel>, sep = '<separador>')

Vamos tentar sozinho primeiro?

<br/>

<br/>

-   **Resposta**:

<!-- -->

    banco <- unite(exemplo_unite, "DATA", ANO, MES, DIA, sep = "-")

Verifique o resultado com a função `head()`.

#### 1.2.1. Aplicando no nosso banco

Que tal arrumar, agora, o nosso banco de dados também? Lembre-se que é
possível utilizar a as funções `head()`, `str()`, entre outras para ter
uma ideia geral da estrutura do nosso `dataframe`.

Provavelmente, você reparou que existem três variáveis que, na verdade,
fornam uma única: `birth_day`, `birth_month` e `birth_year`. Que tal
tentar uni-las com a função `separate()`?

2. Exercícios - Parte 1
-----------------------

Nós acabamos de aprender a **estruturar** o nosso banco no que diz
respeito a **unir** e **separar** variáveis. Vamos praticar mais um
pouco?

### 2.1. Exercício - Exemplos de `unite` e `separate`

Para cada tabela abaixo (1) diga se é necessário realizar um `unite()`
ou um `separate()` e (2) escreva o código que corrija esse problema.

-   **Item I**:

<!-- -->

    ex2_1_1 <- tibble::tribble(
      ~ANO, ~RAZAO_DE_HOMICIDIO,
      2014, '1200293 / 102000000',
      2015, '201992 / 102929222',
      2016, '203918 / 175999271',
      2017, '2901827 / 228191900',
      2018, '201928 / 201928238', 
    )

-   **Item II**:

<!-- -->

    ex_2_1_2 <- tibble::tribble(
      ~NOME, ~LOGRADOUR, ~NUMERO, ~COMPLEMENTO,
      'Lyandra', 'Rua Ademar de Barros', 20, 'APT 28',
      'Monica', 'Avenida São Pedro', 30, 'BLOCO A',
      'Luis', 'Rua do Lago', 22, 'Portão do lado esquerdo',
      'Isaac', 'Avenida Paulista', 22, 'APT 102',
      'Sônia', 'Rua Brigadeiro', 982, 'APT 283'
    )

-   **Item III**:

<!-- -->

    ex_2_1_3 <- tibble::tribble(
      ~ID, ~DIA, ~MES, ~ANO, ~ALTURA_PESO,
      1, 10, 2, 1998, '180 - 340',
      2, 11, 2, 1998, '190 - 200',
      3, 20, 3, 1998, '188 - 176',
      2, 30, 5, 1998, '192 - 180'
    )

Parabéns! :tada: :tada: :tada:

3. Gather e Spread
------------------

Você já ouviu falar em bancos no formato `wide` e `long`?

<center>
**Mortalidade na China e no Brasil - Wide**

</center>
<center>
<table>
<thead>
<tr class="header">
<th>País</th>
<th>2015</th>
<th>2016</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Brasil</td>
<td>12</td>
<td>12.2</td>
</tr>
<tr class="even">
<td>China</td>
<td>20</td>
<td>30</td>
</tr>
</tbody>
</table>

</center>
<center>
**Mortalidade na China e no Brasil - Long**

</center>
<center>
<table>
<thead>
<tr class="header">
<th>País</th>
<th>Ano</th>
<th>Mortalidade</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Brasil</td>
<td>2015</td>
<td>12</td>
</tr>
<tr class="even">
<td>Brasil</td>
<td>2016</td>
<td>12.2</td>
</tr>
<tr class="odd">
<td>China</td>
<td>2015</td>
<td>20</td>
</tr>
<tr class="even">
<td>China</td>
<td>2016</td>
<td>30</td>
</tr>
</tbody>
</table>

</center>
Qual a diferença entre os dois bancos? Quais deles está no formato
`tidy`? Se possível escreva ou tente explicar em voz alta.

<br/>

Como o primeiro banco não contém apenas uma obervação por linha, ele
**não** é `tidy`. Você concorda que as tomadas de dados sobre
mortalidade sobre dois anos não podem ocorrer simultaneamente no mesmo
ano? Além disso, `2015` e `2016` estão ocupando a posição de variáveis,
mas elas na verdade são valores de uma outra variável? Você sabe dizer
qual?

O exemplo de banco `tidy` é o segundo. Nele, temos as variáveis
claramente denominadas no cabeçalho do nosso banco. `País` é uma
variável, assim como `Ano` e `Mortalidade`. E cada linha possui uma
única observação.

Que fique bem claro: `tidy` não é uma definição de qualidade do banco.
Apenas tentamos *estruturar* a nossa tabela nesse formato porque isso
torna mais fácil a interação com outras funções (ex. `dplyr`, `ggplot`,
etc.).

### 3.1. `gather()`

`gather()` é utilizado para derreter/agrupar as colunas dos nossos
bancos. Pensando no exemplo anterior, essa função transforma o nosso
banco *wide* em um banco *long*.

    tabela_wide <- tibble::tribble(
      ~País , ~`2015`, ~`2016`,
      'Brasil' , 10.2 , 11.2,
      'China' , 14.3 , 18.4,
    )

    tabela_wide

`gather()` recebe (1) o banco de dados, (2) o nome da variável (`key`)
que está como nome das colunas, (3) o nome da variável que está nas
células, (4) os nomes das colunas em que iremos realizar a operação
**sem aspas**.

    gather(<banco>, <key>, <value>, <VAR1>, <VAR2>, <VARn>)

Dado isso, qual código devemos utilizar para realizar a transformação em
`tabela_wide`.

<br/>

-   **Resposta**:

<!-- -->

    gather(tabela_wide, key = 'ano', value = 'mortalidade' ,`2015`, `2016`)

#### 3.1.1. Aplicando

Como o nosso banco não possui esse problema, vamos fingir que decidimos
realizar uma segunda coleta de dados e queremos avaliar a evolução de
doenças cardíacas nossos pacientes após 1 ano. Porém, o seu estagiário
era preguiçoso e ao invés de estruturar o seu banco no formato `tidy`
ele (1) alterou o nome da coluna `target` para `target2018` e (2) criou
uma coluna `target2019` para os novos resultados

    ex3_1_1 <- tibble::tribble(
      ~ID, ~target2018, ~target2019,
      1, 0, 0,
      2, 1, 1,
      3, 1, 1,
      4, 1, 1,
      5, 1, 0,
    )

    ex3_1_1

Qual código seria utilizado para deixar essa tabela `tidy`?

### 3.2. `spread()`

`spread()` realiza a operação inversa do `gather()`. Ela estica os
nossos dados horizontalmente. Mas isso não acaba com o formato `tidy` do
nosso banco? Sim, mas lembre-se que apenas estruturamos os nossos dados
de acordo com os princípios do `tidy data` porque a maior parte das
funções esperam esse tipo de estrutura! Isso não significa que ao
apresentar uma tabela para alguém ela deva estar no formato `tidy`. Ela
simplesmente deve estar na maneira mais intuitiva de ler.

    tabela_long <- tibble::tribble(
      ~pais, ~ano, ~mortalidade,
      'Brasil' , 2015 , 10.2,
      'Brasil' , 2016 , 11.2,
      'China' , 2015 , 14.3,
      'China' , 2016 , 18.4,
    )

    tabela_long

A função `spread()` recebe os seguintes parâmetros: (1) Primeiro,
precisamos fornecer o banco de dados; (2) em segundo lugar, o nome da
variável cujo os valores serão dispostos como colunas; (3) por fim, a
variável que fornecerá os valores para as células. São os mesmos
parâmetros da função `gather()`!

    spread(<banco>, <key>, <value>)

Como você faria para deixar o país na linha e os anos no cabeçalho com
os valores de mortalidade ocupando o centro da tabela?

<br/>

<br/>

-   **Resposta**:

<!-- -->

    spread(tabela_long, ano, pib)

#### 3.2.1. Aplicando no nosso banco

Por favor, execute o código abaixo. Não se preocupe em entender como ele
funciona. Nós veremos isso na próxima aula. Tenha apenas em mente que
ele retorna a quantidade de observações diagnosticadas com doença
cardíaca entre homens e mulheres.

    ex3_1_1 <- banco %>% 
      group_by(sex, target) %>%
      summarise(n = n())

    ex3_1_1

Será que essa é a melhor maneira de visualizar esse resultado? Ainda que
você consiga extrair alguma informação, imagine se tivéssemos 3 ou 4
categorias em cada variável. Provavelmente, não seria tão fácil. Uma
maneira elegante de resolver esse problema é com a função `spread()`.
Como você aplicaria essa função para que a variável `target` fique no
cabeçalho?

4. Exercícios - Parte 2
-----------------------

### 4.1. Exercício - `spread()`

Apresente a tabela abaixo de tal maneira que as UFs fiquem nas linhas e
o nível de escolaridade esteja distribuído pelas colunas.

-   **Item I**:

<!-- -->

    ex_4_1_1 <- tibble::tribble(
      ~UF, ~mes, ~nivel_escolaridade,
      'SP', 'Jan', 20.2,
      'SP', 'Fev', 29.2,
      'SP', 'Mar', 12.3,
      'SP', 'Abr', 14.3,
      'RJ', 'Jan', 28.2,
      'RJ', 'Fev', 19.2,
      'RJ', 'Mar', 9.3,
      'RJ', 'Abr', 30.3,
    )

-   **Item II**:

<!-- -->

    ex_4_1_2 <- tibble::tribble(
      ~pais, ~ano, ~venda,
      'Brasil', 2014, 20.2,
      'Brasil', 2015, 29.2,
      'Brasil', 2016, 12.3,
      'Brasil', 2017, 14.3,
      'Colômbia', 2014, 28.2,
      'Colômbia', 2015, 19.2,
      'Colômbia', 2016, 9.3,
      'Colômbia', 2017, 30.3,
    )

### 4.2. Exercício - `gather()`

Transforme as próximas tabelas em `tidy data`.

-   **Item I**: Escolaridade:

<!-- -->

    ex_4_2_1 <- tibble::tribble(
      ~pais, ~`Jan`, ~`Fev`,
      'China', 92, 20.2,
      'EUA', 10.2, 42,
      'França', 72.2, 26,
      'Chile', 80.2, 90,
      'Japão', 19.1, 25,
    )

-   **Item II**: Mortes por arma de fogo

<!-- -->

    ex_4_2_2 <- tibble::tribble(
      ~UF, ~`2015`, ~`2016`,
      'SP', 92, 20.2,
      'RJ', 10.2, 42,
      'RS', 72.2, 26,
      'CO', 80.2, 90,
      'PE', 19.1, 25,
    )

4. `dplyr`
----------

Dentre os pacotes mais importantes do `tidyverse`, o `dplyr` se destaca.
Ele traz uma biblioteca pode rasa de funções que nos permitem
transformar dados. Essa é a tarefa que você provavelmente passará mais
tempo fazendo já que nem sempre os dados estão limpos. Muitas vezes
teremos que criar variáveis ou extrair parte da informação presente em
uma antes de rodarmos um modelo.

Quais são os verbos do `dplyr`? Obviamente, o pacote é extenso e possui
uma quantidade razoável de funções, mas queremos que você se atente,
agora, a três funções: `select()`, `filter()`, `mutate()`.

### 4.1. `select()`

O `select()` é capaz de selecionar colunas específicas do nosso banco de
dados. O uso dela é bem simples e precisamos apenas escrever as
variáveis que desejamos selecionar **sem aspas**. Caso você deseje
**excluir** uma variável, acrescente um `-` antes do no nome. Assim como
nas funções do `tidyr` (`gather()`, `spread()`, etc.), informamos o
banco de dados no primeiro parâmetro de nossa função.

    select(<banco>, <VAR1>, <VAR2>, -<VAR3>)

Repare que antes de `<VAR3>` nós adicionamos um `-`. Isso significa que
queremos excluir essa coluna no banco

Imagine que após muita pesquisa, você tenha descoberto que a melhor
variável para *prever* doenças cardíacas seja idade (`age`). Como você
faria para selecionar apenas `target` e `age`?

<br/>

<br/>

-   **Resposta**:

<!-- -->

    select(banco, age, target)

Agora, imagine que tenha sido provado que sexo é irrelevante. Como você
faria para excluir essa variável do banco?

<br/>

<br/>

    select(banco, -sex)

### 4.2. `filter()`

Novamente, o nome da função já entrega o objetivo dela. `filter()`
filtra (dãã) as **observações** da nossa tabela por meio de
`operações booleanas`.

!!! question " Operadores lógicos "

    Nós vimos na primeira aula que operadores lógicas são operações que retornam 
    necessariamente apenas dois resultados: verdadeiro e falso. A partir de agora, começaremos a
    utilizar eles cada vez mais. Então, se não estiver se sentindo confortável com o tema, volte
    para a primeira aula e reveja os exemplos.

Como ela funciona? Simples, você apenas precisa realizar um teste de
verdadeiro e falso a partir de uma variável do seu banco.

    filter(<banco>, <operacao_booleana>)

Repare no banco abaixo. Como você faria para selecionar as observações
de `SP`?

    exemplo_filter <- tibble::tribble(
      ~UF, ~`2015`, ~`2016`,
      'SP', 92, 20.2,
      'RJ', 10.2, 42,
      'RS', 72.2, 26,
      'CO', 80.2, 90,
      'PE', 19.1, 25,
    )

    exemplo_filter

Qual o operador lógico que testa igualdade? Se você pensou no `==`,
acertou! :tada: Agora, só precisamos colocá-lo dentro do `filter()` e
deixar que mágica aconteça.

<br/>

<br/>

-   **Resposta**:

<!-- -->

    filter(exemplo_filter, UF == 'SP')

### 4.3. `mutate()`

`mutate()` nos permite transformar e criar colunas em nossa tabela de
maneira rápida e intuitiva. Repare na tabela abaixo.

    exemplo_mutate <- tibble::tribble(
      ~UF, ~mes, ~total, ~homi
      'SP', 'Jan', 20.2, 3
      'SP', 'Fev', 29.2, 4
      'SP', 'Mar', 12.3, 6
      'SP', 'Abr', 14.3, 4
      'RJ', 'Jan', 28.2, 3
      'RJ', 'Fev', 19.2, 3
      'RJ', 'Mar', 9.3, 10
      'RJ', 'Abr', 30.3, 20
    )

Sento `total` o total de mortes registradas naquele mês e `homi` valor
absoluto de homicídios, é possível retirar a taxa de homicídios entre
todas as outras mortes realizando com a operação de divisão.

    mutate(<banco>,
           <variavel> = <operacao>)

Novamente, o banco de dados é fornecido como primeiro parâmetro. A
diferença é que dessa vez iremos fazer referências a variáveis
(`<variavel>`) dentro da função `mutate()` para alterá-las. Em
`<operacoes>`, você pode fazer referência a outras variáveis do banco ou
até mesmo de outros objetos para realizar a sua conta.

Você consegue imaginar como escrever o código acima para retirar a taxa
de homicídios?
