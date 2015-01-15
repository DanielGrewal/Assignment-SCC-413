% load data into Matlab and assign to variable object 'calls_dataset'
%calls_data = load('source2.csv');
calls_dataset = dataset('File', 'source2.csv', 'Delimiter', ','); 
calls_dataset = set(calls_dataset, 'VarNames', {'Caller', 'Receiver', 'Duration', 'ToD', 'Days', 'Sex', 'Age', 'Ethnic', 'Occupation', 'Country', 'Lat', 'Long', 'Distance'});

%-------------------------------------------------------------------------------------------------------------------------------------------------------
% exploratory analysis
%-------------------------------------------------------------------------------------------------------------------------------------------------------

% categorise variables
caller_cat = [0:399]; % create category labels
caller_cat = strtrim(cellstr(num2str(caller_cat'))'); % convert to strings
calls_dataset.CallerCat = ordinal(calls_dataset.Caller, caller_cat); % create new variable of categories

receiver_cat = 1:size(unique(calls_dataset.Receiver));
receiver_cat = strtrim(cellstr(num2str(receiver_cat'))');
calls_dataset.ReceiverCat = ordinal(calls_dataset.Receiver, receiver_cat);

tod_cat = 1:size(unique(calls_dataset.ToD));
tod_cat = strtrim(cellstr(num2str(tod_cat'))');
calls_dataset.ToDCat = ordinal(calls_dataset.ToD, {'Early Morning', 'Morning', 'Mid-Day', 'Evening', 'Late Evening'},...
    [], [0,7,12,17,21, 25]);

days_cat = 1:size(unique(calls_dataset.Days));
days_cat = strtrim(cellstr(num2str(days_cat'))');
calls_dataset.DaysCat = ordinal(calls_dataset.Days, days_cat);

calls_dataset.SexCat = nominal(calls_dataset.Sex, {'Male', 'Female'});

calls_dataset.AgeCat = ordinal(calls_dataset.Age, {'Child', 'Teenager', 'Young Adult', 'Mature Adult', 'Middle-Aged', 'Senior Citizen'});

% find noise
indices  = find(calls_dataset.Duration <= 0);
% tuples 822, 4221, 6450, 7245 all have negative durations
% delete tuples where there is negtive duration as it is a very
% insignificant proportion
calls_dataset(indices,:) = [];

% convert new duration variable to mins
calls_dataset.DurationMins = calls_dataset.Duration / 60;

% check for missing values
missingV = ismissing(calls_dataset);
missingV = find(missingV > 0);
    
%-------------------------------------------------------------------------------------------------------------------------------------------------------
% looking for variable association
%-------------------------------------------------------------------------------------------------------------------------------------------------------

% correlation between caller and duration
caller_dur_rel = [calls_dataset.Caller(:), calls_dataset.DurationMins];
caller_dur_rel_cor = corrcoef(caller_dur_rel); % no correlation - 0.0129

% correlation between duration and days
dur_days_rel = [calls_dataset.DurationMins(:), calls_dataset.Days(:)];
dur_days_rel_cor = corrcoef(dur_days_rel); % no correlation

% correlation between tod and duration
tod_dur_rel = [calls_dataset.ToD(:), calls_dataset.DurationMins(:)];
tod_dur_rel_cor = corrcoef(tod_dur_rel); % negative correlation -7.1903e-04
tod_dur_plot = scatter(calls_dataset.ToD, calls_dataset.DurationMins);

% correlation between age and duration
age_dur_rel = [calls_dataset.Age(:), calls_dataset.DurationMins(:)];
age_dur_rel_cor = corrcoef(age_dur_rel); % no correlation

% correlation between sex and duration
sex_dur_rel = [calls_dataset.Sex, calls_dataset.DurationMins];
sex_dur_rel_cor = corrcoef(sex_dur_rel); % no correlation

% correlation between country and duration
country_dur_rel = [calls_dataset.Country, calls_dataset.DurationMins];
country_dur_rel_cor = corrcoef(country_dur_rel); % no correlation

%-------------------------------------------------------------------------------------------------------------------------------------------------------
% summary statistics for each variable
%-------------------------------------------------------------------------------------------------------------------------------------------------------

q = 0:0.25:1; % quantiles of data 

%Caller Summary Stats
summary_caller = calls_dataset(:,{'Caller'});
summary_caller = grpstats(summary_caller,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_caller = histfit(calls_dataset.Caller);
qq_caller = probplot('normal', calls_dataset.Caller);
quant_caller = quantile(calls_dataset.Caller,q);
box_caller = boxplot(calls_dataset.Caller);

% Receiver Summary Stats
summary_receiver = calls_dataset(:,{'Receiver'});
summary_receiver = grpstats(summary_receiver,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_receiver = histfit(calls_dataset.Receiver);
qq_receiver = probplot('normal', calls_dataset.Receiver);
quant_receiver = quantile(calls_dataset.Receiver,q);
box_receiver = boxplot(calls_dataset.Receiver);

% Duration Summary Stats
summary_duration = calls_dataset(:,{'Duration'});
summary_duration = grpstats(summary_duration,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_duration = histfit(calls_dataset.Duration);
qq_duration = probplot('normal', calls_dataset.Duration);
quant_duration = quantile(calls_dataset.Duration,q);
box_duration = boxplot(calls_dataset.Duration);

%Time of Day Summary Stats
summary_tod = calls_dataset(:,{'ToD'});
summary_tod = grpstats(summary_tod,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_tod = histfit(calls_dataset.ToD);
qq_tod = probplot('normal', calls_dataset.ToD);
quant_tod = quantile(calls_dataset.ToD,q);
box_tod = boxplot(calls_dataset.ToD);

%Days Summary Stats
summary_days = calls_dataset(:,{'Days'});
summary_days = grpstats(summary_days,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_days = histfit(calls_dataset.Days);
qq_days = probplot('normal', calls_dataset.Days);
quant_days = quantile(calls_dataset.Days,q);
box_days = boxplot(calls_dataset.Days);

% Sex Summary Stats
summary_sex = calls_dataset(:,{'Sex'});
summary_sex = grpstats(summary_sex,[],{'mean', 'median', 'min', 'max', 'mode'});
mean_sex = mean(calls_dataset.Sex);
hist_sex = histfit(calls_dataset.Sex);
qq_sex = probplot('normal', calls_dataset.Sex);
quant_sex = quantile(calls_dataset.Sex,q);
box_sex = boxplot(calls_dataset.Sex);

% age Summary Stats
summary_age= calls_dataset(:,{'Age'});
summary_age = grpstats(summary_age,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_age = histfit(calls_dataset.Age);
qq_age = probplot('normal', calls_dataset.Age);
quant_age = quantile(calls_dataset.Age,q);
box_age = boxplot(calls_dataset.Age);

% Ethnic Summary Stats
summary_ethnic = calls_dataset(:,{'Ethnic'});
summary_ethnic = grpstats(summary_ethnic,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_ethnic = histfit(calls_dataset.Ethnic);
qq_ethnic = histfit(calls_dataset.Ethnic);
quant_ethnic = quantile(calls_dataset.Ethnic,q);
box_ethnic = boxplot(calls_dataset.Ethnic);

% Country Summary Stats
summary_country = calls_dataset(:,{'Country'});
summary_country = grpstats(summary_country,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_country = histfit(calls_dataset.Country);
qq_country = probplot('normal', calls_dataset.Country);
quant_country = quantile(calls_dataset.Country,q);
box_country = boxplot(calls_dataset.Country);

% Occupation Summary Stats
summary_occupation = calls_dataset(:,{'Occupation'});
summary_occupation = grpstats(summary_occupation,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_occupation = histfit(calls_dataset.Occupation);
qq_occupation = probplot('normal', calls_dataset.Occupation);
quant_occupation = quantile(calls_dataset.Occupation,q);
box_occupation = boxplot(calls_dataset.Occupation);

% Latitude Summary Stats
summary_latitude = calls_dataset(:,{'Lat'});
summary_latitude = grpstats(summary_latitude,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_latitude = histfit(calls_dataset.Lat);
qq_latitude = probplot('normal', calls_dataset.Lat);
quant_latitude = quantile(calls_dataset.Lat,q);
box_latitude = boxplot(calls_dataset.Lat);

% Longitude Summary Stats
summary_longitude = calls_dataset(:,{'Long'});
summary_longitude = grpstats(summary_longitude,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_longitude = histfit(calls_dataset.Long);
qq_longitude = probplot('normal', calls_dataset.Long);
quant_longitude = quantile(calls_dataset.Long,q);
box_longitude = boxplot(calls_dataset.Long);

% Distance Sumary Stats
summary_distance = calls_dataset(:,{'Distance'});
summary_longitude = grpstats(summary_longitude,[],{'mean', 'median', 'min', 'max', 'mode'});
hist_distance = histfit(calls_dataset.Distance);
quant_distance = quantile(calls_dataset.Distance,q);
box_distance = boxplot(calls_dataset.Distance);
