% AIM: this code is to connect flood damage with top 200 counties by population
% Time: 29/01/2018
% Author: Xiuyuan Li
clc; clear all; close all;

%  CENSUS dataset
census = readtable('./PEP_2016_PEPANNRES/PEP_2016_PEPANNRES_with_ann.csv');
% extract FIPS number and population information for each county
fips_ppl=table2array([census(:,2) census(:,4)]);

% select top 100 counties having most ppl
[B,I] = sort(fips_ppl(:,2),'descend');
sort_county=fips_ppl(I,:);
clear B I census fips_ppl

% load flood damage data
load('/Users/xiuyuanli/Documents/RESEARCH/Flooding/05. Data/County/DAM_DMG.mat');

% connect flood disaster with county
for yr=1:21 % 1996 -2016
    disp(yr)
    dam=DAM_DMG(:,:,yr);  % extract dam damage data
    dam(any(isnan(dam(:,13)), 2), :) = [];
    for et=1:size(dam,1) % create FIPS number
        fips=sprintf('%d%03d',dam(et,10),dam(et,11));
        dam(et,15)=str2num(fips);
        clear fips
    end
    
    for ct=1:3142 % top 200 counties
        r=find(dam(:,15)==sort_county(ct,1));
        if ~isempty(r)
            sort_county_yr(ct,yr)=sum(dam(r,13));
            clear r
        end
    end
    clear ct dam mt et 
end
sort_county(:,3)=sum(sort_county_yr,2);
sort_county(:,4)=log(sort_county(:,3));
plot(sort_county(:,4));
xlabel('Rank of counties by people','FontSize',17);
ylabel('Log(Economic Damage[$])','FontSize',17);
title('Economic Lose by Flood for 3014 counties','FontSize',17);
xlim([0, 3200]);
saveas(gcf,sprintf('./figure/ELose_RankofPpl.png'));

scatter(log(sort_county(:,2)),sort_county(:,4),'filled');
xlabel('Log(population)','FontSize',17);
ylabel('Log(Economic Damage)','FontSize',17);
title('Population_Economic Lose','FontSize',17);
saveas(gcf,sprintf('./figure/Ppl_ELose.png'));
