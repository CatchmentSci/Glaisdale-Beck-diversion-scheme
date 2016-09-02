function [normQ, ssc] = Figure7(scratch)

% Usage:  [normQ, ssc] = Figure7(Temp);
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
% Description: This script is used to reproduce Figure 7 within the research
% paper of Perks & Warburton (2016) Reduced fine sediment flux in response
% to the managed diversion of an upland river channel. Earth Surface
% Dynamics. Median of the LOWESS model residuals grouped by (a) individual
% storm event and; (b) season, and the rainfall erosivity index grouped by
% (c) individual storm event and (d) season. The colours represent the
% different seasons with brown representing autumn; blue – winter; green –
% spring and; yellow – summer. This script can be cited as 'Perks, M.T.
% (2016) % Figure 7 of Reduced fine sediment flux in response to the
% managed diversion of % an upland river channel, GitHub repository,
% https://github.com/CatchmentSci/Glaisdale-Beck-diversion-scheme/edit/master/Figure7.m'.


cd(scratch); % Use the pre-assigned temporary space
outfilename = websave('rawData.txt','https://doi.pangaea.de/10.1594/PANGAEA.864198?format=textfile'); % Download data
websave('readtext.m', 'https://raw.githubusercontent.com/CatchmentSci/Glaisdale-Beck-diversion-scheme/master/readtext.m'); % Download dependancy
websave('replace.m', 'https://raw.githubusercontent.com/CatchmentSci/Glaisdale-Beck-diversion-scheme/master/replace.m'); % Download dependancy

[data_text,~] = readtext(outfilename, '	', '','','textual'); % read in the tab delimeted data
timeStamp = data_text(15:end,1); % Create the timestamp array
normQ = str2double(data_text(15:end,2)); % Create the normalised discharge array
ssc = str2double(data_text(15:end,3)); % Create the normalised discharge array

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
ys2 = ssc-ys2;

