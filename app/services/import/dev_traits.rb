class Import::DevTraits < ApplicationService
  def call
    DevTrait.delete_all
    DevTrait.create(values)
  end


  private

  def values
    [
      {id: 3, rating: 9.00},
      {id: 2, rating: 3.00},
      {id: 1, rating: 1.00},
      {id: 0, rating: 0.00}
    ]
  end
end
