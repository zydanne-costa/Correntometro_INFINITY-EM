clear all, clc;
%
%% CORRENTOMETRO PRAIA GRANDE
dados = load('pg.txt');
vel_cm = dados(:,3);
vel = vel_cm/100; % transformando de cm/s para m/s
clear vel_cm;
dir = dados(:,4);
%
%% DECOMPOSICAO VETORIAL
dm = -19.48; % declinacao magnetica
alfa = 30; % grau de rotação
teta = 90-(dir+dm)+alfa; % definindo o angulo teta pra componente u
m = (teta*pi)/180; % Transformando graus para radianos 
vel_u = vel.*cos(m); % decomposição do vetor
vel_v = vel.*sin(m); % o v pode servir para verificar a advecção
%
%% TEMPO
t = readtable('time.txt','ReadVariableNames',false);
t = table2cell(t);
t = datenum(t);
S = datestr(t,'HH:MM:SS');
%
%% PLOT 1
figure(1)
plot(t,vel_u,'b');
title('Velocidade da Corrente','fontsize',16);
xlabel('Tempo (horas)','fontsize',14);
ylabel('m/s','fontsize',14);
datetick;
%
%% PLOT DIREÇÃO
figure(2)
plot(t,dir,'b*');
xlabel('Tempo');
ylabel('Graus')
datetick;
%
%% PLOT VEL-DIR
figure(3)
subplot(211)
plot(t,vel_u,'b','LineWidth',1);
title('Velocidade da Corrente','fontsize',16);
ylabel('m/s','fontsize',16);
ylim([-0.6 0.6])
datetick;
grid on;
subplot(212)
plot(t,dir,'b^')
title('Direção da Corrente','fontsize',16);
ylabel('Graus','fontsize',16);
xlabel('Tempo (horas)','fontsize',16);
ylim([-40 400])
datetick;
grid on;
saveas(gcf,'vel-dir-praiagrande.png') % salvando a imagem como .png no diretório
%
%%
figure(5)
compass(vel_u,vel_v,'r')
view(90,89)
%% FIM %%