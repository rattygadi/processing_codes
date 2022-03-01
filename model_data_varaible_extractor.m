%% This code will extract a requested variable for various scenario's and 
% save it to a *.mat. At the same time, this code can be used for making
% plots
% Comment the next three lines if you want to run it from bash script
clear all;
clc;
close all;

%% location of the *.mat files
list = dir(fullfile(pwd,'*.mat'));
plot_fig = 0;
model_dir = [pwd filesep 'Dataset'];
if(~exist(model_dir))
    mkdir(model_dir);
end
filename_save = [model_dir filesep 'World_data.mat'];

%% List of variables that need to be read
variable_name = ["Emissions|CO2" "Emissions|CO2|AFOLU" ...
    "Emissions|CO2|Energy and Industrial Processes" "GDP|PPP" ....
    "Carbon Sequestration|CCS" "Carbon Sequestration|CCS|Biomass" ...
    "Carbon Sequestration|Land Use" ...
    "Carbon Sequestration|CCS|Fossil|Energy|Supply"....
    "Carbon Sequestration|CCS|Fossil|Energy|Demand|Industry"....
    "Policy Cost|Consumption Loss" "Policy Cost|GDP Loss" ....
    "Population" "Investment|Energy Supply" ....
    "Final Energy" "Final Energy|Electricity" ...
    "Final Energy|Gases" "Final Energy|Heat" "Final Energy|Industry|Electricity"....
    "Final Energy|Industry|Gases" "Final Energy|Industry|Heat" ....
    "Final Energy|Industry|Liquids" "Final Energy|Industry|Solids" ....
    "Final Energy|Liquids" "Final Energy|Residential and Commercial" ...
    "Final Energy|Solids" "Final Energy|Solids|Coal" ....
    "Final Energy|Solids|Biomass" "Final Energy|Transportation" ....
    "Final Energy|Transportation|Electricity" "Final Energy|Transportation|Liquids|Biomass"....
    "Final Energy|Transportation|Liquids|Oil" "Price|Carbon" ....
    "Primary Energy" "Primary Energy|Fossil" "Primary Energy|Nuclear" ....
    "Primary Energy|Biomass" "Primary Energy|Solar" "Primary Energy|Wind" ....
    "Investment|Energy Supply|Electricity|Non-fossil"];
