class Import::Ages < ApplicationService
  def call
    Age.delete_all
    Age.create(values)
  end


  private

  def values
    [
      {id: 20, rating: 10.00},
      {id: 21, rating: 7.98},
      {id: 22, rating: 6.80},
      {id: 23, rating: 5.96},
      {id: 24, rating: 5.31},
      {id: 25, rating: 4.78},
      {id: 26, rating: 4.33},
      {id: 27, rating: 3.94},
      {id: 28, rating: 3.60},
      {id: 29, rating: 3.29},
      {id: 30, rating: 3.02},
      {id: 31, rating: 2.76},
      {id: 32, rating: 2.53},
      {id: 33, rating: 2.31},
      {id: 34, rating: 2.11},
      {id: 35, rating: 1.93},
      {id: 36, rating: 1.75},
      {id: 37, rating: 1.58},
      {id: 38, rating: 1.43},
      {id: 39, rating: 1.28},
      {id: 40, rating: 1.13},
      {id: 41, rating: 1.00},
      {id: 42, rating: 0.87},
      {id: 43, rating: 0.75},
      {id: 44, rating: 0.63},
      {id: 45, rating: 0.51},
      {id: 46, rating: 0.40},
      {id: 47, rating: 0.30},
      {id: 48, rating: 0.20},
      {id: 49, rating: 0.10},
      {id: 50, rating: 0.00}
    ]
  end
end
