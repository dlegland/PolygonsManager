function saveFactors(obj)
%SAVEPOLARSIGNATURE  Saves the current factors in a text file
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

[fileName, dname] = uiputfile('C:\Stage2016_Thomas\data_plos\slabs\Tests\*.txt', 'Save the current factors', obj.model.factorTable.name);
if ~isempty(fileName)
    write(obj.model.factorTable, fullfile(dname, fileName));
    msgbox('success');
end
end