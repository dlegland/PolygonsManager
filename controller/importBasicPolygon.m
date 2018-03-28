function importBasicPolygon(obj)
%IMPORTBASICPOLYGON  Imports a folder containing polygons coordinates files (.txt) and make it the current polygon array
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% open the folder selection prompt and let the user select the folder that
% contains the polygons that will be used as the polygon array
dname = uigetdir;
files = dir(fullfile(dname, '*.txt'));

% memory allocation
nFiles = length(files);
polygonArray = cell(1, nFiles);
nameArray = cell(1, nFiles);

if dname == 0
    return
end

if isempty(files)
    msgbox('The selected folder is empty');
    return;
end

if ~isempty(obj.handles.Panels)
    % if the figure already contains a polygon array
    obj = PolygonsManagerMainFrame;
end

% create waitbar
h = waitbar(0, 'Please wait...', 'name', 'Reading polygons');

for i = 1:length(files)
    % get the name of the polygon without the '.txt' at the end
    name = files(i).name(1:end-4);
    
    if size(Table.read(fullfile(dname, files(i).name)).data,2) ~= 2
        continue
    end
    waitbar(i / (nFiles+1), h, ['process : ' name]);
    
    % save the name
    nameArray{i} = name;
    
    % save the polygon
    polygonArray{i} = Table.read(fullfile(dname, files(i).name)).data;
end

% cleanup polygon array
polygonArray = polygonArray(~cellfun('isempty', polygonArray));
nameArray = nameArray(~cellfun('isempty', nameArray));

% close waitbar
waitbar(1, h);
close(h) 

% set the new polygon array as the current polygon array
model = PolygonsManagerData(...
    'polygonarray', BasicPolygonArray(polygonArray), ...
    'namelist', nameArray);

%setup the frame
setupNewFrame(obj, model);
