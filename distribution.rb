require 'nokogiri'
require 'unicode'
require_relative 'plotter'

class String
  def downcase
    Unicode::downcase(self)
  end

  def sanitize
    self.split.collect do |token|
      token.downcase.gsub(/[^-A-Za-zА-Яа-я0-9]/, '')
    end
  end
end

module Zipf
  class Distribution
    include Zipf::Plotter

  B = 1.15 #1.2 for IOG, 1.15 for AK and O
  P = 10 ** 5 #10**5 for IOG, 10**5 for AK and O
  Ro = 0 #0 for IOG, 0 for AK and O

  def initialize(filename)
    @filename = filename
  end

  def text
    @text ||= Nokogiri::HTML(File.open(@filename)).css('dd').text.sanitize
  end

  def frequency
    @freq ||= begin
      freq = Hash.new(0)
      text.each do |word|
      if !(word.include? '--') and (word != '')
        freq[word] ||= 0
        freq[word] += 1
      end
      end
    Hash[freq.sort_by { |k, v| -v}]
    end
  end

  def ranks
    @ranks ||= begin
      ranks = {}
      rank = 1
      frequency.each do |k, v|
        ranks[k] = rank
        rank += 1
      end
      ranks
    end
  end

  def probability(word)
    frequency[word].to_f / frequency.keys.length
  end

  def zipf_const()
    @zipf ||= begin
      zipf = {}
      frequency.each do |k, v|
        zipf[k] = Math::log(v * ranks[k])
      end
      zipf
    end
  end

  def mandelbrot_const
    @mandelbrot ||= begin
      mandelbrot = {}
      frequency.each do |k, v|
        mandelbrot[k] = Math::log(P) - B * Math::log(ranks[k] + Ro)
      end
      mandelbrot
    end
  end

  end
end

start = Time.now

test = Zipf::Distribution.new(ARGV[0])
#p test.frequency
#p test.ranks
#p test.zipf_const.values
test.plot_ranks_frequency('test.png')

finish = Time.now
puts finish - start