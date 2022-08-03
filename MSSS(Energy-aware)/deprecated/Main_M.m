%% 文件名称：FSGS
%% 文件功能：获得服务选择与任务调度优化方案
%% 输入：数据集
% subtask_num：子任务数量
% candidate_service_num：候选服务集数量
% Ts：制造服务完成子任务需要的时间(candidate_service_num行，subtask_num列矩阵)
% Cs：制造服务完成子任务需要的费用(candidate_service_num行，subtask_num列矩阵)
% Q：制造服务完成子任务的质量(candidate_service_num行，subtask_num列矩阵)
% Th：制造服务的预热时间(candidate_service_num行，subtask_num列矩阵)
% Tc：制造服务的冷却时间(candidate_service_num行，subtask_num列矩阵)
% Eh：制造服务的预热能耗(candidate_service_num行，subtask_num列矩阵)
% Idle：制造服务的空闲时间(candidate_service_num行，subtask_num列元胞矩阵)
% P：制造服务的位置(candidate_service_num行，subtask_num列矩阵)
%% 输出：服务选择与任务调度方案，及其【服务需求者的任务QoS】与【服务供应商的服务预热能耗】
%% 服务选择与任务调度方案
% Start_candidate_service：子任务对应的候选服务的服务开始时间(population_size行，subtask_num列矩阵)
% End_candidate_service：子任务对应的候选服务服务结束时间(population_size行，subtask_num列矩阵)
% Start_logistics：子任务间的物流开始时间(population_size行，subtask_num列矩阵)
% End_logistics：子任务间的物流结束时间(population_size行，subtask_num列矩阵)
%% 服务需求者的任务QoS
% Time：任务完成的总时间(population_size行，subtask_num列矩阵)
% Cost：任务完成的总费用(population_size行，subtask_num列矩阵)
% Quality：任务完成的总质量(population_size行，subtask_num列矩阵)
%% 服务供应商的服务预热能耗
% Energy：任务完成的总预热能耗(population_size行，subtask_num列矩阵)
%% 代码功能：从现有数据集中，计算服务组合的最优选择，无服务占用调度情况，评价指标为：Time（服务时间)、Cost（服务成本）、Q（服务质量）
tic
clear
clc

get_global_parameters % 获取数据集和全局参数

%% 算法变量
Populations = cell(gen_max, 1); % 记录种群的元胞矩阵，用于记录每一代种群的个体
Populations_Fitness = cell(gen_max, 1); % 记录适应值种群的元胞矩阵，用于记录每一代种群个体的适应值

Individual_best = cell(gen_max, 1); % 存放各代种群中的最优个体
Individual_best_fitness = ones(gen_max, 1); % 存放各代种群最优个体的目标值

Individual_best_Start_candidate_service = cell(gen_max, 1); % 存放历代种群最优个体的服务开始时间
Individual_best_End_candidate_service = cell(gen_max, 1); % 存放历代种群最优个体的服务结束时间
Individual_best_Start_logistics = cell(gen_max, 1); % 存放历代种群最优个体的物流开始时间
Individual_best_End_logistics = cell(gen_max, 1); % 存放历代种群最优个体的物流结束时间

gen = 1; % 迭代循环变量

Population = randi(candidate_service_num, population_size, subtask_num); % 种群随机初始化

