module MiniD20::Node
  class H2 < Base
    def render
      font :h2
      text node.inner_html.strip
      move_down 1

      unless html_classes.include?("table-below")
        stroke { horizontal_rule }
        move_down 5
      end
    end
  end
end
