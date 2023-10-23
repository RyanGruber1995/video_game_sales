# Table of Contents
1. [Data Normalization](#DataNormalization)

# Data Normalization

Although this dataset came from a public source and was mostly in a format that was usable, I took this opportunity to explore the data and discovered that the table could be optimized. The following is a screenshot of the columns and the first few rows of the raw data set:

![](https://github.com/RyanGruber1995/video_game_sales/blob/main/screenshots/data_normalization.PNG)

I identified three different attributes that could be broken out into different tables: Platform, Genre, and Publisher. These columns contain string data and can have multiple of the same value within their respective columns, e.g. having 'Nintendo' multiple times per the screenshot. Even though this particular dataset is able to fit in a spreadsheet, this would not be an ideal situation for a much larger dataset and processing time for running SQL queries would be reduced.


