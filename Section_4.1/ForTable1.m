clc;
clear;

Index = [1:250; 361:610; 721:970; 1081:1330; 1441:1690];  

Time = zeros(size(Index,2),5);
Gamma_all = zeros(size(Index,2),5);

load('InstanceAnalysis.mat');
NGT = [];

for i = 1:5
    Index_temp = Index(i,:);
    NGT_tem = [];
    k = 1;
    for j = Index_temp
        load(['Solutions/result_ADRO' num2str(j) '.mat']);
        Time(k,i) = T_aro;
        Gamma_all(k,i) = Gamma(j);
        NGT_tem = [NGT_tem; N, Gamma(j), T_aro];
        k = k+1;
    end
    eval(['NGT' num2str(i) '= sortrows(NGT_tem,2);'])
    NGT = [NGT; NGT_tem];
end

% index in NGTi
% 1st group: 1-181, 182-250; gamma_0 = 0.3637;
% 2nd group: 1-101, 102-250; gamma_0 = 0.3334;
% 3rd group: 1-134, 135-250; gamma_0 = 0.4195;
% 4th group: 1-131, 132-250; gamma_0 = 0.4147;
% 5th group: 1-127, 128-250; gamma_0 = 0.3923;

Table1 = zeros(5,4);

NGT_small = NGT1(NGT1(:,2)<=0.3637,3);
NGT_big = NGT1(NGT1(:,2)>0.3637,3);
Table1(1,:) = [mean(NGT_small) mean(NGT_big) max(NGT_small) max(NGT_big)];

NGT_small = NGT2(NGT2(:,2)<=0.3334,3);
NGT_big = NGT2(NGT2(:,2)>0.3334,3);
Table1(2,:) = [mean(NGT_small) mean(NGT_big) max(NGT_small) max(NGT_big)];

NGT_small = NGT3(NGT3(:,2)<=0.4195,3);
NGT_big = NGT3(NGT3(:,2)>0.4195,3);
Table1(3,:) = [mean(NGT_small) mean(NGT_big) max(NGT_small) max(NGT_big)];

NGT_small = NGT4(NGT4(:,2)<=0.4147,3);
NGT_big = NGT4(NGT4(:,2)>0.4147,3);
Table1(4,:) = [mean(NGT_small) mean(NGT_big) max(NGT_small) max(NGT_big)];

NGT_small = NGT5(NGT5(:,2)<=0.3923,3);
NGT_big = NGT5(NGT5(:,2)>0.3923,3);
Table1(5,:) = [mean(NGT_small) mean(NGT_big) max(NGT_small) max(NGT_big)];