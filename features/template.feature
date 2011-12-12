@ignore
Feature: Template feature

  The Mnml specification is based on a comparison between input and an
  S-expression representation of a parse tree.

  In the top level list of the S-expression there are two elements, the first
  one represents the parse tree itself and the second one is a list of expected
  parse errors.

  This feature is a template that can be used as a basis for other features.

  Scenario: Template scenario with parse tree
    Given a file named "test.mnml" with:
      """
      foo bar=baz quux
        bazinga
      """
    When I parse the file "test.mnml"
    Then I should see the following expression:
      """
      (
        (
          ("foo" 1
            (("bar" "baz"))
            ("quux")
            (("bazinga" 2 () () ()))
          )
        )
        ()
      )
      """

  Scenario: Template scenario with errors
    Given a file named "test.mnml" with:
      """
      %#@$#

        bla
      """
    When I parse the file "test.mnml"
    Then I should see the following expression:
      """
      (
        ()
        (
          ("Expected tag name" 1 1)
          ("Unexpected indentation" 3 1)
        )
      )
      """
