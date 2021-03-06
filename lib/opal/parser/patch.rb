# frozen_string_literal: true

if RUBY_ENGINE == 'opal'
  class Parser::Lexer
    def source_buffer=(source_buffer)
      @source_buffer = source_buffer

      if @source_buffer
        source = @source_buffer.source
        # Force UTF8 unpacking even if JS works with UTF-16/UCS-2
        # See: https://mathiasbynens.be/notes/javascript-encoding
        @source_pts = source.unpack('U*')
      else
        @source_pts = nil
      end
    end
  end

  class Parser::Lexer::Literal
    undef :extend_string

    def extend_string(string, ts, te)
      @buffer_s ||= ts
      @buffer_e = te

      # Patch for opal-parser, original:
      # @buffer << string
      @buffer += string
    end
  end

  class Parser::Source::Buffer
    def source_lines
      @lines ||= begin
        lines = @source.lines.to_a
        lines << '' if @source.end_with?("\n")
        lines.map { |line| line.chomp("\n") }
      end
    end
  end
end
