function gps_raw_scatter_time(path, disp_type)
% GPS_RAW_SCATTER Function for plotting raw data from GPS.
% INPUT:
% path: str, path for the bag package
% disp_type: str, displaying type. "degree" or "meter"

% get data
bag_circled = rosbag(path);
bag_circled.AvailableTopics;
% get gps topic data
% NFIX = select(bag_circled,'Topic','/navsat/fix');
NFIX = select(bag_circled,'Topic','/novatel/fix');
% convert to matlab struct
msgStructs = readMessages(NFIX,'DataFormat','struct');
% get longitude and latitude, double
Lo = cellfun(@(m) double(m.Longitude),msgStructs);  % longitude (n,1)
La = cellfun(@(m) double(m.Latitude),msgStructs); % latitude (n,1)
sz = linspace(1,100,length(Lo));
c = linspace(1,10,length(Lo));

% create a new figure and plot according to 'disp_type'
% for plot in meter
if disp_type == "degree"
    % display the plot
    figure();
    hold on;
    xlabel('Longitude (deg)');
    ylabel('Latitude (deg)');
    title('Latitude & Longitude in degree');
    scatter(Lo, La, sz, c, 'filled', 'MarkerFaceAlpha',.2);
end
% for plot in meter
if disp_type == "meter"
    % convert from longitude and latitude into meter
    % shift total plot from minimun to (0,0)
    la_meter = 111034.61;
    lo_meter = 85393.83;
    Lo_m = (Lo - min(Lo)) * lo_meter;
    La_m = (La - min(La)) * la_meter;
    % display the plot
    figure();
    scatter(Lo_m, La_m, sz, c, 'filled', 'MarkerFaceAlpha',.2)
    xlabel('Longitude (meter)');
    ylabel('Latitude (meter)');
    title('Latitude & Longitude in meter');
end

end

