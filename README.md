# Trading Rule Back Testing

### Introduction

In this assignment, we took a deeper dive into algorithmic trading. This type of trading is very useful because
it utilizes computation to make buying and selling stocks efficient. In algorithmic trading, stocks are bought
and sold based on “signals” - in this assignment, we use the following signal: long when DVI < 0.5 and short
otherwise. A long trade occurs when you buy a stock and expect to sell it at a higher price in the future.
A short trade occurs when you sell a stock and expect to buy it at a lower price in the future. Before we
implemented this trading rule, we had to back test it.

### Algorithmic Trading

With the increase in technological advances corporations like Citibank have started training their employees
in programming languages like Python and R. This is a move to train their employees in programming to
improve their overall banking operations including trading and investment banking. This has introduced
concepts and strategies like algorithmic trading or algo trading.

### Back Testing

Back testing is the process of assessing how well a trading strategy works based on historical data. It is
a key component in developing an effective trading strategy. There are infinite possibilities for strategies,
and any slight alteration will change the results. This is why back testing is important, as it shows whether
certain parameters will work better than others. To back-test, a trading strategy is required. At minimum,
a trading strategy helps to define entry and exit points for both winning and losing trades, plus a position
size. Back testing requires historical data, which shows past price movements of a particular asset from
trading charts. To back-test, a trader will typically need several weeks of historical data for strategies where
the trades are short-term in nature. Many years of historical data may be required if testing a long-term
strategy.

### Load and Get the Stock Data

For the purposes of this project we used predetermined inputs. The firm whose stock we used is Johnson and
Johnson (ticker: JNJ) and the time period used was from 2010 to 2016. We use the getSymbols() function
of Quantmod library to get the stock data for our required time period range.

### Strategy Backtesting

To back test our algo-trading strategy we are using DVI as an indicator to determine our trading signals.
DVI Oscillates between 0 and 1, however in our case we will use a simple trading rule of doing a Long trade if DVI < 0.5 and Short trade if DVI >= 0.5. We will also perform a Lag so that yesterday’s signal is applied
to today’s returns. This allows us to avoid look-ahead bias.Furthermore, doing back testing using a singular
set of inputs is not a good practice. As such we will back-test using multiple time period ranges (2010-2016)
and multiple DVI indicator values (0.4-0.6 with an increment of 0.01). This allows us to avoid “bounded
rationality”, which in simple terms means making decisions based on limited knowledge.

### Base Level Back Test (Function 1)

As part of our back testing process we will first back-test our strategy for a singular set of inputs. Which
in our case are stock data of “JNJ”, time range from “2014-01-01” to “2017-12-31” and DVI indicator of
0.5. In our first function we are performing a simple back test in which we enter a long when DVI is less
than 0.5 and short otherwise. Our function takes inputs in terms of stock ticker, beginning and ending date
from the time period range and a DVI threshold. Using them we are getting stock close price which we use
to calculate the stock returns. After that we determine our buy/+1 and sell/-1 signals to implement our
trading rule using the DVI threshold. Furthermore, we also lag our signal to mitigate look-ahead bias. We
then determine the number of short and long trades encountered in our backtest and also determine the
percentage of days the trade was in long and short position. Finally we calculate the cumulative return of
the strategy and store the results in a data frame for viewing.

### Interpret Result

The percentage return should give an indication of how successful the strategy is. A cumulative return is the
total amount of money that an investment has gained or lost over time, independent of the time involved.
It is expressed as a percentage. In this singular backtesting, the trader is losing at 16.7% of their investment
money.

### Back Test with Multiple Back Test Periods (Function 2)

As discussed before, using a single instance of inputs to run a back-test is not a good practice and as such
we test our strategy using multiple back-test periods. So for that we define our second function in which we
determine multiple back test periods with each period being of 3 years, so our time periods come out to be
2010-2012, 2011-2013, 2012-2014, 2013-2015 and 2014-2016. Using a for loop we use these new time period
ranges as input for our first function and run the back-test for each period. This gives us a data frame with
the output of the first function for the 5 periods. After which we plot the cumulative returns of these 5 time
periods in order to visualize their comparison. Lastly we calculate the mean of these five time periods to
reduce standard error in our strategy results.

