function importFactors(~,~, obj)
loop = 0;
while loop == 0
    [fName, fPath] = uigetfile('C:\Stage2016_Thomas\data_plos\slabs\images\*sel.txt','Select a factor file');
    if fPath == 0
        return;
    end
    fFile = fullfile(fPath, fName);

    factorTbl = Table.read(fFile);
    if rowNumber(factorTbl) == length(obj.model.nameList)
        obj.model.factorTable = factorTbl;
        set([obj.handles.submenus{:}], 'enable', 'on');
        loop = 1;
        set(obj.handles.figure, 'name', ['factors : ' fName]);
    else
        loop = importFactorsPrompt;
    end
end
end