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
 {id: 1008992256, wins: 187, losses: 102, ties: 1},
 {id: 1008992257, wins: 168, losses: 119, ties: 0},
 {id: 1008992258, wins: 145, losses: 131, ties: 2},
 {id: 1008992259, wins: 168, losses: 111, ties: 0},
 {id: 1008992260, wins: 207, losses: 84, ties: 0},
 {id: 1008992261, wins: 109, losses: 141, ties: 2},
 {id: 1008992262, wins: 132, losses: 144, ties: 0},
 {id: 1008992263, wins: 140, losses: 133, ties: 1},
 {id: 1008992296, wins: 152, losses: 126, ties: 0},
 {id: 1008992297, wins: 178, losses: 102, ties: 0},
 {id: 1008992298, wins: 170, losses: 114, ties: 0},
 {id: 1008992299, wins: 170, losses: 114, ties: 0},
 {id: 1008992300, wins: 167, losses: 111, ties: 0},
 {id: 1008992301, wins: 173, losses: 114, ties: 1},
 {id: 1008992302, wins: 153, losses: 124, ties: 1},
 {id: 1008992304, wins: 166, losses: 119, ties: 0},
 {id: 1008992306, wins: 103, losses: 87, ties: 0},
 {id: 1008992307, wins: 139, losses: 136, ties: 1},
 {id: 1008992308, wins: 135, losses: 138, ties: 0},
 {id: 1008992310, wins: 193, losses: 92, ties: 3},
 {id: 1008992311, wins: 111, losses: 88, ties: 0},
 {id: 1008992312, wins: 213, losses: 86, ties: 0},
 {id: 1008992313, wins: 140, losses: 136, ties: 0},
 {id: 1008992314, wins: 139, losses: 137, ties: 0},
 {id: 1008992315, wins: 129, losses: 60, ties: 1},
 {id: 1008992316, wins: 150, losses: 127, ties: 1},
 {id: 1008992317, wins: 155, losses: 122, ties: 0},
 {id: 1008992318, wins: 182, losses: 102, ties: 0},
 {id: 1008992319, wins: 200, losses: 91, ties: 1},
 {id: 1008992320, wins: 75, losses: 66, ties: 0},
 {id: 1008992321, wins: 162, losses: 117, ties: 0},
 {id: 1008992322, wins: 187, losses: 95, ties: 0}
])

TeamRecord.order(:id).each do |record|
  record.percentage = ((record.wins / (record.wins + record.losses + record.ties).to_d) * 100).round(1)
  record.save
end


