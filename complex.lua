ctemp=nil
complex_meta={
 __add=function(a,b)
  ctemp={x=a.x+b.x, y=a.y+b.y}
  setmetatable(ctemp,complex_meta)
  return ctemp
 end,
 __sub=function(a,b)
  ctemp={x=a.x-b.x, y=a.y-b.y}
  setmetatable(ctemp,complex_meta)
  return ctemp
 end,
 __mul=function(a,b)
  //a.x*b.x + a.x*b.y*i + a.y*b.x*i + a.y*b.y*i^2
  //x=a.x*b.y - a.y*b.y
  //y=a.x+b.y + a.y*b.x
  ctemp={
   x=a.x*b.x - a.y*b.y,
   y=a.x*b.y + a.y*b.x
  }
  setmetatable(ctemp,complex_meta)
  return ctemp
 end,
 __div=function(a,b)
  local denom=b.x*b.x+b.y*b.y
  ctemp={
   x=(a.x*b.x+a.y*b.y)/denom,
   y=(b.x*a.y-a.x*b.y)/denom
  }
  setmetatable(ctemp,complex_meta)
  return ctemp
 end,
 __len=function(a)
  return abs(a.x)+abs(a.y)
 end
}

function complex(x,y)
 local obj={x=x,y=y}
 setmetatable(obj,complex_meta)
 return obj
end
