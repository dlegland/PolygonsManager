classdef PolygonArray < handle
    methods
%         function this = PolygonArray(file)
%             this.polygonArr = Table.read(file);
%         end
        
%         function polygon = getPolygon(obj, index)
%             x = obj.polygonArr(index, :);
%             polygon = transform(x);
%             
%             function polygon = transform(x)
%                 N = size(x);
%                 N = N(2)/2;
%                 temp = zeros(N, 2);
%                 temp(:,1) = x(1:N);
%                 temp(:,2) = x(N+1:N*2);
%                 polygon = Table.create(temp, {'x', 'y'});
%             end
%         end
        
        function polygon = getPolygonArray(obj, index)
            x = obj.polygonArr(index, :);
            polygon = transform(x);
            
            function polygon = transform(x)
                N = size(x);
                N = N(2)/2;
                polygon = zeros(N, 2);
                polygon(:,1) = x(1:N);
                polygon(:,2) = x(N+1:N*2);
            end
        end
    end
    
    methods (Abstract)
        arraySize = getPolygonNumber(poly);
        polygon = getPolygon(poly);
        polygons = getAllPolygons(obj)
    end
end