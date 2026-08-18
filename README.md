# How do annual members and casual riders use Cyclistic differently?

An analysis of 5.7 million bike-share trips, June 2025 to May 2026.

**Tools:** BigQuery (SQL), Power BI
**Data:** Divvy public trip data, Chicago, used under the Divvy Data License Agreement

## Ask
Cyclistic is a Chicago bike-share company with two customer types: casual riders, who pay per ride or per day, and annual members. Finance has concluded that members are more profitable, so the marketing director wants to convert casual riders into members.

Converting them requires knowing how they differ. The brief as given "how do annual members and casual riders use Cyclistic differently?" is too broad to answer with a query, so I narrowed it to five measurable questions:

1. How long are their rides?
2. Which days of the week do they ride?
3. What times of day?
4. How does riding change across the year?
5. Where do their rides start?

**What this data cannot answer.** Each row is a trip, not a person. There are no rider IDs, so a rider taking fifty trips is indistinguishable from fifty riders taking one each — ride counts are not rider counts. There is no revenue or pricing data, no demographics, and no way to identify a casual rider who later became a member. Every conclusion below is about the *pattern of rides*, not about individual people, and the recommendations are written to respect that limit.

## Prepare

Twelve monthly CSV files covering June 2025 to May 2026, published by Divvy and made available under a public licence that permits this use. The data is first-party. Divvy collected it from its own system rather than surveying or purchasing it, so it is current, reliable and directly relevant to the question.

Each file holds one row per trip with thirteen fields: ride ID, bike type, start and end timestamps, start and end station names and IDs, start and end coordinates, and the rider type.

Before loading, I checked the timestamps inside each file against its filename. One file was labelled January 2025 but contained January 2026 data. Going by filenames alone, it looked as though January 2026 was missing entirely. Since seasonality is one of my five questions and January is the low point of the year, losing that month would have broken the analysis. I renamed the file and checked the other eleven the same way, because one mislabelling meant I couldn't assume the rest were right.

Loading into BigQuery Sandbox needed a workaround. Six of the twelve files exceeded the 100 MB browser upload limit, and the Sandbox tier blocks `INSERT`. I loaded the oversized files as external tables pointing at Google Drive, copied them into the main table using a query with a destination table set to append, then dropped the external tables.

The schema was declared explicitly rather than left to BigQuery to guess, with all station ID fields typed as `STRING`. They contain non-numeric characters, so an inferred type would have failed.


## Process

Three cleaning decisions, each documented with the reasoning rather than the rule.

**Duplicates.** 35 rides appeared twice. All sat on the April/May file boundary, and all were identical across every one of the thirteen columns. That points to an overlap in how the files were published rather than a data fault. Removed with SELECT DISTINCT *, leaving 5,848,668 rows.

**Missing station names.** 21% of rides had no start or end station name. I nearly treated this as a quality problem, but checking against bike type showed every affected ride was on an electric bike. These can be locked anywhere, so a ride starting or ending away from a dock has no station to record. The nulls are a feature of dockless operation, not missing data. I kept the rows and noted that the geographic analysis rests mainly on dock-based trips.

**Ride duration.** I kept rides between 30 seconds and 24 hours. Both limits were chosen from the shape of the distribution rather than picked as round numbers.

Grouping rides into duration bands and comparing them per second rather than by raw count shows the density roughly halves at 30 seconds, about 3,700 rides per second below it, against 1,500 just above. It climbs again as genuine journeys begin. The floor sits at that break. Below it the pattern fits a bike being undocked and put straight back rather than a trip taken, and it also removed 29 rows where the end time preceded the start.

At the top end, a small number of rides ran for days, far outside the main distribution. A bike never properly returned keeps the ride open, so these record an equipment problem rather than travel. The 24-hour ceiling removes them without cutting into genuine long rides.

121,553 rides were excluded, leaving 5,727,115 for analysis.

### The timezone error

The clearest thing I learned on this project came from an error.

