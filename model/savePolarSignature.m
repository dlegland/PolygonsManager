function savePolarSignature(obj)
%SAVEPOLARSIGNATURE  Saves the current polar signature in a text file
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% open the file save prompt and let the user select the name of the file in 
% which the factor Table will be saved
[fileName, dname] = uiputfile('*.txt');

if fileName ~= 0
    % if the user did select a folder
    % get the list of angles that were used while computing the polar
    % signature
    colnames = cellstr(num2str(obj.model.PolygonArray.angleList'));
    
    % create he Table containing the polar signatures and save it in the
    % previously selected file
    tab = Table.create(obj.model.PolygonArray.signatures, ...
                        'rowNames', obj.model.nameList, ...
                        'colNames', colnames');
    write(tab, fullfile(dname, fileName));
    
    % display a message to inform the user that the save worked
    msgbox('success');
end
end