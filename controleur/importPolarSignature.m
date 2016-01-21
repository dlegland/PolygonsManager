function importPolarSignature(~,~, obj)
%IMPORTPOLARSIGNATURE  Imports a polar signature file (.txt) and defines it as the current signature array
%
%   Inputs :
%       - ~ (not used) : inputs automatically send by matlab during a callback
%       - obj : handle of the MainFrame
%   Outputs : none

[fName, fPath] = uigetfile('C:\Stage2016_Thomas\data_plos\slabs\images\*.txt');
fFile = fullfile(fPath, fName);

if fName ~= 0
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
end