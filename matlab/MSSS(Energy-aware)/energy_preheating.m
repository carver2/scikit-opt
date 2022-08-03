%% 子任务对应的候选服务节约的能耗
% 输入
%   Eh：候选服务的预热能耗
%   Population：种群
%   Cohesion：种群的衔接度
% 输出
%   E：种群中个体节约的能耗
function [E] = energy_preheating(Eh,Population,Th,Tc,Idle,Start_candidate_service,End_candidate_service)
[population_size,subtask_num] = size(Population);
E = zeros(population_size,subtask_num);
for k = 1:population_size
    for i = 1:subtask_num
        candidate_service = Population(k,i); % 候选服务
        Periods = Idle{candidate_service,i}; % 候选服务的空闲时段
        start_time = Start_candidate_service(k,i); % 第k个个体的第i个子任务对应的服务开始时间
        end_time = End_candidate_service(k,i); % 第k个个体的第i个子任务对应的服务的结束时间
        Th_candidate_service = Th(candidate_service,i); % 候选服务预热时长
        Tc_candidate_service = Tc(candidate_service,i); % 候选服务冷却时长
        
        cohesion = get_cohesion(Th_candidate_service,Tc_candidate_service,Periods,start_time,end_time); % 获取任务衔接度
        
        energy = Eh(candidate_service,i); % 候选服务启动能耗
        E(k,i) = energy * (1 - cohesion);
    end
end
