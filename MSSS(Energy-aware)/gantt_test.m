%% 求解Population_combined种群的适应度
[Tl,Cl] = logistics(Popu,Distance_cell,T_unit_dist,C_unit_dist);% 计算种群中每个个体的物流时间和物流成本

% [Start_candidate_service,End_candidate_service] = scheduling_Makespan(Popu,Ts,Idle,ordertime,Time_required_max,Tl); % 计算种群中每个个体中候选服务完成子任务的时间
[Start_candidate_service,End_candidate_service] = scheduling_Makespan_Energy(Popu,Th,Tc,Ts,Idle,ordertime,Time_required_max,Tl); % 计算种群中每个个体中候选服务完成子任务的时间
% [Start_candidate_service,End_candidate_service] = scheduling_Energy(Popu,Th,Tc,Ts,Idle,ordertime,Time_required_max,Tl); % 计算种群中每个个体中候选服务完成子任务的时间

[Start_logistics,End_logistics] = Start_End_logistics(End_candidate_service,Tl); % 计算种群中每个个体对应的子任务的运输开始时间和运输结束时间

paint_gantt(Popu,Occupancy,Time_elasticity,Start_candidate_service,End_candidate_service,Start_logistics,End_logistics);