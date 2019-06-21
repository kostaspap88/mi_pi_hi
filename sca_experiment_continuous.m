function traceset = sca_experiment_continuous(key_bits, no_traces)


key_range = 0:2^key_bits-1;

% Normally the train data are observed in a real device
% Here we just simulate them from statistical distributions
% We choose normal distributions for our simulation of device leakage

sigma = 1;
 
mu=key_range;
for i=1:length(mu)
    pd(i) = makedist('normal','mu',mu(i)*10,'sigma',sigma);
end

for i=1:length(mu)
    traceset{i} = random(pd(i), no_traces, 1);
end


end