******
head section (h1)
******

small head section (h2)
******

head section (h3)
======

Listing
======

- unordered list with -
- list item ca be breaked in raw text
  with leading spaces
* leading one can be * or + with space
+ this is with +, but using different heading charactor makes another list
  + second order is not possible
1. ordered list is by leading number
#. continuous number will be assigned automatically with #

definition
  list is possible with item with following text
also phrase
  is posslbe for definition

:colon:
  will be rendered as small table

:can continue:
  even with line break in between, tailing \: is required

-a  command help is displayed as this
-b  with continued list

Text markup
======

- *emphasis* with *
- **strong** with two *
- `solid text` with \`
- ``inline literal`` with two \`
- reference_ or `in phrase`_ are possible (need `.. _text: URL` as line)
- numbered footnote reference is by `[x]_`
- escape by \\ as \`

::

 paragraph headed with two \: and heading white space text 
 will be taken as literal block

>>> leading three \> will be quote

 or text with space will be quote

Text can be breaked into lines with leading \| like
| this is breaked line.

Tables
======

+-------+-------+----------+
| table | is by | bar      |
| but   | not   | flexible |

