clear;
clc;

%****************************
number_instance = 240;
%****************************

Instance_Index = [1:number_instance];

load('InstanceAnalysis.mat');
load('CostAnalysis.mat');

Gamma_sort = sortrows([Gamma,Instance_Index']);
Small_Gamma_ind = Gamma_sort(1:number_instance/2,2);               % fisrt 120 gamma
Large_Gamma_ind = Gamma_sort(number_instance/2+1:number_instance,2);             % last 120 gamma

type_collection = cell(1,2);
type_collection{1} = 'RN';
type_collection{2} = 'D';


% ********* one-way ANOVA *********
P_Value_N = zeros(8,1);
P_Value_Gamma = zeros(8,1);
Mu_N = zeros(8,2);
Mu_Gamma = zeros(8,2);
for j = 1:2
    type = type_collection{j};
    eval([ 'P_Value_N_' type '= zeros(8,1);' ])
    eval([ 'P_Value_Gamma_' type '= zeros(8,1);' ])
    eval([ 'Mu_N_' type '= zeros(8,2);' ])
    eval([ 'Mu_Gamma_' type '= zeros(8,2);'])    
    for i = 1 : 8
        
        eval([ 'Performance = P_' type '(:,i);' ])      % need change
        
        Performance_N = [Performance(1:number_instance/2) Performance(number_instance/2+1:end)];
        Performance_Gamma = [Performance(Small_Gamma_ind) Performance(Large_Gamma_ind)];
        
        eval([ 'Mu_N_' type '(i,:) = [mean(Performance_N(:,1)) mean(Performance_N(:,2))];' ])
        eval([ 'Mu_Gamma_' type '(i,:) = [mean(Performance_Gamma(:,1)) mean(Performance_Gamma(:,2))];' ])
        eval([ 'P_Value_N_' type '(i) = anova1(Performance_N,[],''off'');' ])
        eval([ 'P_Value_Gamma_' type '(i) = anova1(Performance_Gamma,[],''off'');' ])
    end
end

Table3 = [ Mu_N_RN P_Value_N_RN Mu_N_D P_Value_N_D ];
Table4 = [ Mu_Gamma_RN P_Value_Gamma_RN Mu_Gamma_D P_Value_Gamma_D ];