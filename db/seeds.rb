# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


PlayerOverall.delete_all
PlayerOverall.create([{id:99,rating:2293.6},{id:98,rating:2176.0},{id:97,rating:2058.4},
{id:96,rating:1940.7},{id:95,rating:1823.1},{id:94,rating:1705.5},{id:93,rating:1587.9},
{id:92,rating:1470.2},{id:91,rating:1352.6},{id:90,rating:1235.0},{id:89,rating:1164.4},
{id:88,rating:1093.9},{id:87,rating:1023.3},{id:86,rating:952.7},{id:85,rating:882.2},
{id:84,rating:811.6},{id:83,rating:741.0},{id:82,rating:670.4},{id:81,rating:599.9},
{id:80,rating:529.3},{id:79,rating:494.0},{id:78,rating:458.7},{id:77,rating:423.4},
{id:76,rating:388.1},{id:75,rating:352.9},{id:74,rating:317.6},{id:73,rating:282.3},
{id:72,rating:247.0},{id:71,rating:211.7},{id:70,rating:176.4},{id:69,rating:158.8},
{id:68,rating:141.1},{id:67,rating:123.5},{id:66,rating:105.8},{id:65,rating:88.2},
{id:64,rating:70.6},{id:63,rating:52.9},{id:62,rating:35.3},{id:61,rating:17.6},
{id:60,rating:0},{id:59,rating:-17.6},{id:58,rating:-35.3},{id:57,rating:-52.9},
{id:56,rating:-70.6},{id:55,rating:-88.2},{id:54,rating:-105.8},{id:53,rating:-123.5},
{id:52,rating:-141.1},{id:51,rating:-158.8},{id:50,rating:-176.4},{id:49,rating:-211.7},
{id:48,rating:-247.0},{id:47,rating:-282.3},{id:46,rating:-317.6},{id:45,rating:-352.9},
{id:44,rating:-388.1},{id:43,rating:-423.4},{id:42,rating:-458.7},{id:41,rating:-494.0},
{id:40,rating:-529.3},{id:39,rating:-599.9},{id:38,rating:-670.4},{id:37,rating:-741.0},
{id:36,rating:-811.6},{id:35,rating:-882.2},{id:34,rating:-952.7},{id:33,rating:-1023.3},
{id:32,rating:-1093.9},{id:31,rating:-1164.4},{id:30,rating:-1235.0}])


PlayerDevTrait.delete_all
PlayerDevTrait.create([{id:3,rating:0.6},{id:2,rating:0.3},{id:1,rating:0.1},{id:0,rating:0.0}])


PlayerAge.delete_all
PlayerAge.create([{id:20,rating:4},{id:21,rating:3.6},{id:22,rating:3.2},
{id:23,rating:2.8},{id:24,rating:2.4},{id:25,rating:2},{id:26,rating:1.6},
{id:27,rating:1.2},{id:28,rating:0.8},{id:29,rating:0.4},{id:30,rating:0},
{id:31,rating:-0.2},{id:32,rating:-0.4},{id:33,rating:-0.6},{id:34,rating:-0.8},
{id:35,rating:-1},{id:36,rating:-1.2},{id:37,rating:-1.4},{id:38,rating:-1.6},
{id:39,rating:-1.8},{id:40,rating:-2},{id:41,rating:-2.2},{id:42,rating:-2.4},
{id:43,rating:-2.6},{id:44,rating:-2.8},{id:45,rating:-3},{id:46,rating:-3.2},
{id:47,rating:-3.4},{id:48,rating:-3.6},{id:49,rating:-3.8},{id:50,rating:-4}])


PlayerPosition.delete_all
PlayerPosition.create([{id:"QB",rating:1},{id:"HB",rating:0.25},{id:"FB",rating:-0.5},
{id:"WR",rating:0.3},{id:"TE",rating:0.2},{id:"LT",rating:0.15},{id:"LG",rating:0.1},
{id:"C",rating:0.12},{id:"RG",rating:0.1},{id:"RT",rating:0.15},{id:"LE",rating:0.25},
{id:"DT",rating:0.2},{id:"RE",rating:0.25},{id:"LOLB",rating:0.25},{id:"MLB",rating:0.3},
{id:"ROLB",rating:0.25},{id:"CB",rating:0.3},{id:"SS",rating:0.2},{id:"FS",rating:0.2},
{id:"K",rating:-0.5},{id:"P",rating:-0.5}])

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
