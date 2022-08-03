%% 轮盘赌选择个体(Fitness越小越优，因此需要将小的Fitness通过倒数转换成大的Fitness进行选择操作）
% 输入：
%   Population_combined_unique：合并后去除重复个体的种群
%   population_size：种群大小
%   selection_size：选择个体的数量
%   Fitness：适应度值
% 输出：
%   Population_selected：精英个体+轮盘赌选择的非精英个体作为新的种群
function [Population_new] = roulette_select(Population_combined_unique,population_size,selection_size,Fitness)
% 根据个体的适应度值由小到大排序
[Fitness_sorted, index] = sort(Fitness);
Population_combined_unique_sorted = Population_combined_unique(index,:);
% 选出种群中的精英个体
Population_elite = Population_combined_unique_sorted(1:population_size-selection_size,:);
%% 用轮盘赌选出精英个体外的个体补全种群数量
% 除精英个体外的种群
Population_ordinary = Population_combined_unique_sorted;
Population_ordinary(1:population_size-selection_size,:) = [];
Population_ordinary_Fitness = Fitness_sorted;
Population_ordinary_Fitness(1:population_size-selection_size) = [];

Fitness_turn_max = 1/Population_ordinary_Fitness;
select_probability = Fitness_turn_max/sum(Fitness_turn_max); % 选择概率
select_index = zeros(selection_size,1); % 存放被选个体的序号
c = cumsum(select_probability); % 将选择概率分布在轮盘上
for i = 1:selection_size
    r = rand;                         %0~1之间的随机数
    index = find(c >= r,1,'first');     %每次被选择出的个体序号
    select_index(i,1) = index;
end
Population_ordinary_selected = Population_ordinary(select_index,:);        %被选中的个体
Population_new = [Population_elite;Population_ordinary_selected];
end