function   [windowed_data]=runing_windows(data,window_size, step_size)

%This function gets a vector of data and returns a matrix of
%N X (window_size). data is a 1 X N vector. The step size betwin the
%windows is step_size

%        Writen by Sigal Saar January 13 2006
size_data=size(data,2);

start_window=[1:floor(step_size):(size_data-window_size+1)]';
end_window=[window_size:floor(step_size):size_data]';
%adding zeros or sample point to make comensation for uneven number of
%lines watch out from doing ver!!!
if (step_size-floor(step_size))~=0
    %step_size=floor(step_size);
    
    add_to_step=round(1/(step_size-floor(step_size)));
    
    n_data=zeros(1,length(start_window));
    
    
    add_to_window=[0:((size_data)/add_to_step)]'*ones(1,add_to_step+1);
    
    add_to_window=add_to_window';
    add_to_window=add_to_window(1:end)';
    %add_to_window=[0 ; add_to_window];
    
    start_window=start_window+add_to_window(1:length(start_window));
    end_window=end_window+add_to_window(1:length(start_window));
    
    
    good_index=find(end_window<size_data);
    
    start_window=start_window(good_index);
    end_window=end_window(good_index);
   

    n_data=n_data(1:length(end_window));
   n_data( add_to_step+1:add_to_step+1:end)=data(end_window(add_to_step+1:add_to_step+1:end)+1);
   if n_data(end)>size_data
       n_data(end)=0;
   end
end

char_string_dot=char(':'*ones(length(end_window),1));
char_string_coma=char(';'*ones(length(end_window),1));
starting_string=['[' ; char(' '*ones(length(end_window)-1,1))];
ending_string=[char(' '*ones(length(end_window)-1,1)) ; ']' ];

eval_matrix=[starting_string num2str(start_window) char_string_dot num2str(end_window) char_string_coma ending_string]';

matrix_is=eval( eval_matrix(1:size(eval_matrix,1)*size(eval_matrix,2)));

windowed_data=data([ matrix_is]);
if (step_size-floor(step_size))~=0
      windowed_data=[windowed_data n_data'];
end

clear matrix_is*
