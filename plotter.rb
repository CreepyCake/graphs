require 'gruff'
module Zipf
  module Plotter
    def plot_ranks_frequency(output)
      labels = []
      data = []
      zipf = []
      mandelbrot = []

      frequency.each_with_index do |(k, v), i|
        labels << i
        data << Math::log(v)
        zipf << zipf_const[k]
        mandelbrot << mandelbrot_const[k]
      end

      plot(data, zipf, mandelbrot, labels, 'Charts', output)
    end

    private
    def plot(data, zipf, mandelbrot, labels, title, output)
      graph = Gruff::Line.new

      graph.title = title
      graph.theme = Gruff::Themes::GREYSCALE
      graph.dataxy('Text', labels, data, '#f61100')
      graph.dataxy('Zipf constant', labels, zipf, '#FDD84E')
      graph.dataxy('Mandelbrot constant', labels, mandelbrot)
      graph.labels = {1000 => '1000', 10000 => '10000', 25000 => '25000'}

      graph.write(output)
    end
  end
end