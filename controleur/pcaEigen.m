function pcaEigen(obj)

% extract data
coord   = obj.model.pca.scores.data;
values  = obj.model.pca.eigenValues.data;

nx = pcaEigenPrompt(size(coord, 2));

if isnumeric(nx)
    figure('units', 'normalized', ...
        'outerposition', [0.25 0.25 0.5 0.5], ...
              'menubar', 'none', ...
          'numbertitle', 'off', ...
                 'Name', 'Polygons Manager | PCA - Eigen Values');

    % scree plot
    bar(1:nx, values(1:nx, 2));

    % setup graph
    xlim([0 nx+1]);

    % annotations
    xlabel('Number of components');
    ylabel('Inertia (%)');
end

function nx = pcaEigenPrompt(nbCP)
%COLORFACTORPROMPT  A dialog figure on which the user can select
%which factor he wants to see colored and if he wants to display the
%legend or not
%
%   Inputs : none
%   Outputs : 
%       - factor : selected factor
%       - leg : display option of the legend

    % default value of the ouput to prevent errors
    nx = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 130);

    % create the dialog box
    d = dialog('Position', pos, ...
                   'Name', 'Select one factor');
               
    uicontrol('parent', d, ...
            'position', [30 80 90 20], ...
               'style', 'text', ...
              'string', 'number of CP :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup = uicontrol('Parent', d, ...
                    'Position', [130 82 90 20], ...
                       'Style', 'popup', ...
                      'string', 1:nbCP, ...
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
        nx = popup.Value;
        
        delete(gcf);
    end
end

end