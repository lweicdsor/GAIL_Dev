%% Pricing Basket Option with Monte Carlo and Quasi-Monte Carlo Methods
% Basket Option is a type of financial derivative where the underlying 
% asset is a group of commodities, securities or currencies. A basket 
% option gives the holder the right, but not the obligation, to buy or 
% sell an underlying asset at a specific price, on or before a certain date.
%
% There are two different types of options, *calls* and *puts*:
%
% * A call gives the holder the right to buy an asset at a certain price 
% within a specific period of time. Buyers of calls hope that the stock 
% will increase substantially before the option expires.
% * A put gives the holder the right to sell an asset at a certain price 
% within a specific period of time. Buyers of puts hope that the price of 
% the stock will fall before the option expires.
%

%% Payoffs of Basket Option
% The payoff of a basket option is given as follows:
%
% Call Option:
%
% \[max(\sum_{i=1}^n {a_i*S_T^{(i)}} - K, 0)\]
% 
% Put Option:
%
% \[max(K - \sum_{i=1}^n {a_i*S_T^{(i)}}, 0)\]
%
% where:
%
% \(n\) - number of assets
%
% \(K\) - strike price


%% Generate Basket Option Price using Monte Carlo Method
% _optPrice_ is a MATLAB(R) class that generates the prices for options. 
% _optPrice_ uses many different variables and it has many superclasses:
superclasses(optPrice)

%%
% To calculate the basket option price, we first need to construct several parametrer values:
%Payoff Parameters:
inp.payoffParam.optType = {'basket'};       % basket Option
inp.payoffParam.putCallType = {'call'};     % call
inp.payoffParam.strike = 12;                % strike price
inp.payoffParam.basketWeight = [0.2 0.8];   % weights of assets in a basket option

%Asset Path Parameters: 
inp.assetParam.initPrice = [11 15];         % initial Asset Prices
inp.assetParam.interest = 0.01;             % 1% interest rate
inp.assetParam.volatility = [0.5 0.6];      % volatility
inp.assetParam.nAsset = 2;                  % number of underlying assets in the basket option
inp.assetParam.corrMat = [1 0.5; 0.5 1];    % correlation matrix of assets in the basket option

%Option Price Parameters
inp.priceParam.cubMethod = 'IID_MC';        % type of pricing scheme
inp.priceParam.absTol = 0.01;   
inp.priceParam.relTol = 0;                  % 1% relative tolerance

%Stochastic Process
inp.timeDim.timeVector = 1;                 % Defining the Time as one trimester.

%%
% Then we generate a class that evaluates the option price.
tic, BasketOptionCall = optPrice(inp), toc

%%
% Now we generate the basket option price using Independent Identically Distributed (IID) sampling
n=5; %number of sampling

for i=1:n
    tic, 
    iid_BasketOptionCall(i) = genOptPrice(BasketOptionCall);
    , toc
end
iid_BasketOptionCall
%%
% The function _genOptPrice_ is calledfrom the IID Monte Carlo method for 
% Finance in <https://code.google.com/p/gail/ GAIL> Repository(meanMC_g).

%% Plot of Payoffs Generated by Monte Carlo Method
% The plot of payoffs is generated below, which is a cumulative probability
% graph.
plot(BasketOptionCall,1e4);

%% Generate Basket Option Price using Quasi - Monte Carlo Method
% To use Sobol rather than IID method, we need to change the option price
% parameter:
inp.priceParam.cubMethod = 'Sobol';

%%
% Then we generate a class that evaluates the option price.
tic, BasketOptionCall = optPrice(inp), toc

%%
% Now we can generate the option price using Sobol sampling
for j=1:n
    tic, 
    sobol_BasketOptionCall(j) = genOptPrice(BasketOptionCall);
    , toc
end
sobol_BasketOptionCall

%%
% And the absolute difference of results generated by IID and Sobol sampling is:
absDiff = abs(iid_BasketOptionCall - sobol_BasketOptionCall)

%%
% As shown above, the absolute difference is within the tolerance.

%% References
%
% "Online Option Pricer." Options Pricer. Web. 22 June 2015.
%
% "Basket Option Definition | Investopedia." Investopedia. 19 Nov. 2003. Web. 22 June 2015.
%%
% Authors: Tianci Zhu and Hartur Santi










