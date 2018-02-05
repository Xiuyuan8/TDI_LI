% AIM: this code is to calculate summary damage cause by flood events.
% Time: 29/01/2018
% Author: Xiuyuan Li

clc; clear all; close all;

% load data
load('US_county_borders') % load US counties boundaries
load('fips.mat'); % load the fips order
load('/Users/xiuyuanli/Documents/RESEARCH/Flooding/05. Data/County/DAM_DMG.mat');
% load('US_county_info');
load('/Users/xiuyuanli/Documents/RESEARCH/Flooding/05. Data/Basin Delineation/USA_18.mat'); % load boundaries of 18 water resource regions
MonthNames = {'January','February','March','April','May','June','July','August',...
    'September','October','November','December'};

for yr=1:21
    disp(yr);
    dam=DAM_DMG(:,:,yr);  % extract dam damage data
    dam(any(isnan(dam(:,1)), 2), :) = [];
    dam_yr_mth(yr,1)=nansum(dam(:,13))+nansum(dam(:,14));
    
    for mt=1:12 % by month
        r=find(dam(:,3)==mt);
        dam_yr_mth(yr,1+mt)=nansum(dam(r,13))+nansum(dam(r,14));
    end
    bar(dam_yr_mth(yr,2:13))
    xlabel('Month', 'FontSize',17);
    ylabel('Flood Damage', 'FontSize',17);
    str=num2str(yr+1995);
    title(str, 'FontSize',17);
    saveas(gcf,sprintf('./figure/%s.png',str));
    close all
    clear dam
end
% see how flood damage changes through years
bar(dam_yr_mth(:,1));
xlabel('Year 1996-2016', 'FontSize',17);
ylabel('Flood Damage', 'FontSize',17);
xlim([1 22]);
title('Flood damage by year', 'FontSize',17);
saveas(gcf,sprintf('./figure/Flood damage by year.png'));
close all
