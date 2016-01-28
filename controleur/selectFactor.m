function selectFactor(obj)
%SELECTFACTOR  Prepare the datas to display the axes' lines colored by factors
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% select the factor that will determine the coloration and if the legend of
% the axis must be displayed
[factor, leg] = colorFactorPrompt(obj);

if ~strcmp(factor, '?')
    % get the levels of the selected factor
    x = columnIndex(obj.model.factorTable, factor);
    levels = obj.model.factorTable.levels{x};
    
    % save the selected factor, it's levels, and the legend display option
    obj.model.selectedFactor = {factor levels leg};
    
    if isempty(obj.handles.Panels{1}.type)
        % display the colored polygons
        displayPolygonsFactor(obj.handles.Panels{1}, getPolygonsFromFactor(obj.model, factor));
        if isa(obj.model.PolygonArray, 'PolarSignatureArray')
            % if the polygon array is a signature array, also display the
            % colored polar signatures
            displayPolarSignatureFactor(obj.handles.Panels{2}, getSignatureFromFactor(obj.model, factor));
        end
    else
        if ~strcmp(obj.handles.Panels{1}.type, 'pcaInfluence')
            ud = obj.handles.Panels{1}.uiAxis.UserData;
            displayPcaFactor(obj.handles.Panels{1}, getPcaFromFactor(obj.model, factor, obj.handles.Panels{1}.type, ud{1}, ud{2}));
        else
            displayPcaFactor(obj.handles.Panels{1}, getPcaFromFactor(obj.model, factor, obj.handles.Panels{1}.type));
        end
    end
end

function [factor, leg] = colorFactorPrompt(obj)
%COLORFACTORPROMPT  A dialog figure on which the user can select
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

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 165);

    % create the dialog box
    d = dialog('Position', pos, ...
                   'Name', 'Select one factor');

    % create the inputs of the dialog box
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

    % create the two button to cancel or validate the inputs
    uicontrol('parent', d, ...
            'position', [30 30 85 25], ...
              'string', 'Validate',...
            'callback', @callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel',...
            'callback', 'delete(gcf)');

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