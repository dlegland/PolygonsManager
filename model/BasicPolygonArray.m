classdef BasicPolygonArray < PolygonList
%BASICPOLYGONARRAY Class for polygon array of non altered polygons 
%
%   Creation : 
%   polygonArray = BasicPolygonArray(polygons);
%

properties
    % the list of all the polygons
    polygons;
end

%% Constructor methods
methods
    function obj = BasicPolygonArray(polygons)
    %Constructor for BasicPolygonArray class
    %
    %   polygonArray = BasicPolygonArray(polygons)
    %   where polygons is a 1-by-N cell array, containing N 2-by-M cell arrays

        obj.polygons = polygons;
    end
end

%% Implementation of the PolygonList interface
methods
    function number = getPolygonNumber(this)
        % returns the number of polygons contained in the polygon array
        number = length(this.polygons);
    end

    function polygon = getPolygon(this, index)
        % returns the polygon at the given index
        polygon = this.polygons{index};
    end

    function polygons = getAllPolygons(this)
        % returns all the polygons
        polygons = this.polygons;
    end

    function setPolygon(this, index, polygon)
        % replaces the polygon found at the given index by a new polygon
        this.polygons{index} = polygon;
    end
    
    function removeAll(obj, inds)
        % removes from the array all the polygons specified by index list
        obj.polygons(inds) = [];
    end
    
    function retainAll(obj, inds)
        % keeps only the polygons specified by a index list
        obj.polygons = obj.polygons(inds);
    end
    
    function dup = duplicate(obj)
        % duplicates this array
        newPolys = cell(1, length(obj.polygons));
        newPolys(:) = obj.polygons(:);
        dup = BasicPolygonArray(newPolys);
    end

    
    function newPolygonArray = selectPolygons(obj, polygonIndices)
        % extract the selected polygons and returns a new BasicPolygonArray
        newPolygons = obj.polygons(polygonIndices);
        newPolygonArray = BasicPolygonArray(newPolygons);
    end
end

end