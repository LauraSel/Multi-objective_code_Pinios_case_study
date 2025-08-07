function F = obj_fun2(x)

%% DELTA area e CC = 1:
k0 = 25 ;
k1 = 37 ;
C = 1;
k2 = 1;
k3 = -0.005;
k4 = 2723.93;
k5 = 9;
k6 = 1e-6;
k8 = 0;
k9 = 1.06;
k11 = [0,0,0,0,0,0,0,0,0.176,0];
k12 = [0,0,0,0,0,0,0,0,0.05,0];
k13 = [4200,4200,0,4813,3300,4903,2650,1130,10462,3662];%1e-5*
k19 = [0,0,0.51,0.55,0.51,0.55,1,0.51,0,0.51];
k14 = 0.88* k19;
k15 = 0;
k16 = 0.8;
k17 = 0.042;
k18 = 0;
k20 = 0.5;
k21 = 0;
k22 = [43,43,52,250,43,8,112,43,43,220]; 
k23 = 0.5;
k24 = [1000,1000,706.9,398.9,50.6,863,70.8,112.7,596,136.3];
k25 = [45,45,101,201,110,28,84,89,45,168]; 
k26 = 1/1.1;
k27 = 0.5;
k28 = 0.5;
k29 = [1.7, 12.7, 706.9, 398.9, 50.6, 863, 70.8, 112.7, 596, 136.3]; 


%Fertilizer constraint:
rate=zeros(1,10);
for i=1:10
    if (k22(i)*(1- 0.2*x(6)+0.2*k21-0.1*x(8)))/k25(i) > 1
        rate(i) = 1;
    else
        rate(i) = (k22(i)*(1- 0.2*x(6)+0.2*k21-0.1*x(8)))/k25(i);
    end
end

% aa: agricultural areas[crop]
aa = k29;   
a = sum(aa);

% irr_wu: irrigation water use
scal_irr_wu = (k9*(1-0.15*x(5)-0.05*k15-0.15*x(6))*(2-x(7))*k6); 
irr_wu = scal_irr_wu*aa.*(1-x(3)*k11+x(4)*k12).*k13.*(1-k14);

% capil: capillarity rise - volume
capil = k19 .* k13 .* aa;  

% aa sum / Initial crop area sum
rapp = a/sum(k24);

% rapp2:
rapp2 = (rate .* aa)/a;

GWa = k0;
gwa_t = k0;
SE = k23;
SQ = k20;


T=120;

%% One year (12 months)
for t=1:T
    mese = mod(t - 1, 12) + 1;
    
    switch mese
        case 1
            k10 = 0;
            k7 = 1;
        case 2
            k10 = 0;
            k7 = 1;
        case 3
            k10 = 0;
            k7 = 1;
        case 4
            k10 = 0;
            k7 = 1;
        case 5
            k10 = 0.07;
            k7 = 1;
        case 6
            k10 = 0.2;
            k7 = 2.25;
        case 7
            k10 = 0.3;
            k7 = 2.25;
        case 8
            k10 = 0.3;
            k7 = 2.25;
        case 9
            k10 = 0.13;
            k7 = 1;
        case 10
            k10 = 0;
            k7 = 1;
        case 11
            k10 = 0;
            k7 = 1;
        case 12
            k10 = 0;
            k7 = 1;
    end

    
%% GW Availability - OBJECTIVE 1
    
    if gwa_t <= k1
        GWA_ir = x(1)*k2*(1+(C*k3)/12);
        outflow = 0;
    else 
        GWA_ir = 0;
        outflow = gwa_t - k1;
    end
    
    GWA_dr = (((1+x(2))*k4*k5*k6*k7)*(1-k8)+ k10*sum(irr_wu)*(1-k16)+ k17(1-k18))+ k6*k10*sum(capil)+outflow;
    gwa_t = GWA_ir - GWA_dr;
    GWa = gwa_t + GWa;
     
    gwa_t =GWa;
    
%% Soil Erotion 
    if SE>1
        SE = SE -(0.001 *(x(4)+x(8)+x(6))*(1/3));
    elseif SE>0
        SE = SE + 0.001*(rapp +C + (1-x(6))+(1-x(8)))*(1/4);
    else
        SE = SE + 0.001*(rapp +C + (1-x(6))+(1-x(8)))*(1/4)-(0.001 *(x(4)+x(8)+x(6))*(1/3));
    end
    
%% SW quality - OBJECTIVE 2
    NloadArea = (1-0.22*x(4)*t/360)*sum(rapp2);
    SOM = ((1-NloadArea) + (x(6)+x(4))*(t/360))*1/3;
    SQir = SQ*0.005 * (x(8)+SOM)/2;
    if SQ <1
        SQdr = SQ*0.001*(NloadArea + C+(1-SOM) + SE/4)*rapp;
    else 
        SQdr = 0;
    end
    SQ = SQ +SQir -SQdr;
    
    
    %% Average agricultural sustainability (AAS):
    nload = (k22./k25)*(1-0.2*x(6)-0.2*k21-0.1*x(8));
    % Agricultural productivity:
    AP = ones(1,10) *(k26*(SOM + x(5) + x(6)*t/360 +SQ)*(1/4));
    % Crop profitability:
    CP = k27*(1+ 0.2*k28 - 0.4*(ones(1,10)-nload)); 
    scal = 1+0.3*x(9)-0.12*(1-x(8))-0.5*(0.6*((1-k16)*(1-GWa/k1) + (1-x(7))-x(3))*(1/3) + 0.2*(1-x(10))+0.2*(1-x(6)))*(1/3);
    %Agricultural sustainability:
    AS = 0.5*(AP + CP*scal);
    % Average agricultural sustainability
    AAS = (1/10)*sum(AS);
end
f1 = -GWa;
f2 = -(SQ);
f3 = -(AAS);

%%
F = [f1,f2,f3]';
end