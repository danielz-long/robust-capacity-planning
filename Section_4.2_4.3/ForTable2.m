clear;
clc;

%***************************************
number_instance = 240;
number_type = 8;
%***************************************

solution_type_collection = cell(1,5);
solution_type_collection{1} = 'ADRO';
solution_type_collection{2} = 'Robust_Z';
solution_type_collection{3} = 'Robust_B';
solution_type_collection{4} = 'RN';
solution_type_collection{5} = 'D';

P_ADRO = zeros(number_instance, number_type);
P_Robust_Z = zeros(number_instance, number_type);
P_Robust_B = zeros(number_instance, number_type);
P_RN = zeros(number_instance, number_type);
P_D = zeros(number_instance, number_type);

load('UncertaintyOutOfSampleTesting.mat');

for i = 1:number_instance
    
    load(['Solutions/result_ADRO' num2str(i) '.mat']);
    
    for solution_approach_index = 1:5
        solution_approach = solution_type_collection{solution_approach_index};
        eval(['load(''CostSample/Cost_' solution_approach num2str(i) '.mat'');']);
        eval(['cost_' solution_approach '=cost_sample;']);
        
        cost_sample_prob = [cost_sample, prob];
        cost_sample_prob = sortrows(cost_sample_prob,1);
        cost_sample_prob = [ cost_sample_prob , cumsum(cost_sample_prob(:,2)) ];
        eval(['cost_' solution_approach '_prob=cost_sample_prob;']);

        clear cost_sample cost_sample_prob
    end
    
    p_best = [cost_ADRO(1); cost_Robust_Z(1); cost_Robust_B(1); cost_RN(1); cost_D(1)];    % should be like this
    p_worst = [cost_ADRO(end); cost_Robust_Z(end); cost_Robust_B(end); cost_RN(end); cost_D(end)];
    
    p_mean = [sum(cost_ADRO.*prob); sum(cost_Robust_Z.*prob); sum(cost_Robust_B.*prob); sum(cost_RN.*prob); sum(cost_D.*prob)];
    p_squd = [sum((cost_ADRO.^2).*prob); sum((cost_Robust_Z.^2).*prob); sum((cost_Robust_B.^2).*prob); sum((cost_RN.^2).*prob); sum((cost_D.^2).*prob)];    
    p_variance = p_squd - p_mean.^2;
    
    for solution_approach_index = 1:5
        solution_approach = solution_type_collection{solution_approach_index};        
        eval([ 'quantile_index_' solution_approach '=max(find(cost_' solution_approach '_prob(:,3)<0.95));' ]);
        
        eval([ 'quantile_' solution_approach ' = cost_' solution_approach '_prob(quantile_index_' solution_approach '+1:end, [1 2] );' ]);
        eval([ 'quantile_' solution_approach '(1,2) = 0.05 - sum(quantile_' solution_approach '(2:end,2));' ])

        eval([ 'quantile_' solution_approach '(:,2) = quantile_' solution_approach '(:,2)/ sum(quantile_' solution_approach '(:,2));' ]);

    end
    
    p_var5 = [cost_ADRO_prob(quantile_index_ADRO,1); cost_Robust_Z_prob(quantile_index_Robust_Z,1); cost_Robust_B_prob(quantile_index_Robust_B,1); cost_RN_prob(quantile_index_RN,1); cost_D_prob(quantile_index_D,1)] ;
    p_cvar5 = [ sum(quantile_ADRO(:,1).*quantile_ADRO(:,2)); sum(quantile_Robust_Z(:,1).*quantile_Robust_Z(:,2)); sum(quantile_Robust_B(:,1).*quantile_Robust_B(:,2)); sum(quantile_RN(:,1).*quantile_RN(:,2));sum(quantile_D(:,1).*quantile_D(:,2))];
    clear quantile_*
    
    for solution_approach_index = 1:5
        solution_approach = solution_type_collection{solution_approach_index};
        eval([ 'quantile_index_' solution_approach '=min(find(cost_' solution_approach '_prob(:,1)>target));' ]); 
        eval([ 'quantile_' solution_approach ' = cost_' solution_approach '_prob(quantile_index_' solution_approach ':end, [1 2] );' ]);
        eval([ 'quantile_' solution_approach ' =[ quantile_' solution_approach ', quantile_' solution_approach '(:,2)/ sum(quantile_' solution_approach '(:,2))];' ]);
        eval([ 'quantile_' solution_approach '(:,1) = quantile_' solution_approach '(:,1) - target;' ])

    end
    
    p_vp = [ sum(quantile_ADRO(:,2));sum(quantile_Robust_Z(:,2));sum(quantile_Robust_B(:,2));sum(quantile_RN(:,2));sum(quantile_D(:,2)); ];
    p_el = [ sum(quantile_ADRO(:,1).*quantile_ADRO(:,2)); sum(quantile_Robust_Z(:,1).*quantile_Robust_Z(:,2)); sum(quantile_Robust_B(:,1).*quantile_Robust_B(:,2)); sum(quantile_RN(:,1).*quantile_RN(:,2));sum(quantile_D(:,1).*quantile_D(:,2))];
    clear quantile_*
      
    
    p_best = p_best/p_best(1);
    p_worst = p_worst/p_worst(1);
    p_mean = p_mean/p_mean(1);
    p_variance = p_variance/p_variance(1);
    p_var5 = p_var5/p_var5(1);
    p_cvar5 = p_cvar5/p_cvar5(1);
    p_vp = p_vp/p_vp(1);
    p_el = p_el/p_el(1);

    
    performance_num = [p_best p_worst p_mean p_variance p_var5 p_cvar5 p_vp p_el];
    
    P_ADRO(i,:) = performance_num(1,:);
    P_Robust_Z(i,:) = performance_num(2,:);
    P_Robust_B(i,:) = performance_num(3,:);
    P_RN(i,:) = performance_num(4,:);
    P_D(i,:) = performance_num(5,:);
 
