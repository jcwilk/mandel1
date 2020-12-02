pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
iterations=100
cutoff=2
camx=-.5
camy=0
cam_width=2
colors={1,2,5,4,3,13,9,8,14,6,15,12,11,10,7}
zoom_ratio=1.025
move_amount=1/32

function mandel(screenx,screeny)
 local x=(screenx/63.5 - 1)
 local y=(screeny/63.5 - 1)
 x=camx + x*cam_width/2
 y=camy + y*cam_width/2
 local zx=0
 local zy=0
 for i=1,iterations do
  if abs(zx)+abs(zy) > cutoff then
   return colors[1+flr(i/iterations*15+rnd()-.5)]
  end
 
  local next_zx = zx*zx-zy*zy + x
  local next_zy = 2*zy*zx + y
  zx = next_zx
  zy = next_zy
 end
 
 return 0
end

function _init()

end

function _update60()
 if moved then
  return
 end
 
 if btn(0) then
  moved=true
  camx-=cam_width*move_amount
 end
 if btn(1) then
  moved=true
  camx+=cam_width*move_amount
 end
 if btn(2) then
  moved=true
  camy-=cam_width*move_amount
 end
 if btn(3) then
  moved=true
  camy+=cam_width*move_amount
 end
 if btn(4) then
  moved=true
  cam_width/=zoom_ratio
 end
 if btn(5) then
  moved=true
  cam_width*=zoom_ratio
 end
end

redraw_steps={
 {0,1},
 {1,0},
 {1,1}
}
max_draw_width=16 // must be power of 2
sweep_divides=4
draw_width=max_draw_width
moved=true
function _draw()
 if moved then
  co_draw=cocreate(co_draw_f)
 end
 if costatus(co_draw) != "dead" then
  assert(coresume(co_draw))
 end
 //rectfill(0,0,20,6,0)
 //print(stat(7),0,0,7)
end

