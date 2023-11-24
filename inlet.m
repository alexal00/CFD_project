%% Result verification
clear all; close all; clc
%% Inlet profile definiton

% Velocity profile at the inlet
% import data from paraview for the output of the straight channel
T1 = readtable("outlet_pol_coarse.csv");
R = T1.Points_1(end);
y = T1.Points_1;                         % Height from lower wall
mu = T1.Laminar_Viscosity(1);            % Viscosity
rho = T1.Density(1);                     % Fluid density
nu = T1.Laminar_Viscosity./T1.Density;    % Kinematic viscosity
Ub_cfd = trapz(T1.Points_1,T1.Velocity_0)/(R);  % Bulk velocity
U  = T1.Velocity_0(end);                 % Maximum velocity
Reb = Ub_cfd*2*R./nu(1);                    % Bulk Reynold's number

% Specify the paper used for comparisson
Re_Sudo = 6e4;
Re_Rohrig = 14e3:1e4:34e3;
Ub_exp = Re_Rohrig(2)*1.785e-5/(1.185*0.2);

err = abs(Ub_exp-Ub_cfd)/Ub_exp*100;

if err<1

else
    warning("The associated error of the bulk velocity is higher than 1%, rerun simulations")
    return
end

T = readtable("outlet_coarse.csv");
% Ub = trapz(T.Points_1,T.Velocity_0)/R;  % Bulk velocity
% overwrite the bulk velocity value
Ub = 8.7;
addata = 'yes';
if strcmp(addata,'no')
A=[0.0*ones(size(T.Points_0)),T.Points_1,300.0*ones(size(T.Points_0)),Ub.*T.Velocity_0./Ub_exp,1.0*ones(size(T.Points_0)),0.0*ones(size(T.Points_0))];
else
% Data including TKE and Dissipation
A=[0.0*ones(size(T.Points_0)),T.Points_1,300.0*ones(size(T.Points_0)),Ub.*T.Velocity_0./Ub_exp,1.0*ones(size(T.Points_0)),0.0*ones(size(T.Points_0)),T.Turb_Kin_Energy,T.Omega];
end
% Set formatting for the matrices
A = double(A);
% Order from lowest to highest y coordinate
B = sortrows(A,2);

% Plot the veloctiy profile in the inlet
figure
plot(B(:,4),B(:,2)./T.Points_1(end),'LineWidth',1.5);
grid on
ylabel('$y/D$','Interpreter','latex')
xlabel('$V_x$','Interpreter','latex')

%% file formatting and wirtting
fileID  = fopen('inlet_coarse.dat','w');
fprintf(fileID,'NMARK= 1\n');
fprintf(fileID,'MARKER_TAG= inlet\n');
fprintf(fileID,'NROW=%i\n',size(B,1));
fprintf(fileID,'NCOL=%i\n',size(B,2));
fprintf(fileID,'# COORD-X               COORD-Y                 TEMPERATURE             VELOCITY                NORMAL-X                NORMAL-Y\n');
if strcmp(addata,'no')
fprintf(fileID,'%8d \t %8d \t %6d \t %6d \t %6d \t %6d\n',B');
else
fprintf(fileID,'%8d \t %8d \t %6d \t %6d \t %6d \t %6d \t %6d \t %6d\n',B');
end
fclose(fileID);