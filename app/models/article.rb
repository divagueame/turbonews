class Article < ApplicationRecord

include PgSearch::Model

pg_search_scope :search_all, against: {
    header: 'A',
    body: 'B'
},
using: { tsearch: {prefix:true, any_word: true} }

pg_search_scope :search_header, against: {
    header: 'A'
},
using: { tsearch: {prefix:true, any_word: false} }


end
