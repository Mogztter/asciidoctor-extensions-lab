require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'asciidoctor-pdf'
require 'asciidoctor-pdf/rouge_ext'

include Asciidoctor

module RawTerm
  def text
    @text
  end

  def text= text
    @text = text
  end
end

class FcnEntryTreeProcessor < Extensions::Treeprocessor
  def process doc
    (doc.find_by context: :dlist, role: 'fcnentry').each do |dlist|
      dlist.items.each do |dlist_entry|
        terms, description = dlist_entry
        term_0 = terms[0]
        term_0.extend RawTerm
        lexer = Rouge::Lexer.find 'c'
        formatter = if doc.backend == "html5"
          Rouge::Formatters::HTML.new(Rouge::Theme.find(doc.attr('rouge-style', 'github')).new)
        else
          Rouge::Formatters::HTMLInline.new(Rouge::Theme.find(doc.attr('rouge-style', 'github')).new)
        end
        newText = formatter.format(lexer.lex(term_0.text))
        term_0.text = %(<span class="rouge">#{newText}</span>)
      end
    end
  end
end

module Styles
  def read_stylesheet style
    @@stylesheet_cache[style || DEFAULT_STYLE]
  end

  private

  @@stylesheet_cache = ::Hash.new do |cache, key|
    @@stylesheet_cache = cache.merge key => (stylesheet = ((::Rouge::Theme.find key).render scope: BASE_SELECTOR))
    stylesheet
  end

  DEFAULT_STYLE = 'github'
  BASE_SELECTOR = 'span.rouge'

  private_constant :BASE_SELECTOR
end

class FcnEntryDocinfoProcessor < Extensions::DocinfoProcessor
  include Styles
  use_dsl

  def process doc
    %(<style>
#{read_stylesheet nil}
  </style>)
  end
end

