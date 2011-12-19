Feature: Heredocs (multiline strings)

  Sometimes it may be necessary for a Mnml tag to have a multiline text
  attribute, e.g. for inserting code blocks or entire paragraphs of text. For
  this purpose Mnml has the heredoc construct.

  Instead of writing the text at the end of the tag declaration line an arrow
  can be appended. This signals the parser to treat any child content as a
  multiline string. The heredoc content is stripped of its indentation (except
  for indentation that is deeper than the first line of the contents) and any
  starting or ending newlines and whitespace are removed.

  Empty lines do not terminate the heredoc if the first line after the empty
  line still has an indentation level greater or equal to the indentation level
  of the heredoc.

  # TODO: figure out the best way to represent newlines in the XML attribute
  Scenario: Simple heredoc
    Given a file named "test.mnml" with:
      """
      tagname ->
        #include <stdio.h>

        main() {
          return 0;
        }
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="tagname">
          <text row=2 col=3 value="#include <stdio.h>\n\nmain() {\n  return 0;\n}"/>
        </tag>
      </document>
      """

  Scenario: Heredoc with stripped whitespace
    Given a file named "test.mnml" with:
      """
      second ->

        
        this
        is the
        heredoc


      second
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="first">
          <text row=4 col=3 value="this\nis the\nheredoc"/>
        </tag>
        <tag row=9 col=1 name="second"/>
      </document>
      """

  Scenario: Invalid heredoc indentation
    Given a file named "test.mnml" with:
      """
      tagname ->
        hello
       world
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <errors>
        <error row=3 col=2 text="Inconsistent heredoc indentation"/>
      </errors>
      """

