% Collecting Speed Data
Speed_1 = mean(DATA1.speed);
Speed_2 = mean(DATA2.speed);
Speed_3 = mean(DATA3.speed);
Speed_4 = mean(DATA4.speed);
Speed_5 = mean(DATA5.speed);
Speed_6 = mean(DATA6.speed);

% Calculating Average Speed
AvgSpeed = (Speed_1 + Speed_2 + Speed_3 + Speed_4 +  Speed_5 +Speed_6)/6;

% Menu option for displaying average trial speed or input user speed
Choice = menu('Choose a Trial or input your speed! ', 1, 2, 3, 4, 5, 6, 7);

% Switch statements for menu input
switch Choice
    case 1
        disp(Speed_1);
    case 2
        disp(Speed_2);
    case 3
        disp(Speed_3);
    case 4
        disp(Speed_4);
    case 5
        disp(Speed_5);
    case 6
        disp(Speed_6);
    case 7
        Input = input("What is your speed? ");
        % Processing user input
        if Input > 4
            disp('You have a new personal best!')
        else
            disp('Try harder!')
        end
    otherwise
        disp('ERROR!');
end