% Get all PDF files in the current folder
path = 'dataset/sample/table/';
files = dir(strcat(path, '*.png'));
% Loop through each
for id = 1:length(files)
    % Get the file name (minus the extension)
    [~, f] = fileparts(files(id).name);
          % If numeric, rename
    movefile(strcat(path, files(id).name), strcat(path, sprintf('%03d.png', id)));
end