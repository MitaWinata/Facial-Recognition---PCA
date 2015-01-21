function [] = image_norm()
%IMAGE_NORM Summary of this function goes here
% we need to compute the
% parameters of an affine transformation that maps them to the predetermined locations in the 64 × 64
% window. Here we describe an iterative algorithm that work well in practice:
%Open a directory that stores the features file
clear all; close all; clc;

%Get the path where the features are and where the images will be stored
% datapath = uigetdir('C:\','Select path of features file');
% datapath3 = uigetdir('C:\','Select path of images file');
% datapath2 = uigetdir('C:\','Select path to store the result file');
datapath = uigetdir('C:\Users\User\Documents\Master_VIBOT\Semester1\Applied maths\PCA\features_data','Select path of features file');
datapath3 = uigetdir('C:\Users\User\Documents\Master_VIBOT\Semester1\Applied maths\PCA\faces_data','Select path of images file');
datapath2 = uigetdir('C:\Users\User\Documents\Master_VIBOT\Semester1\Applied maths\PCA\test_images','Select path to store the result file');

D = dir(datapath);  
% D is a Lx1 structure with 4 fields as: name,date,byte,isdir of all L files present in the directory 'datapath'

% set the predetermine location. We can set it to the feature of first but
% need to rescale it to 64X64
F_predetermined = [13 20;
                  50 20;
                  34 34;
                  16 50;
                  48 50;]';

%1. Use a vector F to store the average locations of each facial feature over all face images; 
%initialize F with the feature locations in the first image F1.
F_average = F_predetermined;

%2. Compute the best transformation that aligns F (i.e., average locations of the features) with predetermined
%positions in the 64 × 64 window. set the predetermined location 
% check the total feature file, in case it is not 5
% it will be used to find the average as well
totalFile = 0;
%totalFeatureFile 
for t=1 :  size(D,1)
    if ( ~isempty(strfind(D(t).name, '.txt')))
        totalFile = totalFile + 1;
    end
end

first_iteration = 0;
j = 0;
threshold = 0.9;
difference = 1;

while(  difference > threshold )
    % while still in thresshold keeps averaging
   temp = 0;
   first_iteration = 0;
   for i=1 :size(D,1) %totalFile
        %get the txt file, which is the feature file
        if ( ~isempty(strfind(D(i).name, '.txt')))
            % Read the data in the feature file for image i, F_i        
            str = strcat(datapath,'\',D(i).name);
            %put each of the value in an array       
            file = textread(str, '%s', 'delimiter', ' ', 'whitespace', '');  
            %store the read file in a matrix
            x1 = str2double( file(1) ); y1 = str2double( file(2) );
            x2 = str2double( file(3) ); y2 = str2double( file(4) );
            x3 = str2double( file(5) ); y3 = str2double( file(6) );
            x4 = str2double( file(7) ); y4 = str2double( file(8) );
            x5 = str2double( file(9) ); y5 = str2double( file(10) );
                
            % Get the best transformation of image F_i with the affine transformation parameter
            % Affine transformation can be defined by six parameters A and b
            %       F_predetermined_i = A*Fi + b       
            % Ab - trasformation that aligns features of image F_i with F_predetermined
            % A = [a11 a12 ; a21; a22 ]
            % b = [b1 b2]
            % P_i c1 = fx , P_i c2 = fy , affine = [c1;c2] 
            % c1 = [a11; a12; b1] , c2 = [a21; a22; b2]
            % P_i * affine = F_i ,  with P_i is
            P_i = [   x1 y1 1; 
                      x2 y2 1;
                      x3 y3 1;
                      x4 y4 1;
                      x5 y5 1;
                  ]';
           
            %Solve the affine transformation with SVD
            %Once the transformation is obtained, we apply it on F_average.
            affine =  F_average * pinv(P_i);
            
            %3. For every face image F_i , compute the best transformation that aligns the facial features of F_i with
            %the average facial feature F_average; called the aligned features F'_i. 
            F_i_aligned = affine * P_i;            
            
            % Noting the aligned features F_average , 
            % we update F_average by setting F_average = F_i_aligned.
           if (  first_iteration == 0  && j == 0)
                F_average = F_i_aligned;
                first_iteration = first_iteration +1;
           end
           
           temp = temp + F_i_aligned;
           
           imgFile = strrep(D(i).name, '.txt', '.jpg');
           affine_transform( imgFile, datapath3, affine, datapath2);

            
        end
    
   end  
    %find difference between current and previous average, if its small stop
    %5. If the error between F_average_t and F_average_t+1 is less than a threshold, then stop; 
    % otherwise, go to step 2.
    difference_matrix = abs( (temp / totalFile) - F_average);
    %maximum value in the difference matrix
    difference = max(difference_matrix(:));
   
    %4. Update F_average by averaging the aligned feature locations F'i for each face image Fi.          
    F_average = temp / totalFile;
    j = j+1;        
end
clear all;

end


