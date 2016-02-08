function pcaEigen(obj)
%PCAEIGEN Creates a new frame and displays the eigen values of the current pca on it
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% extract data
coord   = obj.model.pca.scores.data;
values  = obj.model.pca.eigenValues.data;

% select the number of principal component the must be displayed
nbPC = pcaEigenPrompt(size(coord, 2));

if isnumeric(nbPC)
    % create a new figure
    figure('units', 'normalized', ...
        'outerposition', [0.25 0.25 0.5 0.5], ...
              'menubar', 'none', ...
          'numbertitle', 'off', ...
                 'Name', 'Polygons Manager | PCA - Eigen Values');

    % scree plot
    bar(1:nbPC, values(1:nbPC, 2));

    % setup graph
    xlim([0 nbPC+1]);

    % annotations
    xlabel('Number of components');
    ylabel('Inertia (%)');
end

function nbPC = pcaEigenPrompt(maxPC)
%PCAEIGENPROMPT  A dialog figure on which the user can select the number of principal components he wants to see on the graph
%
%   Inputs : 
%       - maxPC : total number of principal components
%   Outputs : 
%       - nbPC : selected number of pricipal components

    % default value of the ouput to prevent errors
    nbPC = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 130);

    % create the dialog box
    d = dialog('Position', pos, ...
                   'Name', 'Select one factor');
               
    uicontrol('parent', d, ...
            'position', [30 80 90 20], ...
               'style', 'text', ...
              'string', 'number of PC :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup = uicontrol('Parent', d, ...
                    'Position', [130 82 90 20], ...
                       'Style', 'popup', ...
                      'string', 1:maxPC, ...
                       'value', 2);

    % create the two button to cancel or validate the inputs
    uicontrol('parent', d, ...
            'position', [30 30 85 25], ...
              'string', 'Validate',...
            'callback', @callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel',...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback(~,~)
        nbPC = popup.Value;
        
        delete(gcf);
    end
end

end