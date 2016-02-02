classdef BasicPolygonArray < PolygonArray
%BASICPOLYGONARRAY Class for polygon array of non altered polygons 
%
%   Creation : 
%   polygonArray = BasicPolygonArray(polygons);
%

    properties
        % the list of all the polygons
        polygons;
    end
    
    methods
        function obj = BasicPolygonArray(polygons)
        %Constructor for BasicPolygonArray class
        %
        %   polygonArray = BasicPolygonArray(polygons)
        %   where polygons is a 1-by-N cell array, containing N 2-by-M cell arrays
        
            obj.polygons = polygons;
        end
        
        function arraySize = getPolygonNumber(obj)
            % returns the number of polygons contained in the polygon array
            arraySize = length(obj.polygons);
        end
        
        function polygon = getPolygon(obj, row)
            % returns the polygon found at the index row
            polygon = obj.polygons{row};
        end
        
        function polygons = getAllPolygons(obj)
            % returns all the polygons
            polygons = obj.polygons;
        end
        
        function updatePolygon(obj, row, polygon)
            % replace the polygon found at the index row by a new polygon
            obj.polygons{row} = polygon;
        end
    end
end