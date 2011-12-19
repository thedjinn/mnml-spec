Feature: Text attribute

  Every Mnml tag has an option to add a text value to the tag. This can be
  either a single line string that is added at the end of the tag declaration
  line or a multiline string, which is called a heredoc (and covered in the
  feature definition with that name).

  A tag definition always begins with a tag name and a list of arguments, which
  may be empty. Any content after that argument list should be recognized as a
  text value.

  If the text value begins with an arrow symbol (/->\s*/) it should parse the
  child lines below it as a heredoc. If this symbol is recognized any trailing
  characters should result in a parse error. When the arrow symbol is part of
  the text then it should be part of the text content. Strings that should
  start with an arrow symbol can be implemented as a single line heredoc.

  Scenario: Text follows arguments
    Given a file named "test.mnml" with:
      """
      tagname arg=value this is the text
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="tagname">
          <argument>
            <key row=1 col=9 value="arg"/>
            <value row=1 col=13 value="value"/>
          </argument>
          <text row=1 col=19 value="this is the text"/>
        </tag>
      </document>
      """

  Scenario: Text follows tag name
    Given a file named "test.mnml" with:
      """
      tagname this is the text
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="tagname">
          <text row=1 col=9 value="this is the text"/>
        </tag>
      </document>
      """

  Scenario: Arrow symbols in text, but not at start
    Given a file named "test.mnml" with:
      """
      tagname this -> is -> the -> text ->
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="tagname">
          <text row=1 col=9 value="this -> is -> the -> text ->"/>
        </tag>
      </document>
      """

  Scenario: No whitespace after last quoted argument
    Given a file named "test.mnml" with:
      """
      tagname arg="value"this is the text
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <errors>
        <error row=1 col=20 text="Expected whitespace or end of line"/>
      </errors>
      """
    
  # Note: Might want to relocate this scenario to heredoc feature
  Scenario: Text starting with arrow symbol
    Given a file named "test.mnml" with:
      """
      tagname -> this is the text
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <errors>
        <error row=1 col=12 text="Expected end of line"/>
      </errors>
      """

