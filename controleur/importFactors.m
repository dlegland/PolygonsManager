function importFactors(~,~, obj)
%IMPORTFACTORS  Imports a factor file (.txt) and defines it as the current factors
%
%   Inputs :
%       - ~ (not used) : inputs automatically send by matlab during a callback
%       - obj : handle of the MainFrame
%   Outputs : none

loop = 0;
while loop == 0
    [fName, fPath] = uigetfile('C:\Stage2016_Thomas\data_plos\slabs\Tests\*.txt','Select a factor file');
    if fPath == 0
        return;
    end
    fFile = fullfile(fPath, fName);
        
    import = Table.read(fFile);
    factorTbl = zeros(length(obj.model.nameList), columnNumber(import));
    levels = cell(columnNumber(import), 1);
    for j = 1:columnNumber(import)
        levels{j} = cell(length(import.levels{j}), 1);
    end
    for i = 1:rowNumber(import)
        index = not(cellfun('isempty', ...
                strfind(obj.model.nameList, import.rowNames{i})));
        if any(index, 2) ~= 0
            factorTbl(index, :) = getRow(import, i);
            for j = 1:columnNumber(import)
                if isFactor(import, j)
                    if any(strcmp(levels{j}, getLevel(import, i, j))) == 0
                        ind = strcmp(import.levels{j}, getLevel(import, i, j));
                        levels{j}{ind} = getLevel(import, i, j);
                    end
                end
            end
        end
    end
    factorTbl = factorTbl(factorTbl~=0);
    factorTbl = reshape(factorTbl,[], columnNumber(import));
    if size(factorTbl, 1) == length(obj.model.nameList)
        for i = 1:columnNumber(import)
            levels{i} = levels{i}(~cellfun('isempty',levels{i}));
            transform = zeros(length(unique(factorTbl(:, i))), 2);
            transform(:, 1) = 1:length(unique(factorTbl(:, i)));
            transform(:, 2) = unique(factorTbl(:, i));
            if size(transform, 1) == 1
                a=transform(1); b=transform(2);
                factorTbl(factorTbl(:, i) == b, i) = a;
            else
                for j=1:length(transform)
                    a=transform(j,1); b=transform(j,2);
                    factorTbl(factorTbl(:, i) == b, i) = a;
                end
            end
        end
        factorTbl = Table.create(factorTbl, 'rowNames', obj.model.nameList, 'colNames', import.colNames);
        for i = 1:length(levels)
            if isFactor(import, i)
                setFactorLevels(factorTbl, i, levels{i});
            else
                setAsFactor(factorTbl, i);
            end
        end
        obj.model.factorTable = factorTbl;
        obj.model.factorTable.name = fName;
        updateMenus(obj);
        loop = 1;
    else
        loop = importFactorsPrompt;
    end
end

    function loop = importFactorsPrompt
        loop = 0;

        pos = getMiddle(gcf, 400, 130);

        d = dialog('position', pos, ...
                       'name', 'Error');

        uicontrol('parent', d,...
                'position', [30 80 340 20], ...
                   'style', 'text',...
                  'string', 'The selected factors are not compatible with the datas', ...
                'fontsize', 10);

        uicontrol('parent', d,...
                'position', [90 30 100 25], ...
                  'string', 'Cancel',...
                'callback', @callback);

        uicontrol('parent', d,...
                'position', [210 30 100 25], ...
                  'string', 'Choose another',...
                'callback', 'delete(gcf)');

        % Wait for d to close before running to completion
        uiwait(d);

        function callback(~,~)
            loop = 1;
            delete(gcf);
        end
    end

end