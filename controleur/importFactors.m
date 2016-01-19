function importFactors(~,~, obj)
loop = 0;
while loop == 0
    [fName, fPath] = uigetfile('C:\Stage2016_Thomas\data_plos\slabs\images\*sel.txt','Select a factor file');
    if fPath == 0
        return;
    end
    fFile = fullfile(fPath, fName);

    import = Table.read(fFile);
    factorTbl = zeros(rowNumber(import), columnNumber(import));
    if rowNumber(import) == length(obj.model.nameList)
        for i = 1:rowNumber(import)
            index = not(cellfun('isempty', ...
                    strfind(obj.model.nameList, import.rowNames{i})));
            if exist('index', 'var')
                factorTbl(index, :) = getRow(import, i);
            else
                return;
            end
        end
        factorTbl = Table.create(factorTbl, 'rowNames', obj.model.nameList, 'colNames', import.colNames);
        for i = 1:columnNumber(factorTbl)
            setFactorLevels(factorTbl, i, factorLevels(import, i));
        end
        show(factorTbl);
        obj.model.factorTable = factorTbl;
        set([obj.handles.submenus{:}], 'enable', 'on');
        loop = 1;
        set(obj.handles.figure, 'name', ['factors : ' fName]);
    else
        loop = importFactorsPrompt;
    end
end
end