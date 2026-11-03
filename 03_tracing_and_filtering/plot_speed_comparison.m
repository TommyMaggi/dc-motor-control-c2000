% MATLAB SCRIPT TO PLOT MOTOR SPEED SIGNALS

% --- Configuration ---
mat_file_name = 'matlab.mat'; % The name of your .mat file

% --- 1. Load Data ---
% This script assumes the .mat file is in the same directory as the script
% or in the MATLAB path.
try
    disp(['Loading data from ', mat_file_name, '...']);
    data = load(mat_file_name);
    disp('File loaded successfully.');
catch ME
    % Error handling if the file is not found
    if (strcmp(ME.identifier, 'MATLAB:load:couldNotReadFile'))
        error('The file "%s" was not found. Please make sure it is in the current MATLAB directory.', mat_file_name);
    else
        rethrow(ME); % Rethrow other errors
    end
end

% --- 2. Extract Variables ---
% Extracts the signals and the time vector from the loaded data structure.
% NOTE: Adjust these variable names if they are different in your .mat file.
try
    ref_input = data.ref_input;
    datasheet_params = data.datasheet_parameters;
    estimated_params = data.estimated_parameters;
    
    % Check for a 'time' variable. If it doesn't exist, create a default one.
    if isfield(data, 'time')
        time_vector = data.time;
    else
        disp('Warning: "time" variable not found. Generating a default time vector.');
        % Assumes samples are sequential (1, 2, 3, ...)
        time_vector = 1:length(ref_input); 
    end
catch ME
    error('A required variable was not found in the .mat file. Please check the variable names within the file. Error: %s', ME.message);
end


% --- 3. Plotting ---
% Creates a new figure and plots all three signals on the same axes.
figure;         % Create a new figure window
hold on;        % Hold the plot to overlay multiple lines

plot(time_vector, ref_input, 'k-', 'LineWidth', 2);
plot(time_vector, datasheet_params, 'b--', 'LineWidth', 1.5);
plot(time_vector, estimated_params, 'r-.', 'LineWidth', 1.5);

hold off;       % Release the plot

% --- 4. Formatting ---
% Adds labels, a title, a legend, and a grid for better readability.
title('Comparison of Motor Speed Signals');
xlabel('Time (s)');
ylabel('Speed (rad/sec)');
legend('Reference Input', 'Datasheet Parameters', 'Estimated Parameters', 'Location', 'best');
grid on;        % Add a grid for easier value reading
axis tight;     % Adjust axis limits to fit the data

disp('Plot generated successfully.');

