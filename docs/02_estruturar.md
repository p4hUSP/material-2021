1. tidyr
--------

O `tidyr` é o pacote utilizado para estruturar os nossos bancos de
dados. Em geral, ele pode ser utilizado para **unir** (`unite`) e
**separar** (`separate`) colunas ou para **derreter** (`gather`) e
**esticar** (`spread`) as colunas.

Esse pacote é contruído com base no conceito de `tidy data`. Deixar o
seus dados `tidy` significa transformar a **estrutura** dos dados de tal
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

    Tente imaginar a unidade de observação de informações como PIP, desemprego, entre outras coisas.s

### 1.1 separate

-   [Download do
    Banco](https://github.com/p4hUSP/material-bio/raw/master/docs/data/ramen-ratings.zip)

Vamos começar abrindo o nosso banco. Repare que já estamos carregando o
pacote `tidyr`.

!!! warning " Instalando pacotes "

    Caso você não tenha o `tidyr` no seu computador, por favor, execute o código `install.packages('tidyr')`.

    library(readr)
    library(tidyr)

    banco <- read_csv('data/ramen-ratings.zip')

`separate()` é uma função do pacote `tidyr` que tem como objetivo
**separar** valores contidos em uma coluna. Às vezes, mais de uma
informação é agrupado dentro da mesma coluna. Você consegue identificar
no nosso banco de dados em qual coluna isso acontece?

!!! question " Funções para explorar dataframes "

    Tente utilizar funções para explorar o seu dataframe. Por exemplo, com `head()` conseguimos obter facilmente
    as primeiras linhas do nosso banco. Experiemente utilizar `table()` dessa vez já que o banco possuí uma quantidade 
    razoável de variáveis categóricas.

Você percebeu alguma coisa de estranho na variável `Top Ten`? O que? Se
você percebeu que na verdade ela contém duas variáveis, parabéns! :tada:
Agora temos um exemplo para usarmos a função `separate()`.

Como o `separate()` funciona? Tente executar o comando `?separate`. A
documentação do `tidyverse` tende a ser muito boa e normalmente teremos
uma boa explicação de como a função opera e de quais parâmetros
precisamos utilizar nela.

No caso, o `separate()` recebe (1) no primeiro parâmetro o banco de
dados, (2) no segundo, a coluna que desejamos separar, (3) na terceira o
nome das colunas que desejamos criar a partir da coluna informada no
segundo parâmetro, (4) o separador, ou seja, o padrão de caracteres que
serão utilizados para separar a coluna do segundo parâmetro nas colunas
específicadas no terceiro parâmetro. Isso pode parecer complicado, mas é
bem simples.

    separate(<dataframe>, <coluna_que_desejamos_separar>, <vetor_com_as_colunas_a_serem_criadas>, <separador>)

Vamos lá? 💪

    separate(banco, 'Top Ten', c('top_year', 'top_position'), '#', remove = FALSE)

Que tal dar um `View()` no seu banco agora?

    View(banco)

!!! warning " Salvando alterações "

    Nunca se esqueça de que o R não sabe que você deseja sobrescrever uma variável. Ao contrário do Stata, por exemplo, as alterações devem ser escritas sobre uma variável com `<-`. Caso contrário, o R irá apenas imprimir no console o resultado.

<br/>

    banco <- separate(banco, 'Top Ten', c('top_year', 'top_position'), '#', remove = FALSE)

Agora, podemos utilizar o `View()` ou o `head()` para verificar se deu
tudo certo.

### unite

A função `unite()` faz o oposto da `separate()`. O nome dela já entrega
o objetivo dela, que é **unir** ou **concatenar** colunas. Um dos
melhores exemplos de uso dessa função é unir as variáveis de `dia`,
`mês` e `ano`. Como não temos essa informação no nosso banco, vamos
adicionar algumas datas de mentira.

    set.seed(12345)

    banco$fake_dia <- replicate(nrow(banco), sample(1:28, 1))
    banco$fake_mes <- replicate(nrow(banco), sample(1:12, 1))
    banco$fake_ano <- replicate(nrow(banco), sample(2002:2016, 1))

Após executar o código acima, vamos prossguir com a função `unite()`.
Ela recebe (1) no primeiro parâmetro o banco de dados e (2) no segundo o
nome da **nova** variável. Em seguida, (3) podemos adicionar os nodemos
de todas as colunas que queremos concatenar (4) e, por fim, podemos
escolher o separador entre as colunas.

    banco <- unite(banco, "data", fake_ano, fake_mes, fake_dia, sep = "-")

Virique o resultado com a função `head()`.

Exercícios - Parte 1
--------------------

### Exercício - Exemplos de `unite` e `separate`

Para cada tabela abaixo diga se é necessário realizar um `unite()` ou um
`separate()`. Em seguinda, escreva o código que você utilizaria.

<br/>

<center>
<table>
<thead>
<tr class="header">
<th>CIDADE</th>
<th>PIB</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>“São José dos Campos - SP”</td>
<td>19.2</td>
</tr>
<tr class="even">
<td>“São Paulo - SP”</td>
<td>20</td>
</tr>
<tr class="odd">
<td>“Porto Alegre - RS”</td>
<td>8.2</td>
</tr>
</tbody>
</table>

</center>
<br/>

<center>
<table>
<thead>
<tr class="header">
<th>CIDADE</th>
<th>ALUNOS - ESCOLAS</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>São José dos Campos</td>
<td>19292 - 1882</td>
</tr>
<tr class="even">
<td>São Paulo</td>
<td>21828 - 102</td>
</tr>
<tr class="odd">
<td>Porto Alegre</td>
<td>102761 - 98</td>
</tr>
</tbody>
</table>

</center>
<br/>

Nesse último exemplo, imagine que estamos preparando um banco para
realizar uma pesquisa de endereços no Google.

<center>
<table>
<thead>
<tr class="header">
<th>CIDADE</th>
<th>RUA</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Ubatuba</td>
<td>Rua das Pedras</td>
</tr>
<tr class="even">
<td>Uberlândia</td>
<td>Avenida Minas Geras</td>
</tr>
<tr class="odd">
<td>Curitiba</td>
<td>Rua dos Cocais</td>
</tr>
</tbody>
</table>

</center>
Exercício - unite() e separate() na prática
-------------------------------------------

1.  Aplique a função `unite()` nas colunas `Style` e `Country`.

2.  Aplique a função `separate()` na coluna criada no exercício anterior

3. Gather e Spread
------------------

Você já ouviu falar em bancos no formato `wide` e `long`? No geral,
existem duas maneiras de organizar séries temporais. Quando optamos pelo
`wide`, o nosso banco é “esticado” horizontalmente; enquanto, quanto a
opção é pelo `long`, o banco é “esticado” verticalmente.

<center>
**PIB na China e no Brasil - Wide**

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
<td>10.2</td>
<td>11.2</td>
</tr>
<tr class="even">
<td>China</td>
<td>14.3</td>
<td>18.4</td>
</tr>
</tbody>
</table>

</center>
<center>
**PIB na China e no Brasil - Long**

</center>
<center>
<table>
<thead>
<tr class="header">
<th>País</th>
<th>Ano</th>
<th>PIB</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Brasil</td>
<td>2015</td>
<td>10.2</td>
</tr>
<tr class="even">
<td>Brasil</td>
<td>2016</td>
<td>11.2</td>
</tr>
<tr class="odd">
<td>China</td>
<td>2015</td>
<td>14.3</td>
</tr>
<tr class="even">
<td>China</td>
<td>2016</td>
<td>18.4</td>
</tr>
</tbody>
</table>

</center>
### 3.1. `gather()`

`gather()` é utilizado para derreter/agrupar as colunas dos nossos
bancos. Essa função recebe (1) o banco de dados, (2) o nome da variável
que está como nome das colunas, (3) o nome da variável que está nas
células, (4) os nomes das colunas em que iremos realizar a operação
**sem aspas**.

Ela pode parecer um pouco complicada de se utilizar do que o `unite()` e
o `separate()`, mas com um pouco de prática ela se torna bastante
intuitiva. Para quem está acostumado com o Excel, estamos fazendo uma
`tabela dinâmica` ou `pivot table`.

    tabela_wide <- tibble::tribble(
      ~País , ~`2015`, ~`2016`,
      'Brasil' , 10.2 , 11.2,
      'China' , 14.3 , 18.4,
    )

    gather(tabela_wide, key = 'ano', value = 'pib' ,`2015`, `2016`)

### 3.2. `spread()`

A função `spread()` realiza a operação inversa. Ela estica os nossos
dados horizontalmente. Mas isso não acaba com o formato `tidy` do nosso
banco? Sim, mas lembre-se que apenas estruturamos os nossos dados de
acordo com os princípios `tidy` porque a maior parte das funções esperam
esse tipo de estrutura! Isso não significa que essa é a melhor maneira
de, por exemplo, apresentar os nossos dados.

A função `spread()` recebe parâmetros bem parecidos como a `gather()`.
(1) Primeiro, precisamos fornecer o banco de dados; (2) em segundo
lugar, o nome da variável cujo os valores serão dispostos como colunas;
(3) por fim, a variável que fornecerá os valores para as células.

    tabela_long <- tibble::tribble(
      ~pais, ~ano, ~pib,
      'Brasil' , 2015 , 10.2,
      'Brasil' , 2016 , 11.2,
      'China' , 2015 , 14.3,
      'China' , 2016 , 18.4,
    )

    spread(tabela_long, ano, pib)

Exercícios - Parte 2
--------------------

### Exercício - `spread()`

Apresente a tabela abaixo de tal maneira que as UFs fiquem nas linhas e
o nivel de escolaridade esteja distribuído pelas colunas.

    tabela_escolaridade <- tibble::tribble(
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

Faça a mesma coisa agora com a tabela abaixo e deixe o país nas linhas.

    tabela_pais <- tibble::tribble(
      ~pais, ~ano, ~venda,
      'Brasil', 2014, 20.2,
      'Brasil', 2015, 29.2,
      'Brasil', 2016, 12.3,
      'Brasil', 2017, 14.3,
      'Colombia', 2014, 28.2,
      'Colombia', 2015, 19.2,
      'Colombia', 2016, 9.3,
      'Colombia', 2017, 30.3,
    )

### Exercício - `gather()`

Transforme as próximas tabelas em formato `tidy`.

-   Escolaridade:

<!-- -->

    tabela_pais_escol <- tibble::tribble(
      ~pais, ~`Jan`, ~`Fev`,
      'China', 92, 20.2,
      'EUA', 10.2, 42,
      'França', 72.2, 26,
      'Chile', 80.2, 90,
      'Japão', 19.1, 25,
    )

-   Mortes por arma de fogo

<!-- -->

    tabela_arma_fogo <- tibble::tribble(
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
Ele traz uma biblioteca poderasa de funções que nos permitem transformar
dados. Essa é a tarefa que você provavelmente passará mais tempo fazendo
já que nem sempre os dados estão limpos. Muitas vezes teremos que criar
variáveis ou extrair parte da informação presente em uma para que possas
rodar um modelo.

Quais são os verbos do `dplyr`? Obviamente, o pacote é extenso e possui
uma quantidade razoável de funções, mas queremos que você se atente,
agora, a três funções: `select()`, `filter()`, `mutate()`.

### 4.1. `select()`

O `select()` é capaz de selecionar colunas específicas do nosso banco de
dados.

Vamos carregar novamente o banco de *ramen*.

    library(dplyr)
    library(readr)

    banco <- read_csv('data/ramen-ratings.zip')

Digamos que seja mais relevante apresentar apenas as variáveis `Brand` e
`Stars`.

    select(banco, Brand, Stars)

Parece bem simples, não? Repare apenas que não colocamos aspas nos nomes
das variáveis dentro do `select()`. Isso é uma coisa um pouco ruim do
`tidyverse` já que às vezes precisamos colocar as aspas e às vezes não.
Fique atento para não errar isso e caso tenha dúvidas dê uma olhada na
documentação da função com `?select`.

### 4.2. `filter()`

Novamente, o nome da função já entrega o objetivo dela. `filter()`
filtra (dãã) as **observações** da nossa tabela. Digamos que você esteja
de viagem para o Japão e que queira olhar apenas as avaliações desse
país. Para obter esse resultado, você terá que fazer uso dos
`operadores lógicas`

!!! question " Operadores lógicos "

    Nós vimos na primeira aula que operadores lógicas são operações que retornam 
    necessariamente apenas dois resultados: verdadeiro e falso. A partir de agora, começaremos a
    utilizar eles cada vez mais. Então, se não estiver se sentindo confortável com o tema, volte
    para a primeira aula e reveja os exemplos.

Qual o operador lógico que testa igualdade? Se você pensou no `==`,
acertou! :tada: Agora, só precisamos colocá-lo dentro do `filter()` e
deixar que mágica aconteça. Assim como nas outras funções, (1) o
primeiro argumento é o banco de dados. (2) O segundo, no caso, é o teste
que queremos realisar . Repare que `filter()` irá retornar todos os
valores que tiverem como resposta para o teste o valor `TRUE`. Logo, no
exemplo abaixo, serão retornados todas as observações em que `Country`
seja igual a `Japan`.

    filter(banco, Country == 'Japan')
