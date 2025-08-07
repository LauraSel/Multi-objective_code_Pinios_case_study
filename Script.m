%% %% CODE 22-10-2023 %% %%

%% variables:
% x1: GW recharge rate
% x2: Loss rate drinking
% x3: S2 Irrigation programming
% x4: S1 Mulching
% x5: Innovation in agricultural practice
% x6: Farmers' training
% x7: Irrigation efficiency
% x8: Landuse
% x9: Access to funding
% x10: Development of consortia

clear all

%% Setting delle costanti e dei bounds:
lb = [0,0,0,0,0,0,0,0,0,0];  
ub = [1,1,1,1,1,1,1,1,1,1]; 

fun = @obj_fun2;
opts_ps = optimoptions('paretosearch','Display','off','PlotFcn','psplotparetof');
rng default % For reproducibility

%% PS
npts = 120;
opts_ps.ParetoSetSize = npts;
[x_ps2,fval_ps2,~,psoutput2] = paretosearch(fun,10,[],[],[],[],lb,ub,[],opts_ps);
disp("Total Function Count: " + psoutput2.funccount);

%% GAs
npts_ga = 120; 
opts_ga = optimoptions('gamultiobj','Display','off','PlotFcn','gaplotpareto','PopulationSize',npts_ga);
[x_ga1,fval_ga1,~,gaoutput1] = gamultiobj(fun,10,[],[],[],[],lb,ub,[],opts_ga);
disp("Total Function Count: " + gaoutput1.funccount);


%% f1 vs f2 vs f3
figure
fps2 = sortrows(-fval_ps2,1,'ascend');
plot3(fps2(:,1),fps2(:,2),fps2(:,3),'o')
hold on
fga = sortrows(-fval_ga1,1,'ascend');
plot3(fga(:,1),fga(:,2),fga(:,3),'o')
legend('paretosearch','gamultiobj', 'FontSize', 12)
grid on
xlabel('Groundwater Availability', 'FontSize', 14);
ylabel('Soil quality', 'FontSize', 14); 
zlabel('Average Agricultural Sustainability','FontSize', 14);
title('GWA VS SQ VS AAS', 'FontSize', 16)
hold off


%% Control figures
x = zeros(1,10);
x(1) = 0.87;
x(2) = 0.3;
x(3) = 0;
x(4) = 0;
x(5)= 0;
x(6) = 0;
x(7) = 0.65;
x(8) = 0.5;
x(9)= 0.1;
x(10)= 0.2;
[GWa,gwa_ir,gwa_dr,demand] = check_GWA(x);
[SQ] = check_SQ(x);
[AAS] = check_AAP(x, GWa(:,1), SQ);
figure
plot(GWa(:,1))
title('Groundwater availability') 
xlabel('months')    
ylabel('GWA Mm3')
xlim([0, 360]) 
print('GWA_beha', '-dtiff', '-r300');

figure
plot(SQ)
title('Soil quality') 
xlabel('months')    
ylabel('SQ percentage')   
xlim([0, 360]) 
print('SQ_beha', '-dtiff', '-r300');

figure
plot(AAS)
title('Average agricultural sustainability') 
xlabel('months')    
ylabel('AAS percentage') 
xlim([0, 360]) 
print('AAS_beha', '-dtiff', '-r300');


%% HEATMAP 
set(gcf, 'Position', [100, 100, 1000, 800]);
heatmap(x_ga1);
xlabel('Variables');
ylabel('Solutions');
print('heatmap2', '-dtiff', '-r300');

heatmap(x_ps2);
xlabel('Variables');
ylabel('Solutions');
print('heatmap1', '-dtiff', '-r300');