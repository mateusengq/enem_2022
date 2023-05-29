## Pacotes

if(!require(data.table)){install.packages('data.table')}
if(!require(tidyverse)){install.packages('tidyverse')}
library(hrbrthemes)
library(kableExtra)
library(ggtext)

cores <- c('#1B418C','#025930', '#F2E205', '#F2B705', '#D91E1E', '#CCCCCC')

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

