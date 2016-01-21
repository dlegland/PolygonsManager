function importPolygonArray(~,~, obj)
%IMPORTPOLYGONARRAY  Imports a folder containing polygons coordinates files (.txt) and make it the current polygon array
%
%   Inputs :
%       - ~ (not used) : inputs automatically send by matlab during a callback
%       - obj : handle of the MainFrame
%   Outputs : none

dname = uigetdir('C:\Stage2016_Thomas\data_plos\slabs\images');

files = dir(fullfile(dname, '*txt'));

polygonArray = cell(1,length(files));
nameArray = cell(1, length(files));

if dname ~= 0
    if ~isempty(files)
        if ~isempty(obj.handles.panels)
            obj = MainFrame;
        end
        h = waitbar(0,'Début de l''import', 'name', 'Chargement des contours');
        for i = 1:length(files)
            name = files(i).name(1:end-4);
            nameArray{i} = name;

            polygonArray{i} = Table.read(fullfile(dname, files(i).name)).data;

            waitbar(i / length(files), h, ['process : ' name]);
        end
        close(h)
        polygons = BasicPolygonArray(polygonArray);
        set(obj.handles.list, 'string', nameArray);
        setPolygonArray(obj, nameArray, polygons);
    else
        msgbox('The selected folder is empty');
    end
end
end
