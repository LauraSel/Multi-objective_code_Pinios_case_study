function [SQ] = check_SQ(x)


%% Sto considerando l'area DELTA e CC = 1:
k0 = 25 ;%* 1e6;
k1 = 37 ;%* 1e6;
C = 1;
k2 = 1;
k3 = -0.005;
k4 = 2723.93;%20000;
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
k16 = 0.8;%0;
k17 = 0.042;% * 1e6;
k18 = 0;
k20 = 0.5;
k21 = 0;
k22 = [43,43,52,250,43,8,112,43,43,220]; %dipende anche da nutrient...%1e-5*
k23 = 0.5;
k24 = [1000,1000,706.9,398.9,50.6,863,70.8,112.7,596,136.3];%1e5*
k25 = [45,45,101,201,110,28,84,89,45,168]; %dipende anche da nutrient...%1e-5*
k26 = 1/1.1;
k27 = 0.5;
k28 = 0.5;
k29 = [1.7, 12.7, 706.9, 398.9, 50.6, 863, 70.8, 112.7, 596, 136.3]; %Initial crops area 1e5*1e5*

%Vincolo sul fertilizzante:
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
    capil = k19 .* k13 .* aa; %(gli scalari li ho separati) 

% aa sum / Initial crop area sum
    rapp = a/sum(k24);

% rapp2:
    rapp2 = (rate .* aa)/a;



gwa_t = k0;
gwa = k0;


T=360;
SQ = zeros(1, T);
SQdr = zeros(1, T);
SE = zeros(1, T);
SOM = zeros(1, T);
GWa = zeros(T);
gwa_ir= zeros(T);
gwa_dr = zeros(T);
gw_outflow = zeros(T);

SE(1) = k23;
SQ(1) = k20;


%% In un anno (12 mesi):
for t=2:T


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
    % 
    % if gwa_t > k1
    %     GWA_ir = 0;
    % else 
    %     GWA_ir = x(1)*k2*(1+(C*k3)/12);
    % 
    % 
    % end
    % 
    % if gwa_t > k1
    %    outflow = gwa_t - k1;
    % else
    %     outflow = 0;
    % end
    % 
    % other(t) = k17(1-k18);
    % irrigation(t) = k10*sum(irr_wu)*(1-k16);
    % outflowvec(t) = outflow;
    % fluct(t) = k10;
    % drinking(t) = ((1+x(2))*k4*k5*k6*k7)*(1-k8);
    % capillarity(t) = k6*k10*sum(capil);
    % gwdemand(t) = drinking(t)+ irrigation(t)+ other(t);
    % GWA_dr = (((1+x(2))*k4*k5*k6*k7)*(1-k8)+ k10*sum(irr_wu)*(1-k16)+ k17(1-k18))+ k6*k10*sum(capil)+outflow;
    % gwa_ir(t)=GWA_ir;
    % gwa_dr(t)=GWA_dr;
    % gwa_t = GWA_ir - GWA_dr;
    % gwa = gwa_t + gwa;
    % GWa(t) = gwa;
    % 
    % gwa_t =gwa;

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
    SOM(t) = ((1-NloadArea) + (x(6)+x(4))*(t/360))*1/3;
    SQir(t) = SQ(t)*0.005 * (x(8)+SOM(t))/2;
    if SQ(t) <1
        SQdr(t) = SQ(t-1)*0.001*(NloadArea + C+(1-SOM(t)) + SE(t)/4)*rapp;
    else 
        SQdr(t) = 0;
    end
    SQ(t) = SQ(t-1) +SQir(t) -SQdr(t);

    

end

end