class ApplicationService
  def self.call(*args)
    new.call(*args)
  end


  protected

  def gaussian(mean, stddev, rand = lambda { Kernel.rand })
    mean + (stddev * Math.sqrt(-2 * Math.log(1 - rand.call))) * Math.cos(2 * Math::PI * rand.call)
  end
end
