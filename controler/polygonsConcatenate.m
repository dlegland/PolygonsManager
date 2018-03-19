function polygonsConcatenate(obj, varargin)
%POLYGONSCONCATENATE  Rotate all slab contours such that they are aligned with
%one of the axis
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - varargin : contains the parameters if the function is called from
%       a macro
%   Outputs : none

% select the number of vertices that the new polygons will have
if nargin == 1
    number = contoursConcatPrompt;
else
    if ~isa(varargin{1}, 'double')
        number = str2double(varargin{1});
    else
        number = varargin{1};
    end
end

if ~strcmp(number, '?')
    % save the name of the function and the parameters used during
    % its call in the log variable
    obj.model.usedProcess{end+1} = ['polygonsConcatenate : number = ' num2str(number)];
    
    % get the number of polygons
    nPolys = length(obj.model.nameList);

    % memory allocation
    dat = zeros(nPolys, 2*number);

    % create waitbar
    h = waitbar(0, 'Please wait...', 'name', 'Polygons concatenation');
    
    for i = 1:nPolys
        % get the name of the contours that will be converted 
        name = obj.model.nameList{i};
        
        % update the waitbar and the contours selection (purely cosmetic)
        obj.model.selectedPolygons = {name};
        updateSelectedPolygonsDisplay(obj.handles.Panels{obj.handles.tabs.Selection});
        set(obj.handles.list, 'value', find(strcmp(name, obj.model.nameList)));
        
        waitbar(i / (nPolys+1), h, ['process : ' name]);
        
        % get the polygon from its name
        poly = getPolygonFromName(obj.model, name);
        
        np = size(poly, 1);

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
%         poly2 = resamplePolygon(poly, number);

        % fill the data table
        dat(i, :) = polygonToRow(poly2, 'packed');
    end
    waitbar(1, h);
    
    % close waitbar
    close(h) 
    
    % create a new PolygonsManagerMainFrame
    fen = PolygonsManagerMainFrame;  
    
    % create the PolygonsManagerData that'll be used as the new
    % PolygonsManagerMainFrame's model
    model = PolygonsManagerData('PolygonArray', CoordsPolygonArray(dat), 'nameList', obj.model.nameList, 'factorTable', obj.model.factorTable, 'pca', obj.model.pca, 'usedProcess', obj.model.usedProcess);
    
    % prepare the new PolygonsManagerMainFrame and display the graph
    setupNewFrame(fen, model);
end

function number = contoursConcatPrompt
%CONTOURSALIGNPROMPT  A dialog figure on which the user can select
%which axis will be aligned with the contours
%
%   Inputs : none
%   Outputs : selected axis

    % default value of the ouput to prevent errors
    number = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(obj, 250, 130);

    % create the dialog box
    d = dialog('position', pos, ...
                   'name', 'Enter nb of points');

    % create the inputs of the dialog box
    uicontrol('parent', d,...
            'position', [30 80 90 20], ...
               'style', 'text',...
              'string', 'Nb of points :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit = uicontrol('parent', d,...
                   'position', [130 81 90 20], ...
                      'style', 'edit');

    error = uicontrol('parent', d,...
                    'position', [135 46 85 25], ...
                       'style', 'text',...
             'foregroundcolor', 'r', ...
                     'visible', 'off', ...
                    'fontsize', 8);

    % create the two button to cancel or validate the inputs
    uicontrol('parent', d, ...
            'position', [30 30 85 25], ...
              'string', 'Validate', ...
            'callback', @(~,~) callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel', ...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback
        try
            % if input is numeric, get it and close the dialog box
            if ~isnan(str2double(get(edit,'String')))
                if str2double(get(edit,'String')) < min(getColumn(obj.model.infoTable, 'Vertices'))
                    number = str2double(get(edit,'String'));
                    delete(gcf);
                else
                    set(error, 'string', 'Value too high', 'visible', 'on');
                end
            else
                set(error, 'string', 'Enter a number', 'visible', 'on');
            end
        catch
            set(error, 'string', 'Invalid value', 'visible', 'on');
        end
    end
end

end