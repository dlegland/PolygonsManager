function importPolarSignature(obj)
%IMPORTPOLARSIGNATURE  Imports a polar signature file (.txt) and defines it as the current signature array
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% open the file selection prompt and let the user select the file he wants
% to use as a polygon array
[fName, fPath] = uigetfile('C:\Stage2016_Thomas\data_plos\slabs\Tests\*.txt');
fFile = fullfile(fPath, fName);

if fName ~= 0
    if ~isempty(obj.handles.Panels)
        % if the figure already contains a polygon array
        obj = PolygonsManagerMainFrame;
    end

    %read the Table contained in the selected file
    import = Table.read(fFile);

    % determine the angle list depending on the column names of the Table
    pas = 360/columnNumber(import);
    startAngle = str2double(import.colNames{1});
    angles = startAngle:pas:360+startAngle-pas;
    
    % set the new polygon array as the current polygon array
    model = PolygonsManagerData('PolygonArray', PolarSignatureArray(import.data, angles), 'nameList', import.rowNames');

    %setup the frame
    setupNewFrame(obj, model);
end