Feature: Tag names

  The basic building block of Mnml is called a tag. A tag has a name, zero or
  more arguments, an optional text attribute and zero or more children.

  The tag name is a string that matches the following regular expression:

      [a-zA-Z_][a-zA-Z0-9_]*

  Scenario: Valid tag name
    Given a file named "test.mnml" with:
      """
      valid_TAG_name
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="valid_TAG_name"/>
      </document>
      """

  Scenario: Invalid tag name
    Given a file named "test.mnml" with:
      """
      1_invalid_TAG_name
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <errors>
        <error row=1 col=1 text="Expected tag name"/>
      </errors>
      """
