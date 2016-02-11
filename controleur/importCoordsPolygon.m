function importCoordsPolygon(obj)
%IMPORTCOORDSPOLYGON  Imports a coords polygons file (.txt) and defines it as the current signature array
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% open the file selection prompt and let the user select the file he wants
% to use as a polygon array
[fName, fPath] = uigetfile('*.txt');
fFile = fullfile(fPath, fName);

if fName ~= 0
    if ~isempty(obj.handles.Panels)
        % if the figure already contains a polygon array
        obj = PolygonsManagerMainFrame;
    end

    %read the Table contained in the selected file
    import = Table.read(fFile);
    
    % set the new polygon array as the current polygon array
    model = PolygonsManagerData('PolygonArray', CoordsPolygonArray(import.data), 'nameList', import.rowNames');

    %setup the frame
    setupNewFrame(obj, model);
end