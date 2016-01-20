function createPanel(obj, index, equal)
%CREATEPANEL  Create a new panel and every elements needed to display an axis
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - index : the index at which the panel handle will be saved in the
%       MainFrame
%       - equal : defines if the axis created must have the "equal"
%       parameter -> Values :
%                   - 1 : on
%                   - 2 : off
%   Outputs : none


co = [0.28 0.44 0.91;
      0.93 0.04 0.25;
      1.00 0.44 0.40;
      0.23 0.66 0.34;
      0.40 0.18 0.76;
      0.76 0.33 0.76;
      0.80 0.25 0.50;
      0.69 0.35 0.25;
      0.91 0.74 0.37;
      0.74 0.71 0.69;
      0.40 0.40 0.40;
      0.00 0.80 0.60];

    myPanel = uipanel('parent', obj.handles.tabs, 'bordertype', 'none');
    myAxe = axes('parent', myPanel, 'ButtonDownFcn', @reset, 'colororder', co);
         
%     set(myAxe, 'userdata', {});

    if equal == 1
        axis equal;
    end

    obj.handles.lines{index} = cell(length(obj.model.nameList), 1);
    obj.handles.panels{index} = myPanel;
    obj.handles.axes{index} = myAxe;

    set(obj.handles.tabs, 'selection', index, ...
                'SelectionChangedFcn', @select );

    function reset(~,~)
        modifiers = get(obj.handles.figure,'currentModifier');
        ctrlIsPressed = ismember('control',modifiers);
        if ~ctrlIsPressed
            obj.model.selectedPolygons = {};
            set(obj.handles.list, 'value', []);
            updateSelectedPolygonsDisplay(obj);
        end
    end

    function select(~,~)
        updateSelectedPolygonsDisplay(obj);
    end
end