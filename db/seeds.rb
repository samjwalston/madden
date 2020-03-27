# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Import::Overalls.call
Import::DevTraits.call
Import::Ages.call

Import::DraftPositions.call

Import::Archetypes.call
Import::Schemes.call
Import::SchemeArchetypes.call


# DEPRECATED - Moving to using ratings per team scheme?
# PlayerPosition.delete_all
# PlayerPosition.create([{id:"QB",rating:5},{id:"HB",rating:0.57},{id:"FB",rating:0.22},
# {id:"WR",rating:1.13},{id:"TE",rating:0.46},{id:"LT",rating:1.13},{id:"LG",rating:0.57},
# {id:"C",rating:0.68},{id:"RG",rating:0.57},{id:"RT",rating:0.91},{id:"LE",rating:0.46},
# {id:"DT",rating:0.34},{id:"RE",rating:0.46},{id:"LOLB",rating:1.59},{id:"MLB",rating:0.68},
# {id:"ROLB",rating:1.59},{id:"CB",rating:1.48},{id:"SS",rating:0.68},{id:"FS",rating:0.68},
# {id:"K",rating:0.22},{id:"P",rating:0.22}])
