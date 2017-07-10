******
head section (h1)
******

small head section (h2)
******

head section (h2)
======

head section 3
------

======
head section 4
======

------
head section 5
------

head sections
------

Listing
======

- unordered list with -
- list item ca be breaked in raw text
  with leading spaces
* leading one can be * or + with space
+ this is with +, but using different heading charactor makes another list

  + second order is possible, but need to place blank line before and after

    + Adding leading spaces will make deeper orders

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

| Text can be breaked into lines with leading \| like
| this is breaked line, but need to start with leading \| from 
  beginning of paragraph.

Tables
======

+-------+-------+----------+
| table | is by | bar      |
+=======+=======+==========+
| but   | not   | flexible |
+-------+-------+----------+

Links
=====

- normalink_
- `phrase link`_ 
- `in place link <http://example.net/>`_
- Can link to titles without anything like `Links`_

.. _normallink: http://example.net/
.. _phrase link: http://example.net/

- numbered footnote [5]_
- auto numbered footnote [#]_
- auto numbered footnote with name [#named]_
- citations are possible [PFS2017]_

.. [5] A footnote
.. [#] Auto numbered footnote
.. [#named] Named footnote
.. [PFS2017] Citation


