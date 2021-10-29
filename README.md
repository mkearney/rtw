
# rtweet

A lite version of [{rtweet}](https://github.com/ropensci/rtweet)

Still includes a progress bar and a tibble-like class for printing purposes

```r
> ## search for most recent tweets
> rtw::search_tweets("filter:verified OR -filter:verified", n = 200)
...downloading...    [==================================================]    1s
# rtwibble (190 x 90)
            created_at     screen_name                          text ...
1  2021-10-29 17:39:49   MansiMudgal23               Just watch t...   .
2  2021-10-29 17:39:49        ffskuroo 心操くんの活躍がまた早く見...   .
3  2021-10-29 17:39:49         jonghug               [IDOL CHAMP ...   .
4  2021-10-29 17:39:49       msacadien               @_waleedshah...   .
5  2021-10-29 17:39:49 NedzUabXl1eAevh 気になる人フォローしてます...   .
6  2021-10-29 17:39:49       aures40dz               M'chounech b...   .
7  2021-10-29 17:39:49           8Tmhr @tsujiJCP 『迷ったら共産党...   .
8  2021-10-29 17:39:49         ZaccSno               Finally gett...   .
9  2021-10-29 17:39:49     Atmiyavijay            आर्यन के साथ नेता,...   .
10 2021-10-29 17:39:49 Elizabe04632973             #FelizJueves\n...   .
   ...
```