count_1 = 1;count_2 = 1;count_3 = 1;
%M = containers.Map('KeyType','char','ValueType','double')
for j=1:length(list)
%j = 1;
    data = load(list(j).name);
    var_name = string(table2array(data.var_name));
    for i=1:length(variable_name)
        ind = find(strcmp(var_name,variable_name(i)));
        var_data_dum = data.Data(ind,:);
        ind_var = find(var_data_dum~=0);
        %var_data_dum(var_data_dum~=0) = NaN;
        var_data.ind(i) = length(ind_var);
        var_data.data{j,i,:} = var_data_dum(ind_var);
        %M(variable_name(i)) = data.Data(ind(i),:);
        var_data.time{j,i,:} = data.Time(ind_var);
        var_data.model_no(j) = 1;
        % CODE TO FIND WHERE THE SIGN CHANGES
        if(strcmp(variable_name(i),"Emissions|CO2")==1)
            var_data.peak_year(j) = data.Time(find(max(var_data_dum)==var_data_dum));
            ind_left = max(find(sign(var_data.data{j,i,:})>0));
            ind_right = max(find(sign(var_data.data{j,i,:})>0)) + 1;
            
            if(ind_right<=length(ind_var))
                syms x real;
                y_var = var_data_dum(ind_var);
                x_var = data.Time(ind_var);
                m = (y_var(ind_right) - y_var(ind_left))/(x_var(ind_right) - x_var(ind_left));
                y = m * x + y_var(ind_right) - m * x_var(ind_right);
                var_data.zero_year(j) = floor(eval(solve(y==0,x)));
        %if(strcmp(variable_name(i),"Emissions|CO2")==1)
        %    F = fit(data.Time(ind)',var_data_dum(ind)','linearinterp');
        %end
            else
                var_data.zero_year(j) = NaN;
            end
        end
        if(strcmp(variable_name(i),"Final Energy")==1&&(~isnan(var_data.zero_year(j)))&&~isempty(var_data_dum))
            var_data.final_energy.peak(count_2-1) = var_data_dum(find(var_data.peak_year(j)==data.Time));
            ind_imp = find(data.Time==var_data.zero_year(j)&var_data_dum~=0);
            if(isempty(ind_imp))
                x_left = max(find(data.Time<=var_data.zero_year(j)&var_data_dum~=0));
                x_right = min(find(data.Time>=var_data.zero_year(j)&var_data_dum~=0));
                if(~isempty(x_right))
                    var_data.final_energy.net_zero(count_2-1) = 1/abs(x_left - x_right)....
                        * [abs(var_data.zero_year(j) - data.Time(x_left)) ...
                        abs(var_data.zero_year(j) - data.Time(x_right))] * [var_data_dum(x_right);...
                        var_data_dum(x_left)];
                else
                    var_data.final_energy.net_zero(count_2-1) = var_data_dum(x_left);
                end
            else
                var_data.final_energy.net_zero(count_2-1) = var_data_dum(ind_imp);
            end
             
            %count_1 = count_1 + 1;
        elseif(isempty(var_data_dum)&&strcmp(variable_name(i),"Final Energy")==1)
            var_data.final_energy.peak(count_2-1) = 0;
            var_data.final_energy.net_zero(count_2-1) = 0;
            %count_1 = count_1 + 1;
        elseif(strcmp(variable_name(i),"Final Energy")==1)
            var_data.final_energy.peak(count_2-1) = 0;
            var_data.final_energy.net_zero(count_2-1) = 0;
        end
        if(strcmp(variable_name(i),"GDP|PPP")==1&&(~isnan(var_data.zero_year(j)))&&~isempty(var_data_dum))
            var_data.gdp_ppp.peak(count_2) = var_data_dum(find(var_data.peak_year(j)==data.Time));
            ind_imp = find(data.Time==var_data.zero_year(j)&var_data_dum~=0);
            
            if(isempty(ind_imp))
                x_left = max(find(data.Time<=var_data.zero_year(j)&var_data_dum~=0));
                x_right = min(find(data.Time>=var_data.zero_year(j)&var_data_dum~=0));
                if(~isempty(x_right))
                    var_data.gdp_ppp.net_zero(count_2) = 1/abs(x_left - x_right)....
                        * [abs(var_data.zero_year(j) - data.Time(x_left)) ...
                        abs(var_data.zero_year(j) - data.Time(x_right))] * [var_data_dum(x_right);...
                        var_data_dum(x_left)];
                elseif(~isempty(x_left))
                    var_data.gdp_ppp.net_zero(count_2) = var_data_dum(x_left);
                else
                    var_data.gdp_ppp.net_zero(count_2) = 0;
                end
            else
                var_data.gdp_ppp.net_zero(count_2) = var_data_dum(ind_imp);
            end
            var_data.gdp_ppp.scen(count_2) = j; 
            count_2 = count_2 + 1;
        elseif(isempty(var_data_dum)&&strcmp(variable_name(i),"GDP|PPP")==1)
            var_data.gdp_ppp.peak(count_2) = 0;
            var_data.gdp_ppp.net_zero(count_2) = 0;
            count_2 = count_2 + 1;
            var_data.gdp_ppp.scen(count_2) = j;
        end
        if(strcmp(variable_name(i),"Population")==1&&(~isnan(var_data.zero_year(j)))&&~isempty(var_data_dum))
            var_data.pop.peak(count_2-1) = var_data_dum(find(var_data.peak_year(j)==data.Time));
            ind_imp = find(data.Time==var_data.zero_year(j)&var_data_dum~=0);
            if(isempty(ind_imp))
                x_left = max(find(data.Time<=var_data.zero_year(j)&var_data_dum~=0));
                x_right = min(find(data.Time>=var_data.zero_year(j)&var_data_dum~=0));
                if(~isempty(x_right))
                    var_data.pop.net_zero(count_2-1) = 1/abs(x_left - x_right)....
                        * [abs(var_data.zero_year(j) - data.Time(x_left)) ...
                        abs(var_data.zero_year(j) - data.Time(x_right))] * [var_data_dum(x_right);...
                        var_data_dum(x_left)];
                elseif(~isempty(x_left))
                    var_data.pop.net_zero(count_2-1) = var_data_dum(x_left);
                else
                    var_data.pop.net_zero(count_2-1) = 0;
                end
            else
                var_data.pop.net_zero(count_2-1) = var_data_dum(ind_imp);
            end
            %count_3 = count_3 + 1;
        elseif(isempty(var_data_dum)&&strcmp(variable_name(i),"Population")==1)
            var_data.pop.peak(count_2-1) = 0;
            var_data.pop.net_zero(count_2-1) = 0;
            %count_3 = count_3 + 1;
        elseif(strcmp(variable_name(i),"Population")==1)
            var_data.pop.peak(count_2-1) = 0;
            var_data.pop.net_zero(count_2-1) = 0;
        end
        if(strcmp(variable_name(i),"Price|Carbon")==1&&(~isnan(var_data.zero_year(j)))&&~isempty(var_data_dum))
            var_data.price_carbon.peak(count_3) = var_data_dum(find(var_data.peak_year(j)==data.Time));
            ind_imp = find(data.Time==var_data.zero_year(j)&var_data_dum~=0);
            if(isempty(ind_imp))
                x_left = max(find(data.Time<=var_data.zero_year(j)&var_data_dum~=0));
                x_right = min(find(data.Time>=var_data.zero_year(j)&var_data_dum~=0));
                if(~isempty(x_right))
                    var_data.price_carbon.net_zero(count_3) = 1/abs(x_left - x_right)....
                        * [abs(var_data.zero_year(j) - data.Time(x_left)) ...
                        abs(var_data.zero_year(j) - data.Time(x_right))] * [var_data_dum(x_right);...
                        var_data_dum(x_left)];
                elseif(~isempty(x_left))
                    var_data.price_carbon.net_zero(count_3) = var_data_dum(x_left);
                else
                    var_data.price_carbon.net_zero(count_3) = 0;
                end
            else
                var_data.price_carbon.net_zero(count_3) = var_data_dum(ind_imp);
            end
            count_3 = count_3 + 1;
        elseif(isempty(var_data_dum)&&strcmp(variable_name(i),"Price|Carbon")==1)
            var_data.price_carbon.peak(count_3) = 0;
            var_data.price_carbon.net_zero(count_3) = 0;
            count_3 = count_3 + 1;
        elseif(strcmp(variable_name(i),"Price|Carbon")==1)
            var_data.price_carbon.peak(count_3) = 0;
            var_data.price_carbon.net_zero(count_3) = 0;
        end
    end
    disp(j);
