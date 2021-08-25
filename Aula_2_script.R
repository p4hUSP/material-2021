#abrindo as bibliotecas necessárias 

#install.packages("tidyverse")
library(tidyverse)

#abrindo o banco de dados 
#função read_csv para ler arquivos em csv
atletas_eventos <- read_csv("athlete_events.csv")

View(atletas_eventos)

#rename()
#mudando o nome das variáveis para o português

atletas_eventos<-
  rename(atletas_eventos,"Nome"="Name",
         "Sexo"="Sex",
         "Idade"="Age",
         "Altura"="Height",
         "Peso"="Weight",
         "Time"="Team",
         "CON"="NOC",
         "Jogos"="Games",
         "Ano"="Year",
         "Estação"="Season",
         "Cidade"="City",
         "Esporte"="Sport",
         "Evento"="Event",
         "Medalha"="Medal")

atletas_eventos

#select()

select(atletas_eventos,Nome,Sexo,Idade)

#excluindo coluna do banco
select(atletas_eventos,-CON)

#filter()

filter(atletas_eventos, Sexo == "F")

#mais de um filter

filter(atletas_eventos, Sexo == "F" & Idade < 18 & Time == "Brazil")

#ou

filter(atletas_eventos, Altura <= 165 | Peso >60 )

#mutate()

#criando variavel

atletas_mutate <- 
mutate(atletas_eventos, Idade_Categoria = ifelse(Idade >=60,"IDOSO","ADULTO"))

View(atletas_mutate)

atletas_mutate2 <-
mutate(atletas_eventos, Age_Category = case_when(Idade >= 60 ~ "IDOSO",
                                                 Idade < 60 ~ "ADULTO"))

View(atletas_mutate2)

#mudando o nome de observações dentro de uma variável

atletas_eventos <-
mutate(atletas_eventos, Medalha = case_when(Medalha == "Gold"~"Ouro",
                                          Medalha =="Silver"~"Prata",
                                          TRUE ~ Medalha))
View(atletas_eventos)


#mudando o "case"

#do maiúsculo para o minúsculo
atletas_eventos <-
mutate(atletas_eventos, CON=tolower(CON))

View(atletas_eventos)

#do minúsculo para o maiúsculo
atletas_eventos <-
  mutate(atletas_eventos, CON=toupper(CON))

View(atletas_eventos)

#count()

count(atletas_eventos, Idade)

count(atletas_eventos, Medalha)

#dica: se quisermos omitir os NA é só usar a função na.omit()
na.omit(count(atletas_eventos,Medalha))

#group_by

atle_2<-
  group_by(atletas_eventos, Sexo)

#sumarizando o número de homens e de mulheres
summarise(atle_2, Quantidade=n())

#sumarizando a altura media de homens e mulheres

summarise(atle_2, media_altura = mean(Altura, na.rm=T))

#sumarizando o valor maximo de idade de homens e mulheres

summarise(atle_2, maximo_idade = max(Idade, na.rm=T))

#sumarizando o valor minimo de idade de homens e mulheres

summarise(atle_2, minimo_idade = min(Idade, na.rm=T))

#separate()

atletas_eventos <-
  separate(atletas_eventos, Name, c("Name","Surname"), " ", remove = F)

atletas_eventos

#unite()

atletas_eventos <-
  unite(atletas_eventos, "Name", Name,Surname, sep = " ")

atletas_eventos
#importância do %>% e porque você deveria usa-lo 
#sem o %>%
rename(count(mutate(select(filter(atletas_eventos, Altura >= 175, Time == "Brazil", Sexo == "F", Medalha == "Ouro"),-CON,-ID,-Evento),CATEGORIA = ifelse(Idade >= 60, "IDOSO","ADULTO")),CATEGORIA),QUANTIDADE = n)

#com o %>%
atletas_eventos %>%
  filter(Altura >= 175, Time == "Brazil", Sexo == "F", Medalha == "Ouro") %>%
  select(-CON,-ID,-Evento) %>%
  mutate(CATEGORIA = ifelse(Idade >= 60, "IDOSO","ADULTO")) %>%
  count(CATEGORIA) %>%
  rename(Quantidade=n)
