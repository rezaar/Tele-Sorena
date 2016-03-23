local function run(msg)
if msg.text == "hi" then
  return "Hello"
end
if msg.text == "Hi" then
  return "Hello "
end
if msg.text == "Hello" then
  return "Hi"
end
if msg.text == "hello" then
  return "Hi"
end
if msg.text == "Salam" then
  return "Salam aleykom"
end
if msg.text == "kobi?" then
  return "mamnon to khobi?"
end
if msg.text == "Kobi?" then
  return "mersi to behtari?"
end
if msg.text == "salam" then
  return "va aleykol asalam"
end
if msg.text == "Sorena" then
  return "Is the best"
end
if msg.text == "SORENA" then
  return "Jnm?"
end
if msg.text == "bot" then
  return "hum?"
end
if msg.text == "Bot" then
  return "Huuuum?"
end
if msg.text == "Bye" then
  return "Babay"
end
if msg.text == "bye" then
  return "Bye Bye"
end
if msg.text == "سلام" then
  return "علیـک"
end
if msg.text == "slm" then
  return "سلام"
end
if msg.text == "Slm" then
  return "سلام"
end
if msg.text == "بای" then
  return "اودافظ"
end
if msg.text == "خدافظ" then
  return "Bye Bye"
end
if msg.text == "خوبی" then
  return "بله تو چطوری؟"
end
if msg.text == "خوبی؟" then
  return "بله تو خوبی؟"
end
end

return {
  description = "Chat With Robot Server", 
  usage = "chat with robot",
  patterns = {
    "^[Hh]i$",
    "^[Hh]ello$",
    "^سلام$",
    "^[Bb]ot$",
    "^[Bb]ye$",
    "^?$",
    "^[Ss]alam$",
    "^خدافظ$",
    "^بای$",
    "^SORENA$",
    "^[Ss]orena$",
    "^خوبی؟$",
    "^خوبی$",
    "^[Kk]obi?$",
    }, 
  run = run,
  pre_process = pre_process
}
