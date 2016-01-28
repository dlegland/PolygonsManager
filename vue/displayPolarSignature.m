function displayPolarSignature(obj, signatureArray, axis)
%DISPLAYPOLARSIGNATURE  Display the current signatures
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - signatureArray : a N-by-M cell array containing the polar signatures
%       - axis : handle of the axis on which the lines will be drawn
%   Outputs : none

% get the list of all angles + 1 angle to make the last point match the
% first
angles = signatureArray.angleList;
angles(end+1) = angles(end) + angles(2)-angles(1);

% set the name of the tab
obj.handles.tabs.TabTitles{2} = 'Signatures';

% reset the position of the cursor in the axis' colormap
set(axis, 'colororderindex', 1);

% get the axis' colormap
co = axis.ColorOrder;
    
if length(co) > length(obj.model.nameList)
    % if there's less signatures than colors in the colormap
    % change the axis' colormap to get colors that are as different as
    % possible from eachother
    set(axis, 'colororder', co(floor(1:length(co)/(length(obj.model.nameList)) :length(co)), :));
end

% set the axis' limits
xlim(axis, [angles(1), angles(end)]);
ylim(axis, [0 max(obj.model.PolygonArray.signatures(:))+.5]);

% delete all the lines already drawn on the axis
delete([obj.handles.lines{2}{:}]);

hold(axis, 'on');
for i = 1:getPolygonNumber(signatureArray)
    % get the signature that will be drawn
    signature = getSignature(signatureArray, i);
    
    % make sure the last point matches the first
    signature(end+1) = signature(1);
    
    % draw the line
    obj.handles.lines{2}{i} = plot(angles, signature, 'parent', axis, ...
                                               'ButtonDownFcn', {@detectLineClick, obj}, ...
                                                         'tag', obj.model.nameList{i});
end
hold(axis, 'off');

% reset the colomap for futur uses
set(axis, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    % if at least one signature was selected, update the view
    updateSelectedPolygonsDisplay(obj);
end
end