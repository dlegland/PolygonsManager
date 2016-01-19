classdef PolygonArray < handle
    methods (Abstract)
        arraySize = getPolygonNumber(poly);
        polygon = getPolygon(poly);
        polygons = getAllPolygons(obj)
    end
end