end

P_Robust_Z_1best = P_Robust_Z(:,1);
P_Robust_Z_2worst = P_Robust_Z(:,2);
P_Robust_Z_3mean = P_Robust_Z(:,3);
P_Robust_Z_4variance = P_Robust_Z(:,4);
P_Robust_Z_5var5 = P_Robust_Z(:,5);
P_Robust_Z_6cvar5 = P_Robust_Z(:,6);
P_Robust_Z_7vp = P_Robust_Z(:,7);
P_Robust_Z_8el = P_Robust_Z(:,8);
P_Robust_Z_aggregated = mean(P_Robust_Z,1);

P_Robust_B_1best = P_Robust_B(:,1);
P_Robust_B_2worst = P_Robust_B(:,2);
P_Robust_B_3mean = P_Robust_B(:,3);
P_Robust_B_4variance = P_Robust_B(:,4);
P_Robust_B_5var5 = P_Robust_B(:,5);
P_Robust_B_6cvar5 = P_Robust_B(:,6);
P_Robust_B_7vp = P_Robust_B(:,7);
P_Robust_B_8el = P_Robust_B(:,8);
P_Robust_B_aggregated = mean(P_Robust_B,1);

P_RN_1best = P_RN(:,1);
P_RN_2worst = P_RN(:,2);
P_RN_3mean = P_RN(:,3);
P_RN_4variance = P_RN(:,4);
P_RN_5var5 = P_RN(:,5);
P_RN_6cvar5 = P_RN(:,6);
P_RN_7vp = P_RN(:,7);
P_RN_8el = P_RN(:,8);
P_RN_aggregated = mean(P_RN,1);

P_D_1best = P_D(:,1);
P_D_2worst = P_D(:,2);
P_D_3mean = P_D(:,3);
P_D_4variance = P_D(:,4);
P_D_5var5 = P_D(:,5);
P_D_6cvar5 = P_D(:,6);
P_D_7vp = P_D(:,7);
P_D_8el = P_D(:,8);
P_D_aggregated = mean(P_D,1);

Table2 = [ ones(1,8); P_Robust_Z_aggregated; P_Robust_B_aggregated; P_RN_aggregated; P_D_aggregated ];

save('CostAnalysis.mat', 'P_*');