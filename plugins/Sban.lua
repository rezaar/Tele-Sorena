do
    
local function superban_user(user_id, chat_id)
  -- Save to redis
  local hash =  'superbanned:'..user_id
  redis:set(hash, true)
  local hash =  'gbanned'
  redis:sadd(hash, user_id)
  -- Kick from chat
  kick_user(user_id,chat_id)
end

local function is_super_banned(user_id)
    local hash = 'superbanned:'..user_id
    local superbanned = redis:get(hash)
    return superbanned or false
end

local function unsuperban_user(user_id)
  local hash =  'superbanned:'..user_id
  redis:del(hash)
  local hash =  'gbanned'
  redis:srem(hash, user_id)
end

local function action_by_reply(extra, success, result)
  local msg = result
  local chat_id = msg.to.id
  local user_id = msg.from.id
  local chat = 'chat#id'..msg.to.id
  local user = 'user#id'..msg.from.id
  if result.to.type == 'chat' and not is_sudo(msg) then
    if extra.match == 'sban' then
        superban_user(user_id, chat_id)
        send_msg(chat, 'user '..user_id..' hammered', ok_cb, true)
    elseif extra.match == 'unsban' then
      unsuperban_user(user_id)
      send_msg(chat, 'user '..user_id..' unhammered', ok_cb, true)
    end
  else
    return 'Use This in Your Groups'
  end
end

local function resolve_username(extra, success, result)
  if success == 1 then
    local msg = extra.msg
    local chat_id = msg.to.id
    local user_id = result.id
    local chat = 'chat#id'..msg.to.id
    local user = 'user#id'..result.id
    if msg.to.type == 'chat' then
      -- check if sudo users
      local is_sudoers = false
      for v,username in pairs(_config.sudo_users) do
        if username == user_id then
          is_sudoers = true
        end
      end
      -- if not sudo users
      if not is_sudoers then
        if extra.match == 'sban' then
          superban_user(user_id, chat_id)
          send_msg(chat, 'user @'..result.username..' hammered', ok_cb, true)
        elseif extra.match == 'unsban' then
          unsuperban_user(user_id)
          send_msg(chat, 'user @'..result.username..' unhammered', ok_cb, true)
        end
      end
    else
      return 'Use This in Your Groups.'
    end
  end
end

local function pre_process(msg)

  local user_id = msg.from.id
  local chat_id = msg.to.id
  local chat = 'chat#id'..chat_id
  local user = 'user#id'..user_id


  -- SERVICE MESSAGE
  if msg.action and msg.action.type then
    local action = msg.action.type
    -- Check if banned user joins chat
    if action == 'chat_add_user' or action == 'chat_add_user_link' then
      local user_id
      if msg.action.link_issuer then
        user_id = msg.from.id
      else
	      user_id = msg.action.user.id
      end
      print('Checking invited user '..user_id)
      local superbanned = is_super_banned(user_id)
      if superbanned then
        print('User is superbanned!')
        kick_user(user_id,chat_id)
      end
    end
    -- No further checks
    return msg
  end

  -- BANNED USER TALKING
  if msg.to.type == 'chat' then
    local banned = is_banned(user_id, chat_id)
    if banned then
      print('Banned user talking!')
      ban_user(user_id, chat_id)
      msg.text = ''
    end
  end
  return msg
end

local function run(msg, matches)


  local user_id = matches[2]
  local chat_id = msg.to.id
  local chat = 'chat#id'..msg.to.id
  local user = 'user#id'..msg.to.id

  if msg.to.type == 'chat' and is_admin(msg) then
    if matches[1] == 'sban' then
      if msg.reply_id then
        msgr = get_message(msg.reply_id, action_by_reply, {msg=msg, match=matches[1]})
      elseif string.match(user_id, '^%d+$') then
        superban_user(user_id, chat_id)
        return 'User '..user_id..' hammered'
      elseif string.match(user_id, '^@.+$') then
        local user = string.gsub(user_id, '@', '')
        msgr = res_user(user, resolve_username, {msg=msg, match=matches[1]})
      end
    elseif matches[1] == 'unsban' then
      if msg.reply_id then
        msgr = get_message(msg.reply_id, action_by_reply, {msg=msg, match=matches[1]})
      elseif string.match(user_id, '^%d+$') then
        unsuperban_user(user_id)
        return 'User '..user_id..' unhammered'
      elseif string.match(user_id, '^@.+$') then
        local user = string.gsub(user_id, '@', '')
        msgr = res_user(user, resolve_username, {msg=msg, match=matches[1]})
      end
    end 
  end  
end

return {
  description = "Plugin to manage bans, kicks and white/black lists.",
  patterns = {
    "^!(sban)$",
    "^!(sban) (.*)$",
    "^!(unsban)$",
    "^!(unsban) (.*)$",
  },
  run = run,
  pre_process = pre_process,
}

end
