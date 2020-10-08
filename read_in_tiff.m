function [Y] = read_in_tiff(filename)

tif_file = filename
tiff_info = imfinfo(tif_file);
tiff_stack = imread(tif_file,1);
size(tiff_info,1)
for ii=2:size(tiff_info,1)
    temp_tiff = imread(tif_file,ii);
    tiff_stack = cat(3, tiff_stack, temp_tiff);
end 
Y = tiff_stack;