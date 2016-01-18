function saveContours(~,~, obj)
try
[dname, fileName] = savePrompt;
if ~isempty(dname)
    for i = 1:length(obj.model.nameList)
        name = obj.model.nameList{i};
        filename = sprintf(fileName, name);
        tab = Table.create(getPolygonFromName(obj.model, name), {'x', 'y'});
        write(tab, fullfile(dname, [filename '.txt']));
    end
end
catch
end
end