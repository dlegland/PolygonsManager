classdef PolygonList < handle
%POLYGONLIST  Interface that defines an abstract collection of polygons
%
%   Class PolygonList
%
%   Example
%   PolygonList
%
%   See also
%     PolygonArray

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-03-30,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - BIA-BIBS.

%% Methods
methods (Abstract)
    % returns the number of polygons stored within this collection
    number = getPolygonNumber(obj);

    % return the polygon at the given index
    polygon = getPolygon(obj, index);

    % updates the coordinates of the specified polygon
    setPolygon(obj, row, polygon);

    % returns the list of all polygons as a cell array
    polygons = getAllPolygons(obj);

    
    % removes from the array all the polygons specified by index list
    removeAll(obj, inds);

    % keeps only the polygons specified by index list
    retainAll(obj, inds);

    % extract the selected polygons in a new PolygonArray
    newArray = selectPolygons(obj, polygonIndices);

    % duplicates this array
    dup = duplicate(this);
    
end % end methods

end % end classdef

