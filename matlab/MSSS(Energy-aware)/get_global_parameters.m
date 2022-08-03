%% 用户参数
ordertime = 60;
Time_required_max = 800;
Cost_required_max = 7000;
Quality_required_min = 0.6;
w_Energy = 0.25;
w_Quality = 0.25;
w_Cost = 0.25;
w_Time = 0.25;

%% 平台参数
T_unit_dist = 0.2;
C_unit_dist = 0.2;
elastic_coefficient = 1.2;
Time_elasticity = Time_required_max*elastic_coefficient;

%% 用xlsread函数来读取xlsx文件
file_path = '模拟数据集\simulationData.xlsx';
sheet = 'Sheet1';
range = 'A2:K51';
[subtask_num,candidate_service_num,Q,Ts,Cs,Th,Tc,Eh,Idle,P] = data_extract(file_path, sheet, range);
[Occupancy] = get_occupancy(Idle,Time_elasticity);

%% 算法参数设置
population_size = 50;
selection_size = 20;
gen_max = 1000;
cross_probability = 0.9; % 交叉概率
mutation_probability = 0.05; % 变异概率

%% 生成距离矩阵元组(candidate_service_num,subtask_num)，元祖中每个元素是当前位置与下一个位置的距离矩阵（candidate_service_num,1）
Distance_cell = cell(candidate_service_num,subtask_num); % 距离元祖，矩阵的每个元素都是一个数组，对应与下一个位置的距离
for i = 1:subtask_num-1
    for j = 1:candidate_service_num
        Distance = zeros(candidate_service_num,1); % 定义当前位置与下一个位置的距离矩阵
        current_position = P{j,i}; % 当前位置
        for next_j = 1:candidate_service_num
            next_position = P{next_j,i+1}; % 下一个位置有candidate_service_num个
            Distance(next_j,1) = pdist([current_position;next_position]);
        end
        Distance_cell{j,i} = Distance;
    end
end
%% 求解最小的运输时间和运输成本，用于计算Time_min和Cost_min
total_min_dist = 0;
for i = 1:subtask_num-1
    min_dist = Inf;
    for j = 1:candidate_service_num
        min_dist = min([min_dist;Distance_cell{j,i}]);
    end
    total_min_dist = total_min_dist + min_dist;
end
total_min_Tl = total_min_dist * T_unit_dist;
total_min_Cl = total_min_dist * C_unit_dist;

%% 组合服务参数（不考虑物流和等待时间的最优值）
Quality_max = sum(max(Q,[],1))/subtask_num;
Time_min = sum(min(Ts,[],1)) + total_min_Tl;
Cost_min = sum(min(Cs,[],1)) + total_min_Cl;
Energy_max = sum(max(Eh,[],1))*2;