function savePolarSignature(~,~, obj)
%SAVEPOLARSIGNATURE  Saves the current polar signature in a text file
%
%   Inputs :
%       - ~ (not used) : inputs automatically send by matlab during a callback
%       - obj : handle of the MainFrame
%   Outputs : none

[fileName, dname] = uiputfile('C:\Stage2016_Thomas\data_plos\slabs\images\*.txt');
colnames = cellstr(num2str(obj.model.PolygonArray.angleList'));
tab = Table.create(obj.model.PolygonArray.signatures, ...
                    'rowNames', obj.model.nameList, ...
                    'colNames', colnames');
write(tab, fullfile(dname, fileName));
msgbox('success');
end