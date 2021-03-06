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

%% Implementation of PolygonList interface
methods
    function arraySize = getPolygonNumber(obj)
        % returns the number of polygons contained in the polygon array
        arraySize = size(obj.signatures, 1);
    end

    function polygon = getPolygon(obj, row)
        % computes the polygon found at the index row
        polygon = signatureToPolygon(getSignature(obj, row), obj.angleList);
    end

    function setPolygon(obj, row, polygon) %#ok<INUSD>
        error('Unsupported operation');
    end

    function polygons = getAllPolygons(obj)
        % computes all the polygons
        polygons = cell(1, getPolygonNumber(obj));
        for i = 1:getPolygonNumber(obj)
            polygons{i} = getPolygon(obj, i);
        end
    end

    function removeAll(obj, inds)
        % removes from the array all the polygons specified by index list
        obj.signatures(inds, :) = [];
    end
    
    function retainAll(obj, inds)
        % keeps only the polygons specified by a index list
        obj.signatures = obj.signatures(inds, :);
    end
    
    function dup = duplicate(obj)
        % duplicates this array
        dup = PolarSignatureArray(obj.signatures, obj.angleList);
    end
   
    function newPolygonArray = selectPolygons(obj, polygonIndices)
        % extract the selected polygons and returns a new PolarSignatureArray
        newSignatures = obj.signatures(polygonIndices, :);
        newPolygonArray = PolarSignatureArray(newSignatures, obj.angleList);
    end
end


%% Implementation of the PolygonArray interface
methods
    function nCols = getRowLength(this)
        % returns the length of each row in the data array
        nCols = size(this.signatures, 2);
    end
    
    function poly = rowToPolygon(this, row)
        % convert row to polygon
        poly = signatureToPolygon(row, this.angleList);
    end
    
    function row = polygonToRow(this, poly)
        % convert polygon to row
        row = polygonToSignature(poly, this.angleList);
    end
    
    function data = getDataArray(this)
        % returns the N-by-P data array
        data = this.signatures;
    end
end


%% Methods specific to PolarSignatureArray
methods
    function polygonSize = getPolygonSize(obj)
        polygonSize = size(obj.signatures, 2);
    end

    function signature = getPolarSignature(obj, row)
        % returns the signature found at the index row
        signature = obj.signatures(row, :);
    end

    function angles = getSignatureAngles(obj)
        % returns the signature found at the index row
        angles = obj.angleList;
    end
    
    function signature = getSignature(obj, row)
        % returns the signature found at the index row
        signature = obj.signatures(row, :);
    end

end

end