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
path = ('C:\SEU\CAMINHO\AQUI\NomedoArquivo.csv');

% Carregar dados ignorando as 75 primeiras linhas de cabecalho
% Usa-se 'HeaderLines' para ignorar as linhas do cabecalho
data = readtable(path, 'HeaderLines', 75);
data = data(1:5890,:); % excluindo as linhas de fora dagua, serve pro ponto 08 e 13
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

% Definindo e manipulando velocidade
vel = data{:,3}/100; % a divisao por 100 transforma cm/s para m/s
% quando utiliza-se '{ }' os dados mudam de tabela para array (numero)

% Definindo e manipulando direcao
dir = data{:,4};

% Decomposicao vetorial
dm = __; % declinacao magnetica do local 
alfa = __; % grau de rotacao do canal, varia de acordo com seu ponto de coleta (fiz no google earth) | para agua parada agua = 0
teta = 90-(dir+dm)+alfa; % definindo o angulo teta pra componente u
m =(teta*pi)/180; % Transformando graus para radianos 
vel_u = vel.*cos(m); % decomposiÃ§Ã£o do vetor
vel_v = vel.*sin(m); % o v pode servir para verificar a advecao
data.Componente_u = vel_u;
data.Componente_v = vel_v;

%% Plotagem de Graficos
% Cria uma nova figura com um tamanho especifico
fig = figure(1); % Define o identificador da figura como 1
set(fig, 'Position', [100, 70, 900, 600]); % Define a posicao e o tamanho da figura [esquerda, inferior, largura, altura]

% Configuracao do primeiro subplot: (2 linhas, 3 coluna, grafico entre 1 e 2)
subplot(2,3,[1 2]) % Divide a area de plotagem em uma matriz de 2x3 e seleciona o grafico na posicao entre 1 e 2

% Plotagem da componente u da velocidade
plot(dt, vel, 'k', 'LineWidth', 1.1); % Plota a variavel vel_u ao longo do tempo dt em preto ('k') com largura de linha de 1.1

% Adiciona o rotulo do eixo y
ylabel('Velocidade (m/s)', 'FontName', 'Times New Roman', 'FontSize', 14); % Define o texto e o formato do rotulo do eixo y

% Define os limites do eixo y
ylim([0 0.1]); % Define o intervalo dos valores do eixo y

% Define os limites do eixo x
xlim([min(dt) max(dt)]); % Define o intervalo dos valores do eixo x

% Adiciona o titulo ao grafico
title('Velocidade x Direção da Corrente', 'FontName', 'Times New Roman', 'FontSize', 18); % Define o titulo e o formato

% Formata o eixo x para exibir as datas
datetick('x', 'dd/mm/yy HH:MM', 'keepticks'); % Ajusta o formato do eixo x para datas e horas, mantendo os ticks existentes

% Ajusta a fonte dos numeros dos eixos
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12); % Define a fonte e o tamanho dos nÃºmeros dos eixos

% Adiciona linhas de grade menores para melhor visualizacao
grid minor;

% Configuracao do segundo subplot: (2 linhas, 3 coluna, grafico entre 4 e 5)
subplot(2,3,[4 5]) % Seleciona o grafico na posicao 2

% Plotagem da direcao
plot(dt, dir, 'k*', 'MarkerSize', 4); % Plota a variÃ¡vel dir ao longo do tempo dt em preto ('k*') com marcadores de tamanho 4

% Adiciona o rotulo do eixo y
ylabel('Direção (graus)', 'FontName', 'Times New Roman', 'FontSize', 18); % Define o texto e o formato do rotulo do eixo y

% Define os limites do eixo y
ylim([-1 361]); % Define o intervalo dos valores do eixo y

% Define os limites do eixo x
xlim([min(dt) max(dt)]); % Define o intervalo dos valores do eixo x

% Adiciona o rotulo do eixo x
xlabel('Tempo (dia/mês/ano hora:minuto)', 'FontName', 'Times New Roman', 'FontSize', 18); % Define o texto e o formato do rotulo do eixo x

% Formata o eixo x para exibir as datas
datetick('x', 'dd/mm/yy HH:MM', 'keepticks'); % Ajusta o formato do eixo x para datas e horas, mantendo os ticks existentes

% Ajusta a fonte dos numeros dos eixos
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12); % Define a fonte e o tamanho dos numeros dos eixos

% Adiciona linhas de grade menores
grid minor; % Adiciona linhas de grade menores para melhor visualizacao

% Configuracao do segundo subplot: (2 linhas, 3 coluna, grafico entre 3 e 6)
subplot(2,3,[3 6]) % Seleciona o grafico na posicao 
compass(vel_u,vel_v,'k')
view(90,-90)

% Salva a figura como um arquivo PNG
saveas(fig, 'vel_dir.png', 'png'); % Salva a figura com o nome 'vel_dir.bmp' no formato PNG

%% FIM DO SCRIPT
