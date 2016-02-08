function importPolarSignature(obj)
%IMPORTPOLARSIGNATURE  Imports a polar signature file (.txt) and defines it as the current signature array
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

loop = 0;
while loop == 0
    % open the file selection prompt and let the user select the file he wants
    % to use as a polygon array
    [fName, fPath] = uigetfile('C:\Stage2016_Thomas\data_plos\slabs\Tests\*.txt');
    fFile = fullfile(fPath, fName);

    if fName ~= 0
        if ~isempty(obj.handles.Panels)
            % if the figure already contains a polygon array
            obj = PolygonsManagerMainFrame;
        end

        %read the Table contained in the selected file
        import = Table.read(fFile);

        % determine the angle list depending on the column names of the Table
        pas = 360/columnNumber(import);
        startAngle = str2double(import.colNames{1});
        if ~isnan(startAngle)
            angles = startAngle:pas:360+startAngle-pas;

            % set the new polygon array as the current polygon array
            model = PolygonsManagerData('PolygonArray', PolarSignatureArray(import.data, angles), 'nameList', import.rowNames');

            %setup the frame
            setupNewFrame(obj, model);
            loop = 1;
        else
            loop = importPolarSignaturePrompt;
        end
    else
        % if the number of rows of the futur factor Table doesn't match the
        % number of polygons, display the error prompt
        loop = importPolarSignaturePrompt;
    end
end

function loop = importPolarSignaturePrompt
%IMPORTPOLARSIGNATUREPROMPT  A dialog figure that informs the user that the
%select file cannot be used as the factor Table, and let's him choose
%if he wants to select another or not
%
%   Inputs : none
%   Outputs : 
%       - loop : variable that determines if the whille loop of the
%       main part continues or not

    % set the value of loop to zero
    loop = 0;

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 400, 130);

    % create the dialog box
    d = dialog('position', pos, ...
                   'name', 'Error');

    % display the warning message
    uicontrol('parent', d,...
            'position', [30 80 340 20], ...
               'style', 'text',...
              'string', 'The selected file doesn''t contain polar signatures', ...
            'fontsize', 10);

    % create the two buttons to stop or continue the selection
    uicontrol('parent', d,...
            'position', [90 30 100 25], ...
              'string', 'Cancel',...
            'callback', @(~,~) callback);

    uicontrol('parent', d,...
            'position', [210 30 100 25], ...
              'string', 'Choose another',...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback
        loop = 1;
        delete(gcf);
    end
end

end