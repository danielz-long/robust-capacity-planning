clear;
clc;

number_instance = 240;
number_type = 8;

solution_type_collection = cell(1,2);
solution_type_collection{1} = 'robust';
solution_type_collection{2} = 'sampling';


P_robust = zeros(number_instance,number_type);
P_sampling = zeros(number_instance,number_type);

for distribution_type = 1 : 2
    
    for i = 1:number_instance
        load(['Solutions_Sampling/result_sampling' num2str(i) '.mat'],'target');
        
        for solution_approach_index = 1:2
            
            solution_approach = solution_type_collection{solution_approach_index};
            eval(['load(''CostSampleUnderDistribution' num2str(distribution_type) '/Cost_' solution_approach num2str(i) '.mat'');']);
            eval(['cost_' solution_approach '=cost_sample;']);
            eval(['prob_' solution_approach '=probability;']);
            
            cost_sample_prob = [cost_sample, probability];
            cost_sample_prob = sortrows(cost_sample_prob,1);
            cost_sample_prob = [ cost_sample_prob , cumsum(cost_sample_prob(:,2)) ];
            eval(['cost_' solution_approach '_prob=cost_sample_prob;']);
            
            clear cost_sample cost_sample_prob
        end
        
        p_best = [cost_robust(1); cost_sampling(1)];    % should be like this
        p_worst = [cost_robust(end); cost_sampling(end)];
        
        p_mean = [sum(cost_robust.*prob_robust); sum(cost_sampling.*prob_sampling)];
        p_squd = [sum((cost_robust.^2).*prob_robust); sum((cost_sampling.^2).*prob_sampling) ];
        p_variance = p_squd - p_mean.^2;
        
        
        for solution_approach_index = 1:2
            solution_approach = solution_type_collection{solution_approach_index};
            eval([ 'quantile_index_' solution_approach '=max(find(cost_' solution_approach '_prob(:,3)<0.95));' ]);
            
            eval([ 'quantile_' solution_approach ' = cost_' solution_approach '_prob(quantile_index_' solution_approach '+1:end, [1 2] );' ]);
            % balance 10%
            eval([ 'quantile_' solution_approach '(1,2) = 0.05 - sum(quantile_' solution_approach '(2:end,2));' ])
            % balance end
            
            eval([ 'quantile_' solution_approach '(:,2) = quantile_' solution_approach '(:,2)/ sum(quantile_' solution_approach '(:,2));' ]);
            
        end
        
        p_var5 = [cost_robust_prob(quantile_index_robust+1,1); cost_sampling_prob(quantile_index_sampling+1,1)];
        p_cvar5 = [ sum(quantile_robust(:,1).*quantile_robust(:,2)); sum(quantile_sampling(:,1).*quantile_sampling(:,2)) ];
        clear quantile_*
        
        for solution_approach_index = 1:2
            solution_approach = solution_type_collection{solution_approach_index};
            eval([ 'quantile_index_' solution_approach '=min(find(cost_' solution_approach '_prob(:,1)>target));' ]);
            eval([ 'quantile_' solution_approach ' = cost_' solution_approach '_prob(quantile_index_' solution_approach ':end, [1 2] );' ]);
            eval([ 'quantile_' solution_approach ' =[ quantile_' solution_approach ', quantile_' solution_approach '(:,2)/ sum(quantile_' solution_approach '(:,2))];' ]);
            eval([ 'quantile_' solution_approach '(:,1) = quantile_' solution_approach '(:,1) - target;' ])
            
        end
        
        
        p_vp = [ sum(quantile_robust(:,2));sum(quantile_sampling(:,2)) ];
        p_el = [ sum(quantile_robust(:,1).*quantile_robust(:,2)); sum(quantile_sampling(:,1).*quantile_sampling(:,2)) ];
        clear quantile_*
        
        
        performance_num = [p_best p_worst p_mean p_variance p_var5 p_cvar5 p_vp p_el];
        
        P_robust(i,:) = performance_num(1,:);
        P_sampling(i,:) = performance_num(2,:);
        
        
    end
    
    P_sampling_1best = P_sampling(:,1);
    P_sampling_2worst = P_sampling(:,2);
    P_sampling_3mean = P_sampling(:,3);
    P_sampling_4variance = P_sampling(:,4);
    P_sampling_5var5 = P_sampling(:,5);
    P_sampling_6cvar5 = P_sampling(:,6);
    P_sampling_7vp = P_sampling(:,7);
    P_sampling_8el = P_sampling(:,8);
    P_sampling_aggregated = mean(P_sampling,1);
    
    P_robust_1best = P_robust(:,1);
    P_robust_2worst = P_robust(:,2);
    P_robust_3mean = P_robust(:,3);
    P_robust_4variance = P_robust(:,4);
    P_robust_5var5 = P_robust(:,5);
    P_robust_6cvar5 = P_robust(:,6);
    P_robust_7vp = P_robust(:,7);
    P_robust_8el = P_robust(:,8);
    P_robust_aggregated = mean(P_robust,1);
    
    eval(['Table5_Distribution' num2str(distribution_type) ' = [P_robust_aggregated; P_sampling_aggregated];']);
    
end

Table5 = [Table5_Distribution1; Table5_Distribution2];