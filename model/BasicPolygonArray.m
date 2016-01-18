classdef BasicPolygonArray < PolygonArray
    
    properties
        polygons;
        
        status;
    end
    
    methods
        function obj = BasicPolygonArray(polyArray)
            obj.polygons = polyArray;
        end
        
        function arraySize = getPolygonNumber(obj)
            arraySize = length(obj.polygons);
        end
        
%         function nameList = getPolygonNames(obj)
%             size =  getPolygonNumber(obj);
%             nameList(1:size) = obj.polygons(1:size);
%         end
        
        function polygon = getPolygon(obj, row)
            polygon = obj.polygons{row};
        end
        
        function addPolygon(obj, polygon)
            obj.polygons{end+1} = polygon;
        end
        
        function updatePolygon(obj, row, polygon)
            obj.polygons{row} = polygon;
        end
    end
end