% Extract the data for each high flow event
eventsTime = {'23/09/2007 16:45','25/09/2007 22:45';'26/09/2007 04:15','28/09/2007 13:30';'28/09/2007 13:45','01/10/2007 20:30';'08/10/2007 20:00','12/10/2007 21:15';'30/11/2007 16:30','02/12/2007 10:00';'02/12/2007 10:15','04/12/2007 00:00';'06/12/2007 05:30','08/12/2007 12:15';'08/12/2007 12:30','09/12/2007 18:30';'09/12/2007 18:45','12/12/2007 02:00';'28/12/2007 15:45','30/12/2007 23:45';'01/01/2008 11:00','03/01/2008 13:15';'04/01/2008 05:15','06/01/2008 14:00';'07/01/2008 00:00','08/01/2008 01:00';'08/01/2008 03:30','09/01/2008 22:00';'10/01/2008 00:30','12/01/2008 07:30';'17/01/2008 05:00','19/01/2008 02:00';'20/01/2008 05:30','24/01/2008 04:30';'31/01/2008 04:00','02/02/2008 06:00';'02/02/2008 21:00','05/02/2008 01:30';'05/02/2008 04:00','07/02/2008 03:30';'09/03/2008 17:00','11/03/2008 16:30';'12/03/2008 05:00','14/03/2008 07:00';'18/03/2008 21:00','25/03/2008 08:00';'26/03/2008 16:30','29/03/2008 14:30';'29/03/2008 17:00','31/03/2008 21:30';'06/04/2008 15:00','08/04/2008 12:00';'08/04/2008 14:30','10/04/2008 09:00';'11/04/2008 15:00','13/04/2008 09:30';'15/04/2008 09:00','17/04/2008 01:00';'17/04/2008 16:00','19/04/2008 20:30';'30/04/2008 01:30','03/05/2008 14:30';'03/06/2008 03:00','06/06/2008 13:30';'18/06/2008 13:00','20/06/2008 20:00';'06/07/2008 11:00','09/07/2008 19:00';'09/07/2008 21:30','11/07/2008 06:00';'11/07/2008 06:15','13/07/2008 18:00';'31/07/2008 18:30','03/08/2008 01:30';'04/08/2008 02:30','06/08/2008 14:30';'07/08/2008 20:30','09/08/2008 07:30';'09/08/2008 10:00','11/08/2008 17:00';'12/08/2008 10:30','15/08/2008 13:30';'17/08/2008 00:30','18/08/2008 09:00';'18/08/2008 11:30','21/08/2008 02:00';'21/08/2008 14:30','22/08/2008 13:00';'22/08/2008 15:30','24/08/2008 15:00';'06/09/2008 18:00','10/09/2008 22:00';'12/09/2008 04:00','15/09/2008 14:30';'06/11/2008 06:30','07/11/2008 07:30';'07/11/2008 10:00','08/11/2008 21:00';'08/11/2008 21:15','11/11/2008 21:30';'22/11/2008 22:30','28/11/2008 11:00';'01/12/2008 11:30','03/12/2008 13:30';'04/12/2008 07:00','05/12/2008 13:00';'05/12/2008 15:30','07/12/2008 17:30';'07/12/2008 20:00','10/12/2008 00:30';'10/12/2008 10:30','12/12/2008 15:00';'12/12/2008 20:00','19/12/2008 04:30';'04/01/2009 08:00','06/01/2009 20:00';'15/01/2009 14:00','18/01/2009 14:30';'19/01/2009 08:00','21/01/2009 10:00';'21/01/2009 20:00','24/01/2009 08:00';'25/01/2009 01:30','26/01/2009 17:30';'28/01/2009 02:00','30/01/2009 14:00';'02/02/2009 19:30','05/02/2009 05:00';'09/02/2009 21:30','12/02/2009 12:00';'14/02/2009 14:00','20/02/2009 17:30';'03/03/2009 06:00','06/03/2009 19:00';'27/04/2009 03:30','30/04/2009 21:30';'04/06/2009 16:30','08/06/2009 00:30';'09/06/2009 19:00','13/06/2009 15:30';'15/06/2009 20:00','20/06/2009 00:00';'16/07/2009 06:00','20/07/2009 17:30';'21/07/2009 18:30','25/07/2009 17:30';'29/07/2009 14:00','31/07/2009 21:00';'01/08/2009 09:30','03/08/2009 14:00';'02/09/2009 16:30','04/09/2009 06:00';'04/09/2009 08:30','07/09/2009 06:30';'20/10/2009 09:30','23/10/2009 15:00';'24/10/2009 06:00','26/10/2009 20:30';'30/10/2009 22:00','06/11/2009 14:00'};
eventsTime = eventsTime(:);
Tnum = datenum(eventsTime(:,1),'dd/mm/yyyy HH:MM');
Tstr = cellstr(datestr(Tnum,'yyyy-mm-dd HH:MM:SS'));
eventsTime = regexprep(Tstr,' ','T');

% Sort highflow data (Q, SSC, residuals)
for m = 1:length(eventsTime)/2
    ind1 = find(strcmp(char(eventsTime(m,1)),timeStamp)==1);
    ind2 = find(strcmp(char(eventsTime(m+length(eventsTime)/2,1)),timeStamp)==1);
    eventsSsc(1:ind2-ind1+1,m) = ssc(ind1:ind2);
    eventsQ(1:ind2-ind1+1,m) = normQ(ind1:ind2);
    eventResiduals(1:ind2-ind1+1,m) = ys2(ind1:ind2);
end

