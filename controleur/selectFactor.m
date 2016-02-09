function selectFactor(obj)
%SELECTFACTOR  Prepare the datas to display the axes' lines colored by factors
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% select the factor that will determine the coloration and if the legend of
% the axis must be displayed

[factor, leg, factor2, envelope] = selectFactorPrompt;

if ~strcmp(factor, '?')
    % get the levels of the selected factor
    x = columnIndex(obj.model.factorTable, factor);
    levels = obj.model.factorTable.levels{x};
    
    % save the selected factor, it's levels, and the legend display option
    obj.model.selectedFactor = {factor levels leg envelope};
    
    if isempty(obj.handles.Panels{1}.type)
        % display the colored polygons
        displayPolygonsFactor(obj.handles.Panels{1}, getPolygonsFromFactor(obj.model, factor));
        if strcmp(class(obj.model.PolygonArray), 'PolarSignatureArray')
            % if the polygon array is a signature array, also display the
            % colored polar signatures
            displayPolarSignatureFactor(obj.handles.Panels{2}, getSignatureFromFactor(obj.model, factor));
        end
    else
        if ~strcmp(obj.handles.Panels{1}.type, 'pcaInfluence')
            ud = obj.handles.Panels{1}.uiAxis.UserData;
            displayPcaFactor(obj.handles.Panels{1}, getPcaFromFactor(obj.model, factor, obj.handles.Panels{1}.type, ud{1}, ud{2}), factor2);
%             displayPcaFactor(obj.handles.Panels{1});
        else
            displayPcaFactor(obj.handles.Panels{1}, getPcaFromFactor(obj.model, factor, obj.handles.Panels{1}.type), factor2);
%             displayPcaFactor(obj.handles.Panels{1});
        end
    end
end

function [factor, leg, factor2, group] = selectFactorPrompt
%SELECTFACTORPROMPT  Creates a dialog figure on which the user can select
%which factor he wants to see colored and if he wants to display the
%legend or not
%
%   Inputs : none
%   Outputs : 
%       - factor : selected factor
%       - leg : display option of the legend

    % default value of the ouput to prevent errors
    factor = '?';
    leg = '?';
    factor2 = '?';
    group = 'None';
    
    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 165);

    % create the dialog box
    d = dialog('Position', pos, ...
                   'Name', 'Select one factor');

    % create the inputs of the dialog box
    popupText = uicontrol('parent', d, ...
                        'position', [30 115 90 20], ...
                           'style', 'text', ...
                          'string', 'Color factor :', ...
                        'fontsize', 10, ...
             'horizontalalignment', 'right');

    popup1 = uicontrol('Parent', d, ...
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
                   'callback', @(~,~) toggle);
               
    if ~isempty(obj.handles.Panels{1}.type)
        pos = getMiddle(obj.handles.figure, 250, 235);
        d.Position = pos;
        popupText.Position = [30 185 90 20];
        popup1.Position = [130 187 90 20];
        
        % create the inputs of the dialog box
        uicontrol('parent', d, ...
                'position', [30 150 90 20], ...
                   'style', 'text', ...
                  'string', 'Group factor :', ...
                'fontsize', 10, ...
     'horizontalalignment', 'right');

        popup2 = uicontrol('Parent', d, ...
                         'Position', [130 152 90 20], ...
                            'Style', 'popup', ...
                           'string', obj.model.factorTable.colNames, ...
                           'enable', 'off');
        
        % create the inputs of the dialog box
        uicontrol('parent', d, ...
                'position', [30 115 90 20], ...
                   'style', 'text', ...
                  'string', 'Display groups :', ...
                'fontsize', 10, ...
     'horizontalalignment', 'right');

        popup3 = uicontrol('Parent', d, ...
                         'Position', [130 117 90 20], ...
                            'Style', 'popup', ...
                           'string', {'None', 'Convex hull', 'Ellipse', 'Inertia ellipse'}, ...
                         'callback', @(~,~) popupCallback);

    end
               
    % create the two button to cancel or validate the inputs
    uicontrol('parent', d, ...
            'position', [30 30 85 25], ...
              'string', 'Validate',...
            'callback', @(~,~) callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel',...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback
        val = popup1.Value;
        maps = popup1.String;
        factor = maps{val};
        leg = get(toggleB,'Value');
        if ~isempty(obj.handles.Panels{1}.type)
            val = popup2.Value;
            maps = popup2.String;
            factor2 = maps{val};
            val = popup3.Value;
            maps = popup3.String;
            group = maps{val};
        end

        delete(gcf);
    end

    function toggle
        if get(toggleB,'Value') == 1
            set(toggleB, 'string', 'No');
        else 
            set(toggleB, 'string', 'Yes');
        end
    end
    
    function popupCallback
        if popup3.Value == 1
            popup2.Enable = 'off';
        else
            popup2.Enable = 'on';
        end
    end
end

end