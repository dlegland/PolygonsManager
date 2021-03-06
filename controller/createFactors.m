function createFactors(frame)
%CREATEFACTORS  Creates a factor Table using the current polygons
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% enter the name that will be used for the factor Table and the nb of factors
% it will contain
[factorName, nFactors] = createFactorPrompt1;

if strcmp(nFactors, '?') || nFactors == 0
    return;
end

rowNames = getPolygonNames(frame.model);
nPolys = length(rowNames);

% get the name of the first polygon to use it as an exemple
sampleName = frame.model.nameList{1};

% memory allocation
factors = Table.create(zeros(nPolys, 0), 'rowNames', rowNames);

for iFact = 1:nFactors
    [start, number, name] = createFactorPrompt2(iFact, sampleName);

    if strcmp(name, '?')
        return;
    end

    % add the new factor to the factor table
    fact = parseFactorFromRowNames(factors, start, number, name);
    factors = [factors fact]; %#ok<AGROW>
end

% set the factor Table name
factors.name = factorName;

% set the new factor Table as the current factor Table
frame.model.factors = factors;

%update the menus
updateMenus(frame);
updatePolygonInfoPanel(frame);


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
    pos = getMiddle(frame, 250, 165);

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
            'callback', @(~,~) callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel', ...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback
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
    pos = getMiddle(frame, 250, 235);

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
                   
    error{1} = uicontrol('parent', d, ...
                     'position', [220 150 20 20], ...
                        'style', 'text', ...
                       'string', '*', ...
              'foregroundcolor', 'r', ...
                     'fontsize', 10, ...
                      'visible', 'off');


    uicontrol('parent', d, ...
            'position', [30 115 90 20], ...
               'style', 'text', ...
              'string', 'Factor length :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit2 = uicontrol('Parent', d, ...
                    'Position', [130 116 90 20], ...
                       'Style', 'edit');

    error{2} = uicontrol('parent', d, ...
                     'position', [220 115 20 20], ...
                        'style', 'text', ...
                       'string', '*', ...
              'foregroundcolor', 'r', ...
                     'fontsize', 10, ...
                      'visible', 'off');

    uicontrol('parent', d,...
            'position', [30 80 90 20], ...
               'style', 'text',...
              'string', 'Factor name :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit3 = uicontrol('parent', d,...
                   'position', [130 81 90 20], ...
                      'style', 'edit');

    error{3} = uicontrol('parent', d,...
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
            'callback', @(~,~) callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel', ...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback
        try
            if ~isnan(str2double(get(edit1,'String'))) && ~isnan(str2double(get(edit2,'String')))
                
                start = str2double(get(edit1,'String'));
                number = str2double(get(edit2,'String'));
                if start > length(sample)
                    set(error{1}, 'visible', 'on');
                    set(error{2}, 'visible', 'off');
                    set(error{3}, 'visible', 'on');
                elseif start+number > length(sample)
                    set(error{1}, 'visible', 'off');
                    set(error{2}, 'visible', 'on');
                    set(error{3}, 'visible', 'on');
                else
                    name = get(edit3, 'string');
                    delete(gcf);
                end
            else
                set([error{isnan([str2double(get(edit1,'String')) str2double(get(edit2,'String'))])}], 'visible', 'on');
                set([error{~isnan([str2double(get(edit1,'String')) str2double(get(edit2,'String'))])}], 'visible', 'off');
                set(error{3}, 'visible', 'on');
            end
        catch
            set(error{3}, 'visible', 'on');
        end
    end
end

end