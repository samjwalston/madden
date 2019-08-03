# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


PlayerOverall.delete_all
PlayerOverall.create([{id:99,rating:2293.6},{id:98,rating:1790.7},{id:97,rating:1505.7},
{id:96,rating:1316.3},{id:95,rating:1118.4},{id:94,rating:989.2},
{id:93,rating:871.3},{id:92,rating:735.2},{id:91,rating:664.1},
{id:90,rating:596.7},{id:89,rating:522.7},{id:88,rating:463.9},
{id:87,rating:419.3},{id:86,rating:376.6},{id:85,rating:335.4},
{id:84,rating:300.4},{id:83,rating:270.0},{id:82,rating:246.6},
{id:81,rating:224.1},{id:80,rating:207.2},{id:79,rating:192.8},
{id:78,rating:179.4},{id:77,rating:167.3},{id:76,rating:155.5},
{id:75,rating:144.3},{id:74,rating:133.4},{id:73,rating:123.0},
{id:72,rating:112.8},{id:71,rating:102.9},{id:70,rating:93.2},
{id:69,rating:84.8},{id:68,rating:77.5},{id:67,rating:70.0}])


PlayerDevTrait.delete_all
PlayerDevTrait.create([{id:3,rating:0.6},{id:2,rating:0.3},{id:1,rating:0.05},{id:0,rating:-0.2}])


PlayerAge.delete_all
PlayerAge.create([{id:20,rating:4.2},{id:21,rating:3.3},{id:22,rating:2.4},
{id:23,rating:1.5},{id:24,rating:0.6},{id:25,rating:0.3},
{id:26,rating:0},{id:27,rating:-0.03},{id:28,rating:-0.1},
{id:29,rating:-0.2},{id:30,rating:-0.3},{id:31,rating:-0.45},
{id:32,rating:-0.6},{id:33,rating:-0.8},{id:34,rating:-1},
{id:35,rating:-1.2},{id:36,rating:-1.4},{id:37,rating:-1.5},
{id:38,rating:-1.55},{id:39,rating:-1.6},{id:40,rating:-1.63}])


PlayerPosition.delete_all
PlayerPosition.create([{id:"QB",rating:1.6},{id:"HB",rating:0.25},{id:"FB",rating:-0.65},
{id:"WR",rating:0.27},{id:"TE",rating:0.21},{id:"LT",rating:0.17},
{id:"LG",rating:0.1},{id:"C",rating:0.13},{id:"RG",rating:0.1},
{id:"RT",rating:0.1},{id:"LE",rating:0.27},{id:"DT",rating:0.22},
{id:"RE",rating:0.29},{id:"LOLB",rating:0.22},{id:"MLB",rating:0.29},
{id:"ROLB",rating:0.27},{id:"CB",rating:0.25},{id:"SS",rating:0.21},
{id:"FS",rating:0.19},{id:"K",rating:-0.85},{id:"P",rating:-0.9}])

TeamRecord.delete_all
TeamRecord.create([
 {id: 778043392, wins: 187, losses: 102, ties: 1},
 {id: 778043394, wins: 168, losses: 119, ties: 0},
 {id: 778043395, wins: 145, losses: 131, ties: 2},
 {id: 778043396, wins: 168, losses: 111, ties: 0},
 {id: 778043397, wins: 207, losses: 84, ties: 0},
 {id: 778043398, wins: 109, losses: 141, ties: 2},
 {id: 778043399, wins: 132, losses: 144, ties: 0},
 {id: 778043400, wins: 140, losses: 133, ties: 1},
 {id: 778043401, wins: 152, losses: 126, ties: 0},
 {id: 778043402, wins: 178, losses: 102, ties: 0},
 {id: 778043403, wins: 170, losses: 114, ties: 0},
 {id: 778043404, wins: 170, losses: 114, ties: 0},
 {id: 778043405, wins: 167, losses: 111, ties: 0},
 {id: 778043406, wins: 173, losses: 114, ties: 1},
 {id: 778043407, wins: 153, losses: 124, ties: 1},
 {id: 778043409, wins: 166, losses: 119, ties: 0},
 {id: 778043411, wins: 103, losses: 87, ties: 0},
 {id: 778043412, wins: 139, losses: 136, ties: 1},
 {id: 778043413, wins: 135, losses: 138, ties: 0},
 {id: 778043416, wins: 193, losses: 92, ties: 3},
 {id: 778043417, wins: 111, losses: 88, ties: 0},
 {id: 778043418, wins: 213, losses: 86, ties: 0},
 {id: 778043419, wins: 140, losses: 136, ties: 0},
 {id: 778043420, wins: 139, losses: 137, ties: 0},
 {id: 778043421, wins: 129, losses: 60, ties: 1},
 {id: 778043422, wins: 150, losses: 127, ties: 1},
 {id: 778043423, wins: 155, losses: 122, ties: 0},
 {id: 778043424, wins: 182, losses: 102, ties: 0},
 {id: 778043425, wins: 200, losses: 91, ties: 1},
 {id: 778043426, wins: 75, losses: 66, ties: 0},
 {id: 778043427, wins: 162, losses: 117, ties: 0},
 {id: 778043428, wins: 187, losses: 95, ties: 0}
])
