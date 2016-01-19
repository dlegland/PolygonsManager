classdef BasicPolygonArray < PolygonArray
    
    properties
        polygons;
    end
    
    methods
        function obj = BasicPolygonArray(polyArray)
            obj.polygons = polyArray;
        end
        
        function arraySize = getPolygonNumber(obj)
            arraySize = length(obj.polygons);
        end
        
        function polygon = getPolygon(obj, row)
            polygon = obj.polygons{row};
        end
        
        function polygons = getAllPolygons(obj)
            polygons = obj.polygons;
        end
        
        function addPolygon(obj, polygon)
            obj.polygons{end+1} = polygon;
        end
        
        function updatePolygon(obj, row, polygon)
            obj.polygons{row} = polygon;
        end
    end
end