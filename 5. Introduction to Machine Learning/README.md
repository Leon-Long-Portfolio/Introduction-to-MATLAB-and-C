# Introduction to Machine Learning
The project for the Machine Learning course at Boston University primarily focuses on the practical application of machine learning techniques to solve real-world societal problems. Students are required to use MATLAB's Machine Learning Toolbox for analyzing large datasets, with a minimum of 20,000 data points, to derive meaningful insights. A significant aspect of the project is to ensure that the chosen problems and solutions have a positive impact on society. Furthermore, the project emphasizes the importance of ethical considerations in AI development, particularly in understanding and addressing biases in datasets and algorithms. This comprehensive approach aims to equip students with both technical skills in machine learning and a deep awareness of the societal and ethical implications of their work in AI.
### Data Manipulation 
Focuses on the process of cleaning and preparing the data for analysis. It involves removing the 'education' field, handling NaN values, and converting the data into a matrix format. The section explains how the data is converted back into a table with renamed variables for clarity.
Visual Data Inspection
```
%Scrub Data
ScrubData = rmfield(RawData, "education");
[StructRow, StructCol] = size(ScrubData);
MatData = cell2mat(struct2cell(ScrubData))';
for i = 1:StructRow
    MatData(any(isnan(MatData),i),:) = [];
end
TableData = array2table(MatData,'VariableNames',{'Gender', 'Age', 'Smoker', 'CigsPerDay', 'BPMeds', 'PrevalentStroke', 'PrevalentHypertension', 'Diabetes', 'TotalCholesterol', 'SystolicBP', 'DiastolicBP', 'BMI', 'HeartRate', 'Glucose', 'TenYearCHD'});
```
### Correlation Analysis
This part covers the calculation of correlation coefficients among different variables and the plotting of these correlations as a heatmap. It provides insights into how various health indicators are interrelated.
```
% Plotting Heatmap
[MatDataRows, MatDataCols] = size(MatData);
CorrMatData = corr(MatData);
HeatmapMatData = heatmap(CorrMatData);
FieldNames = fieldnames(TableData);
for k = 1:MatDataCols
    HeatmapMatDataLabels(k) = FieldNames(k);
end 
HeatmapMatData.XDisplayLabels = HeatmapMatDataLabels;
HeatmapMatData.YDisplayLabels = HeatmapMatDataLabels;
```
<p align="center">
  <img src="https://github.com/Leon-Long-Portfolio/MATLAB-Programming-EK125/blob/main/Introduction%20to%20Machine%20Learning/images/Screenshot%202024-01-07%20at%2014.45.55.png" width="500">
</p>

### Significant Variable Identification
Involves identifying significant variables using logistic regression and p-values. It includes a process of selecting variables with p-values less than 0.05 and creating a new table with these significant variables.
```
% Plotting Heatmap to Visualize Correlation between significant Variables
Y = categorical(TableData.TenYearCHD);
  X = [TableData.Gender, TableData.Age, TableData.Smoker, TableData.CigsPerDay, TableData.BPMeds, TableData.PrevalentStroke, TableData.PrevalentHypertension, TableData.Diabetes, TableData.TotalCholesterol, TableData.SystolicBP, TableData.DiastolicBP, TableData.BMI, TableData.HeartRate, TableData.Glucose];
  [CoeffValues,dev,stats] = mnrfit(X,Y,'model','hierarchical');
  PValues = stats.p;
  counter = 1;

  for j = 1:14
      if PValues(j+1) < 0.05
        ScrubData1(:,counter) = MatData(:,j);
        CoeffValuesScrubData1(counter) = abs(CoeffValues(j+1));
        counter = counter + 1;
      end
  end
  ScrubData1(:,counter) = MatData(:,MatDataCols);
  FinalTableData = array2table(ScrubData1,'VariableNames', {'Gender', 'Age', 'CigsPerDay', 'TotalCholesterol', 'SystolicBP', 'Glucose', 'TenYearCHD'});
CorrScrubData2 = corr(ScrubData1);
figure(9)
HeatmapScrubData2 = heatmap(CorrScrubData2);
Field_Names = fieldnames(FinalTableData);
for k = 1:counter
    HeatmapScrubData2Labels(k) = FieldNames(k);
end
HeatmapScrubData2.XDisplayLabels = HeatmapScrubData2Labels;
HeatmapScrubData2.YDisplayLabels = HeatmapScrubData2Labels;
HeatmapScrubData2Labels2 = HeatmapScrubData2Labels;
HeatmapScrubData2Labels2(counter) = [];
for r = 1:counter-1
    PercentageMat(r) = (exp(CoeffValuesScrubData1(r)) - 1) * 100;
end
```
<p align="center">
  <img src="https://github.com/Leon-Long-Portfolio/MATLAB-Programming-EK125/blob/main/Introduction%20to%20Machine%20Learning/images/Screenshot%202024-01-07%20at%2014.46.04.png" width="500">
