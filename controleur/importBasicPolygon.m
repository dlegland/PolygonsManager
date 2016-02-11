function importBasicPolygon(obj)
%IMPORTBASICPOLYGON  Imports a folder containing polygons coordinates files (.txt) and make it the current polygon array
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% open the folder selection prompt and let the user select the folder that
% contains the polygons that will be used as the polygon array
dname = uigetdir;
files = dir(fullfile(dname, '*txt'));

% memory allocation
polygonArray = cell(1,length(files));
nameArray = cell(1, length(files));

if dname ~= 0
    if ~isempty(files)
        if ~isempty(obj.handles.Panels)
        % if the figure already contains a polygon array
            obj = PolygonsManagerMainFrame;
        end
        
        for i = 1:length(files)
            % get the name of the polygon without the '.txt' at the end
            name = files(i).name(1:end-4);
            
            % save the name
            nameArray{i} = name;
            
            % save the polygon 
            polygonArray{i} = Table.read(fullfile(dname, files(i).name)).data;
        end
        
        % set the new polygon array as the current polygon array
        model = PolygonsManagerData('PolygonArray', BasicPolygonArray(polygonArray), 'nameList', nameArray);
        
        %setup the frame
        setupNewFrame(obj, model);
    else
        msgbox('The selected folder is empty');
    end
end
end
