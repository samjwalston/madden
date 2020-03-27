class Import::Schemes < ApplicationService
  def call
    Scheme.delete_all
    Scheme.create(values)
  end


  private

  def values
    [
      {id: 0, name: "West Coast Zone Run"},
      {id: 1, name: "West Coast Power Run"},
      {id: 2, name: "Vertical Zone Run"},
      {id: 3, name: "Multiple Zone Run"},
      {id: 4, name: "Multiple Power Run"},
      {id: 5, name: "Vertical Power Run"},
      {id: 6, name: "Spread"},
      {id: 7, name: "Run and Shoot"},
      {id: 8, name: "Air Raid"},
      {id: 9, name: "Pistol"},
      {id: 10, name: "West Coast Spread"},
      {id: 11, name: "Base 4-3"},
      {id: 12, name: "4-3 Under"},
      {id: 13, name: "Base 3-4"},
      {id: 14, name: "3-4 Under"},
      {id: 15, name: "Tampa 2"},
      {id: 16, name: "4-3 Quarters"},
      {id: 17, name: "Disguise 3-4"},
      {id: 18, name: "3-4 Storm"},
      {id: 19, name: "4-3 Cover 3"},
      {id: 20, name: "46 Defense"}
    ]
  end
end
