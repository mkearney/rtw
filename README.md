
# rtweet

A lite version of [{rtweet}](https://github.com/ropensci/rtweet)

Still includes a progress bar and a tibble-like class for printing purposes

```r
> ## search for most recent tweets
> rtw::search_tweets("lang:en", n = 200)
...downloading...    [===========================================================]    1s
# rtwibble (168 x 90)
            created_at     screen_name                             text ...
1  2021-10-29 17:45:04        ZetaMale I would like a large pizza wi...   .
2  2021-10-29 17:45:04 namtitsinurarea RT to vote #BTS as #TheGroup ...   .
3  2021-10-29 17:45:04      Winter_Six @umarkhalifa19 @BamroSarah No...   .
4  2021-10-29 17:45:04    destroyymari staring at the ceiling thinki...   .
5  2021-10-29 17:45:04      newbsybhoy 3rd November 7pm | Hey, israe...   .
6  2021-10-29 17:45:04     wasimbhatii This is the coolest tweet by ...   .
7  2021-10-29 17:45:04          MasirM From Kashmir to Khi, Ziarat t...   .
8  2021-10-29 17:45:04         meee_sg how i wanna be https://t.co/B...   .
9  2021-10-29 17:45:04  _Thats_SoRaven It’s all making sense now. Th...   .
10 2021-10-29 17:45:04 mynameisnotvlad @IshigamiNajim that's why I p...   .
   ...
```