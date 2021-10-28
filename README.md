
# rtweet

A lite version of [{rtweet}](https://github.com/ropensci/rtweet)


```r
> ## search for most recent tweets
> twts <- rtw::search_tweets("filter:verified OR -filter:verified", n = 200)
Downloading [=========================================] 100%
```

Tibble-like replacement for printing purposes

```r
> ## print data (auto-truncates)
> twts
## # rtwibble (183 x 90)
##             created_at     screen_name                              text ...
## 1  2021-10-28 17:21:45       JEXUAISEN   Me contaron que @ProvosteYas...   .
## 2  2021-10-28 17:21:45        sady5111   #معصيتي_راحتي العلاقة الجنسي...   .
## 3  2021-10-28 17:21:45         ailerb_   #heeseung so handsome https:...   .
## 4  2021-10-28 17:21:45       agabiroxa   @gloriagroove Quem te ensino...   .
## 5  2021-10-28 17:21:45        xxx_nier       @_kumya キャナル行ってんやw   .
## 6  2021-10-28 17:21:45       boblopes1      @thelauracoates Slaughtered?   .
## 7  2021-10-28 17:21:45     koheigorila シーズン11のカジュアルのマップ...   .
## 8  2021-10-28 17:21:45   Shiva21373220   A. Rama Raju Mass JathaRRRa ...   .
## 9  2021-10-28 17:21:45         mett002   🙋‍♀️🙋Yarın tag çalışmamız sa...   .
## 10 2021-10-28 17:21:45        iIyesung   bakit pa ‘ko nabubay kung ‘d...   .
##    ...
```
