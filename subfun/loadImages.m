function [imgStruct] = loadImages()
    %
    % [imgStruct] = loadImages()
    %
    % builds a structure with the images
    %
    % the output of the function is a structure 1 field per image:
    %
    % - imgStruct(imageName).data

    [cfg] = setParameters();

    imgStruct =  struct();

    allImages = bids.internal.file_utils('FPList', cfg.dir.stimuli, ['^.*.tif$']);

    for i = 1:size(allImages, 1)
        thisImage = deblank(allImages(i, :));
        basename = bids.internal.file_utils(thisImage, 'basename');
        imgStruct.(basename).data = imread(thisImage);
    end

end