PlayerDraft.delete_all
PlayerDraft.create([
  {id: 1, rating: 2000.0},{id: 2, rating: 1982.1},{id: 3, rating: 1964.2},{id: 4, rating: 1946.3},
  {id: 5, rating: 1928.4},{id: 6, rating: 1910.5},{id: 7, rating: 1892.6},{id: 8, rating: 1874.7},
  {id: 9, rating: 1856.8},{id: 10, rating: 1838.9},{id: 11, rating: 1821.0},{id: 12, rating: 1803.1},
  {id: 13, rating: 1785.2},{id: 14, rating: 1767.3},{id: 15, rating: 1749.4},{id: 16, rating: 1731.5},
  {id: 17, rating: 1713.6},{id: 18, rating: 1695.7},{id: 19, rating: 1677.8},{id: 20, rating: 1659.9},
  {id: 21, rating: 1642.0},{id: 22, rating: 1624.1},{id: 23, rating: 1606.2},{id: 24, rating: 1588.3},
  {id: 25, rating: 1570.4},{id: 26, rating: 1552.5},{id: 27, rating: 1534.6},{id: 28, rating: 1516.7},
  {id: 29, rating: 1498.8},{id: 30, rating: 1480.9},{id: 31, rating: 1463.0},{id: 32, rating: 1445.1},
  {id: 33, rating: 1431.0},{id: 34, rating: 1416.9},{id: 35, rating: 1402.8},{id: 36, rating: 1388.7},
  {id: 37, rating: 1374.6},{id: 38, rating: 1360.5},{id: 39, rating: 1346.4},{id: 40, rating: 1332.3},
  {id: 41, rating: 1318.2},{id: 42, rating: 1304.1},{id: 43, rating: 1290.0},{id: 44, rating: 1275.9},
  {id: 45, rating: 1261.8},{id: 46, rating: 1247.7},{id: 47, rating: 1233.6},{id: 48, rating: 1219.5},
  {id: 49, rating: 1205.4},{id: 50, rating: 1191.3},{id: 51, rating: 1177.2},{id: 52, rating: 1163.1},
  {id: 53, rating: 1149.0},{id: 54, rating: 1134.9},{id: 55, rating: 1120.8},{id: 56, rating: 1106.7},
  {id: 57, rating: 1092.6},{id: 58, rating: 1078.5},{id: 59, rating: 1064.4},{id: 60, rating: 1050.3},
  {id: 61, rating: 1036.2},{id: 62, rating: 1022.1},{id: 63, rating: 1008.0},{id: 64, rating: 993.9},
  {id: 65, rating: 983.0},{id: 66, rating: 972.1},{id: 67, rating: 961.2},{id: 68, rating: 950.3},
  {id: 69, rating: 939.4},{id: 70, rating: 928.5},{id: 71, rating: 917.6},{id: 72, rating: 906.7},
  {id: 73, rating: 895.8},{id: 74, rating: 884.9},{id: 75, rating: 874.0},{id: 76, rating: 863.1},
  {id: 77, rating: 852.2},{id: 78, rating: 841.3},{id: 79, rating: 830.4},{id: 80, rating: 819.5},
  {id: 81, rating: 808.6},{id: 82, rating: 797.7},{id: 83, rating: 786.8},{id: 84, rating: 775.9},
  {id: 85, rating: 765.0},{id: 86, rating: 754.1},{id: 87, rating: 743.2},{id: 88, rating: 732.3},
  {id: 89, rating: 721.4},{id: 90, rating: 710.5},{id: 91, rating: 699.6},{id: 92, rating: 688.7},
  {id: 93, rating: 677.8},{id: 94, rating: 666.9},{id: 95, rating: 656.0},{id: 96, rating: 645.1},
  {id: 97, rating: 637.3},{id: 98, rating: 629.5},{id: 99, rating: 621.7},{id: 100, rating: 613.9},
  {id: 101, rating: 606.1},{id: 102, rating: 598.3},{id: 103, rating: 590.5},{id: 104, rating: 582.7},
  {id: 105, rating: 574.9},{id: 106, rating: 567.1},{id: 107, rating: 559.3},{id: 108, rating: 551.5},
  {id: 109, rating: 543.7},{id: 110, rating: 535.9},{id: 111, rating: 528.1},{id: 112, rating: 520.3},
  {id: 113, rating: 512.5},{id: 114, rating: 504.7},{id: 115, rating: 496.9},{id: 116, rating: 489.1},
  {id: 117, rating: 481.3},{id: 118, rating: 473.5},{id: 119, rating: 465.7},{id: 120, rating: 457.9},
  {id: 121, rating: 450.1},{id: 122, rating: 442.3},{id: 123, rating: 434.5},{id: 124, rating: 426.7},
  {id: 125, rating: 418.9},{id: 126, rating: 411.1},{id: 127, rating: 403.3},{id: 128, rating: 395.5},
  {id: 129, rating: 390.0},{id: 130, rating: 384.5},{id: 131, rating: 379.0},{id: 132, rating: 373.5},
  {id: 133, rating: 368.0},{id: 134, rating: 362.5},{id: 135, rating: 357.0},{id: 136, rating: 351.5},
  {id: 137, rating: 346.0},{id: 138, rating: 340.5},{id: 139, rating: 335.0},{id: 140, rating: 329.5},
  {id: 141, rating: 324.0},{id: 142, rating: 318.5},{id: 143, rating: 313.0},{id: 144, rating: 307.5},
  {id: 145, rating: 302.0},{id: 146, rating: 296.5},{id: 147, rating: 291.0},{id: 148, rating: 285.5},
  {id: 149, rating: 280.0},{id: 150, rating: 274.5},{id: 151, rating: 269.0},{id: 152, rating: 263.5},
  {id: 153, rating: 258.0},{id: 154, rating: 252.5},{id: 155, rating: 247.0},{id: 156, rating: 241.5},
  {id: 157, rating: 236.0},{id: 158, rating: 230.5},{id: 159, rating: 225.0},{id: 160, rating: 219.5},
  {id: 161, rating: 216.4},{id: 162, rating: 213.3},{id: 163, rating: 210.2},{id: 164, rating: 207.1},
  {id: 165, rating: 204.0},{id: 166, rating: 200.9},{id: 167, rating: 197.8},{id: 168, rating: 194.7},
  {id: 169, rating: 191.6},{id: 170, rating: 188.5},{id: 171, rating: 185.4},{id: 172, rating: 182.3},
  {id: 173, rating: 179.2},{id: 174, rating: 176.1},{id: 175, rating: 173.0},{id: 176, rating: 169.9},
  {id: 177, rating: 166.8},{id: 178, rating: 163.7},{id: 179, rating: 160.6},{id: 180, rating: 157.5},
  {id: 181, rating: 154.4},{id: 182, rating: 151.3},{id: 183, rating: 148.2},{id: 184, rating: 145.1},
  {id: 185, rating: 142.0},{id: 186, rating: 138.9},{id: 187, rating: 135.8},{id: 188, rating: 132.7},
  {id: 189, rating: 129.6},{id: 190, rating: 126.5},{id: 191, rating: 123.4},{id: 192, rating: 120.3},
  {id: 193, rating: 118.7},{id: 194, rating: 117.1},{id: 195, rating: 115.5},{id: 196, rating: 113.9},
  {id: 197, rating: 112.3},{id: 198, rating: 110.7},{id: 199, rating: 109.1},{id: 200, rating: 107.5},
  {id: 201, rating: 105.9},{id: 202, rating: 104.3},{id: 203, rating: 102.7},{id: 204, rating: 101.1},
  {id: 205, rating: 99.5},{id: 206, rating: 97.9},{id: 207, rating: 96.3},{id: 208, rating: 94.7},
  {id: 209, rating: 93.1},{id: 210, rating: 91.5},{id: 211, rating: 89.9},{id: 212, rating: 88.3},
  {id: 213, rating: 86.7},{id: 214, rating: 85.1},{id: 215, rating: 83.5},{id: 216, rating: 81.9},
  {id: 217, rating: 80.3},{id: 218, rating: 78.7},{id: 219, rating: 77.1},{id: 220, rating: 75.5},
  {id: 221, rating: 73.9},{id: 222, rating: 72.3},{id: 223, rating: 70.7},{id: 224, rating: 69.1},
  {id: 225, rating: 67.5},{id: 226, rating: 65.9},{id: 227, rating: 64.3},{id: 228, rating: 62.7},
  {id: 229, rating: 61.1},{id: 230, rating: 59.5},{id: 231, rating: 57.9},{id: 232, rating: 56.3},
  {id: 233, rating: 54.7},{id: 234, rating: 53.1},{id: 235, rating: 51.5},{id: 236, rating: 49.9},
  {id: 237, rating: 48.3},{id: 238, rating: 46.7},{id: 239, rating: 45.1},{id: 240, rating: 43.5},
  {id: 241, rating: 41.9},{id: 242, rating: 40.3},{id: 243, rating: 38.7},{id: 244, rating: 37.1},
  {id: 245, rating: 35.5},{id: 246, rating: 33.9},{id: 247, rating: 32.3},{id: 248, rating: 30.7},
  {id: 249, rating: 29.1},{id: 250, rating: 27.5},{id: 251, rating: 25.9},{id: 252, rating: 24.3},
  {id: 253, rating: 22.7},{id: 254, rating: 21.1},{id: 255, rating: 19.5},{id: 256, rating: 17.9}
])
