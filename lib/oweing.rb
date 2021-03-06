# Autogenerated from a Treetop grammar. Edits may be lost.


module Oweing
  include Treetop::Runtime

  def root
    @root || :sentence
  end

  module Sentence0
    def action
      elements[0]
    end

    def space
      elements[1]
    end

    def amount
      elements[2]
    end

  end

  module Sentence1
    def content
      {:creditor    => action.creditor.content,
       :debitor     => action.debitor.content,
       :amount      => amount.content,
       :description => (elements.last.respond_to?(:name) && elements.last.name == "description" ? elements.last.content : nil)}
    end
  end

  def _nt_sentence
    start_index = index
    if node_cache[:sentence].has_key?(index)
      cached = node_cache[:sentence][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_action
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        r3 = _nt_amount
        s0 << r3
        if r3
          r5 = _nt_joiner
          if r5
            r4 = r5
          else
            r4 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r4
          if r4
            r7 = _nt_description
            if r7
              r6 = r7
            else
              r6 = instantiate_node(SyntaxNode,input, index...index)
            end
            s0 << r6
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Sentence0)
      r0.extend(Sentence1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:sentence][start_index] = r0

    r0
  end

  module Debitor0
    def content
      text_value
    end
  end

  def _nt_debitor
    start_index = index
    if node_cache[:debitor].has_key?(index)
      cached = node_cache[:debitor][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    s1, i1 = [], index
    loop do
      if has_terminal?('\G[A-Za-z0-9]', true, index)
        r2 = true
        @index += 1
      else
        r2 = nil
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      @index = i1
      r1 = nil
    else
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
    end
    if r1
      r0 = r1
      r0.extend(Debitor0)
    else
      if has_terminal?("me", false, index)
        r3 = instantiate_node(SyntaxNode,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure("me")
        r3 = nil
      end
      if r3
        r0 = r3
        r0.extend(Debitor0)
      else
        if has_terminal?("I", false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("I")
          r4 = nil
        end
        if r4
          r0 = r4
          r0.extend(Debitor0)
        else
          @index = i0
          r0 = nil
        end
      end
    end

    node_cache[:debitor][start_index] = r0

    r0
  end

  module Creditor0
    def content
      text_value
    end
  end

  def _nt_creditor
    start_index = index
    if node_cache[:creditor].has_key?(index)
      cached = node_cache[:creditor][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    s1, i1 = [], index
    loop do
      if has_terminal?('\G[A-Za-z0-9]', true, index)
        r2 = true
        @index += 1
      else
        r2 = nil
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      @index = i1
      r1 = nil
    else
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
    end
    if r1
      r0 = r1
      r0.extend(Creditor0)
    else
      if has_terminal?("me", false, index)
        r3 = instantiate_node(SyntaxNode,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure("me")
        r3 = nil
      end
      if r3
        r0 = r3
        r0.extend(Creditor0)
      else
        if has_terminal?("I", false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("I")
          r4 = nil
        end
        if r4
          r0 = r4
          r0.extend(Creditor0)
        else
          @index = i0
          r0 = nil
        end
      end
    end

    node_cache[:creditor][start_index] = r0

    r0
  end

  module Action0
    def creditor
      elements[0]
    end

    def gives_to
      elements[1]
    end

    def debitor
      elements[2]
    end
  end

  module Action1
    def debitor
      elements[0]
    end

    def takes_from
      elements[1]
    end

    def creditor
      elements[2]
    end
  end

  module Action2
    def content
      elements.map{|e| e.content if e.respond_to?(:content)}
    end
  end

  def _nt_action
    start_index = index
    if node_cache[:action].has_key?(index)
      cached = node_cache[:action][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_creditor
    s1 << r2
    if r2
      r3 = _nt_gives_to
      s1 << r3
      if r3
        r4 = _nt_debitor
        s1 << r4
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Action0)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
      r0.extend(Action2)
    else
      i5, s5 = index, []
      r6 = _nt_debitor
      s5 << r6
      if r6
        r7 = _nt_takes_from
        s5 << r7
        if r7
          r8 = _nt_creditor
          s5 << r8
        end
      end
      if s5.last
        r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
        r5.extend(Action1)
      else
        @index = i5
        r5 = nil
      end
      if r5
        r0 = r5
        r0.extend(Action2)
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:action][start_index] = r0

    r0
  end

  module GivesTo0
    def space1
      elements[0]
    end

    def space2
      elements[2]
    end
  end

  def _nt_gives_to
    start_index = index
    if node_cache[:gives_to].has_key?(index)
      cached = node_cache[:gives_to][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_space
    s0 << r1
    if r1
      i2 = index
      if has_terminal?("gave", false, index)
        r3 = instantiate_node(SyntaxNode,input, index...(index + 4))
        @index += 4
      else
        terminal_parse_failure("gave")
        r3 = nil
      end
      if r3
        r2 = r3
      else
        if has_terminal?("lent", false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 4))
          @index += 4
        else
          terminal_parse_failure("lent")
          r4 = nil
        end
        if r4
          r2 = r4
        else
          @index = i2
          r2 = nil
        end
      end
      s0 << r2
      if r2
        r5 = _nt_space
        s0 << r5
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(GivesTo0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:gives_to][start_index] = r0

    r0
  end

  module TakesFrom0
    def space1
      elements[0]
    end

    def space2
      elements[2]
    end
  end

  def _nt_takes_from
    start_index = index
    if node_cache[:takes_from].has_key?(index)
      cached = node_cache[:takes_from][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_space
    s0 << r1
    if r1
      i2 = index
      if has_terminal?("owes", false, index)
        r3 = instantiate_node(SyntaxNode,input, index...(index + 4))
        @index += 4
      else
        terminal_parse_failure("owes")
        r3 = nil
      end
      if r3
        r2 = r3
      else
        if has_terminal?("owe", false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 3))
          @index += 3
        else
          terminal_parse_failure("owe")
          r4 = nil
        end
        if r4
          r2 = r4
        else
          @index = i2
          r2 = nil
        end
      end
      s0 << r2
      if r2
        r5 = _nt_space
        s0 << r5
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(TakesFrom0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:takes_from][start_index] = r0

    r0
  end

  module Space0
  end

  def _nt_space
    start_index = index
    if node_cache[:space].has_key?(index)
      cached = node_cache[:space][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    if has_terminal?('\G[ \\t\\n\\r]', true, index)
      r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
      r0.extend(Space0)
      @index += 1
    else
      r0 = nil
    end

    node_cache[:space][start_index] = r0

    r0
  end

  module Amount0
    def content
      text_value
    end
  end

  def _nt_amount
    start_index = index
    if node_cache[:amount].has_key?(index)
      cached = node_cache[:amount][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('\G[\\$0-9\\.]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Amount0)
    end

    node_cache[:amount][start_index] = r0

    r0
  end

  module Joiner0
    def space1
      elements[0]
    end

    def space2
      elements[2]
    end
  end

  module Joiner1
    def content
      [:joiner, text_value.strip]
    end
  end

  def _nt_joiner
    start_index = index
    if node_cache[:joiner].has_key?(index)
      cached = node_cache[:joiner][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_space
    s0 << r1
    if r1
      if has_terminal?("for", false, index)
        r2 = instantiate_node(SyntaxNode,input, index...(index + 3))
        @index += 3
      else
        terminal_parse_failure("for")
        r2 = nil
      end
      s0 << r2
      if r2
        r3 = _nt_space
        s0 << r3
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Joiner0)
      r0.extend(Joiner1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:joiner][start_index] = r0

    r0
  end

  module Description0
    def content
      text_value
    end
    def name
    return "description"
    end
  end

  def _nt_description
    start_index = index
    if node_cache[:description].has_key?(index)
      cached = node_cache[:description][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('\G[A-Za-z0-9\\s]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Description0)
    end

    node_cache[:description][start_index] = r0

    r0
  end

end

class OweingParser < Treetop::Runtime::CompiledParser
  include Oweing
end

