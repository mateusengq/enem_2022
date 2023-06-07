## Pacotes

if(!require(data.table)){install.packages('data.table')}
if(!require(tidyverse)){install.packages('tidyverse')}
if(!require(GGally)){install.packages('GGally')}
library(hrbrthemes)
library(kableExtra)
library(ggtext)
library(corrplot)

cores <- c('#1B418C','#025930', '#F2E205', '#F2B705', '#D91E1E', '#CCCCCC')


theme_padrao <- theme(legend.position = 'none',
                          legend.title = element_blank(),
                          panel.grid.major = element_blank(),
                          panel.grid.minor = element_blank(),
                          panel.background = element_blank(),
                          axis.title.y = element_text(size = 16),
                          axis.title.x = element_text(size = 16),
                          axis.text.x = element_blank(),
                          axis.text.y = element_text(size = 12),
                          plot.title = element_text(size = 22),
                          plot.title.position = "plot",
                          plot.caption = element_text(size = 14))

## alocação de Memória
memory.limit(24576)

## Dados

df_enem <- data.table::fread('MICRODADOS_ENEM_2022.csv',
                             integer64 = 'character',
                             skip = 0,
                             nrow = -1,
                             na.strings = "",
                             showProgress = TRUE,
                            encoding = 'Latin-1')

dim(df_enem)
head(df_enem)
# A base possui 3476105 registros e 76 variáveis

## Análise Exploratória
##### Variável Faixa Etária ######

df_enem$TP_FAIXA_ETARIA <- factor(df_enem$TP_FAIXA_ETARIA, levels = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20), 
                                                                                  labels = c('Menor de 17 anos','17 anos','18 anos','19 anos','20 anos','21 anos','22 anos',
                                                                                             '23 anos','24 anos','25 anos','Entre 26 e 30 anos','Entre 31 e 35 anos','Entre 36 e 40 anos',
                                                                                             'Entre 41 e 45 anos','Entre 46 e 50 anos','Entre 51 e 55 anos','Entre 56 e 60 anos','Entre 61 e 65 anos',
                                                                                             'Entre 66 e 70 anos','Maior de 70 anos'))

str(df_enem$TP_FAIXA_ETARIA)


g1_idade <- df_enem %>%
    drop_na(TP_FAIXA_ETARIA) %>%
    group_by(TP_FAIXA_ETARIA) %>%
    summarise(cont = n()) %>%
    mutate(prop = ((cont/sum(cont))*100)) %>%
    ggplot(aes(x = reorder(TP_FAIXA_ETARIA, desc(TP_FAIXA_ETARIA)), y = prop, fill = TP_FAIXA_ETARIA), color = 'black') +
    geom_bar(stat = 'identity', col = 'white') +
    coord_flip() +
    geom_label(aes(label = paste0(round(prop,2),"%")), position = position_dodge(0.9), hjust = -0.1,
               size = 6, show.legend = F, color = 'white') +
    ylim(0, 30) +
    labs(title = 'Proporção de alunos por Faixa Etária', x = '', y = '',
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values =  c(rep('#025930',3), rep('#a9a9a9', 7), rep('#1B418C',2), rep('#a9a9a9',10)))+
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.y = element_text(size = 16),
          axis.title.x = element_text(size = 16),
          axis.text.x = element_blank(),
          axis.text.y = element_text(size = 12),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))

g1_idade + annotate('text', label = "As faixas iniciais representam\n 52,3% dos alunos.", x = 15, y = 21,
                    col = 'black', size = 6) +
    annotate('text', label = "A partir de 26 anos,\n os dados estão agrupados.", x = 8, y = 15,
             col = 'black', size = 6)

 #### treineiro ######
 
df_enem$IN_TREINEIRO <- factor(df_enem$IN_TREINEIRO, levels = c(1, 0), labels = c('Sim', 'Não'))
table(df_enem$IN_TREINEIRO)

prop.table(table(df_enem$IN_TREINEIRO))
 # Na base há 14,75% (512732) de treineiros e 2963373 (85,25%) de não treineiros
 
######## sexo ######

df_enem$TP_SEXO <- factor(df_enem$TP_SEXO, levels = c('M', 'F'), labels = c('Masculino', 'Feminino'))
summary(df_enem$TP_SEXO)


