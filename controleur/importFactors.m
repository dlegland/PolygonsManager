function importFactors(obj)
%IMPORTFACTORS  Imports a factor file (.txt) and defines it as the current factor Table
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

loop = 0;
while loop == 0
    try
        % open the file selection prompt and let the user select the file
        % he wants to use as a factor Table
        [fName, fPath] = uigetfile('*.txt','Select a factor file');
        
        if fPath == 0
            % if the user closed the prompt without selecting a file,
            % terminate the function
            return;
        end
        
        % reassemble the full name of the file
        fFile = fullfile(fPath, fName);

        % get the Table contained in the selected file
        import = Table.read(fFile);
        
        % memory allocation
        factorTbl = zeros(length(obj.model.nameList), columnNumber(import));
        
        %get the levels list of the Table that was imported
        levels = import.levels;
        
        %for each row of the imported factor Table
        for i = 1:rowNumber(import)
            % find the polygon that contains the current row's name
            index = not(cellfun('isempty', ...
                    strfind(obj.model.nameList, import.rowNames{i})));
                
            % if one of the polygons contains the name of the current row
            if any(index, 2) ~= 0
                % save this row in the futur factor Table at the right
                % index
                factorTbl(index, :) = getRow(import, i);
            end
        end
        if size(factorTbl, 1) == length(obj.model.nameList)
            
            % create the new factor Table
            factorTbl = Table.create(factorTbl, 'rowNames', obj.model.nameList, 'colNames', import.colNames);
            
            % set the levels of the new factor Table
            for i = 1:length(levels)
                if isFactor(import, i)
                    setFactorLevels(factorTbl, i, levels{i});
                else
                    setAsFactor(factorTbl, i);
                end
            end
            
            % set the new factor Table as the current factor Table
            obj.model.factorTable = factorTbl;
            obj.model.factorTable.name = fName;
            
            % update the menus
            updateMenus(obj);
            loop = 1;
        else
            % if the number of rows of the futur factor Table doesn't match the
            % number of polygons, display the error prompt
            loop = importFactorsPrompt;
        end
    catch
        loop = importFactorsPrompt;
        continue;
    end
end

    function loop = importFactorsPrompt
    %IMPORTFACTORPROMPT  A dialog figure that informs the user that the
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
                  'string', 'The selected factor file is not compatible with the datas', ...
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