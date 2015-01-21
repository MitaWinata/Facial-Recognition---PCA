function [  ] = affine_transform( fileName, facesPath, affine, resultPath )
%  datapath = 'C:\Users\User\Documents\Master_VIBOT\Semester1\Applied maths\PCA\faces_data';
%  selected_img = strcat(datapath,'\',fileName);
%  I = imread(selected_img);
%  I  = rgb2gray(I );
%  

imagePath = fullfile(facesPath ,fileName);
I = imread(imagePath);
I = rgb2gray(I);


% Ab - trasformation that aligns features of image F_i with F_predetermined
% A = [a11 a12 ; a21; a22 ]
% b = [b1 b2]
% affine = [c1;c2] = [ a11 a21; a12 a22; b1 b2] 
% c1 = [a11; a12; b1]
% c2 = [a21; a22; b2]
A = affine([1, 3; 2 4]);
b = affine([5; 6]);

result = zeros(64, 64);
for x = 1:64
    for y = 1:64
        %calculate the inverse of the affine transformation
        %int32(A \ ([x ; y] - b))
        out_pixel = int32(A \ ([x ; y] - b));        
        if (out_pixel(1) <= 0 || out_pixel(1) >= 240 || out_pixel(2) >= 320 || out_pixel(2) <= 0) 
            pixel_value = 254;
        else
            pixel_value = I(out_pixel(2), out_pixel(1));
        end        
        result(x, y) = uint8(pixel_value);
    end
end
result = mat2gray(result');

testPath = fullfile(resultPath,fileName);
imwrite(result, testPath);

end