g1_sexo <- df_enem %>%
    drop_na(TP_SEXO) %>%
    group_by(TP_SEXO) %>%
    summarise(cont = n()) %>%
    mutate(prop = ((cont/sum(cont))*100)) %>%
    ggplot(aes(x = TP_SEXO, y = prop, fill = TP_SEXO), color = 'black') +
    geom_bar(stat = 'identity', col = 'white') +
    coord_flip() +
    geom_label(aes(label = paste0(round(prop,2),"%")), position = position_dodge(0.9), hjust = -0.1,
               size = 6, show.legend = F, color = 'white') +
    ylim(0, 70) +
    labs(title = 'Proporção de alunos por Sexo', x = '', y = '',
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values =  c(rep('#1B418C',1), rep('#D91E1E',1), rep('#1B418C',1), rep('#a9a9a9',10)))+
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.y = element_text(size = 16),
          axis.title.x = element_text(size = 16),
          axis.text.x = element_blank(),
          axis.text.y = element_text(size = 16),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))

g1_sexo

######## dependência da escola #######

df_enem$TP_DEPENDENCIA_ADM_ESC <- factor(df_enem$TP_DEPENDENCIA_ADM_ESC, levels = c(1, 2, 3, 4),
                                         labels = c('Federal', 'Estadual',
                                                    'Municipal', 'Privada'))
table(df_enem$TP_DEPENDENCIA_ADM_ESC)


g1_dep_adm <- df_enem %>%
    drop_na(TP_DEPENDENCIA_ADM_ESC) %>%
    group_by(TP_DEPENDENCIA_ADM_ESC) %>%
    summarise(cont = n()) %>%
    mutate(prop = ((cont/sum(cont))*100)) %>%
    ggplot(aes(x = reorder(TP_DEPENDENCIA_ADM_ESC, desc(prop)), y = prop, fill = TP_DEPENDENCIA_ADM_ESC), color = 'black') +
    geom_bar(stat = 'identity', col = 'white') +
    #coord_flip() +
    geom_label(aes(label = paste0(round(prop,2),"%")), position = position_dodge(0), vjust = -0.25,
               size = 6, show.legend = F, color = 'white') +
    ylim(0, 80) +
    labs(title = 'Proporção de alunos por dependência escolar', x = '', y = '',
         subtitle = 'Dependência Administrativa Escolar ',
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values =  c(rep('#a9a9a9', 1), rep('#025930', 1), rep('#a9a9a9', 1), rep('#1B418C',1), rep('#a9a9a9',10)))+
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.x = element_text(size = 16),
          axis.title.y = element_text(size = 16),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size = 12),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))

g1_dep_adm + annotate('text', label = "A maior proporção de alunos são de escolas estaduais,\nseguido de escolas privadas.\n\nNo Brasil, o Ensino Médio é prioridade do governo estadual e \ndo Distrito Federal", x = 1.5, y = 60,
                          col = 'black', size = 6, hjust = 0)


#### raça ####
df_enem$TP_COR_RACA <- factor(df_enem$TP_COR_RACA, levels = c(0, 1, 2, 3, 4, 5, 6),
                              labels = c('Não declarado', 'Branca', 'Preta',
                                         'Parda', 'Amarela', 'Indígena','Não dispões da informação'))


table(df_enem$TP_COR_RACA)

g1_raca <- df_enem %>%
    drop_na(TP_COR_RACA) %>%
    group_by(TP_COR_RACA) %>%
    summarise(cont = n()) %>%
    mutate(prop = ((cont/sum(cont))*100)) %>%
    ggplot(aes(x = reorder(TP_COR_RACA, desc(prop)), y = prop, fill = TP_COR_RACA), color = 'black') +
    geom_bar(stat = 'identity', col = 'white') +
    #coord_flip() +
    geom_label(aes(label = paste0(round(prop,2),"%")), position = position_dodge(0), vjust = -0.25,
               size = 6, show.legend = F, color = 'white') +
    ylim(0, 50) +
    labs(title = 'Proporção de alunos segundo a variável COR/RAÇA', x = '', y = '',
         #subtitle = 'Dependência Administrativa Escolar ',
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values =  c(rep('#a9a9a9', 1), rep('#025930', 1), rep('#a9a9a9', 1), rep('#025930',1), rep('#a9a9a9',10)))+
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.x = element_text(size = 16),
          axis.title.y = element_text(size = 16),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size = 12),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))

g1_raca + annotate('text', label = "Aproximadamente 84% dos alunos\nse declaram Pardos ou Brancos", x = 2.5, y = 40,
                   col = 'black', size = 6, hjust = 0) +
    annotate('text', label = 'A proporção de declarantes "Indígenas" é\ninferior ao percentual dos\n"Não declarados"!',
             x = 3.5, y = 15, col = 'firebrick', size = 6, hjust = 0) 

###### estados #####
if(!require(geobr)){install.packages('geobr')}
if(!require(sf)){install.packages('sf')}
if(!require(tmap)){install.packages('tmap')}