while (gen <= gen_max)
    %% 优化步骤
    Population_crossed = cross(Population, cross_probability); % 交叉
    Population_mutated = mutate(Population, mutation_probability, candidate_service_num); % 变异
    Population_combined = combine(Population, Population_crossed, Population_mutated); % 合并原始、交叉、变异种群的个体

    %% 占用调度和物流
    [Tl, Cl] = logistics(Population_combined, Distance_cell, T_unit_dist, C_unit_dist); % 计算种群中每个个体的物流时间和物流成本
    [Start_candidate_service, End_candidate_service] = scheduling_Makespan(Population_combined, Ts, Idle, ordertime, Time_required_max, Tl); % 计算种群中每个个体中候选服务完成子任务的时间
    [Start_logistics, End_logistics] = Start_End_logistics(End_candidate_service, Tl); % 计算种群中每个个体对应的子任务的运输开始时间和运输结束时间

    %% 计算Population_combined种群的预热能耗Energy，并进行无量纲化
    E = energy_preheating(Eh, Population_combined, Th, Tc, Idle, Start_candidate_service, End_candidate_service); % 各候选服务的预热能耗
    Energy = sum(E, 2); % 累加种群中个体的总预热能耗
    Energy_dimensionless = dimensionless_Energy(Energy, Energy_max); % 预热能耗无量纲化

    %% 计算Population_combined种群的任务QoS，并进行无量纲化
    [Quality, Cost, Time] = criteria(Population_combined, Q, Cs, End_candidate_service, Cl); % 获取种群中每个个体对应的完成质量、完成成本、完成时间
    [Quality_dimensionless, Cost_dimensionless, Time_dimensionless] = dimensionless_bottom2(Quality, Cost, Time, Time_required_max, Cost_required_max, Quality_required_min, Time_min, Cost_min, Quality_max); % 数据无量纲化

    %% 计算适应度
    Fitness = fitness_single_object(Energy_dimensionless, Quality_dimensionless, Cost_dimensionless, Time_dimensionless, w_Energy, w_Quality, w_Cost, w_Time); % 加权后的总适应值

    %% 选出下一代种群Population在Population_combined种群中的位置index
    [Population_index] = select_population(Fitness, population_size);

    %% 提取种群信息
    Population = Population_combined(Population_index, :); % 下一代种群
    Population_Fitness = Fitness(Population_index, :); % 下一代种群的目标值
    Population_Start_candidate_service = Start_candidate_service(Population_index, :); % 下一代种群的服务开始时间
    Population_End_candidate_service = End_candidate_service(Population_index, :); % 下一代种群服务结束时间
    Population_Start_logistics = Start_logistics(Population_index, :); % 下一代种群的物流开始时间
    Population_End_logistics = End_logistics(Population_index, :); % 下一代种群的物流结束时间

    %% 获得种群中最佳的fitness对应的fitness_QoS和fitness_Energy
    best_individual_fitness = Population_Fitness(1, 1);
    Energy = Energy_dimensionless(Population_index, :);
    best_individual_Energy = Energy(1, 1);
    best_individual_QoS = best_individual_fitness - w_Energy * best_individual_Energy;

    %% 存放历代种群个体的信息
    Populations{gen, 1} = Population;
    Populations_Fitness{gen, 1} = Population_Fitness;
    Individual_best{gen, 1} = Population(1, :); % 存放历代最优种群个体
    Individual_best_fitness(gen, 1) = Population_Fitness(1, :); % 存放历代种群最优个体的目标值
    Individual_best_Start_candidate_service{gen, 1} = Start_candidate_service(1, :); % 存放历代种群最优个体的服务开始时间
    Individual_best_End_candidate_service{gen, 1} = End_candidate_service(1, :); % 存放历代种群最优个体的服务结束时间
    Individual_best_Start_logistics{gen, 1} = Start_logistics(1, :); % 存放历代种群最优个体的物流开始时间
    Individual_best_End_logistics{gen, 1} = End_logistics(1, :); % 存放历代种群最优个体的物流结束时间

    %% 更新代数
    gen = gen + 1;
    disp(gen);
end

toc
%% 画出种群的fitnes迭代图
% paint_fitness(Individual_best_fitness);

%% 画出个体的甘特图
Individual = Individual_best{gen_max, 1};
Individual_Start_candidate_service = Individual_best_Start_candidate_service{gen_max, 1};
Individual_End_candidate_service = Individual_best_End_candidate_service{gen_max, 1};
Individual_Start_logistics = Individual_best_Start_logistics{gen_max, 1};
Individual_End_logistics = Individual_best_End_logistics{gen_max, 1};
% paint_gantt(Individual,Occupancy,Time_elasticity,Individual_Start_candidate_service,Individual_End_candidate_service,Individual_Start_logistics,Individual_End_logistics);

save('Data_M.mat');
