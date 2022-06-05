
% translate mat files(multiple selection support)

% ※ Precautions ※
% delete old version paths if you added old versions

clear all;
format compact;
%% =============== you can use options =================
%% you can add character string behind the file name.
% ----------------------------------
% |  example                        |
% | load file name = AAA            |
% | text_added = BB                 |
% | output file name = AAABB        |
% ----------------------------------
% if you add nothing
text_added = [];
% text_added = '_pre';
% text_added = '_short';




%% select the CSV file(one or more)
% keep Ctrl key pressed if you select some files
[filename, filepath] = uigetfile( {'*.csv'}, ...
    'select the CSV files','MultiSelect','on');

%% check the number of files
% filename's data class is char if number is one
% filename's data class is cell if number is some
if ischar(filename)
    file_Length = 1;
else
    file_Length = length(filename);
end

%% if you select one file
if file_Length == 1
    fprintf('load %s\n',extractBefore(filename,'.'));
    csv2arff_reader_0001(filename,filepath,text_added);
end

%% if you select some files
if file_Length > 1
% translate filename from cell class to char class
filename1 = filename;
for n=1:file_Length
    filename = cell2mat(filename1(n));
    fprintf('[%d / %d] load %s\n',n,file_Length,extractBefore(filename,'.'));
    csv2arff_reader_0001(filename,filepath,text_added);
end
end

%% notify ends
fprintf("complete all\n");
clear file_Length filename filepath n text_added dir_eeg2mat BrainVisionReader mat_file_version filename1
