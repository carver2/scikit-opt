%% 将个体节约的能量无量纲化
% 输入
%   Energy：种群对应的候选服务节约的能量
%   Eh：候选服务的预热全过程所需的能耗
% 输出
%   Energy_dimensionless：种群中每个个体的无量纲化能耗(值越小越优）
function [Energy_dimensionless] = dimensionless_Energy(Energy,Energy_max)
Energy_dimensionless = Energy/Energy_max;
end

