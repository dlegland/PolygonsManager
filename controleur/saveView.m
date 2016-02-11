function saveView(obj)
 
name = saveViewPrompt;

if ~strcmp(name, '?')
    f = figure('position', obj.handles.Panels{obj.handles.tabs.Selection}.uiPanel.Position);
    h = copyobj(obj.handles.Panels{obj.handles.tabs.Selection}.uiPanel, f);
    positionLeg = get(findobj(obj.handles.Panels{obj.handles.tabs.Selection}.uiPanel, 'tag', 'legend'), 'position');
    positionAxis = get(findobj(obj.handles.Panels{obj.handles.tabs.Selection}.uiPanel, 'tag', 'main'), 'position');
    if iscell(obj.handles.Panels{obj.handles.tabs.Selection}.uiLegend)
        legendProp = obj.handles.Panels{obj.handles.tabs.Selection}.uiLegend;
        legend(findobj(h, 'tag', 'main'), legendProp{3}, legendProp{4}, ...
                                             'position', positionLeg, ...
                                        'uicontextmenu', []);
        set(findobj(h, 'tag', 'main'), 'position', positionAxis);
    end
    export_fig(f, name, '-nocrop');
    close(f);
end

function name = saveViewPrompt
%SAVECONTOURSPROMPT  A dialog figure on which the user can select
%the save folder and he prefix/suffix of the file name
%
%   Inputs : none
%   Outputs : 
%       - dname : full path of the save folder
%       - fileName : variable that stores the prefix/suffix

    % default value of the ouput to prevent errors
    name = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 500, 165);

    % create the dialog box
    d = dialog('position', pos, ...
                   'name', 'Select save options');

    % create the inputs of the dialog box
    uicontrol('parent', d,...
            'position', [30 115 90 20], ...
               'style', 'text',...
              'string', 'Directory :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit = uicontrol('parent', d,...
                   'position', [130 116 320 20], ...
                      'style', 'edit');

    uicontrol('parent', d,...
            'position', [450 116 20 20], ...
              'string', '...', ...
              'callback', @(~,~) dnameFnc);

    uicontrol('parent', d,...
            'position', [30 80 90 20], ...
               'style', 'text',...
              'string', 'File name :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit2 = uicontrol('parent', d,...
                   'position', [130 81 195 20], ...
                      'style', 'edit');

    uicontrol('parent', d,...
            'position', [330 80 60 20], ...
               'style', 'text',...
              'string', 'Format :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup = uicontrol('parent', d,...
                   'position', [400 82 70 20], ...
                      'style', 'popup', ...
                     'string', {'.png', '.jpg'});

    % create the two button to cancel or validate the inputs
    uicontrol('parent', d, ...
            'position', [385 30 85 25], ...
              'string', 'Validate', ...
            'callback', @(~,~) callback);

    uicontrol('parent', d, ...
            'position', [280 30 85 25], ...
              'string', 'Cancel', ...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback
        % get the values of both textbox
        dname = get(edit,'String');
        filename = get(edit2,'String');
        val = popup.Value;
        maps = popup.String;
        format = maps{val};
        
        if dname ~= 0
            % if the variable containing the folder path isn't empty
            name = fullfile(dname, [filename format]);
            delete(gcf);
        end
    end

    function dnameFnc
        % open the folder selection prompt and let the user select the
        % folder he wants to use as the save folder
        dname = uigetdir;
        
        set(edit, 'string', dname);
    end
end

end