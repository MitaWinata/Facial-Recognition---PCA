%get similar faces and sex for given image
clear all , clc, close all;

%Get the path where the features are and where the images will be stored
% traindata = uigetdir('C:\','Select path of traing data file');
% testdata = uigetdir('C:\','Select path of test  data file');
traindata='D:\richa docs\course material\AM\Desire\PCA\train_images'
testdata='D:\richa docs\course material\AM\Desire\PCA\test_images'
k_pca = 20;
similar_images = 4;
testfile = fullfile(testdata,'Pramita_5.jpg');
testImage = imread(testfile);
accuracies = [];

accuracies = face_recognition_accuracy(k_pca,testImage,similar_images,testdata,traindata);


disp('Accuracy of the algo in training data and test data is::')
disp(mean(accuracies));

