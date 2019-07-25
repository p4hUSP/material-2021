# Visualização

As visualizações gráficas são muito importantes para transmitir
informações. Podemos dizer até que ela é fundamental para análise de
dados, nos ajudando a responder questões, tomar decisões, contar
histórias e até mesmo inspirar. Veremos não só como fazer estas
visualizações, mas também a entender quando elas podem ser necessárias.

Além disso, vamos aproveitar para rever alguns tópicos de aulas passadas
porém utilizando um banco de dados sobre diabetes no povo Pima, nativos
dos EUA e que vivem na parte sul do estado de Arizona. Para ter mais
contexto do dado que iremos trabalhar, o povo Pima foram foco de estudos
devido à alta presença de diabetes tipo 2, causado sobretudo, pela
mudança da agricultura tradicional para comidas processadas.

O banco de dados possuí 768 mulheres com 8 variáveis:

<table>
<colgroup>
<col style="width: 73%" />
<col style="width: 26%" />
</colgroup>
<thead>
<tr class="header">
<th>Variável</th>
<th>Descrição</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Pregnancies</td>
<td>Número de gravidezes</td>
</tr>
<tr class="even">
<td>Glucose</td>
<td>Concetração de plasma glucose</td>
</tr>
<tr class="odd">
<td>BloodPressure</td>
<td>Pressão Sanguínea (mm Hg)</td>
</tr>
<tr class="even">
<td>SkinThickness</td>
<td>Espessura da dobra da pele do tríceps (mm)</td>
</tr>
<tr class="odd">
<td>Insulin</td>
<td>Insulina (mu U/ml)</td>
</tr>
<tr class="even">
<td>BMI</td>
<td>Indíce de Massa corpórea (IMC)</td>
</tr>
<tr class="odd">
<td>DiabetesPedigreeFunction</td>
<td>Diabetes pedigree function</td>
</tr>
<tr class="even">
<td>Age</td>
<td>Idade (anos)</td>
</tr>
<tr class="odd">
<td>Outcome</td>
<td>Variável que indica de a pessoa tem ou não diabetes (1 = Sim, 0 = Não)</td>
</tr>
</tbody>
</table>

Vamos aprender a fazer visualizacões?

