classdef PolygonArray < PolygonList
%POLYGONARRAY A collection of polygons with the same number of vertices

methods (Abstract)
    % returns the length of each row in the data array
    nCols = getRowLength(obj);
    
    % convert row to polygon
    poly = rowToPolygon(this, row)
    
    % convert polygon to row
    row = polygonToRow(this, poly)
    
    % returns the N-by-P data array
    data = getDataArray(this);
end

end