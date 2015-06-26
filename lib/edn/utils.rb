#require 'stringio'
#require 'set'

#puts __FILE__

module EDN
  def self.resolve_metadata(raw_metadata)
    metadata = raw_metadata.reverse.reduce({}) do |acc, m|
      case m
      when Symbol then acc.merge(m => true)
      when EDN::Type::Symbol then acc.merge(:tag => m)
      else acc.merge(m)
      end
    end
    metadata.empty? ? nil : metadata
  end


  # my version of this method -ep
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
