complex_meta={
 __add=function(a,b)
  min_length=min(#a.x,#b.x)
  local newx={}
  local newy={}
  if #a.x > min_length then
   for i=#a.x,min_length+1,-1 do
    newx[i]=a.x[i]
    newy[i]=a.y[i]
   end
  end
  if #b.x > min_length then
   for i=#b.x,min_length+1,-1 do
    newx[i]=b.x[i]
    newy[i]=b.y[i]
   end
  end
  ccarryx=0
  ccarryy=0
  for i=min_length,1,-1 do
   cresx=a.x[i]+b.x[i]+ccarryx
   // if they have matching signs and the result does not, reverse the sign on the result and carry
   if ( ( (~(a.x[i] ^^ b.x[i]) ) & 0x8000) == 0x8000) and ( ( (cresx ^^ a.x[i]) & 0x8000) == 0x8000) then
    cresx=cresx ^^ 0x8000
    if cresx < 0 then
     ccarryx=0x8000.0001
    else
     ccarryx=0x0000.0001
    end
   end
   newx[i]=cresx

   cresy=a.y[i]+b.y[i]+ccarryy
   // copied from above
   // if they have matching signs and the result does not, reverse the sign on the result and carry
   if ( ( (~(a.y[i] ^^ b.y[i]) ) & 0x8000) == 0x8000) and ( ( (cresy ^^ a.y[i]) & 0x8000) == 0x8000) then
    cresy=cresy ^^ 0x8000
    if cresy < 0 then
     ccarryy=0x8000.0001
    else
     ccarryy=0x0000.0001
    end
   end
   newy[i]=cresy
  end
  ctemp={x=newx, y=newy}
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

//x and y are arrays where each sequential index holds a number
//0x0000.0000 - 32 bits, but the leftmost bit is for negative
//if you want to store 0x0.00001 then you need an additional number
//so that would end up being 0x0.0000 + 0x4000.0000*(1/2)^(7*(n-1))
//where n is the index, in this case 2
function complex(x,y)
 local obj={x=x,y=y}
 setmetatable(obj,complex_meta)
 return obj
end
