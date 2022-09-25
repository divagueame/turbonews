# README

Search the latests news

Created by Martin Arce
![Alt text](/README/1.gif "Optional title")
![Alt text](/README/1.jpg "Optional title")
![Alt text](/README/2.gif "Optional title")
![Alt text](/README/2.jpg "Optional title")
![Alt text](/README/3.gif "Optional title")
![Alt text](/README/3.jpg "Optional title")
![Alt text](/README/4.webp "Optional title")

Date: May 2022

# Description

Browsers through different newspapers and indexes the articles.
The admin can add, modify or remove sources for the articles.
Admin can add, modify or remove available tags.

Articles have tags associated to them.

# Selectors for reference:

El Pais:

www.elpais.com
article h2 a
relative_url: true

El Mundo

www.elmundo.es
article a#ue-c-cover-content\_\_link
relative_url: false

# Other info

Some news sites link their articles with an absolute path or relative one. Therefore, there's a flag "relative_url" called to indicate that.

# Database structure

Intent:
Sources are newspapers in which there are many articles.
Articles have one or several associated Tags which describe the topic of that article.
Tags are generated through the most common words in the article.
Admins can add Tags manually through the admin panel.

Source
name
url
selector
relative_url

Article
header
body
url
browsed

Tags
name
active

Terms
name
discarded
active

Associations
Sources have many articles
Article Belongs to a source

    Articles have many Tags
    Tags have many articles

    Tags have many Terms
    Terms have many Tags
