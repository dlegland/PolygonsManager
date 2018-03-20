function importDemoPolygonList(obj)
%IMPORTBASICPOLYGON  Imports a demo folder containing polygons coordinates files (.txt)
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none


path = fileparts(mfilename('fullpath'));
path = fullfile(path, '..', 'demoData', 'pone_small');

% open the folder selection prompt and let the user select the folder that
% contains the polygons that will be used as the polygon array
files = dir(fullfile(path, '*.txt'));

% memory allocation
polygonArray = cell(1, length(files));
nameArray = cell(1, length(files));

% if dname == 0
%     return
% end

if isempty(files)
    msgbox('The selected folder is empty');
    return;
end

if ~isempty(obj.handles.Panels)
    % if the figure already contains a polygon array
    obj = PolygonsManagerMainFrame;
end

for i = 1:length(files)
    % get the name of the polygon without the '.txt' at the end
    name = files(i).name(1:end-4);
    
    if size(Table.read(fullfile(path, files(i).name)).data,2) ~= 2
        continue
    end
    
    % save the name
    nameArray{i} = name;
    
    % save the polygon
    polygonArray{i} = Table.read(fullfile(path, files(i).name)).data;
end

polygonArray = polygonArray(~cellfun('isempty', polygonArray));
nameArray = nameArray(~cellfun('isempty', nameArray));

% set the new polygon array as the current polygon array
model = PolygonsManagerData(...
    'polygonarray', BasicPolygonArray(polygonArray), ...
    'namelist', nameArray);

%setup the frame
setupNewFrame(obj, model);