</p>

### Regression Coefficients and Evaluation
Discusses the calculation of regression coefficients and their conversion into percentage values. This section also includes the creation of an evaluation table that lists these values for each significant variable.
```
% Regression Coefficients
EvaluationTable = table(CoeffValuesScrubData1', PercentageMat', 'RowNames', {'Gender', 'Age', 'CigsPerDay', 'TotalCholesterol', 'SystolicBP', 'Glucose'} ,'VariableNames', {'Coefficient Values', 'Percentage Values (%)'})
```
### Machine Learning Model Training
Describes the process of dividing the data into training and test sets for building a machine learning model. It also touches on the logistic regression models built using all features and selective features.
```
% Machine Learning
[MatDataRows MatDataCols] = size(ScrubData1);
  P = 0.90;
  idx = randperm(MatDataRows);
  TrainingData = ScrubData1(idx(1:round(P*MatDataRows)),:);
  TestData = array2table(ScrubData1(idx(round(P*MatDataRows)+1:end),:),'VariableNames', {'Gender', 'Age', 'CigsPerDay', 'TotalCholesterol', 'SystolicBP', 'Glucose', 'TenYearCHD'});
```
Logistic Regression using All Features
<p align="center">
  <img src="https://github.com/Leon-Long-Portfolio/MATLAB-Programming-EK125/blob/main/Introduction%20to%20Machine%20Learning/images/Screenshot%202024-01-07%20at%2014.46.29.png" width="490">
  <img src="https://github.com/Leon-Long-Portfolio/MATLAB-Programming-EK125/blob/main/Introduction%20to%20Machine%20Learning/images/Screenshot%202024-01-07%20at%2014.46.35.png" width="500">
</p>
Logistic Regression using Selective Features
<p align="center">
  <img src="https://github.com/Leon-Long-Portfolio/MATLAB-Programming-EK125/blob/main/Introduction%20to%20Machine%20Learning/images/Screenshot%202024-01-07%20at%2014.46.46.png" width="500">
  <img src="https://github.com/Leon-Long-Portfolio/MATLAB-Programming-EK125/blob/main/Introduction%20to%20Machine%20Learning/images/Screenshot%202024-01-07%20at%2014.46.57.png" width="500">
</p>

### Model Evaluation and Testing
Focuses on testing the machine learning model with the test data set. It includes the evaluation of model performance through metrics like the number of correct predictions, false positives, and false negatives, and presents these results in a table format.
```
% Model Testing
ResultsData = trainedModel.predictFcn(TestData);
  Correct = 0;
  T1P1 = 0;
  T0P0 = 0;
  T1P0 = 0;
  T0P1 = 0;
  LengthResultsData = length(ResultsData);
  for a = 1:LengthResultsData
      if ResultsData(a) == 0 && TestData.TenYearCHD(a) == 0
          T0P0 = T0P0 + 1;
          Correct = Correct + 1;
      elseif Results_Data(a) == 1 && TestData.TenYearCHD(a) == 0
          T0P1 = T0P1 + 1;
      elseif Results_Data(a) == 0 && TestData.TenYearCHD(a) == 1
          T1P0 = T1P0 + 1;
      elseif ResultsData(a) == 1 && TestData.TenYearCHD(a) == 1
          T1P1 = T1P1 + 1;
          Correct = Correct + 1;
      end
  end
```
<p align="center">
  <img src="https://github.com/Leon-Long-Portfolio/MATLAB-Programming-EK125/blob/main/Introduction%20to%20Machine%20Learning/images/Screenshot%202024-01-07%20at%2014.47.10.png" width="500">
</p>

### Visualization of Logistic Regression Results
This section describes the visualization of logistic regression results using figures and ROC (Receiver Operating Characteristic) curves. It includes opening and displaying figures saved from previous analyses.
```
ResultMat = [Correct, T1P1, T0P0, LengthResultsData - Correct, T0P1, T1P0];
  PercentageResultMat = ResultMat/LengthResultsData*100;
  ResultTable = table(ResultMat', PercentageResultMat', 'RowNames', {'Correct', 'Predicted CHD', 'Predicted NO CHD', 'Incorrect', 'False Positive', 'False Negative'}, 'VariableNames', {'Number of Predictions', 'Pecentage Values (%)'})
```
Logistic Regression using All Features vs Selective Features
<p align="center">
  <img src="https://github.com/Leon-Long-Portfolio/MATLAB-Programming-EK125/blob/main/Introduction%20to%20Machine%20Learning/images/Screenshot%202024-01-07%20at%2014.46.41.png" width="491">
  <img src="https://github.com/Leon-Long-Portfolio/MATLAB-Programming-EK125/blob/main/Introduction%20to%20Machine%20Learning/images/Screenshot%202024-01-07%20at%2014.47.02.png" width="500">
</p>

### Please read the report PDF in this repository for more!
