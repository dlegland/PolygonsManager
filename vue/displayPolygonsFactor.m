function displayPolygonsFactor(obj, polygonArray, axis)
%DISPLAYPOLYGONSFACTOR  Display the current polygons colored by factors
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - polygonArray : a N-by-1 cell array containing the polygons
%       - axis : handle of the axis on which the lines will be drawn
%   Outputs : none

% update the checked values in the menu
set(obj.handles.submenus{4}{2}, 'checked', 'on');
set(obj.handles.submenus{4}{1}, 'checked', 'off');
set(obj.handles.submenus{6}{2}, 'checked', 'on');
set(obj.handles.submenus{6}{1}, 'checked', 'off');

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
delete([obj.handles.lines{1}{:}]);

hold(axis, 'on');
for i = 1:length(polygonArray)
    % draw the polygon on the axis
    obj.handles.lines{1}{i} = drawPolygon(polygonArray{i, 2}, 'parent', axis, ...
                                      'ButtonDownFcn', {@detectLineClick, obj}, ...
                                                'tag', obj.model.nameList{i}, ...
                                              'color', axis.ColorOrder(polygonArray{i, 1}, :));
                                         
    if cellfun('isempty',lineHandles(polygonArray{i, 1}))
        % if the factor of the signature that was just drawn has never been
        % encountered, create a copy of this line and save it, and add the
        % level to the list of levels that'll be displayed in the legend
        lineHandles{polygonArray{i, 1}} = copy(obj.handles.lines{1}{i});
        levels{polygonArray{i, 1}} = obj.model.selectedFactor{2}{polygonArray{i, 1}};
    end
end
hold(axis, 'off');

% remove all the empty cells of the levels list
levels = levels(~cellfun('isempty',levels));

% reset the colomap for futur uses
set(axis, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    % if at least one signature was selected, update the view
    updateSelectedPolygonsDisplay(obj);
end

if obj.model.selectedFactor{3} == 0
    % if the legend must be displayed, display it
    obj.handles.legends{1} = legend(axis, [lineHandles{:}], levels, ...
                                                'location', 'best', ...
                                           'uicontextmenu', []);
end
end