@ignore
Feature: Template feature

  This feature is a template that can be used as a basis for other features.

  The Mnml specification is based on a comparison between input and an XML
  representation of an AST.

  The XML representation given in the scenarios should correspond to the data
  structures that are returned from the parser. Of course, simple collection
  nodes may be represented internally as lists where possible, and the same
  applies to any other native data structures the target programming
  environment may have. Common sense should be applied at all times when
  designing the parsing API.

  Scenario: Template scenario with parse tree
    Given a file named "test.mnml" with:
      """
      foo bar=baz quux
        bazinga
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="foo">
          <argument>
            <key row=1 col=5 value="bar"/>
            <value row=1 col=9 value="baz"/>
          </argument>
          <text row=1 col=13 value="quux"/>
          <children>
            <tag row=2 col=3 name="bazinga"/>
          </children>
        </tag>
      </document>
      """

  Scenario: Template scenario with errors
    Given a file named "test.mnml" with:
      """
      foo
      %#@$#

        bla
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <errors>
        <error row=2 col=1 text="Expected tag name"/>
        <error row=4 col=1 text="Unexpected indentation"/>
      </errors>
      """
