function exportToWorkspace(frame)
%EXPORTTOWORKSPACE Export the data to the current workspace
%
%   output = exportToWorkspace(input)
%
%   Example
%   exportToWorkspace
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-03-30,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

% export the "global" variables
assignin('base', 'mainFrame', frame);
assignin('base', 'model', frame.model);

polygonArray = frame.model.PolygonArray;

if isa(polygonArray, 'BasicPolygonArray')
    % export the polygons as a cell array of cell arrays
    assignin('base', 'polygons', frame.model.PolygonArray.polygons);
    
elseif isa(polygonArray, 'CoordsPolygonArray')
    % export the polygons as a Table
    nCols = size(frame.model.PolygonArray.polygons, 2)/2;
    colnames = [cellstr(num2str((1:nCols)', 'x%d'))' cellstr(num2str((1:nCols)', 'y%d'))'];
    
    assignin('base', 'polygons', Table.create(frame.model.PolygonArray.polygons, ...
        'rowNames', frame.model.nameList, ...
        'colNames', colnames));
    
elseif isa(polygonArray, 'PolarSignatureArray')
    % export the polar signatures as a table
    colnames = cellstr(num2str(frame.model.PolygonArray.angleList'));
    
    assignin('base', 'signatures', Table.create(frame.model.PolygonArray.signatures, ...
        'rowNames', frame.model.nameList, ...
        'colNames', colnames'));
    
else
    error(['Unknown type of polygon array: ' class(polygonArray)]);
end

if isa(frame.model.factors, 'Table')
    % if there's one, export the factor Table
    assignin('base', 'factors', frame.model.factors);
end

if isa(frame.model.pca, 'Pca')
    % if that PCA has been computed, export it
    assignin('base', 'pca', frame.model.pca);
end

% export the informations concerning the polygons
assignin('base', 'infos', frame.model.infoTable);
