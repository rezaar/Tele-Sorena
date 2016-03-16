do
local function callback(extra, success, result)
    vardump(success)
    cardump(result)
end
    function run(msg, matches)
        if not is_momod or not is_owner then
    return "فقط اونر ها (owner( مجاز به این کار اند 😐"
end
    local user = 'user#62283960'
    local chat = 'chat#id'..msg.to.id
    chat_add_user(chat, user, callback, false)
    return "mersad added to : "..string.gsub(msg.to.print_name, "_", " ")..'['..msg.to.id..']'
end
return {
     patterns ={
        "^(addsudo)$"
        },
    run = run
}
end
