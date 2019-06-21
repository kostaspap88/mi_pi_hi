function p_estimated = binomial_parameter_estimation(traceset, no_trials)

for i=1:length(traceset)
    p_estimated(i) = mean(traceset{i}/no_trials);
end

end