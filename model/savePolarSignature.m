function savePolarSignature(~,~, obj)
[fileName, dname] = uiputfile('C:\Stage2016_Thomas\data_plos\slabs\images\*.txt');
colnames = cellstr(num2str(obj.model.PolygonArray.angleList'));
tab = Table.create(obj.model.PolygonArray.signatures, ...
                    'rowNames', obj.model.nameList, ...
                    'colNames', colnames');
write(tab, fullfile(dname, fileName));
msgbox('success');
end