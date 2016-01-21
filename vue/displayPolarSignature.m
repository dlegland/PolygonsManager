function displayPolarSignature(obj, signatureArray)
%DISPLAYPOLARSIGNATURE  Display the current signatures
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - signatureArray : a N-by-M cell array containing the polar signatures
%   Outputs : none

angles = signatureArray.angleList;
angles(end+1) = angles(end) + angles(2) - angles(1);

co = obj.handles.axes{1}.ColorOrder;
    
if length(co) > length(obj.model.nameList)
    set(obj.handles.axes{2}, 'colororder', co(floor(1:length(co)/(length(obj.model.nameList)-1)-1:length(co)), :));
end
set(obj.handles.axes{2}, 'colororderindex', 1);

xlim(obj.handles.axes{2}, [angles(1), angles(end)]);
ylim(obj.handles.axes{2}, [0 max(obj.model.PolygonArray.signatures(:))+.5]);

obj.handles.axes{2}.UserData = 0;
delete([obj.handles.lines{2}{:}]);

hold(obj.handles.axes{2}, 'on');
for i = 1:getPolygonNumber(signatureArray)
    signature = getSignature(signatureArray, i);
    signature(end+1) = signature(1);
    obj.handles.lines{2}{i} = plot(angles, signature, 'parent', obj.handles.axes{2}, ...
                                                                         'ButtonDownFcn', @mouseClicker, ...
                                                                                   'tag', obj.model.nameList{i});
end
hold(obj.handles.axes{2}, 'off');

set(obj.handles.axes{2}, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    updateSelectedPolygonsDisplay(obj);
end

    function mouseClicker(h,~)
        modifiers = get(obj.handles.figure,'currentModifier');
        ctrlIsPressed = ismember('control',modifiers);
        if ~ctrlIsPressed
            if find(strcmp(get(h,'tag'), obj.model.selectedPolygons))
                if length(obj.model.selectedPolygons) == 1
                    obj.model.selectedPolygons(strcmp(get(h,'tag'), obj.model.selectedPolygons)) = [];
                else
                    obj.model.selectedPolygons = obj.model.nameList(strcmp(get(h,'tag'), obj.model.nameList));
                end
            else
                obj.model.selectedPolygons = obj.model.nameList(strcmp(get(h,'tag'), obj.model.nameList));
            end
        else
            if find(strcmp(get(h,'tag'), obj.model.selectedPolygons))
                obj.model.selectedPolygons(strcmp(get(h,'tag'), obj.model.selectedPolygons)) = [];
            else
                obj.model.selectedPolygons{end+1} = obj.model.nameList{strcmp(get(h,'tag'), obj.model.nameList)};
            end
        end
        updateSelectedPolygonsDisplay(obj);
        set(obj.handles.list, 'value', find(ismember(obj.model.nameList, obj.model.selectedPolygons)));
    end
end