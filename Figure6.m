function [normQ, ssc] = Figure6(scratch)

% Usage:  [normQ, ssc] = Figure6(Temp);
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
% Description: This script is used to reproduce Figure 6 within the research
% paper of Perks & Warburton (2016) Reduced fine sediment flux in response
% to the managed diversion of an upland river channel. Earth Surface
% Dynamics. Figure 6. (a) Suspended sediment concentrations and (b) residuals
% over the entire monitoring period as a result of (c) the LOWESS
% model developed between normalized discharge and suspended sediment
% concentrations.% This script can be cited as 'Perks, M.T. (2016)
% Figure 5 of Reduced fine sediment flux in response to the managed diversion of
% an upland river channel, GitHub repository,
% https://github.com/CatchmentSci/Glaisdale-Beck-diversion-scheme/edit/master/Figure6.m'.


cd(scratch); % Use the pre-assigned temporary space
outfilename = websave('rawData.txt','https://doi.pangaea.de/10.1594/PANGAEA.864198?format=textfile'); % Download data
websave('readtext.m', 'https://raw.githubusercontent.com/CatchmentSci/Glaisdale-Beck-diversion-scheme/master/readtext.m'); % Download dependancy
[data_text,~] = readtext(outfilename, '	', '','','textual'); % read in the tab delimeted data
timeStamp = data_text(15:end,1); % Create the timestamp array
normQ = str2double(data_text(15:end,2)); % Create the normalised discharge array
ssc = str2double(data_text(15:end,3)); % Create the normalised ssc array

% Remove corrupted data from the record prior to analysis
removeTimeStartStop = {'22/10/2007 08:15';'04/11/2007 00:30';'13/01/2008 08:30';'15/01/2008 03:00';'30/03/2008 03:00';'30/04/2008 09:00';'15/05/2008 11:30';'04/06/2008 14:00';'26/06/2008 23:30';'12/07/2008 04:30';'13/09/2008 10:00';'23/10/2008 05:00';'20/02/2009 00:00';'05/03/2009 05:30';'25/03/2009 13:00';'10/05/2009 06:30';'30/06/2009 05:00';'29/10/2007 16:00';'28/11/2007 14:45';'14/01/2008 22:00';'15/01/2008 13:00';'05/04/2008 04:00';'04/05/2008 15:30';'18/05/2008 17:00';'07/06/2008 17:00';'03/07/2008 15:30';'25/07/2008 20:00';'15/10/2008 17:00';'06/11/2008 06:30';'26/02/2009 03:30';'21/03/2009 14:00';'04/04/2009 03:00';'13/05/2009 17:00';'13/07/2009 10:30'};
Tnum = datenum(removeTimeStartStop(:,1),'dd/mm/yyyy HH:MM');
Tstr = cellstr(datestr(Tnum,'yyyy-mm-dd HH:MM:SS'));
removeTimeStartStop = regexprep(Tstr,' ','T');

% Remove the corrupted SSC data from the entire series
for m = 1:length(removeTimeStartStop)/2
    ind1 = find(strcmp(char(removeTimeStartStop(m,1)),timeStamp)==1);
    ind2 = find(strcmp(char(removeTimeStartStop(m+17,1)),timeStamp)==1);
    ssc(ind1:ind2) = NaN;
end

% Perform the LOWESS analysis
[xy, ~] = sortrows([normQ,ssc]);
span = 0.1340; %This has been optimised
ys1 = smooth(xy(:,1),xy(:,2),span,'loess');
ys2 = smooth(normQ,ssc,span,'loess'); % Residuals

% Prep the x-axis (time) data for input
tStart = timeStamp(1,1); tStart = regexprep(tStart,'T',' ');
tEnd = timeStamp(end); tEnd = regexprep(tEnd,'T',' ');
xData = linspace(datenum(tStart,'yyyy-mm-dd HH:MM:SS'),datenum(tEnd,'yyyy-mm-dd HH:MM:SS'),length(timeStamp));

figure();
subplot(2,2,1);
plot(xData',ssc,'color','b','linestyle','-','linewidth',1); hold on % SSC
axis tight
L = get(gca,'YLim');
set(gca,'YLim',[0 L(2)])
yLabel2 = sprintf('SSC (mg L^{-1})');
ylabel(gca,yLabel2);
L = get(gca,'XLim');
NumTicks = 4;
set(gca,'XTick',linspace(L(1),L(2),NumTicks))
datetick('x','mmm yy', 'keepticks')

subplot(2,2,3);
plot(xData,ssc - ys2, 'color','b','linestyle','-','linewidth',1); hold on
axis tight
L = get(gca,'YLim');
yLabel2 = sprintf('LOWESS Residuals (mg L^{-1})');
ylabel(gca,yLabel2);
L = get(gca,'XLim');
NumTicks = 4;
set(gca,'XTick',linspace(L(1),L(2),NumTicks))
datetick('x','mmm yy', 'keepticks')

subplot(2,2,[2 4]);
h1 = scatter(normQ,ssc, 'b+'); hold on % Scatter all the data
h3 = line(xy(:,1), ys1,'color','r','linestyle','-','linewidth',2); hold off % Plot the loess fit over the top
set(gca,'XGrid','on')
set(gca,'YGrid','on')
xLabel1 = sprintf('Normalised Discharge(m^{3} s^{-1})');
xlabel(gca,xLabel1);
yLabel1 = sprintf('SSC (mg L^{-1})');
ylabel(gca,yLabel1);

end