# leitura dos estados
states <- read_state(
    year = 2019,
    showProgress = TRUE
)

head(states)

alunos_estados <- df_enem |>
    group_by(SG_UF_PROVA) |>
    summarise(num_alunos = n()) |>
    mutate(prop = (num_alunos/sum(num_alunos))*100)


df_estados <- merge(x = alunos_estados, y = states, by.x = "SG_UF_PROVA", by.y =  "abbrev_state")
head(df_estados)

ggplot(df_estados) +
    geom_sf(data = df_estados, aes(fill = prop, geometry = geom), color = "white", size = .15) +
    labs(title = 'Proporção de alunos por Estado', x = '', y = '',
         caption = "Fonte: Enem | 2022") +
    geom_sf_label(aes(label = paste0(round(prop,2),"%"), geometry = geom), #vjust = 0,
               size = 4, show.legend = F, color = 'black', position = "jitter", check_overlap = TRUE) +
    scale_fill_gradient(low = "#CCCCCC", high = "#1b418c") +
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          #axis.title.y = element_text(size = 16),
          #axis.title.x = element_text(size = 16),
          axis.text.x = element_blank(),
          #axis.text.y = element_text(size = 12),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))

# "#1B418C" "#025930" "#F2E205" "#F2B705" "#D91E1E" "#CCCCCC"


######### presença por prova ###########
df_enem$TP_PRESENCA_CN <- factor(df_enem$TP_PRESENCA_CN, levels = c(0, 1, 2),
                                 labels = c('Faltou', 'Presente', 'Eliminado'))

table(df_enem$TP_PRESENCA_CN)
prop.table(table(df_enem$TP_PRESENCA_CN))*100

df_enem$TP_PRESENCA_CH <- factor(df_enem$TP_PRESENCA_CH, levels = c(0, 1, 2),
                                 labels = c('Faltou', 'Presente', 'Eliminado'))

table(df_enem$TP_PRESENCA_CH)
prop.table(table(df_enem$TP_PRESENCA_CH))*100

df_enem$TP_PRESENCA_LC <- factor(df_enem$TP_PRESENCA_LC, levels = c(0, 1, 2),
                                 labels = c('Faltou', 'Presente', 'Eliminado'))

table(df_enem$TP_PRESENCA_LC)
prop.table(table(df_enem$TP_PRESENCA_LC))*100

df_enem$TP_PRESENCA_MT <- factor(df_enem$TP_PRESENCA_MT, levels = c(0, 1, 2),
                                 labels = c('Faltou', 'Presente', 'Eliminado'))

table(df_enem$TP_PRESENCA_MT)
prop.table(table(df_enem$TP_PRESENCA_MT))*100


######## idioma #######
df_enem$TP_LINGUA <- factor(df_enem$TP_LINGUA, levels = c(0, 1),
                            labels = c('Ingles', 'Espanhol'))


g1_idioma <- df_enem %>%
    drop_na(TP_LINGUA) %>%
    group_by(TP_LINGUA) %>%
    summarise(cont = n()) %>%
    mutate(prop = ((cont/sum(cont))*100)) %>%
    ggplot(aes(x = TP_LINGUA, y = prop, fill = TP_LINGUA), color = 'black') +
    geom_bar(stat = 'identity', col = 'white') +
    #coord_flip() +
    geom_label(aes(label = paste0(round(prop,2),"%")), position = position_dodge(0), vjust = -0.25,
               size = 6, show.legend = F, color = 'white') +
    ylim(0, 60) +
    labs(title = 'Proporção de alunos segundo o idioma de escolha', x = '', y = '',
         #subtitle = 'Dependência Administrativa Escolar ',
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values =  c(rep('#1B418C', 1), rep('#025930', 1), rep('#a9a9a9', 1), rep('#025930',1), rep('#a9a9a9',10)))+
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.x = element_text(size = 16),
          axis.title.y = element_text(size = 16),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size = 12),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))

#"#1B418C" "#025930" "#F2E205" "#F2B705" "#D91E1E" "#CCCCCC"

g1_idioma

###### status redação ######
# incluir status e uma análise da nota

df_enem$TP_STATUS_REDACAO <- factor(df_enem$TP_STATUS_REDACAO, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9),
                                    labels = c("Sem problemas",
                                               "Anulada",
                                               "Copia do texto motivador",
                                               "Em branco",
                                               "Fere direitos humanos",
                                               "Fuga ao tema",
                                               "Nao atendimento ao tipo",
                                               "Texto insuficiente",
                                               "Parte desconectada"))


