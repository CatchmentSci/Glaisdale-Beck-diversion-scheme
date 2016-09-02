function [Days, Distance] = Figure9(scratch)

% Usage:  [Days, Distance] = Figure9(Temp);
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
% Description: This script is used to reproduce Figure 9 within the research
% paper of Perks & Warburton (2016) Reduced fine sediment flux in response
% to the managed diversion of an upland river channel. Earth Surface
% Dynamics. Plot between days since diversion and distance of headward
% knickpoint migration (m). Figure 9 of Reduced fine sediment flux in 
% response to the % managed diversion of % an upland river channel, 
% GitHub repository, https://github.com/CatchmentSci/Glaisdale-Beck-diversion-scheme/edit/master/Figure9.m'.


cd(scratch); % Use the pre-assigned temporary space
outfilename = websave('rawData.txt','https://doi.pangaea.de/10.1594/PANGAEA.864159?format=textfile'); % Download data
websave('readtext.m', 'https://raw.githubusercontent.com/CatchmentSci/Glaisdale-Beck-diversion-scheme/master/readtext.m'); % Download dependancy

[data_text,~] = readtext(outfilename, '	', '','','textual'); % read in the tab delimeted data
Days = str2double(data_text(14:end,2)); % Create the days elapsed array
Distance = str2double(data_text(14:end,3)); % Create the distance of retreat array

x1 = 0:2372;
y1 = 173.3.*(1 - 0.99.^x1); % Calculate the asymptote fit
plot(x1,y1,'color','k','linestyle','-','linewidth',2); hold on
scatter(Days,Distance,'b+')
yLabel2 = sprintf('Knickpoint migration distance (m)');
ylabel(gca,yLabel2);
xLabel2 = sprintf('Days since diversion');
xlabel(gca,xLabel2);

end
