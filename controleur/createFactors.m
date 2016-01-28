function createFactors(obj)
%CREATEFACTORS  creates a factor Table using the current polygons
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% enter the name that will be used for the factor Table and the nb of factors
% that it'll contain
[factorName, nbFactors] = createFactorPrompt1;

if ~strcmp(nbFactors, '?')
    % get the name of one of the polygons to use it as an exemple
    sampleName = obj.model.nameList{1};

    % memory allocation
    rowNames = Table.create(zeros(length(obj.model.nameList), 1), 'rowNames',  obj.model.nameList);
    
    % for the 1st factor, enter it's name, index of its first character, and
    % number of characters
    [start, number, name] = createFactorPrompt2(1, sampleName);
    
    if ~strcmp(name, '?')
        % create the Table that will be output
        factorTbl = parseFactorFromRowNames(rowNames, start, number, name);

        if nbFactors > 1
            % if there's more than 1 factor
            for i = 2:nbFactors
                % for each factor, enter it's name, index of its first character, and
                % number of characters
                [start, number, name] = createFactorPrompt2(i, sampleName);

                if strcmp(name, '?')
                    return;
                end
                % add the new factor to the factor table
                factorTbl = horzcat(factorTbl, parseFactorFromRowNames(rowNames, start, number, name));
            end
        end
    
        % set the factor Table name
        factorTbl.name = factorName;

        % set the new factor Table as the current factor Table
        obj.model.factorTable = factorTbl;

        %update the menus
        updateMenus(obj);
    end
    
end


function [factorName, nbFactors] = createFactorPrompt1
%CREATEFACTORPROMPT1  A dialog figure on which the user can enter the
%name of the new factor Table and the number of factors it'll contain
%
%   Inputs : none
%   Outputs : 
%       - factorName : name of the new factor Table
%       - nbFactors : number of factors of the new factor Table

    % default value of the ouput to prevent errors
    factorName = '?';
    nbFactors = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 165);

    % create the dialog box
    d = dialog('position', pos, ...
                   'name', 'Enter number of factors');

    % create the inputs of the dialog box
    uicontrol('parent', d, ...
            'position', [30 115 90 20], ...
               'style', 'text', ...
              'string', 'Factor name :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit1 = uicontrol('Parent', d, ...
                    'Position', [130 116 90 20], ...
                       'Style', 'edit');

    uicontrol('parent', d,...
            'position', [30 80 90 20], ...
               'style', 'text',...
              'string', 'Nb of factors :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit2 = uicontrol('parent', d,...
                   'position', [130 81 90 20], ...
                      'style', 'edit');

    error = uicontrol('parent', d,...
                    'position', [135 46 85 25], ...
                       'style', 'text',...
                      'string', 'Invalid value', ...
             'foregroundcolor', 'r', ...
                     'visible', 'off', ...
                    'fontsize', 8);

    % create the two buttons to cancel or validate the inputs
    uicontrol('parent', d, ...
            'position', [30 30 85 25], ...
              'string', 'Validate', ...
            'callback', @callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel', ...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback(~,~)
        try
            % if both inputs are numeric, get them and close the dialog box
            if ~isnan(str2double(get(edit2,'String')))
                factorName = get(edit1, 'string');
                nbFactors = str2double(get(edit2,'String'));
                delete(gcf);
            else
                set(error, 'visible', 'on');
            end
        catch
            set(error, 'visible', 'on');
        end
    end
end

function [start, number, name] = createFactorPrompt2(index, sample)
%CREATEFACTORPROMPT1  A dialog figure on which the user can enter the
%starting character's index of the factor, the number of
%characters it'll contain, and it's name
%
%   Inputs : 
%       - index : the number of the factor
%       - sample : an exemple of a polygon's name
%   Outputs : 
%       - start : starting character's index of the factor
%       - nbFactors : number of characters the factor will contain
%       - name : factor's name

    % default value of the ouput to prevent errors
    start = '?';
    number = '?';
    name = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 235);

    % create the dialog box
    d = dialog('position', pos, ...
                   'name', ['Factor number : ' num2str(index)]);

    % create the inputs of the dialog box
    uicontrol('parent', d, ...
            'position', [30 185 200 20], ...
               'style', 'text', ...
              'string', sample, ...
            'fontsize', 10);

    uicontrol('parent', d, ...
            'position', [30 150 90 20], ...
               'style', 'text', ...
              'string', 'Factor start :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit1 = uicontrol('Parent', d, ...
                    'Position', [130 151 90 20], ...
                       'Style', 'edit');

    uicontrol('parent', d, ...
            'position', [30 115 90 20], ...
               'style', 'text', ...
              'string', 'Factor length :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit2 = uicontrol('Parent', d, ...
                    'Position', [130 116 90 20], ...
                       'Style', 'edit');

    uicontrol('parent', d,...
            'position', [30 80 90 20], ...
               'style', 'text',...
              'string', 'Factor name :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit3 = uicontrol('parent', d,...
                   'position', [130 81 90 20], ...
                      'style', 'edit');

    error = uicontrol('parent', d,...
                    'position', [135 46 85 25], ...
                       'style', 'text',...
                      'string', 'Invalid value', ...
             'foregroundcolor', 'r', ...
                     'visible', 'off', ...
                    'fontsize', 8);

    % create the two button to cancel or validate the inputs
    uicontrol('parent', d, ...
            'position', [30 30 85 25], ...
              'string', 'Validate', ...
            'callback', @callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel', ...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback(~,~)
        try
            if ~isnan(str2double(get(edit1,'String'))) && ~isnan(str2double(get(edit2,'String')))
                start = str2double(get(edit1,'String'));
                number = str2double(get(edit2,'String'));
                name = get(edit3, 'string');
                delete(gcf);
            else
                set(error, 'visible', 'on');
            end
        catch
            set(error, 'visible', 'on');
        end
    end
end

end