g1_status_redacao <- df_enem %>%
    drop_na(TP_STATUS_REDACAO) %>%
    group_by(TP_STATUS_REDACAO) %>%
    summarise(cont = n()) %>%
    mutate(prop = ((cont/sum(cont))*100)) %>%
    ggplot(aes(x = reorder(TP_STATUS_REDACAO, prop), y = prop, fill = TP_STATUS_REDACAO), color = 'black') +
    geom_bar(stat = 'identity', col = 'white') +
    coord_flip() +
    geom_label(aes(label = paste0(round(prop,2),"%")), position = position_dodge(0.9), hjust = -.15,
               size = 6, show.legend = F, color = 'white') +
    ylim(0, 110) +
    labs(title = 'Avaliação dos Status da Redação', x = '', y = '',
         #subtitle = 'Dependência Administrativa Escolar ',
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values =  c(rep('#1B418C', 1), rep('#a9a9a9', 1), rep('#025930', 3), rep('#a9a9a9', 6), rep('#025930',1), rep('#a9a9a9',10)))+
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.y = element_text(size = 16),
          axis.title.x = element_text(size = 16),
          axis.text.x = element_blank(),
          axis.text.y = element_text(size = 12),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))

g1_status_redacao + annotate('text', label = "Quase 95% dos alunos não tiveram\nproblemas na redação", x = 6.75, y = 40,
                                      col = '#1B418C', size = 6, hjust = 0) +
    annotate('text', label = "A soma das categorias em cinza\ntotalizam 0,55%", x = 2.75, y = 20,
             col = '#a9a9a9', size = 6, hjust = 0)

## notas redação

media_redacao <- mean(df_enem$NU_NOTA_REDACAO, na.rm = TRUE)
media_redacao
quart1_redacao <- quantile(df_enem$NU_NOTA_REDACAO, na.rm = TRUE, 0.25)
quart1_redacao
quart3_redacao <- quantile(df_enem$NU_NOTA_REDACAO, na.rm = TRUE, 0.75)
quart3_redacao
quart2_redacao <- quantile(df_enem$NU_NOTA_REDACAO, na.rm = TRUE, 0.5)
quart2_redacao

sd(df_enem$NU_NOTA_REDACAO, na.rm = T)

notas_1000 <- length(which(df_enem$NU_NOTA_REDACAO == 1000 & !is.na(df_enem$NU_NOTA_REDACAO)))
notas_1000

df_enem %>%
    drop_na(NU_NOTA_REDACAO) %>%
    filter(NU_NOTA_REDACAO == 1000) %>%
    group_by(TP_SEXO) %>%
    summarise(cont = n())
    

g1_redacao <- ggplot(df_enem, aes(x = NU_NOTA_REDACAO)) +
    geom_histogram(color = "#a9a9a9", alpha = 0.6) +
    geom_vline(xintercept = media_redacao, color = '#025930', linetype = 'dashed', size = 1)+
   # geom_vline(xintercept = quart2_redacao, color = '#1B418C', linetype = 'dashed', size = 1)+
    geom_vline(xintercept = quart1_redacao, color = '#d91e1e', linetype = 'dashed', size = 1, alpha = 0.5)+
    geom_vline(xintercept = quart3_redacao, color = '#d91e1e', linetype = 'dashed', size = 1, alpha = 0.5)+
    labs(title = 'Distribuição das notas da Redação', x = '', y = '',
         #subtitle = 'Dependência Administrativa Escolar ',
         caption = 'Fonte: Enem 2022') +
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.x = element_text(size = 16),
          axis.title.y = element_text(size = 16),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size = 12),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))

g1_redacao + annotate('text', label = paste0("Média: ", round(media_redacao,2), '\ne a mediana: ', round(quart2_redacao,2)), y = 410000, x = media_redacao+10,
                    col = '#025930', size = 6, hjust = 0) +
    annotate('text', label = paste0("Q1: ", round(quart1_redacao,2)),y = 310000, x = quart1_redacao-60,
             col = '#d91e1e', size = 6, hjust = 0) +
    annotate('text', label = paste0("Q3: ", round(quart3_redacao,2)),y = 310000, x = quart3_redacao+10,
             col = '#d91e1e', size = 6, hjust = 0) 


### questões família

df_enem$Q001 <- factor(df_enem$Q001, levels = c("A", "B", "C", "D", "E", "F", "G", "H"),
                       labels=c('Nunca estudou',
                                'Nao completou a 4 serie/5 ano do ensino fundamental',
                                'Completou a 4 serie/5 ano, mas nao completou a 8 serie/9 ano do ensino fundamental',
                                'Completou a 8 serie/9 ano do ensino fundamental, mas nao completou o Ensino Medio',
                                'Completou o Ensino Medio, mas nao completou a Faculdade',
                                'Completou a Faculdade, mas nao completou a Pos-graduacao',
                                'Completou a Pos-graduacao','Nao sei'))


