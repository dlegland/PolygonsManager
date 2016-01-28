function displayPolarSignatureFactor(obj, signatureArray, axis)
%DISPLAYPOLARSIGNATUREFACTOR  Display the current signatures colored by factors
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - signatureArray : a N-by-M cell array containing the polar signatures
%       - axis : handle of the axis on which the lines will be drawn
%   Outputs : none

% get the list of all angles + 1 angle to make the last point match the
% first
angles = obj.model.PolygonArray.angleList;
angles(end+1) = angles(end) + angles(2) - angles(1);

% reset the position of the cursor in the axis' colormap
set(axis, 'colororderindex', 1);

% get the axis' colormap
co = axis.ColorOrder;

% change the axis' colormap to get colors that are as different as
% possible from eachother
set(axis, 'colororder', co(floor(1:length(co)/(length(obj.model.selectedFactor{2})):length(co)), :));

% memory allocation for the array that'll contain the legend's lines
lineHandles = cell(1, length(obj.model.selectedFactor{2}));
levels = cell(1, length(obj.model.selectedFactor{2}));

% delete all the lines already drawn on the axis
delete([obj.handles.lines{2}{:}]);

hold(axis, 'on');
for i = 1:length(signatureArray)
    % get the signature that will be drawn
    signature = signatureArray{i, 2};
    
    % make sure the last point matches the first
    signature(end+1) = signature(1);
    
    % draw the line
    obj.handles.lines{2}{i} = plot(angles, signature, 'parent', axis, ...
                                               'ButtonDownFcn', {@detectLineClick, obj}, ...
                                                         'tag', obj.model.nameList{i}, ...
                                                       'color', axis.ColorOrder(signatureArray{i, 1}, :));
                                         
    if cellfun('isempty',lineHandles(signatureArray{i, 1}))
        % if the factor of the signature that was just drawn has never been
        % encountered, create a copy of this line and save it
        lineHandles{signatureArray{i, 1}} = copy(obj.handles.lines{2}{i});
        levels{signatureArray{i, 1}} = obj.model.selectedFactor{2}{signatureArray{i, 1}};
    end
end
hold(axis, 'off');

levels = levels(~cellfun('isempty',levels));

% reset the colomap for futur uses
set(axis, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    % if at least one signature was selected, update the view
    updateSelectedPolygonsDisplay(obj);
end

if obj.model.selectedFactor{3} == 0
    % if the legend must be displayed, display it
    obj.handles.legends{2} = legend(axis, [lineHandles{:}], levels, ...
                                                'location', 'eastoutside', ...
                                           'uicontextmenu', []);
end
end