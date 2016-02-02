classdef CoordsPolygonArray < PolygonArray
%BASICPOLYGONARRAY Class for polygon array of polygons that all have the
%same number of points
%
%   Creation : 
%   polygonArray = BasicPolygonArray(polygons);
%

    
    properties
        % the list of all the polygons
        polygons
    end
    
    methods 
        function obj = CoordsPolygonArray(polygons)
        %Constructor for CoordsPolygonArray class
        %
        %   polygonArray = CoordsPolygonArray(polygons)
        %   where polygons is a N-by-M Table where 1 row equals 1 polygon
        
            obj.polygons = polygons;
        end
       
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
        
        function polygons = getAllPolygons(obj)
            % returns all the polygons
            polygons = cell(1, getPolygonNumber(obj));
            for i = 1:getPolygonNumber(obj)
                polygons{i} = getPolygon(obj, i);
            end
        end
        
        function updatePolygon(obj, row, polygon)
            % replace the polygon found at the index row by a new polygon
            obj.polygons(row, :) = polygonToRow(polygon, 'packed');
        end
        
        function array = getDatas(obj)
            array = obj.polygons;
        end
    end
end