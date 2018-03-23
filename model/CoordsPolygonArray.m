classdef CoordsPolygonArray < PolygonArray
%COORDSPOLYGONARRAY Class for polygon array of polygons that all have the same number of points
%
%   Creation: 
%   polygonArray = CoordsPolygonArray(coordArray);
%

    
properties
    % the list of all the polygons
    polygons;
end

%% Constructor methods
methods 
    function obj = CoordsPolygonArray(polygons)
    %Constructor for CoordsPolygonArray class
    %
    %   polygonArray = CoordsPolygonArray(polygons)
    %   where polygons is a N-by-M Table where 1 row equals 1 polygon

        obj.polygons = polygons;
    end

end

%% Implementation of PolygonArray interface
methods
    function arraySize = getPolygonNumber(obj)
        % returns the number of polygons contained in the polygon array
        arraySize = size(obj.polygons, 1);
    end

    function polygonSize = getPolygonSize(obj)
        polygonSize = size(obj.polygons, 2);
    end

    function polygon = getPolygon(obj, row)
        % returns the polygon found at the index row
        polygon = rowToPolygon(obj.polygons(row, :), 'packed');
    end

    function polygon = getPolygonRow(obj, row)
        polygon = obj.polygons(row, :);
    end

    function polygons = getAllPolygons(obj)
        % returns all the polygons
        polygons = cell(1, getPolygonNumber(obj));
        for i = 1:getPolygonNumber(obj)
            polygons{i} = getPolygon(obj, i);
        end
    end

    function b = isNormalized(obj) %#ok<MANU>
        % return true
        b = true;
    end
    
    function updatePolygon(obj, row, polygon)
        % replace the polygon found at the index row by a new polygon
        obj.polygons(row, :) = polygonToRow(polygon, 'packed');
    end
    
    function removeAll(obj, inds)
        % removes from the array all the polygons specified by index list
        obj.polygons(inds, :) = [];
    end
    
    function retainAll(obj, inds)
        % keeps only the polygons specified by a index list
        obj.polygons = obj.polygons(inds, :);
    end
    
    function dup = duplicate(obj)
        % duplicates this array
        dup = CoordsPolygonArray(obj.polygons);
    end
    
    
    function newPolygonArray = selectPolygons(obj, polygonIndices)
        % extract the selected polygons and returns a new CoordsPolygonArray
        newCoords = obj.polygons(polygonIndices, :);
        newPolygonArray = CoordsPolygonArray(newCoords);
    end
    
end

%% Methods specific to this class
methods
    function array = getDatas(obj)
        array = obj.polygons;
    end
end

end