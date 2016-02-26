function savePolygons(obj)
%SAVECONTOURS  Saves the current polygons as separated text files in a folder
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none
%

if strcmp(class(obj.PolygonArray), 'CoordsPolygonArray')
    % open the file save prompt and let the user select the file where the polygons will be saved
    [fileName, dname] = uiputfile('*.txt');

    if fileName ~= 0
        % if the user did select a folder
        % create the columns' name
        vars = [cellstr(num2str((1:size(obj.PolygonArray.polygons, 2)/2)', 'x%d'))' cellstr(num2str((1:size(obj.PolygonArray.polygons, 2)/2)', 'y%d'))'];
        
        % create he Table containing the polygons and save it in the
        % previously selected file
        tab = Table.create(obj.PolygonArray.polygons, ...
                            'rowNames', obj.nameList, ...
                            'colNames', vars);
        write(tab, fullfile(dname, fileName));

        % display a message to inform the user that the save worked
        msgbox('success');
    end
elseif strcmp(class(obj.PolygonArray), 'PolarSignatureArray')
    % open the file save prompt and let the user select the name of the file in 
    % which the factor Table will be saved
    [fileName, dname] = uiputfile('*.txt');

    if fileName ~= 0
        % if the user did select a folder
        % get the list of angles that were used while computing the polar
        % signature
        colnames = cellstr(num2str(obj.PolygonArray.angleList'));

        % create he Table containing the polar signatures and save it in the
        % previously selected file
        tab = Table.create(obj.PolygonArray.signatures, ...
                            'rowNames', obj.nameList, ...
                            'colNames', colnames');
        write(tab, fullfile(dname, fileName));

        % display a message to inform the user that the save worked
        msgbox('success');
    end
else
    % select the folder where the polygons will be saved, and the prefix/suffix
    % that'll be added to the file names
    [dname, fileName] = savePrompt;

    if ~strcmp(dname, '?')
        for i = 1:length(obj.nameList)
            % get the name of the polygon that'll be saved
            name = obj.nameList{i};

            % complete the name with the prefix/suffix
            filename = sprintf(fileName, name);

            % create the Table containing the polygon and save it
            tab = Table.create(getPolygonFromName(obj, name), {'x', 'y'});
            write(tab, fullfile(dname, [filename '.txt']));
        end
        % display a message to inform the user that the save worked
        msgbox('success');
    end
end

function [dname, fileName] = savePrompt
%SAVECONTOURSPROMPT  A dialog figure on which the user can select
%the save folder and he prefix/suffix of the file name
%
%   Inputs : none
%   Outputs : 
%       - dname : full path of the save folder
%       - fileName : variable that stores the prefix/suffix

    % default value of the ouput to prevent errors
    dname = '?';
    fileName = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(obj, 500, 165);

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
                   'position', [130 81 150 20], ...
                      'style', 'edit', ...
                     'string', '%s');

    % create the two button to cancel or validate the inputs
    uicontrol('parent', d, ...
            'position', [280 30 85 25], ...
              'string', 'Validate', ...
            'callback', @(~,~) callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel', ...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback
        % get the values of both textbox
        dname = get(edit,'String');
        fileName = get(edit2,'String');
        
        if ~isempty(dname)
            % if the variable containing the folder path isn't empty
            delete(gcf);
        end
    end

    function dnameFnc
        % open the folder selection prompt and let the user select the
        % folder he wants to use as the save folder
        name = uigetdir('C:\Stage2016_Thomas\data_plos\slabs\Tests');
        
        set(edit, 'string', name);
    end
end

end