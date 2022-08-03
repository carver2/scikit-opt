%% 功能：用来验证不同个体的适应值，需要将个体赋值给Popu变量
%% 求解Population_combined种群的适应度
[Tl,Cl] = logistics(Popu,Distance_cell,T_unit_dist,C_unit_dist);% 计算种群中每个个体的物流时间和物流成本
% [Start_candidate_service,End_candidate_service] = scheduling_Makespan(Popu,Ts,Idle,ordertime,Time_required_max,Tl); % 计算种群中每个个体中候选服务完成子任务的时间
% [Start_candidate_service,End_candidate_service] = scheduling_Makespan_Energy(Popu,Th,Tc,Ts,Idle,ordertime,Time_required_max,Tl); % 计算种群中每个个体中候选服务完成子任务的时间
[Start_candidate_service,End_candidate_service] = scheduling_Energy(Popu,Th,Tc,Ts,Idle,ordertime,Time_required_max,Tl); % 计算种群中每个个体中候选服务完成子任务的时间
                                                                            
[Start_logistics,End_logistics] = Start_End_logistics(End_candidate_service,Tl); % 计算种群中每个个体对应的子任务的运输开始时间和运输结束时间

%% 计算Population_combined种群的上层适应度（Provider：Energy）
E = energy_saving(Eh,Popu,Th,Tc,Idle,Start_candidate_service,End_candidate_service); % 各候选服务节约的能量
Energy = sum(E,2); % 种群中个体的总节约能耗
Energy_dimensionless_test = dimensionless_top2(Energy,Energy_max); % 节约的能量无量纲化
Fitness_top_test = fitness_top2(Energy_dimensionless_test); % 上层适应度值

%% 计算Population_combined种群的底层适应度（Demander：Time、Cost、Quality）
[Quality_test,Cost_test,Time_test] = criteria(Popu,Q,Cs,End_candidate_service,Cl); % 获取种群中每个个体对应的完成质量、完成成本、完成时间
[Quality_dimensionless_test,Cost_dimensionless_test,Time_dimensionless_test] = dimensionless_bottom2(Quality_test,Cost_test,Time_test,Time_required_max,Cost_required_max,Quality_required_min,Time_min,Cost_min,Quality_max); % 数据无量纲化
Fitness_bottom_test = fitness_bottom2(Quality_dimensionless_test,Cost_dimensionless_test,Time_dimensionless_test,w_Quality,w_Cost,w_Time); % 底层适应度函数值
disp([Fitness_top_test,Fitness_bottom_test])