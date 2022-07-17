%% 获取种群中每个个体对应的完成质量、完成成本、完成时间
% 输入
%   Population：种群数据
%   Q：候选服务质量数据集
%   Cs：候选服务成本数据集
%   End_candidate_service：候选服务的子任务完成时刻数据集
% 输出
%   Quality：总任务的完成质量
%   Cost：总任务的完成成本
%   Time：总任务的完成时间
function [Quality,Cost,Time] = criteria(Population,Q,Cs,End_candidate_service,Cl)
[population_size,subtask_num] = size(Population);

total_Q = zeros(population_size,1);
total_Cs = zeros(population_size,1);
total_Cl = zeros(population_size,1);
total_T = zeros(population_size,1);
for k = 1:population_size
    for i = 1:subtask_num
        candidate_service_index = Population(k,i);
        total_Q(k,1) = total_Q(k,1) + Q(candidate_service_index,i);
        total_Cs(k,1) = total_Cs(k,1) + Cs(candidate_service_index,i);
    end
    total_Cl(k,1) = sum(Cl(k,:));
    total_T(k,1) = End_candidate_service(k,end);
end

Quality = total_Q/subtask_num;
Cost = total_Cs + total_Cl;
Time = total_T;
end