function [normQ, ssc] = Figure5(scratch)

% Usage:  [normQ, ssc] = Figure5(Temp);
%
% Temp: The working directory where the raw data files, and dependancies
% will be downloaded to. It is recommended that pwd is used as this is 
% commonly the MATLAB folder. If an alternative folder is desired this 
% should be assigned using quotation marks (e.g. 'C:\Users\nm785\Documents').
%
% normQ: Normalised river discharge data
%
% ssc: Suspended sediment concentration data
%
% Description: This script utilises data deposited at
% https://doi.pangaea.de/10.1594/PANGAEA.864198. The contents of which are
% used to reproduce Figure 5 within the research paper of Perks & Warburton
% (2016) Reduced fine sediment flux in response to the managed diversion of
% an upland river channel. Earth Surface Dynamics. The output is Figure 5
% of the aforementioned paper

cd(scratch); % Use the pre-assigned temporary space
outfilename = websave('rawData.txt','https://doi.pangaea.de/10.1594/PANGAEA.864198?format=textfile'); % Download data
websave('readtext.m', 'https://raw.githubusercontent.com/CatchmentSci/Glaisdale-Beck-diversion-scheme/master/readtext.m'); % Download dependancy
[data_text,~] = readtext(outfilename, '	', '','','textual'); % read in the tab delimeted data
timeStamp = data_text(15:end,1); % Create the timestamp array
normQ = str2double(data_text(15:end,2)); % Create the normalised discharge array
ssc = str2double(data_text(15:end,3)); % Create the normalised discharge array

%Prep the data for Figure 5a
preQ = normQ(1:1776); % Extract data from the pre-monitoring period i.e. 21/09/07 - 09/10/07
preSsc = ssc (1:1776);

% Log-log anlaysis
log10x = log10(preQ); % Assign the x and y data
log10y = log10(preSsc);
log10x1 = log10x;
length(log10x1);
log10x1(1:ans,2) = 1; % Prep the data for regression
[b,bint,r,rint,stats] = regress(log10y,log10x1); % Run the regression
OriginalLog_r2 = stats(1,1); % Pull out the R2 value
OriginalLog_p = stats(1,3); % Pull out the p value
log10a = b(2,1); % Pull out the a coefficient in log
log10b = b(1,1); % Pull out the b coefficient in log
a = 10^log10a; % Convert from log10 to exp

