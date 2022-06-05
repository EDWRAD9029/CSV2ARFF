function [] = csv2arff_reader_0001(filename,filepath,text_added)
% this traslate the CSV file to the ARFF file
% this need CSV files
% this need the variable made by csv2arff.m
%% load csv file
opts = detectImportOptions(strcat(filepath,filename));
data = readtable(strcat(filepath,filename));

%% check variable type
%  CSV  | ARFF
% ======|=======
% int   | numeric
% float | REAL

labels_type = cell(length(opts.VariableNames),1);
for i=1:length(opts.VariableNames)
    tmp = data.(opts.VariableNames{i});
    % 数値か文字か
    if strcmp(opts.VariableTypes(i),'double')
        labels_type{i}="num";
    elseif strcmp(opts.VariableTypes(i),'char')
        labels_type{i}="str";
    end
    
    % より詳しく
    if labels_type{i}=="num"
        tmp_str = num2str(tmp(1));
        % 整数か実数か
        if contains(tmp_str,'.')
            labels_type{i}="REAL";
        else
            labels_type{i}="numeric";
        end
    else
        % 文字はクラス分類と想定する
        class = string(categories(categorical(tmp)));
        class_all = strjoin(class,',');
        labels_type{i} = strcat('{',class_all,'}');
    end

    
end

%% make the output file name
filename = extractBefore(filename,'.');
filename_output = strcat(filepath,filename,text_added,'.arff');

%% 現在のパスを確認
dir_now = dir;
dir_now = dir_now(1).folder;

%% データがあるフォルダに移動
cd(filepath);

%% make the ARFF file
fileID = fopen(filename_output,'w');
% prefix
fprintf(fileID,'%% このファイルはcsv2arff.mで作成されています\n');
fprintf(fileID,'%% \n');
fprintf(fileID,'%% csv2arff\n');
fprintf(fileID,'%%   version : 1.0\n');
fprintf(fileID,'%%   author : Nomura\n');
fprintf(fileID,'%% 詳細はreadme.txtへ\n');
fprintf(fileID,'\n');

% config
fprintf(fileID,'@RELATION %s\n',filename);
for i=1:length(opts.VariableNames)
    fprintf(fileID,'@ATTRIBUTE %s %s\n',opts.VariableNames{i},labels_type{i});
end
fprintf(fileID,'\n');

% data
fprintf(fileID,'@DATA\n');
data_len = length(data.(opts.VariableNames{1}));
for i=1:data_len
    tmp = data(i,:);
    tmp1 = tmp.(opts.VariableNames{1});
    if strcmp(opts.VariableTypes(1),'double')
        tmp_str = num2str(tmp1);
    else
        tmp_str = tmp1;
    end
    
    for j=2:length(opts.VariableNames)
        tmp1 = tmp.(opts.VariableNames{j});
        if strcmp(opts.VariableTypes(j),'double')
            tmp_str = strcat(tmp_str,',',num2str(tmp1));
        else
            tmp_str = strcat(tmp_str,',',tmp1);
        end
    end
    
    if ischar(tmp_str)
        fprintf(fileID,'%s\n',tmp_str);
    else
        fprintf(fileID,'%s\n',tmp_str{1});
    end
end
fclose(fileID);

%% 元のフォルダに戻る
cd(dir_now);

%% 終了を知らせる
fprintf('complete %s\n',filename_output);

end