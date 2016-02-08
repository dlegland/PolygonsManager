function pcaLoadings(obj)
%PCALOADINGS Display the loadings of each vertices depending on 2 principal components
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% select the two principal component we want to compare
[cp1, cp2] = pcaLoadingsPrompt(length(obj.model.pca.loadings.rowNames));

if isnumeric([cp1 cp2])
    % create a new PolygonsManagerMainFrame
    fen = PolygonsManagerMainFrame;
    
    % create the PolygonsManagerData that'll be used as the new
    % PolygonsManagerMainFrame's model
    model = PolygonsManagerData('PolygonArray', obj.model.PolygonArray, ...
                                    'nameList', obj.model.nameList, ...
                                 'factorTable', obj.model.factorTable, ...
                                         'pca', obj.model.pca);

    % prepare the the new PolygonsManagerMainFrame's name
    if strcmp(class(obj.model.factorTable), 'Table')
        fenName = ['Polygons Manager | factors : ' obj.model.factorTable.name ' | PCA - Loadings'];
    else
        fenName = 'Polygons Manager | PCA - Loadings';
    end
    
    % prepare the new PolygonsManagerMainFrame and display the graph
    setupNewFrame(fen, model, fenName, ...
                  'pcaLoadings', 'off', ...
                  obj.model.pca.loadings(:, cp1).data, ...
                  obj.model.pca.loadings(:, cp2).data);
    
    
    % create legends
    annotateFactorialPlot(fen.model.pca, fen.handles.Panels{1}.uiAxis, cp1, cp2);
end

function [cp1, cp2] = pcaLoadingsPrompt(nbPC)
%PCALOADINGSPROMPT  A dialog figure on which the user can select
%which principal components he wants to oppose
%
%   Inputs : none
%   Outputs : 
%       - cp1 : principal component n°1
%       - cp2 : principal component n°2

    % default value of the ouput to prevent errors
    cp1 = '?';
    cp2 = '?';

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
              'string', 'PC n°1 :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup1 = uicontrol('Parent', d, ...
                    'Position', [130 117 90 20], ...
                       'Style', 'popup', ...
                      'string', 1:nbPC);

    uicontrol('parent', d, ...
            'position', [30 80 90 20], ...
               'style', 'text', ...
              'string', 'PC n°2 :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup2 = uicontrol('Parent', d, ...
                    'Position', [130 82 90 20], ...
                       'Style', 'popup', ...
                      'string', 1:nbPC, ...
                       'value', 2);

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
        % get the values of both popup
        cp1 = popup1.Value;
        cp2 = popup2.Value;
        
        % delete the dialog
        delete(gcf);
    end
end

end