(g1_q001 <- df_enem %>%
    group_by(Q001) %>%
    summarise(cont = n())  %>%
    mutate(prop = (cont/sum(cont))*100) %>%
    ggplot(aes(x = reorder(Q001, desc(Q001)), y = prop, fill = Q001), color = 'black') +
    geom_bar(stat = 'identity', col = 'white') +
    coord_flip()) +
    geom_label(aes(label = paste0(round(prop,2),"%")), position = position_dodge(0.9), hjust = -0.1,
               size = 6, show.legend = F, color = 'white') +
    ylim(0, 40) +
    labs(title = 'Até que série seu pai, ou o homem responsável por você, estudou?', x = '', y = '',
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values =  c(rep('#a9a9a9', 4), rep('#025930',1), rep('#a9a9a9', 7, rep('#1B418C',2), rep('#a9a9a9',10))))+
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.y = element_text(size = 16),
          axis.title.x = element_text(size = 16),
          axis.text.x = element_blank(),
          axis.text.y = element_text(size = 16),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))



df_enem$Q002 <- factor(df_enem$Q002, levels = c("A", "B", "C", "D", "E", "F", "G", "H"),
                       labels=c('Nunca estudou',
                                'Nao completou a 4 serie/5 ano do ensino fundamental',
                                'Completou a 4 serie/5 ano, mas nao completou a 8 serie/9 ano do ensino fundamental',
                                'Completou a 8 serie/9 ano do ensino fundamental, mas nao completou o Ensino Medio',
                                'Completou o Ensino Medio, mas nao completou a Faculdade',
                                'Completou a Faculdade, mas nao completou a Pos-graduacao',
                                'Completou a Pos-graduacao','Nao sei'))


(g1_q002 <- df_enem %>%
        group_by(Q002) %>%
        summarise(cont = n())  %>%
        mutate(prop = (cont/sum(cont))*100) %>%
        ggplot(aes(x = reorder(Q002, desc(Q002)), y = prop, fill = Q002), color = 'black') +
        geom_bar(stat = 'identity', col = 'white') +
        coord_flip()) +
    geom_label(aes(label = paste0(round(prop,2),"%")), position = position_dodge(0.9), hjust = -0.1,
               size = 6, show.legend = F, color = 'white') +
    ylim(0, 40) +
    labs(title = 'Até que série sua mãe, ou a mulher responsável por você, estudou?', x = '', y = '',
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values =  c(rep('#a9a9a9', 4), rep('#025930',1), rep('#a9a9a9', 7, rep('#1B418C',2), rep('#a9a9a9',10))))+
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.y = element_text(size = 16),
          axis.title.x = element_text(size = 16),
          axis.text.x = element_blank(),
          axis.text.y = element_text(size = 16),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))


df_enem$Q003 <- factor(df_enem$Q003, levels = c("A", "B", "C", "D", "E", "F"),
                       labels = c("Grupo 1", "Grupo 2", "Grupo 3", "Grupo 4", "Grupo 5", "Não sei"))

df_enem$Q004 <- factor(df_enem$Q004, levels = c("A", "B", "C", "D", "E", "F"),
                       labels = c("Grupo 1", "Grupo 2", "Grupo 3", "Grupo 4", "Grupo 5", "Não sei"))


df_enem$Q006 <- factor(df_enem$Q006,levels =  c('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q'),
                        labels=c('Nenhuma Renda','Ate R$ 1.212,00','De R$ 1.212,01 ate R$ 1.818,00.',
                                 'De R$ 1.818,01 ate R$ 2.424,00.','De R$ 2.424,01 ate R$ 3.030,00.',
                                 'De R$ 3.030,01 ate R$ 3.636,00.','De R$ 3.636,01 ate R$ 4.848,00.',
                                 'De R$ 4.848,01 ate R$ 6.060,00.','De R$ 6.060,01 ate R$ 7.272,00.',
                                 'De R$ 7.272,01 ate R$ 8.484,00.','De R$ 8.484,01 ate R$ 9.696,00.',
                                 'De R$ 9.696,01 ate R$ 10.908,00.','De R$ 10.908,01 ate R$ 12.120,00.',
                                 'De R$ 12.120,01 ate R$ 14.544,00.','De R$ 14.544,01 ate R$ 18.180,00.',
                                 'De R$ 18.180,01 ate R$ 24.240,00.','Acima de R$ 24.240,00.'))