function co_draw_f()
 cls()
 moved=false
 draw_width=max_draw_width
 
 for x=0,127,draw_width do
  for y=0,127,draw_width do
   if stat(1) > 0.95 then
    yield()
   end
   rectfill(x,y,x+draw_width-1,y+draw_width-1,mandel(x,y,0,0,iterations))
  end
 end
 
 draw_width/=2
 redraw_i=1
 redraw_col=0
 redraw_row=0
 
 while draw_width >= 1 do
  local step=redraw_steps[redraw_i]  

  for s=0,sweep_divides-1,1 do
   local xoff=(2*s+step[1])*draw_width
   local yoff=(step[2])*draw_width
   for x=xoff,127,draw_width*2*sweep_divides do
    for y=yoff,127,draw_width*2 do
     if stat(1) > 0.95 then
      yield()
     end
     rectfill(x,y,x+draw_width-1,y+draw_width-1,mandel(x,y,0,0,iterations))
    end
   end
  end
  redraw_i+=1
  
  if redraw_i > #redraw_steps then
   redraw_i=1
   draw_width/=2
  end
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
a098dddd99009b7e88999888ec0eeeefb077b00000fcc00000bf66660b00cc000000cff7066666ee66666666f6ffc000000070000000000066f66f6060f60000
f069ddd3d909d060a89998988eceeee0c00bcc000000b0000bcf66f60cfccca00000affc0b66eee66e6666666f6cf0000000000000000000c66666ee666c0700
98099dddddddd999999998988888eee666a0cfc00070b0000000fff6f0ffcb0000000cc000666eee66ee6e66fff00c00000000000000000666666ee6e6070c00
d6afddddd3dddd9999d9888888e888eee60cff0a0007707a0000f6ffffcfb0000000bbba0ccc766eee6666666cfa00aa00000000000000f6666666eee6f0f000
330d3d33ddddd9999d9900e88888ee6666006ff00000000bbccfffffffffcb0000000bcb70070666ee6666666c0a0007000000000000000f666666e6eeeee006
336d3333d3ddddd9d9900c60beeee00ee666f6f0b0707000bb0aff6fffffb0000000a00000000f066666666f6fa0000000000000070000ff666666e6eeeee60e
33333d333d3d0907888700afeee0000c66f6f66fcc7a00000b0bb0f0fffc000000077000000000066666666f0b0000000000000007b0a066666c0a6eeeeee88e
33d33333330c000c88e70aa0600000770666fffcf00b00000ba0000bcfffc0000000000000000afff66666000000000000000000000bcf6ff66f70eeeee888ee
3333333333d00b0e880f0bff660b707cff0f0ffff0bb000000000000bfcc0000000000007000000f66f666faa0000000000000000000fcfffffca0c6eee88ee8
333333d33ddf0a0f8e6bf00cfff00abcb00000fffcbcc0000000000acfc700070000007aa00abc0f6666fffc07000000000000000a00fffcc00cb0abee88e8e8
33333d33dd0c00066ef0b00000aa00bcc00000ccccccb00000007000bccc0a00a7000007b0000cf6ff6f6f6fc0000000000070000aacfffc00000000eee88eee
333333dd3ddbcb0c00a0aa0000000000aa00000ccccccb00000070a7bccc0bbaa000000bb00a07ffffff6fff0a0000000007a700bbccccf0ba00b006eee8ee88
3433333d3dd008b0a700acf0f00ab0000000abac7bbbbb007000aa0bbbccbbbb0000000bbcb000ff6fff000c00000000077a7aabbbbccccbc000f0eeeee88e88
33333333dddd8800eeeef0ff60f0bca000000b00000bba0a70000a0bbccccbb00000000bbcccffffffff000a00070000007700abba0b07ccb0000f6eee8e8e8e
34333d3d3d3d99900eeee6f6f6f0ccca00000000000bbaaaa00007000bbbbba00000000ab0cfccfffffcb00000770000000000000a00000ba7000c0666ee888e
3343d0d09dddd99998eeee66ff6fcfcb00700000007abbaaa000000000abba00000000ab000cfccffff0000077a00000000000000770000ab00000b6e00ec8e8
3333d9068609d8a88ee06666a0ffccccb0aa0000007a0aaa70000000000bbbb00000000770bcfffffcf0bb0007ba0000000000000000007a7a00a0a76f00e88e
433ee7caec8d000b8e000f60000fcb0bbbaa7000000000aaa000000000baab070000000000000ffffffccccb7bbaa000000000000000000007000070c0000e88
3306b0000f8bf000e7000f0000bc0070bbbaa000000000777000000000aaaa00000000000000bcfffffccfccbbbab070000000000000000000000000a0ffee88
333d0bb06e8867c6ef0aacca00aa00070007a770000000077000000007aaa070000000000000baccffffffcbbb00aaa00000000000000000000000000cfeee88
333d96f0fee7bc00b00000000000000700007777000000007000000007aaaa7770000000000000cfcffccccc000000000000000000000000000000000006e88e
33dd6e86a07a00c0000b7000a000000000007000000000000000000000aaa7770000000000000cccfcffcc00700000000000000000000077000000007c6eee88
3dd9e8e07ca0c00667f0fc000ab00000000000000000000000000000000a77a70000007700000bcfcfccccb0000000000000007a007baaa000000000006e6eee
ddd30990ce88e00e66f0ffcc7bba0770000000000000000000000000000777000000007a000bccccccc070000000000000000077aabaa770000000000b606eee
dd3ddd99a7e888e6666fffccccbaaa770000000000000000000000000007aa0000000077a000bccbbcba000000000000000000000abb000000000000ac0c0068
dddddd999988eeeeeffffb07b000a7070000000000000000000000000077700000000070baaccbcccccb0000000000000000000000bbb000000000000000006e
faddd9989998be6e00acf000700070000000000000000000000000000007000000000000abbbcbccbbc0000000000000000000a00bcbb000070000a770c00fee
08ddb00608e00760007ba00700000000000000000000000000000000000000000000000aaabcbcbc0000000000000000000000acccca0a0007a00070fff60ee8
899960a06800bcffc00000000000000000000000000000000000000000000000000000000ccbbb0000000000000000000000007cfccb000000b000000f666eee
e99ff0f6666c0770000000007000000000000000000000000000000000000000000000000bccbb707000000000000000000000bcccca000000cc0000000e6e8e
8888eccc660a000000ab0a077770000000000000000000000000000000000000000000000abcbbbaa00700000000000000000bcfffc0000a007cfc0000666eee
8888f00000000c0ccbabbbbaa070000000000000000000000000000000000000000000007abbbbbaaa077000000000000007afccffffbc0b0000f6600006eeee
e08f00a00f0aa0fffcccbbaa0000000000000000000000000000000000000000000000000abababaaa7770000000000000a0bcfcfffffccca0bba66fffeeeee8
70a00a06ce6600ffccfcc00a00000000000000000000000000000000000000000000000aabbabbbbaaa000000000000000bcbcccfcfffca000a00666606eeeee
00ee6a066e666f6f000a000000000000000000000000000000000000000000000007a7aaabbaaaa70000000000000777aabcb0bc0cff6f00700c66666eeeeeee
608eee70eee6666f000a7000000000000000000000000000000000000000000000077aaaabba00000000000000000070aba700000ffffff00000f66eeeeeee6e
e8988888ee60f0fc0077000000000000000000000000000000000000000000000000a7aaa0aaa000000000000000000000bb7000af6fff00ccffeee66eeeeeee
68898888ee60a0cca0000000000000000000000000000000000000000000000000077a7a00070000000000000000000000a0000000f6666ffbf666eeee6eeeee
09998eef6e600bbb00007a077000000000000000000000000000000000000000000077a000000000000000000000000000700070b6ff6666f666ee66e6eeeeee
9999e60a0e7b0a00000aaaa7700000000000000000000000000000000000000000077777700000000000000000000000000000cc666f66666e6e66e6ee6ee6ee
99998000c6fca0000aa7aa0000000000000000000000000000000000000000000007777700000000000000000000000000000a006f66ff666eeeee6ee6eeee6e
d988b0000ff00000cbbbba000000000000000000000000000000000000000000070077777000000000000000000700000000000fff666666666e66eeee66666e
0c88000c0f00000bccbba7000000000000000000000000000000000000000000000700000000000000000000000770000000000baf666666666e6e66eee66eee
6e8ab0b00000c00bcf0007000000000000000000000000000000000000000000000000000000000000000000a0aa70000000000070ff666666e666666ee66eee
a088e00a00bfffcfcc0000000000000000000000000000000000000000000000000000000000000000000000abaa70000000000bfc66666666e66666e6e6eeee
c08e0000aff6fffcfcb0000000000000000000000000000000000000000000000000000000000000000000baaaa00000000000000f6666666e66666e6e6ee6ee
66e0a007b7f6f6ff0b000007700000000000000000000000000000000000000000000000000000000007aabbba700000000000bf66666666666ee66e6e66e606
6cfb70000a066f000bb000077000000000000000000000000000000000000000000000000000000000777bbabcb0000000000a0cff6666666e666e666ee6670b
0c00006e66c66f000aa00007a7000000000000000000000000000000000000000000000000000000000700a0bbb00007700000706fe66666666e66666e666fbb
0b006cfe66666f0000007baa0000000000000000000000000000000000000000000000000000000000000000bca07000a000cc00f666666666666e6bb0c60000
0c06eeeeee66ff0a7000bbaa000000000000000000000000000000000000000000000000000000000000000bbba0000ac0070f00f666666e6666666f00afba00
006eeee8ee60bfcc000aaab00000000000000000000000000000000000000000000000000a7700000000abbcccb00000fc00fff6666666666666666c000a0000
bcb76eee860ba0cc00007bb00000000000000000000000000000000000000000000000007770000000000ccccc0a00bccf00fff6f6f6f66666666f0000000000
ccbf0e88e0007bc0000bcbba0000000000000000000000000000000000000000000000000a7000000000abcffff0ccccccff6ff66666f6f66f6660a00b070aa0
ae0078ee87000a00000ccb0a700000700000000000000000000000000000000000000000aa700000000000ccccfffffffff6fff6666666f6f666f600cc00b000
e88b8e8e8fa000000bcccb00a0000770000000000000000000000000000077000000007aaa7000000000c0cfcccffcffff66fff666f666f6ffff660cfffccb00
8888888eee0bb007bcccc0000000777000000000000000000000000000007700000000abaa70000000acccfcfcffffffff6f66666f6f6f6666f6ff6fffcfc0b0
888998e0eecf000a0cccc00000007aa00000000000000000000000007777a7a00000a7aaab00ba00a70ccccccccfffffffffff66f6666f6ff6f66f6f6fcb0000
88898ef06666000707fffca000000aaa70000000000000000000000077777aaa7070aabbbbbbbbb0bb0ccfcccffcfcffffff6fff666f6f6f66f66fffffcc0000
99880060b06f0000ccfffc0000000aaa7700000007000000000000007777777aaaaaaabbbbbbcbcbbcccfcfccccfccfcfff6fffffff6f6f66ff6f66ffff00000
8899ef0b006f00bf66ff0cbb000abba0000000000070000000000000700007a7aabbabbbbbbcbbbccccccffcccccfffffff6f66f666f6f6f66666fffffc00007
9989c7007f07007c6f6f000b000abbb70000000007700000000000000700077aaaababbbbbbbcbcbcbcccccffcffcffffffffff66f666f66f6f6fffffffffa00
99999000bca000f666f000a00000bba0000000000777000000000000000000a7aaaabbbbbcbbbbbbccbcfcccfccc0ccccbffffff6f0f6fff6f6f66fffffcf000
99990c0a0000006666f00070000bbbb0000000007aa00000000000000000007aaabbbbaaabbccbccccccccccccc700ccb0cfff6fff00ffffff666ffffffff00a
999999e00cb0cf666e60000000abbccbb07000007aaa0000000000000000007700abaab000aabbbbcccccbcccc0000b000fffffff000cffffffffffffffcfac0
9dd998006f00c0f06e6fcba0000a0ccbba77000007aaaa0a0700000000000000007aaaa70007bcbbcccccccccc0a0000000ccfffc000ccfffc0c0ffffcffcccb
d9d9980ee000ac06666600c00000bccc0b7000000aaaabaa77000000000000000070aaa70000abbcbcccccccbbbb0000000cfcfccc00000ff000bcfffffccffc
dd9098888e70ae6eee66ffc000aacfc0007000000aaabaaa00000000000000000000aa700000abcba0bcccccbccbaa00007bcc00cb000700c000cfccffcfffcc
ddd0088e8eb066eeee6c0cc0000cccc070000000a70aabb7000000000000000000007700000a00aa00bbccccccca000000bbba07a00000000a00ba00cccccffc
ddd8fcbe860000eee0c0ac00000fffcb00000000000aabaaa0000000000000000000a700000070a0000cbccccbb00000000bbb00000000000000000acffcfccc
9be0f0f6c000ee888f000b7000ccfcc0000000000000abbb00000007000000000000007000000000000b00bbcbb0000000000a70000000000000007acccccfcc
d77c000f6f00ee8e8e00a00000ccffffc0070000000bbbbba0000007a0000000000000000000000000000abbbbb0000000000000000000000000000b0a00cccc
d9c00ab6000ceee88ef70a70acccffffcc0a0000000bbbbbb000070aaa000000000000000000000000000a7bcb00070000000000000000000000000ba0000cbc
007000b006b00098888af0000b07fff6fc0cb00000a0bbbcccb0cb00baa7000000000000000000000000000aaba0aa70000000000000000000000070000000bc
dd8000b006b0898888ef6b00707b66fffcccb7000000bccbccbcbcbbaaaa00000000000000000000000000aabaaaaaa700000000000000000000000000000bbc
d360fffbe889999900ee6f000cc066f60000ba00000bcbbccccccbbab07777000000000000000000000000007aaaaa77700000000000000000000000007a0bcb
ddd070960899d990e0066fb000666666b00ab0000000bcbccccccb70000070000000000000000000000000000aaba0777770000000000000000000000000abbb
3336dd900e9999900cb6ff00ab6666600000a700000bbb0bbccff70000000000000000000000000000000000a7a000007070000000000000000000000007abbb
33d3ddd0c0dddd0b070f00000b0666600000000000aa0b00cfcfc00000000000070000000000000000000007777000000000000000000000000000000000abba
33dddd3ddddddd0000bc00000066e6600000000000aa000acfcfccca700000000770000000000000000000077000000000000000000000000000000000000aba
33d33dddddddd90f700000700bee666ec0000a70000000000ccfcc0a000000000a0000000000000000000007700000000000000000000000000000000000aaaa
dddd33dddddddd98a60ca0b0666eeeee6f00cb0000000000cfffff0000000007aba000000000000000000000000000000000000000000000000000000000abba
3333333dddd9d9dbbfe0000fcf66eeeee600cc0000000bbffffcfffc0000000000cb0000000000000000000000000000000000000000000000000000777aaaa7
3333d333ddd9099808e000bc0aa7eeee6660ffc00000000ccffffff00c0700b70bccc00b0000000000000000000000000000000000000000000000077aaa7aa7
333ddddddd80f09988800000c0aeeeee6666f600000000bcffffffffffc7cfc07accccbb00007000000000000000000000000000000000000000000777aa7777
33333d7e8d000e89888c0bc0000ee8e6cfffffcb00000070cff6fff6fff0ff6bc0cccccc00007000000000000000000000000000000000000000000777700000
333d3dd0089c607088ee70b06e888eee0000cff00000000a0ff6fff66666fffffcccccccb0aaa000000000000000000000000000000000000000000707000000
333dddd06aee0000e8ea0000ee888eeef7000cc000000000ffffff66666fff6fffccbccbbbaa7000000000000000000000000000000000000000000777000000
3333009e0600f00bee06cb00eee888e7cba00ccba000000ccf6f66ff666ff6fffffc000bbbab0000000000000000000000000000000000000000000000000000
33d0060f0ab0c0b666c0b0000ee8888000700bb000000000ffff6fff6f666ff0c0bb0000bbba0000000000000000000000000000000000000000000000000000
33ddb9077000b0076efb000088888eef7000aa00000000bfffffff6f66666600000b007000aa0000000007700000000000000000000000000000000000000000
3333dd000000a0f6600bb00fe888880000007700000aa0cccffb0ff6666666000000000000770000000007700000000000000000000000000000000000000000
44ddd9e7000000f00000000088888988f000000070000bccc0fcb00f666666f00000000000077000000a77000000000000000000000000000000000000000000
433ddcf00000abc000000c6ee8899898000bc0c0aa000bca00aa00f66666666f0b0a070000070000007aa0000000000000000000000000000000000000000000
34d3d96f000000000e60ba6cfe8998888860ff0000000aab000a0ff66ee6666ffccc00000000000007ab00000000000000000000000000000000000000000000
3333fa0ef00b60f06ec00aa000e99988880076f00000aaa000000bf666e66666ff0a000000000000000ba0000000000000000000000000000000000000000000
334dabb80bf0f6ef8800006f099989898e60eef00000a700070000066ee666e6f70000000000000000cb00000000000000000000000000000000000000000000
333d009ddeae0ce888800099999998898886ee60000077000c0000666666ee6a07000000000000a00ccc0b000000000000000000000000000000000000000000
333d3d83dded7ea0c999999999d989e0e8eeee60070000000c00666e666e6ee000fb0000000007aacbcfc0000000000000700000000000000000000000000000
33333d3d3ddd0f0a09dddddd99999907feeee6660a0000000cf666ee66e666e66ff00000000000000b0fffc00000000000770000000000000000000000000000
3333333333d0a70e89dd9d9d9999886b670be6e6ff700007bc0f66666e66eeee6607ba00000a000000ccff00c0000000007a7000000000000000000000000000
333333333dd00066e99d9ddddd9006e0000b666000000000000f66666e6eeee6ef00600000a00fc7000ff6fff00007000077aa0a007000000000000000000000
333333d3333306c6b09dd9ddd996000fb00066f00000000000cf6fee66ee6eeee6b66e0c0c00f6a00acf6fff6c0c0bc7000aaabaa77000000000000000000000
3333333333d9e990099ddddddd0ebc07c0cfff0b000a7700000af0666eeee6eeeeeee6e6a06666000bffff666fffcc0a0007abaa770000000000000000000000
3333333333d3dddd0dddddddd000b000a000f6ff0bba000000000006666eeeeee6eeeeea0b66e6c0ba0fff6ffffff0000000bbb0000000000000000000000000
433333333333d33dddddddd3dd90000000abfffcbc0000000000cf6eeeeeeeeeeee8eeee06eeee666606f66f6ff6fc007a0bbba0000000000000000000000000
3334333d33333dd3dd3ddddddd900000007ffc0000000000000006eeee6eee6eee88eeeeeeee6e66e66666f666fffff70bbbbb00000000000000000000000000
333333333333d3dd33dddddddd9000000abb0c0000000000000c66eeeeeeeeeeeeeee888eeeeeee66666666666fffffa00bccb70000000000000000000000000
3333333333333333d3d33dddd906c000700b0000000770000000c6eeee6eee8e8eeeee8eeeeeeee6eee66666ffffffccfcccc000000000000000000000000000
33333333333d3dddd3ddddddd90e8c0b000000070007a00707cc06eeeeeeeee8eeeeeee8eeeeeeeee666666cc0cfffcffccccb00000000000000000000000000
4333333333333333333ddddddd9906ccfc000c000007b000bb0666e66eeeeee8eeeee8e8eeeeeeeeee6666000000fffcfcccc000000000000000000000000000
43333333333333ddddddddddddd99800f000fcbbb000bb0a0c066e66ee6eeeeeeeee8eeeee8eeeee6c06ff000000cccffcccc0a0000000000000000000000000
3333333333d333d33ddddddd9d9967006ee6f0cbb000cccb0f666eee6eee6eee88ee8e88eeeeee0cf0066c000000ccfcccccbbb0000000000000000000000000
33333333333ddd333d3dddddd9d8000000e0c000a70000cf66666ee666066e8eee88888eeeee6e00c0bff0a000ab00000bcccba7000000000000000000000000
3333333333dd3d33dd90d9ddddd907e00e8fca00070000cff6f66f66e60000eeeeee8e888eee0a000700ca00070aa00000bbb000000000000000000000000000
333333333d3dddd99dce9899d999000e888000000700000f6f00ff0666f0b6eeee8888888e8ee600000bb0000000000000bbba00000000000000000000000000
33333d3d0d3dd3d60f07ec999d99080888e00000000a00cffcb0000c600c00b0e8e8e888888ee60000aa00000000000000bbba70070000000000000000000000
3333db3d0d33ddd96000088999d99889880600000000bcccffcb000bf000007e8eee88888888e60000000000000000007abbbaaa770000000000000000000000
3333de00000ddd09000700009d999988988e0000000bbcccb0ab0007cf00000888e88888eeeee0e00ba0000a00000000000bbaaaa00000000000007070000000
33ddd80000ddd900600bc60099999999998e000007acccccc00000ab0c70fee88e88888888e8eee60f0a000bb07000000000aaa7000000000000007a00000000
3d3d9b000a00d90800f0bfe8999899998980b00c000ba00a000000000070b0ee888888888ee8eeee0666fc0baaa700000007aa000000000000000007a7700000
3dddce0ff099dd9a00f60e88998998888888ee000a00000000000000a000006e88e88888888888eee66ff00000000000000777700000000000000000aab00700
dd3d9ec6e886f99e00f6eee008a9e88988888e0e00007000000aaaba7000000088888ee8888e88eeee70b000000000000007a0000000000000000007aaaaaa00
0d9dd7cb6eef0a8b60b0eee0000b7889888888ee6c00000000000bc00000000ae8888888888e8ef60600000000000000000770000000000000007000baaaaa00
099998ee0a0b00eee6cbc0ccb000008988888fb7ff000000000000cb000000e88888888888e886f0070007700000000000007000000000000000bcbbbabaa7a0
8800c8e8ef0066eeee0ab000000700a88888e0007c000000000000c000006ee88888888888888e000baa0b00000000000000000000000000a0bbcbbbbb7aaaa7
8efb660e66f000006e60fa07b07bfee8888eb0000bb0000000000cffbcb606888888888888888e700000c000000000000000000000000000bbccccbbb0007777
0000fabfbaffb0c0f66f00abcc00008e888ee0000a070000000000fff6e8ee88888888888888880e06ff000000000000000000000770000007cfcb0070000077