I converted the timestamps from UTC to Chicago time before analysing time of day. The result showed members peaking at 3am and midday, a pattern with no sensible explanation. Rather than write around it, I checked the hourly distribution on the raw timestamps and found the trough sat at 3 to 4am with peaks at commuting hours. Divvy publishes in Chicago local time already, and BigQuery only displays it as UTC. My conversion had shifted every ride by several hours.

I rebuilt the table without the conversion and the peaks landed at 8am and 5pm. The check that caught it was simple: the output had to be plausible before I would use it.

---

## Analyse

Five queries, five findings.

**Ride duration.** Casual rides are longer. They run a median of 11.6 minutes against 8.7 for members, 34% longer. Both means sit well above their medians, at 19.4 and 12.2 minutes, because a small number of very long rides pulls the average up. I used the median throughout, as it describes the typical ride rather than the extremes.

**Day of week.** The two groups ride on opposite days. Members ride steadily Monday to Friday and drop away at the weekend, while casual riding peaks on Saturday, 84% above its Tuesday low.
Ride length moves the same way. Casual rides stretch from 16 minutes midweek to 22 on Sunday, while member rides hold between 12 and 13 minutes all week. Weekday riding of a consistent length is the pattern of a commute; longer trips concentrated at weekends are the pattern of leisure.


**Time of day.** Members ride at commuting hours. Volume peaks at 8am and again at 5pm, with a clear trough between the two. Casual riding has no morning peak at all, only a steady climb through the day to a single 5pm high.

**Seasonality.** Casual riding is heavily seasonal and member riding is not. Casual volume runs 13.6 times higher in August than January, while members keep riding through the winter. 70% of casual riding falls in the five months from May to September, with the sharp drop coming after October.

**Starting stations.** The two groups start in different places, with no station appearing in both top tens. Casual rides begin at named destinations along the lakefront: Navy Pier, Millennium Park, the Shedd Aquarium. Member rides begin at street intersections in the West Loop and Near North Side, with Clinton Street appearing three times alongside Union Station. Casual riding also concentrates much harder: Navy Pier alone runs 72% above the busiest member station. A few places account for most casual starts, which makes that audience reachable in a way members are not.

I checked the station coordinates on a map rather than inferring the area from the station names.

**Together:** Five independent measures give one consistent picture. Members use Cyclistic as transport: short, repeated, weekday journeys from rail terminals and residential areas, sustained through winter. Casual riders use it for recreation: longer, weekend, summer trips concentrated on the lakefront.


## Act

**1. Drop the commuter-value pitch.** Casual rides cluster on Saturday and Sunday and nearly stop in winter. The savings argument for membership assumes frequent use, and casual riding is not frequent. Cyclistic should stop selling membership to this group on commuting savings, because the case rests on a pattern of use these riders do not have.

**2. Offer a shorter or seasonal membership.** Seventy percent of casual riding falls in five months, so an annual pass asks riders to pay for a year to use it for less than half of one. Cyclistic should offer a monthly or summer-season option instead. The data can't say which is better, as it holds no pricing or revenue.

**3. Target by place and time.** Casual rides start at a small number of stations, mainly Navy Pier, Millennium Park and the lakefront, and concentrate on summer weekend afternoons. Cyclistic should focus marketing at those stations and times rather than spreading it across the network, as the concentration makes the audience easy to reach.

---

## Limitations

- **No rider IDs.** The weekend clustering is a property of rides, not riders. The same people may ride on weekdays too, or each weekend may bring different people. The pattern is strong enough to act on, but the number of casual riders who could become members is unknown.
- **Missing station data.** 21% of rides have no station name, all on electric bikes, so the geographic findings lean on dock-based trips.
- **No pricing or revenue.** Recommendation 2 identifies the right kind of product change without being able to specify it.
- **One year of data.** The seasonal pattern is observed once, so there is no way to tell whether this year was typical.
- **No record of past conversions.** Nothing here says what has already worked.
