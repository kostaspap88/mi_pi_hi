function [mu_estimated, sigma_estimated] = normal_parameter_estimation(traceset)

for i=1:length(traceset)
    mu_estimated(i) = mean(traceset{i});
    sigma_estimated(i) = std(traceset{i});
end

end