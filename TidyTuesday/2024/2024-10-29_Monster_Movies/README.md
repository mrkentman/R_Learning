<h1 align="center"> Monster Movies </h1>


This week we're exploring "monster" movies: movies with "monster" in their title!

> The data this week comes from the [Internet Movie Database](https://developer.imdb.com/non-commercial-datasets/). Check out ["Why Do People Like Horror Films? A Statistical Analysis"](https://www.statsignificant.com/p/why-do-people-like-horror-films-a) for an exploration of "the unique appeal of scary movies".
>
>What are the most common combinations of genres for "monster" movies? How do "monster" movies compare to ["summer" movies](https://github.com/rfordatascience/tidytuesday/blob/master/data/2024/2024-07-30/readme.md) or ["holiday" movies](https://github.com/rfordatascience/tidytuesday/blob/master/data/2023/2023-12-12/readme.md)? What words are joined with "monster" in popular "monster" movies?

>Thank you to [Jon Harmon](https://github.com/jonthegeek) for curating this week's dataset.

[Link](https://github.com/rfordatascience/tidytuesday/blob/master/data/2024/2024-10-29/readme.md) to the orginal post.
<h2 align="center"> My Plot </h2>

I wanted to try and make a bump chart showing the ranks of the most popular genres each year but I struggled to work out how to rank them so instead I made a graph showing the genres that appeared the most.

I wasn't sure how to best go about working out the culmative frequencies for each genre without having to make a seperate data frame for each. I'm sure there is a much nicer way to go about calculating the culmative frequencies for each. Maybe in the future when I get better with R I can revisit this and clean it up/make the orginial bump chart I invisioned.

<p align="center">
  <img src="/TidyTuesday/2024/2024-10-29_Monster_Movies/monstermovies_plot.png" width="80%">
</p>
