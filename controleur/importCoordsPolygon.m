function importCoordsPolygon(obj)
%IMPORTCOORDSPOLYGON  Imports a coords polygons file (.txt) and defines it as the current signature array
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% open the file selection prompt and let the user select the file he wants
% to use as a polygon array
[fName, fPath] = uigetfile('C:\Stage2016_Thomas\data_plos\slabs\Tests\*.txt');
fFile = fullfile(fPath, fName);

if fName ~= 0
    if ~isempty(obj.handles.panels)
        % if the figure already contains a polygon array
        obj = PolygonsManagerMainFrame;
    end

    %read the Table contained in the selected file
    import = Table.read(fFile);
    
    % create the polygon array
    polygons = CoordsPolygonArray(import.data);

    %setup the frame
    setupNewFrame(obj, import.rowNames', polygons)
end
end