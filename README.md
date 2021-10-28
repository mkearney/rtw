---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtweet

A lite version of [{rtweet}](https://github.com/ropensci/rtweet)


```r
twts <- rtw::search_tweets("filter:verified OR -filter:verified", n = 200)
```

```
## Downloading [=========================================] 100%
```

```r
print(twts, n = 20)
```

```
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
## 11 2021-10-28 17:21:45    AndrLaporte3   @Didier515 @raafkaa @Nirinin...   .
## 12 2021-10-28 17:21:45      theyluvmih   se eu estudasse em hogwarts ...   .
## 13 2021-10-28 17:21:45     babyy_natty   I love irregular texters cau...   .
## 14 2021-10-28 17:21:45          Nookzc      แมวหรือปลาปักเป้า https://t....   .
## 15 2021-10-28 17:21:45 veluman15115104   I’ll give $100 to one random...   .
## 16 2021-10-28 17:21:45      anoxiaplus En 24h:\n\n1 #Mena acuchilla a...   .
## 17 2021-10-28 17:21:45     LuckyAgabaa   Secondly what's your expendi...   .
## 18 2021-10-28 17:21:45       kassem325     قال إنّو الأمركان بحطّو عقوب...   .
## 19 2021-10-28 17:21:45  SantiagoElenaG   Cuando se recoge el pelo aún...   .
## 20 2021-10-28 17:21:45        DFloresT   Twitter haz tu magia!! Por f...   .
##    ...
```
