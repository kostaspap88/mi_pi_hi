function traceset = sca_experiment_discrete(key_bits, no_traces)


key_range = 0:2^key_bits-1;

% Normally the train data are observed in a real device
% Here we just simulate them from statistical distributions
% We choose binomial distributions for our simulation of device leakage
% Does it make sense to use a discrete distribution to simulate the leakage
% of a real device? Although leakage is an analog signal, it gets
% discretized, ergo it discrete pmfs may be of interest.


N = 20;
p=linspace(0.1, 0.9, length(key_range));
for i=1:length(p)
    pd{i} = makedist('binomial','N',N,'p',p(i));
end


for i=1:length(p)
    traceset{i} = random(pd{i}, no_traces, 1);
end


end