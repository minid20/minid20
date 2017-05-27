module MiniD20::Node
  class Table < Base
    attr_accessor :widths, :stripes, :top_line_drawn

    TR_HEIGHT = 11
    TR_V_PAD = 2

    def initialize(node, pdf)
      super
      self.widths = []
      self.stripes = [:dark, :light]
      self.top_line_drawn = false
    end

    def render
      font :primary
      set_widths
      pdf.line_width(0.5)

      node.css("tr").each do |tr|
        if tr.css("th").empty? && self.stripes.reverse!.first == :dark
          pdf.fill_color "cccccc"
          pdf.fill { pdf.rectangle [pdf.bounds.left, pdf.cursor], pdf.bounds.width, TR_HEIGHT }
          pdf.fill_color "000000"
        end

        if tr.css("th").empty? && !top_line_drawn
          pdf.stroke { pdf.horizontal_rule }
          self.top_line_drawn = true
        end

        pdf.bounding_box [pdf.bounds.left, pdf.cursor], width: pdf.bounds.width, height: TR_HEIGHT do
          tr.css("td, th").each_with_index do |cell, i|
            pdf.move_down TR_V_PAD
            render_cell(cell, i)
            pdf.move_cursor_to pdf.bounds.top
          end
        end
      end

      pdf.stroke { pdf.horizontal_rule }

      pdf.move_down 10
    end

    private

    def render_cell(cell, i)
      html = MiniD20::Node.clean_html(cell.inner_html)

      if cell.name == "th"
        font :th
      else
        font :primary
      end

      tr_width = pdf.bounds.width
      cell_left = widths[0, i].reduce(0) { |sum, i| sum + i } / 100.0 * tr_width
      cell_width = widths[i] / 100.0 * tr_width

      pdf.bounding_box [cell_left, pdf.cursor], width: cell_width, height: pdf.bounds.height do
        pdf.text html, inline_format: true
      end
    end

    def set_widths
      tds = node.css("tr").first.css("td, th")
      self.widths = tds.map { |td| td.attr(:width).to_i }
    end
  end
end
