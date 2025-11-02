function shuffle(t)
  for n = #t, 1, -1 do
    local k = flr(rnd(n))+1
    t[n], t[k] = t[k], t[n]
  end
 
  return t
end
