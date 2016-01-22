function displayPolarSignatureFactor(obj, signatureArray, axis)
%DISPLAYPOLARSIGNATUREFACTOR  Display the current signatures colored by factors
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - signatureArray : a N-by-M cell array containing the polar signatures
%   Outputs : none

angles = obj.model.PolygonArray.angleList;
angles(end+1) = angles(end) + angles(2) - angles(1);

co = axis.ColorOrder;
set(axis, 'colororder', co(floor(1:length(co)/(length(obj.model.selectedFactor{2})):length(co)), :));

set(axis, 'colororderindex', 1);

lineHandles = cell(1, length(obj.model.selectedFactor{2}));
delete([obj.handles.lines{2}{:}]);

hold(axis, 'on');
for i = 1:length(signatureArray)
    signature = signatureArray{i, 2};
    signature(end+1) = signature(1);
    obj.handles.lines{2}{i} = plot(angles, signature, 'parent', axis, ...
                                               'ButtonDownFcn', {@detectLineClick, obj}, ...
                                                         'tag', obj.model.nameList{i}, ...
                                                       'color', axis.ColorOrder(signatureArray{i, 1}, :));
                                         
    if cellfun('isempty',lineHandles(signatureArray{i, 1}))
        line = obj.handles.lines{2}{i};
        lineHandles{signatureArray{i, 1}} = line;
    end
end
hold(axis, 'off');

set(axis, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    updateSelectedPolygonsDisplay(obj);
end
if obj.model.selectedFactor{3} == 0
    obj.handles.legends{2} = legend(axis, [lineHandles{:}], obj.model.selectedFactor{2}, 'location', 'eastoutside');
end
end