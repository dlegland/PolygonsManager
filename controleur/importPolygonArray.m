function importPolygonArray(~,~, obj)
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
        obj.model = Model(polygons, nameArray);
        if isempty(obj.handles.panels);
            createPanel(obj,length(obj.handles.tabs.Children) + 1, 1);
        end
        set(obj.handles.list, 'string', nameArray);
        set([obj.handles.menus{:}], 'enable', 'on');
        set(obj.handles.submenus{1}, 'enable', 'on');
        showContours(obj, getAllPolygons(obj.model.PolygonArray));
    else
        msgbox('The selected folder is empty');
    end
end
end
