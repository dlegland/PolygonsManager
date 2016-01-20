function loadContoursFactor(obj)
%LOADCONTOURSFACTOR  Prepare the datas to display the polygons colored by factors
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

[factor, leg] = colorFactorPrompt(obj);
if ~strcmp(factor, '?')
    polygonList = getPolygonsFromFactor(obj.model, factor);

    x = columnIndex(obj.model.factorTable, factor);
    levels = obj.model.factorTable.levels{x};

    set(obj.handles.axes{1}, 'userdata', {factor levels leg});

    displayPolygonsFactor(obj, polygonList);
end

    function [factor, leg] = colorFactorPrompt(obj)
        
        factor = '?';
        leg = '?';
        pos = getMiddle(gcf, 250, 165);

        d = dialog('Position', pos, ...
                       'Name', 'Select one factor');

        uicontrol('parent', d, ...
                'position', [30 115 90 20], ...
                   'style', 'text', ...
                  'string', 'Factor :', ...
                'fontsize', 10, ...
     'horizontalalignment', 'right');

        popup = uicontrol('Parent', d, ...
                        'Position', [130 117 90 20], ...
                           'Style', 'popup', ...
                          'string', obj.model.factorTable.colNames);

        uicontrol('parent', d, ...
                'position', [30 80 90 20], ...
                   'style', 'text', ...
                  'string', 'Show legend :', ...
                'fontsize', 10, ...
     'horizontalalignment', 'right');

        toggleB = uicontrol('parent', d, ...
                       'position', [130 81 90 20], ...
                          'style', 'toggleButton', ...
                         'string', 'Yes', ...
                       'callback', @toggle);

    %     rbtn = uicontrol('parent', d, ...
    %                    'position', [140 70 100 25], ...
    %                       'style', 'radiobutton', ...
    %                      'string', 'Display legend');

        uicontrol('parent', d, ...
                'position', [30 30 85 25], ...
                  'string', 'Cancel',...
                'callback', 'delete(gcf)');

        uicontrol('parent', d, ...
                'position', [135 30 85 25], ...
                  'string', 'Validate',...
                'callback', @callback);

        % Wait for d to close before running to completion
        uiwait(d);

        function callback(~,~)
            val = popup.Value;
            maps = popup.String;
            factor = maps{val};
            leg = get(toggleB,'Value');

            delete(gcf);
        end

        function toggle(~,~)
            if get(toggleB,'Value') == 1
                set(toggleB, 'string', 'No');
            else 
                set(toggleB, 'string', 'Yes');
            end
        end
    end

end