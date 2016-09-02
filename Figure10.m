function [Chainage, Elevation] = Figure10(scratch)

% Usage:  [Days, Distance] = Figure10(Temp);
%
% Temp: The working directory where the raw data files, and dependancies
% will be downloaded to. It is recommended that pwd is used as this is
% commonly the MATLAB folder. If an alternative folder is desired this
% should be assigned using quotation marks (e.g. 'C:\Users\nm785\Documents').
%
% Days: Days since diversion
%
% Distance: Knickpoint migration distance
%
% Description: This script is used to reproduce Figure 10 within the research
% paper of Perks & Warburton (2016) Reduced fine sediment flux in response
% to the managed diversion of an upland river channel. Earth Surface
% Dynamics. Comparison of long profile surveys of the channel diversion reach
% at Glaisdale Beck: 2 March 2009 to 7 April 2014. Figure 10 of Reduced fine
% sediment flux in  response to the managed diversion of % an upland river
% channel, GitHub repository, 
% https://github.com/CatchmentSci/Glaisdale-Beck-diversion-scheme/edit/master/Figure10.m'.


cd(scratch); % Use the pre-assigned temporary space
outfilename = websave('rawData.txt','https://doi.pangaea.de/10.1594/PANGAEA.864160?format=textfile'); % Download data
websave('readtext.m', 'https://raw.githubusercontent.com/CatchmentSci/Glaisdale-Beck-diversion-scheme/master/readtext.m'); % Download dependancy

[data_text,~] = readtext(outfilename, '	', '','','textual'); % read in the tab delimeted data
Chainage = str2double(data_text(15:end,1)); % Create the distance of retreat array
Elevation = str2double(data_text(15:end,2)); % Create the days elapsed array

plot(Chainage(1:67),Elevation(1:67),'b--'); hold on;
plot(Chainage(68:end),Elevation(68:end),'b')
legend ({'2009', '2014'});
pos = get(gcf,'Position');
pos = [100,100,1341,420];
set(gcf,'Position',pos);

xLabel1 = sprintf('Longitudinal distance (m)');
xlabel(gca,xLabel1);
yLabel1 = sprintf('Local height (m)');
ylabel(gca,yLabel1);


end
