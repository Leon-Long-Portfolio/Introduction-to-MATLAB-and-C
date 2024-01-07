# Data Exploration and Analysis
The objective is to clean, analyze, and draw inferences from the data, using MATLAB's Live Editor for documentation, including decision-making processes, code, and outputs like plots and charts. The analysis aims to identify correlations and patterns, requiring creative and statistical approaches to test hypotheses. Groups are tasked with submitting a comprehensive PDF report, competing in terms of creativity and analytical depth, while exploring advanced programming techniques for efficient data handling.
### Data Importation
This section details the process of importing data for the project. It emphasizes the use of MATLAB functions to read data from Excel files into structured arrays, and the importance of placing datasets in the correct path for successful importation.
```
Fall = table2struct(readtable('F20HW4FallData.xlsx', 'PreserveVariableNames', true));
Spring = table2struct(readtable('F20HW4SpringData.xlsx', 'PreserveVariableNames', true));

```
### Data Scrubbing
Discusses the strategies for cleaning and preprocessing the data. This includes handling NaN values, deciding on which fields to keep or remove, and the concept of feature engineering. The section underscores the importance of documenting each step of the data cleaning process.
```
Fall = xlsread('F20HW4FallData.xlsx');
Spring = xlsread('F20HW4SpringData.xlsx');

% Converts NaN to 0
Fall(isnan(Fall)) = 0;
Spring(isnan(Spring)) = 0;
```
### Exploratory Data Analysis (EDA)
This part focuses on analyzing the datasets through various visualizations, such as histograms for exam scores. It highlights the importance of exploring different aspects of the data to understand underlying patterns and distributions.
```
% Calculating final grade into FallVec and SpringVec
[r, ~] = size(Fall);
FallVec = zeros(r,1);
for i = 1:r
    FallVec(i) = 33*(Fall(i,1)/100) + 33*(Fall(i,2)/100) + 33*(Fall(i,3)/100);
end
FallVec = FallVec';

[r, ~] = size(Spring);
SpringVec = zeros(r,1);
for i = 1:r
    SpringVec(i) = 33*(Spring(i,1)/100) + 33*(Spring(i,2)/100) + 33*(Spring(i,3)/100);
end
SpringVec = SpringVec';

% Plotting Histogram for Fall Data
histogram(FallVec, 50)
title('Fall Semester Final Grades')
xlabel('Final Grade (%)')
ylabel('No. of Students')
legend('Histogram for Fall Data')

% Plotting Histogram for Spring Data
histogram(SpringVec, 50)
title('Spring Semester Final Grades')
xlabel('Final Grade (%)')
ylabel('No. of Students')
legend('Histogram for Spring Data')
```
