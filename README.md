# 2020-yukon-forecasting

Data, code, and output for the 2020 operational forecast of Yukon River Chinook salmon run timing.

## Predictions


|% of Run|Day|
|-|-|
|15%|June 14|
|25%|June 16|
|50%|June 22|

## Diagnostic Plots

**Figure 1:** Estimated vs. Modeled %CPUE (Chart 1 on AOOS page)

![](daily_forecast/figures/daily_forecast.png)

- **Black line:** Logistic curve fit to the three predicted percentiles of cumulative CPUE. This is our cumulative %CPUE model.
0 **Red line:** Estimated cumulative %CPUE. This assumes the cumulative %CPUE model (black line) is correct and also assumes that, for example, if the cumulative CPUE at the 25% point is 10, then the end-of-season cumulative CPUE will be 40 (10/0.25). Cumulative %CPUE is then calculated from the daily cumulative CPUEs with 40 as the denominator. Daily CPUE values are from the LYTF drift.
- **How to read the graph:** If the timing forecast and the above %CPUE model are correct, we would expect the red line to oscillate above and below the black line. If the timing forecast is wrong, we would expect substantial deviation between the red and black lines.

**Figure 2:** Final CPUE estimates over the run

![](daily_forecast/figures/final_cpue.png)

- **Black, dotted line:** These are the final CPUE estimates we've made each day of the run based upon our predictions of run timing and the most recent cumulative CPUE observation.
- **How to read the graph:** When the timing model is correct, we expect the time series of Final CPUE estimates to stabilize and oscillate around a value. When the timing model is appreciably wrong, the time series will not stabilize.

## Previous years

- https://github.com/amoeba/2019-yukon-forecasting
- https://github.com/amoeba/2018-yukon-forecasting
- https://github.com/amoeba/2017-yukon-forecasting
- https://github.com/amoeba/2016-yukon-forecasting
