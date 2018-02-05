% This code is to draw locations of flood damage by month and by year across USA (Second step)

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
    
    for et=1:size(dam,1) % create FIPS number
        fips=sprintf('%d%03d',dam(et,10),dam(et,11));
        dam(et,15)=str2num(fips);
        clear fips
    end
    
    for mt=1:12
        disp(mt);
        figure('Position',[100 100 1200 600]); % figure for IYG
        
        evt=find(dam(:,3)==mt); % find month events
        X(1:34580,1:size(evt,1))=NaN;
        Y(1:170,1:size(evt,1))=NaN;
        ct=1; % count how many counties can be shown
        for e=1:size(evt,1) % selecting boundaries info for counties having broken dam
            loc=find(FIPS(:,1)==dam(evt(e,1),15));
            
            if ~isempty(loc)
                X(1:size(us_county(loc).X,2),e)= us_county(loc).X;
                Y(1:size(us_county(loc).Y,2),e)= us_county(loc).Y;
                ct=ct+1;
            end
            clear loc
        end
        X(X == 0) = NaN;
        Y(Y == 0) = NaN;
        ct_shown(mt,yr)=(ct-1)/size(evt,1); %percentage of counties shown on figures
        
        % base of USA
        for n=1:3141 % USA Map
            plot(us_county(n).X, us_county(n).Y,'Color',[0.6 0.6 0.6]); hold on;
        end
        xlim([-126 -65]);
        ylim([24 51]);
        hold on;
        % locate counties having broken dam
        for cty=1:size(X,2)
            h=fill(X(~isnan(X(:,cty)),cty),Y(~isnan(Y(:,cty)),cty),dam(evt(cty,1),4),'edgecolor','k');
        end
        %         colormap jet;
        colorbar;
        caxis([1 30])
        h = colorbar;
        ylabel(h, 'Day of Month','FontSize',20)
        
        % plot boundries of 18 Water Resource Regions
        plot(Coor(:,1),Coor(:,2),'Color','b','LineWidth',2);
        
        name=sprintf('%d %s',yr+1995, MonthNames{mt}); % name for figure
        title(name,'FontSize',20);
        axis off;
        name_1=sprintf('%d %d Flood Damage',yr+1995, mt); % name for figure
        saveas(gcf,sprintf('./figure/%s.png',name_1));
        close all
        clear name name_1 X Y cty e evt
    end
    clear dam et yr n
end

% make animation of those figures
writerObj = VideoWriter('YourAVI.avi');
open(writerObj);
for yr=1:21
    disp(yr);
    for mt=1:12
        name=sprintf('./figure/%d %d Flood Damage.png',yr+1995, mt);
        frame=imread(name);
        writeVideo(writerObj,frame);
        
        clear frame
    end
end
close(writerObj);
