% Load Data
RawData = table2struct(readtable('framingham.csv'));

%Scrub Data
ScrubData = rmfield(RawData, "education");
[StructRow, StructCol] = size(ScrubData);
MatData = cell2mat(struct2cell(ScrubData))';
for i = 1:StructRow
    MatData(any(isnan(MatData),i),:) = [];
end
TableData = array2table(MatData,'VariableNames',{'Gender', 'Age', 'Smoker', 'CigsPerDay', 'BPMeds', 'PrevalentStroke', 'PrevalentHypertension', 'Diabetes', 'TotalCholesterol', 'SystolicBP', 'DiastolicBP', 'BMI', 'HeartRate', 'Glucose', 'TenYearCHD'});

% Plotting Data for Visual Inspection
figure(1)
subplot(2,1,1);
histogram(MatData(:,1))
title('Distribution of Gender')
xlabel('Gender')
ylabel('Number of Individuals')
set(gca,'xtick',[0,1],'xticklabel',{'Male';'Female'})
subplot(2,1,2);
histogram(MatData(:,2))
title('Distribution of Ages')
xlabel('Ages')
ylabel('Number of Individuals')
figure(2)
subplot(2,1,1);
histogram(MatData(:,3))
title('Distribution of Smokers')
ylabel('Number of Individuals')
set(gca,'xtick',[0,1],'xticklabel',{'Non-Smokers';'Smokers'})
subplot(2,1,2);
histogram(MatData(:,4))
title('Distribution of Cigarettes Smoked per Day')
xlabel('Cigarettes Smoked per Day')
ylabel('Number of Individuals')
figure(3)
subplot(2,1,1);
histogram(MatData(:,5))
title('Distribution of People on Blood Pressure Medication')
ylabel('Number of Individuals')
set(gca,'xtick',[0,1],'xticklabel',{'No Medication';'On Medication'})
subplot(2,1,2);
histogram(MatData(:,6))
title('Distribution of People with History of Strokes')
ylabel('Number of Individuals')
set(gca,'xtick',[0,1],'xticklabel',{'No History of Strokes';'History of Strokes'})
figure(4)
subplot(2,1,1);
histogram(MatData(:,7))
title('Distribution of People Diagnosed with Hypertension')
ylabel('Number of Individuals')
set(gca,'xtick',[0,1],'xticklabel',{'No Hypertension';'Diagnosed with Hypertension'})
subplot(2,1,2);
histogram(MatData(:,8))
title('Distribution of People Diagnosed with Diabetes')
ylabel('Number of Individuals')
set(gca,'xtick',[0,1],'xticklabel',{'No Diabetes';'Diagnosed with Diabetes'})
figure(5)
subplot(2,1,1);
histogram(MatData(:,9))
title('Distribution of Total Blood Cholesterol Levels')
xlabel('Blood Cholesterol Level')
ylabel('Number of Individuals')
subplot(2,1,2);
histogram(MatData(:,10))
title('Distribution of Systolic Blood Pressure')
xlabel('Systolic Blood Pressure')
ylabel('Number of Individuals')
figure(6)
subplot(2,1,1)
histogram(MatData(:,11))
title('Distribution of Diabolic Blood Pressure')
xlabel('Diabolic Blood Pressure')
ylabel('Number of Individuals')
subplot(2,1,2);
histogram(MatData(:,12))
title('Distribution of BMI')
xlabel('BMI')
ylabel('Number of Individuals')
figure(7)
subplot(2,1,1);
histogram(MatData(:,13))
title('Distribution of Resting Heart Rate')
xlabel('Resting Heart Rate')
ylabel('Number of Individuals')
subplot(2,1,2);
histogram(MatData(:,14))
title('Distribution of Blood Glucose Level')
xlabel('Blood Glucose Level')
ylabel('Number of Individuals')
figure(8)
histogram(MatData(:,15))
title('Distribution of People Diagnosed with Coronary Heart Disease in the past 10 years')
ylabel('Number of Individuals')
set(gca,'xtick',[0,1],'xticklabel',{'No Coronary Heart Disease';'Diagnosed with Coronary Heart Dosease'})

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

% Regression Coefficients
EvaluationTable = table(CoeffValuesScrubData1', PercentageMat', 'RowNames', {'Gender', 'Age', 'CigsPerDay', 'TotalCholesterol', 'SystolicBP', 'Glucose'} ,'VariableNames', {'Coefficient Values', 'Percentage Values (%)'})

% Machine Learning
[MatDataRows MatDataCols] = size(ScrubData1);
  P = 0.90;
  idx = randperm(MatDataRows);
  TrainingData = ScrubData1(idx(1:round(P*MatDataRows)),:);
  TestData = array2table(ScrubData1(idx(round(P*MatDataRows)+1:end),:),'VariableNames', {'Gender', 'Age', 'CigsPerDay', 'TotalCholesterol', 'SystolicBP', 'Glucose', 'TenYearCHD'});

% Logistic regression using all features
Fig1 = openfig('LR1_Mat1.fig');
F = figure;
set(Fig1.Children,'Parent',F)
Fig2 = openfig('LR1_Mat2.fig');
F = figure;
set(Fig2.Children,'Parent',F)
Image1 = imread('LR1_ROC.png');
image(Image1);

% Logistic regression using selective features
Fig4 = openfig('LR2_Mat1.fig');
F = figure;
set(Fig4.Children,'Parent',F)
Fig5 = openfig('LR2_Mat2.fig');
F = figure;
set(Fig5.Children,'Parent',F)
Image2 = imread('LR2_ROC.png');
image(Image2);

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

  ResultMat = [Correct, T1P1, T0P0, LengthResultsData - Correct, T0P1, T1P0];
  PercentageResultMat = ResultMat/LengthResultsData*100;
  ResultTable = table(ResultMat', PercentageResultMat', 'RowNames', {'Correct', 'Predicted CHD', 'Predicted NO CHD', 'Incorrect', 'False Positive', 'False Negative'}, 'VariableNames', {'Number of Predictions', 'Pecentage Values (%)'})
