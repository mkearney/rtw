
# rtweet

A lite version of [{rtweet}](https://github.com/ropensci/rtweet)

{rtw} includes a fancy new (and dependency free) progress bar and tibble-like
printing class.

``` R
> rtw::search_tweets("lang:en filter:verified min_retweets:1000", n = 200)
..downloading..    ―――――――――――――――――――――――――――――――――――――――――――――――――――――   1s
# rtwibble (200 x 90)
            created_at     screen_name                                text ...
1  2021-11-01 16:25:18    AdamSchefter    Blockbuster: Broncos are fina...   .
2  2021-11-01 13:50:47    AdamSchefter    The concern on Titans’ RB Der...   .
3  2021-11-01 13:11:05    AdamSchefter    Titans’ RB Derrick Henry suff...   .
4  2021-11-01 16:00:42 Stranger_Things   drop a 🧇 if ur also at an ele...   .
5  2021-11-01 16:00:02 into1_official_ #INTO1 🌐 #HappyRikimaruDay \n\n...   .
6  2021-11-01 15:56:00       gucci1017                     It’s Novembrrr!   .
7  2021-11-01 15:47:07    narendramodi    The @COP26 Summit offers a wo...   .
8  2021-11-01 15:33:54    narendramodi    Addressing the @COP26 Summit ...   .
9  2021-11-01 15:24:32    narendramodi    Will be addressing the @COP26...   .
10 2021-11-01 11:15:24    narendramodi    Heartiest felicitations to @k...   .
   ...
```