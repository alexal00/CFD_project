function [s_bar,cp,cf] = dataanalize(U,R1,R2)
global Ub_exp Rc q
cf_U = (U.Skin_Friction_Coefficient_0.^2+U.Skin_Friction_Coefficient_1.^2).^0.5./Ub_exp^2;
connectivityU = zeros(length(U.Points_0),5);
connectivityU(:,[1 2])= [U.Points_0, U.Points_1];
connectivityU(:,[4 5])= [U.Pressure, cf_U];
for ii=1:length(U.Points_0)
    if U.Points_0(ii)<=0.2*4.5
        connectivityU(ii,3)=1;
    elseif U.Points_1(ii)<=-0.216
        connectivityU(ii,3)=3;  
    else
        connectivityU(ii,3)=2;
    end
end

connectivityU = sortrows(connectivityU,3);
inlet = sortrows(connectivityU(connectivityU(:,3)==1,[1 2 4 5]),1);
Li = inlet(end,1);
outlet = sortrows(connectivityU(connectivityU(:,3)==3,[1 2 4 5]),2,'descend');
elbow = sortrows(connectivityU(connectivityU(:,3)==2,[1 2 4 5]),1);
% points = [L.Points_0,L.Points_1];
si = (inlet(:,1)-Li)./Rc;
cp1_data = (inlet(:,3)-inlet(1,3))./(q);
iu_cfdata = inlet(:,4);


so = abs(outlet(:,2)+R1)./Rc;
cp3_data = (outlet(:,3)-inlet(1,3))./(q);
ou_cfdata = outlet(:,4);


elbow2 = [elbow(:,1)-Li,elbow(:,2)+R1];
theta = pi/2-acos(elbow2(:,1)./R2);
se2 = theta./(pi/2);
% eu_cpdata = U.Pressure_Coefficient(ve);
cp2_data = (elbow(:,3)-inlet(1,3))./(q);
eu_cfdata = elbow(:,4);

s_bar=[si;si(end)+se2;se2(end)+so];
cp=[cp1_data;cp2_data;cp3_data];
cf = [iu_cfdata;eu_cfdata;ou_cfdata];
end