function loadMacro(obj)
%LOADMACRO Load a log file and uses it as a macro to automatically execute processes
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% open the file selection prompt and let the user select the file he wants
% to use as a macro
[fileName, dname] = uigetfile('*.txt');

if fileName == 0
    return;
end

% read the content of the selected file
fileID = fopen(fullfile(dname, fileName), 'r');

% get the first line of the file
tline = fgets(fileID);

while ischar(tline)
    % while the end of the file has'nt benn reached
    % memory allocation
    params = {};
    
    % delete the space created at the end of the line
    tline = tline(1:end-1);
    
    % separate the name of the used function and its parameters
    split1 = strsplit(tline, ' : ');
    if length(split1) > 1
        % if the function was called using parameters
        % separate each parameters
        split2 = strsplit(split1{2}, ' ; ');
        for i = 1:length(split2)
            % for each parameters
            % separate the name of the parameter and its value
            split3 = strsplit(split2{i}, ' = ');
            
            % save the value
            params{end+1} = split3{2};
        end
    end
    % create a function handle using the name of the function
    fh = str2func(split1{1});
    
    % call the function with all the needed parameters
    fh(obj, params{:});
    
    % get the next line of the file
    tline = fgets(fileID);
end

% close the file
fclose(fileID);
end