function polygonsConcatenate(frame, varargin)
%POLYGONSCONCATENATE  Concatenate all polygons with the same number of vertices
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
    
    gd = GenericDialog('Concatenate Polygons');
    gd.addNumericField('Vertex number', 200, 0);
    gd.addChoice('Start from:', {'top', 'bottom', 'right', 'left'}, 'top');
    gd.showDialog();
    if gd.wasCanceled()
        return;
    end
    
    number = gd.getNextNumber();
    start = gd.getNextString();
    
%     number = promptVertexNumber(frame);
%     if isempty(number)
%         return;
%     end
else
    if ~isa(varargin{1}, 'double')
        number = str2double(varargin{1});
    else
        number = varargin{1};
    end
end

% save the name of the function and the parameters used during
% its call in the log variable
frame.model.usedProcess{end+1} = ['polygonsConcatenate : number = ' num2str(number)];

% get the number of polygons
nPolys = length(frame.model.nameList);

% memory allocation
dat = zeros(nPolys, 2*number);

% create waitbar
h = waitbar(0, 'Please wait...', 'name', 'Polygons concatenation');

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

    np = size(poly, 1);

    % choose the coordinate to work with
    if ismember(start, {'top', 'bottom'})
        coords = poly(:,2);
    else
        coords = poly(:,1);
    end
    
    % keep only coordinates on one side
    if ismember(start, {'top', 'right'})
        indSup = find(coords > 0);
    else
        indSup = find(coords < 0);
    end
    
    % find the point the closest to the start axis
    if ismember(start, {'top', 'bottom'})
        % among the selected points find the one closer to the y-axis
        [tmp, ind] = min(abs(poly(indSup,1))); %#ok<ASGLU>
    else
        % among the selected points find the one closer to the y-axis
        [tmp, ind] = min(abs(poly(indSup,2))); %#ok<ASGLU>
    end
    
    % convert index of selection to index of polygon
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

    % index of the curves' end
    inds = round(linspace(1, np+1, number+1));

    % memory allocation for the new polygon
    poly2 = zeros(number, 2);

    % compute each curves' fragment's centroid
    for j = 1:number
        curve   = poly(inds(j):inds(j+1), :);
        centro  = polylineCentroid(curve);
        poly2(j,:) = centro;
    end

    % fill the data table
    dat(i, :) = polygonToRow(poly2, 'packed');
end

% close waitbar
waitbar(1, h);
close(h) 

% create the PolygonsManagerData that'll be used as the new
% PolygonsManagerMainFrame's model
model = PolygonsManagerData(CoordsPolygonArray(dat), 'parent', frame.model);

% create a new PolygonsManagerMainFrame
PolygonsManagerMainFrame(model);  
