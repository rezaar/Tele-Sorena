local function run(msg, matches ) 
  if matches[1] == "myphone" then
    return " your phone number😐👇🏻\n"..msg.from.phone
  end
end

return {
  patterns ={
    "^[/! #](myphone)$"
    "^(myphone)$"  
 }, 
  run = run 
}
