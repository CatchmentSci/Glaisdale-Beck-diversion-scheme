function [  ] = tesFun()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
addpath C:\Users\nmp65\Documents\SINATRA\Scripts\NIMRODSoftware
dirname = 'metoffice-c-band-rain-radar_uk_';
cd 'C:\Users\nmp65\Documents\SINATRA\Data\FFIR Events\2015.07.17 Scotland\1km Composite MetOffice Radar'
% read un-compressed NIMROD filenames from directory
s = dir('2015*');
file_list = {s.name}';
No_files = length(file_list);
% Set accumulation to zero
accumulation = 0;
for f = 1441:length(file_list)%1441 is the 17th
    
    % Import the shapefile of the UK
    [S, ~] = shaperead('C:\Users\nmp65\Documents\SINATRA\Data\General GIS\UK Border\infuse_uk_2011.shp');
    
    % Import the shapefile of the Alyth catchment
    [S1] = shaperead('C:\Users\nmp65\Dropbox\Scotland July 2015 Floods\Alyth July 2015\Spatial Data\Catchment Shapefile\AlythCatchment');
    
    % Import Alyth watercourse
    [S2, ~] = shaperead('C:\Users\nmp65\Documents\SINATRA\Data\FFIR Events\2015.07.17 Scotland\LiDAR & Analysis\Processing\AlythWatercourse.shp');
    
    % Plot the data on a basemap
    [A R] = geotiffread('C:\Users\nmp65\Dropbox\DataTransfer\Alyth Aerial Photos\Alyth_2005_clip1.tif');
    
    % create MATLAB figure to fill left-hand half of screen (minus taskbar at bottom)
    scrsz = get(0,'ScreenSize');
    fh1 = figure();%'OuterPosition',[1 scrsz(4)*.05 scrsz(3)*0.5 scrsz(4)* 0.95]);
    
    f1name = char(file_list(f));
    
    % read the uncompressed NIMROD composite uk-1km rain radar data file
    [int_gen_hd, ~, rl_datsp_hd, ~, ~, rr_dat_mat] = rdnim1km(f1name);
    
    % create x and y vectors one value for each pixel along edge of plot
    %NB: yg is deliberately in descending order to allow correct display of
    % both array and NG co-ordinates on plot y-axis
    xg = linspace(rl_datsp_hd(2),rl_datsp_hd(4),int_gen_hd(19));
    yg = linspace(rl_datsp_hd(1),rl_datsp_hd(5),int_gen_hd(18));
    
    % Generate a timestamp array
    timestamp{f,1} = [f1name(7:8) '/' f1name(5:6) '/' f1name(1:4) ' ' f1name(9:10) ':' f1name(11:12)];
    
    % Create a mask of the catchment
    [a1 a2] = meshgrid(xg,yg);
    rx = S1.X(1:end-1);
    ry = S1.Y(1:end-1);
    mask = inpolygon(a1,a2,rx,ry);
    
    % Convert the rainfall data to mm hr intensity rate
    rr_dat_mat_mm = rr_dat_mat./32;
    clear rr_dat_mat
    
    % Using the mask, assign all values outside of the catchment as zero
    rr_dat_mat_mm(~mask) = 0;
    
    % Convert from mm hr to mm 5mins
    rr_dat_mat_mm = rr_dat_mat_mm./12;
    
    % Replace vales of less than 0.1 mm with a value of zero
    find(rr_dat_mat_mm < 0.1);
    rr_dat_mat_mm(ans) = 0;
    
    % Calculate the accumulated volume
    accumulation = rr_dat_mat_mm + accumulation;
    
    % Create a timeseries of rainfall for the Camerton catchment at 5
    % minute intervals (mm)
    input = rr_dat_mat_mm(mask);
    input = input(:);
    Timeseries5min(f,1) = mean(input);
    
    clear rr_dat_mat_mm colordata
    
    disp(f)
    
    % Plot the data for presentation
    imagesc(xg,yg,accumulation); hold on;
    colordata = colormap;
    colordata(1,:) = [1 1 1];
    colormap(colordata); hold on;
    axis([rl_datsp_hd(2) rl_datsp_hd(4) rl_datsp_hd(5) rl_datsp_hd(1) ]);
    axis xy
    axis equal
    clims = [ 0 70 ]; % Set colour limits for image and colourbar
    caxis([clims]);
    
    titleIn = (strcat([f1name(7:8) '/' f1name(5:6) '/' f1name(1:4) ' ' f1name(9:10) ':' f1name(11:12)]));
    title(titleIn);
    colorbar;
    plot(S.X,S.Y,'k');
    plot(S1.X,S1.Y,'r');
    
    for d = 1:length(S2)
        plot(S2(d(:)).X,S2(d(:)).Y,'b');
    end
    
    % Enable/Disable the basemap display
    %h11 = mapshow(A, R);
    %set(h11,'AlphaData',0.5)
    
    xlim([315258.031233286,326715.981854381]);
    ylim([746330.388809437,758941.338780895]);
    xlabel('X BNG (m)')
    ylabel('Y BNG (m)')
    hcb = colorbar;
    title(hcb,'Accumulated Rainfall (mm)')
    refreshdata
    drawnow
    
    if max(accumulation(:) > 0) % If there is rainfall data then save the image
        namer = strcat (['C:\Users\nmp65\Documents\SINATRA\Data\FFIR Events\2015.07.17 Scotland\NIMROD Video\' f1name]);
        saveas(gcf,namer,'png') % save as a png
    end
    
    close all
end
