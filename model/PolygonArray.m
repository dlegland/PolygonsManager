classdef PolygonArray < handle
%POLYGONARRAY Interface that defines an abstract collection of polygons

    methods (Abstract)
        % returns the number of polygons stored within this array
        arraySize = getPolygonNumber(obj);
        
        % return the polygon at the given index
        polygon = getPolygon(obj, index);
        
        % returns the list of all polygons
        polygons = getAllPolygons(obj);
        
        % Checks if all the polygons in this array have the same vertex  number
        b = isNormalized(obj);
        
        % updates the coordinates of the specified polygon
        updatePolygon(obj, row, polygon);
        
        % extract the selected polygons in a new PolygonArray
        newPolygonArray = selectPolygons(obj, polygonIndices);
    end
end