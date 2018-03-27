function test_suite = test_PolygonArrayPca
%TEST_POLYGONARRAYPCA  Test case for the file PolygonArrayPca
%
%   Test case for the file PolygonArrayPca

%   Example
%   test_PolygonArrayPca
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2018-03-27,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

test_suite = functiontests(localfunctions);

function test_Constructor_CoordsArray(testCase) %#ok<INUSD,*DEFNU>
% Test call of function without argument

coords = rand(10, 200);
array = CoordsPolygonArray(coords);
arrayPca = PolygonArrayPca(array);


