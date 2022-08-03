%% 计算拥挤距离
% 输入
%   Fitness_value：目标函数矩阵
%   Individual_front_num：个体的前沿编号
%   front_num：第front_num个前沿
% 输出
%   distance_value：第front_num个前沿的个体拥挤距离
function distance_value = crowd_distance(Fitness_value,Individual_front_num,front_num)
Population_combined_index_for_front_n = find(Individual_front_num == front_num); % 记录第front_num前沿上个体的编号，长度为front_num
distance_value = zeros(size(Population_combined_index_for_front_n)); % 存放个体的拥挤距离
Fitness_value_selected = Fitness_value(Population_combined_index_for_front_n,:); % 第front_num前沿上的适应度值
fmax = max(Fitness_value_selected,[],1); % Fitness_value_selected每维上的最大值
fmin = min(Fitness_value_selected,[],1); % Fitness_value_selected每维上的最小值
% 分目标计算每个目标上Fitness_value_selected各个体的拥挤距离
for i = 1:size(Fitness_value,2)
    Fitness_value_i_in_front_n = Fitness_value(Population_combined_index_for_front_n,i); % 第i个目标值
    [~,Fitness_value_i_in_front_n_index] = sortrows(Fitness_value_i_in_front_n); % 对第i个目标值升序排列
    distance_value(Fitness_value_i_in_front_n_index(1)) = inf; % 最小目标值的个体距离设置为无穷大
    distance_value(Fitness_value_i_in_front_n_index(end)) = inf; % 最大目标值的个体距离设置为无穷大
    % 从第2个遍历到倒数第2个个体
    for j = 2:length(Population_combined_index_for_front_n)-1
        next = Population_combined_index_for_front_n(Fitness_value_i_in_front_n_index(j+1)); % 下一个个体在Population_combined中的编号
        prev = Population_combined_index_for_front_n(Fitness_value_i_in_front_n_index(j-1)); % 上一个个体在Population_combined中的编号
        % Population_combined_index_for_front_n中的第j个个体的拥挤距离，从不同目标值的维度叠加
        distance_value(Fitness_value_i_in_front_n_index(j)) = distance_value(Fitness_value_i_in_front_n_index(j))...
            +(Fitness_value(next,i)-Fitness_value(prev,i))...
            /(fmax(i)-fmin(i));
    end
end
end