(g1_q006 <- df_enem %>%
        group_by(Q006) %>%
        summarise(cont = n())  %>%
        mutate(prop = (cont/sum(cont))*100) %>%
        ggplot(aes(x = reorder(Q006, desc(Q006)), y = prop, fill = Q006), color = 'black') +
        geom_bar(stat = 'identity', col = 'white') +
        coord_flip()) +
    geom_label(aes(label = paste0(round(prop,2),"%")), position = position_dodge(0.9), hjust = -0.1,
               size = 6, show.legend = F, color = 'white') +
    ylim(0, 40) +
    labs(title = 'Qual é a renda mensal de sua família?', x = '', y = '',
         subtitle = 'Renda do inscrito e dos seus familiares',
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values =  c('#D91E1E', rep('#F2B705', 4), rep('#025930',3), rep('#a9a9a9',5), rep('#1B418C',10), rep('#a9a9a9',10)))+
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.y = element_text(size = 16),
          axis.title.x = element_text(size = 16),
          axis.text.x = element_blank(),
          axis.text.y = element_text(size = 16),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))


#### nota ######

df_enem <- df_enem %>%
    rowwise() %>%
    mutate(media = mean(c(NU_NOTA_CN, NU_NOTA_CH, NU_NOTA_LC, NU_NOTA_MT), na.rm = TRUE))

hist(df_enem$media)

df_enem |>
    drop_na(TP_DEPENDENCIA_ADM_ESC,m) |>
    ggplot(aes(y = media, x = as.factor(TP_DEPENDENCIA_ADM_ESC))) +
    geom_boxplot()


media_global <- mean(df_enem$media, na.rm = TRUE)
media_global
quart1_global <- quantile(df_enem$media, na.rm = TRUE, 0.25)
quart1_global
quart3_global <- quantile(df_enem$media, na.rm = TRUE, 0.75)
quart3_global
quart2_global <- quantile(df_enem$media, na.rm = TRUE, 0.5)
quart2_global

sd(df_enem$m, na.rm = TRUE)
summary(df_enem$m)

notas_1000 <- length(which(df_enem$m == 1000 & !is.na(df_enem$m)))
notas_1000


g1_nota_global <- ggplot(df_enem, aes(x = m)) +
    geom_histogram(color = "#a9a9a9", alpha = 0.6) +
    geom_vline(xintercept = media_global, color = '#025930', linetype = 'dashed', size = 1)+
    # geom_vline(xintercept = quart2_redacao, color = '#1B418C', linetype = 'dashed', size = 1)+
    geom_vline(xintercept = quart1_global, color = '#d91e1e', linetype = 'dashed', size = 1, alpha = 0.5)+
    geom_vline(xintercept = quart3_global, color = '#d91e1e', linetype = 'dashed', size = 1, alpha = 0.5)+
    labs(title = 'Distribuição das notas (exceto Redação)', x = '', y = '',
         subtitle = 'Média das notas: Ciências da Natureza, Ciências Humanas, Linguagens e Códigos, Matemática ',
         caption = 'Fonte: Enem 2022') +
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.x = element_text(size = 16),
          axis.title.y = element_text(size = 16),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size = 12),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14))

g1_nota_global + annotate('text', label = paste0("Média: ", round(media_global,2), '\ne a mediana: ', round(quart2_global,2)), y = 410000, x = media_global+10,
                      col = '#025930', size = 6, hjust = 0) +
    annotate('text', label = paste0("Q1: ", round(quart1_global,2)),y = 310000, x = quart1_global-60,
             col = '#d91e1e', size = 6, hjust = 0) +
    annotate('text', label = paste0("Q3: ", round(quart3_global,2)),y = 310000, x = quart3_global+10,
             col = '#d91e1e', size = 6, hjust = 0) 


###### Análise Multivariada ########
### correlação notas

df_enem %>%
    select(NU_NOTA_CH, NU_NOTA_CN, NU_NOTA_LC, NU_NOTA_MT) %>%
    drop_na() %>%
    ggpairs(title = "Análise das notas objetivas")

correlacao <- df_enem |>
    select(NU_NOTA_CN, NU_NOTA_CH, NU_NOTA_LC, NU_NOTA_MT, NU_NOTA_REDACAO) |>
    drop_na() |>
    cor()

correlacao


df_enem |>
    select(NU_NOTA_CN, NU_NOTA_CH, NU_NOTA_LC, NU_NOTA_MT, NU_NOTA_REDACAO) |>
    drop_na() |>
    cor()

corrplot.mixed(correlacao, order = "AOE")

#### notas x sexo

df_boxplot <- df_enem |>
    select(TP_SEXO, NU_NOTA_CN, NU_NOTA_CH, NU_NOTA_LC, NU_NOTA_MT, NU_NOTA_REDACAO, media) |>
    drop_na() |>
    pivot_longer(!TP_SEXO, names_to = "AREA_CONHECIMENTO", values_to = "NOTA")

