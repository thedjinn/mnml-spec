Feature: Tag arguments

  The tags in a Mnml document can have any number of optional arguments. These
  arguments are key-value pairs. 

  The argument keys follow the same naming convention as the tag names, i.e.
  they must conform to the following regular expression:

      [a-zA-Z_][a-zA-Z0-9_]*

  For representing the value there are two options.

  1. You can write values as simple unquoted strings. This is only possible if
     the string does not contain any spaces and double quotes.

  2. Any other value can be represented as a double quoted string. In order to
     add double quotes to the string itself they can be escaped with a 
     backslash. A double backslash inserts a single backslash. Any other
     escapes are reserved for future use and should be ignored.

  Scenario: Simple unquoted arguments
    Given a file named "test.mnml" with:
      """
      tagname first_ARG=foo second_ARG=bar
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="tagname">
          <argument>
            <key row=1 col=9 value="first_ARG"/>
            <value row=1 col=19 value="foo"/>
          </argument>
          <argument>
            <key row=1 col=23 value="second_ARG"/>
            <value row=1 col=34 value="bar"/>
          </argument>
        </tag>
      </document>
      """

  Scenario: Complex unquoted arguments
    Given a file named "test.mnml" with:
      """
      tagname arg=~!@#$%^&*()_+`-=[]{}\|;':,./<>?
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="tagname">
          <argument>
            <key row=1 col=9 value="arg"/>
            <value row=1 col=13 value="~!@#$%^&*()_+`-=[]{}\|;':,./<>?"/>
          </argument>
        </tag>
      </document>
      """

  Scenario: Quoted arguments
    Given a file named "test.mnml" with:
      """
      tagname first_ARG="He said: \"Hello world!\"." second_ARG="C:\\Windows\\"
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="tagname">
          <argument>
            <key row=1 col=9 value="first_ARG"/>
            <value row=1 col=19 value="He said: &quot;Hello world!&quot;."/>
          </argument>
          <argument>
            <key row=1 col=48 value="second_ARG"/>
            <value row=1 col=59 value="C:\Windows\"/>
          </argument>
        </tag>
      </document>
      """

  Scenario: Ignoring reserved escapes
    Given a file named "test.mnml" with:
      """
      tagname arg="Hello \a\b\c\d\e\fworld!"
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="tagname">
          <argument>
            <key row=1 col=9 value="first_ARG"/>
            <value row=1 col=13 value="Hello world!"/>
          </argument>
        </tag>
      </document>
      """

