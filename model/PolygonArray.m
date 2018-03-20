classdef PolygonArray < handle
%POLYGONARRAY Interface that defines the methods that any polygon array
%must contain

    methods (Abstract)
        arraySize = getPolygonNumber(obj);
        polygon = getPolygon(obj);
        polygons = getAllPolygons(obj);
        
        % Checks if all the polygons in this array have the same vertex  number
        b = isNormalized(obj);
        
        % updates the coordinates of the specified polygon
        updatePolygon(obj, row, polygon);
        
        % extract the selected polygons in a new PolygonArray
        newPolygonArray = selectPolygons(obj, polygonIndices);
    end
end