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
   // when they have matching signs and the result does not, reverse the sign on the result and carry
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
   // when they have matching signs and the result does not, reverse the sign on the result and carry
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
  ctemp.max=a.max
  if b.max then
   ctemp.max=min(b.max,ctemp.max)
  end
  setmetatable(ctemp,complex_meta)
  return ctemp
 end,
 __mul=function(a,b)
  ctemp={x={},y={}}

  combined_max=#a.x+#b.x-1 //max length it can be given the inputs

  if a.max then
   ctemp.max=a.max
  end

  if b.max then
   ctemp.max=min(b.max,ctemp.max)
  end

  if ctemp.max and ctemp.max < combined_max then
   combined_max=ctemp.max
  end

  for i=1,combined_max do
   add(ctemp.x,0)
   add(ctemp.y,0)
  end
  setmetatable(ctemp,complex_meta)

  local adder,level
  local tempa,tempb,tempres,sign
  local mult_carry=function(a,b,dim,negative)
   tmpres= a*b
   if negative then
    tmpres*=-1
   end
   adder[dim][level]=tmpres
   if tmpres >= 0 then
    sign=1
   else
    sign=-1
   end

   a=abs(a)
   b=abs(b)

   tempa=(a<<8)&0x7fff.ffff
   tempb=(b<<8)&0x7fff.ffff
   tempres=tempa*tempb //sign is 0

   //carry right
   adder[dim][level+1]= ((tempres<<16)>>>1)*sign

   if level>1 then
    tempa=a>>>8
    tempb=b>>>8
    tempres=tempa*tempb //sign is 0

    //carry left
    adder[dim][level-1]= (tempres>>>16)*sign
   end

   ctemp+=adder

   adder[dim][level-1]=0
   adder[dim][level]=0
   adder[dim][level+1]=0
  end

  local ax,ay,bx,by
  local res
  //TODO - a more efficient version of this could be done with squaring:
  // most of these are going to be mirrored across the diagonal
  for ai=1,#a.x do
   for bi=1,#b.x do
    level=ai+bi-1
    if level <= combined_max then
     ax=a.x[ai]
     ay=a.y[ai]
     bx=b.x[bi]
     by=b.y[bi]

     adder={x={},y={}}
     for i=1,level+1 do
      add(adder.x,0)
      add(adder.y,0)
     end
     //catchme=true
     // ax*bx (-> x)
     mult_carry(ax,bx,"x")

     // ax*by (-> y)
     mult_carry(ax,by,"y")

     // ay*bx (-> y)
     mult_carry(ay,bx,"y")

     // ay*by (flip sign -> x)
     mult_carry(ay,by,"x",true)
    end
   end
  end

  return ctemp
 end,
 __len=function(a)
  return abs(a.x[1])+abs(a.y[1])
 end
}

//x and y are arrays where each sequential index holds a number
//0x0000.0000 - 32 bits, but the leftmost bit is for negative
//if you want to store 0x0.00001 then you need an additional number
//so that would end up being 0x0.0000 + 0x4000.0000*(1/2)^(7*(n-1))
//where n is the index, in this case 2
function complex(x,y,max_level)
 local obj={x=x,y=y,max=max_level}
 setmetatable(obj,complex_meta)
 return obj
end
