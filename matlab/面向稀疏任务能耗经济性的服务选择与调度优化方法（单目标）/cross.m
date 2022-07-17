%% 交叉
% 输入
%   Population：种群
%   cross_probability：交叉概率
% 输出
%   Population_crossed：交叉操作后的种群
function [Population_crossed] = cross(Population,cross_probability)
[selection_size,subtask_num] = size(Population);
Population_crossed = Population;
for i = 1:2:selection_size-mod(selection_size,2)
    if rand <= cross_probability % 交叉判断
        Section = randi(subtask_num,1,2); % 产生交叉区间
        start_point = Section(1,1);
        end_point = Section(1,2);
        if start_point <= end_point
            Section_temp = Population_crossed(i,start_point:end_point);
            Population_crossed(i,start_point:end_point) = Population_crossed(i+1,start_point:end_point);
            Population_crossed(i+1,start_point:end_point) = Section_temp;
        else
            Section_temp_back = Population_crossed(i,start_point:subtask_num);
            Population_crossed(i,start_point:subtask_num) = Population_crossed(i+1,start_point:subtask_num);
            Population_crossed(i+1,start_point:subtask_num) = Section_temp_back;
            Section_temp_front = Population_crossed(i,1:end_point);
            Population_crossed(i,1:end_point) = Population_crossed(i+1,1:end_point);
            Population_crossed(i+1,1:end_point) = Section_temp_front;
        end
    end
end
end