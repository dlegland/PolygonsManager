function pcaScores(obj)
%PCASCORES  Display the score of each polygon depending on 2 principal components
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% select the two principal component we want to compare and the
% variable that defines if the axis must be equalized
[cp1, cp2, equal] = pcaScoresPrompt(length(obj.model.pca.scores.rowNames));

if ~isnumeric([cp1 cp2])
    return;
end

% create a new PolygonsManagerMainFrame
fen = PolygonsManagerMainFrame;

% create the PolygonsManagerData that'll be used as the new
% PolygonsManagerMainFrame's model
model = duplicate(obj.model);

% prepare the the new PolygonsManagerMainFrame's name
if isa(obj.model.factors, 'Table')
    fenName = ['Polygons Manager | factors : ' obj.model.factors.name ' | PCA - Scores'];
else
    fenName = 'Polygons Manager | PCA - Scores';
end

% prepare the new PolygonsManagerMainFrame and display the graph
setupNewFrame(fen, model, fenName, ...
              'pcaScores', equal, ...
              obj.model.pca.scores(:, cp1).data, ...
              obj.model.pca.scores(:, cp2).data);

% save the two principal components that were selected in the axis
fen.handles.Panels{1}.uiAxis.UserData = {cp1, cp2};

% create legends
annotateFactorialPlot(fen.model.pca, fen.handles.Panels{1}.uiAxis, cp1, cp2);

    
function [cp1, cp2, equal] = pcaScoresPrompt(nbPC)
%PCASCOREPROMPT  A dialog figure on which the user can select
%which principal components he wants to oppose and if the axis must be
%equalized
%
%   Inputs : none
%   Outputs : 
%       - cp1 : principal component n°1
%       - cp2 : principal component n°2
%       - equal : determines if the axis must be equalized

    % default value of the ouput to prevent errors
    cp1 = '?';
    cp2 = '?';
    equal = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(obj, 250, 200);

    % create the dialog box
    d = dialog('Position', pos, ...
                   'Name', 'Select one factor');

    % create the inputs of the dialog box
    uicontrol('parent', d, ...
            'position', [30 150 90 20], ...
               'style', 'text', ...
              'string', 'PC n°1 :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup1 = uicontrol('Parent', d, ...
                    'Position', [130 152 90 20], ...
                       'Style', 'popup', ...
                      'string', 1:nbPC);

    uicontrol('parent', d, ...
            'position', [30 115 90 20], ...
               'style', 'text', ...
              'string', 'PC n°2 :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup2 = uicontrol('Parent', d, ...
                    'Position', [130 117 90 20], ...
                       'Style', 'popup', ...
                      'string', 1:nbPC, ...
                       'value', 2);

    uicontrol('parent', d, ...
            'position', [30 80 90 20], ...
               'style', 'text', ...
              'string', 'Axis equal :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    toggleB = uicontrol('parent', d, ...
                   'position', [130 81 90 20], ...
                      'style', 'toggleButton', ...
                     'string', 'On', ...
                   'callback', @(~,~) toggle);


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
        % get the valus of both popup and the value of th toggle button
        cp1 = popup1.Value;
        cp2 = popup2.Value;
        equal = lower(get(toggleB,'String'));
        
        % delete the dialog
        delete(gcf);
    end
    

    function toggle
        % updaate the value of the toggle button depending on its state
        if get(toggleB,'Value') == 1
            set(toggleB, 'string', 'Off');
        else 
            set(toggleB, 'string', 'On');
        end
    end
end

end