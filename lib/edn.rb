$:.push(File.dirname(__FILE__))
require 'edn/version'
require 'edn/core_ext'
require 'edn/types'
require 'edn/metadata'
require 'edn/char_stream'
require 'edn/parser_common'
require 'edn/parser'
require 'edn/ragel_parser'
require 'edn/reader'
require 'edn/edn_ragel'

module EDN

  # tagged element registered items
  @tags = {
    # built-in elements
    "inst" => lambda { |*a| DateTime.parse(*a) },
    "uuid" => lambda { |*a| String.new(*a) }
  }

  def self.read(edn, eof_value=NOTHING)
    EDN::Reader.new(edn).read(eof_value)
  end

  def self.register(tag, func = nil, &block)
    # don't allow re-registration of built-in tags
    return if tag == "inst" && tag == "uuid"

    if block_given?
      func = block
    end

    if func.nil?
      func = lambda { |x| x }
    end

    if func.is_a?(Class)
      @tags[tag] = lambda { |*args| func.new(*args) }
    else
      @tags[tag] = func
    end
  end

  def self.unregister(tag)
    @tags[tag] = nil
  end

  def self.tagged_element(tag, element)
    func = @tags[tag]
    if func
      func.call(element)
    else
      EDN::Type::Unknown.new(tag, element)
    end
  end

  def self.tagout(tag, element)
    ["##{tag}", element.to_edn].join(" ")
  end

  def self.symbol(text)
    EDN::Type::Symbol.new(text)
  end

  def self.list(*values)
    EDN::Type::List.new(*values)
  end

  def self.set(*values)
    Set.new(*values)
  end


  #
  # moved from read_meta() in parser.rb
  def self.extend_for_meta(value, rev_raw_metadata)
    metadata = rev_raw_metadata.reduce({}) do |acc, m|
      case m
      when Symbol then acc.merge(m => true)
      when EDN::Type::Symbol then acc.merge(:tag => m)
      else acc.merge(m)
      end
    end

    if !metadata.empty?
      value.extend Metadata
      value.metadata = metadata
    end

    value
  end


end
