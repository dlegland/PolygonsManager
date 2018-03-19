function computePCA(obj)
%COMPUTEPCA  Compute the Principal Component Analysis of the current polygons
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

obj.model.pca = Pca(Table.create(getDatas(obj.model.PolygonArray), 'rowNames', obj.model.nameList'), 'Display', 'none', 'scale', false);

updateMenus(obj);
end