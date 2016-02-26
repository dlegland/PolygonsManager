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
        
        function arraySize = getPolygonNumber(this)
            % returns the number of polygons contained in the polygon array
            arraySize = length(this.polygons);
        end
        
        function polygon = getPolygon(this, row)
            % returns the polygon found at the index row
            polygon = this.polygons{row};
        end
        
        function polygons = getAllPolygons(this)
            % returns all the polygons
            polygons = this.polygons;
        end
        
        function updatePolygon(this, row, polygon)
            % replace the polygon found at the index row by a new polygon
            this.polygons{row} = polygon;
        end
    end
end