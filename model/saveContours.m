function saveContours(obj)
%SAVECONTOURS  Saves the current polygons as separated text files in a folder
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

[dname, fileName] = savePrompt;
if ~strcmp(dname, '?')
    for i = 1:length(obj.model.nameList)
        name = obj.model.nameList{i};
        filename = sprintf(fileName, name);
        tab = Table.create(getPolygonFromName(obj.model, name), {'x', 'y'});
        write(tab, fullfile(dname, [filename '.txt']));
    end
    msgbox('success');
end

    function [dname, fileName] = savePrompt
        
        dname = '?';
        fileName = '?';
        
        pos = getMiddle(gcf, 500, 165);

        d = dialog('position', pos, ...
                       'name', 'Select save options');
        movegui(d,'center');

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
                  'callback', @dnameFnc);

        uicontrol('parent', d,...
                'position', [30 80 90 20], ...
                   'style', 'text',...
                  'string', 'File name :', ...
                'fontsize', 10, ...
     'horizontalalignment', 'right');

        edit2 = uicontrol('parent', d,...
                       'position', [130 81 150 20], ...
                          'style', 'edit', ...
                         'string', '%s');

        uicontrol('parent', d, ...
                'position', [280 30 85 25], ...
                  'string', 'Validate', ...
                'callback', @callback);

        uicontrol('parent', d, ...
                'position', [135 30 85 25], ...
                  'string', 'Cancel', ...
                'callback', 'delete(gcf)');

        % Wait for d to close before running to completion
        uiwait(d);

        function callback(~,~)
            dname = get(edit,'String');
            fileName = get(edit2,'String');
            if ~isempty(dname)
                delete(gcf);
            end
        end

        function dnameFnc(~,~)
            name = uigetdir('C:\Stage2016_Thomas\data_plos\slabs\Tests');

            set(edit, 'string', name);
        end
    end

end