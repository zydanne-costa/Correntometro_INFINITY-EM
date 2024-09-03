%==========================================================================
% SCRIPT DE PROCESSAMENTO DE DADOS DE CORRENTE
%--------------------------------------------------------------------------
% Autor: Zydanne Costa
% Data: 02 de setembro de 2024
% Análise de Dados de Correntes - Correntometro JFE Advantech
% Descricao: Este script e destinado ao tratamento e visualizacao dos dados 
% adquiridos de um correntometro eletromagnetico JFE Advantech. Os dados 
% incluem informações sobre direção e velocidade das correntes. O script 
% realiza a importacao, manipulacao e plotagem dos dados de forma detalhada 
% e visualmente clara.
%--------------------------------------------------------------------------
clear all; clc;
%==========================================================================

%% Carregando os dados
% Definindo o caminho da pasta com os dados brutos
path = ('C:\SEU\CAMINHO\AQUI\NomeDoArquivo');

% Carregar dados ignorando as 75 primeiras linhas de cabecalho
% Usa-se 'HeaderLines' para ignorar as linhas do cabecalho
data = readtable(path, 'HeaderLines', 75);
% Manter apenas as colunas de 1 a 3 (data+hora, velocidade, direcao)
data = data(:, 1:3);
% Definindo a variavel tempo
dt = datetime(data{:,1}, 'InputFormat', 'yyyy/MM/dd HH:mm:ss');
% Separando data
date = dateshift(dt, 'start', 'day');
% Separando hora
time = timeofday(dt);
% Incluindo data e hora em 'data'
data.Data = dateshift(dt, 'start', 'day');
data.Hora = timeofday(dt);       
% Excluir a primeira coluna
data(:, 1) = [];  % Remove a primeira coluna
% Reorganizar as colunas: Colocar as duas ultimas colunas na frente
data = data(:, [3, 4, 1, 2]);  % Move as colunas 3 e 4 para as primeiras posicoes

% Manipulando velocidade
vel = data{:,3}/100; % a divisao por 100 transforma cm/s para m/s
% quando utiliza-se '{ }' os dados mudam de tabela para array (numero)

% Manipulando direcao
dir = data{:,4};
% Decomposicao vetorial
dm = ___; % declinacao magnetica do local 
alfa = ___; % grau de rotação do canal, varia de acordo com seu ponto de coleta (fiz no google earth)
teta = 90-(dir+dm)+alfa; % definindo o angulo teta pra componente u
m =(teta*pi)/180; % Transformando graus para radianos 
vel_u = vel.*cos(m); % decomposição do vetor
vel_v = vel.*sin(m); % o v pode servir para verificar a advecção
data.Componente_u = vel_u;
data.Componente_v = vel_v;

%% Plotagem de Gráficos
% Cria uma nova figura com um tamanho especifico
fig = figure(1); % Define o identificador da figura como 1
set(fig, 'Position', [100, 70, 900, 600]); % Define a posicao e o tamanho da figura [esquerda, inferior, largura, altura]

% Configuracao do primeiro subplot: (2 linhas, 1 coluna, grafico 1)
subplot(2,1,1) % Divide a area de plotagem em uma matriz de 2x1 e seleciona o grafico na posicao 1

% Plotagem da componente u da velocidade
plot(dt, vel_u, 'k', 'LineWidth', 1.1); % Plota a variavel vel_u ao longo do tempo dt em preto ('k') com largura de linha de 1.1

% Adiciona o rotulo do eixo y
ylabel('Velocidade (cm/s)', 'FontName', 'Times New Roman', 'FontSize', 14); % Define o texto e o formato do rotulo do eixo y

% Define os limites do eixo y, se necessario
% ylim([-5 70]); % Define o intervalo dos valores do eixo y

% Adiciona o titulo ao grafico
title('Velocidade x Direção da Corrente', 'FontName', 'Times New Roman', 'FontSize', 18); % Define o titulo e o formato

% Formata o eixo x para exibir as datas
datetick('x', 'dd/mm/yy HH:MM', 'keepticks'); % Ajusta o formato do eixo x para datas e horas, mantendo os ticks existentes

% Ajusta a fonte dos numeros dos eixos
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12); % Define a fonte e o tamanho dos números dos eixos

% Adiciona linhas de grade menores para melhor visualizacao
grid minor;

% Configuracao do segundo subplot: (2 linhas, 1 coluna, gráfico 2)
subplot(2,1,2) % Seleciona o grafico na posicao 2

% Plotagem da direcao
plot(dt, dir, 'k*', 'MarkerSize', 4); % Plota a variável dir ao longo do tempo dt em preto ('k*') com marcadores de tamanho 4

% Adiciona o rotulo do eixo y
ylabel('Direção (graus)', 'FontName', 'Times New Roman', 'FontSize', 18); % Define o texto e o formato do rotulo do eixo y

% Define os limites do eixo y, se necessario
% ylim([-1 361]); % Define o intervalo dos valores do eixo y

% Adiciona o rotulo do eixo x
xlabel('Tempo (dia/mês/ano hora:minuto)', 'FontName', 'Times New Roman', 'FontSize', 18); % Define o texto e o formato do rotulo do eixo x

% Formata o eixo x para exibir as datas
datetick('x', 'dd/mm/yy HH:MM', 'keepticks'); % Ajusta o formato do eixo x para datas e horas, mantendo os ticks existentes

% Ajusta a fonte dos numeros dos eixos
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12); % Define a fonte e o tamanho dos numeros dos eixos

% Adiciona linhas de grade menores
grid minor; % Adiciona linhas de grade menores para melhor visualizacao

% Salva a figura como um arquivo BMP
saveas(fig, 'vel_dir.png', 'png'); % Salva a figura com o nome 'vel_dir.bmp' no formato PNG

%% FIM DO SCRIPT
