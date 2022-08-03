%% 合并原种群、交叉后的种群、变异后的种群，并去除重复个体
% 输入
%   Population：原种群
%   Population_crossed：交叉后的种群
%   Population_mutated：变异后的种群
% 输出
%   Population_combine：合并后的种群
function [Population_combined] = combine(Population, Population_crossed, Population_mutated)
    population_size = size(Population, 1);
    Population_combined = [Population; Population_crossed; Population_mutated];
    % 去除合并后重复的个体
    Population_combined = unique(Population_combined, 'rows', 'stable');
    % 计算去除重复个体后的种群大小
    actual_population_size = size(Population_combined, 1);
    % 计算种群空缺数量
    vacancy_size = population_size - actual_population_size;
    % 随机选择种群中的个体填补空缺
    if vacancy_size > 0
        Individual_selected_index = randi(actual_population_size, vacancy_size, 1);
        Individual_selected = Population_combined(Individual_selected_index, :);
        Population_combined = [Population_combined; Individual_selected];
    end

end