ggplot(data = df_boxplot, aes(x = TP_SEXO ,y = NOTA, fill = AREA_CONHECIMENTO)) + #, y = NOTA, fill = AREA_CONHECIMENTO)) +
    geom_boxplot() +
    #geom_jitter(alpha = 0.5) +
    facet_grid(.~ AREA_CONHECIMENTO)+
    labs(title = 'Boxplot das notas ', x = '', y = '',
         subtitle = 'Média das provas objetivas, notas individuais de Ciências da Natureza, Ciências Humanas, Linguagens e Códigos, Matemática e Redação ',
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values = c("#1B418C", "#025930", "#F2E205", "#F2B705", "#D91E1E", "#CCCCCC")) +
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.x = element_text(size = 16),
          axis.title.y = element_text(size = 16),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size = 16),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 14),
          strip.text = element_text(size = 14, vjust = 0.5, hjust = .5, face = 'bold'))


base_notas <- df_enem |>
    select(TP_SEXO, NU_NOTA_CN, NU_NOTA_CH, NU_NOTA_LC, NU_NOTA_MT, NU_NOTA_REDACAO) |>
    drop_na() |>
    pivot_longer(!TP_SEXO, names_to = "AREA_CONHECIMENTO", values_to = "NOTA") |>
    filter(TP_SEXO == 'F')

psych::describeBy(base_notas$NOTA, base_notas$AREA_CONHECIMENTO)

rm(base_notas)

# considerar apenas a nota média

notas_idade <- df_enem |>
    select(media, TP_FAIXA_ETARIA, NU_NOTA_REDACAO) |>
    drop_na()

ggplot(notas_idade, aes(x = media, fill = as.factor(TP_FAIXA_ETARIA), group = as.factor(TP_FAIXA_ETARIA))) +
    geom_histogram() +
    facet_wrap(TP_FAIXA_ETARIA ~ .)


#### notas x escola
notas_escola <- df_enem |>
    select(media, TP_DEPENDENCIA_ADM_ESC, NU_NOTA_REDACAO) |>
    drop_na()

df_notas_escola_2 <- notas_escola |>
    group_by(TP_DEPENDENCIA_ADM_ESC) |>
    summarise(Mean.DA = mean(media))

(g1_dep_adm_escola <- ggplot(notas_escola, aes(x = media, after_stat(density), fill = TP_DEPENDENCIA_ADM_ESC)) +
    geom_histogram(bins = 50) +
    geom_density(alpha = .5) +
    geom_vline(aes(xintercept = mean(media)), col = "#D91E1E", size = 1., linetype = "dotdash") +
        geom_vline(data = df_notas_escola_2, aes(xintercept = Mean.DA), col = "black", size = 1.5, linetype = "dotdash") +
        geom_label(data = df_notas_escola_2, aes(label = paste0("A média da categoria\né: ", round(Mean.DA, 2))
                                                 ), inherit.aes = FALSE,
                   x = 150, y = 0.0055) +
    facet_wrap(TP_DEPENDENCIA_ADM_ESC~.) +
    labs(title = 'Histograma da Nota Média das Provas Objetivas por Dependência Adm da Escola', x = 'Nota', y = 'Proporção',
         subtitle = paste0('A média global é: ', round(Media_global, 2)),
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values = c("#1B418C", "#F2B705", "#025930", "#CCCCCC")) +
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.x = element_text(size = 16),
          axis.title.y = element_text(size = 16),
          axis.text.y = element_text(size = 16),
          axis.text.x = element_text(size = 16),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 16),
          strip.text = element_text(size = 14, vjust = 0.5, hjust = .5, face = 'bold')))


g1_dep_adm_escola + annotate('text', x = 150, y = 0.007,
                             label = paste0("A média global é :", round(Media_global,2)), col = "#D91E1E", ) +
    annotate("text", )


