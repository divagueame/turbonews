# README
Search the latests news

Created by Martin Arce

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
article a#ue-c-cover-content__link
relative_url: false




# Other info
Some news sites link their articles with an absolute path or relative one. Therefore, there's a flag "relative_url" called  to indicate that.