function pcaScoresProfiles(obj)
%PCASCORESPROFILES  Display the score of each polygon depending on 2 principal components
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% if the current panel isn't displaying a score plot

% select the two principal component we want to compare and the
% variable that defines if the axis must be equalized
[cp1, cp2, equal] = pcaScoresPrompt(length(obj.model.pca.scores.rowNames));

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
        fenName = ['Polygons Manager | factors : ' obj.model.factorTable.name ' | PCA - Scores'];
    else
        fenName = 'Polygons Manager | PCA - Scores';
    end

    % prepare the new PolygonsManagerMainFrame and display the graph
    setupNewFrame(fen, model, fenName, ...
                  'pcaScoresProfiles', equal, ...
                  obj.model.pca.scores(:, cp1).data, ...
                  obj.model.pca.scores(:, cp2).data);

    delete(fen.handles.Panels{1}.uiAxis);
    fen.handles.Panels{1}.uiAxis = [];

    grid = uix.Grid('parent', fen.handles.Panels{1}.uiPanel);

    hbox = uix.HBox('parent', grid, 'padding', 5);
    uix.Empty('parent', hbox);
    axisArray{1} = axes('parent', hbox, 'ActivePositionProperty', 'Position');
    uix.Empty('parent', hbox);
    axisArray{2} = axes('parent', hbox, 'ActivePositionProperty', 'Position');
    uix.Empty('parent', hbox);

    pan = uipanel('parent', grid, 'bordertype', 'none');
    fen.handles.Panels{1}.uiAxis = axes('parent', pan, ...
                                 'ButtonDownFcn', @(~,~) reset(fen.handles.Panels{1}), ...
                                    'colororder', fen.handles.Panels{1}.colorMap, ...
                                           'tag', 'main', ...
                                 'uicontextmenu', fen.handles.menus{6});

    uix.Empty('parent', grid);

    vbox = uix.VBox('parent', grid, 'padding', 15);
    uix.Empty('parent', vbox);
    axisArray{3} = axes('parent', vbox, 'ActivePositionProperty', 'Position');
    uix.Empty('parent', vbox);
    axisArray{4} = axes('parent', vbox, 'ActivePositionProperty', 'Position');
    uix.Empty('parent', vbox);
    
    hbox.Widths = [-9 150 -10 150 -7];
    vbox.Heights = [-1 150 -1 150 -1];
    
    grid.Heights = [150 -1]; 
    grid.Widths = [-1 170]; 
    
    set([axisArray{:}], 'XTick', [], 'YTick', [], 'YColor','w' , 'XColor','w', 'Xlim', [-10 10], 'Ylim', [-10 10]);
    axis([axisArray{:}], 'equal');

    ld1 = obj.model.pca.loadings(:, cp1).data';
    lambda1 = obj.model.pca.eigenValues(cp1, 1).data;
    
    ld2 = obj.model.pca.loadings(:, cp2).data';
    lambda2 = obj.model.pca.eigenValues(cp2, 1).data;
    
    if strcmp(class(obj.model.PolygonArray), 'PolarSignatureArray')
        polys{2, 1} = signatureToPolygon(obj.model.pca.means, obj.model.PolygonArray.angleList);
        polys{2, 2} = signatureToPolygon(obj.model.pca.means + sqrt(lambda1) * ld1, obj.model.PolygonArray.angleList);
        polys{1, 1} = polys{2, 1};
        polys{1, 2} = signatureToPolygon(obj.model.pca.means - sqrt(lambda1) * ld1, obj.model.PolygonArray.angleList);

        polys{3, 1} = signatureToPolygon(obj.model.pca.means, obj.model.PolygonArray.angleList);
        polys{3, 2} = signatureToPolygon(obj.model.pca.means + sqrt(lambda2) * ld2, obj.model.PolygonArray.angleList);
        polys{4, 1} = polys{3, 1};
        polys{4, 2} = signatureToPolygon(obj.model.pca.means - sqrt(lambda2) * ld2, obj.model.PolygonArray.angleList);
    else
        polys{2, 1} = rowToPolygon(obj.model.pca.means, 'packed');
        polys{2, 2} = rowToPolygon(obj.model.pca.means + sqrt(lambda1) * ld1, 'packed');
        polys{1, 1} = polys{2, 1};
        polys{1, 2} = rowToPolygon(obj.model.pca.means - sqrt(lambda1) * ld1, 'packed');

        polys{3, 1} = rowToPolygon(obj.model.pca.means, 'packed');
        polys{3, 2} = rowToPolygon(obj.model.pca.means + sqrt(lambda2) * ld2, 'packed');
        polys{4, 1} = polys{3, 1};
        polys{4, 2} = rowToPolygon(obj.model.pca.means - sqrt(lambda2) * ld2, 'packed');
    end
    
    for i = 1:length(axisArray)
        hold(axisArray{i}, 'on');
        drawPolygon(polys{i, 1}, 'parent', axisArray{i}, 'color', 'k');
        drawPolygon(polys{i, 2}, 'parent', axisArray{i}, 'color', 'r', 'linewidth', 2);
        hold(axisArray{i}, 'off');
    end
    
    displayPca(fen.handles.Panels{1}, ...
               fen.model.pca.scores(:, cp1).data, ...
               fen.model.pca.scores(:, cp2).data);
           
    % save the two principal components that were selected in the axis
    fen.handles.Panels{1}.uiAxis.UserData = {cp1, cp2};
    
    % create legends
    annotateFactorialPlot(fen.model.pca, fen.handles.Panels{1}.uiAxis, cp1, cp2);

end
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
    pos = getMiddle(gcf, 250, 200);

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