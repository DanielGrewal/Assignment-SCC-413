data = dataset('File', 'source2.csv', 'Delimiter', ','); 
data = set(data, 'VarNames', {'Caller', 'Receiver', 'Duration', 'ToD', 'Days', 'Sex', 'Age', 'Ethnic', 'Occupation', 'Country', 'Lat', 'Long', 'Distance'});

indices = find(data.Duration < 0);
data(indices,:) = [];
data.Duration = data.Duration / 60;

origData = double(data);
stat_data = grpstats(data, {'Caller'}, {'min', 'mean', 'max', 'sum'});
stat_data_2 = grpstats(data, {'Receiver'}, {'min', 'mean', 'max', 'sum'});


data_A = double(stat_data);
data_B = double(stat_data_2);
data_C = [data_A,data_B];
data_PF = data_C; % dataset for popular female

pf_ind = find(data_PF(:,2) == 1); % find all males
data_PF(pf_ind,:) = []; % delete all males from set


% popular female vs unpopular female
for i = 1:size(data_PF,1)
    if data_PF(i,6) >= 50
       popular_f{i} = 'Popular Female';
    elseif data_PF(i,6) < 50  
        popular_f{i} = 'Unpopular Female';
    end
end
popular_fem = popular_fem'; % class labels for popular vs unpopular females




