% Author: Kostas Papagiannopoulos -- kpcrypto.net -- kostaspap88@gmail.com'
% Based on: "Leakage certification revisited: bounding model errors in
% side-channel security evaluations", Bronchain et al., Section 2


% CAROLINE DELETED...GOODBYE CAROLINE
clear all;
close all;


% user input
key_bits = 2;




% MI computation-----------------------------------------------------------

% discrete leakage with true leakage distribution
MI_discrete = compute_mi_discrete(key_bits);


% discrete leakage with sampled leakage distribution 
% number of sampled leakages from the distribution pmf of every set
no_traces = 50;
MI_discrete_sampled = compute_mi_discrete_sampled(key_bits, no_traces);


% continuous leakage with true leakage distribution
[MI_continuous] = compute_mi_continuous(key_bits);


% continuous leakage with sampled leakage distribution 
% number of sampled leakages from the distribution pdf of every set
no_traces = 50;
[MI_continuous_sampled] = compute_mi_continuous_sampled(key_bits, no_traces);





% Note on estimation and testing-------------------------------------------

% Normally, the true distribution of the leakage is unknown.
% Instead, experimental traces are acquired from the device-under-test
% These traces are used to model and test the leakage
% Here, we simulate the experimental traces from statistical distributions
% This must be replaced with real traces for HI and PI to make sense

% trainset is used to estimate the parameters of our assumed model
no_train_traces = 70;
real_traces_trainset_continuous = sca_experiment_continuous(key_bits, no_train_traces);
real_traces_trainset_discrete = sca_experiment_discrete(key_bits, no_train_traces);

% estimate the binomial model parameters using the trainset
no_trials = 20;
[p_estimated] = binomial_parameter_estimation(real_traces_trainset_discrete, no_trials);
% estimate the normal model parameters using the trainset
[mu_estimated, sigma_estimated] = normal_parameter_estimation(real_traces_trainset_continuous);

% testset is used to test our estimated model against real data
no_test_traces = 30;
real_traces_testset_continuous = sca_experiment_continuous(key_bits, no_test_traces);
real_traces_testset_discrete = sca_experiment_discrete(key_bits, no_test_traces);






% HI computation-----------------------------------------------------------

% For HI computation we do not know the true distribution of the dataset
% Instead, we have experimental traces and a model assumption.
% We use the trainset to estimate the parameters of our model.
% Then we validate it against the estimated model itself
% Thus the testset is not used during HI computation. Only the trainset is.


HI_discrete =  compute_hi_discrete(key_bits, p_estimated, no_trials);

no_traces = 50;
HI_discrete_sampled = compute_hi_discrete_sampled(key_bits, no_traces, p_estimated, no_trials);


HI_continuous = compute_hi_continuous(key_bits, mu_estimated, sigma_estimated);

no_traces = 50;
HI_continuous_sampled = compute_hi_continuous_sampled(key_bits, no_traces, mu_estimated, sigma_estimated);





% PI computation-----------------------------------------------------------

% PI can be encountered in practical and theoretical form
% For practical PI computation we do not know the true distribution 
% Instead, we have experimental traces and a model assumption.
% We use the trainset to estimate the parameters of our model.
% Then we validate it against the real testset
% Thus both trainset and testset are used during practical PI computation
% For theoretical PI we know the true distribution so we do not need to
% validate against the real testset (sampled from the device)
% Instead we validate it against the true distribution
% Thus only the trainset is needed for theoretical PI
% Note that the common PI computation usually implies the practical PI.
% Thus we are mostly interested in PI_continuous/discrete_sampled

% theoretical PI discrete
PI_discrete = compute_pi_discrete(key_bits,  p_estimated, no_trials);
% practical PI discrete
PI_discrete_sampled  = compute_pi_discrete_sampled(key_bits,  p_estimated, no_trials, real_traces_testset_discrete);

% theoretical PI continuous
PI_continuous = compute_pi_continuous(key_bits,  mu_estimated, sigma_estimated);
% practical PI continuous
PI_continuous_sampled = compute_pi_continuous_sampled(key_bits,  mu_estimated, sigma_estimated, real_traces_testset_continuous);





