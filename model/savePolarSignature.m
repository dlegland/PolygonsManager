function savePolarSignature(obj)
%SAVEPOLARSIGNATURE  Saves the current polar signature in a text file
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

[fileName, dname] = uiputfile('C:\Stage2016_Thomas\data_plos\slabs\Tests\*.txt');
if ~isempty(fileName)
    colnames = cellstr(num2str(obj.model.PolygonArray.angleList'));
    tab = Table.create(obj.model.PolygonArray.signatures, ...
                        'rowNames', obj.model.nameList, ...
                        'colNames', colnames');
    write(tab, fullfile(dname, fileName));
    msgbox('success');
end
end