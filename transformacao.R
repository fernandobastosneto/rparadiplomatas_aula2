# Pacotes -----------------------------------------------------------------

library(tidyverse)
library(scales)

# Base de dados -----------------------------------------------------------

exportacoes <- read_csv2("dados/exportacoes2020.csv")
fmi <- readRDS("dados/fmi.rds")
# Jeito de ver a base -----------------------------------------------------

glimpse(exportacoes)
names(exportacoes)
View(exportacoes)

# dplyr: 6 verbos principais
# select()    # seleciona colunas do data.frame
# filter()    # filtra linhas do data.frame
# arrange()   # reordena as linhas do data.frame
# mutate()    # cria novas colunas no data.frame (ou atualiza as colunas existentes)
# summarise() + group_by() # sumariza o data.frame
# left_join   # junta dois data.frames

# Conceitos importantes para filtros! --------------------------------------

## Comparações lógicas -------------------------------

x <- 1

# Testes com resultado verdadeiro
x == 1
"a" == "a"

# Testes com resultado falso
x == 2
"a" == "b"

# Maior
x > 3
x > 0

# Maior ou igual
x > 1
x >= 1

# Menor
x < 3
x < 0

# Menor ou igual
x < 1
x <= 1

# Diferente
x != 1
x != 2

x %in% c(1, 2, 3)
"a" %in% c("b", "c")

## Operadores lógicos -------------------------------

## & - E - Para ser verdadeiro, os dois lados 
# precisam resultar em TRUE

x <- 5
x >= 3 & x <=7


y <- 2
y >= 3 & y <= 7

## | - OU - Para ser verdadeiro, apenas um dos 
# lados precisa ser verdadeiro

y <- 2
y >= 3 | y <=7

y <- 1
y >= 3 | y == 0


## ! - Negação - É o "contrário"

!TRUE

!FALSE

w <- 5
(!w < 4)

# filter ------------------------------------------------------------------

# Filtrando uma coluna da base
exportacoes %>% filter(vl_fob > 100000)
exportacoes %>% filter(no_pais == "Afeganistão")

# O que acontece com o NA?
df <- tibble(x = c(1, NA, 3))

filter(df, x > 1)
filter(df, is.na(x) | x > 1)

# Vendo categorias de uma variável
unique(fmi$desemprego) # saída é um vetor
fmi %>% distinct(desemprego) # saída é uma tibble

# Filtrando texto sem correspondência exata
# A função str_detect()
textos <- c("a", "aa","abc", "bc", "A", NA)

str_detect(textos, pattern = "a")

## Pegando apenas os filmes que 
## tenham o gênero ação
exportacoes %>% filter(str_detect(no_sec_por, "Madeira"))


## Exercícios --------
### 1. Use a função "filter" para selecionar dois países na base de dados 
### exportacoes.

### 2. Crie um vetor com uma lista de cinco países e filtre a base de dados
### a partir desse vetor.

### 3. Na base de dados do fmi, identifique os anos em que o Brasil teve crescimento
### econômico acima de 0

### 4. Na base de dados do fmi, para um país à sua escolha, identifique os anos em 
### que a razão entre desemprego e inflação é maior que 1

### 5. Usando os dados do fmi, selecione linhas com "NA" na coluna "desemprego"

### 6. Nos dados de exportação, selecione produtos exportados de "máquinas" com 
### valor exportado superior a um milhão de dólares (1000000)


# mutate ------------------------------------------------------------------

# Modificando uma coluna

fmi %>% 
  filter(pais == "Chile") %>% 
  mutate(divida = dividabruta-dividaliquida) %>% 
  View()

# Criando uma nova coluna

fmi %>% 
  mutate(gdpgrowth = percent(gdpgrowth, scale = 1)) %>% 
  View()

fmi %>% 
  filter(pais == "Chile") %>% 
  mutate(divida = dividabruta-dividaliquida) %>% 
  View()

# select ------------------------------------------------------------------

# Selcionando uma coluna da base

select(exportacoes, no_sec_por)

# A operação NÃO MODIFICA O OBJETO imdb

exportacoes

# Selecionando várias colunas

select(exportacoes, no_pais, vl_fob)

select(exportacoes, no_pais:vl_fob)

# Funções auxiliares

select(exportacoes, starts_with("no"))
select(exportacoes, contains("p"))

# Principais funções auxiliares

# starts_with(): para colunas que começam com um texto padrão
# ends_with(): para colunas que terminam com um texto padrão
# contains():  para colunas que contêm um texto padrão

# Selecionando colunas por exclusão

select(exportacoes, -starts_with("no"), -ano, -ends_with("s"))

# arrange -----------------------------------------------------------------

# Ordenando linhas de forma crescente de acordo com 
# os valores de uma coluna

arrange(exportacoes, vl_fob)

# Agora de forma decrescente

arrange(exportacoes, desc(vl_fob))

# O que acontece com o NA?

df <- tibble(x = c(NA, 2, 1), y = c(1, 2, 3))
arrange(df, x)
arrange(df, desc(x))

## Exercícios -----

fmi

### 1. Selecione dois indicadores a sua escolha na base de dados fmi e crie uma nova
### variável a partir da relação entre esses dois indicadores (pode ser a soma, diferença,
### multiplicação ou divisão). Ordene a tabela de maneira descrescente com base nos valores
### do novo indicador.

### 2. Crie uma visualização à sua escolha a partir do indicador construído no exercício anterior.


# summarise ---------------------------------------------------------------

# Sumarizando uma coluna

fmi %>% summarise(media_desemprego = mean(desemprego, na.rm = TRUE))

# repare que a saída ainda é uma tibble


# Sumarizando várias colunas
fmi %>% summarise(
  media_desemprego = mean(desemprego, na.rm = TRUE),
  media_crescimento = mean(gdpgrowth, na.rm = TRUE),
  media_inflacao = mean(inflacao, na.rm = TRUE)
)

# Diversas sumarizações da mesma coluna
fmi %>% summarise(
  media_desemprego = mean(desemprego, na.rm = TRUE),
  mediana_desemprego = median(desemprego, na.rm = TRUE),
  variancia_desemprego = var(desemprego, na.rm = TRUE)
)

# group_by + summarise ----------------------------------------------------

# Agrupando a base por uma variável.

fmi %>% group_by(pais)

# Agrupando e sumarizando
fmi %>% 
  group_by(pais) %>% 
  summarise(
    media_desemprego = mean(desemprego, na.rm = TRUE),
    media_crescimento = mean(gdpgrowth, na.rm = TRUE),
    media_inflacao = mean(inflacao, na.rm = TRUE)
  )

## Exercícios -----
### 1. Na base de dados "exportações", use a função "sum()" para identificar a 
### soma de todos os produtos exportados pelo Brasil a todos os países.

### 2. Identifique o valor exportado pelo Brasil a cada
### um dos países na base de dados.

### 3. Identifique os principais produtos exportados pelo Brasil a todo o mundo.
### Apresente os resultados em um gráfico.

### 4. Selecione um país à sua escolha. Identifique os principais produtos exportados
### pelo Brasil a esse país. Apresente os resultados em um gráfico.