eventsSsc = replace(eventsSsc,0,NaN);
eventsQ = replace(eventsQ,0,NaN);
eventResiduals = replace(eventResiduals,0,NaN);
xDataEvents = [733308.697916667;733311.177083333;733313.572916667;733323.833333333;733376.687500000;733378.427083333;733382.229166667;733384.520833333;733385.781250000;733404.656250000;733408.458333333;733411.218750000;733414;733415.145833333;733417.020833333;733424.208333333;733427.229166667;733438.166666667;733440.875000000;733443.166666667;733476.708333333;733479.208333333;733485.875000000;733493.687500000;733496.708333333;733504.625000000;733506.604166667;733509.625000000;733513.375000000;733515.666666667;733528.062500000;733562.125000000;733577.541666667;733595.458333333;733598.895833333;733600.260416667;733620.770833333;733624.104166667;733627.854166667;733629.416666667;733632.437500000;733637.020833333;733638.479166667;733641.604166667;733642.645833333;733657.750000000;733663.166666667;733718.270833333;733719.416666667;733720.885416667;733734.937500000;733743.479166667;733746.291666667;733747.645833333;733749.833333333;733752.437500000;733754.833333333;733777.333333333;733788.583333333;733792.333333333;733794.833333333;733798.062500000;733801.083333333;733806.812500000;733813.895833333;733818.583333333;733835.250000000;733890.145833333;733928.687500000;733933.791666667;733939.833333333;733970.250000000;733975.770833333;733983.583333333;733986.395833333;734018.687500000;734020.354166667;734066.395833333;734070.250000000;734076.916666667];

% Create the plot of the median LOWESS residuals for each event
figure('units','normalized','outerposition',[0 0 1 1]) % set full screen mode
subplot(2,2,1);
y = nanmedian(eventResiduals);
for i = 1:4
    bar(xDataEvents(i),y(i), 'facecolor', [214/255 205/255 201/255], 'EdgeColor',[214/255 205/255 201/255]); hold on % SSC
end
for i = [5:10,48:57]
    bar(xDataEvents(i),y(i), 'facecolor', [234/255 181/255 117/255], 'EdgeColor',[234/255 181/255 117/255]); hold on % SSC
end
for i = [11:25,58:67]
    bar(xDataEvents(i),y(i), 'facecolor', [164/255 187/255 226/255], 'EdgeColor',[164/255 187/255 226/255]); hold on % SSC
end
for i = [26:33,68:71]
    bar(xDataEvents(i),y(i), 'facecolor', [215/255 229/255 175/255], 'EdgeColor',[215/255 229/255 175/255]); hold on % SSC
end
for i = [34:47,72:77]
    bar(xDataEvents(i),y(i), 'facecolor', [249/255 214/255 43/255], 'EdgeColor',[249/255 214/255 43/255]); hold on % SSC
end
axis tight
yLabel2 = sprintf('Median of Residuals (mg L^{-1})');
ylabel(gca,yLabel2);
L = get(gca,'XLim');
NumTicks = 9;
set(gca,'XTick',linspace(L(1),L(2),NumTicks))
datetick('x','mmm yy')

subplot(2,2,2);
x = 1:9;
y = [13.8636101485416,-3.11762477615572,-4.62856621107093,-2.63575035855780,1.12932675399730,-10.1068325439278,-12.8560647181190,-1.31273089319590,0.490462850949093];
for i = 1
    bar(x(i),y(i), 'facecolor', [214/255 205/255 201/255], 'EdgeColor','none'); hold on % SSC
end
for i = [2,6]
    bar(x(i),y(i), 'facecolor', [234/255 181/255 117/255], 'EdgeColor','none'); hold on % SSC
end
for i = [3,7]
    bar(x(i),y(i), 'facecolor', [164/255 187/255 226/255], 'EdgeColor','none'); hold on % SSC
end
for i = [4,8]
    bar(x(i),y(i), 'facecolor', [215/255 229/255 175/255], 'EdgeColor','none'); hold on % SSC
end
for i = [5,9]
    bar(x(i),y(i), 'facecolor', [249/255 214/255 43/255], 'EdgeColor','none'); hold on % SSC
end
L = [1,9];
NumTicks = 9;
set(gca,'XTick',linspace(L(1),L(2),NumTicks))
yLabel2 = sprintf('Median of Residuals (mg L^{-1})');
ylabel(gca,yLabel2);

