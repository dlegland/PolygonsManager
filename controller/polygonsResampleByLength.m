function polygonsResampleByLength(frame, varargin)
%POLYGONSCONCATENATE Resample each polygon with a specific sampling length
%
%   For each polygon, resample with the same number of vertices.
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - varargin : contains the parameters if the function is called from
%       a macro
%
%   Outputs : none
%
% 

% select the number of vertices that the new polygons will have
if nargin == 1
%     number = contoursConcatPrompt;
     samplingLength = promptVertexNumber(frame);
else
    if ~isa(varargin{1}, 'double')
        samplingLength = str2double(varargin{1});
    else
        samplingLength = varargin{1};
    end
end

% save the name of the function and the parameters used during
% its call in the log variable
frame.model.usedProcess{end+1} = ['polygonsResampleByLength : number = ' num2str(samplingLength)];

% get the number of polygons
nPolys = length(frame.model.nameList);

% memory allocation
dat = cell(1, nPolys);

% create waitbar
h = waitbar(0, 'Please wait...', 'name', 'Polygons resampling');

for i = 1:nPolys
    % get the name of the contours that will be converted 
    name = frame.model.nameList{i};

    % update the waitbar and the contours selection (purely cosmetic)
    frame.model.selectedPolygons = {name};
    updateSelectedPolygonsDisplay(getActivePanel(frame));
    set(frame.handles.list, 'value', find(strcmp(name, frame.model.nameList)));

    waitbar(i / (nPolys+1), h, ['process : ' name]);

    % get the polygon from its name
    poly = getPolygonFromName(frame.model, name);

    % index of points above x-axis
    indSup = find(poly(:,2) > 0);

    % among the points above the x-axis, find the one closer to the y-axis
    [tmp, ind] = min(abs(poly(indSup,1))); %#ok<ASGLU>

    % get point's index iwt the polygons numerotation
    ind = indSup(ind);

    % shift the vertex to start from from the highest one
    poly = circshift(poly, [1-ind 0]);

    % check if the polygon is rotating in the right direction (counterclockwise)
    if polygonArea(poly) < 0
        poly = poly(end:-1:1, :);
    end

    % close the polygon
    poly = poly([1:end 1], :);

    % cut polygon into same number of pieces
    poly2 = resamplePolygonByLength(poly, samplingLength);

    % fill the data table
    dat{i} = poly2;
end
waitbar(1, h);

% close waitbar
close(h) 

% create the PolygonsManagerData that'll be used as the new
% PolygonsManagerMainFrame's model
model = PolygonsManagerData(BasicPolygonArray(dat), 'parent', frame.model);

% create a new PolygonsManagerMainFrame
PolygonsManagerMainFrame(model);  



function number = promptVertexNumber(frame)
    
prompt = {'Choose sampling length:'};
title = 'Input sampling length';
defaultanswer = {'1'};
options.Resize = 'on';

while true
    answer = inputdlg(prompt, title, [1 40], defaultanswer, options);

    % cancel
    if isempty(answer)
        number = [];
        return;
    end

    % try to convert to numeric
    number = str2double(answer{1});

    % if fails, re-iterate
    if isfinite(number)
        break;
    end
end

