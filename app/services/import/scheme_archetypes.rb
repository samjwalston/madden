class Import::SchemeArchetypes < ApplicationService
  def call
    SchemeArchetype.delete_all
    SchemeArchetype.create(values)
  end


  private

  def values
    [
      {id: 1,scheme_id: 0, archetype_id: 2},
      {id: 2, scheme_id: 0, archetype_id: 5},
      {id: 3, scheme_id: 0, archetype_id: 9},
      {id: 4, scheme_id: 0, archetype_id: 12},
      {id: 5, scheme_id: 0, archetype_id: 15},
      {id: 6, scheme_id: 0, archetype_id: 17},
      {id: 7, scheme_id: 0, archetype_id: 20},
      {id: 8, scheme_id: 0, archetype_id: 23},
      {id: 9, scheme_id: 0, archetype_id: 26},
      {id: 10, scheme_id: 0, archetype_id: 29},
      {id: 11, scheme_id: 1, archetype_id: 2},
      {id: 12, scheme_id: 1, archetype_id: 6},
      {id: 13, scheme_id: 1, archetype_id: 9},
      {id: 14, scheme_id: 1, archetype_id: 12},
      {id: 15, scheme_id: 1, archetype_id: 15},
      {id: 16, scheme_id: 1, archetype_id: 19},
      {id: 17, scheme_id: 1, archetype_id: 22},
      {id: 18, scheme_id: 1, archetype_id: 25},
      {id: 19, scheme_id: 1, archetype_id: 28},
      {id: 20, scheme_id: 1, archetype_id: 31},
      {id: 21, scheme_id: 2, archetype_id: 4},
      {id: 22, scheme_id: 2, archetype_id: 5},
      {id: 23, scheme_id: 2, archetype_id: 8},
      {id: 24, scheme_id: 2, archetype_id: 10},
      {id: 25, scheme_id: 2, archetype_id: 16},
      {id: 26, scheme_id: 2, archetype_id: 18},
      {id: 27, scheme_id: 2, archetype_id: 20},
      {id: 28, scheme_id: 2, archetype_id: 23},
      {id: 29, scheme_id: 2, archetype_id: 26},
      {id: 30, scheme_id: 2, archetype_id: 29},
      {id: 31, scheme_id: 3, archetype_id: 1},
      {id: 32, scheme_id: 3, archetype_id: 5},
      {id: 33, scheme_id: 3, archetype_id: 8},
      {id: 34, scheme_id: 3, archetype_id: 11},
      {id: 35, scheme_id: 3, archetype_id: 15},
      {id: 36, scheme_id: 3, archetype_id: 17},
      {id: 37, scheme_id: 3, archetype_id: 20},
      {id: 38, scheme_id: 3, archetype_id: 23},
      {id: 39, scheme_id: 3, archetype_id: 26},
      {id: 40, scheme_id: 3, archetype_id: 29},
      {id: 41, scheme_id: 4, archetype_id: 1},
      {id: 42, scheme_id: 4, archetype_id: 6},
      {id: 43, scheme_id: 4, archetype_id: 8},
      {id: 44, scheme_id: 4, archetype_id: 11},
      {id: 45, scheme_id: 4, archetype_id: 14},
      {id: 46, scheme_id: 4, archetype_id: 18},
      {id: 47, scheme_id: 4, archetype_id: 22},
      {id: 48, scheme_id: 4, archetype_id: 25},
      {id: 49, scheme_id: 4, archetype_id: 28},
      {id: 50, scheme_id: 4, archetype_id: 31},
      {id: 51, scheme_id: 5, archetype_id: 4},
      {id: 52, scheme_id: 5, archetype_id: 6},
      {id: 53, scheme_id: 5, archetype_id: 8},
      {id: 54, scheme_id: 5, archetype_id: 10},
      {id: 55, scheme_id: 5, archetype_id: 16},
      {id: 56, scheme_id: 5, archetype_id: 18},
      {id: 57, scheme_id: 5, archetype_id: 22},
      {id: 58, scheme_id: 5, archetype_id: 25},
      {id: 59, scheme_id: 5, archetype_id: 28},
      {id: 60, scheme_id: 5, archetype_id: 30},
      {id: 61, scheme_id: 6, archetype_id: 3},
      {id: 62, scheme_id: 6, archetype_id: 5},
      {id: 63, scheme_id: 6, archetype_id: 9},
      {id: 64, scheme_id: 6, archetype_id: 12},
      {id: 65, scheme_id: 6, archetype_id: 16},
      {id: 66, scheme_id: 6, archetype_id: 18},
      {id: 67, scheme_id: 6, archetype_id: 20},
      {id: 68, scheme_id: 6, archetype_id: 23},
      {id: 69, scheme_id: 6, archetype_id: 26},
      {id: 70, scheme_id: 6, archetype_id: 29},
      {id: 71, scheme_id: 7, archetype_id: 1},
      {id: 72, scheme_id: 7, archetype_id: 7},
      {id: 73, scheme_id: 7, archetype_id: 9},
      {id: 74, scheme_id: 7, archetype_id: 13},
      {id: 75, scheme_id: 7, archetype_id: 16},
      {id: 76, scheme_id: 7, archetype_id: 18},
      {id: 77, scheme_id: 7, archetype_id: 21},
      {id: 78, scheme_id: 7, archetype_id: 24},
      {id: 79, scheme_id: 7, archetype_id: 27},
      {id: 80, scheme_id: 7, archetype_id: 30},
      {id: 81, scheme_id: 8, archetype_id: 2},
      {id: 82, scheme_id: 8, archetype_id: 7},
      {id: 83, scheme_id: 8, archetype_id: 8},
      {id: 84, scheme_id: 8, archetype_id: 13},
      {id: 85, scheme_id: 8, archetype_id: 14},
      {id: 86, scheme_id: 8, archetype_id: 18},
      {id: 87, scheme_id: 8, archetype_id: 21},
      {id: 88, scheme_id: 8, archetype_id: 24},
      {id: 89, scheme_id: 8, archetype_id: 27},
      {id: 90, scheme_id: 8, archetype_id: 31},
      {id: 91, scheme_id: 9, archetype_id: 3},
      {id: 92, scheme_id: 9, archetype_id: 6},
      {id: 93, scheme_id: 9, archetype_id: 8},
      {id: 94, scheme_id: 9, archetype_id: 11},
      {id: 95, scheme_id: 9, archetype_id: 14},
      {id: 96, scheme_id: 9, archetype_id: 17},
      {id: 97, scheme_id: 9, archetype_id: 20},
      {id: 98, scheme_id: 9, archetype_id: 23},
      {id: 99, scheme_id: 9, archetype_id: 26},
      {id: 100, scheme_id: 9, archetype_id: 29},
      {id: 101, scheme_id: 10, archetype_id: 3},
      {id: 102, scheme_id: 10, archetype_id: 7},
      {id: 103, scheme_id: 10, archetype_id: 9},
      {id: 104, scheme_id: 10, archetype_id: 13},
      {id: 105, scheme_id: 10, archetype_id: 15},
      {id: 106, scheme_id: 10, archetype_id: 19},
      {id: 107, scheme_id: 10, archetype_id: 21},
      {id: 108, scheme_id: 10, archetype_id: 24},
      {id: 109, scheme_id: 10, archetype_id: 27},
      {id: 110, scheme_id: 10, archetype_id: 31},
      {id: 111, scheme_id: 11, archetype_id: 33},
      {id: 112, scheme_id: 11, archetype_id: 37},
      {id: 113, scheme_id: 11, archetype_id: 39},
      {id: 114, scheme_id: 11, archetype_id: 43},
      {id: 115, scheme_id: 11, archetype_id: 45},
      {id: 116, scheme_id: 11, archetype_id: 48},
      {id: 117, scheme_id: 11, archetype_id: 54},
      {id: 118, scheme_id: 11, archetype_id: 57},
      {id: 119, scheme_id: 11, archetype_id: 59},
      {id: 120, scheme_id: 12, archetype_id: 34},
      {id: 121, scheme_id: 12, archetype_id: 36},
      {id: 122, scheme_id: 12, archetype_id: 40},
      {id: 123, scheme_id: 12, archetype_id: 42},
      {id: 124, scheme_id: 12, archetype_id: 45},
      {id: 125, scheme_id: 12, archetype_id: 50},
      {id: 126, scheme_id: 12, archetype_id: 53},
      {id: 127, scheme_id: 12, archetype_id: 57},
      {id: 128, scheme_id: 12, archetype_id: 60},
      {id: 129, scheme_id: 13, archetype_id: 32},
      {id: 130, scheme_id: 13, archetype_id: 36},
      {id: 131, scheme_id: 13, archetype_id: 39},
      {id: 132, scheme_id: 13, archetype_id: 42},
      {id: 133, scheme_id: 13, archetype_id: 45},
      {id: 134, scheme_id: 13, archetype_id: 51},
      {id: 135, scheme_id: 13, archetype_id: 52},
      {id: 136, scheme_id: 13, archetype_id: 57},
      {id: 137, scheme_id: 13, archetype_id: 59},
      {id: 138, scheme_id: 14, archetype_id: 32},
      {id: 139, scheme_id: 14, archetype_id: 36},
      {id: 140, scheme_id: 14, archetype_id: 39},
      {id: 141, scheme_id: 14, archetype_id: 43},
      {id: 142, scheme_id: 14, archetype_id: 45},
      {id: 143, scheme_id: 14, archetype_id: 49},
      {id: 144, scheme_id: 14, archetype_id: 53},
      {id: 145, scheme_id: 14, archetype_id: 55},
      {id: 146, scheme_id: 14, archetype_id: 59},
      {id: 147, scheme_id: 15, archetype_id: 32},
      {id: 148, scheme_id: 15, archetype_id: 37},
      {id: 149, scheme_id: 15, archetype_id: 38},
      {id: 150, scheme_id: 15, archetype_id: 41},
      {id: 151, scheme_id: 15, archetype_id: 46},
      {id: 152, scheme_id: 15, archetype_id: 48},
      {id: 153, scheme_id: 15, archetype_id: 54},
      {id: 154, scheme_id: 15, archetype_id: 57},
      {id: 155, scheme_id: 15, archetype_id: 60},
      {id: 156, scheme_id: 16, archetype_id: 33},
      {id: 157, scheme_id: 16, archetype_id: 37},
      {id: 158, scheme_id: 16, archetype_id: 38},
      {id: 159, scheme_id: 16, archetype_id: 43},
      {id: 160, scheme_id: 16, archetype_id: 46},
      {id: 161, scheme_id: 16, archetype_id: 48},
      {id: 162, scheme_id: 16, archetype_id: 53},
      {id: 163, scheme_id: 16, archetype_id: 55},
      {id: 164, scheme_id: 16, archetype_id: 58},
      {id: 165, scheme_id: 17, archetype_id: 32},
      {id: 166, scheme_id: 17, archetype_id: 35},
      {id: 167, scheme_id: 17, archetype_id: 39},
      {id: 168, scheme_id: 17, archetype_id: 42},
      {id: 169, scheme_id: 17, archetype_id: 46},
      {id: 170, scheme_id: 17, archetype_id: 51},
      {id: 171, scheme_id: 17, archetype_id: 52},
      {id: 172, scheme_id: 17, archetype_id: 55},
      {id: 173, scheme_id: 17, archetype_id: 58},
      {id: 174, scheme_id: 18, archetype_id: 34},
      {id: 175, scheme_id: 18, archetype_id: 37},
      {id: 176, scheme_id: 18, archetype_id: 40},
      {id: 177, scheme_id: 18, archetype_id: 44},
      {id: 178, scheme_id: 18, archetype_id: 46},
      {id: 179, scheme_id: 18, archetype_id: 51},
      {id: 180, scheme_id: 18, archetype_id: 54},
      {id: 181, scheme_id: 18, archetype_id: 57},
      {id: 182, scheme_id: 18, archetype_id: 60},
      {id: 183, scheme_id: 19, archetype_id: 34},
      {id: 184, scheme_id: 19, archetype_id: 35},
      {id: 185, scheme_id: 19, archetype_id: 38},
      {id: 186, scheme_id: 19, archetype_id: 41},
      {id: 187, scheme_id: 19, archetype_id: 47},
      {id: 188, scheme_id: 19, archetype_id: 49},
      {id: 189, scheme_id: 19, archetype_id: 53},
      {id: 190, scheme_id: 19, archetype_id: 55},
      {id: 191, scheme_id: 19, archetype_id: 58},
      {id: 192, scheme_id: 20, archetype_id: 33},
      {id: 193, scheme_id: 20, archetype_id: 35},
      {id: 194, scheme_id: 20, archetype_id: 39},
      {id: 195, scheme_id: 20, archetype_id: 43},
      {id: 196, scheme_id: 20, archetype_id: 47},
      {id: 197, scheme_id: 20, archetype_id: 50},
      {id: 198, scheme_id: 20, archetype_id: 52},
      {id: 199, scheme_id: 20, archetype_id: 57},
      {id: 200, scheme_id: 20, archetype_id: 58}
    ]
  end
end
