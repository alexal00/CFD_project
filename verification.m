clear all; clc; close all;
%%
% Specify the paper used for comparisson
Re_Sudo = 6e4;
Re_Rohrig = 14e3:1e4:34e3;
global Ub_exp Rc q
Ub_exp = Re_Rohrig(2)*1.785e-5/(1.185*0.2);

D = 0.2;
Rc = 1.58*D;
Ri = 1.08*D;
Ro = 2.08*D;
rho = 1.885;

q = 0.5*rho*Ub_exp^2;

% data from lower wall
L = readtable("lower.csv");
[s_barLf,cpLf,cfLf]=dataanalize(L,Ri,Ri);
% upper wall
U = readtable("upper.csv");
[s_barUf,cpUf,cfUf]=dataanalize(U,Ri,Ro);

% data from lower wall
L = readtable("lower_coarse.csv");
[s_barLc,cpLc,cfLc]=dataanalize(L,Ri,Ri);
% upper wall
U = readtable("upper_coarse.csv");
[s_barUc,cpUc,cfUc]=dataanalize(U,Ri,Ro);

fid = 1;
fighandle= figure(fid);fid = fid+1;
fighandle.Name = "Cp";
plot(s_barLf,cpLf,'DisplayName','Lower fine'); hold on
plot(s_barUf,cpUf,'DisplayName','Upper fine'); hold on
plot(s_barLc,cpLc,'DisplayName','Lower coarse'); hold on
plot(s_barUc,cpUc,'DisplayName','Upper coarse'); hold on
xlabel('$\bar{s}$','Interpreter','latex')
ylabel('$c_p$','Interpreter','latex')
legend('show')
grid on


figure(fid); fid = fid+1; 
plot(s_barLf,cfLf,'DisplayName','inner fine'); hold on
plot(s_barLc,cfLc,'DisplayName','inner coarse'); hold on
xlabel('\={s}','Interpreter','latex')
ylabel('$c_f$','Interpreter','latex')
legend('show')
grid on

figure (fid)
plot(s_barUf,cfUf,'DisplayName','outter fine'); hold on
plot(s_barUc,cfUc,'DisplayName','outter coarse'); hold on
xlabel('\={s}','Interpreter','latex')
ylabel('$c_f$','Interpreter','latex')
legend('show')

grid on
