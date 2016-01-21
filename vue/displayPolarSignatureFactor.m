function displayPolarSignatureFactor(obj, signatureArray)
%DISPLAYPOLARSIGNATUREFACTOR  Display the current signatures colored by factors
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - signatureArray : a N-by-M cell array containing the polar signatures
%   Outputs : none

angles = obj.model.PolygonArray.angleList;
angles(end+1) = angles(end) + angles(2) - angles(1);

co = obj.handles.axes{2}.ColorOrder;
set(obj.handles.axes{2}, 'colororder', co(floor(1:length(co)/(length(obj.model.selectedFactor{2})-1)-1:length(co)), :));

set(obj.handles.axes{2}, 'colororderindex', 1);

lineHandles = cell(1, length(obj.model.selectedFactor{2}));
delete([obj.handles.lines{2}{:}]);

hold(obj.handles.axes{2}, 'on');
for i = 1:length(signatureArray)
    signature = signatureArray{i, 2};
    signature(end+1) = signature(1);
    obj.handles.lines{2}{i} = plot(angles, signature, 'parent', obj.handles.axes{2}, ...
                                                                           'ButtonDownFcn', @mouseClicker, ...
                                                                                     'tag', obj.model.nameList{i}, ...
                                                                                   'color', obj.handles.axes{2}.ColorOrder(signatureArray{i, 1}, :));
                                         
    if cellfun('isempty',lineHandles(signatureArray{i, 1}))
        line = obj.handles.lines{2}{i};
        lineHandles{signatureArray{i, 1}} = line;
    end
end
hold(obj.handles.axes{2}, 'off');

set(obj.handles.axes{2}, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    updateSelectedPolygonsDisplay(obj);
end
if obj.model.selectedFactor{3} == 0
    obj.handles.legends{2} = legend(obj.handles.axes{2}, [lineHandles{:}], obj.model.selectedFactor{2}, 'location', 'eastoutside');
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