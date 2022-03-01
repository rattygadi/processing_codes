%% Comment the next three lines after debugging
clear all;
clc;
close all;

Data = load('World_data.mat');
Tstart = 2000:10:2090;
Tend = 2010:10:2100;

%%
for i=1:length(Tstart)
    ind = [];
    for j=1:length(Data.var_data.zero_year)
        if((Data.var_data.zero_year(j)>=Tstart(i))&&(Data.var_data.zero_year(j)<Tend(i)))
            ind = [ind j];
        end
    end
    index{i} = ind;
end
Marker = {'-o','-+','-*','-d','-x','-s','-^','-p','-h','->'};
Color = {'','','','r','b','c','m','y','g',[0.6350 0.0780 0.1840]};
MarkerSize = {5,5,5,5,5,8,5,5,5,5,5};
%% Taking the first scenario
figure('units','normalized','outerposition',[0 0 1 1]);
ax1 = subplot(3,1,1);
count = 1;
for i=1:length(Tstart)
    if(length(index{i})>0)
        %ind_choice = max(
         ind_choice(i) = Data.var_data.gdp_ppp.scen(find(max(Data.var_data.gdp_ppp.net_zero(finds(Data.var_data.gdp_ppp.scen,index{i})))==Data.var_data.gdp_ppp.net_zero));
%        ind_choice(i) = min(index{i});
        PP = plot(Data.var_data.time{ind_choice(i),1},Data.var_data.data{ind_choice(i),1}/10^3,Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
leg{count} = 'Net zero';
plot([2000 2100],[0 0],'--','Color','k');
legend(leg,'Location','eastoutside');
ylabel(ax1,'CO_2 emissions (Gt)');
xlabel(ax1,'Time (yr)');

ax2 = subplot(3,1,2);
count = 1;
for i=1:length(Tstart)
    if(length(index{i})>0)
        PP = plot(Data.var_data.time{ind_choice(i),2},Data.var_data.data{ind_choice(i),2}/10^3,Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        %leg{count} = num2str((Tstart(i) + Tend(i))/2);
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
leg{count} = 'Net zero';
plot([2000 2100],[0 0],'--','Color','k');
legend(leg,'Location','eastoutside');
ylabel(ax2,'CO_2 emissions (Gt) (AFOLU)');
xlabel(ax2,'Time (yr)');

ax3 = subplot(3,1,3);
count = 1;
for i=1:length(Tstart)
    if(length(index{i})>0)
        PP = plot(Data.var_data.time{ind_choice(i),3},Data.var_data.data{ind_choice(i),3}/10^3,Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        %leg{count} = num2str((Tstart(i) + Tend(i))/2);
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
leg{count} = 'Net zero';
plot([2000 2100],[0 0],'--','Color','k');
legend(leg,'Location','eastoutside');
ylabel(ax3,'CO_2 emissions (Gt) (Fossil)');
xlabel(ax3,'Time (yr)');
print(gcf,'-dpng','-r300',fullfile(pwd,'CO2emissions'));

figure('units','normalized','outerposition',[0 0 1 1]);
ax1 = subplot(3,1,1);
count = 1; clear leg;
for i=1:length(Tstart)
    if(length(index{i})>0&&~isempty(Data.var_data.data{ind_choice(i),5}))
        PP = plot(Data.var_data.time{ind_choice(i),5},-Data.var_data.data{ind_choice(i),5}/10^3,Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
legend(leg,'Location','eastoutside');
%plot([0 0],[2000 2100],'--');
ylabel(ax1,'CCS (Total)');
xlabel(ax1,'Time (yr)');

clear leg;
ax2 = subplot(3,1,2);
count = 1;
for i=1:length(Tstart)
    if(length(index{i})>0&&~isempty(Data.var_data.data{ind_choice(i),5+1}))
        PP = plot(Data.var_data.time{ind_choice(i),6},-Data.var_data.data{ind_choice(i),6}/10^3,Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        %leg{count} = num2str((Tstart(i) + Tend(i))/2);
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
legend(leg,'Location','eastoutside');
%plot([0 0],[2000 2100],'--');
ylabel(ax2,'CCS (BECCS)');
xlabel(ax2,'Time (yr)');

clear leg;
ax3 = subplot(3,1,3);
count = 1;
for i=1:length(Tstart)
    if(length(index{i})>0&&~isempty(Data.var_data.data{ind_choice(i),7}))
        PP = plot(Data.var_data.time{ind_choice(i),7},-(Data.var_data.data{ind_choice(i),7})/10^3,Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        %leg{count} = num2str((Tstart(i) + Tend(i))/2);
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
legend(leg,'Location','eastoutside');
%plot([0 0],[2000 2100],'--');
ylabel(ax3,'CCS (Land Use)');
xlabel(ax3,'Time (yr)');
print(gcf,'-dpng','-r300',fullfile(pwd,'CCS'));
clear leg;
%% Policy cost for the various scenario's
% figure('units','normalized','outerposition',[0 0 1 1]);
% ax1 = subplot(2,1,1);
% for i=1:length(Tstart)
%     if(length(index{i})>0&&~isempty(Data.var_data.data{ind_choice(i),10}))
%         plot(Data.var_data.time{ind_choice(i),10},(Data.var_data.data{ind_choice(i),10}),Marker{i},'MarkerSize',MarkerSize{i});
%         %leg{count} = num2str((Tstart(i) + Tend(i))/2);
%         leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
%         hold on;
%         count = count + 1;
%     end
% end
% legend(leg,'Location','eastoutside');
% %plot([0 0],[2000 2100],'--');
% xlabel(ax1,'Time (yr)');
% ylabel(ax1,'Policy Cost (Consumption Loss)');
% 
% clear leg;
% ax2 = subplot(2,1,2);
% for i=1:length(Tstart)
%     if(length(index{i})>0&&~isempty(Data.var_data.data{ind_choice(i),11}))
%         plot(Data.var_data.time{ind_choice(i),11},(Data.var_data.data{ind_choice(i),11}),Marker{i},'MarkerSize',MarkerSize{i});
%         %leg{count} = num2str((Tstart(i) + Tend(i))/2);
%         leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
%         hold on;
%         count = count + 1;
%     end
% end
% legend(leg,'Location','eastoutside');
% %plot([0 0],[2000 2100],'--');
% xlabel(ax2,'Time (yr)');
% ylabel(ax2,'Policy Cost (GDP Loss)');
% print(gcf,'-dpng','-r300',fullfile(pwd,'Policy cost'));
clear leg;
%% 
% figure;
% for i=1:length(Tstart)
%     if(length(index{i})>0)
%         plot(Data.var_data.time{min(index{i}),10},(Data.var_data.data{min(index{i}),10}));
%         leg{count} = num2str((Tstart(i) + Tend(i))/2);
%         hold on;
%         count = count + 1;
%     end
% end

figure('units','normalized','outerposition',[0 0 1 1]);
count = 1;
for i=1:length(Tstart)
    if(length(index{i})>0&&~isempty(Data.var_data.data{ind_choice(i),32}))
        %ind_choice = max(
        %ind_choice(i) = find(max(Data.var_data.gdp_ppp.net_zero(finds(Data.var_data.gdp_ppp.scen,index{i})))==Data.var_data.gdp_ppp.net_zero);
        PP = plot(Data.var_data.time{ind_choice(i),32},Data.var_data.data{ind_choice(i),32},Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        %leg{count} = num2str((Tstart(i) + Tend(i))/2);
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
legend(leg,'Location','eastoutside');
xlabel('Time (yr)');
ylabel('Carbon Price ($ t/CO_2)');
print(gcf,'-dpng','-r300',fullfile(pwd,'Carbon_price'));

figure('units','normalized','outerposition',[0 0 1 1]);
ax1 = subplot(3,1,1);
count = 1;clear leg;
for i=1:length(Tstart)
    if(length(index{i})>0&&~isempty(Data.var_data.data{ind_choice(i),33}))
        %ind_choice = max(
        %ind_choice(i) = find(max(Data.var_data.gdp_ppp.net_zero(finds(Data.var_data.gdp_ppp.scen,index{i})))==Data.var_data.gdp_ppp.net_zero);
        PP = plot(Data.var_data.time{ind_choice(i),33},Data.var_data.data{ind_choice(i),33},Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        %leg{count} = num2str((Tstart(i) + Tend(i))/2);
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
legend(leg,'Location','eastoutside');
xlabel(ax1,'Time (yr)');
ylabel(ax1,'Primary Energy (EJ/yr)');

clear leg;
ax2 = subplot(3,1,2);
count = 1;
for i=1:length(Tstart)
    if(length(index{i})>0&&~isempty(Data.var_data.data{ind_choice(i),34}))
        %ind_choice = max(
        %ind_choice(i) = find(max(Data.var_data.gdp_ppp.net_zero(finds(Data.var_data.gdp_ppp.scen,index{i})))==Data.var_data.gdp_ppp.net_zero);
        PP = plot(Data.var_data.time{ind_choice(i),34},Data.var_data.data{ind_choice(i),34}./Data.var_data.data{ind_choice(i),33}*100,Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        %leg{count} = num2str((Tstart(i) + Tend(i))/2);
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
legend(leg,'Location','eastoutside');
xlabel(ax2,'Time (yr)');
ylabel(ax2,{'% of Primary Energy';'from Fossils (EJ/yr)'});

clear leg;
ax3 = subplot(3,1,3);
count = 1;
for i=1:length(Tstart)
    if(length(index{i})>0&&~isempty(Data.var_data.data{ind_choice(i),34}))
        %ind_choice = max(
        %ind_choice(i) = find(max(Data.var_data.gdp_ppp.net_zero(finds(Data.var_data.gdp_ppp.scen,index{i})))==Data.var_data.gdp_ppp.net_zero);
        PP = plot(Data.var_data.time{ind_choice(i),34},(Data.var_data.data{ind_choice(i),33}-.....
            Data.var_data.data{ind_choice(i),34})./Data.var_data.data{ind_choice(i),33}*100,...
            Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        %leg{count} = num2str((Tstart(i) + Tend(i))/2);
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
legend(leg,'Location','eastoutside');
xlabel(ax3,'Time (yr)');
ylabel(ax3,{'% of Primary Energy';'from Renewable (EJ/yr)'});
print(gcf,'-dpng','-r300',fullfile(pwd,'Energy systems'));

% %% THIS DOES NOT WORK. DONT THINK THIS
% figure;
% count = 1;
% for i=1:length(Tstart)
%     if(length(index{i})>0)
%         %ind_choice = max(
%         %ind_choice(i) = find(max(Data.var_data.gdp_ppp.net_zero(finds(Data.var_data.gdp_ppp.scen,index{i})))==Data.var_data.gdp_ppp.net_zero);
%         plot(Data.var_data.time{ind_choice(i),39},Data.var_data.data{ind_choice(i),39});
%         leg{count} = num2str((Tstart(i) + Tend(i))/2);
%         hold on;
%         count = count + 1;
%     end
% end
% legend(leg);
% xlabel('Time (yr)');
% ylabel('Investment (GW)');
% print(gcf,'-dpng','-r300',fullfile(pwd,'Investment'));

clear leg;
figure('units','normalized','outerposition',[0 0 1 1]);
ax1 = subplot(2,1,1);
count = 1;
for i=1:length(Tstart)
    if(length(index{i})>0&&~isempty(Data.var_data.data{ind_choice(i),4}))
        %ind_choice = max(
        %ind_choice(i) = find(max(Data.var_data.gdp_ppp.net_zero(finds(Data.var_data.gdp_ppp.scen,index{i})))==Data.var_data.gdp_ppp.net_zero);
        PP = plot(Data.var_data.time{ind_choice(i),4},Data.var_data.data{ind_choice(i),4},Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        Ty{i,:} = Data.var_data.data{ind_choice(i),4};
        %leg{count} = num2str((Tstart(i) + Tend(i))/2);
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
legend(leg,'Location','eastoutside');
xlabel(ax1,'Time (yr)');
ylabel(ax1,'GDP');

clear leg;
%figure;
ax2 = subplot(2,1,2);
count = 1;
for i=1:length(Tstart)
    if(length(index{i})>0&&~isempty(Data.var_data.data{ind_choice(i),12}))
        %ind_choice = max(
        %ind_choice(i) = find(max(Data.var_data.gdp_ppp.net_zero(finds(Data.var_data.gdp_ppp.scen,index{i})))==Data.var_data.gdp_ppp.net_zero);
        var = Data.var_data.data{ind_choice(i),4}./....
            interp1(Data.var_data.time{ind_choice(i),12},Data.var_data.data{ind_choice(i),12},Data.var_data.time{ind_choice(i),4});
        PP = plot(Data.var_data.time{ind_choice(i),4},var,Marker{i},'MarkerSize',MarkerSize{i});
        PP.Color = Color{i};
        clear var;
        %Ty{i,:} = Data.var_data.data{ind_choice(i),4};
        %leg{count} = num2str((Tstart(i) + Tend(i))/2);
        leg{count} = strcat(num2str(Tstart(i)),"-",num2str(Tend(i)));
        hold on;
        count = count + 1;
    end
end
legend(leg,'Location','eastoutside');
xlabel(ax2,'Time (yr)');
ylabel(ax2,'GDP/capita');
print(gcf,'-dpng','-r300',fullfile(pwd,'GDP'));