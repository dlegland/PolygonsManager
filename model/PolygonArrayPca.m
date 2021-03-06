classdef PolygonArrayPca < PolygonArray
%POLYGONARRAYPCA  Represents a collection of polygons using PCA
%
%   RES = PolygonArrayPca(polygonArray)
%   RES = PolygonArrayPca(polygonArray, NCOMP)
%   Where polygonArray is an instance of a (normalized) PolygonArray, such
%   as CoordsPolygonArray or PolarSignatureArray.
%
%   Class PolygonArrayPca
%
%   Example
%   PolygonArrayPca
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2018-03-27,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % the method used to reconstruct polygons
    rowToPolyFun;

    % the method use
    polyToRowFun;
    
    % the average value of the initial data array, for reconstruction
    means;

    % the scores result of the PCA, as a N-by-P array
    scores;

    % the eigen vectors of the pca, as a P-by-P array
    eigenVectors;

    % the eigen values of the PCA, as a P-by-3 array
    eigenValues;

    % the number of components to keep
    nComps = 10;
    
end % end properties


%% Constructor
methods
    function this = PolygonArrayPca(varargin)
    % Constructor for PolygonArrayPca class
        
        if nargin < 1
            error('Requires at least one input argument');
        end
        
        var1 = varargin{1};
        if isa(var1, 'CoordsPolygonArray')
            this.rowToPolyFun = @(x) rowToPolygon(x, 'packed');
            this.polyToRowFun = @(x) polygonToRow(x, 'packed');
        elseif isa(var1, 'PolarSignatureArray')
            angles = var1.angleList;
            this.rowToPolyFun = @(x) signatureToPolygon(x, angles);
            this.polyToRowFun = @(x) polygonSignature(x, angles);
        else
            error('First argument must be a normalized polygon array');
        end
        
        
        % get the data, and compute PCA
        data = getDataArray(var1);
        
        computePCA(this, data);

    end

    function computePCA(this, data)
        %% Pre-processing

        % recenter data (remove mean)
        this.means = mean(data, 1);
        cData = bsxfun(@minus, data, this.means);

        % computation of covariance matrix
        transpose = false;
        if size(cData, 1) < size(cData, 2) && size(cData, 2) > 50
            % If data table has large number of variables, computes the covariance
            % matrix on the transposed array.
            % Result V has dimension nind x nind
            transpose = true;
            V = cData * cData';
        else
            % V has dimension nvar * nvar
            V = cData' * cData;  
        end

        % divides by the number of rows to have a covariance
        V = V / (size(cData, 1) - 1);

        % Diagonalisation of the covariance matrix.
        % * eigenVectors: basis transform matrix
        % * vl: eigen values diagonal matrix
        % * coords: not used
        [this.eigenVectors, evl, coords] = svd(V);

        % In case the input table was transposed, eigen vectors need to be
        % recomputed from the coord array
        if transpose
            this.eigenVectors = cData' * coords;

            % Normalisation of eigen vectors, such that eigenVectors * eigenVectors
            % corresponds to identity matrix
            for i = 1:size(this.eigenVectors, 2)
                this.eigenVectors(:,i) = this.eigenVectors(:,i) / sqrt(sum(this.eigenVectors(:,i) .^ 2));
            end
        end

        % compute new coordinates from the eigen vectors
        this.scores = cData * this.eigenVectors;

        % compute array of eigen values
        evl= diag(evl);
        this.eigenValues = zeros(length(evl), 3);
        this.eigenValues(:, 1) = evl;                        % eigen values
        this.eigenValues(:, 2) = 100 * evl/ sum(evl);        % inertia
        this.eigenValues(:, 3) = cumsum(this.eigenValues(:,2));   % cumulated inertia
    end
    
end % end constructors


%% Methods specific to PolygonArrayPca
methods
    function row = reconstruct(this, rowIndex, varargin)
        % reconstruct the row vector for a given row index, using nComps.
        row = this.means;
        for i = 1:this.nComps
            row = row + this.scores(rowIndex,i) * this.eigenVectors(:,i)';
        end
    end
    
    function poly = computePolygon(this, coeffs)
        % reconstruct a polygon using the specified coefficients
        row = this.means;
        for i = 1:length(coeffs)
            row = row + coeffs(i) * this.eigenVectors(:,i)';
        end
        poly = this.rowToPolyFun(row);
    end
end

%% methods implementing PolygonArray
methods
    function nCols = getRowLength(this)
        % returns the length of each row in the data array
        nCols = size(this.eigenVectors, 1);
    end
    
    function poly = rowToPolygon(this, row)
        % convert row to polygon
        poly = this.rowToPolyFun(row);
    end
    
    function row = polygonToRow(this, poly)
        % convert polygon to row
        row = this.polyToRowFun(poly);
    end
    
    function data = getDataArray(this)
        % returns the N-by-P data array
        data = this.scores;
    end
end

%% Methods implementing PolygonList
methods
    function nPolys = getPolygonNumber(this)
        % returns the number of polygons contained in the polygon array
        nPolys = size(this.scores, 1);
    end

    function polygonSize = getPolygonSize(this)
        poly = getPolygon(this, 1);
        polygonSize = size(poly, 1);
    end

    function polygon = getPolygon(this, rowIndex)
        % returns the polygon found at the index row
        data = reconstruct(this, rowIndex);
        polygon = this.rowToPolyFun(data);
    end
    
    function polygons = getAllPolygons(obj)
        % returns all the polygons
        polygons = cell(1, getPolygonNumber(obj));
        for i = 1:getPolygonNumber(obj)
            polygons{i} = getPolygon(obj, i);
        end
    end

    function setPolygon(obj, row, polygon) %#ok<INUSD>
        error('Unimplemented method');
    end
    
    function removeAll(obj, inds) %#ok<INUSD>
        error('Unimplemented method');
    end
    
    function retainAll(obj, inds) %#ok<INUSD>
        error('Unimplemented method');
    end
    
    function dup = duplicate(this)
        % duplicates this array
        dup = PolygonArrayPca(this);
    end
    
    function newPolygonArray = selectPolygons(obj, polygonIndices) %#ok<INUSD,STOUT>
        error('Unimplemented method');
    end

end % end methods

end % end classdef