(g1_dep_adm_escola_quant <- ggplot(notas_escola, aes(x = media, fill = TP_DEPENDENCIA_ADM_ESC)) +
        geom_histogram(bins = 50) +
        geom_density(alpha = .5) +
        geom_vline(aes(xintercept = mean(media)), col = "#D91E1E", size = 1., linetype = "dotdash") +
        geom_vline(data = df_notas_escola_2, aes(xintercept = Mean.DA), col = "black", size = 1.5, linetype = "dotdash") +
        geom_label(data = df_notas_escola_2, aes(label = paste0("A média da categoria\né: ", round(Mean.DA, 2))
        ), inherit.aes = FALSE,
        x = 50, y = 45000) +
        facet_wrap(TP_DEPENDENCIA_ADM_ESC~.) +
        labs(title = 'Histograma da Nota Média das Provas Objetivas por Dependência Adm da Escola', x = 'Nota', y = 'Proporção',
             subtitle = paste0('A média global é: ', round(Media_global, 2)),
             caption = 'Fonte: Enem 2022') +
        scale_fill_manual(values = c("#1B418C", "#F2B705", "#025930", "#CCCCCC")) +
        theme_ipsum() +
        theme(legend.position = 'none',
              legend.title = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.background = element_blank(),
              axis.title.x = element_text(size = 16),
              axis.title.y = element_text(size = 16),
              axis.text.y = element_text(size = 16),
              axis.text.x = element_text(size = 16),
              plot.title = element_text(size = 22),
              plot.title.position = "plot",
              plot.caption = element_text(size = 16),
              strip.text = element_text(size = 14, vjust = 0.5, hjust = .5, face = 'bold')))


#### notas x treineiro

df_treineiro <- df_enem |>
    select(media, NU_NOTA_REDACAO, IN_TREINEIRO) |>
    drop_na()

psych::describeBy(df_treineiro$media, df_treineiro$IN_TREINEIRO)

ggplot(df_treineiro, aes(x = as.factor(IN_TREINEIRO), y = media, fill = IN_TREINEIRO)) +
    geom_boxplot(alpha = 0.7) +
    labs(title = 'Notas Médias x Treineiro', x = 'É TREINEIRO?', y = 'Nota Média',
         caption = 'Fonte: Enem 2022') +
    scale_fill_manual(values = c("#1B418C", "#F2B705", "#025930", "#CCCCCC")) +
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.x = element_text(size = 16),
          axis.title.y = element_text(size = 16),
          axis.text.y = element_text(size = 16),
          axis.text.x = element_text(size = 16),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 16),
          strip.text = element_text(size = 14, vjust = 0.5, hjust = .5, face = 'bold'))

### q1 e q2
# prop <- (prop.table(table(df_enem$Q001, df_enem$Q002))*100)
# 
# ggplot(as.data.frame(prop), aes(x = Var1, y = Var2, fill = Freq)) +
#     geom_tile()


## q006
df_q006 <- df_enem |>
    select(Q006, media, NU_NOTA_REDACAO) |>
    drop_na()

df_q006$Q006 <- factor(df_q006$Q006,levels =  c('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q'),
                       labels=c('Nenhuma Renda','Ate R$ 1.212,00','Ate R$ 1.818,00.',
                                'Ate R$ 2.424,00.','Ate R$ 3.030,00.',
                                'Ate R$ 3.636,00.','Ate R$ 4.848,00.',
                                'Ate R$ 6.060,00.','Ate R$ 7.272,00.',
                                'Ate R$ 8.484,00.','Ate R$ 9.696,00.',
                                'Ate R$ 10.908,00.','Ate R$ 12.120,00.',
                                'Ate R$ 14.544,00.','Ate R$ 18.180,00.',
                                'Ate R$ 24.240,00.','Acima de R$ 24.240,00.'))

nota_mediana <- median(df_q006$media)

(g1_renda <- ggplot(df_q006, aes(y = media, fill = Q006, group = Q006)) +
    geom_boxplot(alpha = 0.7, col = "black") +
    #geom_hline(yintercept = nota_mediana) +
    facet_grid(.~Q006, switch = "x") +
    geom_hline(yintercept = nota_mediana, col = "firebrick", size = 1., linetype = "dotdash") +
    labs(title = 'Notas por Faixa de Renda', x = 'Faixa', y = 'Nota Média',
         subtitle = paste0("Importante: Onde se lê 'Até', considerar do valor anterior até o valor apresentado\n","A mediana (em vermelho) é de: ", round(nota_mediana, 2)),
         caption = 'Fonte: Enem 2022') +
    scale_y_continuous(breaks = seq(0, 1000, 150), limits = c(0, 1001)) +
    scale_fill_manual(values = c(rep("#CCCCCC", 25))) +
    theme_ipsum() +
    theme(legend.position = 'none',
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_text(size = 16),
          axis.text.y = element_text(size = 16),
          axis.text.x = element_blank(),
          plot.title = element_text(size = 22),
          plot.title.position = "plot",
          plot.caption = element_text(size = 16),
          strip.text = element_text(size = 12, angle = 90, vjust = 0.5, hjust = .5)))

g1_renda + annotate("text", x = -1, y = 900, hjust = 0, label = paste0("A mediana é de: ", round(nota_mediana, 2)), col = "firebrick") + coord_cartesian(ylim = c(0, 900), clip = "off")

#### q6