end

save(filename_save,'var_data','variable_name','list');
%% Figure
if(plot_fig>0)
    plot(var_data.zero_year(find(~isnan(var_data.zero_year))),var_data.peak_year(find(~isnan(var_data.zero_year))),'*');
    xlim([2000 2100]);
    ylim([2000 2100]);
    xlabel('Zero Year');
    ylabel('Peak Year');
    print(gcf,'-dpng','-r300',fullfile(pwd,'peak_year_vs_zero_year'));

    figure;
    histogram(var_data.peak_year(find(~isnan(var_data.zero_year))))
    xlim([2000 2100]);
    xlabel('Peak Year');
    ylabel('No. of Scenario');
%title('Peak year PDF for Net Zero emission scenarios');
    print(gcf,'-dpng','-r300',fullfile(pwd,'peak_year_histogram'));

    figure;
    histogram(var_data.zero_year(find(~isnan(var_data.zero_year))));
    xlim([2000 2100]);
    xlabel('Zero Year');
    ylabel('No. of Scenario');
%title('Zero year PDF for Net Zero emission scenarios');    
    print(gcf,'-dpng','-r300',fullfile(pwd,'zero_year_histogram'));
    
    figure;
    var_data.gdp_per_cap.net_zero = var_data.gdp_ppp.net_zero./var_data.pop.net_zero;
    ind = find(~isnan(var_data.gdp_per_cap.net_zero)&var_data.final_energy.net_zero~=0&var_data.gdp_per_cap.net_zero~=0);
    F = fit(var_data.gdp_per_cap.net_zero(ind)',var_data.final_energy.net_zero(ind)','poly1');
    Da = fitlm(var_data.gdp_per_cap.net_zero(ind)',var_data.final_energy.net_zero(ind)');
    plot(var_data.gdp_per_cap.net_zero(ind),var_data.final_energy.net_zero(ind),'*');
    hold on;
    plot(var_data.gdp_per_cap.net_zero(ind),F(var_data.gdp_per_cap.net_zero(ind)),'--','Color','k');
    xlim([0.1 130]);
    ylim([0 900]);
    xlabel('GDP per capita');
    ylabel('Final Energy (EJ)');
    print(gcf,'-dpng','-r300',fullfile(pwd,'Energy_vs_gdp_per_cap_net_zero'));
    
    figure;
    var_data.gdp_per_cap.peak = var_data.gdp_ppp.peak./var_data.pop.peak;
    ind = find(~isnan(var_data.gdp_per_cap.peak)&var_data.final_energy.peak~=0&var_data.gdp_per_cap.peak~=0);
    G = fit(var_data.gdp_per_cap.peak(ind)',var_data.final_energy.peak(ind)','poly1');
    Da2 = fitlm(var_data.gdp_per_cap.peak(ind)',var_data.final_energy.peak(ind)');
    plot(var_data.gdp_per_cap.peak(ind),var_data.final_energy.peak(ind),'*');
    hold on;
    plot(var_data.gdp_per_cap.peak(ind),G(var_data.gdp_per_cap.peak(ind)),'--','Color','k');
    xlim([0.1 130]);
    ylim([0 900]);
    xlabel('GDP per capita');
    ylabel('Final Energy (EJ)');
    
    print(gcf,'-dpng','-r300',fullfile(pwd,'Energy_vs_gdp_per_cap_peak'));
end