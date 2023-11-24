function [rp,up,y,u]=fileLOTW(fileID)
global Ub_exp
T = readtable(fileID);
T = sortrows(T,"Points_1");

R = T.Points_1(end);
y = T.Points_1;                         % Height from lower wall
nu = T.Laminar_Viscosity./T.Density;    % Kinematic viscosity
Ub = trapz(T.Points_1,T.Velocity_0)/R;  % Bulk velocity
U  = T.Velocity_0(end);                 % Maximum velocity
Reb = Ub*2*R./nu(1);                    % Bulk Reynold's number
u  = T.Velocity_0;                      % Velocity-x
U = T.Velocity_0(end);                  % 
ReU = U*2*R/nu(1);

%% Y plus validation

Cf = T.Skin_Friction_Coefficient_0(1);
disp(['For file' fileID ' the skin friction are:\n'])
Cf_cfd = Cf/Ub_exp^2
Cf_a = 0.079*ReU^(-0.25)

uTau = sqrt(0.5*Cf);

up = u/uTau;

nu = T.Laminar_Viscosity./T.Density;

rp = uTau*(T.Points_1)./nu;
end
