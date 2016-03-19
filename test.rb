
funcs=["@sueldo=3300" , "@sueldo_integral=@sueldo/2",]


expr="";
funcs.each do |s|
expr+= s + "\n";
end

instance_eval(expr)
puts @sueldo
puts @sueldo_integral
