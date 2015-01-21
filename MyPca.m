function [Proj_tarinData,Labels,firstEig_vec,meanX] = MyPca(K_pca,trainData)
%Pca_recognition Summary of this function goes here
% we need to match the normalized images in the training set to the 
% images in test set.
%clear all; close all; clc;


file = dir(trainData);  
% file is a Lx1 structure with 4 fields as: name,date,byte,isdir of all L files present in the directory 'data_train'

Labels = [];            %to define labels of each image to use for regognition part

%each row of X represents one image in training set
X = [];

%to get training images and have them in matrix X,TO store the name of each
%image in label
for i = 1:length(file)
    if (isempty(strfind(file(i).name, '.png'))) == 0 || (isempty(strfind(file(i).name, '.jpg'))) == 0
        imageName = fullfile(trainData,file(i).name);
        imageread = imread(imageName);
        X = [X; imageread(:)'];
        Labels = [Labels; cellstr(file(i).name)]; 
    end
end

%caluculating the mean and removing it from the images
meanX=double(mean(X));
%covariance matrix
for i = 1:size(X,1)
    Xmean(i,:)=double(X(i,:))-meanX;
end
 %Normalizing covariance
sigma=(1/size(X,1))*Xmean*Xmean';

%eigenvectors eigenvalues
[eig_vec, eig_val] = eig(sigma);

%covariance matrix of eigen values
eig_vec = Xmean' * eig_vec;

%normalizing the covariance matrix before projection
for i = 1:size(eig_vec, 2)
    eig_vec(:, i) = eig_vec(:, i)/norm(eig_vec(:, i));
end

%projection  matrix using top k principal components
firstEig_vec = eig_vec(:, 1:K_pca);
%creating the training datbase
Proj_tarinData = Xmean* firstEig_vec;

