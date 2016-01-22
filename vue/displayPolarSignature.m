function displayPolarSignature(obj, signatureArray, axis)
%DISPLAYPOLARSIGNATURE  Display the current signatures
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - signatureArray : a N-by-M cell array containing the polar signatures
%   Outputs : none

angles = signatureArray.angleList;
angles(end+1) = angles(end) + angles(2) - angles(1);

co = axis.ColorOrder;
    
if length(co) > length(obj.model.nameList)
    set(axis, 'colororder', co(floor(1:length(co)/(length(obj.model.nameList)) :length(co)), :));
end

set(axis, 'colororderindex', 1);

xlim(axis, [angles(1), angles(end)]);
ylim(axis, [0 max(obj.model.PolygonArray.signatures(:))+.5]);

axis.UserData = 0;
delete([obj.handles.lines{2}{:}]);

hold(axis, 'on');
for i = 1:getPolygonNumber(signatureArray)
    signature = getSignature(signatureArray, i);
    signature(end+1) = signature(1);
    obj.handles.lines{2}{i} = plot(angles, signature, 'parent', axis, ...
                                               'ButtonDownFcn', {@detectLineClick, obj}, ...
                                                         'tag', obj.model.nameList{i});
end
hold(axis, 'off');

set(axis, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    updateSelectedPolygonsDisplay(obj);
end
end