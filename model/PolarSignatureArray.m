classdef PolarSignatureArray < PolygonArray
    
    properties
        signatures;
        
        angleList;
    end
    
    methods
        function obj = PolarSignatureArray(signaturesArray, angles)
            obj.signatures = signaturesArray;
            obj.angleList = angles;
        end
       
        function arraySize = getPolygonNumber(obj)
            arraySize = size(obj.signatures, 1);
        end
        
        function polygon = getPolygon(obj, row)
            polygon = signatureToPolygon(getSignature(obj, row), obj.angleList);
        end
        
        function polygons = getAllPolygons(obj)
            polygons = cell(1, getPolygonNumber(obj));
            for i = 1:getPolygonNumber(obj)
                polygons{i} = getPolygon(obj, i);
            end
        end
        
        function signature = getSignature(obj, row)
            signature = obj.signatures(row, :);
        end
        
        function updatePolygon(obj, row, polygon)
            obj.signatures(row, :) = polygonSignature(polygon, obj.angleList);
        end
        
%         function [ymax, ymin] = getLimits(obj)
%             ymin = min(obj.signatures(:));
%             ymax = max(obj.signatures(:));
%         end
    end
end