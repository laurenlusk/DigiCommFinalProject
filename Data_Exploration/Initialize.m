function r = Initialize(filename)

    filePath = fullfile(pwd,"..","Datasets",strcat(filename,".mat"));

    % load received matrix of samples 'r'
    load(filePath);
    r = r.';

end
