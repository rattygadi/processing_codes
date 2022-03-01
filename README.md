# processing_codes
Please run the model_data_variable_extractor.m MATLAB file once you download the excel data. This file will process
all the data into scenario based and creates a structure called 'data' in 10 year bins which is saved in mat file
in the Dataset subdirectory that is created. Once, this is created, one needs to run
average_scenario_extractor after copying this file into that directory 
which will look for the highest GDP scenario among the scenarios in 10 year bins and plots it.
