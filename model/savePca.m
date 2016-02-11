function savePca(obj, field)
%SAVEFACTORS  Saves the current factors in a text file
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% open the file save prompt and let the user select the name of the file in 
% which the factor Table will be saved
[fileName, dname] = uiputfile('*.txt', 'Save the current factors', [field '.pca']);

if fileName ~= 0
    
    if strcmp(field, 'means')
        write(Table.create(obj.model.pca.(field)), fullfile(dname, fileName));
    else
        % if the user did select a folder
        write(obj.model.pca.(field), fullfile(dname, fileName));
    end
    
    % display a message to inform the user that the save worked
    msgbox('success');
end

end