### Interpret Result

We see in our result that for one time period (2010-2012) we get a positive cumulative return of 31% and
for others we get a negative value. As discussed above the percentage return gives an indication of how
successful the strategy is. So in our case the strategy is only successful for the time period (2010-2012).
However if we take the mean of our 5 periods we see that our strategy results in a loss of 0.4%.

### Back Test with Multiple DVI Threshold (Function 3)
In addition to running the back-test for multiple time periods we need to run it for multiple DVI thresholds.
The negative cumulative returns indicate that the trader is losing money and the positive cumulative returns
indicate that the trader is gaining money from the trade.

### Interpret Result

For our third function we run 21 back tests and for most of them we get a negative cumulative return.
The only instances we get a positive value is when the DVI is 0.4 (2% cumulative return), DVI 0.42 (1.3%
cumulative return), DVI 0.55 (0.8% cumulative return), DVI 0.58 (5.7% cumulative return), DVI 0.59 (16.9%
cumulative return) and DVI 0.6 (16.3% cumulative return). So for the “JNJ” ticker and time range of “2014-
01-01” to “2017-12-31” only these DVI values deem our strategy successful.

### Biases in Trading

Although back testing may show how a trading strategy performed in the past, it cannot guarantee a
strategy’s future performance. Traders should be aware of certain biases which might drastically change the
results such as over fitting, time period chosen and assets chosen.
Back testing gives traders the best result on the historical data set, but when we deploy the same model on
the unseen data set, it might fail to give the same result. It’s always better to look at the average of multiple
simulations of different periods of time. For this reason, back testing could be a useful tool but it should
not be exclusively relied on. Traders can also ‘forward test’ their strategies in live market conditions to see
if they work in real time, without basing them purely on historical data. Goal of back testing is not to look
for the best back-test but to find a strategy that works well in future trading as you want to make money in
the future. The best method is to keep the back-test & strategy simple. A simple strategy that works well
overtime is more robust than a strategy that’s tailored made as the more you tailor it, the less likely for the
strategy to change as in reality, changes in the future are inevitable.
Using technical analysis can avoid various biases in behavioral finance. With behavioral finance critique,
traders do not always process correct information and often make inconsistent or systematically sub optimal
decisions. The following behavioral finance bias often causes irrationality in the market: regret avoidance,
mental accounting, framing and overconfidence. Mental accounting refers to the different values a person
places on the same amount of money, based on subjective criteria, often with detrimental results. Mental
accounting is a concept in the field of behavioral economics. Framing bias occurs when people make a decision based on the way the information is presented, as opposed to just on the facts themselves. Overconfidence
bias is the tendency for a person to overestimate their abilities. It may lead a person to think they’re
a better-than-average driver or an expert investor. Overconfidence bias may lead clients to make risky
investments.

### Conclusion

Back testing is a great strategy to figure out whether or not a trading rule is going to work. Using financial
data from Yahoo, we were able to create an indicator and construct our trading rule. The back testing
results from function 1 showed a cumulative return -16.7%, indicating a loss. From this, we can conclude
that this back testing result suggests that the trading rule we constructed may not work too well. The back
testing result from function 2 does not suggest much difference, since all of the cumulative returns except
one are negative.
Additionally, most of the returns are negative in function 3. Our back testing results give a good idea about
the strength of our trading rule. This is because we are changing the inputs and way we backrest in each
of our functions. Instead of just looking at one date range only, we are looking at different periods to see if
there is a difference.
Furthermore, we change the signal we use in function 3 to better understand where the long and short trades
are occurring. Given our elaborate results, we can suggest that the trading rule focused on in this assignment
overall is not very successful. However, not all the results were negative. The first result from function 2
(long = 21, short = 20) produces a return of 31%. Additionally, a few of the results from function 3 produce
a return > 10%, which is a good return. So we cannot say that this trading rule will never work well, but
for the most part it won’t. It is important to note that our backtesting strategy has a big limitation; we do
not know the market segment. This definitely skewed our results.
