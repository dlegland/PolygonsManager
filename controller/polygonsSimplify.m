function varargout = polygonsSimplify(frame, display,  varargin)
%POLYGONSSIMPLIFY Simplify the current polygons using the Douglas-Peucker algorithm
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - display : determines if the results of the smplification must be
%       displayed or ouput
%       - varargin : contains the parameters if the function is called from
%       a macro
%   Outputs : none

% select the tolerence of the simplification
if nargin == 2
    tolerance = polygonsSimplifyPrompt;
else
    if ~isa(varargin{1}, 'double')
        tolerance = str2double(varargin{1});
    else
        tolerance = varargin{1};
    end
end
if strcmp(display, 'off')
    varargout{1} = '?';
    if nargout == 2
        varargout{2} = '?';
    end
end

if strcmp(tolerance, '?')
    return;
end

% save the name of the function and the parameters used during
% its call in the log variable
frame.model.usedProcess{end+1} = ['polygonsSimplify : display = ' display ' ; tolerance = ' num2str(tolerance)];

% memory allocation
polygonList = cell(1, length(frame.model.nameList));

% create waitbar
h = waitbar(0, 'Start simplification...', 'name', 'Simplify polygons');

for i = 1:length(polygonList)
    % get the name of the polygon that will be converted
    name = frame.model.nameList{i};
    
    % update display of current polygon
    setSelectedPolygonIndices(frame.model, i);
    updateSelectedPolygonsDisplay(getActivePanel(frame));
    set(frame.handles.list, 'value', i);
    waitbar(i / (length(frame.model.nameList)+1), h, ['process : ' name]);

    % get the data for the current polygon
    poly = getPolygon(frame.model.PolygonArray, i);
    
    % simplify the polygon
    polyS = simplifyPolygon(poly, tolerance);
    
    polygonList{i} = polyS;
end

% close waitbar
waitbar(1, h);
close(h);

% create new frame with the resulting polygons
newArray = BasicPolygonArray(polygonList);
model = PolygonsManagerData(newArray, 'parent', frame.model);
PolygonsManagerMainFrame(model);

if nargout == 1
    varargout = {model};
elseif nargout == 2
    varargout = {model, tolerance};
end
    
% if strcmp(display, 'off')
%     % if the results must be output, output them
%     varargout{1} = PolygonsManagerData('PolygonArray', BasicPolygonArray(polygonList), 'nameList', obj.model.nameList, 'factorTable', obj.model.factorTable, 'pca', obj.model.pca, 'usedProcess', obj.model.usedProcess);
%     if nargout == 2
%         varargout{2} = tolerance;
%     end
% else
%     if nargin == 2
%         % create a new PolygonsManagerMainFrame
%         fen = PolygonsManagerMainFrame;
%         
%         % create the PolygonsManagerData that'll be used as the new
%         % PolygonsManagerMainFrame's model
%         model = PolygonsManagerData('PolygonArray', BasicPolygonArray(polygonList), 'nameList', obj.model.nameList, 'factorTable', obj.model.factorTable, 'pca', obj.model.pca, 'usedProcess', obj.model.usedProcess);
%         
%         % prepare the new PolygonsManagerMainFrame and display the graph
%         setupNewFrame(fen, model);
%     else
%         % update the model of the current PolygonsManagerMainFrame
%         polygons = BasicPolygonArray(polygonList);
%         obj.model.PolygonArray = polygons;
%         updatePolygonInfos(obj.model, name)
%     end
% end


function tol = polygonsSimplifyPrompt
%POLYGONSSIMPLIFYPROMPT  A dialog figure on which the user can select type
%the simplification's tolerence
%
%   Inputs : none
%   Outputs : resolution of the image

    % default value of the ouput to prevent errors
    tol = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(frame, 250, 130);

    % create the dialog
    d = dialog('position', pos, ...
                   'name', 'Enter image resolution');

    % create the inputs of the dialog box
    uicontrol('parent', d,...
            'position', [30 80 90 20], ...
               'style', 'text',...
              'string', 'Tolerance :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit = uicontrol('parent', d,...
                   'position', [130 81 90 20], ...
                      'style', 'edit', ...
                   'callback', @(~,~) callback);

    error = uicontrol('parent', d,...
                    'position', [135 46 85 25], ...
                       'style', 'text',...
                      'string', 'Invalid value', ...
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
            if ~isnan(str2double(get(edit,'String')))
            % if the input numeric then get its value and close the dialog box
                tol = str2double(get(edit,'String'));
                delete(gcf);
            else
                set(error, 'visible', 'on');
            end
        catch
            set(error, 'visible', 'on');
        end
    end
end

end