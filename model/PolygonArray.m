classdef PolygonArray < handle
%POLYGONARRAY Interface that defines the methods that any polygon array
%must contain

    methods (Abstract)
        arraySize = getPolygonNumber(poly);
        polygon = getPolygon(poly);
        polygons = getAllPolygons(obj)
    end
end