% Plot the erosivity data
ei30 = [35.3467414824770,2.53511541031640,0,5.49572840064507,0.791729749250766,22.5246147806980,14.1651504958363,14.3402126486797,1.81934513361011,10.9049736928724,9.56512883216621,0,0,6.74026057212480,7.49064269022697,4.77911097438868,78.1384692563035,15.4581266320974,11.2330167678768,11.8260835683550,18.5465096035627,2.43761019937789,22.8979030513931,1.83601615928475,13.8609445661623,6.98173050942338,0,7.36194848202683,10.2212604882073,2.02307678482608,11.5014324571918,148.196025604869,12.3457201622899,36.1123297748790,5.08386942096835,3.41413863111958,32.7860975496440,7.06186257362629,6.51314404546823,9.52026937894389,4.02551029145988,0,1.63652006723177,5.87999822045235,0.846253554585676,36.1699058290511,6.85334753057459,0,0.195133530530797,23.6417083967900,50.8596368184877,5.45004215849539,13.4343450286014,1.20380507334695,1.36284770976176,4.88861650014798,16.2760272851703,1.43361064567909,2.95254450969626,7.45975138815697,1.50834586245550,6.43140376231982,0.590610894930369,14.6746246902447,3.13277851507822,0,9.38737992179969,16.7777196049101,33.6291535839423,16.7105836968168,10.9220428756131,3.11385280767431,27.0400613149397,18.3503928554528,9.35230486290699,53.3313535426863,38.8105407703850,0,0,0]';
subplot(2,2,3);
y = ei30(:,1);
for i = 1:4
    bar(xDataEvents(i),y(i), 'facecolor', [214/255 205/255 201/255], 'EdgeColor',[214/255 205/255 201/255]); hold on % SSC
end
for i = [5:10,48:57]
    bar(xDataEvents(i),y(i), 'facecolor', [234/255 181/255 117/255], 'EdgeColor',[234/255 181/255 117/255]); hold on % SSC
end
for i = [11:25,58:67]
    bar(xDataEvents(i),y(i), 'facecolor', [164/255 187/255 226/255], 'EdgeColor',[164/255 187/255 226/255]); hold on % SSC
end
for i = [26:33,68:71]
    bar(xDataEvents(i),y(i), 'facecolor', [215/255 229/255 175/255], 'EdgeColor',[215/255 229/255 175/255]); hold on % SSC
end
for i = [34:47,72:77]
    bar(xDataEvents(i),y(i), 'facecolor', [249/255 214/255 43/255], 'EdgeColor',[249/255 214/255 43/255]); hold on % SSC
end
axis tight
yLabel2 = sprintf ('Event erosivity index (MJ mm ha^{-1} h^{-1})');
ylabel(gca,yLabel2);
L = get(gca,'XLim');
NumTicks = 9;
set(gca,'XTick',linspace(L(1),L(2),NumTicks))
datetick('x','mmm yy')

% Plot by seasons
seasonEi = [4.01542190548074;8.20035104675876;9.56512883216621;8.79160448511706;6.19657113296029;5.16932932932169;3.04266151238724;16.7441516508634;22.6952270851963]';
subplot(2,2,4);
x = 1:9;
y = seasonEi;
for i = 1
    bar(x(i),y(i), 'facecolor', [214/255 205/255 201/255], 'EdgeColor','none'); hold on % SSC
end
for i = [2,6]
    bar(x(i),y(i), 'facecolor', [234/255 181/255 117/255], 'EdgeColor','none'); hold on % SSC
end
for i = [3,7]
    bar(x(i),y(i), 'facecolor', [164/255 187/255 226/255], 'EdgeColor','none'); hold on % SSC
end
for i = [4,8]
    bar(x(i),y(i), 'facecolor', [215/255 229/255 175/255], 'EdgeColor','none'); hold on % SSC
end
for i = [5,9]
    bar(x(i),y(i), 'facecolor', [249/255 214/255 43/255], 'EdgeColor','none'); hold on % SSC
end
L = [1,9];
NumTicks = 9;
set(gca,'XTick',linspace(L(1),L(2),NumTicks))
yLabel2 = sprintf ('Median event erosivity index (MJ mm ha^{-1} h^{-1})');
ylabel(gca,yLabel2);

end