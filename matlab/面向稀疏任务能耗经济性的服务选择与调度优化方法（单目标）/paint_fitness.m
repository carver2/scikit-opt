%% 画出pareto前沿
% 输入
%   Populations_front_num：gen_max代种群的前沿编号
%   Populations_Fitness_value：gen_max代种群的目标值
%   gen_max：迭代次数
function [] = paint_fitness(Individual_best_fitness,color)
plot(Individual_best_fitness,color)
end

