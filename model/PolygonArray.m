classdef PolygonArray < handle
%POLYGONARRAY Interface that defines an abstract collection of polygons

methods (Abstract)
    % returns the number of polygons stored within this array
    number = getPolygonNumber(obj);

    % return the polygon at the given index
    polygon = getPolygon(obj, index);

    % updates the coordinates of the specified polygon
    setPolygon(obj, row, polygon);

    % returns the list of all polygons
    polygons = getAllPolygons(obj);

    
    % removes from the array all the polygons specified by index list
    removeAll(obj, inds);

    % keeps only the polygons specified by index list
    retainAll(obj, inds);

    
    % Checks if all the polygons in this array have the same vertex  number
    b = isNormalized(obj);

    % extract the selected polygons in a new PolygonArray
    newArray = selectPolygons(obj, polygonIndices);

    % duplicates this array
    dup = duplicate(this);

end

end