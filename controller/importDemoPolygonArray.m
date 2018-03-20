function importDemoPolygonArray(frame)
%IMPORTCOORDSPOLYGON  Imports a coords polygons file (.txt) and defines it as the current signature array
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% open the file selection prompt and let the user select the file he wants
% to use as a polygon array
path = fileparts(mfilename('fullpath'));
path = fullfile(path, '..', 'demoData');

fFile = fullfile(path, 'pone_CSN200.txt');

% if the figure already contains a polygon array
frame = PolygonsManagerMainFrame;

%read the Table contained in the selected file
import = Table.read(fFile);

% set the new polygon array as the current polygon array
model = PolygonsManagerData('PolygonArray', CoordsPolygonArray(import.data), 'nameList', import.rowNames');

%setup the frame
setupNewFrame(frame, model);
