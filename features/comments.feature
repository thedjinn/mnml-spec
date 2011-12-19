Feature: Comments

  Mnml documents are parsed on a line-by-line basis. A line may begin with a
  pound symbol to indicate that the line is a comment and should be ignored.

  Commented lines may have any level of indentation. However, a comment that
  has a lower level of indentation than a previous tag list or heredoc should
  terminate that nesting level.

  Comments only work outside of heredocs. Inside the heredoc the comment is
  treated as being part of the heredoc's contents.

  Scenario: Comments are ignored
    Given a file named "test.mnml" with:
      """
        # First comment line
        # Second comment line
        
        # Third comment line
        
          # Fourth comment line
            # Fifth comment line
        # Sixth comment line
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document></document>
      """

  Scenario: Comments inside a heredoc are treated as heredoc contents
    Given a file named "test.mnml" with:
      """
      tag ->
        heredoc
        # with comment
        contents
      """
    When I parse the file "test.mnml"
    Then I should see the following representation:
      """
      <document>
        <tag row=1 col=1 name="tag">
          <text row=2 col=3 value="heredoc\n# with comment\ncontents"/>
        </tag>
      </document>
      """
