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
        
        % removes from the array all the polygons specified by index list
        removeAll(obj, inds);
        
        % keeps only the polygons specified by index list
        retainAll(obj, inds);
        
        % duplicates this array
        dup = duplicate(this);
        
        % extract the selected polygons in a new PolygonArray
        newArray = selectPolygons(obj, polygonIndices);
    end
end