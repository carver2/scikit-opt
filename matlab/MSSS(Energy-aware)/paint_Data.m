clear
clc

Avg_Std_idle = [
%                 0.2,0.1;
%                 0.3,0.1;
%                 0.4,0.1;
%             0.5, 0.1;
                0.6,0.1;
%                 0.7,0.1;
%                 0.8,0.1;
            ];
Energy_dimensionless_value = ones(size(Avg_Std_idle, 1), 2);
QoS_Fitness_value = ones(size(Avg_Std_idle, 1), 2);
filename_set = [
           1111;
%            1011;
%            1101;
%            1110;
%            1100;
%            1010;
%            1001;
            ];

for ii = 1:size(Avg_Std_idle, 1)

    for jj = 1:size(filename_set, 1)
        source_file = ['模拟数据集\simulationData', num2str(Avg_Std_idle(ii, 1) * 10), num2str(Avg_Std_idle(ii, 2) * 10), '.xlsx'];
        objective_file = '模拟数据集\simulationData.xlsx';
        source_Data_M = 'Data_M';
        objective_Data_M = [source_Data_M, num2str(Avg_Std_idle(ii, 1) * 10), num2str(Avg_Std_idle(ii, 2) * 10), '-', num2str(filename_set(jj))]; % 目标文件Data_M-51-1111
        source_Data_M_Fitness = 'Data_M-Fitness';
        objective_Data_M_Fitness = [source_Data_M_Fitness, num2str(Avg_Std_idle(ii, 1) * 10), num2str(Avg_Std_idle(ii, 2) * 10), '-', num2str(filename_set(jj))]; % 目标文件Data_M-Fitness-51-1111
        source_Data_M_E = 'Data_M_E';
        objective_Data_M_E = [source_Data_M_E, num2str(Avg_Std_idle(ii, 1) * 10), num2str(Avg_Std_idle(ii, 2) * 10), '-', num2str(filename_set(jj))]; % 目标文件Data_M_E-51-1111
        source_Data_M_E_Fitness = 'Data_M_E-Fitness';
        objective_Data_M_E_Fitness = [source_Data_M_E_Fitness, num2str(Avg_Std_idle(ii, 1) * 10), num2str(Avg_Std_idle(ii, 2) * 10), '-', num2str(filename_set(jj))]; % 目标文件Data_M_E-51-1111
        source_Data_M_E_gantt = 'Data_M_E-gantt';
        objective_Data_M_E_gantt = [source_Data_M_E_gantt, num2str(Avg_Std_idle(ii, 1) * 10), num2str(Avg_Std_idle(ii, 2) * 10), '-', num2str(filename_set(jj))]; % 目标文件Data_M_E-gant-51-1111

        % 将simulationData-51-1111.xlsx另存为simulationData.xlsx
        copyfile(source_file, objective_file)
        save('current_parameters2', ...
            'Avg_Std_idle', 'Avg_Std_idle', ...
            'filename_set', 'filename_set', ...
            'ii', 'jj', ...
            'source_file', 'objective_file', ...
            'source_Data_M', 'objective_Data_M', ...
            'source_Data_M_E', 'objective_Data_M_E')
        %% 生成M方法和M_E方法的目标值收敛数据，以及M_E方法的甘特图数据
        clear
        Main
        load('current_parameters2')
        movefile([source_Data_M, '.mat'], [objective_Data_M, '.mat'])
        movefile([source_Data_M_E, '.mat'], [objective_Data_M_E, '.mat'])

        %% 画M方法和M_E方法的目标收敛图，以及M_E方法的甘特图
        % 画目标收敛图
        load(objective_Data_M)
        figure
        paint_fitness(Individual_best_fitness, 'r')
        hold on
        clear
        load('current_parameters2')
        load(objective_Data_M_E)
        paint_fitness(Individual_best_fitness, 'g')
        hold off
        load('current_parameters2')
        title(['fitness', objective_Data_M, objective_Data_M_E])

        % 画M_E方法的甘特图
        clear
        load('current_parameters2')
        load(objective_Data_M_E)
        paint_gantt(Individual, Occupancy, Time_elasticity, Individual_Start_candidate_service, Individual_End_candidate_service, Individual_Start_logistics, Individual_End_logistics);

        % 收集M方法和M_E方法的预热能耗数据
        clear
        load('current_parameters2')
        load(objective_Data_M)
        if jj ~= 1
            load('Energy_dimensionless_value')
        end
        Energy_dimensionless_value(jj, 1) = best_individual_Energy;
        save('Energy_dimensionless_value', 'Energy_dimensionless_value') % 存储M方案的Energy节约程度

        if jj ~= 1
            load('QoS_Fitness_value')
        end
        QoS_Fitness_value(jj, 1) = best_individual_QoS;
        save('QoS_Fitness_value', 'QoS_Fitness_value') % 存储M方案的QoS满意度

        clear
        load('current_parameters2')
        load(objective_Data_M_E)
        load('Energy_dimensionless_value')
        Energy_dimensionless_value(jj, 2) = best_individual_Energy; % 将M_E方案的Energy节约程度加入到变量Energy_dimensionless_value中
        save('Energy_dimensionless_value', 'Energy_dimensionless_value')

        load('QoS_Fitness_value')
        QoS_Fitness_value(jj, 2) = best_individual_QoS; % 将ME方案的QoS满意度加入到Fitness_QoS_value变量中
        save('QoS_Fitness_value', 'QoS_Fitness_value')
    end

end

%% 画M方法和M_E方法节约的能耗对比图和QoS对比图
clear
load('Energy_dimensionless_value.mat')
figure
bar(Energy_dimensionless_value)
title('Energy')

clear
load('QoS_Fitness_value')
figure
bar(QoS_Fitness_value)
title('QoS')
