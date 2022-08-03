%% 适应度函数
% 输入
%   Energy_dimensionless：种群的能耗经济性的无量纲化数值
%   Quality_dimensionless：种群的任务完成质量的无量纲化数值
%   Cost_dimensionless：种群的任务完成价格的无量纲化数值
%   Time_dimensionless：种群的任务完成时间的无量纲化数值
%   w_Energy：完成任务的能耗经济性权重
%   w_Quality：完成任务的质量权重
%   w_Cost：完成任务的成本权重
%   w_Time：完成任务的时间权重
% 输出
%   Fitness：种群的适应度
%   Fitness_sort：经过降序排列后的种群适应度
%   Fitness_sort_index：经过降序排列后的原始序号
function [Fitness] = fitness_single_object(Energy_dimensionless,Quality_dimensionless,Cost_dimensionless,Time_dimensionless,w_Energy,w_Quality,w_Cost,w_Time)
% 计算适应度
[population_size,~] = size(Quality_dimensionless);
Fitness = ones(population_size,1);
for k = 1:population_size
    if Energy_dimensionless(k,1)>1 || Quality_dimensionless(k,1)>1 || Cost_dimensionless(k,1)>1 || Time_dimensionless(k,1)>1
        Fitness(k,1) = Inf;
    else
        Fitness(k,1) = w_Energy*Energy_dimensionless(k,1) + w_Quality*Quality_dimensionless(k,1) + w_Cost*Cost_dimensionless(k,1) + w_Time*Time_dimensionless(k,1);
    end
end

