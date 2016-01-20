function importPolarSignature(~,~, obj)
[fName, fPath] = uigetfile('C:\Stage2016_Thomas\data_plos\slabs\images\*.txt');
fFile = fullfile(fPath, fName);

if ~isempty(obj.handles.panels)
    obj = MainFrame;
end

import = Table.read(fFile);

pas = 360/columnNumber(import);
startAngle = str2double(import.colNames{1});
angles = startAngle:pas:360+startAngle-pas;
polygons = PolarSignatureArray(import.data, angles);

setPolygonArray(obj, import.rowNames', polygons)
end