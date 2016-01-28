function saveFactors(obj)
%SAVEPOLARSIGNATURE  Saves the current factors in a text file
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% open the file save prompt and let the user select the name of the file in 
% which the factor Table will be saved
[fileName, dname] = uiputfile('C:\Stage2016_Thomas\data_plos\slabs\Tests\*.txt', 'Save the current factors', obj.model.factorTable.name);

if fileName ~= 0
    % if the user did select a folder
    write(obj.model.factorTable, fullfile(dname, fileName));
    
    % display a message to inform the user that the save worked
    msgbox('success');
end
end