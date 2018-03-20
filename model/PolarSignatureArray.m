classdef PolarSignatureArray < PolygonArray
%POLARSIGNATUREARRAY Class for polygon array based on polar signatures
%
%   Creation: 
%   polygonArray = PolarSignatureArray(signatures, angles);
%

properties
    % the list of all the signatures
    signatures;

    % the list of angles that were used while computing the polar
    % signatures
    angleList;
end

%% Constructor methods
methods
    function obj = PolarSignatureArray(signaturesArray, angles)
    %Constructor for PolarSignatureArray class
    %
    %   polygonArray = PolarSignatureArray(signatures, angles)
    %   where polygons is a N-by-M Table where 1 row equals 1 signature
    %   and angles is a numeric

        obj.signatures = signaturesArray;
        obj.angleList = angles;
    end
end

%% Implementation of PolygonArray interface
methods
    function arraySize = getPolygonNumber(obj)
        % returns the number of polygons contained in the polygon array
        arraySize = size(obj.signatures, 1);
    end

    function polygonSize = getPolygonSize(obj)
        polygonSize = size(obj.signatures, 2);
    end

    function polygon = getPolygon(obj, row)
        % computes the polygon found at the index row
        polygon = signatureToPolygon(getSignature(obj, row), obj.angleList);
    end

    function polygons = getAllPolygons(obj)
        % computes all the polygons
        polygons = cell(1, getPolygonNumber(obj));
        for i = 1:getPolygonNumber(obj)
            polygons{i} = getPolygon(obj, i);
        end
    end

    function updatePolygon(obj, row, polygon)
        % returns all the signatures
        obj.signatures(row, :) = polygonSignature(polygon, obj.angleList);
    end

        function newPolygonArray = selectPolygons(obj, polygonIndices)
        % extract the selected polygons and returns a new PolarSignatureArray
        newSignatures = obj.signatures(polygonIndices, :);
        newPolygonArray = PolarSignatureArray(newSignatures, obj.angles);
    end
end

%% Methods specific to PolarSignatureArray
methods
    function array = getDatas(obj)
        array = obj.signatures;
    end
    
    function signature = getSignature(obj, row)
        % returns the signature found at the index row
        signature = obj.signatures(row, :);
    end

end

end