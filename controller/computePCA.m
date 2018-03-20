function computePCA(frame)
%COMPUTEPCA  Compute the Principal Component Analysis of the current polygons
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% extract data from polygon array, depending on its class
array = frame.model.PolygonArray;
if isa(array, 'CoordsPolygonArray')
    data = array.coords;
elseif isa(array, 'PolarSignatureArray')
    data = array.signatures;
else
    error(['Unable to compute data table from PolygonArray with class: ' class(array)]);
end

% transform into data table, and compute PCA
tab = Table.create(data, 'rowNames', frame.model.nameList');
frame.model.pca = Pca(tab, 'Display', 'none', 'scale', false);

% refresh menus
updateMenus(frame);
