%% 获取下一代Population在Population_combined中的降序排列的序号index
% 输入
%   Fitness：组合种群的适应度值
%   population_size：种群大小
% 输出
%   Population_index：选出的Population中的个体在Population_combined中的序号

function [Population_index] = select_population(Fitness,population_size)
    [~,Index] = sort(Fitness);
    Population_index = Index(1:population_size,:);
end