% & plot of pre-diversion data
larger = preQ.*1000;
maxi = max(larger);
xvalues = 1:0.5:max(larger);
xvalues = xvalues./1000;
i1 = min(preQ);
i2 = dsearchn(xvalues',i1);
xvalues1 = xvalues(i2:end);
xvalues = xvalues1;
curvefit1 = a.*xvalues.^log10b; % Produce data for regular power fit
subplot(1,2,1);
scatter(log10(preQ),log10(preSsc),'b+'); hold on
plot(log10(xvalues),log10(curvefit1), 'color', 'r', 'linestyle','-','linewidth',2);

%Prep the data for Figure 5b
subplot(1,2,2);
afterQ = normQ(1830:end); % Extract data from the post-diversion monitoring period (i.e. 12/10/07 - 12/11/09)
afterSsc = ssc (1830:end);

% Remove corrupted data from the record prior to analysis
removeTimeStartStop = {'22/10/2007 08:15';'04/11/2007 00:30';'13/01/2008 08:30';'15/01/2008 03:00';'30/03/2008 03:00';'30/04/2008 09:00';'15/05/2008 11:30';'04/06/2008 14:00';'26/06/2008 23:30';'12/07/2008 04:30';'13/09/2008 10:00';'23/10/2008 05:00';'20/02/2009 00:00';'05/03/2009 05:30';'25/03/2009 13:00';'10/05/2009 06:30';'30/06/2009 05:00';'29/10/2007 16:00';'28/11/2007 14:45';'14/01/2008 22:00';'15/01/2008 13:00';'05/04/2008 04:00';'04/05/2008 15:30';'18/05/2008 17:00';'07/06/2008 17:00';'03/07/2008 15:30';'25/07/2008 20:00';'15/10/2008 17:00';'06/11/2008 06:30';'26/02/2009 03:30';'21/03/2009 14:00';'04/04/2009 03:00';'13/05/2009 17:00';'13/07/2009 10:30'};
Tnum = datenum(removeTimeStartStop(:,1),'dd/mm/yyyy HH:MM');
Tstr = cellstr(datestr(Tnum,'yyyy-mm-dd HH:MM:SS'));
removeTimeStartStop = regexprep(Tstr,' ','T');

% Remove the corrupted SSC data from the entire series
for m = 1:length(removeTimeStartStop)/2
    ind1 = find(strcmp(char(removeTimeStartStop(m,1)),timeStamp)==1);
    ind2 = find(strcmp(char(removeTimeStartStop(m+17,1)),timeStamp)==1);
    afterSsc(ind1:ind2) = NaN;
end

num_array = find(~isnan(afterQ)&~isnan(afterSsc));
afterQ = afterQ(num_array);
afterSsc = afterSsc(num_array);

% Log-log anlaysis
log10x = log10(afterQ); % Assign the x and y data
log10y = log10(afterSsc);
log10x1 = log10x;
length(log10x1);
log10x1(1:ans,2) = 1; % Prep the data for regression
[b,bint,r,rint,stats] = regress(log10y,log10x1); % Run the regression
OriginalLog_r2 = stats(1,1); % Pull out the R2 value
OriginalLog_p = stats(1,3); % Pull out the p value
log10a = b(2,1); % Pull out the a coefficient in log
log10b = b(1,1); % Pull out the b coefficient in log
a = 10^log10a; % Convert from log10 to exp

% Plot of post-diversion data
larger = afterQ.*1000;
maxi = max(larger);
xvalues = 1:0.5:max(larger);
xvalues = xvalues./1000;
i1 = min(afterQ);
i2 = dsearchn(xvalues',i1);
xvalues1 = xvalues(i2:end);
xvalues = xvalues1;
curvefit1 = a.*xvalues.^log10b; % Produce data for regular power fit
subplot(1,2,2);
scatter(log10(afterQ),log10(afterSsc),'b+'); hold on
plot(log10(xvalues),log10(curvefit1), 'color', 'r', 'linestyle','-','linewidth',2); hold on

% Run for Qnorm > TV (i.e. 4.6323)
i3 = find(afterQ>4.6323); afterQTVplus = afterQ(i3); afterSscTVplus = afterSsc(i3); % Find data above the threshold
log10x = log10(afterQTVplus); % Assign the x and y data
log10y = log10(afterSscTVplus);
log10x1 = log10x;
length(log10x1);
log10x1(1:ans,2) = 1; % Prep the data for regression
[b,bint,r,rint,stats] = regress(log10y,log10x1); % Run the regression
OriginalLog_r2 = stats(1,1); % Pull out the R2 value
OriginalLog_p = stats(1,3); % Pull out the p value
log10a = b(2,1); % Pull out the a coefficient in log
log10b = b(1,1); % Pull out the b coefficient in log
a = 10^log10a; % Convert from log10 to exp

% This is the log-log section
larger = afterQTVplus.*1000;
maxi = max(larger);
xvalues = 1:0.5:max(larger);
xvalues = xvalues./1000;
i1 = min(afterQTVplus);
i2 = dsearchn(xvalues',i1);
xvalues1 = xvalues(i2:end);
xvalues = xvalues1;
curvefit1 = a.*xvalues.^log10b; % Produce data for regular power fit
plot(log10(xvalues),log10(curvefit1), 'color', 'k', 'linestyle','-','linewidth',2);

% Run for Qnorm < TV (i.e. 4.6323)
i3 = find(afterQ<4.6323); afterQTVminus = afterQ(i3); afterSscTVminus = afterSsc(i3);
log10x = log10(afterQTVminus); % Assign the x and y data
log10y = log10(afterSscTVminus);
log10x1 = log10x;
length(log10x1);
log10x1(1:ans,2) = 1; % Prep the data for regression
[b,bint,r,rint,stats] = regress(log10y,log10x1); % Run the regression
OriginalLog_r2 = stats(1,1); % Pull out the R2 value
OriginalLog_p = stats(1,3); % Pull out the p value
log10a = b(2,1); % Pull out the a coefficient in log
log10b = b(1,1); % Pull out the b coefficient in log
a = 10^log10a; % Convert from log10 to exp

% This is the log-log section
larger = afterQTVminus.*1000;
maxi = max(larger);
xvalues = 1:0.5:max(larger);
xvalues = xvalues./1000;
i1 = min(afterQTVminus);
i2 = dsearchn(xvalues',i1);
xvalues1 = xvalues(i2:end);
xvalues = xvalues1;
curvefit1 = a.*xvalues.^log10b; % Produce data for regular power fit
plot(log10(xvalues),log10(curvefit1), 'color', 'k', 'linestyle','-','linewidth',2);

% Optimize the graphs
subplot(1,2,2);
xLim = get(gca,'Xlim');
yLim = get(gca, 'YLim');
set(gca,'XGrid','on')
set(gca,'YGrid','on')

tt1 = get(gca,'XTickLabel');
for a = 1:length(tt1)
    tt2(a,1) = {['10^' char(tt1(a,:))]};
end
set(gca,'XTickLabel',tt2);

tt3 = get(gca,'YTickLabel');
for a = 1:length(tt3)
    tt4(a,1) = {['10^' char(tt3(a,:))]};
end
set(gca,'YTickLabel',tt4);

subplot(1,2,1);
xlim(gca,xLim);
ylim(gca,yLim);
set(gca,'XGrid','on')
set(gca,'YGrid','on')

set(gca,'XTickLabel',tt2);
set(gca,'YTickLabel',tt4);

xLabel1 = sprintf('Normalised Discharge(m^{3} s^{-1})');
xlabel(gca,xLabel1);
yLabel1 = sprintf('SSC (mg L^{-1})');
ylabel(gca,yLabel1);

end
