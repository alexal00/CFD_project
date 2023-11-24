%% Result verification
clear all; clc; close all;

%%
% Specify the paper used for comparisson
global Ub_exp
Re_Sudo = 6e4;
Re_Rohrig = 14e3:1e4:34e3;
Ub_exp = Re_Rohrig(2)*1.785e-5/(1.185*0.2);

fileID = 'outlet_pol.csv';

T = readtable(fileID);
T = sortrows(T,"Points_1");

R = T.Points_1(end);
y = T.Points_1;                         % Height from lower wall
mu = T.Laminar_Viscosity(1);            % Viscosity
rho = T.Density(1);                     % Fluid density
nu = T.Laminar_Viscosity./T.Density;    % Kinematic viscosity
Ub = trapz(T.Points_1,T.Velocity_0)/R;  % Bulk velocity
U  = T.Velocity_0(end);                 % Maximum velocity
Reb = Ub*2*R./nu(1);                    % Bulk Reynold's number
u  = T.Velocity_0;                      % Velocity-x

% return
u_cfd = u./U;                           % N.D inlet porfile
ReU = rho*2*R*U/mu;                     % Reynolds of the maximum velocity
Reb = rho*2*R*Ub/mu;                     % Reynolds of the maximum velocity
% power law definition
n = -1.7+1.8*log(ReU);  % exponent
u_a = (1/R.*y).^(1/n);  % power law

% Plot the prescribed profile compared with the power law results
fid = 10;
fighandle = figure(fid); fid = fid+1;
fighandle.Name = 'velprofile_inlet';
plot(1/R.*y,u_a,'k--','LineWidth',1.5,'DisplayName','Power Law'); hold on
plot(1/R.*y,u/U,'r','DisplayName','CFD','LineWidth',1.5);
grid on
legend('show')

%% LOTW
% Emprical law of the wall

k = 0.41;
C = 5.1;

rpVisc = logspace(-1,1,100);
rpLog = logspace(1,3,100);
visc = rpVisc;
ulog = (1/k)*log(rpLog) + C;

data = getrohrig2015;
C = cat(2,[rpVisc;visc],[rpLog;ulog]);
fighandle=figure(fid); fid=fid+1;
fighandle.Name = 'LOW';
semilogx(C(1,:),C(2,:),'k--','linew',1.5,'DisplayName','Power Law'); hold on
semilogx(data(:,1),data(:,2),'bo','linew',1.5,'DisplayName','R\"{o}righ et al. 2015'); hold on
ty=ylabel('$u^+$');
tx=xlabel('$y^+$');

% fig stuff
tx.Interpreter='latex';
ty.Interpreter='latex';
set(gca,'TickLabelInterpreter', 'latex');
legend("show",'Interpreter','latex','Location','northwest')
ax = gca;
xlim([1e-1 1e3]);
ylim([0 30]);
grid on
%% Y plus validation
for i =0:5
if i~=5
id = i;
else
    id =45;
end
fileID = ['x' num2str(id) 'D_pol.csv'];
[rp,up,y,u] = fileLOTW(fileID);
figure (10)
text = ['x=' num2str(id)];
plot(1/R.*y,u/U,'DisplayName',text); hold on
figure(11)
semilogx(rp, up, '-','linew',1.5,'DisplayName',text); hold on
end

%% LOTW_WF
fighandle=figure(fid); fid=fid+1;
fighandle.Name = 'LOW_WF';
semilogx(C(1,:),C(2,:),'k--','linew',1.5,'DisplayName','Power Law'); hold on
semilogx(data(:,1),data(:,2),'bo','linew',1.5,'DisplayName','R\"{o}righ et al. 2015'); hold on
ty=ylabel('$u^+$');
tx=xlabel('$y^+$');

% fig stuff
tx.Interpreter='latex';
ty.Interpreter='latex';
set(gca,'TickLabelInterpreter', 'latex');
legend("show",'Interpreter','latex','Location','northwest')
ax = gca;
xlim([1e-1 1e3]);
ylim([0 30]);
grid on
%% Y plus validation
for i =0:5
if i~=5
id = i;
else
    id =45;
end
fileID = ['x' num2str(id) 'D_polwf.csv'];
[rp,up,y,u] = fileLOTW(fileID);
figure (13)
text = ['x=' num2str(id)];
plot(1/R.*y,u/U,'DisplayName',text); hold on
figure(12)
semilogx(rp, up, '-','linew',1.5,'DisplayName',text); hold on
end


function data = getrohrig2015
data=[  1.04784     0.986577
  1.80492     1.78523
  2.58991     2.48993
  3.35606     3.28859
  4.09776     3.89933
  4.91906     4.65101
  5.68346     5.30872
  6.42862     6.01342
  8.76606     7.61074
  11.0734     9.02013
  13.5206     10.1477
  16.025     10.9463
  18.3585     11.651
  20.9427     12.2148
  23.4881     12.5906
  26.3429     13.1074
  29.6705     13.2953
  32.0284     13.6242
  36.3819     14
  40.8038     14.3758
  45.7632     14.5638
  50.6754     14.7987
  55.8769     15.1275
  61.3512     15.2685
  67.6485     15.5503
  75.8706     15.7383
  81.2071     15.9732
  89.5426     16.302
  97.4832     16.396
  106.58     16.6779
  115.54     16.9128
  127.399     17.0537
  138.697     17.3356
  149.719     17.4295
  162.305     17.7114
  179.727     18.0403
  193.187     18.1812
  210.319     18.4161
  233.886     18.8859
  257.893     19.2148
  283.158     19.4027
  317.574     19.8725
  354.663     20.1544
  397.769     20.5772
  438.598     20.7651
    ];
end