-   [Download do
    Banco](https://github.com/p4hUSP/material-bio/raw/master/docs/data/diabetes2.csv)

Sempre é bom recaptular. Para abrir este banco vamos precisar usar qual
pacote?

    library(<pacote>)

    banco <- read_<nome>(<caminho_do_arquivo>)

1. ggplot2
----------

Antes de irmos diretamente para as visualizações vamos habilitar alguns
pacotes:

    library(dplyr)

    library(ggplot2)

    #install.packages("corrplot")
    library(corrplot)

Habilitamos dois pacotes novos, o `ggplot2` e o `corrplot`. O primeiro
deles é o principal pacote para visualizações no R, possibilitando criar
gráficos exatamente da forma que você quiser, sobretudo, porque ele
funciona em um esquema de layers.

O segundo pacote é feito para visualizarmos correlações entre variáveis.
Apesar dele não fazer parte do `ggplot2`, é uma otíma alternativa para
matrizes de correlação.

Mas antes vamos tratar de entender a nossa base de dados e fazer algumas
manipulações nela.

A primeira coisa que iremos fazer é aplicar a função `glimpse()` do
`dplyr`. Elas nos possibilita ver as nossas variáveis sem precisar abrir
o banco inteiro.

    glimpse(banco)

Pode-se notar que todas as variáveis parecem ok, apenas uma que precisa
ser alterada, qual seria?

<br/>

Se você pensou em Outcome, esta correta(o)! Temos que transformar esta
variável em fator (categórica), vamos lá?

### Exercício

1.  Transforme a variável `Outcome` em fator.

<!-- -->

    banco <- banco %>% 
      mutate(Outcome = factor(Outcome, levels = c(0, 1), labels = c("Nao", "Sim")))

Vamos agora criar uma variável que categoriza as idades em grupos? E que
tal também categorizar o BMI?

    banco <- banco %>% 
      mutate(categoria_idade = case_when(Age %in% c(21:34) ~ "21-34",
                                         Age %in% c(35:49) ~ "35-49",
                                         Age >= 50 ~ "50 ou mais"),
             categoria_bmi = case_when(BMI < 18.5 ~ "Underweight",
                                       BMI >= 18.5 & BMI < 25 ~ "Normal weight",
                                       BMI >= 25 & BMI < 30 ~ "Overweight",
                                       BMI >= 30 & BMI < 35 ~ "Obesity Class 1",
                                       BMI >= 35 & BMI < 40  ~ "Obesity Class 2",
                                       BMI >= 40 ~ "Extreme Obesity Class 3"),
             categoria_idade = factor(categoria_idade, levels = c("21-34", "35-49", "50 ou mais")),
             categoria_bmi = factor(categoria_bmi, levels = c("Underweight", "Normal weight", "Overweight", "Obesity Class 1",
                                    "Obesity Class 2", "Extreme Obesity Class 3")))

!!! warning " Instalando pacotes "

    Preste atenção se você escreveu corretamente e não esqueceu da vírgula.

Agora que alteramos e criamos algumas variáveis vamos conhecer o
`ggplot2`.

ggplot2
-------

O ggplot2 é um pacote baseado no que se chamou Grammar of Graphics (por
isso gg antes do plot2), que nada mais é do que uma estrutura
(framework) para realização de gráficos, que nós também chamamos de
“plot”. Além disso, o Grammar of Graphics tem o seguinte principio:

!!! question " Layers "

    Gráficos são construídos com diferentes **layers**

Mas o que são **layers**? Layers são elementos (ou componentes)
gramáticais utilizados para fazer um plot. Estes componentes são
importantes para determinar a representação dos dados. Como o Hadley
Wickham apontou em um artigo chamado “A layered grammar of graphics”
(2010), a associação destes layers com uma certa grámatica auxilia o
usuário em atualizar e contruir gráficos com uma facilidade maior.

Os elementos gramáticais que temos no `ggplot2` são:

1.  Data - O dado que será plotado, mapeando as variáveis de interesse.

2.  Aesthetics - A escala em que o dado será plotado, sinalizando os
    eixos x e y, cor, tamanho, preenchimento e etc.

3.  Geom - Estrutura que será utilizada nos seus dados, como por
    exemplo, gráfico de dispersão, linha, boxplot e etc.

4.  Facets - plotar multiplos grupos

5.  Stats - Transformações estatísticas

6.  Coordinates System - O espaço no qual o dado sera plotado, como por
    exemplo, espaço cartesiano, polar e entre outros.

7.  Theme - Controle e modificação de aparência de tudo que não diz
    respeito ao dado utilizado.

8.  Scales - Para cada Aesthetics, descreve como a característica visual
    é convertida em valores, como por exemplo, escala por tamanho, cor e
    etc.

É muito importante destacar que **as camadas (layers) podem aparecer em
qualquer sequencia ao fazermos um gráfico e que a única camada
necessária para começar um gráfico é a partir da função ggplot()**.

![](https://raw.githubusercontent.com/p4hUSP/workshops_2018.2/master/imgs/w3_03.png)
<center>
Os layers do ggplot2 (Fonte: DataCamp)
</center>
Como fazer um gráfico no `ggplot2`
----------------------------------

Vamos fazer um exercício de imaginação? Como nós faríamos um gráfico sem
o R? Que tal um papel? Qual o passo a passo que poderíamos fazer?

<br/>

No R é semelhante. Primeiro precisamos de um papel:

    ggplot()

Depois, nós precisamos decidir que dados iremos utilizar e quam vai ser
o eixo x e o eixo y.

    ggplot(data = banco, mapping = aes(x = BMI, y = DiabetesPedigreeFunction))

Em seguida, escolhemos qual é melhor forma /estrutura para visualizar os
dados.

    ggplot(data = banco, mapping = aes(x = BMI, y = DiabetesPedigreeFunction)) + 
      geom_point()

!!! question " Qual é a diferença do + para o %&gt;% "

    Como vimos o pipe serve para deixarmos a linguagem mais linear, servindo como um conector entre as funções, porém isso não funciona com o `ggplot2`. O motivo pode ser pensado até de forma mais intuitiva: No ggplot2 estamos adicionando camadas com o sinal de mais enquanto com o `%>%` estamos dando uma sequência de ações, isto é, funções.

Simples, não? Apesar disso, precisamos entender alguns conceitos que
vimos ao montar este gráfico, como por exemplo, colocamos os eixos x e y
dentro de uma função chamada `aes()`. Ela é uma função responsável pela
propriedade visual dos objetos no gráfico, em outras palavras, ela faz o
“mapeamento” das variáveis do nosso banco de dados para que eles possam
fazer parte dos elementos visuais do gráfico.

    ggplot(data = banco, mapping = aes(x = BMI, y = DiabetesPedigreeFunction, color = categoria_idade)) + 
      geom_point()

Perceba que o `color = categoria_idade` afeta o `geom` que utilizamos de
acordo com a variável de interesse, mas veremos adiante que também
podemos alterar tanto um `geom` especificamente, quanto a cor do
gráfico.

Vamos ver outros `geom_`?

### geom\_col()

Para fazer este geom, eu vou manipular a base de dados para contar
quantos são aqueles que possuem diabetes. Além disso, vou chamar essa
nova tabela de `tab1`

    # chame esta tabela de banco para que possamos fazer outras manipulações
    tab1 <- banco %>% 
      group_by(Outcome) %>% 
      summarise(n = n())

    tab1

Vamos para o geom\_col()

    ggplot(data = tab1, mapping = aes(x = Outcome, y = n)) + geom_col()

Vamos brincar um pouco com os argumentos estéticos que o ggplot2
permite?

    ggplot(data = tab1, mapping = aes(x = Outcome, y = n)) + geom_col(fill = "red", width = 0.5)

#### Exercício

1.  Aplique os parâmetros para mudar a cor (color), o tamanho (size) e o
    formato (shape) dos pontos do gráfico abaixo:

<!-- -->

    ggplot(data = banco, mapping = aes(x = Age, y = BloodPressure)) + geom_point()

### geom\_histogram()

Se quisermos ver a distribuição de uma variável quantitativa, podemos
utilizar o `geom_histogram()`! Qual será a distribuição da variável
SkinThickness?

    ggplot(banco, aes(x = SkinThickness)) + geom_histogram(bins = 20)

Lembre-se que também podemos colocar outros atribuitos estéticos!

    ggplot(banco, aes(x = SkinThickness)) + geom_histogram(bins = 20, color = "blue", fill = "green")

### geom\_boxplot() e geom\_violin()

Se nós tivermos uma variável quantitativa e qualitativa, podemos
utilizar o `geom_boxplot` e o `geom_violin`! Qual a distribuição do
speechiness por album?

    ggplot(banco, aes(x = categoria_bmi, y = Glucose)) + geom_boxplot(fill = "#444054", color = "#cc3f0c")

    ggplot(banco, aes(x = categoria_bmi, y = Glucose)) + geom_violin(fill = "#8c1c13", alpha = 1/2)

### geom\_line()

Para esses exemplo vamos criar a tabela abaixo primeiro:

    tab2 <- banco %>% 
      group_by(categoria_idade) %>% 
      summarise(media_gravidez = mean(Pregnancies))

Apesar de mais utilizado para séries temporais, podemos utilizar um
gráfico de linhas para pensar na diferença presente nas idades quanto a
média de gravidez.

    ggplot(data = tab2, mapping = aes(x = categoria_idade, y = media_gravidez)) + geom_line(group = 1)

#### Exercício

1.  Incluia um geom\_point() no gráfico acima e altere sua cor de acordo
    com cada categorização de idade.

E se quisermos mudar a cor da categorização para algo que gostamos mais?
Para fazer isso vamos incluir mais uma camada no nosso gráfico, a camada
de scale.

!!! question " Combinando cores "

    Se você tem dúvida de qual cor pode combinar melhor com outra, tem um [site](https://coolors.co/app) bem bacana que pode te ajudar nisso.

    ggplot(data = tab2, mapping = aes(x = categoria_idade, y = media_gravidez)) + geom_line(group = 1) + geom_point(aes(color = categoria_idade), size = 10) + scale_color_manual(values = c("#ff1053", "#6c6ea0", "#66c7f4"))

Neste caso utilizamos o `scale_color_manual` pois queriamos preencher as
cores de acordo com o que colocamos no paramêtro `color`. Se tivessemos
escolhido o `fill` teriamos que utilizar `scale_fill_manual`.

    ggplot(banco, aes(x = categoria_bmi, y = Glucose, fill = categoria_bmi)) + geom_boxplot(color = "#cc3f0c") + scale_fill_manual(values = c("#ff1053", "#6c6ea0", "#66c7f4", "#3a606e", "#7b4b94", "#8a1c7c", "#5bc0eb"))

O `ggplot2` também possibilita a utilização de outros sistemas de
coordenadas, como por exemplo:

-   `coord_flip`

<!-- -->

    ggplot(data = tab1, mapping = aes(x = Outcome, y = n, fill = Outcome)) + geom_col() + scale_fill_manual(values = c("#ff1053", "#6c6ea0")) + coord_flip()

-   `coord_polar`

<!-- -->

    tab3 <- banco %>% 
      group_by(Outcome) %>% 
      summarise(n = n()) %>% 
      mutate(p = n/sum(n))

    ggplot(data = tab3, mapping = aes(x = factor(1), y = p, fill = Outcome)) + geom_col() + scale_fill_manual(values = c("#ff1053", "#6c6ea0")) + coord_polar(theta = 'y')

Dica: Tome cuidado com o `coord_polar`! Ás vezes, para não dizer sempre,
eles podem dificultar a visualização dos dados, sobretudo, aqueles com
muitas categorias.

Antes de vermos gráficos de correlação, vamos dar um título para nosso
gráfico?

    ggplot(data = tab1, mapping = aes(x = Outcome, y = n, fill = Outcome)) + geom_col() + scale_fill_manual(values = c("#ff1053", "#6c6ea0")) + coord_flip() +
      labs(title = "Aproximadamente 1 a cada 3 tem diabetes",
           x = "Quantidade", 
           y = "Diabetes",
           caption = "Pima Diabetes")

2. corrplot
-----------

Muitas vezes precisamos analisar a correlação entre as variáveis e um
dos melhores pacotes para isso é o `corrplot`. Vamos começar
selecionando apenas as variáveis quantitativas.

    tab4 <- banco %>% 
      select(-Outcome, -categoria_idade, -categoria_bmi)

Vamos primeiro criar uma matriz de correlação e após isto podemos
começar a criar nossos gráficos.

    matriz_correlacao <- cor(tab4)

    corrplot(matriz_correlacao, method = 'circle')

    corrplot(matriz_correlacao, method = 'square')

    corrplot(matriz_correlacao, method = 'number')

    corrplot(matriz_correlacao, method = 'square', type = "upper")

    corrplot(matriz_correlacao, method = 'square', type = "lower")

    corrplot.mixed(matriz_correlacao)
