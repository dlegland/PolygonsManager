function chooseGroupingFactor(frame)
%CHOOSEGROUPINGFACTOR changes the grouping factor for display
%
%   output = chooseGroupingFactor(input)
%
%   Example
%   chooseGroupingFactor
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-03-28,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

factors = frame.model.factors;
if isempty(factors)
    return;
end

name = promptGroupingFactorName(frame);
if isempty(frame) || strcmp(name, '?')
    return;
end

frame.model.groupingFactorName = name;

for i = 1:getPanelNumber(frame)
    panel = getPanel(frame, i);
    refreshDisplay(panel);
end


function name = promptGroupingFactorName(frame)
%PCASCOREPROMPT  A dialog figure on which the user can select
%which principal components he wants to oppose and if the axis must be
%equalized
%
%   Inputs : none
%   Outputs : 
%       - cp1 : principal component n°1
%       - cp2 : principal component n°2
%       - equal : determines if the axis must be equalized

%     % default value of the ouput to prevent errors
%     cp1 = '?';
%     cp2 = '?';
%     equal = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(frame, 250, 200);

    % create the dialog box
    d = dialog('Position', pos, ...
                   'Name', 'Select one factor');

    % create the inputs of the dialog box
    uicontrol('parent', d, ...
            'position', [30 150 150 20], ...
               'style', 'text', ...
              'string', 'Grouping Factor:', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    name = '?';
    
    factorNames = ['none' frame.model.factors.colNames];
%     default = frame.model.groupingFactorName;
    index = find(strcmp(factorNames, frame.model.groupingFactorName));
    
    popup1 = uicontrol('Parent', d, ...
                    'Position', [30 120 150 20], ...
                       'Style', 'popup', ...
                      'string', factorNames, ...
                      'value', index);


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
        % get the valus of both popup and the value of the toggle button
        strings = get(popup1, 'string');
        name = strings{popup1.Value};
        
        % delete the dialog
        delete(gcf);
    end
end

end
