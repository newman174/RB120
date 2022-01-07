module GameDisplay
  class Display
    attr_accessor :frames

    def initialize
      self.frames = []
    end

    def show
      frames.each(&:print)
      nil
    end

    def add_frame(frame)
      frames.push(frame)
    end
  end

  class Frame
    TOP_BOTTOM_DIV_SYM = '-'
    TOP_BOTTOM_MARGIN_LINES = 1
    SIDE_DIV_SYM = '|'
    SIDE_MARGIN = '   '
    TOTAL_PAD = (SIDE_MARGIN.size * 2) + 2

    Line = Struct.new('Line', :text, :align)

    attr_accessor :lines

    def initialize
      self.lines = []
    end

    def width
      max_line_length = lines.empty? ? 0 : lines.map { |ln| ln.text.length }.max
      max_line_length + TOTAL_PAD
    end

    def add_line(text: '', align: :left)
      new_line = Line.new(text, align)
      lines.push(new_line)
      new_line
    end

    def top_bottom_border
      TOP_BOTTOM_DIV_SYM * width
    end

    def top_bottom_margin
      "#{SIDE_DIV_SYM}#{' ' * (width - 2)}#{SIDE_DIV_SYM}"
    end

    def left_border
      "#{SIDE_DIV_SYM}#{SIDE_MARGIN}"
    end

    def right_border
      "#{SIDE_MARGIN}#{SIDE_DIV_SYM}"
    end

    def line_to_s(line)
      case line.align
      when :left then line.text.ljust(width - TOTAL_PAD)
      when :right then line.text.rjust(width - TOTAL_PAD)
      when :center then line.text.center(width - TOTAL_PAD)
      end
    end

    def print
      puts top_bottom_border
      TOP_BOTTOM_MARGIN_LINES.times { puts top_bottom_margin }
      lines.each { |ln| puts "#{left_border}#{line_to_s(ln)}#{right_border}" }
      TOP_BOTTOM_MARGIN_LINES.times { puts top_bottom_margin }
      puts top_bottom_border
    end
  end
end
