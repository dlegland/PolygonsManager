function saveMacro(obj)
[fileName, dname] = uiputfile('C:\Stage2016_Thomas\data_plos\slabs\Tests\*.log.txt');

if fileName ~= 0
    fileID = fopen(fullfile(dname, fileName), 'w');
    temp = obj.model.usedProcess';
    fprintf(fileID,'%s\n', temp{:});
    fclose(fileID);
end
end