%% 数据无量纲化
% 输入
%   Quality：总任务的完成质量
%   Cost：总任务的完成成本
%   Time：总任务的完成时间
%   deadline：用户要求的最迟交货时间
%   budget：用户的总任务成本预算
%   Quality_required_min：用户要求的总任务完成的最低质量
% 输出
%   Quality_dimensionless：总任务完成质量的无量纲数据集
%   Cost_dimensionless：总任务完成成本的无量纲数据集
%   Time_dimensionless：总任务完成时间的无量纲数据集
function [Quality_dimensionless,Cost_dimensionless,Time_dimensionless] = dimensionless_QoS(Quality,Cost,Time,Time_required_max,Cost_required_max,Quality_required_min,Time_min,Cost_min,Quality_max)
%% Quality的归一化和无量纲化处理
Quality_dimensionless = (Quality_max - Quality)/(Quality_max - Quality_required_min); % 如果超过1则不能达到客户的要求
%% Time的归一化和无量纲化处理
Time_dimensionless = (Time-Time_min)/(Time_required_max-Time_min); % 如果超过1则不能达到客户要求
%% Cost的归一化和无量纲化处理
Cost_dimensionless = (Cost-Cost_min)/(Cost_required_max-Cost_min); % 如果超过1则不能达到客户要求