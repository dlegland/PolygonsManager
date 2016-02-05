function loadMacro(obj)
[fileName, dname] = uigetfile('C:\Stage2016_Thomas\data_plos\slabs\Tests\*.log.txt');

fileID = fopen(fullfile(dname, fileName), 'r');
tline = fgets(fileID);
while ischar(tline)
    params = {};
    tline = tline(1:end-1);
    split1 = strsplit(tline, ' : ');
    if length(split1) > 1
        split2 = strsplit(split1{2}, ' ; ');
        for i = 1:length(split2)
            split3 = strsplit(split2{i}, ' = ');
            params{end+1} = split3{2};
        end
    end
    fh = str2func(split1{1});
    fh(obj, params{:});
    tline = fgets(fileID);
end

fclose(fileID);
end