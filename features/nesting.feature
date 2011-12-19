Feature: Nested tags

  A Mnml document is defined as a tree of tags. A tag may have any number of child tags, except when the tag has a heredoc (see heredoc feature for more information).

  Nesting a tag in another one requires that the tags have an indentation level that is deeper than the parent tag. All child tags should have identical indentation.

  Scenario: Nesting tags
    Given a file named "test.mnml" with:
      """
      first
        second
          third
        fourth
          fifth
      sixth
        seventh
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="first">
          <children>
            <tag row=2 col=3 name="second">
              <children>
                <tag row=3 col=5 name="third"/>
              </children>
            </tag>
            <tag row=4 col=3 name="fourth">
              <children>
                <tag row=5 col=5 name="fifth"/>
              </children>
            </tag>
          </children>
        </tag>
        <tag row=6 col=1 name="sixth">
          <children>
            <tag row=7 col=3 name="seventh"/>
          </children>
        </tag>
      </document>
      """

  Scenario: Child tags not properly nested
    Given a file named "test.mnml" with:
      """
      first
        second
       third
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <errors>
        <error row=3 col=2 text="Inconsistent child indentation"/>
      </errors>
      """
