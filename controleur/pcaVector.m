function [poly, values] = pcaVector(obj)
%PCAVECTOR  Compute the polygons' and signatures' means and display them
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : 
%       - poly : the polygons' mean
%       - values : the polar signatures' mean

% get ths column that will be displayed index, and the coefficient of the
% the calculus
[index, coef, profiles] = pcaVectorPrompt(length(obj.model.pca.loadings.rowNames));

if ~strcmp(index, '?')
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
        fenName = ['Polygons Manager | factors : ' obj.model.factorTable.name ' | PCA - Vectors'];
    else
        fenName = 'Polygons Manager | PCA - Vectors';
    end
    
    % memory allocation
    if strcmp(class(obj.model.PolygonArray), 'PolarSignatureArray')
        values = zeros(3, length(obj.model.PolygonArray.angleList));
    else
        values = zeros(3, size(obj.model.PolygonArray.polygons, 2));
    end
    poly = {};
    
    % compute eigen vector with appropriate coeff
    ld = obj.model.pca.loadings(:, index).data';
    lambda = obj.model.pca.eigenValues(index, 1).data;
    values(1, :) = obj.model.pca.means;
    values(2, :) = obj.model.pca.means + coef * sqrt(lambda) * ld;
    values(3, :) = obj.model.pca.means - coef * sqrt(lambda) * ld;
    
    % resulting polygon
    if strcmp(class(obj.model.PolygonArray), 'PolarSignatureArray')
        poly{1} = signatureToPolygon(values(1, :), obj.model.PolygonArray.angleList);
        poly{2} = signatureToPolygon(values(2, :), obj.model.PolygonArray.angleList);
        poly{3} = signatureToPolygon(values(3, :), obj.model.PolygonArray.angleList);
    else
        poly{1} = rowToPolygon(values(1, :), 'packed');
        poly{2} = rowToPolygon(values(2, :), 'packed');
        poly{3} = rowToPolygon(values(3, :), 'packed');
    end
    
    color = 1;
    switch profiles
        case 1
            polygons = poly;
            selValues = values;
        case 2
            [~,i] = min([sum(values(2, :)) sum(values(3,:))]);
            polygons = {poly{1}, poly{i+1}};
            selValues(1, :) = values(1, :);
            selValues(2, :) = values(i+1, :);
            color = 2;
        case 3
            [~,i] = max([sum(values(2, :)) sum(values(3,:))]);
            polygons = {poly{1}, poly{i+1}};
            selValues(1, :) = values(1, :);
            selValues(2, :) = values(i+1, :);
        case 4
            polygons = poly(1);
            selValues(1, :) = values(1, :);
    end
    % prepare the new PolygonsManagerMainFrame and display the graph
    setupNewFrame(fen, model, fenName, ...
                  'pcaVector', 'on', ...
                  polygons, ...
                  selValues, ...
                  color);
              
    panel1 = Panel(fen,length(fen.handles.tabs.Children) + 1, 'off');
    plot(panel1.uiAxis, 1:length(ld), ld, 'linewidth', 2, 'color', 'k');
    xlim(panel1.uiAxis, [1 length(ld)]);
              
end
function [index, coef, profiles] = pcaVectorPrompt(maxPC)
%PCAVECTORPROMPT  A dialog figure on which the user can select
%which principal component's vector he wants to display and the coefficient of the
%calculus
%
%   Inputs : 
%       - maxPC : total number of principal components
%   Outputs : 
%       - index : selected principal component
%       - coef : coefficient of the calculus

    % default value of the ouput to prevent errors
    index = '?';
    coef = '1';

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
              'string', 'PC :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup1 = uicontrol('Parent', d, ...
                    'Position', [130 152 90 20], ...
                       'Style', 'popup', ...
                      'string', 1:maxPC);

    uicontrol('parent', d, ...
            'position', [30 80 90 20], ...
               'style', 'text', ...
              'string', 'Extra profiles :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup2 = uicontrol('Parent', d, ...
                    'Position', [130 82 90 20], ...
                       'Style', 'popup', ...
                      'string', {'Both', 'Minus coef', 'Plus coef', 'None'});

    uicontrol('parent', d, ...
            'position', [30 115 90 20], ...
               'style', 'text', ...
              'string', 'Coefficient :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit = uicontrol('Parent', d, ...
                    'Position', [130 116 90 20], ...
                       'Style', 'edit', ...
                      'string', 1);

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
              'string', 'Validate',...
            'callback', @(~,~) callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel',...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback
        % get the value of the popup
        index = popup1.Value;
        profiles = popup2.Value;
        try
            % if the input numeric then get its value and close the dialog box
            if ~isnan(str2double(get(edit,'String')))
                coef = str2double(get(edit,'String'));
            % if the input contains an operation get the result and close the dialog box
            elseif find(ismember(get(edit,'String'), ['\', '¨', '/', '*', '+', '-'])) ~= 0
                coef = eval(get(edit,'String'));
            else
                set(error, 'visible', 'on');
            end
        catch
            set(error, 'visible', 'on');
        end
        
        % delete the dialog
        delete(gcf);
    end
end

end