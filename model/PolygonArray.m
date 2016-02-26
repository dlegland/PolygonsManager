classdef PolygonArray < handle
%POLYGONARRAY Interface that defines the methods that any polygon array
%must contain

    methods (Abstract)
        arraySize = getPolygonNumber(obj);
        polygon = getPolygon(obj);
        polygons = getAllPolygons(obj);
        updatePolygon(obj, row, polygon);
    end
end